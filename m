Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936F6234445
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 12:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732667AbgGaKuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 06:50:06 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:53202
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729141AbgGaKuE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 06:50:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEwjgqPEftPQ8JhzI5FCCSg7My7qQWZ2P8KFZbjhBuQFCTxt7lqtO9eEuQyTd+HI3nDE6C8hFXYaENQLcSh8cXZNavMOYQkFc+xkIIPqNjdJp4H4Uu3516U2EuWOs7nUKnU2GazqVvK1NnyI7vd8j4rgBVWbIzFFSth7LYfJ1PyGtLaUkeoN4n5+M08LVK12pq6dXPAF6w2UxMRaF6LHwMW6cllpVLFpEk8iFyGG7uCCtYCH1Frvnk5HIs3kDka4f8ksTQ+NGGYDs2ZWEbYHcKdg0Pxti3LwGKmZVOMs4MuFc4w6hG3XCEytexDgA2+2NFeKZgNJV/e7BQED79T54Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pG+1wGl8C1SXGE9DMjN6YD3DGi4ootrNph4b4P63Jog=;
 b=IG4j4cYZW1/wRP8TnboEUhzJmXapF7GG76wWE4ABz2hk0kaxkjwotpPlhXRCHv7Ocb/kKY05VdOaPahVv4WPmvuYeJ0Dg6LQAukki/I0HWLnOG4myNNwgyRy7qx4CK2HV4uHRCKR/mQvmWfLyj/Hh9V8DscaJgqlC2gkruhqqBxV2iQEIVI2fRtaV4yX9YD4wD7wjLVu/SqVv7UrMQOMW8fTNETGFMSFjRp49KGcvD6t9k3ZxoK5NMM6P/8m8zzU0BiyhYHxKU1xLJawjD+XxT4F//Fgzwn+PEPKqStQbCyilyfVmytyFlJt93b0n9dtX6p/+7zhVWU9mTvUHpHnxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pG+1wGl8C1SXGE9DMjN6YD3DGi4ootrNph4b4P63Jog=;
 b=WAQL007bYLb9U+s1mA9ZOpzs2YZUdD86naSep5tyxZiw9QEbRpfYc3Zzm2Vkv8xhXC7mofmFgGADgDozZOJ1bfWk9zkSmlZj09qg/haEyyXG+upn+9tzGE6vidyH3WGyevQU2HYN+tKNguq7h3+z7S36E9+Mvelkvz/Az8EfFIo=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR04MB5943.eurprd04.prod.outlook.com (2603:10a6:20b:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Fri, 31 Jul
 2020 10:49:55 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 10:49:54 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Markus.Elfring@web.de
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v2 2/5] fsl/fman: fix dereference null return value
Date:   Fri, 31 Jul 2020 13:49:19 +0300
Message-Id: <1596192562-7629-3-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
References: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0103.eurprd04.prod.outlook.com
 (2603:10a6:208:be::44) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR04CA0103.eurprd04.prod.outlook.com (2603:10a6:208:be::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 10:49:54 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3bfa406-8c14-4d1e-6c6b-08d8353f75b0
X-MS-TrafficTypeDiagnostic: AM6PR04MB5943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB59438C95B62EDABD7E8A5305FB4E0@AM6PR04MB5943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:475;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 28/lLwsAvWRe+wAvgFWmPU6TLl5GE37kDii966o+TcxGDSHxCjdm5lblbcCFnq1uecwNTbaNyI7VZF4HkKIN4WCn5f4wK5HJeN/1H0NfDTSe8bgVqZ/Jsrft/ZPRcQ4D0yK4cNHW53zKIwxILrN90Sv34aF5EPC/O5IRZYWvvRPkedYdUlU3QiyATFIYNJ2yDkKUvEWGkggHAHva7ebBMtR03CGarI50Kcn0JDQWOvejMqKX3YBSzQx05jK16kLNmVlg06b6TU8xbGxT+T4x1fVVHOP5zuK6Ek7LYyOiZvi2gBb79Qw7VhaeVv5MA/l0tJpna2WVFBrOo9UO0OB1CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(3450700001)(6666004)(478600001)(83380400001)(36756003)(52116002)(2906002)(4326008)(6486002)(316002)(66946007)(66556008)(6512007)(5660300002)(8676002)(86362001)(8936002)(956004)(2616005)(186003)(16526019)(26005)(44832011)(6506007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9p3eLu7o9q2/uYs6JGUoquhQQQsQ4k05PPe9BWTiJ/cTXLT8qFKb4QbSLAyNcqya0qQE7oNCFOtb2KdUhdTqHeG2CWoJW8hX0IZzdR7EJGwAIrmfFdfJCspUHeruo5CJfEIRFJjwa3o2HuoIKW59pxu4csWSVZ0AdiTqcypvshk0BeVWCuQud65b1uixIFfW6w03O+SX/KekdJaqg9LqBDpQT5zxkxTTl4CG2Xk8zfqRj2/Yev7wweal2b/jEI6rgVMwLGIQgYxDN/ADgaO5mWqjU/QkcV9n3vONWnFTUv8BohWiXTRyjd8R4mrPrHQUq3BCohfFPh57nYQcg7MPzkeOAQjt+vz1x18ii2pQ2JX80+L6BqFX7RpODqfvyydpsvbO/Udpttftq8nZQ3I3FveSS0eNlz2Z5Etp2chQbXOtujT50U68DtGvDzATEOZ7HFJuNMksf/6o5rQyrTA191aYu1o7q9iG2/hpDnfkpbVGG6Xvs+tlpcLnbENJZID2tYfZxGy1zL6Zl3XxW4UE7O8tNU3Btiu77VJKxH1PeU4lw6wRwx8Izhcij0EhJBg8+I9hoyII69+ptfe3mCDTelChIBVIKMHIAUT6zC2VB4uo4QwmWABMoeyl8QGAX71xV6duttHOFJ5j4OT7Y9r4ag==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3bfa406-8c14-4d1e-6c6b-08d8353f75b0
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 10:49:54.9022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZpEfbCYDKy62X8L0cT2JOQAwFz1TS8lWCzipDvj8eQCjXDHdZ4+/TnLSNhRBDWHVStUt1hX2tlfEQyL0BiXApu4/Msw7sPR+BGqsq4Iycok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5943
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

