Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863F46E99E9
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjDTQuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjDTQuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:50:16 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF244691
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:50:12 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-187b70ab997so5943789fac.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682009409; x=1684601409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/7fpClabt1h4pcpC7HxEyBgNGm9OTr9vYERAOjx5rc=;
        b=UAFL1ZXG2vVX4JKyvW/eFhG3uLZOYmMJ2Y3Vlpou+DsRC+oCUx5Qpx3CKDbGtbbZcH
         IftH0WubSAmF7Qr1MKASpaMvHY57BUXc0f1MfuSka3N3msqkQgoziFQZbNSqVDoTThlg
         O+p7g0oTHOg5Waj7DR4vJF/Fm91e51p8Z//5SShNLvVdS0i5cDeh9iG3LYFYC7E4v3BQ
         BfTwM0qSdtehp4e+xE1RtNGODTUfRUvCt6SwIy+ZH/xPDBRQgdtVb9jbBKzK0Di7SUfG
         WP9oWfdFqus1gH67qot8cYncRicskDzfCEcbPmygwT7i+g9AS6HQ3FRr+q+/DZeJ4VtN
         aTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682009409; x=1684601409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p/7fpClabt1h4pcpC7HxEyBgNGm9OTr9vYERAOjx5rc=;
        b=b9etZ1r0jGfK2nEnP1Z7fOwt7pw14Styaug/MhbLNQ3n43ZPkgI2jh88JOs1mtyj2V
         MAFouBlFmiSVMqODcpz0V9pOH0LqwzJmacCQ5RKVBNwfPnM4+bpzmS9Zjae8Y9MLOVWi
         r0za54bH/aqXnVkppiioNi8in3XGFsM1vUdg75dg1WoTumBUu71WDjyLwTadvzF04E41
         n5UaIj4Ms12qn3ObGSM0y6lhR7fgIifwF+3V97vwPRdQiZEUBtGa49siPfkzvsPc7mvH
         SCm2Sddfg3Cp/742HIfdZi6TlpRz0TvmXO0i78zJG1dLGcWmUqZBk8TrAeFAay2xlQnb
         WoTw==
X-Gm-Message-State: AAQBX9eaaDjms4TXSbUVJt9iSzWg10GtPFRk1KmgCRxW13TM5Z6dQXur
        gKE7jXM62mAUiZn0/kdHV0X0Z1PCYFsZKYzyQEs=
X-Google-Smtp-Source: AKy350Z5+e7baaV/1ROqBa9ykfVEA641rwuwdKHT6kodeMpiTWjNoekrywx87q5qL8MP0GxashD+Fg==
X-Received: by 2002:a05:6830:32b8:b0:6a5:dd70:38d0 with SMTP id m56-20020a05683032b800b006a5dd7038d0mr1017235ott.12.1682009409422;
        Thu, 20 Apr 2023 09:50:09 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7668:3bb3:e9e3:6d75])
        by smtp.gmail.com with ESMTPSA id p26-20020a9d695a000000b006a13dd5c8a2sm894542oto.5.2023.04.20.09.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 09:50:09 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 4/5] selftests: tc-testing: add more tests for sch_qfq
Date:   Thu, 20 Apr 2023 13:49:27 -0300
Message-Id: <20230420164928.237235-5-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420164928.237235-1-pctammela@mojatatu.com>
References: <20230420164928.237235-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The QFQ qdisc class has parameter bounds that are not being
checked for correctness.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 .../tc-testing/tc-tests/qdiscs/qfq.json       | 72 +++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/qfq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/qfq.json
index 330f1a25e0ab..147899a868d3 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/qfq.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/qfq.json
@@ -46,6 +46,30 @@
             "$IP link del dev $DUMMY type dummy"
         ]
     },
+    {
+        "id": "d364",
+        "name": "Test QFQ with max class weight setting",
+        "category": [
+            "qdisc",
+            "qfq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root qfq"
+        ],
+        "cmdUnderTest": "$TC class add dev $DUMMY parent 1: classid 1:1 qfq weight 9999",
+        "expExitCode": "2",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class qfq 1:1 root weight 9999 maxpkt",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
     {
         "id": "8452",
         "name": "Create QFQ with class maxpkt setting",
@@ -70,6 +94,54 @@
             "$IP link del dev $DUMMY type dummy"
         ]
     },
+    {
+        "id": "22df",
+        "name": "Test QFQ class maxpkt setting lower bound",
+        "category": [
+            "qdisc",
+            "qfq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root qfq"
+        ],
+        "cmdUnderTest": "$TC class add dev $DUMMY parent 1: classid 1:1 qfq maxpkt 128",
+        "expExitCode": "2",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class qfq 1:1 root weight 1 maxpkt 128",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "92ee",
+        "name": "Test QFQ class maxpkt setting upper bound",
+        "category": [
+            "qdisc",
+            "qfq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root qfq"
+        ],
+        "cmdUnderTest": "$TC class add dev $DUMMY parent 1: classid 1:1 qfq maxpkt 99999",
+        "expExitCode": "2",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class qfq 1:1 root weight 1 maxpkt 99999",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
     {
         "id": "d920",
         "name": "Create QFQ with multiple class setting",
-- 
2.34.1

