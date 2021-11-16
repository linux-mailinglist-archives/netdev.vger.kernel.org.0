Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D047453798
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhKPQhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:37:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233936AbhKPQg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 11:36:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637080439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=89B3KAajPsnmRgt1eJkzLJIZzPXyMcrglgmWMTrg9Xs=;
        b=G6SZH0P/DPhZ7zO3/QpuClJUb6HQOwTDziJ2ZzHg1FNUPfC9KLlrVzF5n4Iuog+nssjP4/
        n29R8wOIaSAkXrTqP40GrDXDNDqGgLczrbRZwW726lPK4QWfi0mUch1gFeAg+cdKpGd86Z
        M8eZRiIKb6NN4ZF1jrsL0yosVdEuZHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-LB8b4PKZMCSjCNK4782rCQ-1; Tue, 16 Nov 2021 11:33:55 -0500
X-MC-Unique: LB8b4PKZMCSjCNK4782rCQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DB971922025;
        Tue, 16 Nov 2021 16:33:54 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21F5D60D30;
        Tue, 16 Nov 2021 16:33:54 +0000 (UTC)
Date:   Tue, 16 Nov 2021 17:33:52 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Cc:     Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: "AVX2-based lookup implementation" has broken ebtables
 --among-src
Message-ID: <20211116173352.1a5ff66a@elisabeth>
In-Reply-To: <d35db9d6-0727-1296-fa78-4efeadf3319c@virtuozzo.com>
References: <d35db9d6-0727-1296-fa78-4efeadf3319c@virtuozzo.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Adding netfilter-devel]

Hi Nikita,

On Tue, 16 Nov 2021 11:51:01 +0300
Nikita Yushchenko <nikita.yushchenko@virtuozzo.com> wrote:

> Hello Stefano.
> 
> I've found that nftables rule added by
> 
> # ebtables -A INPUT --among-src 8:0:27:40:f7:9=192.168.56.10 -j log
> 
> does not match packets on kernel 5.14 and on current mainline.
> Although it matched correctly on kernel 4.18
> 
> I've bisected this issue. It was introduced by your commit 7400b063969b ("nft_set_pipapo: Introduce 
> AVX2-based lookup implementation") from 5.7 development cycle.
> 
> The nftables rule created by the above command uses concatenation:
> 
> # nft list chain bridge filter INPUT
> table bridge filter {
>          chain INPUT {
>                  type filter hook input priority filter; policy accept;
>                  ether saddr . ip saddr { 08:00:27:40:f7:09 . 192.168.56.10 } counter packets 0 bytes 0 
> log level notice flags ether
>          }
> }
> 
> Looks like the AVX2-based lookup does not process this correctly.

Thanks for bisecting and reporting this! I'm looking into it now, I
might be a bit slow as I'm currently traveling.

If you need a quick workaround, by the way, defining a "ether . ip"
set without the 'interval' flag and using a reference to it from the
nft rule will cause a switch to the nft_hash back-end (which presumably
doesn't have the same issue), see also:

	https://wiki.nftables.org/wiki-nftables/index.php/Portal:DeveloperDocs/set_internals

-- 
Stefano

