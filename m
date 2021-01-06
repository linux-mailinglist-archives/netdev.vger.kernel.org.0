Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3819C2EB9E0
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 07:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbhAFGLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 01:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbhAFGLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 01:11:52 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C4EC06134D
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 22:11:12 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id g185so1629210wmf.3
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 22:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+uo2SY1X2MxW5+IbgN5c30dJZNJTKlZN+qgwoac0AeE=;
        b=ElgKIpcY6Wd9zu1DLa4lDCn1HsY2EQiuUgN/0tW9HqpR1N2mOhUUKmdpoD+gzn3LQZ
         D07/Qn5AvkdFwTNXBnKAN/7lsZd529SJsM2FVJmwvlShBsQQP8yiWAuttrMSXAu7WvMK
         IGYqhzMnyRFBe7FicPtHA3p99SGrjdUkiMR41K3I375y0U43dZS4ts0zulaPK4C8q3hF
         QzMvuhVurBrCRxXJHftazUykmSgIQsgqzJEXPbjdaHCgdQKbB/OkNDo/idH+k858WBOk
         7GgcP2YSqC9Iyi2XUKsR8SRJR4LDsK6aNJlUEul0QiUJgCFn+ezmToztos3rtgCQGr7d
         fl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+uo2SY1X2MxW5+IbgN5c30dJZNJTKlZN+qgwoac0AeE=;
        b=c1SriUqqNtUv1cSx9krBJgv53DgAlFN+4JySq5rw53XQSub8d9QwEStlBeFvBapAKD
         ogReh01BjYteLRLA/K+0XBYzb7MEy0PS+3ZMwzGY5LQFmypxuhIRuGp5qN6j3kFabJ6v
         EoCFW/acmqLLIL6qsQISrzLC4aJZ0u6AuzePL8e3dYcD3l3im3/Rm84INI0Eb9LZxo36
         OsTd2xTGNRQRJg+++PheZbOGsrYuWPPH3eYK9RabIw3uxQwzBpQPNwOIubJHflqsXz3k
         wkKnAsb2GWalibttqinoa5xdR/yQKjUlXQxLmkVPl4hM8lnl3x6G35Q9YSOuZCoqmZeU
         E9Yg==
X-Gm-Message-State: AOAM533TLGYy6b8mfcsXZ4i72y7YrWJQOYGI2J2zhOe6pD9W4eNU9TxF
        5ZPSl6h4i4AXGfqmaMay8mg=
X-Google-Smtp-Source: ABdhPJzY6r7+16mJFCJ3MrFnVVkgHEXZKPFv/7exgYgzXhx/+eqyOUCftalKpS0mlCQu+wz2cboxpA==
X-Received: by 2002:a1c:7c19:: with SMTP id x25mr2217312wmc.94.1609913470800;
        Tue, 05 Jan 2021 22:11:10 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id c4sm1855715wrw.72.2021.01.05.22.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 22:11:10 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        shmulik.ladkani@gmail.com, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next] xfrm: interface: enable TSO on xfrm interfaces
Date:   Wed,  6 Jan 2021 08:10:46 +0200
Message-Id: <20210106061046.3226495-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Underlying xfrm output supports gso packets.
Declare support in hw_features and adapt the xmit MTU check to pass GSO
packets.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/xfrm/xfrm_interface.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 697cdcfbb5e1..495b1f5c979b 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -296,7 +296,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	}
 
 	mtu = dst_mtu(dst);
-	if (skb->len > mtu) {
+	if ((!skb_is_gso(skb) && skb->len > mtu) ||
+	    (skb_is_gso(skb) && !skb_gso_validate_network_len(skb, mtu))) {
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->protocol == htons(ETH_P_IPV6)) {
@@ -564,6 +565,11 @@ static void xfrmi_dev_setup(struct net_device *dev)
 	eth_broadcast_addr(dev->broadcast);
 }
 
+#define XFRMI_FEATURES (NETIF_F_SG |		\
+			NETIF_F_FRAGLIST |	\
+			NETIF_F_GSO_SOFTWARE |	\
+			NETIF_F_HW_CSUM)
+
 static int xfrmi_dev_init(struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
@@ -581,6 +587,8 @@ static int xfrmi_dev_init(struct net_device *dev)
 	}
 
 	dev->features |= NETIF_F_LLTX;
+	dev->features |= XFRMI_FEATURES;
+	dev->hw_features |= XFRMI_FEATURES;
 
 	if (phydev) {
 		dev->needed_headroom = phydev->needed_headroom;
-- 
2.25.1

