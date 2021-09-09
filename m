Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FF14047AE
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 11:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhIIJYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 05:24:20 -0400
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:16515
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232262AbhIIJYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 05:24:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlfUBJzaf51KLzV3quvgkJ6ug5Gb0EP2UnXdVAa1JBQLByGlnXSpc3Wu70daE3N98otllXHd4QBcwuCmk8fw9o/bcNr/5TBXWhBwMesWcikr2e3+W1V3WsoofS3hIXEZ9jhcaYcfph1ZIrRYl06MKaMqsSe+ty3FaXCp5iTrqaTIWpBXfzkix24ifvmYvx6koYEv0KgC/ohBBkgwUMrpP2m+hsfXP23rN9H7IqEX8efDswKFa6c9a1uNmUhWmtFhAp6VKxSEEaNhEFm8wBUa0yHRtbvk8O/+8JBu8QI197rF/nLALYyHjDuJxGgDZOCFmOZ0htFDt7iJZcYhfsMX9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dUStuCdpcsCKQemZ8w157CaHQvZ+LY+JxQEdui4Wryk=;
 b=I1y4xiYxbLJaKKETmuy9wPTBhTQ1tXkPEko9Ntw7OulTYaDWinhtAjG21CYVFCASgxd2hfvct2q4DBEXxCZ/ESD0aUYlaBExibiX8iYurn9peZnAfG9QTylofdIhduVy5aO3wp0kTLd+l3I6eof1dS0WQ+Z497eS+P0aYTy81JwBPvVIKxHFcEoMi9k8GIol5lAixnAMGP0tOEd/3vRiAo4lQRWw2scZjixeAm7/HUyf35PPldzk2xpUBi1rgYy0x9xW7gj4RSVZPqlqmcFvtBFnguTfrIEA/Iq5foqBwO3EVR89cemoIeUKEOZtBzFuiEj4rrb0Se/rHKE5m4RrcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUStuCdpcsCKQemZ8w157CaHQvZ+LY+JxQEdui4Wryk=;
 b=JYlz36tDkzGg2WQbvn5495/+ftprpV6N343CAKaBIuk0P7S37YjAuCtL+9CorF4mAMXKQ2S43R+XTBv8EP29bfheYvhxGnG0nNSEyd3ryodKR54tHSso6ENGJICzjDAQIu4kvv4kNjLuRnac5pgsQhVBv1KDMBADMFED+0wVH0I=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 09:23:08 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4500.017; Thu, 9 Sep 2021
 09:23:08 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: stmmac: platform: fix build warning when with !CONFIG_PM_SLEEP
Date:   Thu,  9 Sep 2021 17:23:22 +0800
Message-Id: <20210909092322.19825-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::32)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 09:23:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d0ba1d6-0ee8-40f9-c1a4-08d973736f73
X-MS-TrafficTypeDiagnostic: DB8PR04MB6795:
X-Microsoft-Antispam-PRVS: <DB8PR04MB6795F4217B6BA6C34C61F493E6D59@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U13lrVtTMp7PTwQV12bv+uz2FmWk2+Q0nI9RqMmUVMGhCmBx1qJXCFBlS4ViB06NFjRFl3V5MqKVq7tixSkoMeJGr2uirKwoqfkmjEL9rFctxOQDKcI7TiroQJbuDYTtdxY5HoWJBJLEmKSyQTi+f0QHAn7UV5fsAvj6l0xQpR9r1vsN64UPEgZVNKUINy5DgOFHv/YtFi9OSvVI5NwNCASBf+aoeOqmO8hj4fp/HFl8xH1FT7LL6vC0LbQjJqls5FMAJx3lHTzcOGqRzPz+d/aKG2pqaRMEBihFRxid1gErshl7PlPzQnx2V3KtW0MMmX2qgpj4pXHaZFBiS+FlBmu60vO85LI2pa7hw+R1x1YMGJZkgRqHIo7HxnkCbruOA2OXvcpjeWruTPEPGo6KNVwHrI/UkjgYY5GoUgrhkkbgfCSE2C7H1WJs1ccVVyO2fPRoTVUVMwCzDjxauTdzc3VQDlbzhoVwcKb4Mzip10Ljd3W0pXTmulymLRXiQFYsT0V7YuKLN+yBYsLAkc/D4o6mQRKQVnhaeRahCXJ8QcXVV+fNlCNvHZ/iXIa3pMIF04F8+5MEVD465xzdcvFrz7LH+4Twf89RZqwjAtSsFeU9FIQzisCvPHaJTe3KOecEdc6Wd+gqS5FCUmuTR9RadXUbfPqh+B6dB/aFtxVgFcJeutpnd3qcAEqLnQjln3irDESg65ZWMeaXcEQKQi63nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(38350700002)(8676002)(2616005)(38100700002)(5660300002)(956004)(36756003)(4326008)(1076003)(316002)(6506007)(52116002)(2906002)(26005)(186003)(83380400001)(86362001)(8936002)(6486002)(66556008)(66476007)(66946007)(478600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E1Z+er3EWfy12RdEUD3xq9m37ijO7i9v2diG/5iSz2t/g65R3ycTop7PkXXx?=
 =?us-ascii?Q?Wq8qrJNVsfYLRnLmibGis99heVft/OCrupdX0YcQwjTifbmyxat261Iu6FaE?=
 =?us-ascii?Q?PCBaA5xUNqBI1Oea9rBNYEFmK6w6BeAiPMyg0VZylIBrtzdI8lcLscU0tbcr?=
 =?us-ascii?Q?ekBM3RHbq9ZMwmQhRpPSn1kAMNonh5CQKf791qvGmDA+mqTa+XaK1g3HFsZt?=
 =?us-ascii?Q?LyhD4+GpCmSIUkjucoiGV8m4Q3jo7iFPdqiM701i6Tzor+6W2W2yG8triyqk?=
 =?us-ascii?Q?d7gQ9MTF/hitwU+8YYTi9xbtrBPE/H1km2DTPaH7MfKqkAFFANUMWx8WNn8Q?=
 =?us-ascii?Q?2iGNSw88M0It4RuwCqPdUOfhTKNCVFVCAZdaBTYwCYvdNw+l8jgQJ5prN+OP?=
 =?us-ascii?Q?c2xeCFELQ+5AdfyKAdhCY4j0Wbqd2p4sL3jPDAMlYKMcl2L45+f6ABWblpii?=
 =?us-ascii?Q?BAVaJTT5huwoI9vhZPi+b4SJKuEFB95KrKW350IvL6bBXWFg8/J5+CAdWQR1?=
 =?us-ascii?Q?UTihjT/XpXEOaqT7Ylc+MIaqMoS557c6vEQNL3/kJq+4VWOuvbloPdMpypBc?=
 =?us-ascii?Q?tIpleBL91ztAznufksERxbLBQtW4kusXB1EMtuMnCsn8aLehjfgu+7a11qEA?=
 =?us-ascii?Q?w7MxFzrXM1oggd55ykp09A/gFyj4KzU03dBfTG1eSxfcQs40TAr0DWMpeSr8?=
 =?us-ascii?Q?+cNovpXUQdCNXUOaztTvVU9O3J46S15agPfb0eKHSvikLoVHue4aj8ForO6j?=
 =?us-ascii?Q?Ctr4mZ8Z2r6afLH4ZMAelALNXhLwLr5ECT4x5uqs3KpQc7pNGfe6QKqyLKiV?=
 =?us-ascii?Q?/Azc/+h0x/9VWHxHMh0ugUdLD50LhXj2doOcwoR7Io51oSyAePZtWDfboUZG?=
 =?us-ascii?Q?0fsrwjDqHyB37WBt8HNeXAaIbN7HUg4xXVCpFInNbmnc+Fw4zOEjAbaEnox1?=
 =?us-ascii?Q?sr8ieA35fXuiT9A89mWYbzBmC38DSKlLxQqALxQ1LkmCLS+vag9Zo7hSPY6K?=
 =?us-ascii?Q?br03v2tKp1K+9YxAbyWilnjMpjELEiI8LFFXSh/U+RaETmXhAESyAA78j9dv?=
 =?us-ascii?Q?Mv7Qijvw3AJqdkG377flCLnfk2Ma1K1RgcTSRlPG8D4K14KCEV97502oK2zg?=
 =?us-ascii?Q?zbUaPX74javl57ZPGFBCSnVIyQWqSAHZMLrqSJBW58ABWxHqTZymo4asEFcj?=
 =?us-ascii?Q?e57rnxqJc3/gt2IeTLGdoGWYXTPsDnyvEhA00tNWDVkrxuDIHisAsH1jBW5i?=
 =?us-ascii?Q?mi+r6g4WBOlgset3Ucgmlu/oXOFcJof8aKTb1AvGfiENrqWd4aHPcyu2X3dX?=
 =?us-ascii?Q?xDabPDMPOxJZLUeV3+QlDWCl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0ba1d6-0ee8-40f9-c1a4-08d973736f73
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 09:23:08.0495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NDJcGnHSQFH+SpHgtMxZsMDhabiCZXvKuNVHA4wnQG9IOme94fjV73hude4LGPXUCCTBts+9CnrQmTUGV6Qxzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use __maybe_unused for noirq_suspend()/noirq_resume() hooks to avoid
build warning with !CONFIG_PM_SLEEP:

>> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:796:12: error: 'stmmac_pltfr_noirq_resume' defined but not used [-Werror=unused-function]
     796 | static int stmmac_pltfr_noirq_resume(struct device *dev)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:775:12: error: 'stmmac_pltfr_noirq_suspend' defined but not used [-Werror=unused-function]
     775 | static int stmmac_pltfr_noirq_suspend(struct device *dev)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: all warnings being treated as errors

Fixes: 276aae377206 ("net: stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 4885f9ad1b1e..62cec9bfcd33 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -772,7 +772,7 @@ static int __maybe_unused stmmac_runtime_resume(struct device *dev)
 	return stmmac_bus_clks_config(priv, true);
 }
 
-static int stmmac_pltfr_noirq_suspend(struct device *dev)
+static int __maybe_unused stmmac_pltfr_noirq_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -793,7 +793,7 @@ static int stmmac_pltfr_noirq_suspend(struct device *dev)
 	return 0;
 }
 
-static int stmmac_pltfr_noirq_resume(struct device *dev)
+static int __maybe_unused stmmac_pltfr_noirq_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
-- 
2.17.1

