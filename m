Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9C4437C52
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbhJVR6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233819AbhJVR6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E406361374;
        Fri, 22 Oct 2021 17:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634925349;
        bh=KGX3YvwR7bEltMniLsB8vGKOmRwopAe0MZ/Rwh0yQZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qf3Voz223Xba15rkbjrHoYKo/oVtpzuEP8jK4jBJk0sCLDLEHqaXTfoqffyehX96E
         qFPKOcJ4HM8PD2Lu3BFywuI0bSDUUcDkVM9LZFXVvHbV4F8dP45w+3KDATDh5Jtoun
         UAHKYQRSWuE1V+iZ/mTgt3gPIZviWhs4I/q/VFpqsXqaxvk87JPEiEKjmAv3KE71P7
         QAoyRGbdZ2x5kjqnUULHvk3jpHTNW3KY65ieEllEKh24YrcZL/xAtwhgjVHZP31Qss
         hc9gm+xToshVZa3o+GV+Jkja5aQe83HISLHuILxsyvA/ms5SfsX7Vtf2MoUkQdNe4d
         mJuTPsHwkd0EA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 8/8] net: atm: use address setting helpers
Date:   Fri, 22 Oct 2021 10:55:43 -0700
Message-Id: <20211022175543.2518732-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022175543.2518732-1-kuba@kernel.org>
References: <20211022175543.2518732-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get it ready for constant netdev->dev_addr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/atm/br2684.c | 4 +++-
 net/atm/lec.c    | 5 ++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index 11854fde52db..f666f2f98ba5 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -577,10 +577,12 @@ static int br2684_regvcc(struct atm_vcc *atmvcc, void __user * arg)
 	pr_debug("vcc=%p, encaps=%d, brvcc=%p\n", atmvcc, be.encaps, brvcc);
 	if (list_empty(&brdev->brvccs) && !brdev->mac_was_set) {
 		unsigned char *esi = atmvcc->dev->esi;
+		const u8 one = 1;
+
 		if (esi[0] | esi[1] | esi[2] | esi[3] | esi[4] | esi[5])
 			dev_addr_set(net_dev, esi);
 		else
-			net_dev->dev_addr[2] = 1;
+			dev_addr_mod(net_dev, 2, &one, 1);
 	}
 	list_add(&brvcc->brvccs, &brdev->brvccs);
 	write_unlock_irq(&devs_lock);
diff --git a/net/atm/lec.c b/net/atm/lec.c
index 8eaea4a4bbd6..6257bf12e5a0 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -340,12 +340,12 @@ static int lec_close(struct net_device *dev)
 
 static int lec_atm_send(struct atm_vcc *vcc, struct sk_buff *skb)
 {
+	static const u8 zero_addr[ETH_ALEN] = {};
 	unsigned long flags;
 	struct net_device *dev = (struct net_device *)vcc->proto_data;
 	struct lec_priv *priv = netdev_priv(dev);
 	struct atmlec_msg *mesg;
 	struct lec_arp_table *entry;
-	int i;
 	char *tmp;		/* FIXME */
 
 	WARN_ON(refcount_sub_and_test(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc));
@@ -358,8 +358,7 @@ static int lec_atm_send(struct atm_vcc *vcc, struct sk_buff *skb)
 		eth_hw_addr_set(dev, mesg->content.normal.mac_addr);
 		break;
 	case l_del_mac_addr:
-		for (i = 0; i < 6; i++)
-			dev->dev_addr[i] = 0;
+		eth_hw_addr_set(dev, zero_addr);
 		break;
 	case l_addr_delete:
 		lec_addr_delete(priv, mesg->content.normal.atm_addr,
-- 
2.31.1

