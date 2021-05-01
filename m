Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE5F3706D1
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 12:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhEAKYm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 1 May 2021 06:24:42 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:30389 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231819AbhEAKYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 06:24:42 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-0J3P795XM22u2duRP-EGfw-1; Sat, 01 May 2021 06:23:46 -0400
X-MC-Unique: 0J3P795XM22u2duRP-EGfw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03F2B1898298;
        Sat,  1 May 2021 10:23:45 +0000 (UTC)
Received: from hog (unknown [10.40.192.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C15C46C32D;
        Sat,  1 May 2021 10:23:42 +0000 (UTC)
Date:   Sat, 1 May 2021 12:23:40 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Jiri Bohac <jbohac@suse.cz>
Cc:     Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] fix xfrm MTU regression
Message-ID: <YI0sLJ4rOAULgojz@hog>
References: <20210429170254.5grfgsz2hgy2qjhk@dwarf.suse.cz>
 <YIsNeUTQ7qjzhpos@hog>
 <20210429202529.codhwpc7w6kbudug@dwarf.suse.cz>
MIME-Version: 1.0
In-Reply-To: <20210429202529.codhwpc7w6kbudug@dwarf.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-04-29, 22:25:29 +0200, Jiri Bohac wrote:
> On Thu, Apr 29, 2021 at 09:48:09PM +0200, Sabrina Dubroca wrote:
> > That should be fixed with commit b515d2637276 ("xfrm: xfrm_state_mtu
> > should return at least 1280 for ipv6"), currently in Steffen's ipsec
> > tree:
> > https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git/commit/?id=b515d2637276
> 
> Thanks, that is interesting! The patch makes my large (-s 1400) pings inside
> ESP pass through a 1280-MTU link on an intermediary router  but in a suboptimal
> double-fragmented way. tcpdump on the router shows:
> 
> 	22:09:44.556452 IP6 2001:db8:ffff::1 > 2001:db8:ffff:1::1: frag (0|1232) ESP(spi=0x00000001,seq=0xdd), length 1232                    
> 	22:09:44.566269 IP6 2001:db8:ffff::1 > 2001:db8:ffff:1::1: frag (1232|100)                                                            
> 	22:09:44.566553 IP6 2001:db8:ffff::1 > 2001:db8:ffff:1::1: ESP(spi=0x00000001,seq=0xde), length 276
> 
> I.e. the ping is fragmented into two ESP packets and the first ESP packet is then fragmented again.

It's a bit ugly, but I don't think we can do any better. We're going
through the stack twice in tunnel mode. The first pass (before xfrm)
we fragment according to the PMTU (adjusted to IPV6_MIN_MTU, because
MTUs lower than that are illegal in IPv6). The second time (after
xfrm), the first ESP packet is too big so we fragment it. This
behavior is consistent with a vti device running over a network with
MTU=1280 (which doesn't seem to work without my patch).

In transport mode, we're only going through the stack once, so we
don't see this double fragmentation.

I think my patch is correct, because without it we have IPv6 dsts
going around the kernel with an associated MTU smaller than
IPV6_MIN_MTU.

-- 
Sabrina

