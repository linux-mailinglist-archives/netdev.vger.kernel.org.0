Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC1945D302
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhKYCPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhKYCN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 21:13:27 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94EDC061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 17:54:44 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x5so4418597pfr.0
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 17:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tusDP2BWvK1v21tD7mnz4MjDMfYiIMqrTwlsHlf0oPk=;
        b=NxBvjk4YZgbURshPBdW0zvr9tjiylGT/pp4HzBIv0w7FSQ8MJpLcExqGn1rHoCToMN
         yoxQxn4wTRhwakzkw7yCqKThuiiVUzai07KHdfBsAYtchmYud5Ycq9qhLZndPoc3Vexi
         d6ufudVBHeJE9bI7soWzYm3JLGXBnxWUQadfNkpv/i+OLbu6m2HaT/PspAVHrIkWvXGZ
         bpYpc/AEkkZUWm1ouGuTjKbwi0QLQpI/jm0WcA3b8OVm5at7vzZpjnUsMePzTsf0si2g
         TVXJkvLYsFlTdf8etIG9DH4/u6nW8aluedMA3zqT0pyYv7apGU7Tyzwoo4lo1Vu9LpwL
         yO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tusDP2BWvK1v21tD7mnz4MjDMfYiIMqrTwlsHlf0oPk=;
        b=E2XVXlBjkcLYuaQtFKVuMn7yjyzEQKTmyRQwisukJb0m2CYDt1QvwZoWuO6LNoaTIX
         NgOssfOKNNa0p+0769DVKaZJDsW7Qc3CVdsmEbkS6hyTPrm/jkhlQl5mstU33LgLh9cW
         wclkyud4b4kq7mbPqiPkb2DCaNQFgX8xkuieFmxoYbPVddXuOb//Xb0VnJdrAWrIrW0R
         Ww9LPY1dOrK78ZbZmh5IcTW/wFOddvIqhjz1pYHQIPR4DB96Dtpi9+kfT9FsTjtgp4ak
         1RUmwX54eFxGUz/vDWsEkO3p3t4rpa8fT9hp1HLNC/0indEInCad01/5jCEizo6EUgqG
         ecCA==
X-Gm-Message-State: AOAM531lgFDBN1bqdAScHTU335LzJUN/cleKOpOdIXqKx8wfbK6vSPiX
        5uZQ4RJ/9kreO+fVwl/15lvf0atJqtg=
X-Google-Smtp-Source: ABdhPJyMCeSF8pazmdlapasKRMqhQYm53AAJKiX8yYQikJY+j5nfBfei4lEB33yii8KsjbKUvs7LPw==
X-Received: by 2002:a05:6a00:1584:b0:49f:e5dd:f904 with SMTP id u4-20020a056a00158400b0049fe5ddf904mr11185564pfk.55.1637805284063;
        Wed, 24 Nov 2021 17:54:44 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id g7sm995072pfv.159.2021.11.24.17.54.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 17:54:43 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] veth: use ethtool_sprintf instead of snprintf
Date:   Thu, 25 Nov 2021 09:54:38 +0800
Message-Id: <20211125015438.5355-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

use ethtools api ethtool_sprintf to instead of snprintf.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/veth.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 5ca0a899101d..d1c3a3ff4928 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -134,7 +134,7 @@ static void veth_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *inf
 
 static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 {
-	char *p = (char *)buf;
+	u8 *p = buf;
 	int i, j;
 
 	switch(stringset) {
@@ -142,20 +142,14 @@ static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 		memcpy(p, &ethtool_stats_keys, sizeof(ethtool_stats_keys));
 		p += sizeof(ethtool_stats_keys);
 		for (i = 0; i < dev->real_num_rx_queues; i++) {
-			for (j = 0; j < VETH_RQ_STATS_LEN; j++) {
-				snprintf(p, ETH_GSTRING_LEN,
-					 "rx_queue_%u_%.18s",
-					 i, veth_rq_stats_desc[j].desc);
-				p += ETH_GSTRING_LEN;
-			}
+			for (j = 0; j < VETH_RQ_STATS_LEN; j++)
+				ethtool_sprintf(&p, "rx_queue_%u_%.18s",
+						i, veth_rq_stats_desc[j].desc);
 		}
 		for (i = 0; i < dev->real_num_tx_queues; i++) {
-			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
-				snprintf(p, ETH_GSTRING_LEN,
-					 "tx_queue_%u_%.18s",
-					 i, veth_tq_stats_desc[j].desc);
-				p += ETH_GSTRING_LEN;
-			}
+			for (j = 0; j < VETH_TQ_STATS_LEN; j++)
+				ethtool_sprintf(&p, "tx_queue_%u_%.18s",
+						i, veth_tq_stats_desc[j].desc);
 		}
 		break;
 	}
-- 
2.27.0

