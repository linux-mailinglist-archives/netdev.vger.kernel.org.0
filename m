Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C077229E5E8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgJ2IMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:12:44 -0400
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:34191
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726512AbgJ2IMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 04:12:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HayC13v4GDb9xpzpTa8nb8TzVwD4eiQkHBaldjzF/Ha8wN/EKm5AdtLXWT4YC4/pQqeV0ZfKhyzlG7FHSvDcgL1JuwCf30pTmt7f8CgH1lvCkAD2h8rThE1ttnaVupugo5cFKHapl4eY3MsOZmbEBlngnW5+PiVfCDVKrXKsxERakPkbOEU3o70rag6OS+UJSAB8XuvLK9dNBP3ZpocRZjnFboGaVm/qJyO2mc5TeEYsBm2R3fk43zSC5OVjZRpw2AiA18FEdKA/v/Mdn2bYIMPoObWgVdUhnz8X4ew7wtbnYFoCNOetFmVcJ6avF9xSADNglpA5Jc0XUTk20TyAig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4aCsxXr7FbErIY0enJmmV/Mz/I/U7EkU1EGZwHCgRo=;
 b=g8hqUabVAR5yc21+U28AfjHo1e/sOfwrMeNrYpvvAwl7SN4EVNLHA3ttZi/OFwrDlFpAAHTccOvnhAfGFDZXMhU85TKxFPWODboLFuOYztK6pHmMl6fZmVm4tJqovYE7oQKlO2b4Zjb10sOt1fRNf9aP4++INok1K0GQh9OYfCWD+jnwcBEua+gHdpqxxMJa0ZJ4KV/JrPAdFLgYoD2oCwQTMHoOAVFjJqkH192Hw05q/4rP4JOjqCJoqqLaaKrgigdAFT5ixYsxj0hy2nvg0CTeStRpTpeZMv0ADzNZOZRhvpKfUy+KPwgNy/G6fPqE5MB8MD/qP3pW78bdcjv3/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4aCsxXr7FbErIY0enJmmV/Mz/I/U7EkU1EGZwHCgRo=;
 b=cUQykwOOvRB93NmhX1+g76cs6VW5qXm/VbN0A6SOip/QpXIlTJb5Q/bDAwEG+pJQdTOaQ88knnwCVrzOt/35FoGfhREvGZXdpelzue4c6dhHp2iGPw3ys7sTwl5aYRndlllBF+soz55i1ZDBu/DXsrvEH6r8ibjOEyIggcKzzc0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR0402MB3827.eurprd04.prod.outlook.com (2603:10a6:208:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Thu, 29 Oct
 2020 08:11:11 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3477.029; Thu, 29 Oct 2020
 08:11:11 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, james.jurack@ametek.com
Subject: [PATCH net v2 2/2] gianfar: Account for Tx PTP timestamp in the skb headroom
Date:   Thu, 29 Oct 2020 10:10:57 +0200
Message-Id: <20201029081057.8506-2-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201029081057.8506-1-claudiu.manoil@nxp.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM9P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::17) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Thu, 29 Oct 2020 08:11:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5612ccc7-6712-4930-2217-08d87be23278
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3827:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB38270212EA07E6E5AF65CE6896140@AM0PR0402MB3827.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qeaxg1HOtE0wZAPZ5LFTpm/HlAH+0hQ95KoVvwLpSYqB/bifMxKVXFpozvXjbK5zxON9ZmWX7aq100NP5wTEWZh7HYp9PVbKjIXaHK4iDL8oHDyy8GmTY1aTbmXhQM6KeTaDv8KekK0azdQxhIRitYzG2+RpZ2Ao6J9gYqInmwLkPiy/u9Lhw/w5gOM5MQzMb2TX1DW9kXWsH4HcXUnXK0DnOlyDxjz7GPz+uGTR27VzoRIp/oHK5NIfwuJjJkqt3YASxGikDWh+0NKubCuT7Gs6cT1J+cEX66KcP/1OJtiqdqVu2jZr36WdxGDshDKaUPwSJ47Y167XIRVgflYN9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(2616005)(8676002)(26005)(956004)(54906003)(86362001)(36756003)(316002)(66556008)(6916009)(66946007)(66476007)(83380400001)(8936002)(186003)(1076003)(5660300002)(6486002)(478600001)(15650500001)(4326008)(16526019)(44832011)(6666004)(2906002)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YkX2RKh2EwY8FQ7D5McVO5GrQ8Tx8fakQxR/hQ77Eu4myftCD3uZUuipE6vyJbUva8ssARRYFlzy7o8summWE2CeJWooUMTEq1CB/lgZtjzEc2QhjE1RJ+Igc8MuEG7onvlU/D/JvmYeNlkqoL9scW9eVqWq9sbuF1cEgr+TTutoT239gsRQwknzzvdSpyGOENR5uHZ2IeCI7wk0bN45zKUJ2BHZ7/7XDnREC1Ra/XyMBreWiaZeZ3qN/dZ3nyutiKW4l3LlpdCAk1WjJckD1I8edCHrSZuLAb56kTUROfszPasNaQLvn9PtwKThvtgUQPMsvb1z3NWVGJdxN66j6+0buLAKSEeMYif4r044aIa7+gdbkqrPgMvc8dqW4bC+ZqMoxlyw2Xs3owH35GfnzTr0pxzSfON/RR6pxWNWsSNV9EOTPcLHITeGQv94kZzMmBY4zi1Ztso36OuvLeNDbvrDVRzD6Y+G2rhfjjzLZQgWHg5HtOVSotvaCMB1Y/zopud7sXnvPFljVMMrSYtMJdkZOcKttcpJD+x5xCIfzNUO5WcJWfvGs0EZT+ykNFMfsNYQiFKC9zQCrSgp50MuPPv+9dy2csOMecIkBn5KTBKd5vkzCMs+yApuE7tyRnfSrb8L9h1bcFfSPtg7WrMCjQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5612ccc7-6712-4930-2217-08d87be23278
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 08:11:11.4703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bGDWcvl1RdZ58vauuLvfZAEkUwYMZ6+ji64nI9W5a8iGxnT9I/XUlJkXiJUtHW8Ig8b5nBYinEElHDygyyrXug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3827
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When PTP timestamping is enabled on Tx, the controller
inserts the Tx timestamp at the beginning of the frame
buffer, between SFD and the L2 frame header.  This means
that the skb provided by the stack is required to have
enough headroom otherwise it needs to be reallocated.
This patch is requesting enough headroom from the stack to
accommodate PTP frames in order to avoid reallocation whenever
possible.
There's no reason not to set needed_headroom to a large enough
value to accommodate PTP frames, so in this regard this patch
is a fix.

Fixes: bee9e58c9e98 ("gianfar:don't add FCB length to hard_header_len")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2: rephrased message after adding patch 1/2

 drivers/net/ethernet/freescale/gianfar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 7b735fe65334..d391a45cebb6 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3372,7 +3372,7 @@ static int gfar_probe(struct platform_device *ofdev)
 
 	if (dev->features & NETIF_F_IP_CSUM ||
 	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
-		dev->needed_headroom = GMAC_FCB_LEN;
+		dev->needed_headroom = GMAC_FCB_LEN + GMAC_TXPAL_LEN;
 
 	/* Initializing some of the rx/tx queue level parameters */
 	for (i = 0; i < priv->num_tx_queues; i++) {
-- 
2.17.1

