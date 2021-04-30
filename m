Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D5736F560
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 07:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhD3FhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 01:37:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:42464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhD3FhP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 01:37:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1B887B000;
        Fri, 30 Apr 2021 05:36:27 +0000 (UTC)
Date:   Fri, 30 Apr 2021 07:36:26 +0200
From:   Jiri Bohac <jbohac@suse.cz>
To:     Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v2] fix xfrm MTU regression
Message-ID: <20210430053626.uzc4nuubtsbg5vi3@dwarf.suse.cz>
References: <20210429170254.5grfgsz2hgy2qjhk@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429170254.5grfgsz2hgy2qjhk@dwarf.suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 07:02:55PM +0200, Jiri Bohac wrote:
> Below is my attempt to fix the situation by dropping the MTU
> check and instead checking for the underflows described in the
> 749439bf commit message (without much understanding of the
> details!). Does this make sense?:

the first version left headersize uninitialized in the error
path; v2 below fixes this.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
 
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

