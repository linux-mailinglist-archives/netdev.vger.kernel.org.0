Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC3A2CB7F4
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388019AbgLBJA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:00:57 -0500
Received: from mail-eopbgr40057.outbound.protection.outlook.com ([40.107.4.57]:12974
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387643AbgLBJA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 04:00:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFquU3OxDVp3nsxbdRIPQtrZZ2uLCbmAsZ+8xT2NN4CnMCLqepK/ZCLxvpK1WtVkrU1UWzk/+1Yl8otBzqaSW9PjclBSMOO7ntbe7vvU6373TW93TlFnQ7n2jWTrQiXDy5VoRXFmY9gaN+L9iDdpf5V4nN0f+6T6D1xdZNbNI+C3xGiY4cVkkeShIg+0lp4RImu8tMp+yBWU7xFEqLu20ir0MeTDHW2Uebsj7Rjz1m7hhQkjksKq2ePsQX4AyFy7ciLDRDy/3srQ2BTHv7BcbqPsJzhwSXAmWrJSXP8coJKMizdRMzxgRUQhsfPl91RGede2GySqctqKg+zsmS5G4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHVPaPOKsxm4Rs1f7SwXefW0i6EUYty5XizTL3WcRLk=;
 b=Fvlju2OxPy/4Ju8jfxd1y9k2DwsymPme75llsEDGQl6W3nmlV01cGMg5EjRMjSqPXVFfsMOpvMgWA/CVZWNl5qcXtVCPBZYZNT8uE2prhcY09BPcG9c2PZHbI2GRv7n37Cx1J31tLDaQ3yfNtiqpRmKd6LLa2wHDXcZQX0UfESgRw393nV/2x6YPmxS4VYwcmxg6ZzGn0jxEiM8+cs6sQQiutDaqDclRCUYcRO3boOeE0fdNWh1sSJurnW/zyKDIxFx0Dr5FyQC7vf61op0Y286GiD0DETOJcZmEg47wyZZ6cD7FVuaLH5KGOJXbNhSZBCXCo1QTsYd207s6Kyvx9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHVPaPOKsxm4Rs1f7SwXefW0i6EUYty5XizTL3WcRLk=;
 b=QsL0c9NI/AHBC6q8YCQiXgZLzCpO8BqtQcsjDeId9oDpdYga42QUUUjxHfEs4QxMBoPjf62hyJ/pV7WNxf9PTimuaqgSe2SGBEZ1IiOy68LkA3cuogPI9vJVQ0TMYuE5AUVpXB4j8nSG06EnF50vwpZdS4eNJUZjMGKknD3tqSw=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7432.eurprd04.prod.outlook.com (2603:10a6:10:1a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 2 Dec
 2020 08:59:54 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.017; Wed, 2 Dec 2020
 08:59:54 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH 2/4] net: stmmac: start phylink instance before stmmac_hw_setup()
Date:   Wed,  2 Dec 2020 16:59:47 +0800
Message-Id: <20201202085949.3279-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
References: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR04CA0132.apcprd04.prod.outlook.com
 (2603:1096:3:16::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0132.apcprd04.prod.outlook.com (2603:1096:3:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 08:59:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b072972-c157-435d-2f53-08d896a0a2ff
X-MS-TrafficTypeDiagnostic: DBAPR04MB7432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7432DD6F48BBC7FD7BBF5988E6F30@DBAPR04MB7432.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rnGT9oy3RnP2wvEVuWY1nnxVLdtE86s01FZw50h14N7ZAaLh7HOcDFTDdTjv4kkgCax1SeC+6f4FDPe8YhYQt34cCDnrrbcpJMk5hkTCBaQdgJjBNyHc1f9XNxUFctYbasZtPqnUNizkgIzQYPOWLAqGqJ3arLuAcGCkX2mPCshfcyKT80tAzPSydaS647zRhQPgQ+S409F3CYGaiDeH+49Qu5QRU7eFHdnkYkDueJouHL0X4jnRr5rYkzNSIwvo4Ie1dbiQBqXVtOf3iqvxmdohnY4ixswxIK97FJtzfWVB7mOcQW5AULk1wVaZAQ86Kpw7Qh7xE0kehRHP0siQBL7IlRXThGuRX3721ZTdC1jWuotIRaXsi85A6bjURpjx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(8936002)(16526019)(186003)(8676002)(26005)(6506007)(5660300002)(36756003)(83380400001)(52116002)(478600001)(316002)(86362001)(69590400008)(1076003)(956004)(6512007)(66946007)(4326008)(66556008)(66476007)(2616005)(6666004)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QmQjT/ldj8WxercHRHxC2fj19mwTxPgBNVFq/WPGQdBmWGdhi55pYBfTAFpF?=
 =?us-ascii?Q?MkfNwvJHoRyofPVj5i5Qd7PoSUC8yK5ubGNJz8A1NO/FSJL6F8qhwW2m1iJx?=
 =?us-ascii?Q?w639PL3PQtmAO9kVS7eDGglqLOAK03p6yVnaDDfy13ASQBBTYNUN9cBN5YZw?=
 =?us-ascii?Q?P8pdv3x6KmVzvylj/6QlWEHyceZJfgpOq0wC2CvSclk8EkqAx4EzUzaxUcd2?=
 =?us-ascii?Q?Z5e1ZlM5D5N5s1ITzlsR79uVAJCuM6uNbwBwbfpxX4H5SZGNFfQmtwf55D4O?=
 =?us-ascii?Q?Ccgn+ljsd+SyY0Tmw4qdAOLuM7XiVQ4lOUJZMzS8bimSmztE0usYWcqGAqS9?=
 =?us-ascii?Q?MX0wMwVn2DUei2ypjVPw7gI5Y7e1OMQJzroJoH663mPBlHgEzgbVx91BsP0Z?=
 =?us-ascii?Q?pJR0AWeLlqtN0l9c9go1/h5Wzaa4RXM5AlkDGGK6XIg68Ijr8FMUutUkEIms?=
 =?us-ascii?Q?EttBGQDVSkePFzRVoUAxiKGECP3Suj/2mJs4/+6V3yopyuILJRFAOgkobnkl?=
 =?us-ascii?Q?qo0E6ese+G6Il7Iy34S7xj/9ejnWxEhc1hwuz8fsAKTVpT2vTg7pt2K2Qvch?=
 =?us-ascii?Q?hvub8MuuM2QuHdhhIsWg9HmR9KiQzNNml+SOftZhqcJcBlqVUPCEP4kFWCp4?=
 =?us-ascii?Q?WnzPlOmn2EzvYhC2RzPk91jwJ5SPTV9AxBW8MW5bSjzFN214hSYevbbZ+LVx?=
 =?us-ascii?Q?63Oz1JxK47k9zYWpGzHGlVHESzCu127Pw5pM4SBYZ33fpHdaQsTRgBpo8HG9?=
 =?us-ascii?Q?NjEWg4h5kOZ3hrisknaAwOR1OUjuyld4r888Ziync5wxdT+YlOljGsB2zBdJ?=
 =?us-ascii?Q?9yHX4KXI3cd0p4aUlOMRHRSdedyknmSl4KlZmu/G6iqVfypzuis94EEPqzqd?=
 =?us-ascii?Q?x6xqvk4bu63PrsdtFY9cT2AyYnZ/a94k0EaJQdUJEFWLeT7srGQrvpegKz+X?=
 =?us-ascii?Q?ZcCb5sJvzhjqRkczlmh3mg8Hb+czHMNr/k9gzwfTVmK5f7nhspAsDGiPffrJ?=
 =?us-ascii?Q?BfZG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b072972-c157-435d-2f53-08d896a0a2ff
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 08:59:54.8811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SqQiylMkmsYx9iKiGvyBZ0ja/fStWjaqSaCxt8OBRigE5YN2IrnsewDMrFIdVFSrYTu+MPkpUUgTQ/G8LQparw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Start phylink instance and resume back the PHY to supply
RX clock to MAC before MAC layer initialization by calling
.stmmac_hw_setup(), since DMA reset depends on the RX clock,
otherwise DMA reset cost maximum timeout value then finally
timeout.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8c1ac75901ce..107761ef456a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5277,6 +5277,14 @@ int stmmac_resume(struct device *dev)
 			return ret;
 	}
 
+	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
+		rtnl_lock();
+		phylink_start(priv->phylink);
+		/* We may have called phylink_speed_down before */
+		phylink_speed_up(priv->phylink);
+		rtnl_unlock();
+	}
+
 	rtnl_lock();
 	mutex_lock(&priv->lock);
 
@@ -5295,14 +5303,6 @@ int stmmac_resume(struct device *dev)
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();
 
-	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
-		rtnl_lock();
-		phylink_start(priv->phylink);
-		/* We may have called phylink_speed_down before */
-		phylink_speed_up(priv->phylink);
-		rtnl_unlock();
-	}
-
 	phylink_mac_change(priv->phylink, true);
 
 	netif_device_attach(ndev);
-- 
2.17.1

