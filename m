Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4705A315
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfF1SEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:04:12 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:41214 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfF1SEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:04:08 -0400
Received: by mail-pg1-f175.google.com with SMTP id q4so1444456pgj.8
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ApmZXafCUEjqzGjBsTGqzfGYPcU7eaem06UHJ+aJ9OE=;
        b=dqroHn/UeM/vOLBHYzg1KPgBgefGk9YNT0UVp46yqQYLR6G4Lnn52OprXyXQ0lXCrh
         hvKtqhnp4xT9qo33+Lj0v9Wok5Xd7i/snDBkk6fjWpaIYPBv9mvLuTeClCLHZM3dX61U
         4nZgVGYyI0zAApI7y/1jAzW86F5OII3hd7sxqlQfL3WTBRh7WzUs/PhoeD3zoc0jC34G
         crAKU8pLE3kGBqrqitdREgtxvBgs6tLAzbFOsIsAfdPuq+NC5+JGc1eHky09p4Puhrve
         Nr1nW+xZxBmYzd4QShdoI0aLQ+q/E/Se3bdJrd5bHtPCjp5o0mpqLYTh/0FixbPbOi+J
         p7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ApmZXafCUEjqzGjBsTGqzfGYPcU7eaem06UHJ+aJ9OE=;
        b=ezR8te5HyW24QtJ1s6AQkbEHSRK8cpda1cBqotfTOIMUiexkew55E4t3um1M3X6PA/
         lt+XIko4RPvX9I8gUXoFHWmeqcQQMYXPFh1bcnJz15u5cR6VCKvcBZY6CsmoE6hm8sPv
         dc/ZFOIQC5nUqxeTUeCAmrVFX2qxISf6AmfHODp5tkCpTX1YwlGwcU4gDBPhP4HjvcHZ
         wNh+m+welJyQz9SfyeVmmv9MIX4yF9goiRY+tpcsfeiUSMtW4ARNd9k1jFcEBLrPznCT
         XarUNW4+C9FExvPhm5SYGI3SboVOo9rNLF07V4dzvHGoITyVmlYc5S6vYwy3vO7qo7+h
         0xhQ==
X-Gm-Message-State: APjAAAXUasUVansVyfFpd8i1gLBNqUu4skBnJSLSAyVudaf4yZzV8N0+
        Xf2Luwcohxa4ysFuPMqWU/C/0jT2/Fc=
X-Google-Smtp-Source: APXvYqx5wjPqjU1OgofW4xDlz4R7cVwg8ssro/4WjwpT8rtNnWIuU6cwjEjBunIulyTf7YU5jUWtrA==
X-Received: by 2002:a17:90a:bb8b:: with SMTP id v11mr14543359pjr.64.1561745046973;
        Fri, 28 Jun 2019 11:04:06 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id d6sm2175919pgv.4.2019.06.28.11.04.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:04:06 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dcaratti@redhat.com, chrism@mellanox.com, willy@infradead.org,
        Li Shuang <shuali@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net 3/3] selftests: add a test case for cls_lower handle overflow
Date:   Fri, 28 Jun 2019 11:03:43 -0700
Message-Id: <20190628180343.8230-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190628180343.8230-1-xiyou.wangcong@gmail.com>
References: <20190628180343.8230-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 .../tc-testing/tc-tests/filters/tests.json    | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
index e2f92cefb8d5..16559c436f21 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
@@ -38,6 +38,25 @@
             "$TC qdisc del dev $DEV1 clsact"
         ]
     },
+    {
+        "id": "2ff3",
+        "name": "Add flower with max handle and then dump it",
+        "category": [
+            "filter",
+            "flower"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV2 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 parent ffff: handle 0xffffffff flower action ok",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV2 ingress",
+        "matchPattern": "filter protocol ip pref 1 flower.*handle 0xffffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV2 ingress"
+        ]
+    },
     {
         "id": "d052",
         "name": "Add 1M filters with the same action",
-- 
2.21.0

