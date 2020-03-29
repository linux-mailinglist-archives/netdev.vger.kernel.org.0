Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA7EC196D4A
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 14:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgC2M3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 08:29:18 -0400
Received: from post1.eltex-co.ru ([92.125.152.62]:38968 "EHLO
        post1.eltex-co.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgC2M3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 08:29:17 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2020 08:29:15 EDT
Received: from localhost (localhost [127.0.0.1])
        by post1.eltex-co.ru (Postfix) with ESMTP id E5BBD185077;
        Sun, 29 Mar 2020 19:19:16 +0700 (+07)
X-Virus-Scanned: Debian amavisd-new at eltex-co.ru
Received: from post1.eltex-co.ru ([127.0.0.1])
        by localhost (post1.eltex-co.ru [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8U_9GVjTqY6m; Sun, 29 Mar 2020 19:19:16 +0700 (+07)
Received: from GRayJob (unknown [10.25.24.25])
        by post1.eltex-co.ru (Postfix) with ESMTPA id 4F7EF185058;
        Sun, 29 Mar 2020 19:19:14 +0700 (+07)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=eltex-co.ru; s=mail;
        t=1585484356; bh=AwdvP6tnxI1RjaVHyT/dcov8GrM8x+IaCX7dm9mcDgg=;
        h=Date:From:To:Cc:Subject:From;
        b=I0G76xcpzLGGBaasKfs8OsmBg0PjHs+CRoSbc9s2aDSsJcbR+mjrabbSsyW5qEX5z
         pWK4uhr3MV5W99C27jX+0T/ikBzIQrsdttFa1BIu9lWNFK+DRj2bkMDROIqKPI2U7U
         BEXwTVc9wlUfzbmdbSIefzSEtMzQm5V8WUwv+GYw=
Date:   Sun, 29 Mar 2020 19:19:14 +0700
From:   Sergey Marinkevich <sergey.marinkevich@eltex-co.ru>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_exthdr: fix endianness of tcp option cast
Message-ID: <20200329121914.GA7748@GRayJob>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got a problem on MIPS with Big-Endian is turned on: every time when
NF trying to change TCP MSS it returns because of new.v16 was greater
than old.v16. But real MSS was 1460 and my rule was like this:

	add rule table chain tcp option maxseg size set 1400

And 1400 is lesser that 1460, not greater.

Later I founded that main causer is cast from u32 to __be16.

Debugging:

In example MSS = 1400(HEX: 0x578). Here is representation of each byte
like it is in memory by addresses from left to right(e.g. [0x0 0x1 0x2
0x3]). LE — Little-Endian system, BE — Big-Endian, left column is type.

	     LE               BE
	u32: [78 05 00 00]    [00 00 05 78]

As you can see, u32 representation will be casted to u16 from different
half of 4-byte address range. But actually nf_tables uses registers and
store data of various size. Actually TCP MSS stored in 2 bytes. But
registers are still u32 in definition:

	struct nft_regs {
		union {
			u32			data[20];
			struct nft_verdict	verdict;
		};
	};

So, access like regs->data[priv->sreg] exactly u32. So, according to
table presents above, per-byte representation of stored TCP MSS in
register will be:

	                     LE               BE
	(u32)regs->data[]:   [78 05 00 00]    [05 78 00 00]
	                                       ^^ ^^

We see that register uses just half of u32 and other 2 bytes may be
used for some another data. But in nft_exthdr_tcp_set_eval() it casted
just like u32 -> __be16:

	new.v16 = src

But u32 overfill __be16, so it get 2 low bytes. For clarity draw
one more table(<xx xx> means that bytes will be used for cast).

	                     LE                 BE
	u32:                 [<78 05> 00 00]    [00 00 <05 78>]
	(u32)regs->data[]:   [<78 05> 00 00]    [05 78 <00 00>]

As you can see, for Little-Endian nothing changes, but for Big-endian we
take the wrong half. In my case there is some other data instead of
zeros, so new MSS was wrongly greater.

For shooting this bug I used solution for ports ranges. Applying of this
patch does not affect Little-Endian systems.

Signed-off-by: Sergey Marinkevich <sergey.marinkevich@eltex-co.ru>
---
 net/netfilter/nft_exthdr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a5e8469859e3..07782836fad6 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -228,7 +228,6 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	unsigned int i, optl, tcphdr_len, offset;
 	struct tcphdr *tcph;
 	u8 *opt;
-	u32 src;
 
 	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
 	if (!tcph)
@@ -237,7 +236,6 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	opt = (u8 *)tcph;
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
 		union {
-			u8 octet;
 			__be16 v16;
 			__be32 v32;
 		} old, new;
@@ -259,13 +257,13 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 		if (!tcph)
 			return;
 
-		src = regs->data[priv->sreg];
 		offset = i + priv->offset;
 
 		switch (priv->len) {
 		case 2:
 			old.v16 = get_unaligned((u16 *)(opt + offset));
-			new.v16 = src;
+			new.v16 = (__force __be16)nft_reg_load16(
+				&regs->data[priv->sreg]);
 
 			switch (priv->type) {
 			case TCPOPT_MSS:
@@ -283,7 +281,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 						 old.v16, new.v16, false);
 			break;
 		case 4:
-			new.v32 = src;
+			new.v32 = regs->data[priv->sreg];
 			old.v32 = get_unaligned((u32 *)(opt + offset));
 
 			if (old.v32 == new.v32)
-- 
2.21.0

