Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CD82AF72A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgKKRFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:05:17 -0500
Received: from mail-eopbgr00112.outbound.protection.outlook.com ([40.107.0.112]:45497
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727475AbgKKRFK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 12:05:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6iruuT9kJhQFG2Ee6NQZ5dBwHxVHmuYl/jp9FvUmhcPnHH3YKlJdP3GZGGLRt/pnRYvKvzD3yaaJ0wpAglLEnjZStp2yow+ioISD0eQQ6806y8htdaQpNEIq13ZRi4bA1QB2RilIFx9DHsDtWFWg5+lzFCjldsmz+PwhrHlVkkeWqQ1dFBXQZ9mmXGZKPU8JBTRpZ9mqkjlfdssLIpmdH+y3eL2wloJ/F0GnxyvSdad5yfB7Cp54Cdb+fjnMCh9wuBRKt4ZWEMS62SvGxsNCohpm2Fy5tKuHSzPpWsN/ly5w+oMbuBdkHPLz5NyHm/doP4UIQzcPpuYJ8czHWItmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+b+4mAnFIEgYwOlWv/ajnYJ5BrOQ8QvbiDRlPgH2iI=;
 b=T0FVtMoxYX8rvIQkPrsXHEfhkzs+Ysxxz8Qvq/Xig7cqaLQZN+cVmfNatzc3JaMjbqua783nI+hJB44nuMEuECRtenNaQkOqwjLH/Ws+N4f6W5CHyEF6Y4+54sM50mOpnl/NNcB13Bb5RSPM12cj5EkV+49LR6gOtxsVZrtlYwr/8/1sLJUZLMb0BMVvUfkfpc5lt5vDbCCG4oXQYEHHoreDWb0rezlpjgPHDbSCO44tVZbZjvBjhsL6n1q/kv2Z27PHy/drdpPm2af4z4mgv/MZOEkFCp8Yx8eyMT8XG/1h4F+8GStr8I0lney53RppD8aSs+CrUlhJAq0t203c0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+b+4mAnFIEgYwOlWv/ajnYJ5BrOQ8QvbiDRlPgH2iI=;
 b=bjjJPVBXe1i8Zl7pG1vvqsPe1KeCVbyu3q3bepk1JczO9rHjNLiQ4/EHX6pngM2nZxKNH2Y3Vkjs2M0h2W3HaPlt5gpEBaxpkPSXE/OhfSHiTDixruWnNIGNOTYjmG1wQWb39VjhdROlZUVnawVYiHJHwswehS/0JYNdq4pJVCs=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR0502MB3921.eurprd05.prod.outlook.com (2603:10a6:208:17::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.30; Wed, 11 Nov
 2020 17:05:00 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 17:05:00 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com,
        pmenzel@molgen.mpg.de
Subject: [PATCH v4 5/6] igb: use xdp_do_flush
Date:   Wed, 11 Nov 2020 18:04:52 +0100
Message-Id: <20201111170453.32693-6-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201111170453.32693-1-sven.auhagen@voleatech.de>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.209.79.82]
X-ClientProxiedBy: FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::23) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (37.209.79.82) by FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21 via Frontend Transport; Wed, 11 Nov 2020 17:04:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d6ee22c-b07f-454e-6f50-08d88663eca3
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3921:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3921814BC892201B40EC9172EFE80@AM0PR0502MB3921.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:651;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WrASiu+qEpmLJwsvzg4Zz2SLdccEDzoHOeS1uIC80PFySNEp56ISBb3au2fXvS4ovkguaAx7XBl1HO5tits64eZUqTcDQVDka/m6ceFdNh7NOaWy7dTHq5lIHqJYf1xoADVvl30PyBZDSUWPUHRhURURXrXRUh9ImnBqxVYTb0ybjPlbOzeZBBSoeXKlY49lifmXFxy/a1Z8uQJAETzX01cSCx6a9CYtW4tqeH4E9i35rlZz0Ifnl9fmSbqP0MEHtsLlIFK79ZOsE0Fsek+Tq0kBCVfRgY+INtRsrBJbxYCjCnStezJ0fSR9nlO/R3yZRXJ9zhQB3PNaJ+6vTxaShIRoikXyZOUbxKGwnIHWb8z4qqR2P2B0Nw8XLxIUmIKt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(39830400003)(376002)(16526019)(186003)(5660300002)(52116002)(69590400008)(4744005)(316002)(8676002)(4326008)(66556008)(7416002)(86362001)(66476007)(66946007)(478600001)(83380400001)(9686003)(1076003)(6666004)(8936002)(26005)(956004)(6506007)(2906002)(2616005)(36756003)(6512007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: NKkvDJy5fZgXDreSHExQg/61r949SINlFVDSR5vPUZ04+2hOT3dcoRPOXIyOh+CNyx079T1En1FMQp9ehsvQHrJv35fpYCBq1y9OplJeTC0ztnoECNJFwZxPQW2BijwDRCnWnyfY8Ra9o0giS0ElHDf6cxrxIHtVIjtEHDZSouwbutDeAKjBKS+5OvzIr9nD5zbguiKqgaiCK6rBj60HkmcDDMRRwBZCrGBXkzWTfw7FC6vY3CBgViLTmnZjVcfIL0xHQ+GavbL76d5o9L9WT+oeVCb2hLKAzvIpQUK2SfjKujXMVe0SP+kb4cFmOrrYT+mBFh/+yXlICHgGncctBa8f9mt+DaZpl+VjJy6xabKI2Pr8C20Bs8wyOD7zId9jqHL5M2W397Z973/E2KrEvHPoSaNsAFONtipSoOtGJPfgJz+UKJsKmL5840w+7aVJ6di0rLhMPdWSsz+3ddgZW/9SeFKB/BOxHERHdNuypNAu96PkH034W6k6ZJ2+IkbzxYQLFz300bgXMkIdE3uGgZmYdxfkemwDrXif+6Jks4Kkr8WE4qthG7GUQBpA36btDADd8An7AOmdM3fmv9PORPSfQP+PcnumWEqB/un2u5+EKY2sf9zKsNkX51FudEH2HowaD1vlkA63ZOGgCsPrRA==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6ee22c-b07f-454e-6f50-08d88663eca3
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 17:05:00.4466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LoZmbs747vguA5YoAFd5j1op21Ceiol/fbs8bNEHCqWuyjSc8I4nKLz4I5STbw7IG4w+wpgPcvbgZyosu7UfZXWZJaVFV402V5tOaRPUOiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3921
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Since it is a new XDP implementation change xdp_do_flush_map
to xdp_do_flush.

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index fa93aec0ba04..b6c793441585 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8781,7 +8781,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	rx_ring->skb = skb;
 
 	if (xdp_xmit & IGB_XDP_REDIR)
-		xdp_do_flush_map();
+		xdp_do_flush();
 
 	if (xdp_xmit & IGB_XDP_TX) {
 		struct igb_ring *tx_ring = igb_xdp_tx_queue_mapping(adapter);
-- 
2.20.1

