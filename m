Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67A023A007
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHCHIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:08:21 -0400
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:25506
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725806AbgHCHIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 03:08:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSXyyMRp5zAVW7cW+e1O43k6Vlujb7v6SCsaeSuaa4pntd9wJk5Xri+JQhPoWYn0NLaksTk1qy4vdlIxb8r+xhnA1ZuEAy3tWcnSQQULNLOqWOsetpsFIxoRqQUyxhAIQP/kAnurIV4bm06c25cCeJe35jDCbG1lSW7j/RHBwPaipuC+K37nxTLKAQKkQA3ExhWrEhRQxziTeFeMUOjqx3aCjZD4khVTVYzjBLGwEEmvRvc3qtbSRl5O5HZjfKLrMGygb7juSA79+zear1w7HjcbOl3KuDVwrkVcso0iM4cMZeqz+umA0nxUqQektnuxi+XhknH5mDB1GzRsV26xug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5sCP2FZ09v7wBTcSV6/InXrAQGISUkMRsYfgNxsd3w=;
 b=WKqy0+/Wnf12Yl+4p6MFR140FQgjfyWsnXnzDIta+kpNK17FKdj2onMeyNc5Eb8AQ9t2UdUV40j+NKfm3CLY2lvqUDfXdSsy5rH8bRVgaAAlKlDMGMaK8owykw10ypSX0yP73+4ciTFtxFyckyLCJNMr7/bdfGRqLdolWTrbU5X1Ku1z/P56kEYXzmBU9kGRY3gOxZRiYdo5gBYA7IsWQruEjGIusaF/cqUvDww/CsWGpp6V22MGfsRwmCl1hXXkCJh5gFDSI6PxjzZGcweEwl54vmzH6KQk2qs3+cIHg47kXGtFuvayUF32Hk7gaXdlTHRPKIoMym5pod1yPcnyxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5sCP2FZ09v7wBTcSV6/InXrAQGISUkMRsYfgNxsd3w=;
 b=jqdG8zpVDmisGcJrSnqfTgq3NAjfLCRIIzMe72cppNwSBxqd6oSChkdNVb9dvy+aT7v6Mbi52z4NsahxEc9Qpfbfkn+/Xi+zywCAcz7pyrtP9ReAmoSMXqKnpczksMVb3brtlJHgk+bwmZWqfbwsAenvd6lU79cAK556zaGp4Co=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB4356.eurprd04.prod.outlook.com (2603:10a6:208:5c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Mon, 3 Aug
 2020 07:08:03 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 07:08:03 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v3 2/5] fsl/fman: fix dereference null return value
Date:   Mon,  3 Aug 2020 10:07:31 +0300
Message-Id: <1596438454-4895-3-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
References: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0007.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR07CA0007.eurprd07.prod.outlook.com (2603:10a6:208:ac::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3261.13 via Frontend Transport; Mon, 3 Aug 2020 07:08:02 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8df47000-d7ec-4035-e313-08d8377bf6aa
X-MS-TrafficTypeDiagnostic: AM0PR04MB4356:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4356A6573DEFD5E7E6C9A13DFB4D0@AM0PR04MB4356.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:475;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Al7neYpR5xr2cznbO6wfaTJYCsvsLy4k8F8xnRuBGB1yX7Wz4FUAQuIGkfpaGQxFVtM0tLFzREIZGvFSK3V6f7+SwVGKXtkWhCUDuAHQhJoS+W3NjoFsXhB8dCCGn00hVFDXijUnZZDt+X+DWBe6qWU5HrR47FvyaNFIa5ek4TGO0xTAZTQTkuAYNILz1Vr2YmMDRj/A9Q2TOetlbODF6Ed7hc5+YeqvuN2H9bPrhgDLqdGn4M8ACjt/d8CcqSHqRTa/RazBDOEnL5tjhS//hIvkB4AiyJiUNeZOdSWR07ziFof6KPxHNb8anmHQWtyWoK0jTgyDE2PbJl1pMIykOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(956004)(6506007)(52116002)(83380400001)(6512007)(2616005)(316002)(36756003)(66946007)(2906002)(86362001)(6666004)(478600001)(66476007)(66556008)(3450700001)(6486002)(26005)(4326008)(8936002)(5660300002)(186003)(44832011)(8676002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vsaWbhwutHTy0HRZnb9Z+SpZ+cuJownAS/G9MEC+3LCP6plJufzqPqMSfdN2Eena8XX/llSf0rel1MfYeyqpOLhGVfSXxMrc6CWgdPu+Ui823FkZLMUUdexgRQDzNYSNBu0Qkj96bMOLtwIN1zrNhc9Aj6Jrr4RrIwUGB+PLApBUH+NZ2jAHKzckYA9bV/odKDwxPy6aKrxedycJKfcJ9bbMWmV8Xblk59gB2oHh1GL1VLZSr1dwv4iV0g3KaGRHlfKGMrpyDGhuBddyzMIRTxouX39qbPU4a5S5rv2QLLskQEEFG8I0F0ioUBIP8Ug+idqOIwM/O/Gf6996V3vu56qDcUA1N5kKZLeO/8ubFlDAx6biYYtXJ3uXeUjEhUD0qwJHAwdBLWIg3z82gd8tF9zZ+f/FiuI3gz0eA7+LfuOh6Vm0phONvzGyzM8yVhEHQGW+AhyZtBfYOfzhAH1U39OlGovgacQEwhMusq7RaKupOQlbBoooilgMAE8mv6m6QujXesfL05Jlyn73HAszeixm22VNAJejDuqwp3j40ijDkR2xAHNNtn0KF9sBgKQIo62lXkPdPTs9LKfTljI+LAMHjKRn+G5dRkqbQmIquHFX1uFM9FzGhYoLycRjAwvh5VcaYofF+c4P4gSRoO7LIg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df47000-d7ec-4035-e313-08d8377bf6aa
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5443.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 07:08:03.3563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NWYWNoKWZ2NchPRKIjGY7fKKVeJsgPLW3GxaIbcLYlogyDdpG2nh3Gtzff4vD0uu/H8HgEfZdLoDwDhPiEuZlioaqK9garu94M5fjGrJ7hM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4356
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check before using returned value to avoid dereferencing null pointer.

Fixes: 18a6c85fcc78 ("fsl/fman: Add FMan Port Support")
Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_port.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index 87b26f0..c27df15 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1767,6 +1767,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	struct fman_port *port;
 	struct fman *fman;
 	struct device_node *fm_node, *port_node;
+	struct platform_device *fm_pdev;
 	struct resource res;
 	struct resource *dev_res;
 	u32 val;
@@ -1791,8 +1792,14 @@ static int fman_port_probe(struct platform_device *of_dev)
 		goto return_err;
 	}
 
-	fman = dev_get_drvdata(&of_find_device_by_node(fm_node)->dev);
+	fm_pdev = of_find_device_by_node(fm_node);
 	of_node_put(fm_node);
+	if (!fm_pdev) {
+		err = -EINVAL;
+		goto return_err;
+	}
+
+	fman = dev_get_drvdata(&fm_pdev->dev);
 	if (!fman) {
 		err = -EINVAL;
 		goto return_err;
-- 
1.9.1

