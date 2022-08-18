Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96378598801
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344373AbiHRPuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344052AbiHRPtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:49:36 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50081.outbound.protection.outlook.com [40.107.5.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D2754669
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:49:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azVPND4uwdPvQMjwIct5YkGATLc3xwxLVrSb8Ih/o59JAuq5s4O7PIBjejD2BoJ8IqHb1PFSWPR9RWiqPBWYXtb6oemx9CafDE7hqdyg0nFmaZnVXL80OuMc3g1JAPBOs6hauPtVOiP2BRz+pSitEjEFDZPF0qZiAdE41d6szjIzbiTKD5vZh/UaM5ieBo5YScDZ2mukW3obcekoBXdrIONjpjjT2tQStw7Slmvc5+y68tp0+Yur6AzO+kCveyedntPyLYYlbeh4mCXej4YvgF4JvKk/BKsgkh5lD7muG3/kMdfmwVmGblj8c/CoON9xVPkWGZ/9r9lvQ3hzbZxvRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkoT+pjmBxxhYKaLwod8HkjS5u1RFt+zomOkv/KRgs0=;
 b=I9h1XAC5IDGXHPugcIebu8i5Nq2KPengwKLM+MvLXOB6QAy1qE1ub1Ntz5C/q/wlyY7i2cXE6rAw/hcLib14AT80QcITpQIkmZF4B+zJUj2RS1x4liVD1aDGVAQbwyT5jpvIM+//CGrm1Jb/w1IBHj0B0CiSMV4QgqxyB2kHKR7f7cnfo/QUqJBTcSE/BMmYcfgENfMTD6C6O84Y9hxVgqf6YCiifjnSyxI5RPb8AXFA/1L0eX277QGxOZp0k9wUkE+pVgge9JebKWcmUGcVZL5A/yA+mPvpsJPdW582JMJm3kHe4ACIsyybEspsRbNWYXvHeRCpAxfQZSecx5TX+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkoT+pjmBxxhYKaLwod8HkjS5u1RFt+zomOkv/KRgs0=;
 b=bjeHQrLTEVjKyr/Ybu3fbFIo0c366fyt9du6RdV0rGJwvtagSOGDU1trYmDgz0mJjrCknhhN1GeXup+38XqnJJlsdWQlKTy5LbjC+wm42WxQVSjm4wdsWGslW/ie9xPFjN3wz+NKBnWpqYCp1hZ2U5cHk5JE9w6CyWQ3pNaLQko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6349.eurprd04.prod.outlook.com (2603:10a6:803:126::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 15:49:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:49:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH net-next 05/10] Revert "net: dsa: felix: suppress non-changes to the tagging protocol"
Date:   Thu, 18 Aug 2022 18:49:06 +0300
Message-Id: <20220818154911.2973417-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c821a0ae-5da6-4006-69bb-08da81313e97
X-MS-TrafficTypeDiagnostic: VE1PR04MB6349:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZJszzXqeSEy1iwt5N8KvxZkrnaWDvdZ4JUQOVLQ64V7RV7pP4jCpverIFg9Ovh4y6Kq7AWwdI1RUs/b2zOFLEfXzYCm65rC8O8uzpb+Gis3JIASt1pnKQEt2+EzNLEAS04uIeT60Ak9m8aZ9xjHUmztrICmbUHpgkyBdp4mHj1Ipv5huNIy73lsEx11Owda4RMl+B11Ch+ejrtQq+4Uq7DRkN65OU+gxiFS2fimQurG+QTEAOi46hxM8Zc5IaVdFLWn3Bl71ibnq53thisTika3x/qHSjo5m+A97OvLcLdQyIQj7n40MAFBOf8qcUBgOMGLZ6gWHFsWMESfGSxuYc7pdH7se4R7L+vnx3rByHn3kVEddDVx4UT54bbA5ZLjyrPx/IPehplhDUDjfXL5/dJ0vLwaXv9ClEIXCaptyonmAG40TIbju4B1ewwwXcTBD5h1pWZuK+KY/rurdOxeGMMEoXRuT8NXVoqhRYAQwV2J219DUZC04GvbcCbKvnatpEsPsn1u90Yp886RMD3QyI3rNUFkzXFwyOLUAissyM6CFFOeamVo0pts4BG1MbaWszdttZPlnRWTmsz/ImMHEZQgKhNEQfsTU/HcRbe4iKWGg9hCr9D11+XhXjPPG+DTUYkfrTK8mlGS6hE+YsxR6eF5IAZMXpSsqQ06Lhf0JFtiU1msPKdSCyDBRedHuAfBW7yCYz/SZ7Z1rsgy3ilTSQwN+lT5PSvt+9LLcWg1prqzR8v3RmW8168u3mZDm8oS0zwSZk8+et7SyxqXIKraPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(52116002)(6486002)(478600001)(41300700001)(6666004)(26005)(6512007)(2906002)(66476007)(66556008)(6506007)(4744005)(36756003)(86362001)(6916009)(316002)(54906003)(8676002)(66946007)(1076003)(2616005)(186003)(5660300002)(44832011)(7416002)(8936002)(4326008)(38350700002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aclhII281zOesE5MdN0mdu8t8VVha73k/SCouOqQRXzad0uH20tnen+1t6hU?=
 =?us-ascii?Q?DXz0cmvDtvPerLLxWzH+cCJQYQE3pVHWQl94CM8WdwlBDfC6A2olJls3uijE?=
 =?us-ascii?Q?aVyeZ7fEPf9nC5jwagO59v3mlKXucD16E95nyHDcfScdVXv0lFELtzuUOmSv?=
 =?us-ascii?Q?VQZy9L6z2V3qSrvkkpOEFQ0S0UdcC4teZglelEohyMSoMBqj0qpJotpgXj9K?=
 =?us-ascii?Q?Ss0fHrx97Bi3jCN/YQl2/ERSyfdWArK3BtoqZSZ5VhP+wMbTrc/eWNpWXYgj?=
 =?us-ascii?Q?Bqhb5xVqGXfm8EX7S38uFuKFwCTgqkcMNIp/CGK/tvZO+FK1LZV3UqW7/bQw?=
 =?us-ascii?Q?YEqqaYXruDvCJGg0FY5Ed/SRqWiFBASAFtetNRJ03qGb063sAwHGXVZyh/ds?=
 =?us-ascii?Q?VO00FuqQZ40eGzWt4APtqK7qM2yRhMEpcwAjt2nZgQwx18L6x3HogrJL2N+8?=
 =?us-ascii?Q?QjiVBRTfp7XIDrKNINeImg0VTR6NQWbMxmXqEq/JXhxKTxQc2FdXQ09jgiE1?=
 =?us-ascii?Q?YAslpozjBbPVqyiraGGfH0jMlOCUXC0AggjSoASg7sGT6C+u3NY7cYL0O8zl?=
 =?us-ascii?Q?arUy3lY9+nDuBHYEGP2LXIQf1B2r2baSLzwv1QahvxuW10ce2UO1KtyUjyLF?=
 =?us-ascii?Q?LUyDxFL1epTWVAr7QYW4EpGvbipEz4xsjaLQIVZ1E3NJkfnG5V/SJBZxDdkm?=
 =?us-ascii?Q?fMfQxIbmu5q0/WH1Ad7BihGiZOYmrQRQYCKoF8xTPYvTATGP437BTXBKUDEA?=
 =?us-ascii?Q?to65Kc+q1CbHJQ2wlU8vghtPCXDGSgbYAGMN1Vpv1I+Oes2kqI6e7fu1de3g?=
 =?us-ascii?Q?nIulsbyQlbXcLpozcEs7Q0udbniNV7F7Zx1fKs6OGYXgd5CSkZ1CXugLsEtB?=
 =?us-ascii?Q?4v8yBWXeDekN17BH2RD5McfiJTjz53mfBtG8lAuDhBFkNIFNqhwIbBydKrSl?=
 =?us-ascii?Q?65NDNPioiDu1yBdmCmvN+IsuKF1vUO5vvv+e+i0gLFY14GvQDQ1keo6bmqxJ?=
 =?us-ascii?Q?8jq8X/jkKVcFu3om3b716y+o8pjJXZIcm7p9+5hnFtqpbXjtPpleOkcBRiGR?=
 =?us-ascii?Q?PeEOIXIJXicMKvAwNlbd2JMSZ85oD+sHU7pxOWNKc7JULh2+EAF1R3bW7bRl?=
 =?us-ascii?Q?5Sm2JXSGJMVh7MAJIEWYBHM9U2hYnANBUpGGSFBb/pxWqpjVpIPEFdWry/xz?=
 =?us-ascii?Q?sVBUS7f17pJZZvkFGeGYZfMi58JsR0ZTCOgWTwqUuEXbxXqKutHcbSNCvQn3?=
 =?us-ascii?Q?Zmn9LX2zrQkJgkn2owTzZSX8KV/OMAeslzDBAPBjiCMOzj+RrUqrk8B8QuGz?=
 =?us-ascii?Q?efgJHqMURLaBwxdlrYOwCeFAtH7c4ue2wNBuSWcuaoYLUpRMS+0iUiZsKJJo?=
 =?us-ascii?Q?oqk5xis6h21QPqLMwgdQYAhGk3j+QKVMU5MQ5+K4/TrjCyueA42ZM82i2VWY?=
 =?us-ascii?Q?LLFBs0FimoGnBrH2tMGhMYYSqiKr47yoXWRgnDxTOZuGD/QHqs/ga4Ia6yoo?=
 =?us-ascii?Q?ClQPsZ/WjrRAen083A3xrDTn0VIwVyUjkQCNgv0S7L0nBiCiXXaAx3fSsv30?=
 =?us-ascii?Q?w+GV+d8pf4LhF/bmGfttWtw3ugYky0ES2QWGcAmcF4H/MW9ynegUPijbDS3s?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c821a0ae-5da6-4006-69bb-08da81313e97
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:49:33.1867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0T87vvE6QZJ4+a9y6mVbeY0KeSWn5EQ/RfpubhvKL/ZVk+M+upvjT+OYHBFTt6mc+E3DKG0/vmZTXvZfuOkaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6349
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 4c46bb49460ee14c69629e813640d8b929e88941.

This is no longer necessary now that dsa_tree_change_tag_proto() uses
dsa_tree_notify_robust() and hence, does not bother us with another
notifier for old_tag_ops once we've failed the change to the new one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index aadb0bd7c24f..859196898a7d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -610,9 +610,6 @@ static int felix_change_tag_protocol(struct dsa_switch *ds,
 
 	old_proto_ops = felix->tag_proto_ops;
 
-	if (proto_ops == old_proto_ops)
-		return 0;
-
 	err = proto_ops->setup(ds);
 	if (err)
 		goto setup_failed;
-- 
2.34.1

