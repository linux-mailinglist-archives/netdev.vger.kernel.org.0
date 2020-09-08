Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25E4260DE1
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 10:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbgIHIq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 04:46:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729775AbgIHIqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 04:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599554782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4joEUBT7SaaHzNBA3jfKAT1e8ocC7+4gm+izXspXMHc=;
        b=JKJCE8aW9Nmr+8u434N31H5s76qYRymJBClErL+jnb6nnMaBDW3JZpHp3KpoeiadJMKGHo
        9xjK3enPAxVUCJ1BffRUJB2Jpyh7/pq0mcCVlgWW8QdY0LaspOBHxDN0tj6Gf7EyeItQAn
        ML39Q92nPNKYwLfcIgS4HZJcE7dwMhk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-B7gekK4PO8KW5V62l_uEug-1; Tue, 08 Sep 2020 04:46:17 -0400
X-MC-Unique: B7gekK4PO8KW5V62l_uEug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48B5980EDB0;
        Tue,  8 Sep 2020 08:46:16 +0000 (UTC)
Received: from ovpn-114-216.ams2.redhat.com (ovpn-114-216.ams2.redhat.com [10.36.114.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F028F7E438;
        Tue,  8 Sep 2020 08:46:14 +0000 (UTC)
Message-ID: <f13eaa33c4f73bce9bdcf08b072aeaf23b0551d5.camel@redhat.com>
Subject: Re: [PATCH] net/sock: don't drop udp packets if udp_mem[2] not
 reached
From:   Paolo Abeni <pabeni@redhat.com>
To:     dust.li@linux.alibaba.com,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
Date:   Tue, 08 Sep 2020 10:46:13 +0200
In-Reply-To: <20200908031506.GC56680@linux.alibaba.com>
References: <20200907144435.43165-1-dust.li@linux.alibaba.com>
         <428dae2552915c42b9144d7489fd912493433c1e.camel@redhat.com>
         <20200908031506.GC56680@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2020-09-08 at 11:15 +0800, dust.li wrote:
> Actually, with more udp sockets, I can always make it large
> enough to exceed udp_mem[0], and drop packets before udp_mem[1]
> and udp_mem[2].

Sure, but with enough sockets you can also exceeeds any limits ;).

> diff --git a/net/core/sock.c b/net/core/sock.c
> index 6c5c6b18eff4..fed8211d8dbe 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2648,6 +2648,12 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>                                  atomic_read(&sk->sk_rmem_alloc) +
>                                  sk->sk_forward_alloc))
>                         return 1;
> +       } else {
> +               /* for prots without memory_pressure callbacks, we should not
> +                * drop until hard limit reached
> +                */
> +               if (allocated <= sk_prot_mem_limits(sk, 2))
> +                       return 1;

At this point, the above condition is always true, due to an earlier
check. Additionally, accepting any value below udp_mem[2] would make
the previous checks to allow a minimum per socket memory useless.

You can obtain the same result setting udp_mem[0] = udp_mem[2], without
any kernel change. 

But with this change applied you can't guarantee anymore a minimum per
socket amount of memory.

I think you are possibly mislead by your own comment: the point is that
we should never allow allocation above the hard limit, but the protocol
is allowed to drop as soon as the memory allocated raises above the
lower limit.

Note that the current behavior is correctly documented
in Documentation/networking/ip-sysctl.rst.

Your problem must be solved in another way e.g. raising udp_mem[0] -
and keeping udp_mem[2] above that value.

Cheers,

Paolo

