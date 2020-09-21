Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C04A2718EB
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 03:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgIUBJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 21:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgIUBJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 21:09:22 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C206C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:22 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q4so6525170pjh.5
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rUPXZxRAsOrdjtI8FJ/7PvDPSOQH23Sj2mLwzIQCB9E=;
        b=PoA65iQM3R5AhGSjf3x/1AGi3xqOhrHX+tVFv11GNAksr51yeCTXYaYeOykn0lMfQT
         KACkZhhdVn1BRp3Sx0S5lDMZTm+EMvaMRo21aaLVBrBxBe05N4mhd1Ic2WdOh5bams49
         dvdzpTTzi5JVTY8vQDrQHUWVyhs1Vx68g7TiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rUPXZxRAsOrdjtI8FJ/7PvDPSOQH23Sj2mLwzIQCB9E=;
        b=fVMvyQrxG9mJ5dJdkptqrYG3M3mdADs54KM/occ0YZ5fOSY5JI7+j1IcbV/O1ASx+K
         CmvXOY6SZcpGkIfCimhqwTbwpMo2ksEUYoeYAWKfJ/F35b7nkmo/IVgK6notMWOhWc3A
         /XjRKoHtS2JR9kltGWC2sQwDPwAsti7wr7g8VFbnkHQ6Hqzej9UKdpKBuMUtea/OOKYZ
         cUqpOFbyTqJkMxKvi2YA3yTw5fipkeK3mISHKiFCuYo+zrzPrLL25luXOXL7NuXjPSC/
         o3AaJcFJFDtFgt0zMdbrkTM5wnzj0bvh25l+BFTy0iiALR6/c3RnduBvp8g980OeffwX
         gI/Q==
X-Gm-Message-State: AOAM5328uAqUInl0MZsWeQV2t2dHydcDKAXpN42NCesYDShIqQe29dZk
        Ma35Z5vP+R+bw25VstOO2w/ZLg==
X-Google-Smtp-Source: ABdhPJwqnx7eYoqe1bY+/SwJ1EqSorVD9AN/XzlRa19OsCAjTDjjTyymdEzwBLM4rTMdfSdiLA1X+Q==
X-Received: by 2002:a17:90a:ee0d:: with SMTP id e13mr23878138pjy.227.1600650561366;
        Sun, 20 Sep 2020 18:09:21 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bt13sm9098095pjb.23.2020.09.20.18.09.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 18:09:20 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net 2/6] bnxt_en: return proper error codes in bnxt_show_temp
Date:   Sun, 20 Sep 2020 21:08:55 -0400
Message-Id: <1600650539-19967-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
References: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

Returning "unknown" as a temperature value violates the hwmon interface
rules. Appropriate error codes should be returned via device_attribute
show instead. These will ultimately be propagated to the user via the
file system interface.

In addition to the corrected error handling, it is an even better idea to
not present the sensor in sysfs at all if it is known that the read will
definitely fail. Given that temp1_input is currently the only sensor
reported, ensure no hwmon registration if TEMP_MONITOR_QUERY is not
supported or if it will fail due to access permissions. Something smarter
may be needed if and when other sensors are added.

Fixes: 12cce90b934b ("bnxt_en: fix HWRM error when querying VF temperature")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4af42b1..2865e24 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9311,18 +9311,16 @@ static ssize_t bnxt_show_temp(struct device *dev,
 	struct hwrm_temp_monitor_query_output *resp;
 	struct bnxt *bp = dev_get_drvdata(dev);
 	u32 len = 0;
+	int rc;
 
 	resp = bp->hwrm_cmd_resp_addr;
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_TEMP_MONITOR_QUERY, -1, -1);
 	mutex_lock(&bp->hwrm_cmd_lock);
-	if (!_hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT))
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (!rc)
 		len = sprintf(buf, "%u\n", resp->temp * 1000); /* display millidegree */
 	mutex_unlock(&bp->hwrm_cmd_lock);
-
-	if (len)
-		return len;
-
-	return sprintf(buf, "unknown\n");
+	return rc ?: len;
 }
 static SENSOR_DEVICE_ATTR(temp1_input, 0444, bnxt_show_temp, NULL, 0);
 
@@ -9342,7 +9340,16 @@ static void bnxt_hwmon_close(struct bnxt *bp)
 
 static void bnxt_hwmon_open(struct bnxt *bp)
 {
+	struct hwrm_temp_monitor_query_input req = {0};
 	struct pci_dev *pdev = bp->pdev;
+	int rc;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_TEMP_MONITOR_QUERY, -1, -1);
+	rc = hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc == -EACCES || rc == -EOPNOTSUPP) {
+		bnxt_hwmon_close(bp);
+		return;
+	}
 
 	if (bp->hwmon_dev)
 		return;
-- 
1.8.3.1

