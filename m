Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE42B179F1F
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgCEFXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:23:35 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:56196 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgCEFXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 00:23:34 -0500
Received: by mail-pj1-f68.google.com with SMTP id a18so1963436pjs.5
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 21:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7Fanemj7lqCOtUtHai5n5mSddCSmoi8i8DsjH04odmA=;
        b=3GuskwclUaXDJ/otg+I4CwuZ48HynxURncFQwl6s7PTKtTWrEfNG2tNhbQ1Qtfifp6
         QbGbNZNgAO6MiETCHtc7hh2Z6CfsEOek88IEZuk2XpbFpCPPurphFDo1e3ROoPhhEkp1
         o7KL1x/DPavdCDs7RvQ10gxY1OQtAbrtixiFWRYsm2y0cohBzI6is+Qubjmd32+zGC7f
         WYfYbqI8zmhq85nr2xF7W8aBPmQmuEc6t0xKQcvm85lwUkv8oU5TMAfaNRXfe/4dN9IT
         xclCzAJ0dGqAtXifqpU79hv3+7yAIYInM+6sjSLZ+V1hqu/75I5wLrY/v6upyf3+mmcQ
         xEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7Fanemj7lqCOtUtHai5n5mSddCSmoi8i8DsjH04odmA=;
        b=hxdRHCPaqvnVc32pFG2GkKbCmTnFypsY2BuTl1Zj3/fL5FpHKR6sBEA9/oCQJTans5
         HXAf8Ax0/H6y4Nq3BOWprP8eGU5WnxMlD4lF0g7xuIliEcpl74DBJOmIMu5tsU51hKmK
         szQKXgbQ9/VZr9cyj0q1X5PlmiIX+Jz9Z/FkTsypMOcPmLNmnnUrSC2IEzfMqMmsPDZP
         wrrHluPxqOBI9c+jTi1lRm166Hf0iquILzMPbNZuUAXdlxhirSYYmpb+moCjbl0WGSTl
         Zy/kVrFqcIr/mCfS3/LYhJ4kvVGcz0ds1jHOzleSHIbpWGk3UpUu2DV5WdZ4II2EkZHR
         J2aA==
X-Gm-Message-State: ANhLgQ3hFmj1ESVrwt8eB/vHwHolZqh/DuvGOmfbXwqUUTzr7oSukJUK
        vWGf4Cf44JyZwzUmUTtj+fgyrKlBc7Q=
X-Google-Smtp-Source: ADFU+vvh2LB4iBXS0UJHq8FbqTUfyTaOdq99ZcWvHgmCYip99RM8i8NtukEEyLHVXGXtxjfXV70Lyw==
X-Received: by 2002:a17:90a:7784:: with SMTP id v4mr6855098pjk.134.1583385812937;
        Wed, 04 Mar 2020 21:23:32 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h2sm29337759pgv.40.2020.03.04.21.23.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 21:23:32 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 5/8] ionic: support ethtool rxhash disable
Date:   Wed,  4 Mar 2020 21:23:16 -0800
Message-Id: <20200305052319.14682-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305052319.14682-1-snelson@pensando.io>
References: <20200305052319.14682-1-snelson@pensando.io>
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

