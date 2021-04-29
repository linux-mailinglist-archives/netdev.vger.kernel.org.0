Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E2236EE84
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 19:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhD2RDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 13:03:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:60470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232724AbhD2RDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 13:03:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1938BAF9C;
        Thu, 29 Apr 2021 17:02:55 +0000 (UTC)
Date:   Thu, 29 Apr 2021 19:02:54 +0200
From:   Jiri Bohac <jbohac@suse.cz>
To:     Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [RFC PATCH] fix xfrm MTU regression
Message-ID: <20210429170254.5grfgsz2hgy2qjhk@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Commit 749439bfac6e1a2932c582e2699f91d329658196 ("ipv6: fix udpv6
sendmsg crash caused by too small MTU") breaks PMTU for xfrm.

A Packet Too Big ICMPv6 message received in response to an ESP
packet will prevent all further communication through the tunnel
if the reported MTU minus the ESP overhead is smaller than 1280.

E.g. in a case of a tunnel-mode ESP with sha256/aes the overhead
is 92 bytes. Receiving a PTB with MTU of 1371 or less will result
in all further packets in the tunnel dropped. A ping through the
tunnel fails with "ping: sendmsg: Invalid argument".

Apparently the MTU on the xfrm route is smaller than 1280 and
fails the check inside ip6_setup_cork() added by 749439bf.

We found this by debugging USGv6/ipv6ready failures. Failing
tests are: "Phase-2 Interoperability Test Scenario IPsec" /
5.3.11 and 5.4.11 (Tunnel Mode: Fragmentation).

Below is my attempt to fix the situation by dropping the MTU
check and instead checking for the underflows described in the
749439bf commit message (without much understanding of the
details!). Does this make sense?:

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4f9ebcf7f6..8af6adb42c85 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1402,8 +1402,6 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 		if (np->frag_size)
 			mtu = np->frag_size;
 	}
-	if (mtu < IPV6_MIN_MTU)
-		return -EINVAL;
 	cork->base.fragsize = mtu;
 	cork->base.gso_size = ipc6->gso_size;
 	cork->base.tx_flags = 0;
@@ -1465,6 +1463,11 @@ static int __ip6_append_data(struct sock *sk,
 
 	fragheaderlen = sizeof(struct ipv6hdr) + rt->rt6i_nfheader_len +
 			(opt ? opt->opt_nflen : 0);
+
+	if (mtu < fragheaderlen ||
+	    ((mtu - fragheaderlen) & ~7) + fragheaderlen < sizeof(struct frag_hdr))
+		goto emsgsize;
+
 	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
 		     sizeof(struct frag_hdr);
 

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia

