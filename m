Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219794C4BDB
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241236AbiBYRRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238844AbiBYRRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:17:08 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FE721D081
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:16:36 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id z2so5353812plg.8
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=W2jNNrY5/QqqeiRWH7nZnuZClY2AmttMrv8jp57V4/w=;
        b=KStzUTa2nhcNnQj5yjs2/k71YK/9mG2flXhCnJhmn6n4mHwoqtVFz+3XcUeImMnyfc
         QU2r4CaLVeBTS6q7cOTmBs01/kvs6XzHftE6l3hxQTLyfIU10mHgy5JT732DauK4YeNY
         XYxj0lCujJUkrc83F7EuNAW5mrk22SGPgKJEc0vNAGjiZk39PDZpkgEHb6l/2DW69rx9
         qnGUIhTp2cNrT04O4VFoTA/MnANjc8FiUOJ8zwPXEp7ab39hVWIXqykz1GKOZD8VEabA
         zuSTZbSqiW91mcx5Ig3o6yq0fOVCscCgzthjm3lxwGoTAxQsBMLm0YgRiznE/4DzUfp+
         ZjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W2jNNrY5/QqqeiRWH7nZnuZClY2AmttMrv8jp57V4/w=;
        b=YL6rdOZhvPofCdN6RHuEE1dHgZBEkuKBFBEf2pafBVfQKis8T/IZNgHS/fWUz7SwbX
         o8aKLsMWucnf5sq6u9oNqsUYEM+wDJnxDCT+OwYfQ8cckslP2XSzhDsSf9jRysW+gdWg
         bNUZdMUQBJ/IZCYSAqQYqhB0emT4yjZkY4uFcNoC+yZ+QvirPemY4IMLdRG/gZJ0AW73
         QtT8rpOzXAYdHLsFwfdbP0CEd5m1AiEmk/EV0tTXZ9PUz1VRCxISlw+jXwhh1KAw7y4x
         iIcnj9BZwZL3dHVd3p1+uUOYVnTS28eLsbz4ZZ3yNDndoQuBTukOrXubOQVwPs3GEte3
         6AJg==
X-Gm-Message-State: AOAM5314ut7p8a8FDnVE4JUNw9YOcHg7k1q69UHjPGXt+EdKuj5gLjr6
        O4hRQyXNGHeVMEayYwDuW9+vfTp6KU2IPQ==
X-Google-Smtp-Source: ABdhPJypxEuh6WtA5VNZqtbYlP5EeN0s1JDPmZ24cEAD3aEaGr0L94pHRh2Xsl2kM8SPQAbBmMs6sw==
X-Received: by 2002:a17:902:d4c5:b0:150:20c7:78bd with SMTP id o5-20020a170902d4c500b0015020c778bdmr6095138plg.25.1645809395246;
        Fri, 25 Feb 2022 09:16:35 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id l71-20020a63914a000000b0036c4233875dsm3160287pge.64.2022.02.25.09.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 09:16:34 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next] ionic: no transition while stopping
Date:   Fri, 25 Feb 2022 09:16:18 -0800
Message-Id: <20220225171618.31733-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we don't try to transition the fw_status_ready
while we're still in the FW_STOPPING state, else we can
get stuck in limbo waiting on a transition that already
happened.

While we're here we can remove a superfluous check on
the lif pointer.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index faeedc8db6f4..9d0514cfeb5c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -202,21 +202,25 @@ int ionic_heartbeat_check(struct ionic *ionic)
 		}
 	}
 
+	dev_dbg(ionic->dev, "fw_status 0x%02x ready %d idev->ready %d last_hb 0x%x state 0x%02lx\n",
+		fw_status, fw_status_ready, idev->fw_status_ready,
+		idev->last_fw_hb, lif->state[0]);
+
 	/* is this a transition? */
-	if (fw_status_ready != idev->fw_status_ready) {
+	if (fw_status_ready != idev->fw_status_ready &&
+	    !test_bit(IONIC_LIF_F_FW_STOPPING, lif->state)) {
 		bool trigger = false;
 
 		idev->fw_status_ready = fw_status_ready;
 
-		if (!fw_status_ready && lif &&
+		if (!fw_status_ready &&
 		    !test_bit(IONIC_LIF_F_FW_RESET, lif->state) &&
 		    !test_and_set_bit(IONIC_LIF_F_FW_STOPPING, lif->state)) {
 			dev_info(ionic->dev, "FW stopped 0x%02x\n", fw_status);
 			trigger = true;
 
-		} else if (fw_status_ready && lif &&
-			   test_bit(IONIC_LIF_F_FW_RESET, lif->state) &&
-			   !test_bit(IONIC_LIF_F_FW_STOPPING, lif->state)) {
+		} else if (fw_status_ready &&
+			   test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
 			dev_info(ionic->dev, "FW running 0x%02x\n", fw_status);
 			trigger = true;
 		}
-- 
2.17.1

