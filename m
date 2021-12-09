Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B65346E599
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbhLIJc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:57 -0500
Received: from mail-bn8nam08on2090.outbound.protection.outlook.com ([40.107.100.90]:64096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229803AbhLIJc4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdatoI8wW1zgdlzEGFltecHe/wFgzQLwPEfX53LFhyRdu+fovGJQG3LSDpPC0JDG9c7xm9VbYP1HHor1po9WY6Cznt7mpOwwPq4xgapuxwJY5+oSEXz6db+Iss0T09Oy8T5uuEoNOoPc0h4s4WQIpitURft6Rs1uEy+FYIjO8ZVCm1Wl2o/4I+cJWXF5uKt3iCTro6gM7HyFKLI3ZJ3dgO1uwdpINyTTKFhF5XkF2032FP3ZsTdqXsyG7ojg/xNpS0fqhdL/nOgK1MJilrxVLU3VicxUxWd+AaWs6yX/oh1HIeYGhoQzT1aa5vrRJbTbAUl+mD+N4bLdtt5+LkyvnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLD9VLRt+eoIXF9qZ6EZEbTy+gfLtdBLGZEzQQ6ouZ4=;
 b=TT2yQLhA+ahrpSchlynCc4rXZn1P/Qo34MvH4P56i3lWY8dRsuUfAU7e4ZgCs9X75ZPWPa1rCaC664LXDddoy5vnnNmactMx1RUW/dCdvtqWZvXf6886BqNlzf6KxxyU9XIrwAU2BdepEMTxh5LnrlYdVpGYjPlGLI1H+Gyi4iw6hsyO+/dTviKUFqqAs5AwLpcCnjSVGsvHcdsK4u8qEcdJOftHMOCwjJ+XsqhkVr5rXuIglmUB83zKcJ6zTVfYEf8vDk9JEwu+em6BnAaWIgaJwIVD1GwcY0JIT8+qoBLL3ZrIwyuX8NmItV0Twy76iPK/4yn2C0DIcWs1MaZVVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLD9VLRt+eoIXF9qZ6EZEbTy+gfLtdBLGZEzQQ6ouZ4=;
 b=HTz1+8m7nutem6Le0C242mN9CkZISa60yPXU51N3mvS33t1qj0IvSb+5szDzmw63WkOH46qDJOFOzAXgJJgGM6jpjmBCXj2vvtrEB4ftvX4hbb51phrJMGRmbW7pvQ53hepgdkKaYJDp2DOqmM9/C/wFkirmEOi4X1RYu1/+vyc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5494.namprd13.prod.outlook.com (2603:10b6:510:128::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:58 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 12/12] selftests: tc-testing: add action offload selftest for action and filter
Date:   Thu,  9 Dec 2021 10:28:06 +0100
Message-Id: <20211209092806.12336-13-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211209092806.12336-1-simon.horman@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f7aed65-7fbf-4567-ed9a-08d9baf65419
X-MS-TrafficTypeDiagnostic: PH0PR13MB5494:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB54946406643806475081EE33E8709@PH0PR13MB5494.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n6tC/8LAiebUGCEcfiYuIL5seVflf+cb8OZ4HgMtkUBdqzn+zouvDnH6CmdCaJHmcwohmv7cwjvdhaZK5z3k6RAzx0dfkQiyIW0k+8pIoUy23/wEmjycEFi/l5cfDCHS8/p87N7Nv0z3lpyLeLlyysGFFdhoJtdntUNk7IYeq0SkTIqxc5bOZE70CkXxo0STe9NchMzR3djdyudHUTO3CQV58+iduMsmp6BxTMYpXaGhVsR7RHCrDa6nq8ccomYDa67jq65Un9le/aMCh40pHJb1lO54x+sv6DdYosERpcvrzNU8Lmu8ddofxGATEBHDJSXTFqbDSiq2VHuFGCDR+J0kfUfGSWIrbWiCyt4+8KMyvC89JDF3JgCPQcm5s6e8WgtNxJaTG5aWR86siNk3aUqT+vCogfXDP18Y9E4XZcRaCNT9taOcgzGj4gSlmy/ctd/JfuEFIVMpeSAA/ZeFoBul/7xZyrbyJ47+MYAML5gvItPJB+milrYUKy8Npt2RoNtiemDJKre4fNdTmZ23uxQaAIFgTPq92a71Wc9C6PAx5HrRt5SPglQ/8H5Ix6rm1REto77UykHOBXfBeAAE8ffJWrkYPMMx0Uv1dF4uDnjZSqx2PBBP0b6YiVXbe619I5GaO5QsVoswI2cwhDG7xQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(136003)(376002)(366004)(6666004)(6512007)(44832011)(38100700002)(6916009)(66556008)(86362001)(52116002)(316002)(1076003)(6506007)(8936002)(8676002)(4326008)(36756003)(2906002)(6486002)(5660300002)(186003)(66476007)(2616005)(83380400001)(508600001)(54906003)(66946007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ti6YcI8CszEZHEOlPexIukFBUOZ4LcYDCXO8oQGtljr3rNocHNu9QmRYIwQP?=
 =?us-ascii?Q?Lr3w7hN7cHbh6TNX670xobpjuqEpwNHCNI1aW9hG2CQf0vgeumnv2Wub6Uis?=
 =?us-ascii?Q?5fhf156nMfeCKrUEl8pzHyWX556KjdpK4FNWnit+GlNZtwkhyTqw6vvHkW9o?=
 =?us-ascii?Q?gPsrUN8EIzWlGPb/8rarqZNH0dru79F457RvGw4RDPm6qBJpMgcaXhVsnfco?=
 =?us-ascii?Q?vRMLsVUNe3lL88SMBR00bqUtFyP10Hr2+OPrf3hUbO4lOWNjzn4TiZZEVn3/?=
 =?us-ascii?Q?omJPrkgjddvj2uw2Jhg5zSe5BIZKUV2bF+B9jYTv4unqwbcV+3+ev393Nz6L?=
 =?us-ascii?Q?UKwqERaWFfyH1JQtMXfTrSUdZLdo91+kTi5SfiRmR2L5XEENINwkR9wqRJa9?=
 =?us-ascii?Q?Wa+zbQZMkTpYlTRBDZwPIEeAbYVulXmI7QeoJRqyV9QlHJ/chpXOm2OJh8oq?=
 =?us-ascii?Q?g1BBv4Yq9enswfKFQn1v8Ond5P9mfUQVIqSczNiOx86ZXP8mi25ubGevOA5X?=
 =?us-ascii?Q?asKrN8of/RBNXsvo7fqWHIalYOcOxDQjWIrkPfRTUyxKVclOZbZvp6PuEWMU?=
 =?us-ascii?Q?ffbEUlmhLYVLGrGZaEcohiGpSO2YUcrh0WkHephMFBQ5WVXyxOJpiD5Rpoe6?=
 =?us-ascii?Q?K6D+TQBC5SsKUhxTY/6YsYBP5Wc+UTChzwMrF/su1fknibsmMlhfYWh+q2Zk?=
 =?us-ascii?Q?gQGbDjehk0YZK0Ei+ESwltCAbNMZ8OovXIcwnvlZTaOpHO8sMycow3nINwsD?=
 =?us-ascii?Q?01W2AJGrhGP4BWFszCMiTxTZg9ZUAATHVvmvBLmIhsYadxfVdf8E/dxjUUmU?=
 =?us-ascii?Q?l9VuUFugNVG1Gmv7hRlEy75V2ClJGqtqy4hszfKqRwwbrfJzEpNEi4nbdPIR?=
 =?us-ascii?Q?Se+FZ6xmsV1Pb7N7EepCN78lin2wZDAPACdAh4FMxRTzIjtJ98NDwwvv05KH?=
 =?us-ascii?Q?3o5m7zSVsZTYH2nDmjDJRkXb4vcfkWWggBRLUoeA6sLrGbdqgHeFBsj/fCRP?=
 =?us-ascii?Q?r2dZtO9Yac2ETyQRun6pkGn5s0I46PIfUVONR8n2OH3BH/ieLikFVN+OqsiF?=
 =?us-ascii?Q?5U718yyoLfdXKvq8o3KF5Shp+8kImShd3oFhc+9oCOy8iAU5TJ9QbtqoaUSO?=
 =?us-ascii?Q?Lau6GxAe4NReOwfuecoplxTncrAv4yK08kMItaDEzR9xla52AXQsffLESc/5?=
 =?us-ascii?Q?U5OO28KPcjwj0GXBKl/MsovdhQe5jEAEAqHOWINDrT514zBNNHpgRGGBmOn8?=
 =?us-ascii?Q?9rO/x4dtNiFISS6/+MUgCXiwyVamB7YMKk3wtWqZDvmKmI7xu5SECDMq0BbK?=
 =?us-ascii?Q?d4j8hXLqzT95KP2nZxP2NhBTZ4+xhwy1dyxrSD5GzFt+12GKXQIb3WGZdD1M?=
 =?us-ascii?Q?i2Ob+nY7DqkQiYafCYPUQCg/cWn2QQmthGJ7Jfku2QH+vPnjeCxoTL9LiseS?=
 =?us-ascii?Q?+cvOY+dNJDuflCBxc//ZLzROmkvvGT1tKz3BYR+ORS/VDxh5QlXG+/3ZiWKK?=
 =?us-ascii?Q?5fFMUVBlHxINPmTJBBhM3r9FOw025Syld1viVNGEpdmspYplsHesvKbqUnOp?=
 =?us-ascii?Q?BEzzWE8fiYfF3aZ5Qzb4ImHRpQpmUifhCIRDkItFjgEi1FufGTtpFgeCK0Ri?=
 =?us-ascii?Q?YZ+pWxhksexCaSsiBwn+qbc53BdS1xAXfIIXE6vEG76f0yl2YWennzKVO9dO?=
 =?us-ascii?Q?TmaWO8DuRg2vMVOZU+J9+0hyPy60DmBsTJC2G0K7sbacKeaDT0XaybGWqHyC?=
 =?us-ascii?Q?5p4GPSCB6Z6PJFgiQ0DWcsOWe1fxFZw=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7aed65-7fbf-4567-ed9a-08d9baf65419
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:58.7244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LXrjJI3EYoz7snbQT1EYiz5Z6iDfPRNbKlRo9PkBe+nSB02bh2fPFTo2c+lYMv9HbnaPPIGeIM6Q0ee0iqsYN8ymHOZcXj10q2uFe0Lp9Hw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5494
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add selftest cases in action police with skip_hw.
Add selftest case to validate flags of filter and action.
These tests depend on corresponding iproute2 command support.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../tc-testing/tc-tests/actions/police.json   | 24 +++++++++++++++++++
 .../tc-testing/tc-tests/filters/matchall.json | 24 +++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
index 8e45792703ed..b7205a069534 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
@@ -812,5 +812,29 @@
         "teardown": [
             "$TC actions flush action police"
         ]
+    },
+    {
+        "id": "7d64",
+        "name": "Add police action with skip_hw option",
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
+        "cmdUnderTest": "$TC actions add action police rate 1kbit burst 10k index 100 skip_hw",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions ls action police | grep skip_hw",
+        "matchPattern": "skip_hw",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action police"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json b/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
index 51799874a972..4a8d1c5fff29 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
@@ -387,5 +387,29 @@
             "$TC qdisc del dev $DUMMY ingress",
             "$IP link del dev $DUMMY type dummy"
         ]
+    },
+    {
+        "id": "3329",
+        "name": "Validate flags of the matchall filter and police action with skip_sw",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions flush action police",
+            "$TC actions add action police rate 1mbit burst 100k index 199 skip_hw"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv4 matchall skip_sw action police index 199",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ipv4 matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions del action police index 199"
+        ]
     }
 ]
-- 
2.20.1

