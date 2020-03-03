Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED25176DE7
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgCCEQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:16:13 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37060 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbgCCEQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:16:05 -0500
Received: by mail-pg1-f193.google.com with SMTP id z12so894273pgl.4
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 20:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7Fanemj7lqCOtUtHai5n5mSddCSmoi8i8DsjH04odmA=;
        b=eaRZ0JUdyUdP+oyaqzc4uTP5fJsbACR3hPGrhJY0K1HaFBB8MqqE1VoaHBFsulyyli
         dcT0fr/n147qWWSjaGAOT1TkAAqQ7g1Ulv+oxOi4r7su0PXX9uVZTeK40tQO8ySNu7GT
         d4ix1QArm8XhLm/f/eIL+FYnbg3W9pyB9O7n30td7zJaQsYPs+81jkVa8ILuL9Y+doHm
         q6S5SzxTJ/VbEdBHKfqB9/yX3N4FtbBMBxf/zZBMTryK7O5+LY9Dt8bCxzEbNqnl9cPC
         3+Vi4addpwrp46zHiQexlPp4qqqTV+aq704lCZCfGvzyKBlTP2My3RXIOfgDA3u784mJ
         6veg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7Fanemj7lqCOtUtHai5n5mSddCSmoi8i8DsjH04odmA=;
        b=fzzM6KCv+Rh234UvrdigZXl/Ivd5kCKJKuPA7OeYqxXlzol58XOgjxR7/yzO33lffa
         f0w1Qeotd+JyttTdZb3mWEKYhd1ILsg4t6ZCMJhwJrBtzEwA+YzDcfNezR0oT/uocq42
         modHL47OckNgzTB8nEZhU1MsTQsT/fvbRuee+ltOp2HB5l5soFpGIUZ1Me5wSFgHTkOm
         LxNXWAuYBQkFa8+/AZjAr6XnlYoZYnFYot2H4gHxbUaLZv5v5Nlgw+QZTe6g160Utm7D
         YhUwHjO7wYk1n9lc+6hHdZaYQG7C8EGCpLYlHsInvDgJQCwX/LgnPJYlBmZ7688rHMZS
         LXhQ==
X-Gm-Message-State: ANhLgQ2ykvpCXW55tyNtqMt8sPtLJn/Vyn8TD55sKBEU1VCWQRM0Xvqp
        gPbhNEvpvw2jupuceiRUgKtIcA==
X-Google-Smtp-Source: ADFU+vvtLxx7oZQ2OlDOYnv48Z/xV/rpg5UkQ6+J7KfPikxlYitF8Xu2ymj2ub+/znZ8KvLrlvSDng==
X-Received: by 2002:a62:64d5:: with SMTP id y204mr2395646pfb.90.1583208964589;
        Mon, 02 Mar 2020 20:16:04 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t7sm396682pjy.1.2020.03.02.20.16.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 20:16:04 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/8] ionic: support ethtool rxhash disable
Date:   Mon,  2 Mar 2020 20:15:42 -0800
Message-Id: <20200303041545.1611-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303041545.1611-1-snelson@pensando.io>
References: <20200303041545.1611-1-snelson@pensando.io>
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

