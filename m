Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343282CDC81
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 18:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389218AbgLCReg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 12:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbgLCRef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 12:34:35 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D267C061A4E
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 09:33:55 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id a3so4714522wmb.5
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 09:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=8H5t7wOps9GUkUKbXmhcigrdwImPlty8h02XXekORY0=;
        b=p100rrAdq8Hc91vgfxooL5KC5GEj59pqFy1tDFzTFwv8PlEgfDVhwxC7fj6VkSlcLo
         mQWMz6K2VEGtrMMWQb3+S7c8hCS1DhbVOCpw7mfwwLneRm9xaIB3+D2d7vUsYKqe2Vwe
         8wQnLx/pIjN4+p9QiXR89r0dqalkFB9NM/So7nUic3SMJJCIgeluSyzx1lnykznNC+4O
         fcYgf2apKhx9FAT/MmpZBSHHXXNbraHeRGE5rj32gnOQN6Md6yc+HWswYhtclMCTyoFz
         5s54Rip54+OvYn6CbgBvKoQ1a9JcHPnKUD+d+u3oCgdTIQgX2o2g6EMoGcmHCtQw8t/s
         eS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8H5t7wOps9GUkUKbXmhcigrdwImPlty8h02XXekORY0=;
        b=c8JHmzDCz4EqZOcStltEWZWejxpeM+gRR4dLjdTsMFKU999WlNQvbIo7hT6+cSL7MC
         s4IZK992qwHiPLoNGnaoOXm44xPnDIRWg06FL9aXQ7HcpSmERapuUExKaXn5md3Bs8C8
         KSJl+DbfA+iJZoipdG+/gM9HK5GtWeXTD9Ipi15aD2b+a6eqHXKdYNlrvzHmTAk2D447
         +52tdUWcNr4VpXD5EbjdZSOPRMoz1HCT6KlwcOVNdlZDazZ+ObI+K8KYS2BNB5ljMrtC
         o1zDFqg77FyCB/WUht0m0eRbBljZqQK333/pdX/M77BPKSvwzpp2zW9tf8zVUC/wb+X9
         r+LQ==
X-Gm-Message-State: AOAM533V+Kftedcb2vmQ0g41qkCoWizz5ZkJHcLvCvWpkosytuk6Vzhw
        oM1wG1nIRS4UCrWYgKcAGlRIEA==
X-Google-Smtp-Source: ABdhPJwu13qHYRsHz5Em+k6WeQDdgjmxpRbvGR+1/mu8G5KSF+8JIRt64CjnkA/2iIikJBDZMVhSoA==
X-Received: by 2002:a05:600c:cc:: with SMTP id u12mr248898wmm.42.1607016833745;
        Thu, 03 Dec 2020 09:33:53 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id l1sm87904wmi.15.2020.12.03.09.33.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Dec 2020 09:33:53 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] net: rmnet: Adjust virtual device MTU on real device capability
Date:   Thu,  3 Dec 2020 18:40:40 +0100
Message-Id: <1607017240-10582-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A submitted qmap/rmnet packet size can not be larger than the linked
interface (real_dev) MTU. This patch ensures that the rmnet virtual
iface MTU is configured according real device capability.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index d58b51d..d1d7328 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -60,9 +60,14 @@ static netdev_tx_t rmnet_vnd_start_xmit(struct sk_buff *skb,
 
 static int rmnet_vnd_change_mtu(struct net_device *rmnet_dev, int new_mtu)
 {
+	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
+
 	if (new_mtu < 0 || new_mtu > RMNET_MAX_PACKET_SIZE)
 		return -EINVAL;
 
+	if (priv->real_dev && (new_mtu + RMNET_NEEDED_HEADROOM) > priv->real_dev->mtu)
+		return -EINVAL;
+
 	rmnet_dev->mtu = new_mtu;
 	return 0;
 }
@@ -242,6 +247,9 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 
 	priv->real_dev = real_dev;
 
+	/* Align default MTU with real_dev MTU */
+	rmnet_vnd_change_mtu(rmnet_dev, real_dev->mtu - RMNET_NEEDED_HEADROOM);
+
 	rc = register_netdevice(rmnet_dev);
 	if (!rc) {
 		ep->egress_dev = rmnet_dev;
-- 
2.7.4

