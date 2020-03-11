Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B245181F93
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbgCKRem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:34:42 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:25761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730458AbgCKRel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 13:34:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wlo+coCMr5MM8CWdp8PGMLe2NkExtYCgcXR5sPTRmQdxHAAAqv3gmXTbHyLU7fC6OV1DSG0tjYIxADN4FMzp1hfBTDsyBeKR25xAO352NTXwT902XhLzCKBConDX14wcrneLdcb/ao6hJg2XujfmDHBapahdfxrcPMCu/0/HrsvD9ElhP4jyeFMV/OwsdkOs1RFSSUu6Fcipy0zU9Qq0GBC+yoYu4GUWqkVgftpO1YOfkUviZSF8+lhUQqTgEfQDSSqid3cIqWKgPU4WoWJS/DwrdbCcL4TL9gxkl0RF1cPpcMEvdG/zm0ar5gEfQizHAsxaz8oP0gTxkJZnVtrolQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LuRbrLMcwTXikwwar9Aj0ZNqddEMtushUkRbx13mPLY=;
 b=GGMiVg59mKkvwhLflwWrSnFnncHWW6Q8Ygrlm0GDDirSPeDOWK5lzVlDDPeYx9Z0quzwG7Pjq054gsWjxLfdrHYBR4GtjOjafZIbqRphMIs0xJ7AjQYqgGYeT/A9yI9Bv1CfmcOskXTBCQfqRLOUEHXRPnaG4bneKOARJJwegfUrpN2RbbiQXr8u+HeTvKdTrNnlij/HuJzOvv4AmzKgjSpQTH81HXxEd42X45nVYoG+V7SqIh0IGKvCwhes/IZyZcnJDZQecAPNs5OHEAMz9gPaLeA+fLx8MCQzWRY/h7EJbiH+QjE+7Bs8Uotqz1qgNfnI3NaBjsI6pGXLgm2bcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LuRbrLMcwTXikwwar9Aj0ZNqddEMtushUkRbx13mPLY=;
 b=nfnS3Ku5q4ehMSVusoiHIfx96SmwoYMm3LeKQzE+ADo789TqMCxqJmJFMZk7b4Rq4hOVN5qjXoX858nRlsizliXy29vfE6T7kKKxNrLekJ9RcPhDtKKc1h5EcROaYWkamKF5sRxth0UN/oYHEpPxMly4tN2HSTcb129D/+uCqGY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3449.eurprd05.prod.outlook.com (10.170.248.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 17:34:35 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 17:34:35 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v2 5/6] selftests: qdiscs: RED: Add taildrop tests
Date:   Wed, 11 Mar 2020 19:33:55 +0200
Message-Id: <20200311173356.38181-6-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200311173356.38181-1-petrm@mellanox.com>
References: <20200311173356.38181-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Wed, 11 Mar 2020 17:34:33 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d6431c80-b14e-4ee8-98d7-08d7c5e27720
X-MS-TrafficTypeDiagnostic: HE1PR05MB3449:|HE1PR05MB3449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3449D7F7CF3DA165AE224C8EDBFC0@HE1PR05MB3449.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:79;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(199004)(6506007)(186003)(107886003)(6666004)(81156014)(4326008)(81166006)(26005)(16526019)(8936002)(8676002)(2616005)(2906002)(86362001)(956004)(36756003)(6512007)(66476007)(66556008)(6486002)(6916009)(316002)(478600001)(1076003)(54906003)(52116002)(5660300002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3449;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PAHAA+c1sCfBcQLl0XbTqPLwWFyCiI4g++22nC4qBgFJtk73WLvPJDFR4oSxl9b7RVAmTlxYF3nan4An6WgZSwcHuX8rq86sazxAFTWS9EJjTusGaDcVa4UtWlxH/zFkwE4NUrYpryiRCkXAu9dQTZTZV/aW7zVq+10OdPWmeu44LGTDdd4+gKwcyILDTx0EICpz8ydsy0FhFLUEN/NPPLw2BKPAamV3feQDeMVQkIRJLEpcY4c0OwpxnfluXGgBAsPu/9fXdk+R8hkO0CIhpJGUirGmMrJN+Wko6JXTHMndSfMfQ6cW3MQnNrJePM2N2U5Zyq531IkZZexV58MQ/lMWuSAf3NJ5lXiDtPu2oIl5kPtr1kiA0ZrQRZBUlgaBDDPJr5vISfyBHJv00a7DBzqwVfYNaJyH3hSVwGl+JelrlG8WidihF43C6Km/tnS2
X-MS-Exchange-AntiSpam-MessageData: RFcNFF7dsFePDmxAbmDVPzzMZMMXypbFavlExG3Vq1vzSo3IEBvaxd+W9dxSOfyktnSfJbfXsSmd6G8S5CkRCwPQG8VPllU2+xQ01Rer6X02DcK+f9koCN3vmGNQHTdxtU/7NraLCQKDFOXAeOeV9g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6431c80-b14e-4ee8-98d7-08d7c5e27720
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 17:34:34.9919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IsamWxYw3xdp4fNAKlZ4Jf8GECoceQ216843Z+r9Iy8s/vV/KqFDnMuJFhzUqppGYmKdN4WttuHlHORp+CgJgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3449
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for the new "taildrop" flag.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v2:
    - Require nsPlugin in each RED test
    - Match end-of-line to catch cases of more flags reported than
      requested
    - Add a test for creation of non-ECN taildrop, which should fail

 .../tc-testing/tc-tests/qdiscs/red.json       | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
index b70a54464897..72676073c658 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
@@ -113,5 +113,73 @@
             "$TC qdisc del dev $DUMMY handle 1: root",
             "$IP link del dev $DUMMY type dummy"
         ]
+    },
+    {
+        "id": "53e8",
+        "name": "Create RED with flags ECN, taildrop",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn taildrop limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn taildrop $",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "d091",
+        "name": "Fail to create RED with only taildrop flag",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red taildrop limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "af8e",
+        "name": "Create RED with flags ECN, taildrop, harddrop",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn harddrop taildrop limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn harddrop taildrop $",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
     }
 ]
-- 
2.20.1

