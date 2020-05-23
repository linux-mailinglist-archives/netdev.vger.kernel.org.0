Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427EE1DF527
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387674AbgEWGLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387446AbgEWGLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 02:11:08 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEECC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 23:11:08 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a5so5935463pjh.2
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 23:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oDjF/MVSQ+SrxV5GE4Nj15DEJvCkLM9knUvqUOkxARs=;
        b=DUkQj1s+mTcUrNdgol/vJcNDqLzPzlyoZ6NNuxYu+S0YYWSjyU5M6gma+eQWRIZQVB
         06L3km/smgB/fps8asK9E6Fx4EHMNxh7J34ee5Bx2JJIgbUX8Z+pokAflytFCh1ymcBI
         ntoiySNVSiakS+75Pfu2toAkLPcOnhsH0rC+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oDjF/MVSQ+SrxV5GE4Nj15DEJvCkLM9knUvqUOkxARs=;
        b=bX2dKEXlpfYK4ygfRaHcnMJuuPnrMQr3XameGY34z1dcruv7ojqCzuMgz/FWkvbKx0
         8j4OTYKS4Cro9yoVN5LcHBLXXpMvOJ3t3AxCowsA0e7e9kGY7VyLEzEFk60QVgqNkBG2
         oOruGAiMmk8Hbz8eJas2JSNM36MFLI20/9Zs8rl4ylslTmFPVshAQ5Ur0aTHnZL34WEK
         Zm4EalF/wnjxIEEGPPLWsIqY1TnSgyqZl3W771Ld5/H7DjyM9lRHUwolwtvAXy6nnho3
         oqDnkySSMZf3Vai1tTwOuzpCIWIjx2biIKPaWvBJ+7QFFy1UecLDJ8/bdyQDaQuw65O+
         ll9g==
X-Gm-Message-State: AOAM533AzuR4Djb11DLplNNB8Assi/XXiv41avgD4np4Y2AtxAabxrsF
        gCocsoTTWFamySeGtaOJJig5Mg==
X-Google-Smtp-Source: ABdhPJzDMU1g9Bpd1u5/19MhWuUdrg07go1oj9lUtXtmLKOfQvhQp2cORCb32O6Iais66g/PTvjk3A==
X-Received: by 2002:a17:90a:8989:: with SMTP id v9mr9016405pjn.180.1590214268194;
        Fri, 22 May 2020 23:11:08 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 1sm8455414pff.180.2020.05.22.23.11.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 May 2020 23:11:07 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v2 net-next 4/4] bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET
Date:   Sat, 23 May 2020 11:38:25 +0530
Message-Id: <1590214105-10430-5-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If device does not allow fw_live_reset, issue FW_RESET command
without graceful flag, which requires a driver reload to reset
the firmware.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
---
v2: Rephrase the subject and elaborate commit message
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index dd0c3f2..e5eb8d2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1888,12 +1888,11 @@ static int bnxt_firmware_reset(struct net_device *dev,
 	return bnxt_hwrm_firmware_reset(dev, proc_type, self_reset, flags);
 }
 
-static int bnxt_firmware_reset_chip(struct net_device *dev)
+static int bnxt_firmware_reset_chip(struct net_device *dev, bool hot_reset)
 {
-	struct bnxt *bp = netdev_priv(dev);
 	u8 flags = 0;
 
-	if (bp->fw_cap & BNXT_FW_CAP_HOT_RESET)
+	if (hot_reset)
 		flags = FW_RESET_REQ_FLAGS_RESET_GRACEFUL;
 
 	return bnxt_hwrm_firmware_reset(dev,
@@ -3082,7 +3081,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 static int bnxt_reset(struct net_device *dev, u32 *flags)
 {
 	struct bnxt *bp = netdev_priv(dev);
-	bool reload = false;
+	bool reload = false, hot_reset;
 	u32 req = *flags;
 
 	if (!req)
@@ -3093,8 +3092,10 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 		return -EOPNOTSUPP;
 	}
 
-	if (pci_vfs_assigned(bp->pdev) &&
-	    !(bp->fw_cap & BNXT_FW_CAP_HOT_RESET)) {
+	if (bnxt_hwrm_get_hot_reset(bp, &hot_reset))
+		hot_reset = !!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET);
+
+	if (pci_vfs_assigned(bp->pdev) && !hot_reset) {
 		netdev_err(dev,
 			   "Reset not allowed when VFs are assigned to VMs\n");
 		return -EBUSY;
@@ -3103,9 +3104,9 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 	if ((req & BNXT_FW_RESET_CHIP) == BNXT_FW_RESET_CHIP) {
 		/* This feature is not supported in older firmware versions */
 		if (bp->hwrm_spec_code >= 0x10803) {
-			if (!bnxt_firmware_reset_chip(dev)) {
+			if (!bnxt_firmware_reset_chip(dev, hot_reset)) {
 				netdev_info(dev, "Firmware reset request successful.\n");
-				if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET))
+				if (!hot_reset)
 					reload = true;
 				*flags &= ~BNXT_FW_RESET_CHIP;
 			}
-- 
1.8.3.1

