Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E64934A7D4
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 14:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhCZNKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 09:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhCZNKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 09:10:05 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615D7C0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:10:03 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w18so6314981edc.0
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqXIl3nwtcXjCwONbLFI8a44o/exKSenAY5upZa6Mis=;
        b=L7QKC6rpbss6E/VmgvGb+h8f37syWflsXOcaBGGdqAvjviyJJknjurnRGw1bqzFhFx
         NMGBo7a+E+x2KJvqUWT4Nxkpsh5GPIKN2l1Atp4ltYH6152OQbdXZ1srmeHC0kbD7d5U
         NINNgll8lTGxtvgtsuEiEh23p6/SQL5rQAZ/s5jYW3ZUwZbPuK8FfM5neVTjLjFou+ID
         clzpbMoeyOCNzuoVhjZ8ZoVZtFL4ofmXu77SJmdMobpX953czONiSL64jOGCE2HP5XFj
         /Y7jH53Ta2TYz44o3/xrB+QD91UJ7tE7TUO3mjrNIwGay0m63LCtJxWDA+KAhvItB12+
         Hrfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqXIl3nwtcXjCwONbLFI8a44o/exKSenAY5upZa6Mis=;
        b=U5SXLNivX0IXdeVyVyGMi2uOeqZ3AHL/1ramF9m0tOQMpHgSLww/K0mUD+HAYe04YJ
         nZbuTwIWqEL+4wm1drdOpezv/dGxY7Xwj8KqMlRKFEzW9lYjJO4cd0yzDS2cxNoIPCo/
         kzbuiZsqpZ8jISYuF6cd6bIUcxp5EFuD5uxdyChtX7+B+weMJ6CxDqfDwzD5kpbtnudB
         IxZom2psPGUG2W1chmv6WMgz5n2HJ+O+3c4GB15hcNpESqQ4eNrEnVdK2o7c2dnaHqYj
         lAHGPP++WxkNvqrf8QBdqXsutOrSgWohAhSxreSuOGUqBKioZ5CsMN8JhdcZaMPTXe+S
         kjNQ==
X-Gm-Message-State: AOAM530daXouDemLl4LUWIDTpB41ul0Ba3g2Fr9agW2UUTobXo2yI0wo
        GxhYwLBz8pPHKMWhSK1NHne0tQ==
X-Google-Smtp-Source: ABdhPJwkp0DOilUwvwPGWoiKsEEblhE1NcqzRA0XV/S8opzUTIFU7PjE8PV9kki02FMf8vE65nS3SA==
X-Received: by 2002:a05:6402:278d:: with SMTP id b13mr2391878ede.34.1616764202178;
        Fri, 26 Mar 2021 06:10:02 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id 90sm4202624edf.31.2021.03.26.06.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 06:10:00 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Ido Schimmel <idosch@idosch.org>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 1/2] selftests: tc-testing: add action police selftest for packets per second
Date:   Fri, 26 Mar 2021 14:09:37 +0100
Message-Id: <20210326130938.15814-2-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210326130938.15814-1-simon.horman@netronome.com>
References: <20210326130938.15814-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add selftest cases in action police for packets per second.
These tests depend on corresponding iproute2 command support.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
It is also planned, as a follow-up, to provide packet per second rate
limiting tests in tools/testing/selftests/net/forwarding/tc_police.sh
---
 .../tc-testing/tc-tests/actions/police.json   | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
index b8268da5adaa..8e45792703ed 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
@@ -764,5 +764,53 @@
         "teardown": [
             "$TC actions flush action police"
         ]
+    },
+    {
+        "id": "cdd7",
+        "name": "Add valid police action with packets per second rate limit",
+        "category": [
+            "actions",
+            "police"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action police",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action police pkts_rate 1000 pkts_burst 200 index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions ls action police",
+        "matchPattern": "action order [0-9]*:  police 0x1 rate 0bit burst 0b mtu 4096Mb pkts_rate 1000 pkts_burst 200",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action police"
+        ]
+    },
+    {
+        "id": "f5bc",
+        "name": "Add invalid police action with both bps and pps",
+        "category": [
+            "actions",
+            "police"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action police",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action police rate 1kbit burst 10k pkts_rate 1000 pkts_burst 200 index 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions ls action police",
+        "matchPattern": "action order [0-9]*:  police 0x1 ",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action police"
+        ]
     }
 ]
-- 
2.20.1

