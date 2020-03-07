Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2091617CA16
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 02:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCGBEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 20:04:25 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39965 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbgCGBEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 20:04:23 -0500
Received: by mail-pl1-f194.google.com with SMTP id y1so1554834plp.7
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 17:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7Fanemj7lqCOtUtHai5n5mSddCSmoi8i8DsjH04odmA=;
        b=b3+6z306dqR2rco0JJYn80xwDnbZABycVmqvwPs9AaMVMsVmHUw552qpH+eyMJsyvW
         rBrqylGAPwLfXbfFft5ZwPnntH0hNThJ4l/MGLRWJ2HTiZ1Oq2RMIfJwr34ZHLvsBCPY
         qcqZFnywiIy44T8bkDicAjDDITCuoR7cM9CgdhGYlJS5s0UC+n3DNwxJmHy0X9bIaXz/
         wa8vGJV5XN7wtC/tZFwdcGW8MfOqyaFx8KsOVSrHa3c+hF2cxhHbn9G7C65nErplUCjx
         RlMJbbjHqUkEkAb1XpnT26r6g6NK4Ls1/yVrqjGpfXW4ccSuhfskafEH6ydt6k9/OPhr
         aAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7Fanemj7lqCOtUtHai5n5mSddCSmoi8i8DsjH04odmA=;
        b=i2rYhViubhzPR4z7stdwvz85uKCRa9VWIB58XDiT01A34hmB2+Hr0XVBSGxBOBhR78
         /+jTyRSg3GWNNsmgyMOa2Gqadz3U7lcoWm2Cib/Hn1rFV4Lo8dB5y1P8A/QVEH9TztNf
         IzoOT/OIAMREyhljSQJtzfxxGVBO+sUFnLMKPp7ZSx81iVBw/65UIoc19l6BcBOSKs+k
         yy1h2VhWVukzXfavtSlOABZIypzB47SZzNQTbvZG541VQiQXxPbvNlEK6jsxb2Vg5uQh
         wagZh8QtPJQtMn9bhUA1Ms34j5jrFibF0mUIRqDWA7jZE5XZKBRz3y2USdcUCelvXBTF
         /qbg==
X-Gm-Message-State: ANhLgQ1vbl/FNFsGVu0I3eXEUzf/eaG+XkUIDvbKUKvH0dJQv5P/jDIv
        +8yFcVgTZK5PPP8dSbHJxS1ZCw7XO4c=
X-Google-Smtp-Source: ADFU+vuB+irirofDDDkfk0cUhWQ8jmiEwBkKCkvOuxJAVT3W6zXcFRg1A5OMpNzSuQx81cbRxaJXOw==
X-Received: by 2002:a17:902:9889:: with SMTP id s9mr5173619plp.252.1583543061839;
        Fri, 06 Mar 2020 17:04:21 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o66sm23224949pfb.93.2020.03.06.17.04.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Mar 2020 17:04:21 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 5/8] ionic: support ethtool rxhash disable
Date:   Fri,  6 Mar 2020 17:04:05 -0800
Message-Id: <20200307010408.65704-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200307010408.65704-1-snelson@pensando.io>
References: <20200307010408.65704-1-snelson@pensando.io>
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

