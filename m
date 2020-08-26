Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D38252675
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 07:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgHZFJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 01:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgHZFJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 01:09:13 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B1CC061756
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b17so436938wru.2
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9bDWg/FP1jtTcu1lDgXHupN7xhFpM/ajUxrTrUXtDf4=;
        b=dWDJ6CJjmu6ComBxdDmXheVh109X1o35Vbh11yIyVoWwgw9ehXiD0ZEzTB7FHRtZmJ
         VVXgKFXvHaeTMYrLyFZ8R7aERaE4V/dnSECiHZaINuEMxXFfGCgiO0WwX5TP4BjajzvK
         NynD1t+Djbk7PcDlJmRG16w2LzVfnY25UskQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9bDWg/FP1jtTcu1lDgXHupN7xhFpM/ajUxrTrUXtDf4=;
        b=ZpUWrs6cDQQ4SjLH+T28miJaKDf+Rd/9qEgQgV+Q8Xb3O86ZDIw/7O8X4N2TjQUit5
         nqNV67pZAlNhHHSt72gv9IWKvyvezBhivcYkJE0upZFmcWA+nvNw3AlRCufFvkbMH+o9
         ysXExjfNmiVnSvJRGfcUP7RPcV479aeI0LXDrxccRPd2Kdr23L7S3sjfb7mjI4AzwKXc
         5RnV3hpvvpDfiAFh+kRfcibguey7k5QW5UVizhG8GVR9iguEIYHOkopNfH2CynAULAFj
         NMGY96giBfRbOhkVuMmlovy0MZRiKahszeIe0DezdbsLK+wetPBiUJkMmxir1u913wZN
         r99g==
X-Gm-Message-State: AOAM531AzjvzRR22TsVV96+vtGAREHvr06mLa6Lw1hOjO/XxEjqk1PAQ
        zObO4UZajYCpNW0bW/K7t+TbzDO/OS6yhg==
X-Google-Smtp-Source: ABdhPJzDSfvCiW5ElnTbwW8Sxx7X30M7WoaB+L2Y9txkfwUDfLXtyckR5O2hC4ZtFqivHae9cDjhCQ==
X-Received: by 2002:a5d:4907:: with SMTP id x7mr14620364wrq.166.1598418551879;
        Tue, 25 Aug 2020 22:09:11 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm2825832wrm.39.2020.08.25.22.09.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2020 22:09:11 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Edwin Peer <edwin.peer@broadcom.com>,
        Marc Smith <msmith626@gmail.com>
Subject: [PATCH net 6/8] bnxt_en: fix HWRM error when querying VF temperature
Date:   Wed, 26 Aug 2020 01:08:37 -0400
Message-Id: <1598418519-20168-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
References: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

Firmware returns RESOURCE_ACCESS_DENIED for HWRM_TEMP_MONITORY_QUERY for
VFs. This produces unpleasing error messages in the log when temp1_input
is queried via the hwmon sysfs interface from a VF.

The error is harmless and expected, so silence it and return unknown as
the value. Since the device temperature is not particularly sensitive
information, provide flexibility to change this policy in future by
silencing the error rather than avoiding the HWRM call entirely for VFs.

Fixes: cde49a42a9bb ("bnxt_en: Add hwmon sysfs support to read temperature")
Cc: Marc Smith <msmith626@gmail.com>
Reported-by: Marc Smith <msmith626@gmail.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d6f3592..a23ccb0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9289,16 +9289,19 @@ static ssize_t bnxt_show_temp(struct device *dev,
 	struct hwrm_temp_monitor_query_input req = {0};
 	struct hwrm_temp_monitor_query_output *resp;
 	struct bnxt *bp = dev_get_drvdata(dev);
-	u32 temp = 0;
+	u32 len = 0;
 
 	resp = bp->hwrm_cmd_resp_addr;
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_TEMP_MONITOR_QUERY, -1, -1);
 	mutex_lock(&bp->hwrm_cmd_lock);
-	if (!_hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT))
-		temp = resp->temp * 1000; /* display millidegree */
+	if (!_hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT))
+		len = sprintf(buf, "%u\n", resp->temp * 1000); /* display millidegree */
 	mutex_unlock(&bp->hwrm_cmd_lock);
 
-	return sprintf(buf, "%u\n", temp);
+	if (len)
+		return len;
+
+	return sprintf(buf, "unknown\n");
 }
 static SENSOR_DEVICE_ATTR(temp1_input, 0444, bnxt_show_temp, NULL, 0);
 
-- 
1.8.3.1

