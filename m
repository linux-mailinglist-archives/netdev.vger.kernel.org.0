Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8C816BF6E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 12:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbgBYLQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 06:16:26 -0500
Received: from mail-eopbgr20136.outbound.protection.outlook.com ([40.107.2.136]:17796
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727068AbgBYLQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 06:16:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8cYd4EM+c0Yf+/6035Z7su3G3S8W3mpmeSqtsU0I/OFix2KOLaVYQyYHkwFXNgaPTpikrnW13zUhaCzZiGXECbmZ7GUtFDk5kX/ej/R9fmDejzPjh3XR6Sm8+n6K6JLBiMp+wEQ7A164d+nlysp3MUoN7VV3zcJHzJPoP9lytsLiqAqxVW0YVEAwxJlgHBLkk12K1eM+hIeqOvc/JmHQTkufDEOG1rWmbj7uv1GY9Uap+rq7wglq2kdN8rgWSJoOlEFGHqCIDKQUaGNVKQXiAPiFnzVN/oDd+I82Gst7nMyUQswsrovQDsra2d9cT4jchR/oHR6wPtuS63B/oztAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pEIAqFmMc+HyX6sqDhJusCinRHMtUlAnpH1EffPAFw=;
 b=Qtc4EexUHbjMFjdRtyIHXk75Vh1Vl0UJfk17GLAKVHvxpHbgM5NKy18se+kxU/ChdPgVN+ZvqgnnZbowEDsnUNZapAnLjA1M36PZq0BY5R6DdBHBYv3ShBjPC7I6wQRiMwtpnRTwBZAPGjHTZYzJYqQj6YUdQHKP5uyNrVF/XtECfFMO8ZNs8fDCKiAvA+BMczVDRobCpZXA/WAQ0FG8ozFEfUI+J4mIuk9VHcWdsy26mhCRxUGiTFNqlq+/Fz96k4S1HoOg+9nbJuCaSHQfZUYTish4voVwMotn/jj0JGmmW7rAwQVrRuOIrqxbwt6L8KbahwU2IhRz2e6r+vRzOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pEIAqFmMc+HyX6sqDhJusCinRHMtUlAnpH1EffPAFw=;
 b=mn0UxObkbQEgrfO9PKwTH3G/1gx7v2D0fu3AxkbRyP8+BMDEnXtReM6YOJZYfaVValJAMnNzDh+OKQjgaMOAdoHXyr/lOO9Fgiv3GgDzlQFYzHZM0U0H2IwwcfPc+EwL1SsxMmIPYnLP5oLm3U4coxOe9eirh5dCnwaaBFx8bTQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=aaro.koskinen@nokia.com; 
Received: from VI1PR07MB6174.eurprd07.prod.outlook.com (20.178.9.83) by
 VI1PR07MB4782.eurprd07.prod.outlook.com (20.177.53.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.11; Tue, 25 Feb 2020 11:16:21 +0000
Received: from VI1PR07MB6174.eurprd07.prod.outlook.com
 ([fe80::7514:700c:669b:3c8f]) by VI1PR07MB6174.eurprd07.prod.outlook.com
 ([fe80::7514:700c:669b:3c8f%7]) with mapi id 15.20.2772.012; Tue, 25 Feb 2020
 11:16:21 +0000
From:   aaro.koskinen@nokia.com
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: [PATCH] net: stmmac: move notifier block to private data
Date:   Tue, 25 Feb 2020 13:16:15 +0200
Message-Id: <20200225111615.17964-1-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 2.11.0
Content-Type: text/plain
X-ClientProxiedBy: HE1PR0701CA0083.eurprd07.prod.outlook.com
 (2603:10a6:3:64::27) To VI1PR07MB6174.eurprd07.prod.outlook.com
 (2603:10a6:803:a5::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ak-desktop.emea.nsn-net.net (131.228.2.28) by HE1PR0701CA0083.eurprd07.prod.outlook.com (2603:10a6:3:64::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.10 via Frontend Transport; Tue, 25 Feb 2020 11:16:20 +0000
X-Mailer: git-send-email 2.11.0
X-Originating-IP: [131.228.2.28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 99692b57-cb48-4a62-ace0-08d7b9e4245b
X-MS-TrafficTypeDiagnostic: VI1PR07MB4782:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR07MB47825237F8E20B56C34E2142F4ED0@VI1PR07MB4782.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:576;
X-Forefront-PRVS: 0324C2C0E2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(189003)(199004)(16526019)(66556008)(5660300002)(66476007)(6506007)(52116002)(86362001)(66946007)(81166006)(316002)(110136005)(478600001)(8936002)(2616005)(8676002)(956004)(6666004)(81156014)(36756003)(6512007)(9686003)(4326008)(26005)(107886003)(186003)(2906002)(1076003)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB4782;H:VI1PR07MB6174.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lQh1RD7NPY0jNEbQGs3kvHNov9MRnL0/SL4BzaI+djyxldKh4D2u2e6npclnWqEHii2lvJ9MAYzBk/3P5zY7dGfGH39ul0pg4Wt6gxn5nsKhijZkNo0EmepbiQ0NSYTo/SWcK+S14a0fAqlMbJqL6ZM0vm+q/nqOT3YMoeMV+Dd4uLQfu16uTwIMuTfa7z9uuqesRcMp8FEtnkCnHe4HA9jbthC0zX1WvjrN6NwIcsJ1mchzak2u1zuIEAPn45RDp15OchskDKBd1fmVNLKQdHVBD7hqSgyJEjyT3rAiO5icG5JRTCRYOMuetpGuerZhmscOPzO2zx+Vjw2JlFXySZLKH+tMEeIUfHhkoUzzDDLyxm5kzTHHTZoYygsA7o5ER2ZXUs6ny+UUH+Fz/szTfL+DTsmUEjxmHjMkkxol5r3ocRIk4iGs047pcOdd4OP8
X-MS-Exchange-AntiSpam-MessageData: cAgglFMwIyyNhkol/ZslfIe2tyEEIgj8EXbknJ56iKdGgFP9ZbcLrMdrjcT9tvfQL6ePHJWJHCTarQxmo4w3rHq5yWPb4LFTNebj+8g3aUulcoGusSfTt+8BpgU5Z/fTrXZb1+C9ZCtN4p5fnCjXaQ==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99692b57-cb48-4a62-ace0-08d7b9e4245b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2020 11:16:21.1443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YuXkS3nnEhiyDLbLiE+CTyTQDH8f9DH3Pn7rbftMFTPM9D480azefp7+pvZgExr+wrTBSPlDJqaW5qorEhxp4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB4782
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@nokia.com>

Move notifier block to private data. Otherwise notifier code will complain
about double register with multiple stmmac instances.

Fixes: 481a7d154cbb ("stmmac: debugfs entry name is not be changed when udev rename device name.")
Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 +++------
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 9c02fc754bf1..20621b964e6a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -222,6 +222,7 @@ struct stmmac_priv {
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dbgfs_dir;
+	struct notifier_block nb;
 #endif
 
 	unsigned long state;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5836b21edd7e..bf0ce8e4424b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4397,10 +4397,6 @@ static int stmmac_device_event(struct notifier_block *unused,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block stmmac_notifier = {
-	.notifier_call = stmmac_device_event,
-};
-
 static void stmmac_init_fs(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
@@ -4416,14 +4412,15 @@ static void stmmac_init_fs(struct net_device *dev)
 	debugfs_create_file("dma_cap", 0444, priv->dbgfs_dir, dev,
 			    &stmmac_dma_cap_fops);
 
-	register_netdevice_notifier(&stmmac_notifier);
+	priv->nb.notifier_call = stmmac_device_event;
+	register_netdevice_notifier(&priv->nb);
 }
 
 static void stmmac_exit_fs(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	unregister_netdevice_notifier(&stmmac_notifier);
+	unregister_netdevice_notifier(&priv->nb);
 	debugfs_remove_recursive(priv->dbgfs_dir);
 }
 #endif /* CONFIG_DEBUG_FS */
-- 
2.11.0

