Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2013E3B0A19
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhFVQSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhFVQSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 12:18:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2128C06175F
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 09:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8k5Tpc1J0p5dVdrQlCEVBy9u/KXOsse4TxG66ip3Z9c=; b=GoT8y+nksVhEj6bkIOFl6+LNf9
        6ZBpFw6w1+mjk59w5W5DWh7i1O4JIzj5bJGhDMwAn0rovS0Hs6kapLgBH+DzRt2g3ISeMSnrB0nvF
        K0x4355p6SvEcoL0fh77901rFGBWc6UkogwEAlqUAvs6Uj/25Tj0bA4QKCl0r2c/C94yaSB3d+zxF
        VZ6WgfE2j9/BQ/bSoiV0Omal6PdCEL65XSK0zj5AdJzchXNAsfV69L19Hx2MrMM8FKu2HX5keeDOc
        AOi0ErcHu6GDQtP4odC2FXZWL7BrN068GrkY8xyf5J+skYFu0s5CNGgIj9T66ZIV7DSpdRcEm+tcG
        Xh53H0Hg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvj3m-00ETxe-38; Tue, 22 Jun 2021 16:15:48 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvj3l-005608-Kt; Tue, 22 Jun 2021 17:15:33 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Subject: [PATCH v2 1/4] net: tun: fix tun_xdp_one() for IFF_TUN mode
Date:   Tue, 22 Jun 2021 17:15:30 +0100
Message-Id: <20210622161533.1214662-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

In tun_get_user(), skb->protocol is either taken from the tun_pi header
or inferred from the first byte of the packet in IFF_TUN mode, while
eth_type_trans() is called only in the IFF_TAP mode where the payload
is expected to be an Ethernet frame.

The alternative path in tun_xdp_one() was unconditionally using
eth_type_trans(), which corrupts packets in IFF_TUN mode. Fix it to
do the correct thing for IFF_TUN mode, as tun_get_user() does.

Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/net/tun.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4cf38be26dc9..f812dcdc640e 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2394,8 +2394,50 @@ static int tun_xdp_one(struct tun_struct *tun,
 		err = -EINVAL;
 		goto out;
 	}
+	switch (tun->flags & TUN_TYPE_MASK) {
+	case IFF_TUN:
+		if (tun->flags & IFF_NO_PI) {
+			u8 ip_version = skb->len ? (skb->data[0] >> 4) : 0;
+
+			switch (ip_version) {
+			case 4:
+				skb->protocol = htons(ETH_P_IP);
+				break;
+			case 6:
+				skb->protocol = htons(ETH_P_IPV6);
+				break;
+			default:
+				atomic_long_inc(&tun->dev->rx_dropped);
+				kfree_skb(skb);
+				err = -EINVAL;
+				goto out;
+			}
+		} else {
+			struct tun_pi *pi = (struct tun_pi *)skb->data;
+			if (!pskb_may_pull(skb, sizeof(*pi))) {
+				atomic_long_inc(&tun->dev->rx_dropped);
+				kfree_skb(skb);
+				err = -ENOMEM;
+				goto out;
+			}
+			skb_pull_inline(skb, sizeof(*pi));
+			skb->protocol = pi->proto;
+		}
+
+		skb_reset_mac_header(skb);
+		skb->dev = tun->dev;
+		break;
+	case IFF_TAP:
+		if (!pskb_may_pull(skb, ETH_HLEN)) {
+			atomic_long_inc(&tun->dev->rx_dropped);
+			kfree_skb(skb);
+			err = -ENOMEM;
+			goto out;
+		}
+		skb->protocol = eth_type_trans(skb, tun->dev);
+		break;
+	}
 
-	skb->protocol = eth_type_trans(skb, tun->dev);
 	skb_reset_network_header(skb);
 	skb_probe_transport_header(skb);
 	skb_record_rx_queue(skb, tfile->queue_index);
-- 
2.31.1

