Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6B5493726
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 10:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240025AbiASJWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 04:22:55 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:56962 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353032AbiASJWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 04:22:54 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2F1941F384;
        Wed, 19 Jan 2022 09:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642584173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a/XYmC+G3cYxoHtLK2gUJLpRJwEd33N2HoYF1S2/AZA=;
        b=dfggs5uJZRXuQb2sLfk0bvUnvhqwVnN+t/e8gWwOm4TYEdk28sYqEwYkJhU5AaaEH6mivp
        J41YJjdpz0jWWBQ0ZNf1ZPCNlts+Pmi+knukT1mrJXy9DdtUEFRJFtq5sj/8Ph89G+aAMc
        gmwcvLl6Lsc4FQ4HTJ6jVmUkgmMltYM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642584173;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a/XYmC+G3cYxoHtLK2gUJLpRJwEd33N2HoYF1S2/AZA=;
        b=f8Ru8FX7DHmUUzpxaI8jgCHdtvMfBdz4uPuFEZGgZbo4JLdgZmj6EIuXTn5ChYAkWhHTOX
        o69IUSG4DHUJgGAw==
Received: from localhost (dwarf.suse.cz [10.100.12.32])
        by relay2.suse.de (Postfix) with ESMTP id 25BFCA3B87;
        Wed, 19 Jan 2022 09:22:53 +0000 (UTC)
Date:   Wed, 19 Jan 2022 10:22:53 +0100
From:   Jiri Bohac <jbohac@suse.cz>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] xfrm: fix MTU regression
Message-ID: <20220119092253.osio2qsm3dfi6otz@dwarf.suse.cz>
References: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
 <20220114174058.rqhtuwpfhq6czldn@dwarf.suse.cz>
 <20220119073519.GJ1223722@gauss3.secunet.de>
 <20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Commit b515d2637276a3810d6595e10ab02c13bfd0b63a ("xfrm:
xfrm_state_mtu should return at least 1280 for ipv6") attempted
to fix this but caused another regression in TCP MSS calculations
and had to be reverted.

The patch below fixes the situation by dropping the MTU
check and instead checking for the underflows described in the
749439bf commit message.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Fixes: 749439bfac6e ("ipv6: fix udpv6 sendmsg crash caused by too small MTU") 

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4f9ebcf7f6..171eb4ec1e67 100644
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
@@ -1465,8 +1463,6 @@ static int __ip6_append_data(struct sock *sk,
 
 	fragheaderlen = sizeof(struct ipv6hdr) + rt->rt6i_nfheader_len +
 			(opt ? opt->opt_nflen : 0);
-	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
-		     sizeof(struct frag_hdr);
 
 	headersize = sizeof(struct ipv6hdr) +
 		     (opt ? opt->opt_flen + opt->opt_nflen : 0) +
@@ -1474,6 +1470,13 @@ static int __ip6_append_data(struct sock *sk,
 		      sizeof(struct frag_hdr) : 0) +
 		     rt->rt6i_nfheader_len;
 
+	if (mtu < fragheaderlen ||
+	    ((mtu - fragheaderlen) & ~7) + fragheaderlen < sizeof(struct frag_hdr))
+		goto emsgsize;
+
+	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
+		     sizeof(struct frag_hdr);
+
 	/* as per RFC 7112 section 5, the entire IPv6 Header Chain must fit
 	 * the first fragment
 	 */

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia
