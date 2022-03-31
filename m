Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA334EDA89
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 15:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236869AbiCaNbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 09:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236843AbiCaNa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 09:30:58 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10080.outbound.protection.outlook.com [40.107.1.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F125AEEE
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 06:29:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFJ3+tihiU+BLvHpbeGWc5X/tGZrnKzZfox5BpeX5Siol3RDPv5Lm7xvGp9mMEEXTonrU/bX+b8ycP5vR9yEnFz65RXhFMc6HAGtulocUbkP0X/2EKa3RLna9HNi3srbYSF5bRVaJlHB/qEft3kzI68vwR3HtNRGa5MEAnQt8zTGS6F/XFGyNhcxCgpVB9+G8M80x2Tt/8Gfo0QxuC2PbM4TWfa1JB6cIAfUNaCw+odFmJ3LvFeydMjxDXzJZxxBCfhvKBE9Ph1odXA2dxR6X86BL7N1DFh9c7lH8urFK8Qvcv5TueSdGE+xwnxyn9q0c3XHgESNzkpsYQFK9dRIMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qk2JLlVmv/IugTpfcj88R3ajDF1OFdSI2cJ4QJgaYvQ=;
 b=ixF/Lw9fSlB/bi8NMmogHX/6AwZlKXMv1erl1+1LPPv7f8s/o7I6K8lzbsZ1MVfjQKZzqveed9wnY/wKq447sezZZtUvk8uSWk4AdtG1yijFKk9zmevouUoqNaahslhGy/qDi/irh5gc3QzRdu3aPTvjzo1AaJHOTYaD4+Xetu2dSKFcJjftfUBSVsw/QAcTo1GS0p1uA9VRCqWq0GqRShxbrvzH3MkxquQwGBgpcLMaqADa+r+afjHuOHNY4sv7z5QFa0/9JBJjiQDcUyapuyaPDdjhbvFP8O34fIebSejQpKMfOerQ2pMSgcjHqm5FKdcQGPscAWUG9ahDF5UfgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qk2JLlVmv/IugTpfcj88R3ajDF1OFdSI2cJ4QJgaYvQ=;
 b=SyVJ8khkwh/YtbCwgUMzRR3uMRibVYajJ4FvPe75XKTUhDmkByNsRM97gdd4u5HWFdk+xMtZPNmfO1WMkuDFS2qfU2fNiCUwzUxn3icennzU2NsMKTs8zfW1vX+rod5blBRjVAF/Cy5N5kGCCdXHk7MHH8hs+4QCsEeIfRaitrc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7039.eurprd04.prod.outlook.com (2603:10a6:800:12b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.21; Thu, 31 Mar
 2022 13:29:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f090:8a7e:c1e1:3d8e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f090:8a7e:c1e1:3d8e%3]) with mapi id 15.20.5102.022; Thu, 31 Mar 2022
 13:29:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net] Revert "net: dsa: stop updating master MTU from master.c"
Date:   Thu, 31 Mar 2022 16:28:54 +0300
Message-Id: <20220331132854.1395040-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0012.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ff78c6e-cf95-439c-7466-08da131a6ec1
X-MS-TrafficTypeDiagnostic: VI1PR04MB7039:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB70394BB4CF1BE98D1D4212CCE0E19@VI1PR04MB7039.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gZeF4EMHUtVjdKZwVyEDSXvL0NfDcsFBfkylP3T0QlI71f+v/lUY512ysfATYg3E5oFy5ZRe5D00s9YKEbo4mS5OEgFf3g5a+/wWi0s8STZdW0aroDBB+a31hNAOVo1uPNJp+lrEyDgBmE72376RaF/Z/1KL08WSze4FNBKvhB13zCDhTbShEGFS2AEmtsC/JIqF9hFpX9Rh9GjP2gZbVET6CXBbtL/uqXEUiQWHXCOwOeHlAaaBbUr07T/oXztDE0apibJgaCBTx3Educ0aSHD8JsZCPKvszW5z3AHUtbiygzBBtkTVsCS9O5fR2IyafhthvEZNma0Y+x53w03TYJLwreMY0Oz36FPpNI9tY6oHSsHI+HMsGhwksaR4VMC+C5EEGOm48oL5UFXZ0OF9n6N05iMQkfk9OaVmf4THhpCCR0uKPifihfng3mY0Qqgixc00pGwbQvp57LGcDM1Exu8A420H4OkRxkNTw/xLaJTlXYo/WRS3rbB7DNKr7v/33AeQkS3scqkLL4Vvx9EyeWR227mvczFqRqWzjeGxc1Q5HM+QRLiCOTowp2+K4335Z1wTVwmr7Qhe0X+ud23wcLcn2Ab8zu58xlp7n/PlZQQjIY3AH0KmePv03Snk9LnSCgL6Ri+qc+EjiSTqrEAsjTUJNvGneVDm0IF/62qXPZykCewJdK1vNrxyioZSgUoSdby4eQglgA+qsBGVI50GTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(26005)(186003)(1076003)(5660300002)(8936002)(86362001)(44832011)(54906003)(508600001)(316002)(6916009)(66556008)(66476007)(66946007)(6486002)(52116002)(2616005)(38350700002)(38100700002)(4326008)(8676002)(6666004)(6506007)(6512007)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4TdUGBk7hZwZudxRvU2JVdUVh4PoRuQ6lnyYQHYwdsEIc11M8FhLBvHRPM0+?=
 =?us-ascii?Q?YIeF8RuVek8Xk0M6nvse1zST4O+8X2NiiMZ9G3BH2cTr6QOGGuQ6GIowAQYj?=
 =?us-ascii?Q?JajPi/4X4H8ZjrQwzNb/V9zLumq7jb+knQEvAWdNk39zohdod+jd6Jl1oY8a?=
 =?us-ascii?Q?Vph0hlDah6M7z3fwj7hpfb5t6nt4okmD3ObndB7KOG9EZmteqH9QWlBKVgHR?=
 =?us-ascii?Q?+fOW6kHcildiV9M/L/VJFWn709IdLfvx/r6vcyHjYc3QYTHb1UwCwrGUI0Rl?=
 =?us-ascii?Q?QH1xIQre7A34sK+HvC6piLRDSs5yUpcthfH1tGEQC/nUK3j1WgUfAeSMZS4T?=
 =?us-ascii?Q?/Qv4gE6+k6pQDdesb+h6h1E7I4O+Vo5kYTLR3Gxwl+EtiRyej586YyYxSV33?=
 =?us-ascii?Q?NoP306SQAJn430t2FjUChCruirkUeIHK/QW1xq9HXUWRx9m91CzYDPptfKPP?=
 =?us-ascii?Q?zgXQJM6NcUrIFitxNpjD6nNK18Z3EbIP1VfGivARuA5TFq1Tb1RnZdTrSsbs?=
 =?us-ascii?Q?ypVVU9AtKOckH4+5+c3PEAhcXlTgc9O48VCcniwkVwFUTn7FYp+dy0vzVNrr?=
 =?us-ascii?Q?mGQ/NgnHlAMBh7EamEWp3b5OoQva2t55n2WF2ixmDmc1TPUSTwLZVbGp/rdv?=
 =?us-ascii?Q?JLjk1jzqXNLv1KUA0SrUeWB7UKjMZ5chOCqfj7eVigOeOSqBC/MDMTiwM5kP?=
 =?us-ascii?Q?PMcQXHjH6JADTppDudmLS1hSeEkxFdAZLLb90JZjykZamidaZ2677XJ9qvxT?=
 =?us-ascii?Q?QHdBFxBckm2Fr9+OjNIRtYwQjgaroJvAISo2JoOFrk85qqH6420GIp9QYRxr?=
 =?us-ascii?Q?d2vkbVY3zjeq0L4bPnRUhFloP4pjSPCpBqOrtp8ygnj6DrSdX7qmkEckFANo?=
 =?us-ascii?Q?0uRMaI53XYk+hixNGfpR2HCKjOcf02N4LlrHZ8Xj6zlJUCdr44K1BbV7K3B7?=
 =?us-ascii?Q?EhBsxaLbXlYQcnuyvKMmSppfLIZjA39yAjhf2zpdugRCabDkHnNfynxVycCq?=
 =?us-ascii?Q?33JnOC8TvES4bQ6ctb4tlfh34sRr9LxuHcN6tUvPu0YCVKEGh5R3HtVBJXdE?=
 =?us-ascii?Q?JZWcgec0ZluO3714dSOIxv0Wvawr6sPTqAP1r4gkLa+2Unn29bcMe1p1astT?=
 =?us-ascii?Q?YMIrOwyPKR28P/Hum6n6srp7uB43kjHsXYaxB5HjiKEm7ePGdn1bHC5+O/k/?=
 =?us-ascii?Q?JYHQi7Kr5SakuMBwVCj5MiP3KoZlGArjLbHWj9GG/UYohYhT1efsrJWeGp8F?=
 =?us-ascii?Q?/8TQJLadjr8baNKtUsSUF/ivLUZJtBtw3C6lEZccxwf2k1/EmqxkUo+/CqrQ?=
 =?us-ascii?Q?7x6BGSNbQZ51Fh0Vdh7e0vaol532VQ3nphwk7sKmUMVqcxdsgnEPOhgyFl77?=
 =?us-ascii?Q?YneI3tqwyQ8SQmZUb2+lEUAiqeEnMlYaiyWJ5NanEHzRsCfN4mPuphDVNtRZ?=
 =?us-ascii?Q?YrhNUCIH/9/jaRPXgjWv4k7eE7sQn+WPW2v7LQJA2vpeeXE7dTiFF6J+f7Ay?=
 =?us-ascii?Q?IiSVkEh2IK1EKqJwK6uZsH0+Ytqha+Zv2FDy1oibyAQxba2wgTlqdziOUPKd?=
 =?us-ascii?Q?qIazbiWJSgCWHxvRseDffkvaNckEF05pwzLm1P2oVpfJi7McWKN74siGdHX9?=
 =?us-ascii?Q?AQrWaGkNkUozT22/kEuxgmtSnmxRAUFOkHPFrvsLxllLDCv5NVbsNDBz13FX?=
 =?us-ascii?Q?JIVCdf8LyRge/2+FFxKw0UcezImZr2DOPT9x65u/48mVk2GQ1scBRq3jcdct?=
 =?us-ascii?Q?90NpfL8MTNJM15bTqlHZmnOjaL1L3uI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff78c6e-cf95-439c-7466-08da131a6ec1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 13:29:07.8033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q86jJDjzFz7twqdD1vNLPhbSAuV4NspkQ+zkrZXN5gScFqle8P8ojzYI/u5YtEfydB5EQUvn5ePIcZcZYlMrBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7039
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit a1ff94c2973c43bc1e2677ac63ebb15b1d1ff846.

