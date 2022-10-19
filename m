Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74906604935
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiJSO2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJSO1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:27:44 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2123.outbound.protection.outlook.com [40.107.102.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27801AC1E2
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 07:12:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHftQzNmb5yyOsGha6UDE9nk1ZEeiR+FFrny629/VfQrs2ZnuiTFhnLt0qEVNX8va3rJqw3wEStizKOBzSzS6RuTKvfLgCuhJa0bwZwhQVo/u/Gfz8DZt8BqU1MTC6w1oaIvznSQHof1A7SBUT6FsIFWZ9SUSKm9KZ5qOxhGnSuXfTfn+9m1duwEfgCgd0wkgk0mBZEvcT+sq2p/OJVfAFez49OYLvMLTA1khzKvUov35hzyNQmTiypsda0SU40+CybHnCI7j+mXbV98u+rdYTuSAhuMcGwNE20JfiJJ0tZpDsJVvPOP1B2NaS7sIyFyXIJcbyCpk3suvm91oXdoqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XtdTkOcn07wNifQrtn2HyLqFwuO76ir+nc0aZr6IXFw=;
 b=ZSI0yqUbHwXtY7TWeCJwt6IL/Y28GEjruB6G6Cv5SSUO+FEhJBpsFz62yM2CaqUzqB4028mb51yAtQSWZpgaZopYS3j7pUU6To/SA9zf/OsY6EZq4M1kcy4hhluFIZEhHGpt/TayAHwC61xiQjlzaIxtEylKK8Qsr/Ss+CIMg3/BxBmmm8tock0caFLuDhqF2ZQ+FNj06iCwnZazWIbsgMzsOKpOnJYXbjLlK04LJ26FzFh7dm0UaBJg1yGdbKdowFOAXJPcSsuwZ6lr8vNN+9ybyVm4tbDGqCCD9okOvg9y1HMACvLBBbjYw++R05ECLCYrdDOkf92JcJBFqA8fNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtdTkOcn07wNifQrtn2HyLqFwuO76ir+nc0aZr6IXFw=;
 b=i0THCvXFlojgGovm89flpcUN3mHeF+WZptd2/rZiewJeoSH7zOGhg5p0XGBUmw918JZ30ksHjnnPmicqqAKmH3Tn7niKdH0f58ru9FC8AuUxj5d+xfyY3hzEnPvSTw9H7uGn3fXaJo1hlUTHestLIV3+9N+MzdX9etirwS7mx14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4404.namprd13.prod.outlook.com (2603:10b6:208:1c9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.20; Wed, 19 Oct
 2022 14:10:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161%6]) with mapi id 15.20.5746.016; Wed, 19 Oct 2022
 14:10:23 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Peng Zhang <peng.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next 2/3] devlink: Add new "max_vf_queue" generic device param
