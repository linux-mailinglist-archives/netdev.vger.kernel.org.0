Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5221A186506
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 07:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgCPGc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 02:32:56 -0400
Received: from scp8.hosting.reg.ru ([31.31.196.44]:54968 "EHLO
        scp8.hosting.reg.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729593AbgCPGc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 02:32:56 -0400
X-Greylist: delayed 2456 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 02:32:54 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=marinkevich.ru; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ICtt14DdKbzX+OLuDobayzCZUyiOY0nTOBAzHCBfqGE=; b=cCn4gbh0tjfZhaAf2FLyfea68j
        gl+Es6KUTaf5V8E5Fl7F9B8MTUcDsPUPpMOOlHnqm/enLQzYaVC5VvClwbtMPp7LveOEJw4e01gjE
        vfA8m6R7bEw+osghsGWL386vbR3Un5frZtYzIbjk3144DNFPIEFIKVqwPyKfJCbuYld3GOVe0usWJ
        TbWjAN3BWHl7ZLdybrGMTyDqQGfjKVyerzI3oFpmO13zwXJ34UAa8zZ55Rz33Xo0CxWDJYiiC2TrW
        YvR4LI2frniFi99val7SVRMV6MMs2w/UaYr5bBhJo5m26AuSV7dsOKdTk5umPxOfWkraqljQQbYlV
        jiOnX7EA==;
Received: from mail.eltex.org ([92.125.152.58]:46582 helo=GRayJob)
        by scp8.hosting.reg.ru with esmtpa (Exim 4.92)
        (envelope-from <s@marinkevich.ru>)
        id 1jDifM-0002YW-H1; Mon, 16 Mar 2020 08:51:56 +0300
Date:   Mon, 16 Mar 2020 12:51:56 +0700
From:   Sergey Marinkevich <s@marinkevich.ru>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: nft_masq: add range specified flag setting
Message-ID: <20200316055156.GA3822@GRayJob>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - scp8.hosting.reg.ru
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - marinkevich.ru
X-Get-Message-Sender-Via: scp8.hosting.reg.ru: authenticated_id: s@marinkevich.ru
X-Authenticated-Sender: scp8.hosting.reg.ru: s@marinkevich.ru
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With nf_tables it is not possible to use port range for masquerading.
Masquerade statement has option "to [:port-port]" which give no effect
to translation behavior. But it must change source port of packet to
one from ":port-port" range.

My network:

	+-----------------------------+
	|   ROUTER                    |
	|                             |
	|                   Masquerade|
	| 10.0.0.1            1.1.1.1 |
	| +------+           +------+ |
	| | eth1 |           | eth2 | |
	+-+--^---+-----------+---^--+-+
	     |                   |
	     |                   |
	+----v------+     +------v----+
	|           |     |           |
	| 10.0.0.2  |     |  1.1.1.2  |
	|           |     |           |
	|PC1        |     |PC2        |
	+-----------+     +-----------+

For testing i used rule like this:

	rule ip nat POSTROUTING oifname eth2 masquerade to :666

Run netcat for 1.1.1.2 667(UDP) and get dump from PC2:

	15:22:25.591567 a8:f9:4b:aa:08:44 > a8:f9:4b:ac:e7:8f, ethertype IPv4 (0x0800), length 60: 1.1.1.1.34466 > 1.1.1.2.667: UDP, length 1

Address translation works fine, but source port are not belongs to
specified range.

I see in similar source code (i.e. nft_redir.c, nft_nat.c) that
there is setting NF_NAT_RANGE_PROTO_SPECIFIED flag. After adding this,
repeat test for kernel with this patch, and get dump:

	16:16:22.324710 a8:f9:4b:aa:08:44 > a8:f9:4b:ac:e7:8f, ethertype IPv4 (0x0800), length 60: 1.1.1.1.666 > 1.1.1.2.667: UDP, length 1

Now it is works fine.

Signed-off-by: Sergey Marinkevich <s@marinkevich.ru>
---
 net/netfilter/nft_masq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index bc9fd98c5d6d..448376e59074 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -113,6 +113,7 @@ static void nft_masq_ipv4_eval(const struct nft_expr *expr,
 			&regs->data[priv->sreg_proto_min]);
 		range.max_proto.all = (__force __be16)nft_reg_load16(
 			&regs->data[priv->sreg_proto_max]);
+		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 	regs->verdict.code = nf_nat_masquerade_ipv4(pkt->skb, nft_hook(pkt),
 						    &range, nft_out(pkt));
@@ -159,6 +160,7 @@ static void nft_masq_ipv6_eval(const struct nft_expr *expr,
 			&regs->data[priv->sreg_proto_min]);
 		range.max_proto.all = (__force __be16)nft_reg_load16(
 			&regs->data[priv->sreg_proto_max]);
+		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 	regs->verdict.code = nf_nat_masquerade_ipv6(pkt->skb, &range,
 						    nft_out(pkt));
-- 
2.21.0

