Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2091757CF
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 10:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgCBJ7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 04:59:15 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42245 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgCBJ7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 04:59:14 -0500
Received: by mail-pf1-f195.google.com with SMTP id f5so356206pfk.9
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 01:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SFs2o+bvKQWOTGWSBaaZRNWv/2SevACLLTSC4CVuF9o=;
        b=k+9zn7AmFOXHVDt0ZlwNdNu7vwB/lBRCHcXZ9uVbne/C37S7nvS/jxOzZwDCqdi3PY
         nrY9LagL+MxcmajVx32FxZ5KT4+pVZzGEJDDqVH/EK9+twZxCs5kphIB+KrHhP12bWBE
         5aaGwQNQIBm7MDoYqEiGGrI2Sq8KtfUsPZ93g74EF8UM6nwLfG9Fq9x/u5MQxsu/HjoB
         a5yEQiES8XhfzJhltxXaxWhXK4t0tzE69M150Woe41FvK/Kh5PHskpmSZ/BUwpnvii/O
         5Rk5OVTEMRfrbWIwMF2O7YsnnxjArwi5nYfm0F0ZXXEhzR3tyRTCXl1D5654wVCf0iWc
         xQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SFs2o+bvKQWOTGWSBaaZRNWv/2SevACLLTSC4CVuF9o=;
        b=BBqtJRouDmbfkYV+zEfdKKc8YW0LtlaXvzAKTRKzWRMon85cnVPPENjrPUkBliIozX
         F7GDOlAoBGXCU8QjKRX55h88WTk1Vt2tL6EBDC3/f/MotLjS67orR7Edd56YApafeZmv
         JvU2YvHA2F2SQJA1d3lFMWxzoG/8T1Ux1KeSHwHsGYwIOlzIti4q9825PH0VE1aOAQS2
         v1U8Si1fY4mX48rWt9agcxU+mMZ3g9e6R4488T9T72C/vISegnaIsMSir0BQkyYa4NzE
         9t5GL2vOXb6y3DJ3POPYqiOLm/NSslTtR5qbxp1UMKxr89Z2cBE6K4ew4s00TjAm+nOl
         DPDQ==
X-Gm-Message-State: ANhLgQ1n+raTT+oI3wXPL/3qDv+r3VLQAn8aTz69Vg38xDO1EltGtyPb
        2/H12zrG7K/2fHJMvN2cDjWWTB0AUtE=
X-Google-Smtp-Source: ADFU+vuWiV2cy/sd6/DioX7sh81e7bOOoM3AFV8Wt/rPrvFOdWwstsKJ+6HpFMbubpuv066hEQp5JA==
X-Received: by 2002:aa7:96ed:: with SMTP id i13mr6114798pfq.147.1583143153831;
        Mon, 02 Mar 2020 01:59:13 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id z13sm20564307pge.29.2020.03.02.01.59.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 02 Mar 2020 01:59:13 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 2/3] net: thunderx: Reduce mbox wait response time.
Date:   Mon,  2 Mar 2020 15:29:01 +0530
Message-Id: <1583143142-7958-3-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583143142-7958-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583143142-7958-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Replace msleep() with usleep_range() as internally it uses hrtimers.
This will put a cap on maximum wait time.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 0169572..b4b3336 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -126,8 +126,7 @@ static void nicvf_write_to_mbx(struct nicvf *nic, union nic_mbx *mbx)
 
 int nicvf_send_msg_to_pf(struct nicvf *nic, union nic_mbx *mbx)
 {
-	int timeout = NIC_MBOX_MSG_TIMEOUT;
-	int sleep = 10;
+	unsigned long timeout;
 	int ret = 0;
 
 	mutex_lock(&nic->rx_mode_mtx);
@@ -137,6 +136,7 @@ int nicvf_send_msg_to_pf(struct nicvf *nic, union nic_mbx *mbx)
 
 	nicvf_write_to_mbx(nic, mbx);
 
+	timeout = jiffies + msecs_to_jiffies(NIC_MBOX_MSG_TIMEOUT);
 	/* Wait for previous message to be acked, timeout 2sec */
 	while (!nic->pf_acked) {
 		if (nic->pf_nacked) {
@@ -146,11 +146,10 @@ int nicvf_send_msg_to_pf(struct nicvf *nic, union nic_mbx *mbx)
 			ret = -EINVAL;
 			break;
 		}
-		msleep(sleep);
+		usleep_range(8000, 10000);
 		if (nic->pf_acked)
 			break;
-		timeout -= sleep;
-		if (!timeout) {
+		if (time_after(jiffies, timeout)) {
 			netdev_err(nic->netdev,
 				   "PF didn't ACK to mbox msg 0x%02x from VF%d\n",
 				   (mbx->msg.msg & 0xFF), nic->vf_id);
-- 
2.7.4

