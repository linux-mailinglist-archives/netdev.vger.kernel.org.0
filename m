Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC832134F35
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgAHV7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:59:30 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:47029 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgAHV72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 16:59:28 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 878e9a17;
        Wed, 8 Jan 2020 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=strFM4LtIN4dFYi8rUdeqMtVh
        6Q=; b=wjVJ3Yz8/gXurSARGBCYrDZ9JR+Ds2gOPE8oLRbaq5Brvt4GRzitjx8i1
        Qtd4X1c1uUvvhReo95h5Dgn9e0idlFDY6psT1tJgVAVqXFIv7r5I65ZvHrWZdLQ2
        n4KxTmXYllobORK+3iJXitwv+FF4wFxFRJzx97jULrVfROoV5iCW0BmuP+rHvzMX
        tcsDjCR8oFlIRpxmQ7iaEWGHnne0fKCC0648X3v/vDPksp8mAUyS/cn9Rd6pCHc1
        975h7yQNT7ONhf564MNLH0Ewqt/S9SZ60puwpZShWPPbO4k6B1S43iSaXEWfueXI
        KC8UWlwXFaReNy8RVCjLCQ1W1URgA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 350d27c4 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jan 2020 21:00:03 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        siva.kallam@broadcom.com, christopher.lee@cspi.com,
        ecree@solarflare.com, johannes.berg@intel.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5/8] net: sunvnet: use skb_list_walk_safe helper for gso segments
Date:   Wed,  8 Jan 2020 16:59:06 -0500
Message-Id: <20200108215909.421487-6-Jason@zx2c4.com>
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
 drivers/net/ethernet/sun/sunvnet_common.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index a601a306f9a5..c23ce838ff63 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1223,7 +1223,7 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 {
 	struct net_device *dev = VNET_PORT_TO_NET_DEVICE(port);
 	struct vio_dring_state *dr = &port->vio.drings[VIO_DRIVER_TX_RING];
-	struct sk_buff *segs;
+	struct sk_buff *segs, *curr, *next;
 	int maclen, datalen;
 	int status;
 	int gso_size, gso_type, gso_segs;
@@ -1282,11 +1282,8 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 	skb_reset_mac_header(skb);
 
 	status = 0;
-	while (segs) {
-		struct sk_buff *curr = segs;
-
-		segs = segs->next;
-		curr->next = NULL;
+	skb_list_walk_safe(segs, curr, next) {
+		skb_mark_not_on_list(curr);
 		if (port->tso && curr->len > dev->mtu) {
 			skb_shinfo(curr)->gso_size = gso_size;
 			skb_shinfo(curr)->gso_type = gso_type;
-- 
2.24.1

