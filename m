Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483902C3908
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 07:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgKYGUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 01:20:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgKYGUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 01:20:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606285233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hzf8L+pJkmJC6kuPctTHWalVfjiH6jJR7fCpq2GAvzk=;
        b=TADp4melm1A32Mr2mey/51KceMl6SVCZiMupcyEDf2j0h2DFKpf+4f8EAdelrL9nMm4wlC
        ctJ3yB8agvPXCZ63nLJxlLbrUaYgkrp0+VHNk2YilFvqRgXMf/g9mhh2c/l2CwhCUCtq36
        dyPBGjGg4Q6BI81Tt2HMVsUmxnxEsXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-s7V2aL5HN0Sj_o7CAHGE0w-1; Wed, 25 Nov 2020 01:20:28 -0500
X-MC-Unique: s7V2aL5HN0Sj_o7CAHGE0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCB6F8144E5;
        Wed, 25 Nov 2020 06:20:26 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 940005D9C0;
        Wed, 25 Nov 2020 06:20:19 +0000 (UTC)
Subject: Re: netconsole deadlock with virtnet
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit@kernel.org>, Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        netdev <netdev@vger.kernel.org>
References: <20201117102341.GR47002@unreal>
 <20201117093325.78f1486d@gandalf.local.home>
 <X7SK9l0oZ+RTivwF@jagdpanzerIV.localdomain>
 <X7SRxB6C+9Bm+r4q@jagdpanzerIV.localdomain>
 <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
 <20201118091257.2ee6757a@gandalf.local.home> <20201123110855.GD3159@unreal>
 <20201123093128.701cf81b@gandalf.local.home>
 <20201123105252.1c295138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201123140934.38748be3@gandalf.local.home>
 <20201123112130.759b9487@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1133f1a4-6772-8aa3-41dd-edbc1ee76cee@redhat.com>
 <20201124093137.48d1e603@gandalf.local.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fb001549-a4d4-b758-03cf-387eaf81e389@redhat.com>
Date:   Wed, 25 Nov 2020 14:20:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201124093137.48d1e603@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/24 下午10:31, Steven Rostedt wrote:
> On Tue, 24 Nov 2020 11:22:03 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> Btw, have a quick search, there are several other drivers that uses tx
>> lock in the tx NAPI.
> tx NAPI is not the issue. The issue is that write_msg() (in netconsole.c)
> calls this polling logic with the target_list_lock held.


But in the tx NAPI poll it tries to lock TX instead of using trylock.


>
> Are those other drivers called by netconsole? If not, then this is unique
> to virtio-net.


I think the answer is yes, since net console is not disabled in the codes.

Thanks


>
> -- Steve
>

