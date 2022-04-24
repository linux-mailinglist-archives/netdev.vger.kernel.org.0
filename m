Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9091A50D0E1
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 11:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbiDXJsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 05:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiDXJsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 05:48:03 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2125.outbound.protection.outlook.com [40.107.215.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4E05594;
        Sun, 24 Apr 2022 02:45:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYxSOLVsydOftH6y58TwNX6qB6UVFbmWW4fds7FAl0+9hSBQyECvxGLYAzwMI1snhBahwDkwkhaUJW3V8s/BVxh3DfvwSmsBuf6aUV9+3EFjmY54q/h0/KPW5GU616dHDnKQx+MHGsEltrSI2lYdHMBO/D/ct7gPZG/m5luSMLrOvNjpTSraRkDJvX8dKrxbGUTWxirUQBfazjDIFvS16aW0f9cD1MSs2KTkOeThttNtr6nE5RqWt/PHipgcBeWG/MEqp85EfHZpf51qdBEU+cyjaTriy4GW48mgKxETA28zLENdl1uRXzBTyW71u3s4wd+/LsxyS4QDmw86pa9n0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4ScGMX45XpTVE5L0HnhJ/NoDECuVp1PTIlYZUYcapM=;
 b=QVYfLWh7bn0hvwN1CSTj49NzPOo63Q3TWgaY3zwVCam5wsKH3OHidygHPOQvpf46zb66TlfuyqTZgssbdsl5nXIX+JL2x+4z8StFt8Ypwf7nNBfvXQk0NUDP54/jVcUUoYVnTOnm34v20gctSm1Qle7wkl631AnPYmpWM0+uKVww0u5TGzUnHRs40KJT7pNmlCxBusI1aIqx0oKiWCW9f4J3tPlDil9D/Fte9RQD8QqaH1cavaumeiD+8y96kHtM6ZGKTKDzdSFMmjGQdjCzDCQMPiPsKPzvli5QYY2dC5INKETwqIa2d7gv3Pk+akNQuGvz17UOvoaLTeQ7U8CMTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4ScGMX45XpTVE5L0HnhJ/NoDECuVp1PTIlYZUYcapM=;
 b=WxApmgxE7tymFlQyt19HKo7PZBbgEsDIZ7qBxLha1kroPhaAnzqTJuU8EFFPui65UF3qY7xCLAoagm51aK6CeuSLweVv9brTUxlTdHOh5huysXVXkXKEZL0Iub//zc1ljx1jbcjzCwaTZWfiAh1zIO6dvouZpIrJkaeZ+beuoJs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 TY2PR06MB2925.apcprd06.prod.outlook.com (2603:1096:404:53::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Sun, 24 Apr 2022 09:44:58 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5186.019; Sun, 24 Apr 2022
 09:44:58 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] ath9k: hif_usb: simplify if-if to if-else
Date:   Sun, 24 Apr 2022 17:44:41 +0800
Message-Id: <20220424094441.104937-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0066.apcprd04.prod.outlook.com
 (2603:1096:202:14::34) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4b7ea6b-a705-4508-14b2-08da25d7173f
