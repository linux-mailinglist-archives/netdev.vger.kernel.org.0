Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E091943518A
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhJTRo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:44:57 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:56487
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230439AbhJTRoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:44:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BsNjGWb59x1mzsshfcAcht1tuozwssvnkb9cBPmn3XX+0urkHuCzHUjngKgZJQ97RbgO6wfe+kCvtksoxaAQWNRMGNNn+XiFc7X8ev6gyacH8lvboVCzp0dMEN5QlcHlfi0a06xQFEx4HgfOtZ6oKC4Epo27AyBq0GBUsJ7dlb6bu82CfOpMh3JCsrufFJNH+RM+cdnzXD85t1Z1ybi+RckaUvBYrP5kYP4RtCMrAwRnHVpvQvmdnB9otJ0TdgOSkakvUxgBxqQXZXo4t12cbMZtxd/qKKef2F1SiO+SMiIHIRNlrGJvta/jl8QnUICEGVZCMUGTlj4G+wbEtODPwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snbuulglk5vlgO1xrKFPwET1892W3B+6wMeUawqJAz0=;
 b=hAm9NODyDWDZfcIJIlZYLe5hDRjW8klqXrOZzNCvyQa7jUwarw/Ln8f8hmwqGCTzJTtBIpwx8mgnE1xnIIoePMVb2jHuVA6kSZ8wbSQHgMsVV9Ag23yhGiG+kjxNSLGGiNPtpvUw0LqolxuWLaqgUl+DPkR82LjuHuW8fVOd6f2TifCZDjdcThlcAee305Dd6ssAFL0GBJ2g2EGMP4lQmvlOum9S1y96l8k0p+TIO78u54jjdOUTs/dNWd77di7F3lhzL6eHs1F03UxaiJc6CLB6Z8/4IAUhaH8SiRpJ5CniGVoHMeRQP25qp0EsTIZDgxD44KXHDJZSNmnaf28u5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snbuulglk5vlgO1xrKFPwET1892W3B+6wMeUawqJAz0=;
 b=Fa5hM6D53nhms1o/AOocRxj26gRk5NqYdn3GQHDgl3eFYUAfYD9P/qCmPMjh35WfgP69KTdQ5ITaMMJSQfMOF4noZV/DmwBLpyHlS5hPSet6arq2cWavn2qq9s4K8o71gEK7z49Edm85NdJQBQ59H3Ia0fcggOSPPi6F3rlAVwg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2510.eurprd04.prod.outlook.com (2603:10a6:800:54::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 17:42:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:42:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH net-next 1/2] net: enetc: remove local "priv" variable in enetc_clean_tx_ring()
