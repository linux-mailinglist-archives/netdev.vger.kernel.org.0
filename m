Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5863F1BC4
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 16:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240597AbhHSOlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 10:41:11 -0400
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:12417
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240582AbhHSOlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 10:41:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ihi9Xy8R9v3OI8AMp0pLBQ9mynIxm6VkXtYdF2DcAUfdxmNudWQrx5bcz6cah/zGJ9EoObdolOKckrdlW7LkvzfCbRDxc21ay+4xDIdl7lzRbDAQiQUvnvxqy7If88uFwCRPP8729cBhEPAvhzoyIHNnESbjDB/ThakAjs6UD4PS6D/7+KaYu0iHvBPF7bNp8Y4kai+wGSYdkEm/N6Lmx/L+Bp86Y595aOWdsbCPK5xsohuBUrGjACinbr+xmGsqrXxDXm/pSkBo2L0NyImapvPVWSaQQX6MW2yoG9zRQPgh0ADZjENOFs0mgcidQKE1M88FIJpYyDZG7NC3KzmSOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yD5ZxnP19TMkzQoNXdPA1Iv3rmeMcHlTid5WHOG0+A=;
 b=KJvFM/N269YEhrKgg7ou6L4xqtkBJcx/wYO69Nqy0PV/33CXiHsoBuSeRnu55d6yonxgrcTG6M/22ops0wmjEVUcJPgvsACaWZaLfvVwi8LhYe7IjoD6ocZtE2Z7VALaRRvPW3KzLLTRYXCEw8nnesRzGo2M3kZ0UnIvT0jS6kEfM3kRkFFfJpljSPQr0fekw0nbLTveWLTpHzH15jbtlfh3u9QLcMfmlRau6aDeazy0Y9lDYR5U3bEMaaUTBxPYU6u/YNOHcgKLRbv8dtoklicQA5vNbne8SUJKGpwO95CX7Yw2We333ZHE9ywM/YBsLWMcy4I1ojVpypflqxB+FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yD5ZxnP19TMkzQoNXdPA1Iv3rmeMcHlTid5WHOG0+A=;
 b=i/06iujzyOcBUBYGxBjtxd+9X/Nxz9CTOqWq86dVNUWSTTnRqTabrZxiZxgk76KUSYa7sABrkIP4hWoqrfma7KMdyeYPqPA7MikIQR9VvFiV9NnkYHc9MjySh8bzTOAsg17XV2//vwOlUjydmB9qJEuGzQBX1phVq4+C7BccxG8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4430.eurprd04.prod.outlook.com (2603:10a6:803:65::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Thu, 19 Aug
 2021 14:40:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 14:40:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/2] net: dpaa2-switch: call dpaa2_switch_port_disconnect_mac on probe error path
