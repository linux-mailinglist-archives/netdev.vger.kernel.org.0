Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4D123A152
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 10:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHCI5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 04:57:22 -0400
Received: from mail-eopbgr750051.outbound.protection.outlook.com ([40.107.75.51]:65205
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725806AbgHCI5V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 04:57:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8K4QE1MlGjPZinTbAdmW0yvIR6273m8yZg3asdC4yJdmoIvlxq8ybO4ottl4x1ZjfOJImIP2JEazmVxF7Ak41oDjxQrU9osFhrIOdtfuhimaZSvrKpQS6RDoCZ/IEcgZQ9D6+QMwTEKZWvgmorOJ8M/DSZXftDXfLvGs89ekjseYh28CvucOVGBcxaXgG0M3kgWZpeGzg2Nc4r0QdbcizHENd9HAcp2bc1GWFQSXEgg6p6rpy8f0P7KMNU/Ch6O883K1suVmEvYH2nKLSIaceGk/uO7RdZ1aA/xVg7y3aRZi5rxLd3qfmIfHcAJ1oiz3ajbXRARlHtU32BmKXQZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CydEfDRwmajU2XoV4YQmb03N8esx268Olbs2N/mk5WU=;
 b=j7hyVq0S+Xlr2sQaKNaepLdWjcCQO7TOSNSmqkF3Jmk2Q5sWyhegYoA36p8RkoFEVNTRVXzQ9Uod793HBn4PbiGvyNtYpIzr9HTLE2ea6hxvNSYyThefx1Oe9rvrXundyojLCpa7CAD7UVQu4Q1EdIAeriZ+MazLblMpqEMVv1Dj60aiwfKcuJESmh0Mq0kCGhhTGmFLCqWKJXHhnHzX1I0QPHsD0uRsOZRxQH6QYYbzhbGe5iFQx+GHOI/cmRFqPrOTcbU31rS7jJV8q63Ls9LvzEENyr4cJNGBEQOSfTvYaKhdnM/QcKBoojdjYzcM++n1OgDi4cQPAE6X2p4cjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CydEfDRwmajU2XoV4YQmb03N8esx268Olbs2N/mk5WU=;
 b=FGHgE6y/UOqtvpdxAO4a0jI0B2tci7UhiGEYWOIjTvlcFKsi2oHAbdHlabxAHjVWDxCaz3mLNNJdBgSQgPog1Ryw6ACwBvGJ4/IwDFisHOTgaJz00GR/HydNNGLVOd5LsbvNg2uX96R2SH3gSV/z/iFLiT9kRVqYmip8sJA79o4=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=synaptics.com;
Received: from DM6PR03MB4555.namprd03.prod.outlook.com (2603:10b6:5:102::17)
 by DM6PR03MB3498.namprd03.prod.outlook.com (2603:10b6:5:ae::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 08:57:18 +0000
Received: from DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::d9af:b798:6945:27b]) by DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::d9af:b798:6945:27b%3]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 08:57:18 +0000
Date:   Mon, 3 Aug 2020 16:56:47 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: fix failed to suspend if phy based
 WOL is enabled
