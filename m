Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6E2178976
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgCDEU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:20:29 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43078 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbgCDEU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:20:27 -0500
Received: by mail-pl1-f196.google.com with SMTP id x17so408794plm.10
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 20:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7Fanemj7lqCOtUtHai5n5mSddCSmoi8i8DsjH04odmA=;
        b=2konT/EdhSgfOPsJQR741twjwc+/kCy9kPbaCwOVYZzBZvyHINDIF/D6Y2DorNMgc2
         DIN1ZaMedNhWKVV4kVqas9glVQwAiUjODHI1kV69ydSW6rf6FFAk8x8p+HAk1bOE89fM
         qcopn1mT5s6uDzq56QYzIlJDaEaDlkYGvvNGkbwVsgBt42KtBQhZeJVJv9ov6Ul5wEJP
         FWocMwDQfgc+qY3KXEQc2Djp8FXLlqafo8lTUrL4+87hXUfIoPJS725Inul2yI7P05GT
         3MVFfnh514QlmhSynGogw+TDs/VsLSIz3s1lughljcE/pguLrS3fXDon0EOWQKZjaUfB
         HbHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7Fanemj7lqCOtUtHai5n5mSddCSmoi8i8DsjH04odmA=;
        b=Nh6f3JaVaMg8HkwCHQ1KrQLBcKohQ74sNtXhJI3/9qp3P1mwW8d+mNG6k9YbJFMKsy
         V8dYDTodp+a/ZJXEYeWMgnr3qYFH0jvwsBTTY8wht2l80GRuFRPBf2f3a83//vdPHbjK
         KQqHItnEmSJAy1QCruH0i8V4wrLznFcuPydXPBnS7QRVA8wkh07BeCBAD42mXwm/OYBQ
         5lfSA6Uk1PxgZvvrB0qTl+3g2r51lLYAQI5Pfib9g3pT5bGqvtrCTW9Si+7Zo44u2eQX
         elXygxOSDAoSi8DXZtTiGmNUeskuApo1CZWC/4sdenruYpRmp1dxrq3DAp0JMsq78QJO
         dAAA==
X-Gm-Message-State: ANhLgQ2oW2uL5/m8nKE4CKxl5CikOKdpSxoNRMmB8/Gn/AiX6sRVOTxr
        Feeoi64Ha0iOkTWtpC0ZmQSdeA==
X-Google-Smtp-Source: ADFU+vu3lqMXxkdA5ssBcszagEbaMtPEg1ZsJ7wNQ5/JbRiKFExqVt0b7K63lseSUytVJgeKJiIGRw==
X-Received: by 2002:a17:902:b113:: with SMTP id q19mr1266767plr.199.1583295626282;
        Tue, 03 Mar 2020 20:20:26 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c2sm671702pjo.28.2020.03.03.20.20.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 20:20:25 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 5/8] ionic: support ethtool rxhash disable
Date:   Tue,  3 Mar 2020 20:20:10 -0800
Message-Id: <20200304042013.51970-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304042013.51970-1-snelson@pensando.io>
References: <20200304042013.51970-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can disable rxhashing by setting rss_types to 0.  The user
can toggle this with "ethtool -K <ethX> rxhash off|on",
which calls into the .ndo_set_features callback with the
NETIF_F_RXHASH feature bit set or cleared.  This patch adds
a check for that bit and updates the FW if necessary.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index d1567e477b1f..4b953f9e9084 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1094,6 +1094,7 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
 	u64 vlan_flags = IONIC_ETH_HW_VLAN_TX_TAG |
 			 IONIC_ETH_HW_VLAN_RX_STRIP |
 			 IONIC_ETH_HW_VLAN_RX_FILTER;
+	u64 old_hw_features;
 	int err;
 
 	ctx.cmd.lif_setattr.features = ionic_netdev_features_to_nic(features);
@@ -1101,9 +1102,13 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
 	if (err)
 		return err;
 
+	old_hw_features = lif->hw_features;
 	lif->hw_features = le64_to_cpu(ctx.cmd.lif_setattr.features &
 				       ctx.comp.lif_setattr.features);
 
+	if ((old_hw_features ^ lif->hw_features) & IONIC_ETH_HW_RX_HASH)
+		ionic_lif_rss_config(lif, lif->rss_types, NULL, NULL);
+
 	if ((vlan_flags & features) &&
 	    !(vlan_flags & le64_to_cpu(ctx.comp.lif_setattr.features)))
 		dev_info_once(lif->ionic->dev, "NIC is not supporting vlan offload, likely in SmartNIC mode\n");
@@ -1357,13 +1362,15 @@ int ionic_lif_rss_config(struct ionic_lif *lif, const u16 types,
 		.cmd.lif_setattr = {
 			.opcode = IONIC_CMD_LIF_SETATTR,
 			.attr = IONIC_LIF_ATTR_RSS,
-			.rss.types = cpu_to_le16(types),
 			.rss.addr = cpu_to_le64(lif->rss_ind_tbl_pa),
 		},
 	};
 	unsigned int i, tbl_sz;
 
-	lif->rss_types = types;
+	if (lif->hw_features & IONIC_ETH_HW_RX_HASH) {
+		lif->rss_types = types;
+		ctx.cmd.lif_setattr.rss.types = cpu_to_le16(types);
+	}
 
 	if (key)
 		memcpy(lif->rss_hash_key, key, IONIC_RSS_HASH_KEY_SIZE);
-- 
2.17.1

