Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F1813F3A3
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388718AbgAPSnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:43:37 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55881 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731675AbgAPSne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:43:34 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so4846819wmj.5
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZxFTFbnmmtiFbUa3aRvoAz0FbilymAjrwOmHggV0ULQ=;
        b=O+itB9fNlwGoXbGijJdO3AIClH0OF/l+x3wlARzSuKbNLMjvPCXT0z2bQUmwS0T3Cb
         tL3nXhErk4QN6lqxGh5szFjuAcoh9XEdnF9FzeUcfCKwNZLYC/8OHSRFy1DgQ4UCl68Z
         DlLVc/wthSneEzpaA2aYB62i9PlWixpAGSvkTOX42f4vbyrbGCf2utZEZENmYa6iTq5F
         2EH2RbkiKqR5djakcZG3MPbhHZ05+Qx1tF5sqJ5H/5LVkTgCz9RIwENjKQ4qLILCk9YW
         s5U8txLyeXRnzi+NGJd0KFC2V0lAaJNpeC5ehOfaziudBdkERZlxkj50Of0DxDJ7GWHl
         Iwyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZxFTFbnmmtiFbUa3aRvoAz0FbilymAjrwOmHggV0ULQ=;
        b=dwtqTHHmtAnXHUGc42g9f3WV9hnSwp6RE6hw6HmMhZSKSZS7XE20GVv/KOP8pJ7J5o
         PMcWmXKpwFNP0KtEMq6vd3oEPnPjkhoWuhZ7hFh4e39Wv+vdPyuldkP/uZMEdIn36+hc
         P1/tJzRIfjmtkEbUd0aBNvCzWNNY7iZl4Qp0djVDG7n3YHAtoqkwZ2oDtOtgHwLvSwjt
         LX2sdnXzY3s807Xlp1i+uMHKn1GpQkTw0zRClPwZps3kArK76c41+No2RJL9r46Zofl6
         x9ELKjXSUxDRjjfjvXXDbDrlfFOWLeqYUrcczTt7Os5rDiNNuNlkPe7oHbQT7poJ6eu7
         6m7Q==
X-Gm-Message-State: APjAAAU1pA8hkudYsP0up2q91az6vanAC5j/47lKBUibGp4hnXNqmjgd
        b8we097Ufxk4DMPT8NIkaIK0/uJaXt8=
X-Google-Smtp-Source: APXvYqzZzQ19JP5gWmgrboxlgMg+6bvf781KtYSq/tx50+/CBUKIDYTA6mADoGmWDtle6CntxSfzqA==
X-Received: by 2002:a05:600c:54c:: with SMTP id k12mr418037wmc.124.1579200212296;
        Thu, 16 Jan 2020 10:43:32 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id x7sm29557231wrq.41.2020.01.16.10.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 10:43:31 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net] net: dsa: sja1105: Don't error out on disabled ports with no phy-mode
Date:   Thu, 16 Jan 2020 20:43:27 +0200
Message-Id: <20200116184327.13060-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The sja1105_parse_ports_node function was tested only on device trees
where all ports were enabled. Fix this check so that the driver
continues to probe only with the ports where status is not "disabled",
as expected.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 784e6b8166a0..03ba6d25f7fe 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -574,7 +574,7 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 	struct device *dev = &priv->spidev->dev;
 	struct device_node *child;
 
-	for_each_child_of_node(ports_node, child) {
+	for_each_available_child_of_node(ports_node, child) {
 		struct device_node *phy_node;
 		phy_interface_t phy_mode;
 		u32 index;
-- 
2.17.1