Message-ID: <20200803165647.296e6f21@xhacker.debian>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2P15301CA0008.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::18) To DM6PR03MB4555.namprd03.prod.outlook.com
 (2603:10b6:5:102::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by HK2P15301CA0008.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.2 via Frontend Transport; Mon, 3 Aug 2020 08:57:15 +0000
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d6f6ff9-865b-4a33-3d9b-08d8378b396c
X-MS-TrafficTypeDiagnostic: DM6PR03MB3498:
X-Microsoft-Antispam-PRVS: <DM6PR03MB3498CCA46C25F800F197DB4BED4D0@DM6PR03MB3498.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CGl0osAMVqt62G2SIgSdCpSzz8Rlr5cd0L9NWvcieXUpfSjZH3mbffZRR6jKxEdfINlP7911sgNIWi6B2V5T/OQBhDXyQrnVclxr92x4NkX2HTNaumvcCu7GrwIqHWX9QRNzHw/+Ss09P+zCBghI8Rb2IFoXFu8g5FtKn0Ok/GBoXWzG1o7e9ixzkjdDWgL4N7VAATyRsDcmFK3u17yVlLwdSQrFLLTxA6NPh5tm6mtOIt2HcSXrNaAx40wBXU024IeV8hqxIGtpMC84OVyREvLlQRY+w6ryQ5Nl+ef74IUpqfdNToHmRAX/tCHTvAMQQzHKDozKn5tUF4V/oO7U1N1zBhpcsyHV04Y4duucnCvl8JlpdNc1ozswHV8Cd+e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB4555.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(396003)(136003)(366004)(376002)(346002)(66476007)(2906002)(66556008)(15650500001)(1076003)(6666004)(5660300002)(7696005)(55016002)(66946007)(52116002)(6506007)(8676002)(110136005)(956004)(316002)(83380400001)(9686003)(16526019)(186003)(478600001)(26005)(8936002)(86362001)(4326008)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Kiy53CcW+JBaPpvvvmzvspSh4JTWzKps9dMXC9fbvWvZOlRHev3xDbrnDO+4+TxnOyA8JjZj2mSonibpPpvqBcH158mxrGp/p8UZuF1MigOZmbQl6qYjMHUQljawwAv04TjxblMBeYw6nuOe4yUNm37OVmgh2bZJo0MudHoYSVQZSDi/f8zyDzBkiwd4CEePXNF6VdwLQ1gbN2FkYb4acojRWA6uN4TTaZTMe6noKTgKN6Iu4QS7H2l5rZU1WLkFLv02M9JHCIPyFelienNWHAmXEPwqzTGe/gyBNw0ZwLb5bpLJwOFemhTBz+cXKE94bboduYVgNRSUGdzumS4SK9SdCNXG/WMkDFc+CZJrzI60ot6lpGSmYoYyAJrsewlNrHBSrEfHJy/8Amkzl+1vjLUS/ztdlNEFTx2/mCvpSbJoj4W0uIv6NVlEgvIrGQ7tZ3rm095JiOo29262zkhfWI2XdshysWNo/IGsX6OeSPDQj6eJsMUH9A7wtUf8ChehpZKCngSqZIPBSTJ4hux0hkxhs5/Pf3EVAFYFTkz43Aq7QDG//gta2FYhd3pB2VeEuGY9xvxDORVFJzKLjuwKcV6MxUaHIbJViqyyBy4zVZoEUAHRbh/8PZXnBZsVwyvGs8zj+kH5eH0JI6ZJdZa+OQ==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6f6ff9-865b-4a33-3d9b-08d8378b396c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4555.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 08:57:17.9480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 81n3XWiI4mxvssZtA6kxNy09P6n7Mqu/tEmsHq7NhSShO7Jscp1Fu2etjGoDMUn8O69Q2jfbFBOx7Zoz+hBWBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3498
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the latest net-next tree, if test suspend/resume after enabling
WOL, we get error as below:

[  487.086365] dpm_run_callback(): mdio_bus_suspend+0x0/0x30 returns -16
[  487.086375] PM: Device stmmac-0:00 failed to suspend: error -16

-16 means -EBUSY, this is because I didn't enable wakeup of the correct
device when implementing phy based WOL feature. To be honest, I caught
the issue when implementing phy based WOL and then fix it locally, but
forgot to amend the phy based wol patch. Today, I found the issue by
testing net-next tree.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 05d63963fdb7..ac5e8cc5fb9f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -625,7 +625,7 @@ static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 		int ret = phylink_ethtool_set_wol(priv->phylink, wol);
 
 		if (!ret)
-			device_set_wakeup_enable(&dev->dev, !!wol->wolopts);
+			device_set_wakeup_enable(priv->device, !!wol->wolopts);
 		return ret;
 	}
 
-- 
2.28.0

