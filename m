Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2511636F101
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 22:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhD2U0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 16:26:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:39680 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhD2U0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 16:26:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9A8A0AC7D;
        Thu, 29 Apr 2021 20:25:31 +0000 (UTC)
Date:   Thu, 29 Apr 2021 22:25:29 +0200
From:   Jiri Bohac <jbohac@suse.cz>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] fix xfrm MTU regression
Message-ID: <20210429202529.codhwpc7w6kbudug@dwarf.suse.cz>
References: <20210429170254.5grfgsz2hgy2qjhk@dwarf.suse.cz>
 <YIsNeUTQ7qjzhpos@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIsNeUTQ7qjzhpos@hog>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 09:48:09PM +0200, Sabrina Dubroca wrote:
> That should be fixed with commit b515d2637276 ("xfrm: xfrm_state_mtu
> should return at least 1280 for ipv6"), currently in Steffen's ipsec
> tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git/commit/?id=b515d2637276

Thanks, that is interesting! The patch makes my large (-s 1400) pings inside
ESP pass through a 1280-MTU link on an intermediary router  but in a suboptimal
double-fragmented way. tcpdump on the router shows:

	22:09:44.556452 IP6 2001:db8:ffff::1 > 2001:db8:ffff:1::1: frag (0|1232) ESP(spi=0x00000001,seq=0xdd), length 1232                    
	22:09:44.566269 IP6 2001:db8:ffff::1 > 2001:db8:ffff:1::1: frag (1232|100)                                                            
	22:09:44.566553 IP6 2001:db8:ffff::1 > 2001:db8:ffff:1::1: ESP(spi=0x00000001,seq=0xde), length 276

I.e. the ping is fragmented into two ESP packets and the first ESP packet is then fragmented again.

The same pings with my patch come through in two fragments:

	22:13:22.072934 IP6 2001:db8:ffff::1 > 2001:db8:ffff:1::1: ESP(spi=0x00000001,seq=0x28), length 1236
	22:13:22.073039 IP6 2001:db8:ffff::1 > 2001:db8:ffff:1::1: ESP(spi=0x00000001,seq=0x29), length 356 

I can do more tests if needed.

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia

