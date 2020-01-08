Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49B7134F37
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbgAHV7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:59:34 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:47029 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbgAHV7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 16:59:30 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 03289c37;
        Wed, 8 Jan 2020 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=E2G+4p0VbUlMbqfHD/jO2XHVQ
        HM=; b=aDEr5RdQtX+kZ+KZDwCPVM3gaI3C8Q8JEevdbj/Q3V7U+d4Af6Nduyn9c
        7driR2VMlJ2PvuHrgZxwp87Q5r5I4Bd0KWrvQEuwn15J8cU1LcWq/27Nmte/OVVZ
        Ulj7roajf/+TvQPBD2NvXtw8cYhEcTK3/v0bDiv4NI9K4Y8lI1XQmjcZSZAatYIV
        xpfQ2KUU2A8+xeEmia/CZfitriW1HGt2pC8wq5EHHknWZhNYe9uzSHE4OHRNkaoJ
        P3JUAZoXhgW+5YQJFerOUrjzkSiz1gDBZXaphctodNhChAwMQO24Dy5guR64nPtj
        q+D4Wm2Ekg8oEPjq+DBqW2bLxBtSg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3c9bf562 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jan 2020 21:00:04 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        siva.kallam@broadcom.com, christopher.lee@cspi.com,
        ecree@solarflare.com, johannes.berg@intel.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 7/8] net: myri10ge: use skb_list_walk_safe helper for gso segments
Date:   Wed,  8 Jan 2020 16:59:08 -0500
Message-Id: <20200108215909.421487-8-Jason@zx2c4.com>
In-Reply-To: <20200108215909.421487-1-Jason@zx2c4.com>
References: <20200108215909.421487-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a straight-forward conversion case for the new function, and
while we're at it, we can remove a null write to skb->next by replacing
it with skb_mark_not_on_list.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index c979f38a2e0c..2ee0d0be113a 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2892,7 +2892,7 @@ static netdev_tx_t myri10ge_xmit(struct sk_buff *skb,
 static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 					 struct net_device *dev)
 {
-	struct sk_buff *segs, *curr;
+	struct sk_buff *segs, *curr, *next;
 	struct myri10ge_priv *mgp = netdev_priv(dev);
 	struct myri10ge_slice_state *ss;
 	netdev_tx_t status;
@@ -2901,10 +2901,8 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 	if (IS_ERR(segs))
 		goto drop;
 
-	while (segs) {
-		curr = segs;
-		segs = segs->next;
-		curr->next = NULL;
+	skb_list_walk_safe(segs, curr, next) {
+		skb_mark_not_on_list(curr);
 		status = myri10ge_xmit(curr, dev);
 		if (status != 0) {
 			dev_kfree_skb_any(curr);
-- 
2.24.1

