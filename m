Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29124ED958
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 14:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbiCaMKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 08:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiCaMKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 08:10:16 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2125.outbound.protection.outlook.com [40.107.255.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2A4457A1;
        Thu, 31 Mar 2022 05:08:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILWegTR6TPmRUBhvTaTqOYc9lCCWZhyWGQJ5/ItWle3IDaFrpj8gX+wm5v2hfNIXWI0CzjRwnC4x4clpK0foHZqjUcDiy8zG2k8g0CRxqKxaXU/el4ie8vCVpHkmsjmIlIBORIcbxUCDuA0iQ8H4SUjqMglQjRLcKl1z+AZ9yWvG9H+iQFydEIAxS9RpsTtqqg0jmD5Ooci4QAim7RNY8bg8Nr8GzdzjKnZI5AfpP8A3Wp+5tsnpHDL81VnZ9V4Dt5xmQqhFAd5aXgOAzAInafiGhz35Wj3oitGU3ZbbRyxJ9UYnNl7oHeIeSS8+VReoyVT0Pwki47ysFnrAmYCLfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TX+KffmLSdKcObPxPYq4w7P09k+IE3x2sUc4hdGshqQ=;
 b=GuZoEpBzBc0FBPnfiEAQLq/s+Gyq01AV1MdBIxiRewdcvzF1+m5T8CL18fE8ypPJ/L59x4f9j87W7iN74wfWpnif99lXlkWSkvTfSQxL0cet2X2qRWYPGgqfaT2dbM/9L/HYPOFrlNn/ajNnxzy3DZjFkKmfbwFTcaa2vc2DAEjcVcRIy//ThTSglSDaNd129Y7T4FoAKMdEsvIQ7wa7HkjUiGgbwVdj33bSCryqA1jy+R203AnW2s0Yi8rYcH8BFtsITdFoJVcbAjyWtO2Z+ZFbprCidY7NLUXWyqd27KRLbDNLC5/t6NoHX/48aUe322omrgXbhyDRwoCtps+D9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TX+KffmLSdKcObPxPYq4w7P09k+IE3x2sUc4hdGshqQ=;
 b=ZFQwa3QbV60lXrZIpaNPuE5TF7JcE/GALocUTMVdTzuNqJO9scTQJnTpNLFYzmVSkDDuBY+9qwwdOuuoxX4w10nLalem4KReI+BGRDopMZskKySmRGzu6PIyijrMHnScDCmsldmjmk3PHBDuYltWYt8QloHiTUeC8+IRGRzsjrg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SI2PR06MB3882.apcprd06.prod.outlook.com (2603:1096:4:ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.23; Thu, 31 Mar
 2022 12:08:26 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::6c6e:d8af:2d3c:3507]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::6c6e:d8af:2d3c:3507%7]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 12:08:26 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: usb: remove duplicate assignment
Date:   Thu, 31 Mar 2022 05:08:14 -0700
Message-Id: <1648728494-37344-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0302CA0015.apcprd03.prod.outlook.com
 (2603:1096:202::25) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ca93b6d-9dd5-4733-be2c-08da130f2969
