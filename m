Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02A36640A2
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238539AbjAJMhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 07:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238585AbjAJMgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:36:39 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2112.outbound.protection.outlook.com [40.107.243.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1513E0C9
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 04:36:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oESwGQbZ/ZBwNVfPSCt8RmX0XhReA79p1mqwusX0kX9YOfRa5eW/2mOLXA9CpmThtiozrUvfaK77NjDkY39JbJJ8jwH/3DTqcl6X8OBKfivbovHR5WIA8tq+0crR284LFt3xuZ1kAG/JbEUb+tGoGKDMZuW4wRI7DEbrR0ukUNF7820LMRBOCIWp8Xt4QIbCNOckvQlFYcqJbRaw7Pglm3SnPLH7YwAGsh6T1eIVzeFDh9fVU5+hTYwfOh87wuArhNNEKqaCWtVb44WOVEfndc7DihjTvYf7v8XcPTJN79bcp67VYwSQdDTYvurCExABJgBqNCQ2c1/+kenmVKI0lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCKteFmiM8lq+29Vnt5yZoBBb93rYozR3Vg6DK3OfRQ=;
 b=IfU1zom2hjHAec3BI4AKIcq9X/5Jdj9DMYpa2eyz4FXuNlZt4CcM7A9JS1pcmBYbhAEyxO97BIwYG7SggUCWA0SkSQ8iB6rVFhIuC+jtnbTZM5sYunJC77wIeIpJg2JYMCBQFvdfBhGgW+SH90jvpQ0axc/C/uCxdE0UG4OT+wRe6dWMPBzatJ0C//4OSkabHd9wMab4K5DTNgL8ysweUGjVoZWsFbhHvvKkzP3B8f9RMdvALWMk0jcdORIb4YCpm+Rk98zd0SJseHYjYVIItxBzIv/Tvolwl681vj1/xvEe4cyINAc9nlyQN502RvfEstpEuCJ88thaqqsH2hWySw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCKteFmiM8lq+29Vnt5yZoBBb93rYozR3Vg6DK3OfRQ=;
 b=qWgoFyPDY0e8UuNaJqSLMzXVL0LZq0mnoFGALryEfk8+W4dv3J6irPrqcBdxK4IyiGczpdaN3NFZv+7yLBlSTuflynww1FIrphJt5eP1WXzErzfjsVyPawf7yL/Hg80XtnyWRjrdJusl2WiHkGdtfO6y+UjIqof+ulirhhVYLYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5609.namprd13.prod.outlook.com (2603:10b6:806:230::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 12:36:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 12:36:01 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Bin Chen <bin.chen@corigine.com>,
        Xingfeng Hu <xingfeng.hu@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 1/2] nfp: add stub implementation of DCB IEEE callbacks
Date:   Tue, 10 Jan 2023 13:35:41 +0100
Message-Id: <20230110123542.46924-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230110123542.46924-1-simon.horman@corigine.com>
References: <20230110123542.46924-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0001.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 7933e2a6-2643-45cf-dd88-08daf3073b19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f9If3Q4lgML8jEMkf40fCoRtNYMlonRB5hw7O/BWVUO3MjOot9hKSPUcZJNs65bJWUAkrxEm9Q9LGvBrACi8RCYJYACW2rr042MXnzh+I1VCd3GcmPU59TuGmkBhlT81bgbB/1+0XuVGni18a4ZaLXCE2KM6dPfTbXeinIFJv5vrePTxENgwMX4YZ4rj5TzJ5pmQFogZYV/iYKlP4RT2Md8XvV5mufjrjZ6tfSI01dKh0N/p01C6x2Lxdwj7jquYs99T+Mjg31qI9g+iT6Hmpqb0PdGdOpjtRd3kWtBfNmlxZX9sGykgKFqNpyLYMSknJ6HOfzZoJsl3oR/WoLQUTlAvbDMUx0P2F83jcWflESR2APFNUNVTpDuvZroS2XWQ3YkG43AJOUEdi2/xz13UKsl+1MlPH+6xjRFJXNM8kI8mreS1y761FXwXo4yTFBeO0wj6bSqh9EqEs4lIAcZXs+opDcPVdNsZEyshLE8FQa3qSqISxKGGUwrbyWM7oiuyeLYflHL6h47xjX8A0IwPL8DP6G5i+zdgcxeiaobddGq9fHTnWOwyisjzp4P31ddhzvrw9aA1WRx7XNQAi5ZMucyNH3qu2dJm5jOrNVFHPXO3kJ4B2Iif5mum/qlR8ixhzmBwJHlbfqK/178PMqqyzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39830400003)(376002)(366004)(346002)(136003)(396003)(451199015)(8676002)(66476007)(66946007)(66556008)(316002)(52116002)(4326008)(110136005)(54906003)(44832011)(2906002)(5660300002)(8936002)(41300700001)(36756003)(83380400001)(107886003)(6666004)(478600001)(6486002)(6506007)(1076003)(2616005)(38100700002)(6512007)(186003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gJZzK49hgotjcKuQrGzGaggR537z7l3d2JtC6rS6UsmF+dSM50Wtx5a6cEyw?=
 =?us-ascii?Q?VSoEThZx3vM/YJtE11EeXmsCQAYkjaPKz/ax3zSZcdBVBmCo6QW6NmxFdUur?=
 =?us-ascii?Q?6E0jUSlqm5AvYrV/+JHllDyEROZ3WEJ2/XMlNJew75BvffVuK/Hc35eLGttH?=
 =?us-ascii?Q?dFfODAusDBxHQ1GrHfLmqIDwnLoRpNksVJUODQhBhHnefzXLYnKzI9FYAiog?=
 =?us-ascii?Q?piRNOixNNtIgphT0izg9gGVQRXLxRnSay6Wsjs7Z1pgzM2JOMi5Ks4RnkNif?=
 =?us-ascii?Q?5Jxuvwvp7+ScA7MazdA83FKfnEmFGtSSj4eE5fWOXeSd7yCc1o9cNufZAouo?=
 =?us-ascii?Q?f793q3Jq9qlDwPffXx81i9EoZWj8tP8xnJ/AAP3EZuaUE/15OLI0rB/8M8E+?=
 =?us-ascii?Q?wqT4ifzaG6WGV3p2JqrA3qOuLhaPHQalAfwUCr9QKdu028ZSbYexTJyx0EUL?=
 =?us-ascii?Q?1tlJ2V0H+6WJMtlqkznsikOdxpCw2OYEyzegaEsyQnorJKqTtHb1u4YURcgu?=
 =?us-ascii?Q?uKjOt1YVxDeuJTcTTGtr0nxTISroct48BPeegBnbHwzN6haxHarHBPcrlNuU?=
 =?us-ascii?Q?yQlUOZx1T32HBOBnBa1ajq3n6KIFEut4gQiQcFxOusueGhLmjsv0M97BpkpM?=
 =?us-ascii?Q?3Bi7Y4C09r1iZWYhcWoEedpuRjVxSdzHpVVCZriB1agES2vCSrUA8nWSrMW/?=
 =?us-ascii?Q?yUXCGziBtiMAFvDT3Sig1dM85t8ylagvuO1xstI/ynZW8YFdfkYHJS5az/AH?=
 =?us-ascii?Q?XaxJlCtS3Upgh6VVQX/P3JagPJUAcee1pJEgMlUw8vYjcBQ//tfBzovyz2YL?=
 =?us-ascii?Q?wZRJ5IwEcAjeRnWR4oN00HX+zUYSGUVkKxcTtXPewnGgzLob5xNnare7kcyD?=
 =?us-ascii?Q?PFmTSlGsAhTXFc3oAK2WYvbuD93ULnHqRGO4jbKgZzH/m3CxOc7kSlnixMlG?=
 =?us-ascii?Q?N+yQ3Lgy1rWANG8O0MncnaAeMe3Y6U1WjKo5EnnQRvu756zq0hQ+UhmSBHoa?=
 =?us-ascii?Q?VnGaWlPA5NBka75WHvlbt679hz4E9Re8yPez0XSeWgCCyoVyirzvT6p0BQg+?=
 =?us-ascii?Q?MEihTr32XWbzicHHbKXZobSsACDWec/LUjAhPNL6HFoQpbnjAl2m2AMLHKWe?=
 =?us-ascii?Q?qtoC+HYZtEA25vlyvykI3g2hokTjqFwNsfCH3Hr3GGUGkcXNuaXwg8+Nn1Zh?=
 =?us-ascii?Q?1wYNYa2kzlNKcbqprvVSPCF201khXqIYIi4Tqh7espO1HKr7iMxpqqAo9oLT?=
 =?us-ascii?Q?ZwCd0tdEKZ3LQoJBw9hoT9UEEuRmS7Qy3rvkvyff0gDigKlN+OOiixm482Ys?=
 =?us-ascii?Q?E6bDWa/xapqcNee2+zWPIxtCGKu93Zjzhkqa5gyB5uD9soqGgY8EgPlEdRWR?=
 =?us-ascii?Q?T3uncsahExrl/1DJFnTfJEajRBjxmV5s315+MLm7ca+FSDtveYnBeIHCKbqs?=
 =?us-ascii?Q?zXz1ZtKRUDrZulUE+EtvyGBH1zumMjTV0iiViDDqm9VPwZoKTT7Y+nSuuMLX?=
 =?us-ascii?Q?/0lQJHjDRLalxNUWC0nenQS4d+JUoJot3lreDDOwCKbC5fpc8qvu65GO3Q2w?=
 =?us-ascii?Q?hI1agMIrwGKRQCeILpG9gmPI/deQ47+1WGCxcYRIQRzCAuQa+BnxGeqVYCH6?=
 =?us-ascii?Q?fcQjxa1ACYoYFEKEcjoVaJxNbVkJcvaQT1O5nzG0DwTYM022JyephxQMdVfA?=
 =?us-ascii?Q?jwNf5Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7933e2a6-2643-45cf-dd88-08daf3073b19
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 12:36:01.0092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MYBbB4temtvk1DE/0qjiVwaPqVn9tXVWTqbl1cfP65do9DK43Yx4R8S6YRluNZgrG3dZIQWY6dXDOa0JKVKFrXHZze1l6r9jE1KLW03bR4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5609
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xingfeng Hu <xingfeng.hu@corigine.com>

Add stub implementation of DCB IEEE callbacks to allow exercising
user-driver to NFP driver control plane for related DCB configuration.
These stubs are to be filled out with code that interacts with the NIC.

Signed-off-by: Xingfeng Hu <xingfeng.hu@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/Makefile   |  2 +
 drivers/net/ethernet/netronome/nfp/nic/dcb.c  | 73 +++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nic/main.c | 39 +++++++++-
 drivers/net/ethernet/netronome/nfp/nic/main.h | 25 +++++++
 4 files changed, 137 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nic/dcb.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nic/main.h

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index 8a250214e289..c90d35f5ebca 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -83,3 +83,5 @@ endif
 nfp-$(CONFIG_NFP_NET_IPSEC) += crypto/ipsec.o nfd3/ipsec.o
 
 nfp-$(CONFIG_NFP_DEBUG) += nfp_net_debugfs.o
+
+nfp-$(CONFIG_DCB) += nic/dcb.o
diff --git a/drivers/net/ethernet/netronome/nfp/nic/dcb.c b/drivers/net/ethernet/netronome/nfp/nic/dcb.c
new file mode 100644
index 000000000000..91508222cbd6
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nic/dcb.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2020 Netronome Systems, Inc. */
+/* Copyright (C) 2021 Corigine, Inc. */
+
+#include "../nfp_net.h"
+#include <linux/netdevice.h>
+#include <net/dcbnl.h>
+#include "main.h"
+
+static int nfp_nic_dcbnl_ieee_getets(struct net_device *dev,
+				     struct ieee_ets *ets)
+{
+	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+
+	return -EOPNOTSUPP;
+}
+
+static int nfp_nic_dcbnl_ieee_setets(struct net_device *dev,
+				     struct ieee_ets *ets)
+{
+	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+
+	return -EOPNOTSUPP;
+}
+
+static int nfp_nic_dcbnl_ieee_getmaxrate(struct net_device *dev,
+					 struct ieee_maxrate *maxrate)
+{
+	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+
+	return -EOPNOTSUPP;
+}
+
+static int nfp_nic_dcbnl_ieee_setmaxrate(struct net_device *dev,
+					 struct ieee_maxrate *maxrate)
+{
+	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+
+	return -EOPNOTSUPP;
+}
+
+static int nfp_nic_dcbnl_ieee_setapp(struct net_device *dev,
+				     struct dcb_app *app)
+{
+	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+
+	return -EOPNOTSUPP;
+}
+
+static int nfp_nic_dcbnl_ieee_delapp(struct net_device *dev,
+				     struct dcb_app *app)
+{
+	netdev_warn(dev, "%s: UNIMPLEMENTED\n", __func__);
+
+	return -EOPNOTSUPP;
+}
+
+static const struct dcbnl_rtnl_ops nfp_nic_dcbnl_ops = {
+	/* ieee 802.1Qaz std */
+	.ieee_getets	= nfp_nic_dcbnl_ieee_getets,
+	.ieee_setets	= nfp_nic_dcbnl_ieee_setets,
+	.ieee_getmaxrate = nfp_nic_dcbnl_ieee_getmaxrate,
+	.ieee_setmaxrate = nfp_nic_dcbnl_ieee_setmaxrate,
+	.ieee_setapp	= nfp_nic_dcbnl_ieee_setapp,
+	.ieee_delapp	= nfp_nic_dcbnl_ieee_delapp,
+};
+
+int nfp_nic_dcb_init(struct nfp_net *nn)
+{
+	nn->dp.netdev->dcbnl_ops = &nfp_nic_dcbnl_ops;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.c b/drivers/net/ethernet/netronome/nfp/nic/main.c
index aea8579206ee..f78c2447d45b 100644
--- a/drivers/net/ethernet/netronome/nfp/nic/main.c
+++ b/drivers/net/ethernet/netronome/nfp/nic/main.c
@@ -5,6 +5,8 @@
 #include "../nfpcore/nfp_nsp.h"
 #include "../nfp_app.h"
 #include "../nfp_main.h"
+#include "../nfp_net.h"
+#include "main.h"
 
 static int nfp_nic_init(struct nfp_app *app)
 {
@@ -28,13 +30,46 @@ static void nfp_nic_sriov_disable(struct nfp_app *app)
 {
 }
 
+static int nfp_nic_vnic_init(struct nfp_app *app, struct nfp_net *nn)
+{
+	nfp_nic_dcb_init(nn);
+
+	return 0;
+}
+
+static int nfp_nic_vnic_alloc(struct nfp_app *app, struct nfp_net *nn,
+			      unsigned int id)
+{
+	struct nfp_app_nic_private *app_pri = nn->app_priv;
+	int err;
+
+	err = nfp_app_nic_vnic_alloc(app, nn, id);
+	if (err)
+		return err;
+
+	if (sizeof(*app_pri)) {
+		nn->app_priv = kzalloc(sizeof(*app_pri), GFP_KERNEL);
+		if (!nn->app_priv)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void nfp_nic_vnic_free(struct nfp_app *app, struct nfp_net *nn)
+{
+	kfree(nn->app_priv);
+}
+
 const struct nfp_app_type app_nic = {
 	.id		= NFP_APP_CORE_NIC,
 	.name		= "nic",
 
 	.init		= nfp_nic_init,
-	.vnic_alloc	= nfp_app_nic_vnic_alloc,
-
+	.vnic_alloc	= nfp_nic_vnic_alloc,
+	.vnic_free	= nfp_nic_vnic_free,
 	.sriov_enable	= nfp_nic_sriov_enable,
 	.sriov_disable	= nfp_nic_sriov_disable,
+
+	.vnic_init      = nfp_nic_vnic_init,
 };
diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.h b/drivers/net/ethernet/netronome/nfp/nic/main.h
new file mode 100644
index 000000000000..679531fe2838
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nic/main.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2020 Netronome Systems, Inc. */
+/* Copyright (C) 2021 Corigine, Inc. */
+#ifndef __NFP_NIC_H__
+#define __NFP_NIC_H__ 1
+
+#include <linux/netdevice.h>
+
+#ifdef CONFIG_DCB
+struct nfp_dcb {
+};
+
+int nfp_nic_dcb_init(struct nfp_net *nn);
+
+#else
+static inline int nfp_nic_dcb_init(struct nfp_net *nn) { return 0; }
+#endif
+
+struct nfp_app_nic_private {
+#ifdef CONFIG_DCB
+	struct nfp_dcb dcb;
+#endif
+};
+
+#endif
-- 
2.30.2

