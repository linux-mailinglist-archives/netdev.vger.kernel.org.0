Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B90A22EB85
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgG0Lya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:54:30 -0400
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:59361
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726873AbgG0Ly2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 07:54:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEAFRqZFwlCuNRTokzBDI03yNl2LKJst6EOakvs49F+WAyl31jfIQBZ+opE3aKkdsroTKnaimU7FfIdoiWbBTR2+0JezIqFXCnV6PxZeAOCPVJMaSIE++9COnxc0hWW+ceQQqOPJajPljsbHZ8FqzQz+4KtgM9v3tU21Aru3b4bTd5H0ji23FsB//xOJlplO4rap2BjGluwzGkah6e5TdLZIJsQAdCFu6WqzT2mJrGcoOaLFMYribcu0JPjpCugbbOcoxlVUSHehT11WAo/ijLs94Rq0giXFMwkd3RJ5wTtY5QWCNkqv0aGlETQLJH5Js//x4+WqPFHi2hgxB+uuGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGearzZqCHPul4M4Obvhn+rfdNpjHphVUQtJTdY9/8k=;
 b=iMd3Jj1rUi4ZqLpJldof6kPd1n4fdhT1rndOEcZWv6JlX0uGHslKGevUlD5gpYcU01TNTQkEFSBNOzm8MoTxen19ML1a2kMkU/5Kb9hI6YFJmD+I3F+RV96CA9FezzLWmWOBI38oEsEn3MJBYCo8/rEXVsxYniP37Avdel+neIxbWCIIPhIuZi3EDegAg3Xl8xJ3HoiWxghYdKsXM2zQ/lrJc02rMetb/Ftb1+sMh7o6lYPVkVaKLs/B5y0I4X1donGkAUnhyFhO+sqZkKid/upXJK+2zGEJUw+kOi7yL2MsoBuqtEGbTv8I5RVD2fdiOfTn51/w0ykA8mFWEc92UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGearzZqCHPul4M4Obvhn+rfdNpjHphVUQtJTdY9/8k=;
 b=IwsPGDkR/vBmpFpjkgTeb2g2i/duYfD7w3mOtxQ/Gg1u+hShg3zQ+oKifF10zymWKdVGCWFjYZHMOSOoc2uzodWB5O9JxZL7BSq6ZYZlc/nxdriQ6YiNSdtA48oDBUFzKlab5IJVpqKUNNZACyrevLMe4G7g2R1AewlPiFzHoQY=
Authentication-Results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4647.namprd03.prod.outlook.com (2603:10b6:a03:12e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Mon, 27 Jul
 2020 11:54:26 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 11:54:26 +0000
Date:   Mon, 27 Jul 2020 19:53:14 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-nex 2/2] net: mvneta: Don't speed down the PHY when
 changing mtu
Message-ID: <20200727195314.704dfaed@xhacker.debian>
In-Reply-To: <20200727195012.4bcd069d@xhacker.debian>
References: <20200727195012.4bcd069d@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0044.jpnprd01.prod.outlook.com
 (2603:1096:404:28::32) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR01CA0044.jpnprd01.prod.outlook.com (2603:1096:404:28::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 11:54:24 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0dec320e-0bf8-4148-0c41-08d83223cf89
X-MS-TrafficTypeDiagnostic: BYAPR03MB4647:
X-Microsoft-Antispam-PRVS: <BYAPR03MB464738482804F0FDD0784709ED720@BYAPR03MB4647.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:494;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RhN61h6SLNO4RHUI8OXYbzwc+LxmRVkFEh8AynuPrD446VlatMsWi79x1kjIaQjeBwQLrqDGtG0FzNFnOLuC3HprcshXVnbJ79baFx6jmv6rM0H1oaEgh5PXCrDHghGeiu6RZOIRjzZ8I5//d5Dqv8od+Q9UteMCX3NiABl5um8pwOzAK+3hJMDdBUo9NGm+WI2NODKioIyl7hMF2nvIuQWn3bKUDEVYA3wJe1yrXiso3R0W81bXYrT+044KXwAqVz/ZaSP/Xt54gn/oLD0AoNtAEqmIi1EEyo/fZOqaE2mwI50qjFmL61K737c6/EA0nwOQDpYQNJbgb0j3OT45Zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(396003)(376002)(346002)(366004)(478600001)(52116002)(6666004)(9686003)(66556008)(66476007)(66946007)(86362001)(7696005)(8936002)(4744005)(8676002)(83380400001)(5660300002)(2906002)(316002)(186003)(4326008)(1076003)(110136005)(16526019)(26005)(55016002)(6506007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cAxAB0Ms3mGmN0f3FO/b3UH1qs87FIrl8ajiXcdSXqgxr7va32y4/KjGZKMqWJYi5Ne+IY5Ihdbui0F1X7hLISaivcg+L58512WH3Fo/M8r19qzqivPwlQyEP7+EPr2xmT9d7STc2znnrEybB1ZmNurb10pX2IEbw5PWAoZqFWFPx0CiGYfTcn0yhdq4vk4UU/OO3hj+oomB5Ib4JbnxL22chPHuTLuhv0fhjWzfubx2umb0jp7IFZSBguv935pJ3uIEEHxi71I2lLp3ciphSXzGGemXWpWJA5P3NRXho9GYObRFt7Zjw5TnFCvFmPu4ayFO/Ujr25hI/rWtYZ3frOLnfi0Zgic2k+qTJlmsNcJCEBJ0suIbhZBoNH0DCpJW/DBzVt+/urs8wyMEd/rXXd9FwCCqgI6L5hKn5U2fT5zN5mNI7TvwRsL7rLMKGXwyVweWhRKTuvdK4UHYavQq0nqo8rMnf//NZtUzKmNv+qg=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dec320e-0bf8-4148-0c41-08d83223cf89
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 11:54:26.3012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ydn7WFLZHmuh0SaJJ9IEPNIrY+80MUXGEz8xSQ6l2gj9K/236VGshLkSZsQ3+k+6hxQMOPw21mM1HlJRJxyAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4647
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found a case where the phy link speed is changed to 10Mbps
then back to 1000Mbps when changing the mtu:

ethtool -s eth0 wol g
ip link set eth0 mtu 1400

Add a simple check to avoid unnecessary phylink_speed_down() when
changing the mtu.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c9b6b0f85bb0..9cdbb05277eb 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3651,7 +3651,8 @@ static void mvneta_stop_dev(struct mvneta_port *pp)
 
 	set_bit(__MVNETA_DOWN, &pp->state);
 
-	if (device_may_wakeup(&pp->dev->dev))
+	if (device_may_wakeup(&pp->dev->dev) &&
+	    pp->pkt_size == MVNETA_RX_PKT_SIZE(pp->dev->mtu))
 		phylink_speed_down(pp->phylink, false);
 
 	phylink_stop(pp->phylink);
-- 
2.28.0.rc0