Date:   Thu, 19 Aug 2021 17:40:19 +0300
Message-Id: <20210819144019.2013052-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819144019.2013052-1-vladimir.oltean@nxp.com>
References: <20210819144019.2013052-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4P190CA0011.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 14:40:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4024cf58-67bf-444a-6eb1-08d9631f4ba6
X-MS-TrafficTypeDiagnostic: VI1PR04MB4430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB44308CCCE02C800E1C251770E0C09@VI1PR04MB4430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9X6V+PJNsQu8aqQAWFyyrY9+b5NtB3NA6KfFoOmDqh3GCPC6zZL2NM+hwM0h/Cq+OvPVKGFplDowOawd5J8HhkqOtbspCGvNR7DitB4lCetWPhg8iW69b7geA+0UluwUoOkvgBkh0S33y444BgwStwSz4tRzNVHwxBaB5FUzw8IuXCY3RyOzD+/FA1yMacVLEBwTcih+msdB+G8m3zHEYd6Y3i7TiNl10FgDQ+dLYhuizIQ2Hupfjs0mUfqi+M7DzdX/LTEXwFLUDBjJKjykmjU7EcF2gYTtVbGlMXKZRdjCmY4fzLjsV34xbDbDaxZtG2dLHF6vU9KmOrv1pBybzj4BccP+OpMvsl2bSAuWssKoaug3EObGmRh+xZ9sSiuU2uTrDSFJnkdpYU4osZN+k93flI3kIORcnbl3A+x0/J+uGlR7VhNkxFnzW8MWX8ZMDiteuct8OW89hoT631GWCrKX0XzZjZUQLSm6lGFLlD9ibP6DaDqJAaSc6CEF6u8Eg3YbHFpJpaRwzKP64s8KL3jiQ+5aahD4T9FfwVI3cIgC1ru1YcV2GdrPDtjO+e7kaXv7WA3IYdxfaxsG8eHK2CS6WvwiO3hXITOVW6Fen7FqsfRFifQOdD2c87WEJxF2OcD2h81vNKj2YemhCMzczdxxpi+h8/l+BDGeAUFuo6xxikyjS+BdCmmBjWy5LcfaLz6+vs6PJddVH1IWf+nkHIgKa/yLNauikUJXXixWMqx26GOWhtFmeXaDtdUgY4VBeJ4DSkHIa660OKgGZbwjk58YfrqBFYWD3fT2nP+9YdA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39850400004)(52116002)(83380400001)(6506007)(956004)(6486002)(966005)(36756003)(316002)(38100700002)(186003)(8676002)(1076003)(38350700002)(6666004)(86362001)(110136005)(6512007)(2616005)(66946007)(478600001)(66556008)(26005)(5660300002)(8936002)(4326008)(2906002)(66476007)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WZVEg2zz77krheEAdhjP8ZRlpqpyp4diToKwuDkYcVf/G+/DnbYTerq8xy7S?=
 =?us-ascii?Q?z2ve5/2UcCkBQDDyCm0+ojGg1eIpVV3/5GlzqkbVRLuv8yoEqZqF43WFqree?=
 =?us-ascii?Q?/B4L+xYKF9QV2QS8nqgiqeSdd7r3c+Lvf07ZvlFoIGXIXFJ3uXSnKnwQzNQr?=
 =?us-ascii?Q?JYUeXnsYcug/4FkPriWqf71tGs/i2AAfIUP32pOnPu5n/IAVLNGOQ+EEM/7g?=
 =?us-ascii?Q?n0gYsucdFdE5TTvl7k+6k/LwuCwJKMJygzALEgmBbdVB/LVSvWdlBLTfyhXo?=
 =?us-ascii?Q?jW0CLuW9+rXWo7NCJQjv74cnyBsS3zNxy1Ui1KwFcUlfa9XnzkW6IAAkgkxN?=
 =?us-ascii?Q?qNGTR6HGRFQbOSKUxz1dc48cCbo+5DUErn1co9x09d6IYMVn2xueha6ZjWst?=
 =?us-ascii?Q?ZO2l49Sc5ZYJZh4r9omP8IWLTAjFJsq/MOshYXCBEqLV5R8a29ozLhJc7KSy?=
 =?us-ascii?Q?EHhQ3ef/Cjzg7TxbXyFZOtZNtOBJ6fGT+tkor74yxC06OwzfdGjqGTd/UfiI?=
 =?us-ascii?Q?2RqdpqR74klcmR33DD7HC7ImfLwGYVx1QV6+jbOYKixym/xD5YxH0M9x9ihp?=
 =?us-ascii?Q?hadHGs+yf/+QbNn18zq7cx2aVBvln/1JIYn+qhDinWf7ayS+VfQJxPu9WmMa?=
 =?us-ascii?Q?JBBLgHQC9q9Qwi2HqcVyUaHfnEudru2mtd/BtMGOlYxQU5Wr4PFTYqQxv+6b?=
 =?us-ascii?Q?MDJrgKbNMF10D+Uk8pBlSh4pnuluzQNuJB69YcH+xSQLcqHP+0jc0v9q36Um?=
 =?us-ascii?Q?smYFCxF+46v76Nb0zdauMEsmOwIrJRDgVskxCy7JFRCgz1dn36GAEIruQQJ6?=
 =?us-ascii?Q?nWdaBpaoPrJ9lQ6SATcOaEjBwwQZjr3Phfz9Sx3n8g788weC2zIWeX+2BKNk?=
 =?us-ascii?Q?oZQs6FwxvhuZ073/SSlgXzY+jO3on7gonAoATtFASufLcFcu0O5sBHPhzbAQ?=
 =?us-ascii?Q?SfaZZzrQM9xqrkRbBhgJN81pbUjfwLQX8db0e3hOmg5CHhbHBlJ+/1R2YtCr?=
 =?us-ascii?Q?EdpXFvxQczkVeWrBg6H4Q1oEmXKg2nwxja6dPobvgzonKyV9cAqUkKEr7VWq?=
 =?us-ascii?Q?rKwB07+uuxBGz7hXOkSeHzOUINoA4ipYTMM/z+RgBItoE6fo72LUuwCBqxNh?=
 =?us-ascii?Q?gAI00SACg1+DcHjD0Lxsz6MCzFpyi+qjt5jmFh1PiC138GdjEfxnyb4+ABc0?=
 =?us-ascii?Q?zs3FeOLr/755nQDG8p34GHmE55q/uVGQpwvVWbu8AxOrRbcTx1eUX2klPsCY?=
 =?us-ascii?Q?+N2tWIt6dLxPoGyXzlQoJkiZTDt9avkJTWLNTKSsz6+5k3I/3INLwuqvJP6R?=
 =?us-ascii?Q?BTh1Mo09e8F+09DpmCb08zNl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4024cf58-67bf-444a-6eb1-08d9631f4ba6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 14:40:31.5339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7K+ICv3edreSp1AjpbGjGM+mhgqASOtueW8X3vCi10mKzEyDCqSXIJVaMszi1KhII+3l7dE/UHAQbVsn7/LqFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when probing returns an error, the netdev is freed but
