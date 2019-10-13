Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B17D538C
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 02:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbfJMAa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 20:30:59 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:51144 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbfJMAax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 20:30:53 -0400
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 7DE911A40556; Sat, 12 Oct 2019 17:30:53 -0700 (PDT)
Date:   Sat, 12 Oct 2019 17:30:53 -0700
From:   Vito Caputo <vcaputo@pengaru.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: core: skbuff: skb_checksum_setup() drop err
Message-ID: <20191013003053.tmdc3hs73ik3asxq@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return directly from all switch cases, no point in storing in err.

Signed-off-by: Vito Caputo <vcaputo@pengaru.com>
---
 net/core/skbuff.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f5f904f46893..c59b68a413b5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4888,23 +4888,14 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
  */
 int skb_checksum_setup(struct sk_buff *skb, bool recalculate)
 {
-	int err;
-
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		err = skb_checksum_setup_ipv4(skb, recalculate);
-		break;
-
+		return skb_checksum_setup_ipv4(skb, recalculate);
 	case htons(ETH_P_IPV6):
-		err = skb_checksum_setup_ipv6(skb, recalculate);
-		break;
-
+		return skb_checksum_setup_ipv6(skb, recalculate);
 	default:
-		err = -EPROTO;
-		break;
+		return -EPROTO;
 	}
-
-	return err;
 }
 EXPORT_SYMBOL(skb_checksum_setup);
 
-- 
2.11.0

