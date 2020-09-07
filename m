Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF1D260219
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbgIGRTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:19:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730690AbgIGRS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 13:18:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599499135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aqxls+vd0L6OoeYJ1sv9momKp6wV4VzyFbepTInsujU=;
        b=IXOvQOo+q94HWDQXonpgq4QXIRjdtfYW+6LdbZxILMttscb991ZFLeizHc4AkfOoZX3B6b
        k6XrLtgJwBwo4sB1gBIZh1d7eKKbElOuKqbJ4GIVpKJpvfpGWJTk0fh//8xwDFDqkdssKA
        rHbwHqvjAQJ4m/wXmyr9jMKndEZgWIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-jEPQOEf6NJK-FXrVFj2dJg-1; Mon, 07 Sep 2020 13:18:51 -0400
X-MC-Unique: jEPQOEf6NJK-FXrVFj2dJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EB35807335;
        Mon,  7 Sep 2020 17:18:50 +0000 (UTC)
Received: from ovpn-114-245.ams2.redhat.com (ovpn-114-245.ams2.redhat.com [10.36.114.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AC5B5D9DD;
        Mon,  7 Sep 2020 17:18:49 +0000 (UTC)
Message-ID: <428dae2552915c42b9144d7489fd912493433c1e.camel@redhat.com>
Subject: Re: [PATCH] net/sock: don't drop udp packets if udp_mem[2] not
 reached
From:   Paolo Abeni <pabeni@redhat.com>
To:     Dust Li <dust.li@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
Date:   Mon, 07 Sep 2020 19:18:48 +0200
In-Reply-To: <20200907144435.43165-1-dust.li@linux.alibaba.com>
References: <20200907144435.43165-1-dust.li@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 2020-09-07 at 22:44 +0800, Dust Li wrote:
> We encoutered udp packets drop under a pretty low pressure
> with net.ipv4.udp_mem[0] set to a small value (4096).
> 
> After some tracing and debugging, we found that for udp
> protocol, __sk_mem_raise_allocated() will possiblly drop
> packets if:
>   udp_mem[0] < udp_prot.memory_allocated < udp_mem[2]
> 
> That's because __sk_mem_raise_allocated() didn't handle
> the above condition for protocols like udp who doesn't
> have sk_has_memory_pressure()
> 
> We can reproduce this with the following condition
> 1. udp_mem[0] is relateive small,
> 2. net.core.rmem_default/max > udp_mem[0] * 4K

This looks like something that could/should be addressed at
configuration level ?!?

udp_mem[0] should accomodate confortably at least a socket.

Cheers,

Paolo