phylink_disconnect is not called.

Create a common function between the unbind path and the error path,
call it the opposite of dpaa2_switch_probe_port: dpaa2_switch_remove_port,
and call it from both the unbind and the error path.

Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Note: the dpaa2_switch_remove_port function is placed so far from
dpaa2_switch_probe_port because I wanted to avoid a trivial conflict
with this patch on "net":
https://patchwork.kernel.org/project/netdevbpf/patch/20210819141755.1931423-1-vladimir.oltean@nxp.com/
which moves dpaa2_switch_ctrl_if_teardown around, and this would appear
in the context of the "net-next" patch.

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index d27c5b841c84..a1a2dc9e4048 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2925,6 +2925,18 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 	return err;
 }
 
+static void dpaa2_switch_remove_port(struct ethsw_core *ethsw,
+				     u16 port_idx)
+{
+	struct ethsw_port_priv *port_priv = ethsw->ports[port_idx];
+
+	rtnl_lock();
+	dpaa2_switch_port_disconnect_mac(port_priv);
+	rtnl_unlock();
+	free_netdev(port_priv->netdev);
+	ethsw->ports[port_idx] = NULL;
+}
+
 static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 {
 	struct device *dev = &sw_dev->dev;
@@ -3201,10 +3213,7 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
 		port_priv = ethsw->ports[i];
 		unregister_netdev(port_priv->netdev);
-		rtnl_lock();
-		dpaa2_switch_port_disconnect_mac(port_priv);
-		rtnl_unlock();
-		free_netdev(port_priv->netdev);
+		dpaa2_switch_remove_port(ethsw, i);
 	}
 
 	kfree(ethsw->fdbs);
@@ -3394,7 +3403,7 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 	dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 err_free_netdev:
 	for (i--; i >= 0; i--)
-		free_netdev(ethsw->ports[i]->netdev);
+		dpaa2_switch_remove_port(ethsw, i);
 	kfree(ethsw->filter_blocks);
 err_free_fdbs:
 	kfree(ethsw->fdbs);
-- 
2.25.1