X-MS-TrafficTypeDiagnostic: TY2PR06MB2925:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB2925716A305A583C784D68F6ABF99@TY2PR06MB2925.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q9BwGVeDYmrduOqMBK2xNQ9T8xYZ7AxA/2AXRUrX7iSkXXzv5ZnI7XnpJeY9PBbwNL0StzjKSCRbhpZxPuIcxRuk6G4Y+MKQtk/s+5AdVzs1gCxiKX4P8mE/QW8tzjlGSJ3WNJLKAj3wbLyfnsHKbJUzw7+Z/Lrri9Tydy8wTpJafTWLvLDCJjWxKjlkTwSc1ohbrIBH9AapCbxV8CYgonmbdxIz/Fm13/cLIspx5DfNUilRLS5Qza9bg4dea9ROUB9B2Si4oJ8Jp7PxAXIcfT0zxaBfsDfQVYIM273Hqua4NV+F2OOgKHCg8hVMtyE3A7mk5w+ofLGH8PSQ0CY5fueSPpwMjPtdgCBTnpcVrgmWb65xs8Tq/jKhK1oMzpVmhiL/6ssFe78FpXNx2+2gogjBqp5xseHQ5FnOBs3RgTi3w73EWf1d0Susm74s6sKoqiQvjRdE93LgsxtNpdPtZFJEUGk0mgRgIQxxHSVQIsUHhPIH8V0SVgWiFWTdm6J9tCLonMwfOke239P7Zs7RLdPx9sCzIPXAFd8JUdLkTuACqre++Zz2sBgzbGYaY88xLFN9WL27+sYzRjCX6Ai2qoGu4bQzFK7lfuj7C/NcccTqyXCDJX8NANsbSrXalaEW+kDD+5sVR9Z3H+UhBhngXprV+E+YRje1whQlxRZbozpm+zkvM9Gdp3aeA+LtoMIhTNcd7Ft+iTnsi91hKF6ACg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(8676002)(66946007)(508600001)(66476007)(6486002)(4744005)(4326008)(83380400001)(66556008)(8936002)(5660300002)(107886003)(2906002)(2616005)(38100700002)(1076003)(38350700002)(36756003)(52116002)(6666004)(6512007)(26005)(6506007)(110136005)(86362001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5bZLotuxyeWaYhk+KRvFSMbUbg/Y9AU0rL7ih5Ba76MKq11AA8ATmo1IbCkC?=
 =?us-ascii?Q?zA5d3YbAlLZdjKtcobj8KOdlxSQ7R1hk5PBbPRpF9ACTEBaFKTaADAPhQttU?=
 =?us-ascii?Q?w8Vn5+ehq6Ya/CYLtx4kI6z3CzTJ2IGwd5Mf47cFFn41orZ40O7bWxGS0mB0?=
 =?us-ascii?Q?q1L5cKAQefLotrM4opWiIQ0Q5kJFBwPlrcNqwglX3ARxP4rtLBZ29NpXxqHR?=
 =?us-ascii?Q?h7lpboPksQH/zNeS4Xo4iqwJ3vmq/pEQnUV4/9Jq/+QSCv9Oa4bc1vHUIQZM?=
 =?us-ascii?Q?GleHKpJ80urcT7+C8HZiolBpX5sxbyn0SAtS7BlOkBiWlZXMkIinlGcZMsVN?=
 =?us-ascii?Q?ezast7n6szrwuw7Lb73Zoyk8qj+Bc2f1mvkq9fl6Am/zkE6IxQWj6FmaMFzw?=
 =?us-ascii?Q?JIwR+VwwemDH0Q6nGcgFJYfSYv/XVPinfqUDn9c4S0G6l571YgpAt5hRYlGC?=
 =?us-ascii?Q?XMVP2s1dHSHPuwMCZq0v5i7r0BpPI5FU1ULRtAqn1JOYaHgRt2KDflDT61rZ?=
 =?us-ascii?Q?74gjaqSLzovUVCRQqbV3LnTvdKs5kLJWHRUAtUBO98oPRLxHkc+XwJbCR0Nv?=
 =?us-ascii?Q?AyVWVyjJGw+ddLVMNaI9MgnGWLpnfLDrWAjScK4oUEKsb5hpWVz/p8ysH2Sp?=
 =?us-ascii?Q?w/W+2cc7gQZ0w6zw/ZeigK+zUCGxBeFhkv0wMGUUkg+FxWKEldE4OEkbM7z5?=
 =?us-ascii?Q?hizjP5ozgoz8QVSB0GDrfauQs6bKZ9i58HBkKkEB7K+YD8zRQevz42ZvoMX8?=
 =?us-ascii?Q?Z6K7tAzg24asHB7VxCGnwonRvw2Ln27YDIR7oZ/Nl444LusYI6YGpV+uY/2g?=
 =?us-ascii?Q?5YoNdGEg0IsSG4AX4fTMQKnrfYNpzUZh0AdA1hQ9+Zw8VPSnAiHrmnEkK10Q?=
 =?us-ascii?Q?16AqXLi1fDqSwCuS1GwKTOoueODVFbJXf+dFkYu3zHRsJiPHT25y2OoqAadh?=
 =?us-ascii?Q?zdF4mvNdhJOMwDF1BV4x0G/tUP+QRchUY63eQtwNcHcTXk6rpvJplDoI3e3c?=
 =?us-ascii?Q?NvoUK51NEwhTwlU50X3QoIiuFXaVhoI41TBz+6DNtfgJKUQzlTtublNg2HE4?=
 =?us-ascii?Q?kbfS6UH8s17GIrMlodi6PHx7bD3cQXskxQ2RJWC5XypuYQmlD7/2jK7cB8Cr?=
 =?us-ascii?Q?tQ1dcb2hX6yyAYOPjmpL6gLXs32w4VGUWlL2oniEVeqT96KtzX39ln1asxpw?=
 =?us-ascii?Q?FM/jOWCJMUe7XKcI+vKrqjm5cpY0dYf+Y4krG0fvdNq6LKMUThyDtTwI0m8n?=
 =?us-ascii?Q?NLTj+wCmIUXPZvIUtoGzwLlyvvcS/Xp3RpOeQi0Ui8wxzqdsC1GPm81+MvN7?=
 =?us-ascii?Q?X+0QvLLSAa0G1FWXPins5B4G2hPbVkBuDUkDyvoj2QZIOJKrEC2OBNVpXtn0?=
 =?us-ascii?Q?7SmkWmPx4BYBOtFCsGdYG3vmOcol+PFJugZZ4p48iYCigrt5aP+UAdUPzOD4?=
 =?us-ascii?Q?51/DBluhbab2YIg/6BKBM7ZwbM7nC3kRcc4oVbEo1sTrF1VmDyfWUG9r7LqT?=
 =?us-ascii?Q?yzqRFiO7PX/ieaM1vvbQqV8ck203SY2Z97KHCG7gO3evnjjT/9hj5b+Yb1Zp?=
 =?us-ascii?Q?9nvpGaF2MY9VReWG71+LkqI27HWf69oNwFd1p8VviHdntYbIpdDJ6+Xp4/6B?=
 =?us-ascii?Q?txDY5h1nbZaMt5wplz1sxMhPDgSJ9KBw7a2ULBe7BLAB04vysRjl/KhK+svK?=
 =?us-ascii?Q?NNTDlbKaEfFrpRCUik5CV1BzSuWdoMQLlkifR1xFImMXkBm3hKViMU8DWn3Q?=
 =?us-ascii?Q?tz4T0V4P2w=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b7ea6b-a705-4508-14b2-08da25d7173f
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 09:44:57.9864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DOwaZ6Cs1q4AOqqt26JiFMA+r28DCdCfMR3ZrpmwPbU+/efoLkRUkmFLF1gUYklt/0qJofyTr6XXKSkcsmXQkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2925
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use if and else instead of if(A) and if (!A).

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f06eec99de68..518deb5098a2 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -368,10 +368,9 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 		__skb_queue_head_init(&tx_buf->skb_queue);
 		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
 		hif_dev->tx.tx_buf_cnt++;
-	}
-
-	if (!ret)
+	} else {
 		TX_STAT_INC(buf_queued);
+	}
 
 	return ret;
 }
-- 
2.35.1

