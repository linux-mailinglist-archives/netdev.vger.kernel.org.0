Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F58C4AF2E4
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiBINgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiBINgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:22 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4BC8C061355;
        Wed,  9 Feb 2022 05:36:24 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E5A54601CB;
        Wed,  9 Feb 2022 14:36:12 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 01/14] netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY
Date:   Wed,  9 Feb 2022 14:36:03 +0100
Message-Id: <20220209133616.165104-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209133616.165104-1-pablo@netfilter.org>
References: <20220209133616.165104-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Mitchell <kevmitch@arista.com>

The udp_error function verifies the checksum of incoming UDP packets if
one is set. This has the desirable side effect of setting skb->ip_summed
to CHECKSUM_COMPLETE, signalling that this verification need not be
repeated further up the stack.

Conversely, when the UDP checksum is empty, which is perfectly legal (at least
inside IPv4), udp_error previously left no trace that the checksum had been
deemed acceptable.

This was a problem in particular for nf_reject_ipv4, which verifies the
checksum in nf_send_unreach() before sending ICMP_DEST_UNREACH. It makes
no accommodation for zero UDP checksums unless they are already marked
as CHECKSUM_UNNECESSARY.

This commit ensures packets with empty UDP checksum are marked as
CHECKSUM_UNNECESSARY, which is explicitly recommended in skbuff.h.

Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_udp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 3b516cffc779..12f793d8fe0c 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -63,8 +63,10 @@ static bool udp_error(struct sk_buff *skb,
 	}
 
 	/* Packet with no checksum */
-	if (!hdr->check)
+	if (!hdr->check) {
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
 		return false;
+	}
 
 	/* Checksum invalid? Ignore.
 	 * We skip checking packets on the outgoing path
-- 
2.30.2