Date:   Wed, 19 Oct 2022 16:09:42 +0200
Message-Id: <20221019140943.18851-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221019140943.18851-1-simon.horman@corigine.com>
References: <20221019140943.18851-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0008.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4404:EE_
X-MS-Office365-Filtering-Correlation-Id: 559d8ce1-eded-4ba1-ace3-08dab1dbaa1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+n+Qo06WafnK8mgT4LmtJPAAWhDxCdDVARETE+cDvtVH/TVbOE4oTEVkeTpkO4gTPHL2jdBXWq1KowhcRSDpbRwIt593J/gPTPpZJ1REBsk8bHej9s0TD4L/v9OFMI1m39jKGsVA6q7hGo9FxqT6vjt7jmHoYA+eaPdaQ0ZVfPrOIeki7K6xoSNhC6kLBNYLgsZ/38evI5LkVRwugRxs2XOLi7uEEVIFzTdQxoNq2LRH+3aEvsYnBbeFk/PCllZdDJmPTy70Njd+Ff4VLATa/grxeeFpoNX8+BwKcuWrg7JubwPkMxYxbJvzvJHGFKpymr+6zluK8tzmmLNiLvefFls4fZlhvMf6lvCjHO6dMmOvCSz5DiGXF0ClqxeTJPrWuea8GU+O/1BuPCXZQB3f12k5IULAIQ2/uxeXwBScpS7qX3C2hUcYMw86aAgExt71jbLTZCwBwqfObnFoFwVxgzr5FXIuqcQTFtXRD4ptVNNdRyxGUDFkP1g2K0i0xOu/KJtHcYwW+mz21ZQSJEEC6o9gLUpRZZ+HFds7l9o3SLFT6gnakWF2J0KrzzxqOwnQjd7xLD/DA9sCgsLhEIj/EHntZX9X7wrBOww6BwBtUxPK/YxnRaQOlgfV+8/AzUdVpG2sJoH5mt9YJjVcGZODEpv9yLqFcSfgXNwAQ6pQY9skDbaISWdhxu9ZtLqCAfSyJp47HkHO3VrENdtSMfzWeEK6OBEUGlBZtglAgVFbJKuIuCpNyRsCKdf25SQtz/PnbGo8k0LMfIXNNOx6YZtB8wYZQFDFHSQZs0FJ0F/Vew=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39830400003)(366004)(346002)(376002)(396003)(451199015)(1076003)(4326008)(66556008)(41300700001)(66476007)(7416002)(5660300002)(6506007)(2906002)(8936002)(52116002)(2616005)(6512007)(6666004)(107886003)(186003)(44832011)(86362001)(36756003)(8676002)(66946007)(6486002)(478600001)(110136005)(38100700002)(83380400001)(54906003)(316002)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1tLQs7349uEmFyACeWBLqwaSlzqncjnv8t3zE5kqPKBnCL4Gu7L/6jo+oOqw?=
 =?us-ascii?Q?IkE4KX6RxK69VLSpXG7sFIfwidX/FvmtjCpe2eX9JnRIa+tKpSDapXfMvXes?=
 =?us-ascii?Q?5JlPoAfuxOGqC9LOyjNsQ24h3+adVb72LDccSfNpjOzRNPfsiw7w8fMUYEfb?=
 =?us-ascii?Q?oBWs465bcssrhs2RR4I5sMUc2yDAknPD2yXvmqLFCN4z1aR/kScGKDxG7r9B?=
 =?us-ascii?Q?zP9ULuWuM8ZobFX8yafAN2wgcYgiC38p1CFec0Wcm6NmoOPzs8N0aqg1wXg1?=
 =?us-ascii?Q?AUNxyqwNAHfr3ZEMXmRJ4ieaTgXeYFPMEOJmlHu63E10uMIPczeOnEESYkWS?=
 =?us-ascii?Q?fEZ/g3FPelmZMCR+oLAcVt5GR/EWMHmw9MxVkltg7/CFyR+cqMcldAHygLpI?=
 =?us-ascii?Q?gQyH75OXfrljErV533LQ1u/HBYp6sFqk3iLtN6ysXNfnL8pQefvkB0oa/UbM?=
 =?us-ascii?Q?SZtpDaPw6JmxApW4iT6GxWzRlOUsQPhxOZdMiGCthoDx3ojtm6fgmUvSyRO6?=
 =?us-ascii?Q?cwliu0JcJ585+P9GTFZWsf45BqEpwWpXXXHq0ZbgztFI7f0XJNnFFW3GNW3H?=
 =?us-ascii?Q?Q/pX1e0sxvuro9dlLv01WxtLP3N7dykJOLMeY9sgxrali7UV3vid6wMlhqFv?=
 =?us-ascii?Q?qrQHaJot8MNJtixbtxN3bcoiODR6viw8KlBTnSERe2d3IL0VGLe6m1M15nMx?=
 =?us-ascii?Q?+udhJ0TADneIP8BcVgv8a0gUloNLHiV6H20d7s7r++6n1i+z/DVMW7GODe64?=
 =?us-ascii?Q?9Kk3vLfXRgQuj6TxihcVCkvck/Crnn5SAV9qjobgpe3sjc75F+gX1iV6Ykgo?=
 =?us-ascii?Q?l0QRjAgpJhwqw3tI3fkUC7Jr1Cl6RmjKa35pex/86feKiE3IF5uEPQjF4TpP?=
 =?us-ascii?Q?7nT1zWVxQNqgraFtkpRRcW0eraXgAePdaRxuWUXDPfNQSAIaBI50jy7HaNpH?=
 =?us-ascii?Q?4zETVGjAOa2hLZ1N/NdQCwqqcGgbCxNw3wTfoIOqvPapidoTw/dZy1LyW5rZ?=
 =?us-ascii?Q?xgQvjXqElQndyDO44DqpCoy+SpB9JV0yCsjW5H1q0didRKeBxcQd0dRyAEqj?=
 =?us-ascii?Q?Sh+FqrFzyjmiwqUGpfD+Vqct81/MWIxgj9g+Ifk70gdtJRylYF+QTz/IXaOo?=
 =?us-ascii?Q?OUD9eCCTdbNmHs2F1Ol463mnpojNDM49URzV3gZzzFjbACyDd530eXs0eH48?=
 =?us-ascii?Q?M6SNFFqszcQEQScirOB2ejuBTwI6qjVi3CObRezCTNEeBpI/CJ1hE/V5acKh?=
 =?us-ascii?Q?9i+jYrFFPb4ougSoL7l+aR7i68q3Pod06uPKyxMxsNpHXLC++aYsMojxI4eu?=
 =?us-ascii?Q?NxWQJlB4zxv5o7vKmWmPvYJasrLicwHU4hXGtT5sOz7sGlvkiGgKDYVVSce/?=
 =?us-ascii?Q?9p5lUW9QgTetFxGBGt2rpmGZ8dwsa0oQp+XKOobDLdYJ5y8rkzoSw3m0+5ko?=
 =?us-ascii?Q?4w9i2n6M3HiwN/NjtaST1ee/amvKMpKLxI3bxA9YTcrncIKUQiY4LY+ndvWr?=
 =?us-ascii?Q?7MPDb895eREqDrYnRGj2Coo2KzA6+udbCTrkAklVRkjJw9byR5TUpW2FF9P/?=
 =?us-ascii?Q?UwYza5QaWoRC+b/JaVUwiJq+KnBFHVn9k6STsfhOIVGDKLNC/+ELGMZsGPUz?=
 =?us-ascii?Q?k5hPXtcUagkMWfVewUFzZXfMZRLnUTu7JtYlqzOMkv9VMVznSUM+GqEXZ4/D?=
 =?us-ascii?Q?YydCjQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 559d8ce1-eded-4ba1-ace3-08dab1dbaa1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 14:10:23.7556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ul6CC7GFOB2GaatCn+I0IbVmcV7geJMosuKCOPtomoE2wZAuqLUqqHxFAxYhNS00khNCi0jkcEUrCYfalDnQ44cBtR6+x7ANSDT8zBOyLo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4404
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
index ba6b8b094943..8cedc33c5992 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -498,6 +498,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+	DEVLINK_PARAM_GENERIC_ID_MAX_VF_QUEUE,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -556,6 +557,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
 
+#define DEVLINK_PARAM_GENERIC_MAX_VF_QUEUE_NAME "max_vf_queue"
+#define DEVLINK_PARAM_GENERIC_MAX_VF_QUEUE_TYPE DEVLINK_PARAM_TYPE_STRING
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 89baa7c0938b..c33f9040c570 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5152,6 +5152,11 @@ static const struct devlink_param devlink_param_generic[] = {
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

