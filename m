Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5741A5BE9DC
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiITPPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiITPPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:15:35 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2125.outbound.protection.outlook.com [40.107.100.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC10BCBA
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:15:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLTSGQnIJIZdrkmB6WHJtNIBaRQvR3bulqOKf6BAvvxu0977DIvXVJtzNAHvyz9k60pPI5LrpPO0wv9UmVVJoppKSuN9UeNUtNsindZLB/uGEbC0sSKZ7MWv22xmy+2lEpsotbPVwuEe2NmzUOxttU2zVCKAtghtoKUfBQlethRJEi4uTNXw/fSavD3bl0wmG11lxl+i47kXgAPNzV5O1Jcm6Hq8i/14zIrQ/cU/14jQBFZl2h+wXvQml2ZaDh5dAIV5ocro8OwnBd/T4Hbwk5mbsqvUXFIldTyXszn36fo6N7/1O02R6kgq1laNMpg3xiHpG0Mqu4xzWO+MosN5PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bW2kYODJb27wulPl0MAbAEpTeumiAqhx46AuB1x8QR8=;
 b=LmR/izOY9OkLrKh7kzaCVMvo2V00zvCO3LhgtbtpHkkBE7Wi19O4TH/Bff46qkUmCViMfVOOWmUJcBnQz0JiPGy0fKTqWDf1Io/ArgC6a+HjyNX8lhEETs81ZFQT27t0IJKgRnrnqYfFFwPXK7vrr2GkrM4v/4Oc8/m7uF5t+EVn62t075hY2tjgZ5rI5poR6EfRLm01xwf86sfpKt+U1bleLNVQmXTp0/5zCrcTPESmjq8BJwuQdNP4CEAdeYem3iiuG5603Qy7rZbE9NJwIGtRpoDPfNoAdrgSyWUwCpfDHnWmHXFhHrB+c4Wnf1hm6YYLHLZywW8qkse9Gcblmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bW2kYODJb27wulPl0MAbAEpTeumiAqhx46AuB1x8QR8=;
 b=gcXKL7SFNxls7m5uWGvo1IMWhdVBQNcNAAPlGXtTTIzJoljEnvgV+i5HU0VyfIJltt5etMRiLihmYqDy+oBxUju7o5d5Loze5jAp0sMHekKTCQis9EeL0Yi7I5hSM2D3D1JCzHt3AsxF3bYi+j6+4SHf+7l2JM858nEqkYcEBW0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5301.namprd13.prod.outlook.com (2603:10b6:a03:3d9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Tue, 20 Sep
 2022 15:15:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 15:15:27 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>
Subject: [PATCH/RFC net-next 2/3] devlink: Add new "max_vf_queue" generic device param
Date:   Tue, 20 Sep 2022 16:14:18 +0100
Message-Id: <20220920151419.76050-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220920151419.76050-1-simon.horman@corigine.com>
References: <20220920151419.76050-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0064.eurprd07.prod.outlook.com
 (2603:10a6:207:4::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5301:EE_
X-MS-Office365-Filtering-Correlation-Id: dcf4b2e3-3521-40b2-c5d1-08da9b1af150
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A+EeBDfYQKigWQkUnDJ+RuVTnrkEOVhyQH7+a0R6ifTKKZV5SIgbm3LtsOvULA9rn96LBFfzFf66fmaBx3aVWoP+2ALjQ/GYm6OKYY1kLJDYmivZfHd01L8K2vZISMH7f4CsxtQywlbXeqceeDbeELyFA1FRvtsDaTfVX1Pyum5/2AvXS5jU04pd4OYFxtPjs2Eoh/Ucif6avWtuYXrX8UWPQTz5pDghQDQoImT5ou+pHzZhaYkM0fSfgnP46BGJxVll1E1hhC93BS6OlP4trh27od6HsYkfnGsZiQdfAaYrPYU45fyHISbNLWZTWixFF4oBfxskhRmIySy5pgB1zErllZrl/jxNjJm/uApkxFDFxzoxfTDmGCew3kr90w6WwepOXNcP6Y5z5WBA4iKyUA2kpphX5Fumc0igh7ApokH5vw8qDFQBZQPulZbvNN/sSRBDF+OKqYNfRex3ZbfE+jx+Rad91PNi8hiyDUq26iBK5VuuQp406e2vA7nzF2kSzhoqOifr/GsJ1FyNwNj7ZNKw7LR5zUxXnHhkYW+ROSZBV5JNvMWngxPZx/TFLAhEm3YTIEvacMhilteO6FKndnOoveLsQwdUR0pqvCgLlZosOCYWSZ0NDQrGq1x/qiDFa6EQmHk5wLImAIzDH/VIfv/3BYQUNzhMTXFUEznCDR35mcsVI0R5TIC/KyWhvdE2M7BT5HegrJ0kWwecvg1tvzoNqM19+/9zeUFgUar5nTl2YnD01GDEM/llzyMFJMtpDWE0+9w/zXErVfBxF7RJ7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39840400004)(346002)(136003)(376002)(451199015)(6486002)(478600001)(186003)(1076003)(2616005)(6506007)(6512007)(6666004)(107886003)(52116002)(2906002)(44832011)(8936002)(36756003)(5660300002)(110136005)(54906003)(316002)(4326008)(8676002)(41300700001)(86362001)(66476007)(66556008)(66946007)(83380400001)(38100700002)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6iCyXFyw8YLZBGJAVDWsbGrq+2FF+bknv3BJ+jiODYRjLridQbrzqaPQG1fN?=
 =?us-ascii?Q?ul+Qw89hHrvvt90Up9+eSZbJW2iJuFgSdgzK26jx9T/R0qe8w2NQhCW6/Igv?=
 =?us-ascii?Q?wB4qCSZntxwnnNpUtStHhPxiPQ+XViidAMyUPMbY4mh7o1+ay+NE/Zu8IDmI?=
 =?us-ascii?Q?GOwLkO+grQ11AOxiPhlypw+XxE4s92iuDaop0p5KI5dRdsYMGoqiYlRVFM4l?=
 =?us-ascii?Q?bUp+Mtf4zxJ7n9wYqiqzOgvftbfeyg89smDpoW59z5bfspmPeG7cnvK4VInc?=
 =?us-ascii?Q?D/dGnQNm6OV4O37cKIFMghlKF0VcKGbQSl7DgRbZEf8pT06RVy8kInPiqVi2?=
 =?us-ascii?Q?jJJVIdUkcLRnyQtCzNyoENz8XF7Tn7s2IbXRZ6LImenuhwz2fUhGi9TQP1U8?=
 =?us-ascii?Q?P8C1WDwpmAx1LgWyx+LO78B1cJb0RTL4MhqyoBowFInlIJ+m59va4R1ArcLT?=
 =?us-ascii?Q?XNRo8j5EmA3W+9X8DYtzselxceQmlS8PruM282eIICMn6p2PczOvfQjp+xnn?=
 =?us-ascii?Q?N8kSlFUyidoPRHNpav2oeDktGxy/7Bmvvu2uV74pLFuFIJGpaHe2bGMNenDy?=
 =?us-ascii?Q?m1UtrspLktcLn+6kshKbLA1FJqiOvnA6yUHgdFvXhIUjM6+vJqC2Lr8Q5Aj/?=
 =?us-ascii?Q?SO0ueKSQcabDHl4rw5AZHGMWOhKGCh1oxJqHkyAmsIrCGBJSzXYHM/kdm/UQ?=
 =?us-ascii?Q?KuKDxlWSRi/Qnht7OMLCrtQnYliIphd+Vb3lt3i+VXBE+0T0b0uie0LWu7OY?=
 =?us-ascii?Q?x9Mp/txlzi3+nYwkjXyLuhiFyIZ7xQiW2So19RDzHqCzoqAZ0XreqH1XqkGS?=
 =?us-ascii?Q?Zb2Z0YIYWSxCaBEeLhABVwrkSSZzNlZIVysiq2smC9gQzQBvqJ01IQ0eC40H?=
 =?us-ascii?Q?LpnwxsWOnM2WFumC2G4Wlf6ZPAyqnzSQJC1hjTF4/dA2EBAnAe0zOc5YRuyL?=
 =?us-ascii?Q?N/u4AQsGyra3t2QL8O1/ojVgtnq4lw2R3QIRX3XDpWMyNA8I0ikx8jCovnN4?=
 =?us-ascii?Q?GUbMWzSvrMKbb72xDxRKZKOhQCOv7Yt3Wn6yfWReyxKXajyF9Da5y177kh3w?=
 =?us-ascii?Q?6KcW/mdyUhRjg6iMEiJCGjnrq3jnnYqWwgFkNUYNCeL/wakfiiTxnYB7W6Hb?=
 =?us-ascii?Q?tROnawiBUXBNM/iSjAb2Usa0bFCJKvrQWhX6SHKC7f2RYpcSf7NAaxlw8vyT?=
 =?us-ascii?Q?oSDpScC3uUNpIKJYwyUy1h0CJZ1w5DWOOEG4yDvweZrUOc4mXt6lJ3vhhKz1?=
 =?us-ascii?Q?S5YMQkO5qz5E3Qa7STwDeNNb/LEtBnx0IYZFFjLP1R5E9qCuZcPSxmCQRAq0?=
 =?us-ascii?Q?cE0QlaeTV7w4kqfvQcik3LJ9mDEDnkrtYAg+LdjkdXYZHzKUJGdTjQh2dK8E?=
 =?us-ascii?Q?LGXVfUU0+SwBj3Lb2PA1Mx+X7plcVbIBI0WaW2d33+1XydfAw8ORwF0tV+uY?=
 =?us-ascii?Q?KR1wN0ZGGnN40lvVFGQ+nV+l5zuTehzG9lQIsJRKv57U6MkUqXFi7jeuSb8I?=
 =?us-ascii?Q?1k8RHTQPhjYIHU0LO5QD9OpgSGiNzoEb6QmnEnin7/LQMQ6AeAwM4yXAojkC?=
 =?us-ascii?Q?iH5oTKlaoxed5oLSFTmQ0bC93whsp9uH9py+/I2w7mHOOBPjxgaiED3rE+uX?=
 =?us-ascii?Q?QMnS6XuGSaWBiljX6xjoJdDhlmv6XcQsdzUSVVCEASzJRZ8LjOb22TuLCa9I?=
 =?us-ascii?Q?U7oUQA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf4b2e3-3521-40b2-c5d1-08da9b1af150
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 15:15:24.7497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MtyAXv1TrVpVtDJCnwMTsctln+62zfM2LSWtaQURgf5g5k+Oe6dlIZ2fSvdvyc8sT6a9eJzzD8N8eJzdCGQF/JDQ7dOQrL5rq4RM6ihBrUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5301
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Zhang <peng.zhang@corigine.com>

VF max-queue-number is the MAX num of queues which the VF has.

Add new device generic parameter to configure the max-queue-number
of the each VF to be generated dynamically.

The string format is decided ad vendor specific. The suggested
format is ...-V-W-X-Y-Z, the V represents generating V VFs that
have 16 queues, the W represents generating W VFs that have 8
queues, and so on, the Z represents generating Z VFs that have
1 queue.

For example, to configure
* 1x VF with 128 queues
* 1x VF with 64 queues
* 0x VF with 32 queues
* 0x VF with 16 queues
* 12x VF with 8 queues
* 2x VF with 4 queues
* 2x VF with 2 queues
* 0x VF with 1 queue, execute:

$ devlink dev param set pci/0000:01:00.0 \
                          name max_vf_queue value \
                          "1-1-0-0-12-2-2-0" cmode runtime

When created VF number is bigger than that is configured by this
parameter, the extra VFs' max-queue-number is decided as vendor
specific.

If the config doesn't be set, the VFs' max-queue-number is decided
as vendor specific.

Signed-off-by: Peng Zhang <peng.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 Documentation/networking/devlink/devlink-params.rst | 5 +++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 4e01dc32bc08..4b415b1acc9d 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -137,3 +137,8 @@ own name.
    * - ``event_eq_size``
      - u32
      - Control the size of asynchronous control events EQ.
+   * - ``max_vf_queue``
+     - String
+     - Configure the queue of the each VF to be generated dynamically. When
+       created VF number is bigger than that is configured by this parameter,
+       the extra VFs' max-queue-number is decided as vendor specific.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 264aa98e6da6..b756be29f824 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -496,6 +496,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+	DEVLINK_PARAM_GENERIC_ID_MAX_VF_QUEUE,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -554,6 +555,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
 
+#define DEVLINK_PARAM_GENERIC_MAX_VF_QUEUE_NAME "max_vf_queue"
+#define DEVLINK_PARAM_GENERIC_MAX_VF_QUEUE_TYPE DEVLINK_PARAM_TYPE_STRING
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7776dc82f88d..f447e8b11a80 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5145,6 +5145,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_MAX_VF_QUEUE,
+		.name = DEVLINK_PARAM_GENERIC_MAX_VF_QUEUE_NAME,
+		.type = DEVLINK_PARAM_GENERIC_MAX_VF_QUEUE_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.30.2