Date:   Wed, 20 Oct 2021 20:42:19 +0300
Message-Id: <20211020174220.1093032-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020174220.1093032-1-vladimir.oltean@nxp.com>
References: <20211020174220.1093032-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0012.eurprd05.prod.outlook.com (2603:10a6:205::25)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM4PR05CA0012.eurprd05.prod.outlook.com (2603:10a6:205::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:42:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2147872-cf76-4ee9-cede-08d993f10139
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2510:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB25106399BE84D5A08C166B6CE0BE9@VI1PR0401MB2510.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xPMbtMB5LhBSgLtAIJEKrRJX7vamHy449vQsIJ8pLqDChLqERYbUq4/YOC/gud1SB3rrKOPYK8liq0fTt/RvXSid0CKnWy+RFwBfLlCqcyPU07nj7i6AzWgSr6jmDylw64ri+i8ZhuNBetKkoBmJjiWBQTzLF/f/GVBlMrxU4d+vT0SBfS1OSihrsz5hxf4okhkz3f+oVOZnoizlxUXtHSHvvgXCrS7jt+nZeXYTUTbcCtTSkCJ7yBfOxVfpqePj3+Zp5eBnyUuAz7MebqNzOwSRTB0a6U1cmNkbf5Sg5sLzcBritmyRO/ScwL6OrwxuY+m7ow2HU2Lj8cmU4xRLVRNsm1SSIrxo6OnjEOypAFoy8PqCUfokq3OYNGbW1oMz/hTwYl+9vnC9JTOewGzndtgf+yWw3f1LhYmCvg5j3HO5haL6UWHBlZQr35YKCD8lDO9hg89ssqsw0kbZMAH6wZoTm9+AJ+nL5bvJ9JhUGVAAKFwwF4mmLfFrzy0qU6O71FNOBjPYJ1QX3nSuw0Q+pHOvXnwk9pWpSTYBCj0EEulZEdh2SiNrxnDvSn0DEwaAb85ec2FeEQgibjHI+b1h53q7Hobam+Fywd2pwWj5IZd7JhVcmWADreJrf2K96K+d3NC+XdWtu5FYvYeGAKLy+vXE3vvkuSg6kTBaHszbSyOY/68TUfsrxP69hmmxMdhOwoFBMBJCRCtn49LWrwnpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(2906002)(8676002)(52116002)(44832011)(6666004)(5660300002)(316002)(86362001)(6512007)(1076003)(8936002)(110136005)(54906003)(186003)(2616005)(26005)(956004)(38100700002)(508600001)(38350700002)(36756003)(83380400001)(66476007)(66946007)(66556008)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tejfy9sPTJUGb49vroJ7/XDPAX4OrD/9fMv9A4RARDkkSpUt+bh3r2JTNhCQ?=
 =?us-ascii?Q?Rkzs41ta1DSe+/FMvxu6hg7h7Vc4CHq2nhnmMQ05z4RHjhK7Gxh3jbw3/mHk?=
 =?us-ascii?Q?2QofjNI1jBtzOGws0Li5XkLIQ+MoLqpxN32Q/b7yIwv53yd4mQS5qFmfx4La?=
 =?us-ascii?Q?N3WJQg73Bvc1k0iPnzSmnqzahff3ObIBnV2ubU3CG+jj/ItUkhkENpXWqnf2?=
 =?us-ascii?Q?/eeVxd31lkZF/+EuiO/82J7/o0bPVVSu3PSKKCg2R9qKvWWQjdUbdq5j2Xlb?=
 =?us-ascii?Q?KDUQQzd84Hd7vObbX+8H207KWC/DnMzEaIx599b8pbM1eW29xFCHUPkx3o9F?=
 =?us-ascii?Q?/Fr8ohoMZIB0dIY5uXwEWoiiSDH6oVbiBk8O3DNCF11U7ZaTvhHfC2KGNifL?=
 =?us-ascii?Q?v5yLyy+Wlo+W4VnsdpNh6zBajfxegqXyqAoQGyP0RS7uzX5ofsk0srcOrKlg?=
 =?us-ascii?Q?moDU70ZGxqXtcjF2mlZVmnYF03AkHn+iJZISA3XSkN5RKnRbFFzJb6lbGS6l?=
 =?us-ascii?Q?RXdx5DlW9OeFvPigE2HkNesJ4I92/TZBaZp/vkjLNhnTQ1k8Lso8f9QHryC6?=
 =?us-ascii?Q?asyL2quLMfqTjdymCeMW0f5Z9D8bVCnlA7ZtQwsd/2LxO59T725RtgFB4VQR?=
 =?us-ascii?Q?NuT+U2I29EtSWQdV29j0OH2VMCfoEINUUqfTgoyYjZs9BQTipFAxN1OKU5Q6?=
 =?us-ascii?Q?A+RUuoNfk1OQ01Y89Gtn4iEfUB2GsA1LA6dSGQrTav+t3uomyzdSXYqNZmW7?=
 =?us-ascii?Q?/9k5X33S/dSQxnerLkzt0HUfcZMcu+fLkSL5H9Ikc+kT7/fgJAJs3KWuO8tS?=
 =?us-ascii?Q?08tjvX7/B/i4yAxq1hQqIoCbmrJKWbXb5gqfhRMWuC/MCv8JgCmds1ILo3bP?=
 =?us-ascii?Q?XiJIemY9HSZmD6318xWyWNL+buhcs1IZh28VdiGDFjDArCaFYI40nhy4dL60?=
 =?us-ascii?Q?iTXReL2WLaM5Dwb5vXu8jV3Tl8kGOKXwHaNye+SRrcDn0F5Nos+nqoJ0tw5m?=
 =?us-ascii?Q?TLjs1yZeoGRypNGEU1DB03ztuWrb7ak/PzByt3jt2r+g44ORGWLWdBsjyP6Z?=
 =?us-ascii?Q?tvvA4WsS9oMfAgBmPJ3jbXg9OHBQMaqC2Q5DcyYjjNBUKaEHEe9NeGUtZNNs?=
 =?us-ascii?Q?2K2/b5qPLe9R6Q5fso0vPugmENYrOg/5ZazDJZpYWbKNGc9+1uPtIEOaXDyk?=
 =?us-ascii?Q?0JjrzCtflr1frAxeZfqSPgTB6+LwI6Ptyu3feN6O9hbwcJpmNApM9i9tDTOL?=
 =?us-ascii?Q?SizpBRzyGNBTYQ910jqPLNRID+HKvoLUzr+uIFXFqiCGj2b2FyRyar+FX+uI?=
 =?us-ascii?Q?UT206GT5prOqNySv23eHK8GL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2147872-cf76-4ee9-cede-08d993f10139
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:42:36.8971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pZM0t+sCZbXzgZ27POkg3KsmjvHPL4+ueD7qHWs4oGw9kFWLObbKOnvOomCdc/S5PjuLRoknbsfuqLZudDXapg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "priv" variable is needed in the "check_writeback" scope since
commit d39823121911 ("enetc: add hardware timestamping support").

Since commit 7294380c5211 ("enetc: support PTP Sync packet one-step
timestamping"), we also need "priv" in the larger function scope.

So the local variable from the "if" block scope is not needed, and
actually shadows the other one. Delete it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 8e31fe15bf3c..082b94e482ce 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -813,10 +813,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 		bool is_eof = tx_swbd->is_eof;
 
 		if (unlikely(tx_swbd->check_wb)) {
-			struct enetc_ndev_priv *priv = netdev_priv(ndev);
-			union enetc_tx_bd *txbd;
-
-			txbd = ENETC_TXBD(*tx_ring, i);
+			union enetc_tx_bd *txbd = ENETC_TXBD(*tx_ring, i);
 
 			if (txbd->flags & ENETC_TXBD_FLAGS_W &&
 			    tx_swbd->do_twostep_tstamp) {
-- 
2.25.1

