Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8590F19842E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgC3TWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:22:30 -0400
Received: from correo.us.es ([193.147.175.20]:48524 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728391AbgC3TWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:22:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B189B4989
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03DE8FF6F5
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BA572123979; Mon, 30 Mar 2020 21:21:51 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5741100A69;
        Mon, 30 Mar 2020 21:21:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 21:21:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7C13442EF4E1;
        Mon, 30 Mar 2020 21:21:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 27/28] netfilter: nft_exthdr: fix endianness of tcp option cast
Date:   Mon, 30 Mar 2020 21:21:35 +0200
Message-Id: <20200330192136.230459-28-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330192136.230459-1-pablo@netfilter.org>
References: <20200330192136.230459-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Marinkevich <sergey.marinkevich@eltex-co.ru>

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
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0

