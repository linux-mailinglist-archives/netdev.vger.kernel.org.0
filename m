Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628FD134F33
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgAHV71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:59:27 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:47029 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgAHV7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 16:59:23 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b0e47a77;
        Wed, 8 Jan 2020 21:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=tvWX41NmdgS7E5unBxvZAmWb5
        lk=; b=vCZHIzaGEf26+LY5Gn+Eji6IlThlonQtywUhOnGhH1Vu1mlysy/4lPrd0
        vbc6L5Z5syGCQ7FrmP7Hfv+0OteJno2wjaXDbQJl3bILMqPRDx6aOR0En9kl/62a
        W1H7UiwoP3k389I5WfZ8CGuNkYM3oruKAyT+8fd8qiad+TYK3gh7DPDkkJLyDquY
        PXAz+M0sMvZMsoktrDnBfArHXE4cUZ/3wb3lBdxafNZia7Fa0VY+f4fCS5q4ay4U
        +KdVh4/4uqEUvsuSDzRV7KJFybcUgkmIJ6C47UDadjSujN4hGym2SvFcwKU1BfTl
        X2zb4Rdlm2g6p62eanDi7F8doqieA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6ea430c1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jan 2020 21:00:02 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        siva.kallam@broadcom.com, christopher.lee@cspi.com,
        ecree@solarflare.com, johannes.berg@intel.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 3/8] net: r8152: use skb_list_walk_safe helper for gso segments
Date:   Wed,  8 Jan 2020 16:59:04 -0500
Message-Id: <20200108215909.421487-4-Jason@zx2c4.com>
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
 drivers/net/usb/r8152.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 9ec1da429514..fe22a582373b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1897,8 +1897,8 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 {
 	if (skb_shinfo(skb)->gso_size) {
 		netdev_features_t features = tp->netdev->features;
+		struct sk_buff *segs, *seg, *next;
 		struct sk_buff_head seg_list;
-		struct sk_buff *segs, *nskb;
 
 		features &= ~(NETIF_F_SG | NETIF_F_IPV6_CSUM | NETIF_F_TSO6);
 		segs = skb_gso_segment(skb, features);
@@ -1907,12 +1907,10 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 
 		__skb_queue_head_init(&seg_list);
 
-		do {
-			nskb = segs;
-			segs = segs->next;
-			nskb->next = NULL;
-			__skb_queue_tail(&seg_list, nskb);
-		} while (segs);
+		skb_list_walk_safe(segs, seg, next) {
+			skb_mark_not_on_list(seg);
+			__skb_queue_tail(&seg_list, seg);
+		}
 
 		skb_queue_splice(&seg_list, list);
 		dev_kfree_skb(skb);
-- 
2.24.1