Switch drivers that don't implement ->port_change_mtu() will cause the
DSA master to remain with an MTU of 1500, since we've deleted the other
code path. In turn, this causes a regression for those systems, where
MTU-sized traffic can no longer be terminated.

Revert the change taking into account the fact that rtnl_lock() is now
taken top-level from the callers of dsa_master_setup() and
dsa_master_teardown(). Also add a comment in order for it to be
absolutely clear why it is still needed.

Fixes: a1ff94c2973c ("net: dsa: stop updating master MTU from master.c")
Reported-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/master.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 991c2930d631..2851e44c4cf0 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -335,11 +335,24 @@ static const struct attribute_group dsa_group = {
 	.attrs	= dsa_slave_attrs,
 };
 
+static void dsa_master_reset_mtu(struct net_device *dev)
+{
+	int err;
+
+	err = dev_set_mtu(dev, ETH_DATA_LEN);
+	if (err)
+		netdev_dbg(dev,
+			   "Unable to reset MTU to exclude DSA overheads\n");
+}
+
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
+	const struct dsa_device_ops *tag_ops = cpu_dp->tag_ops;
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct device_link *consumer_link;
-	int ret;
+	int mtu, ret;
+
+	mtu = ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops);
 
 	/* The DSA master must use SET_NETDEV_DEV for this to work. */
 	consumer_link = device_link_add(ds->dev, dev->dev.parent,
@@ -349,6 +362,15 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 			   "Failed to create a device link to DSA switch %s\n",
 			   dev_name(ds->dev));
 
+	/* The switch driver may not implement ->port_change_mtu(), case in
+	 * which dsa_slave_change_mtu() will not update the master MTU either,
+	 * so we need to do that here.
+	 */
+	ret = dev_set_mtu(dev, mtu);
+	if (ret)
+		netdev_warn(dev, "error %d setting MTU to %d to include DSA overhead\n",
+			    ret, mtu);
+
 	/* If we use a tagging format that doesn't have an ethertype
 	 * field, make sure that all packets from this point on get
 	 * sent to the tag format's receive function.
@@ -384,6 +406,7 @@ void dsa_master_teardown(struct net_device *dev)
 	sysfs_remove_group(&dev->dev.kobj, &dsa_group);
 	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
+	dsa_master_reset_mtu(dev);
 	dsa_master_set_promiscuity(dev, -1);
 
 	dev->dsa_ptr = NULL;
-- 
2.25.1

