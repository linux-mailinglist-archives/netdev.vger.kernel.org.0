Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E87029106D
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 09:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411663AbgJQHM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 03:12:58 -0400
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:15328
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410562AbgJQHM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 03:12:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9s0q0kUxqBPjVwcjiVf+nf+qoOdyHdZuGRCrtM33UlFQtlBRntZ/Gh9VmJKwjeNPdYux6z97sjM/uA0tFApIrmXO2Mfz3DyqA5A/aSvFxA7mD/fO+1KP3lBDENKP9LWnXCUhOvtssm+ZuYKN+53iLtQsPUmxRi0QrXQcCaMhvHVk8N1roS4k8bxO+3kkGmcXHGVjs4BqFOZN1C2R4srW4AWZvFZv8bADDOCRMagqPQqUDFNsKUZpr2U8kuGRiLCcGYRq6kfB2Bv6cyInPrwSq0ozM6CylTI8pAqmni+U5lkB+0PeplRQBFI44e4XD46N+NMtIGq1AQ11k5jiVCyZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NomBr3LoGQsa69k3Fzkj6rQFsBUyW+u/rsI5lidP2iw=;
 b=Ueg0AJceACGcQyexOBY3cDpA2b3THE/YjzohyPWaoAWjF9mSGLkpJo8gFJfDXWsnBu+1+Wy/VaAjBQsqWczkhOcXJwgkiFEbRSHyZfsodaXv6Iel2vgCLCPnngYQZNg9xbTDeWHoFCqcrXwIU2C2MOjWdHu2JZwGIvQGO/PT7nHSnNj/a62nn9S71szkcQHx4w8l7sas5h6Hi5lS/N5d1eXGqMhNgSlS1yKrXXvLDYA5iKKeLjbYQ/qcAhjFIV1mpNPx2uWg4Txhx7ON6WSdyVRHbUSonhUfZE+OyrpZvN3pQwsV//qNC6O//ITKkM1dUfv0pzN40jeR9/0ersXfTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NomBr3LoGQsa69k3Fzkj6rQFsBUyW+u/rsI5lidP2iw=;
 b=N73Av1DyuAV7+ltuLcs6bzSxx/slWfCn0uBh49PKFbGkb0i0tdMkaa322pGgpIwsmK7w+z92A5Gr5Tz8POJkuRHsYW1KKPm7F6lQwr1Ch2m/AMZ6DXFY6pT8P/uH5U4plqNNhn5PKJyAGkz7JzRkNblFoQK79Cf1Jyu7OSCuV14=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR0502MB4018.eurprd05.prod.outlook.com (2603:10a6:208:b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Sat, 17 Oct
 2020 07:12:45 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.021; Sat, 17 Oct 2020
 07:12:45 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: [PATCH v2 5/6] igb: use xdp_do_flush
Date:   Sat, 17 Oct 2020 09:12:37 +0200
Message-Id: <20201017071238.95190-6-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201017071238.95190-1-sven.auhagen@voleatech.de>
References: <20201017071238.95190-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM3PR05CA0087.eurprd05.prod.outlook.com
 (2603:10a6:207:1::13) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (109.193.235.168) by AM3PR05CA0087.eurprd05.prod.outlook.com (2603:10a6:207:1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.25 via Frontend Transport; Sat, 17 Oct 2020 07:12:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97e67ce1-e20a-496e-2792-08d8726c0b94
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4018:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB4018D7C0AF0F487126D9971AEF000@AM0PR0502MB4018.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:651;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1uAqfKzQswolkot+7HHZUSpdQ3kVzY8jBE15Sh6YsobX0oswIMPcUn425tZZl0235/ZbJda8iuCWH2iM2jrMLdO2ZFDu5oACk09eRnqdnuRQY9Eqkr4SpyN4h7z0Kpk0D3uBG544/aD7rI1kN66uQ4d+Hkrgtjx//BvuZkiWW9KUHw9Xbr3Oe5NBhSYAeUNbd8n0Hh89YaRGCmLPsG1F1PQq/WL7Ws4HcMbv4TG0zXvNblD4KfaPiRPOcyG+7CeALGhGW/wTXL3GHc51f+N14dQaerQgAAcfRL32Wyxn910pUAIsSHFkEyAicHCcdVdtCJN//8DYKWDBs4NzMY96EFOkryp6ehbv/G1cUOJpUeufgnX5Ypy0m9k2avVUsPuB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39830400003)(396003)(346002)(376002)(136003)(1076003)(8936002)(66476007)(66946007)(8676002)(86362001)(52116002)(69590400008)(66556008)(6512007)(478600001)(6506007)(9686003)(26005)(4326008)(6666004)(83380400001)(4744005)(5660300002)(956004)(2906002)(36756003)(316002)(186003)(2616005)(16526019)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: fxXgHkULNGeBG4izx9WfhZjnYrQYsuvvpjcKsQeNAfJMc8Xu1GqXKvLcfObla/QUdUSY61sFOoIrvA1swwIElRR/g/URq1rP50qdxdGABpxrgSH7p6Z8J6brje6neOgn7Ol1ZxzbUK0u7v9OYzjnrRYKyo49Al6CL5qrk8+YPBoY4FNkfnBVmEXDXV45WQSc2/J0zvNkrefBa1ukjfhoJd0uRNqY+3bgtBVjbODA89asAXQAWV0X0J2whQILTaX+cTaSWi2pd9jV9MUvirEd92AAxOxwFkK2kUgOLmI2gKX4C2KEYjR3UQEP/aW06UfR6ukgta/t56usbvLys/SPY25F17pSgDjjvKnGQIJagpY1rVo6HPbh4HjSHrWvNiciDnXDDRXfDrdY2KWm8Hl2M+TV+U2MfP9yxSJxl2jnOLji2wOKWEeU1yzMfdYVSoJsIC3wRq0DK2Jfp43+RnftTP9sjKPYkejZQf7MciHg3RFmXcMRHhDe97o34SQXMQBNGQm/7+65CbpwabzuUo04yFhVSZLIJqdxOL0UexuTkh/IrV5srX07MGwmtKO939N53u5B7Xt+Oa0R79XFea/Nywmlo4j/KX/lOm5o4VS6E2AimdzLW6Rv98FLExp5oZV8fqdGBKF/cXjDUTDS3L5MUg==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e67ce1-e20a-496e-2792-08d8726c0b94
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 07:12:45.0861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+YDBX+aLqewvAyShV+nDzwac0ttyNJ4kOL7HtnqcCe5FeiKEC/fdSbMBpCUmKBaI2FT0mmn6UIcyfh4RnoaX6zrY6YnwULAM6zNPntWhDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Since it is a new XDP implementation change xdp_do_flush_map
to xdp_do_flush.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 36ff8725fdaf..55e708f75187 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8776,7 +8776,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	rx_ring->skb = skb;
 
 	if (xdp_xmit & IGB_XDP_REDIR)
-		xdp_do_flush_map();
+		xdp_do_flush();
 
 	if (xdp_xmit & IGB_XDP_TX) {
 		struct igb_ring *tx_ring = igb_xdp_tx_queue_mapping(adapter);
-- 
2.20.1

