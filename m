Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E96438096
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhJVXXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231691AbhJVXX3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:23:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C41961037;
        Fri, 22 Oct 2021 23:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634944871;
        bh=KGX3YvwR7bEltMniLsB8vGKOmRwopAe0MZ/Rwh0yQZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sw4yCrNif99JY/VYhXDLn4bJd/TgCUGNvBklAgovjt+k10EJRFg+b2ra/LdUDjqlE
         EZsbIUi0Lj7SNwDAFTfAFybvXwF21wRDnn0T5ZmiIvCWFjebv2ntM7XmdbQFWZmGAY
         lObbVM9AxIGixl2jRcGg5Apjwids0evorFzvVLrJ7xc+h8G7zRx8Qhigi8E9YZuAsl
         ZyoNM0GvMQFBKJkpqC8kB5Pghv9QUX91MMBFeGyQbFHEXmDcQlct/Elxkf/onDc7Qw
         J6ZXg8v0i0RTIjkn4n7wzEEHwvZd+o03KSOnnpIm/cgorQM1xw9JMuyd6H8dGpX82v
         F9LhOFr3F2PFw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 8/8] net: atm: use address setting helpers
Date:   Fri, 22 Oct 2021 16:21:03 -0700
Message-Id: <20211022232103.2715312-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022232103.2715312-1-kuba@kernel.org>
References: <20211022232103.2715312-1-kuba@kernel.org>
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

