Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EB750D0E4
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 11:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238915AbiDXJsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 05:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbiDXJsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 05:48:37 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2111.outbound.protection.outlook.com [40.107.215.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DEA29CB8;
        Sun, 24 Apr 2022 02:45:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNjK66Bx86oRW0co4mgU1MlT6rR6kwHr7so8VTVOao5PRD5FmzaOL74xgtVIArWg2mrC2kXJv55xL4JDGQuviH2//DaHJXupzCgUmYhlYo50rFHHILrsMKMIR6Vl6hugcDTq/oAbIkUbAVX97WoKO7Rwrt987/2EmdU2ADBoYyeskA4jT1KioTtCOz7/B0YuiQ3KwWQ5HRD44xF+NEDtKSGcyAaCxtADcldxt7ndttWKd/H8RDFzQEdJiKNdpMZKKhLeHEZvRX5jff4TJQ47q/JgFmRmmHEA1K2V2KnahYRh4wcqAkAaZdA3N5zUr7j06pvOYWV55n5/MfczPHXXCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6yYKYNA50mE/CGfCJHRuKu89Rm4W72b7Gcm5pJ/+6Q=;
 b=nn5fd1FwekXDaOrTf42XEWEuQYMq40YJrFRoRDiSIkkRSHsCYU2haVZjyhZ2aChHiQPRObUXJS5RGBk4TWXA7wqVY1daMlqn0nA+ip7PMSezkEHZG0frg/p7dwNkCLcDPYDK2Jv7t9S4AwfIMz6qd8q3jG5rWun2Tj4YUey/PyuL3E+E9EI6pU8kU7gvY8ddo7rh8ugsrlIyI62LiOk6dk2DODWkaiZhv40qx3NSYw5ZsL3sEO62433M5HmnqtRlrwST+peKlRsrHPqKVMS65d5uXXg83TR9JIt5DcYFV05svMBl7YolH9QjCWObXvMm0f6I6RdegfOKkF4Jtxc2Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6yYKYNA50mE/CGfCJHRuKu89Rm4W72b7Gcm5pJ/+6Q=;
 b=PANsXplRep12IDNp9uZOLgaPUtPxX73CMYzutwkmC99I42eWuvTd0Rmav29czP5rcoJkJwBIO9G6PDDqDUY7j6lgOYkg+KI6iugcJOw1K8Z5yBACfVMVB1xtqKC2c9lKBg9YvIHDHnIcIpmaSbntZULnJcaDuEDHEhcBbBnDzSA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 TY2PR06MB2925.apcprd06.prod.outlook.com (2603:1096:404:53::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Sun, 24 Apr 2022 09:45:34 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5186.019; Sun, 24 Apr 2022
 09:45:34 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] ath10k: simplify if-if to if-else
Date:   Sun, 24 Apr 2022 17:45:22 +0800
Message-Id: <20220424094522.105262-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0063.apcprd03.prod.outlook.com
 (2603:1096:202:17::33) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4292273-a2fc-4cd3-b8f5-08da25d72d98
X-MS-TrafficTypeDiagnostic: TY2PR06MB2925:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB2925250A80A09011EA7BE011ABF99@TY2PR06MB2925.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: InhzxSgYS7+xda3m3CRq7qfQhSk3bRZU/Y6R+toLE/4gIxSJycJrPzm/eVC5TWPW9ojrfN24z3Uf4hWxTtUwiivBFnYkp8fN+DUSiq67AwdUgbOscLJAkAptRbodmDh/bGcEVYvnLefFRISf+DwNJzJbRfHgCn3rxdLjX2CPKUs3Mi5ZkA6kW7S/85nAJEoZ9+piz940QmluJ8wwh1xvpdXkCy4x1RTTQTd+MzdAuMmJNiUVWMjd1F+LS9fVKgPebn4+e2e48Jt5aup1p/1DAULwtCzoprrlOARvWezvdheZRWXp+xODrGzmcS8grh75qDo9Amia6UkzB0rArAreoizXbHuHIBXdVyfPgndnPDQbbww/enB2jlPQDyrk76m2r6OLVaPYQ9jbDioOwJ8ELbcZkn13vJtzeUKbRvV7t9NBdowasfZPdB2EfMQ40Uqeg8tjIFo+QztTMUNPGZ2RkD36fAVKvc6Mv3vNtFxY358HOLRttgMBx91HbVPATLXus2fOA+q0lNUV9Y9b5qhu/YZwfG+WcKeuJ+J1oXT/L3+vvYAlhc6N1GsP13MuoOtXi5LfK0rnpnYLclC5e8mzxHjai8AE8VmTpsxFWQCOdHBW9kZsgv3DOfUuzXKPYKJO3V52VXkp4g7jv1v+YT8b6/2efSj6pyJJsqqOBYHC/VNi82DAwri+MsgMVdqmE1CtiVCpgbpWeLq0uLrOrD3lhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(8676002)(66946007)(508600001)(66476007)(6486002)(4744005)(4326008)(83380400001)(66556008)(8936002)(5660300002)(107886003)(2906002)(2616005)(38100700002)(1076003)(38350700002)(36756003)(52116002)(6666004)(6512007)(26005)(6506007)(110136005)(86362001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xAY+T5WNEGHew43cwT67OUG6S+uwrdGrgtSWLZXbupbTM8FjUKo7uSjzNxWe?=
 =?us-ascii?Q?jova++dfbQnhPK1kQyInpFSuY7o4Xsu5mSbL0zaN+LOlvor0zUr12u7hDskC?=
 =?us-ascii?Q?fwRoQTol3NPHMn1jmC4Kw4Yfdx81+k580G42hl8W4B4USiYkF8lQ3zS4TXif?=
 =?us-ascii?Q?kNjgIf36vRjdD8Img5lv0hTVTSCarlR5eZQfwzItyy+FQ6izunyincFe6q6W?=
 =?us-ascii?Q?VyFcJIfhtOiF0a247wySmfk34KhJdA9Yf2K0UyWBnIFGpRxvM5HwVuKJyqGX?=
 =?us-ascii?Q?O11nLjb1o/Hs5jGbacUAxKBADUoSrAse9jMIFTzuaYZFl1nWkNvnXpg1s6ud?=
 =?us-ascii?Q?MFwGQRW+hX34uZN7ucZki5t/iB6kmc6b6LkRHMCO9/g8Xg489Xg/ToPcop66?=
 =?us-ascii?Q?w+DLhjb4YYUhrnly4/k17Ll6Y/MsMrg4VxQNcUbmQZJ/HsKUiNjMdKFd7zUH?=
 =?us-ascii?Q?olRGwUJrmMiXx4VWSz8ca9LGTJFKz1OpQn3RCvhFTwzFleSrhz2Oyqtezku9?=
 =?us-ascii?Q?FjzEaLYs3yVFagC96t1y7Ipmj6+5DP9YUU3iIwozGEIZEhSTf7vNVvNDRZZe?=
 =?us-ascii?Q?P1GG6063kXaqFgJkoyYaEGHEuwE7wcRkhz2ex08JAW+f9BHu/5C2RU9IlC0g?=
 =?us-ascii?Q?EiZcHRJFp5sV0EPxdNp0LbkusFxgEkUyRLEGckAphThV4k8vNRNXWksI/r0z?=
 =?us-ascii?Q?oDGndpq98jAF2rb3udivJMDjIybROXQL2aBmFN+gNZNQJ1i1RBArS796k/Fm?=
 =?us-ascii?Q?oWESnUS2r1rkul4VC89rCHIGUdDDi3pbgXsU6nOj+SsNZ19JiQ/MFR3PA8OA?=
 =?us-ascii?Q?uOiNf5DGrTOljYFfi7BgIKG/TXJsto+ONLiu9E+mXCx+OBxOtBXMqL/U4ZiH?=
 =?us-ascii?Q?C8efQSWIaTHQIufGg6sRGL5wU0rlgM65Gqqlmq5wFNvg58pI1can+TkYQavY?=
 =?us-ascii?Q?0BR86ngq1NscsrXPJpEDcP5dMxVHGedFEOJzm7aYzVDHZG0zyIlbHlOfRjgO?=
 =?us-ascii?Q?Iiyq4J1WURqsYBi2DJy9sO/nAwMtuaSUgtWfCJroLEo7t0xY9PSSeRP0O3aL?=
 =?us-ascii?Q?P1ZepuDWBsRevc/3dpU6vhGJZWzkUhipalCxw5d/byX7mBEIxV4grsz7uDnO?=
 =?us-ascii?Q?QAdg7g1gUOf7rKwaZ4WIV6k5hUvIbsI2HP9NPLtHZLH1XBsbOfWTWbp9QNAL?=
 =?us-ascii?Q?9IbUVEW+6+x0BrzGVItC6yay80qz4qIBqw4g5Ca5UWbbxlSAHrgHyeN6Oea2?=
 =?us-ascii?Q?UlbZlfhKS2WIwdsdjIqnegPp/E8fkwvonwKce+FRafT0zGq/wWky+HHjt6/i?=
 =?us-ascii?Q?4uJFNRQHjUujQ/mkD1Rmd5ME/ZpTDTvjohWmS1Y7ohG7LFOdXtPape0UtRIQ?=
 =?us-ascii?Q?+3KUrjt95aC00I1HsD+hzUCKVcTDwyrlMxwdm3h+lX2AV0+ShEyRJWKDUvZ3?=
 =?us-ascii?Q?IKw80x0YQx/vZ+nRluGO/zHsDwWCGY7WMsll/Q8BkPn0RRyGPZwEI2LX87+z?=
 =?us-ascii?Q?O6jfjWUS/eO/U/ZZyLnXhxOcSrC2IiKMk0v+DHAobo/xSCekte9QyY511lFt?=
 =?us-ascii?Q?h0JLA/hlJSoLuuPaLtC4lqQDQ80+0aQFU+Wyb41fkNGpCTM6tiPX1z+wMT8N?=
 =?us-ascii?Q?k3JIRvE3KcBQ/S7AVvUghpZWvDfXPEqInmah10NfYWWX8VepN8EhCJdLfhCI?=
 =?us-ascii?Q?UnbsCGZEqgNAEoNra3sI4wX0oEF3uJH6uk8aw7YD8290KdCC/aB10sO1tWgP?=
 =?us-ascii?Q?zmRA6vcaMw=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4292273-a2fc-4cd3-b8f5-08da25d72d98
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 09:45:34.1557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qt0FVFiysD68plnCZ2Oe1jOKOGy+r/VQU9Ruy/q+Hfq6MdO3dJg3RMTUr9YQfEDyTuh1HzYuGznLjYtImeKQig==
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
 drivers/net/wireless/ath/ath10k/mac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d804e19a742a..c460f6f8d4bb 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4119,11 +4119,10 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		peer = ath10k_peer_find(ar, vdev_id, peer_addr);
 		spin_unlock_bh(&ar->data_lock);
 
-		if (peer)
+		if (peer) {
 			ath10k_warn(ar, "peer %pM on vdev %d already present\n",
 				    peer_addr, vdev_id);
-
-		if (!peer) {
+		} else {
 			ret = ath10k_peer_create(ar, NULL, NULL, vdev_id,
 						 peer_addr,
 						 WMI_PEER_TYPE_DEFAULT);
-- 
2.35.1