X-MS-TrafficTypeDiagnostic: SI2PR06MB3882:EE_
X-Microsoft-Antispam-PRVS: <SI2PR06MB388241FB7B9BD044C135A77DBDE19@SI2PR06MB3882.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S78W7rLJySBjEE8Hm4GTL3ceZXHrvem2s5ADiOuB3Dec0eiBQ/KraJcAyx2l4ZctF8TW9RujuIex/or8UbLrmnyX5+Rk6UXanxOIgxeEDPR0KTUBnHHbWpUuwScMJeH2NZGMh99+KKdcHkI3pH4VeSedV1S018T8AUinxc2t9DT7NVFGxofbYLox8+T+tJXNVtjkYHKjgCCdlBnv73i6wpUz5TohcoIS0klCJy7m3fRVD4iK658TrLzHPugbCc5e0V/R+XDdIellXzV2dW68psPD74u8aUAqFxIbG3+nrQiFhIxVqUEJl0KW2pnjeMQ20GNJXxzhfT8dK4YIrqUyW0DPQzD9fVW0YoAdyMlpaGjRcy1ZAv/E/GmKVpF6R2Xy9JMMO+E2gTottluyFlfwJrYYbxHkmWkJuJMd6T/C3PID61xrLGeVhDWzc3gTxooUjiRz7LnxDPvyzSHbpLDqQX84y2D0aB0dQVFlR+37t9J56g7AzkzyEXWRmRk7r5AKX0Sr64VjzJx03p6ldsi6s5AoRiCnADJW5xwTZkWlrvCKVCYfDl91B5gmjoXkZLrqmY2rMNhuOwXvDEyGBNMiOI9xp6ZR4hmTtiy9DNDCCXYkt06jNVdYO2dwjs6RUjXgifHMAAzg6yS7ULZkxgXeUVQguAubujca6s/RBUDZI2coVI10JUXZAu32qkCxVE9i10uyyaDu1a45RFKz3PaGPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(38350700002)(38100700002)(86362001)(316002)(8936002)(4326008)(66946007)(66556008)(66476007)(8676002)(107886003)(2616005)(26005)(186003)(83380400001)(6666004)(508600001)(6486002)(6512007)(52116002)(6506007)(36756003)(4744005)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YdrdCsSs4XVb7vacb9JYdxbiMlLPd4cXEBAYMbhkayzdvKbcbVQNDY+HgEC6?=
 =?us-ascii?Q?EDk+ScVMWXdclXxAcvpM+NYQcs2z12bIvZ14xPx6mKIOomfUhOKz5yegx+XY?=
 =?us-ascii?Q?nhigxSLNbVUVSwS0BwtXeYCnWbI53VRXnm9QuCNNHZX4E6lfKcprJG6zXfsD?=
 =?us-ascii?Q?M8rwSSMQ39cDfQf8x9diKNLHmE/X7KYJqYmlIFXYzNmKKVgrNdgihARD3Ojt?=
 =?us-ascii?Q?t7H/0kLor3YmuT/VbiPKNaZuifvGQHM35Ykn61RaoACn44fTeqmNv6VJZuTg?=
 =?us-ascii?Q?Oc3zKe+IDFdQVGflWEFGtdktmNQE9nxU2moBRTD34To31hXS5xgYea5Qe+9R?=
 =?us-ascii?Q?9kLTSuQg5o+jKzYeaGBQYtX3uJevVpIaCJN/Dqi0LDrKo/WXv6Q48WGA5jbr?=
 =?us-ascii?Q?7p43ek7gGWREMUF9vgLKJP9rij3ZoRBGevai5sD8Hpb24E7Dv4Ea8VV/ZeP5?=
 =?us-ascii?Q?s0Ld6Z1nnpkeOP4VSBlIMjTKaIrZNGrFXwQfpCn2Rynitil0PoAmgHuv+w6x?=
 =?us-ascii?Q?jBNZydJIGjbyZvXeLWjfwA3nTE6Dr3ToDRIEW0IsNmgQQ9Bxq8cftR1wyCD2?=
 =?us-ascii?Q?S1IbBJVlG2OubOy8s6cblsEhQe6H4vdf9W0yAi2pkR6O1pvFZCCQWlZgmv29?=
 =?us-ascii?Q?N84z9GIlpiUFdOJ1jpbnCzYtdp1XAJh6ZwaFk1o7E+izOHqg9T6LYkJeFGDf?=
 =?us-ascii?Q?5bEYwsj9ARwrl4RIxCmHqGqzrhW5HxPRnO3R2MbJPfgqdmsBm4R5tJrnPOeN?=
 =?us-ascii?Q?8+frMxv1spntesFMsRnGaiSJyAeotsVac3iQdy2GV7iJzftW2CRSlPgn+4Es?=
 =?us-ascii?Q?YYBzHMz3WPW4RwtD7PPnn8EbBaghkwVDrQ8WV+199iS6+nQJq8A+wN22atkU?=
 =?us-ascii?Q?lkxXXZ9/WqTMFCIBIJnTdqoKPQVfH4F9/O4bf+jmR53gOazp99ZRHzBrSvCR?=
 =?us-ascii?Q?TbG9Gahysd5c4ThRwD1JVYvLzE0/B0oiBTR1RqWj7FbgHtX+ZZ4SGa8+c5mu?=
 =?us-ascii?Q?ieLM29qvWoh6Ki8CTI9IKjUTrqB1MPzuK/qLoODk02kwoOW/r6+o1TVBwqw+?=
 =?us-ascii?Q?w8DhClgoClHYG712JFh+b64bJPyPW5whjN7TxO9sk3L5fp6rpnmF/gIpHWjM?=
 =?us-ascii?Q?Z5jP98MIDT1IwNTGIwwMiexANpciPgziMGT8WSA5XFyGpoc4FEtalDpaLPUU?=
 =?us-ascii?Q?UHwFLRo6X2jgy2lD5l6dPpGUt0QAYY4Hk0KWanZG7KisI9d5ity8QnRHA2wK?=
 =?us-ascii?Q?K8oXwGd9bGO3/gGpndF3fE54mAlrcW+Cq4pNK3HcPtumO/oBJiA41tESYcCK?=
 =?us-ascii?Q?JP3G+zJsKtf6rxsZzR+Tg0KhPeaMj1sxdDzyWQfXGbwMZZ5j0qq1f2nv+2q+?=
 =?us-ascii?Q?o36H2uQqD2XFkK0B5is5X/N5Ztn7vSXOc4T7vNo9oGpw+V6EYDIn3b6jyYnY?=
 =?us-ascii?Q?V/8l5uptE9gvL6YRxubwcRQgjsbV1tkUfA9BQx8pNadC9I1fN2PwYqbrHmGW?=
 =?us-ascii?Q?XClllfhfW9gklNbBRtwJMLIal+1GSYXk9padhnh3HdsSUspIfEWjIUjaMSX2?=
 =?us-ascii?Q?n0lxKohLla36GroE7nvno/fyO1MFNjytJBOlsiTX4iEmSiUjyFjLLeO+fnYt?=
 =?us-ascii?Q?x+5mucChBHWKTUaU5AszhZQ8RCTBWtrnNjYs6nv5B5LWp4R4WxijO3ZIS6Kp?=
 =?us-ascii?Q?yPO55ETNX8lVTQkzODYybXnvsuQPVbzD6H+UbCkC7yt1MDs2WJ1ONjcPaeF0?=
 =?us-ascii?Q?FbK/8j01XA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca93b6d-9dd5-4733-be2c-08da130f2969
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 12:08:26.7985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3jelA6Xs0GYiWKeByODVUDoB1g5sRFbxs0ffbswnER2nwm7nJcxt+HsjxM9toO0PrxzJrY+q4PnR0yt5c3qQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB3882
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

netdev_alloc_skb() has assigned ssi->netdev to skb->dev if successed,
no need to repeat assignment.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/usb/qmi_wwan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 3353e76..17cf0d1
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -190,7 +190,6 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		skbn = netdev_alloc_skb(net, pkt_len + LL_MAX_HEADER);
 		if (!skbn)
 			return 0;
-		skbn->dev = net;
 
 		switch (skb->data[offset + qmimux_hdr_sz] & 0xf0) {
 		case 0x40:
-- 
2.7.4

