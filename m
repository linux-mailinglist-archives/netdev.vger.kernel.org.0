Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6604B60B2
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 03:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiBOCDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 21:03:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbiBOCDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 21:03:01 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2100.outbound.protection.outlook.com [40.107.255.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6860BC12C8;
        Mon, 14 Feb 2022 18:02:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bISQYVO5IyIvi4NMf+tDyS+9MbNEjZvuhB0+8jh+BJZEMfUoC3Kti4CWCDG9S0dDrFb1EV3V+e3BZ1ZRdhYvJCiob5XvmS9sFCoqdgY/KL85QgmFiIczTstuLvDR+5Vd3DLtcBQ/ekYH8b/YurdcMlGLM1V8WxdxreCIgNM+pCmVXtow6y+mYmSSFLlqqZxUV2aSP4micVdeqWVwxGnC91ruExI9gtcW9YwVwFc8QHoOwtb3cIWjrahPWx+Nq7a39dIYGrjTi7ewWhs0pmyhmTufflfLQUa+6LqdO+jsGrXf0uvy4yIYRo32ZGWCYWDSJVlXbCeYkefa/m6r+q3S6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbT87ECK3tkcuzgFCVCn/Ps3r1QcJVlwvcsyxI7ipvk=;
 b=Q8KN8jHviDFwyezPGbE0+ISECGWmumYrWMBMAcCHBlSg0kjoLvl6xUI+U4VpSHqZCgV0rLhQgE97Xe8M5HcTGZk7R+g50H427L+BCfJLGFcv+TaYcMDoSdzwSFmElv4Pf8KMQB/wySVnVeyR2f6+xDhSxX9lN7md5HWpSE3wQOq42PTFYYETYq4rl8ObzrSKxgMysedQNXXUJsSz5Z8D/XGGoFavoCLlDcXNNtvXgJWagiMRI4N7Zql4cfsyiPsnjmcbn0e0cJFLjqdnPdtkLr8+lfqvp+TJyJxnmDZr8fk71nHnr/xAtpqpdUkPtoPuiH7oLSOWCYkgEzkf/a4TDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbT87ECK3tkcuzgFCVCn/Ps3r1QcJVlwvcsyxI7ipvk=;
 b=iqLmRPGRT7QUFLFqzMiMy+kR6kQ61FFcrPhlU5O0fghN8JJtJ3fM561ZiysNdFu827EjTlKQhQpohJIc6O0q8Ftyo7i4Um1tKYVPPzRgXXZOIrDzL6elIEF7uJ68L1lRR4ACB1ZF7rpoywga+NANJK2JP2yb9INYiFPiTdxekv8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by TYZPR06MB4510.apcprd06.prod.outlook.com (2603:1096:400:65::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 02:02:25 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::80b4:e787:47a9:41bb]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 02:02:25 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: bluetooth: assign len after null check
Date:   Mon, 14 Feb 2022 18:01:56 -0800
Message-Id: <1644890516-65362-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0008.APCP153.PROD.OUTLOOK.COM (2603:1096::18) To
 SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 098a09ac-385c-4f96-45bf-08d9f027364b
X-MS-TrafficTypeDiagnostic: TYZPR06MB4510:EE_
X-Microsoft-Antispam-PRVS: <TYZPR06MB4510472F108B8CF51C5FC753BD349@TYZPR06MB4510.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:415;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3SyxE8fYne+TdCFSpmSwMsDS0GQoOTp5eXuGdXQJnR1yxPJYpZLl/LG2xEnwEm5Uo2Rux8SGz1+5qrcEouu6mbF1iEWaASf/Po1cFEeYM9SN5F5nXXu3Dtb6LKln0kF14Aqmtrtnezx0q7GV8mJPVcFZPblMd0uksBYf19e5xMrAVPInS5qPr2t8HI0sJjOQABQRrbw+nksGC9Xv7qbnSL/iZYOmkGWVtehy/sr/JWe9tAoVp4djUANoAVE0crmAdc5RNY9+j3Hp1YwipTMgdJeXvInrpJRUl92sFJEGw1aFU1XCqguVR8oXJ3iOV0PE4kfe5ULnRC4gqnLNGiKuMZeFjsShGL1ZwJNlyfT9a4RkA/5YpCzfLL3wXNy2Yw+L3BRaHqCnEIOQf+axE3u5gt5VBVKGCKK4HA8pVhsSwgIOnGvLk54cm8Haex50XM8x/txUz7HcEH8TPdL8XfgVY2hSJz9/cfdfnZ5PAlb1tdy/UBeUFqTgv/Te8XqmVVbfQz9Rw/S7VtRSS0uB6fUUnGwQ3Xvt8Y9xTAPU64rwuzJESCZ0juCAGKAtlH2vgL12grKfzqz59uO/zhLLcRma+8LBHBWYoPEo+GRLKDhXvH5XaJ0Hrg6Lt5irIVB0VO+vx2Jt7jxBjFXJdsGNtWTBBTEt5WhbT7QFYc5ffSwyTjc5fXJdQWzxNsB4HkpJkVvtMcZRl90tqlfIfwcmXfZCIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(86362001)(83380400001)(107886003)(52116002)(186003)(26005)(6512007)(6486002)(2616005)(6666004)(110136005)(4744005)(508600001)(8936002)(66946007)(4326008)(66476007)(66556008)(5660300002)(2906002)(38100700002)(38350700002)(36756003)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ha1/DhTUa4FwpkkKylx23HckJJBNVNy6v8TDBf3y8zwdKFMFmkaMDmp84Gg7?=
 =?us-ascii?Q?IDcSUdGg/zOTmce8elBlmbDNn7/9NymoxGzKcX9EDtBPxPtAT9vbZ5n6EVoj?=
 =?us-ascii?Q?QtJVl+pkxsqfMF9cGkmenl4KvNaS1Zvc4gp9TBXYBh60lXaWZG0QZRMoiVRs?=
 =?us-ascii?Q?18gcmQw1OKDLbjWJET4HDY1gWHIrV868H0xM6u7mW52NYcvYbmOopr/rHYAa?=
 =?us-ascii?Q?LXy7TW15nZGh4PYSFJGbjTO4FZvn3cBKOPXdeRO0y9LOmcTYbJ7EnwvAF/JB?=
 =?us-ascii?Q?YnUv3R/DE/Uk02j8OtDMjvh1bXShP+tWcbHRMuOj/RsO+MaK7Olwg8q8mEQ3?=
 =?us-ascii?Q?N6PMCFKPDDoj3UFlbgnXZEki+T+OFSrQ3wo+0+qmXREdxyKkILRpUoxdCaGu?=
 =?us-ascii?Q?3Snb6cOQFEROXCHP+3mStVgJdM1lazzRdRPElb+79Yotz/vAXc01o6xWeF2d?=
 =?us-ascii?Q?Psx+L/NcLnCm8iKBmKXP0mBdQryBSzzYZu1WgyNFvI7u1GwBvVvHH3kc1hC+?=
 =?us-ascii?Q?qEcH+ZYxNl05xo62cQf4BBCZKvBDqamd3/rxh+AprpZsu5w5PtJxvh3xMYii?=
 =?us-ascii?Q?sc7rEajv4YjDrvb8w4reklQWoDspm978FugzMkYXc1Ok2YJXwhM5kC68r2+U?=
 =?us-ascii?Q?wqC6Dv8PoaJWbhvvjIGvsJx02e+gL6/rZsJcyrkDmhXd3+mzUYx/eV09cDFQ?=
 =?us-ascii?Q?0us+nt38Uv/DbbB4BEjRGAtr9xRULciTZO3pSzFZYZly8M91hRulfHwPTrbL?=
 =?us-ascii?Q?O/04owGoKKuNEibPfcXEcUdE6thJ5J1SPilaZF8u+4Wl6p8eiCzIf5lI+iRp?=
 =?us-ascii?Q?alFufgSu0Xe8LAQlp0umLh6KFBrgP6K+phJWfkgKZqOhRMib0iy1WTVh52dV?=
 =?us-ascii?Q?wHBiwVRkDoTOQLKbFFt9CLm8KaVqw+EQDS4BYtajP9SC2i7UmhxjoI4KcuJY?=
 =?us-ascii?Q?CGsAaIgzt0vRCay8wrOVkqK6skzIkQpNoxXMFBrtjYTsZnJXAGA1x+oOE2hK?=
 =?us-ascii?Q?oDbKaXggVj87ylkjz1jkrMPS5A1TYoTV8Qbb/Mq1/kszlV/K4gycpmI4KSUl?=
 =?us-ascii?Q?ShUJssbKvyl9uLDxdiAnFtkTqNbfKkR0/xrCXsxqHVrpBcuM1co8LXKajk0h?=
 =?us-ascii?Q?sniIKOkWGkDG2ts5M3P7cG05VtY5UVLby+Z9Zf50Ao/1oFEEKA6n8LJuYuUM?=
 =?us-ascii?Q?O435OI9rr3pB8whwBC1zKfSe8PtCYrNQ0wjO/GlJkPXdD5/LzCJeQncXUaTj?=
 =?us-ascii?Q?pz0tMoe2teSVeoPach398nqRaMNis6TOAMCOu3E6eVMi7KEJBy+uFXQ8mxn3?=
 =?us-ascii?Q?egL+47NLnDmTT/y+VBt66RMukE3b95k+xPDXeF3FKwEtY0R8m/wIVp995UM6?=
 =?us-ascii?Q?7O8sGcPuJ4D+U6qfVa305e0CHlXZaVQUsxis5rqu/mhhhNJcNRfGmplkxRDC?=
 =?us-ascii?Q?hqyHFRyhnKvdpeHLKAPyp6cDizOZy3nu7YdFHdZPcBhJ9hKsEFBcXHVobu47?=
 =?us-ascii?Q?+QCIfVXDwMcQjz65qWY0mAw66rEUuFtZR0sm9yFVusHS8M4NqiR53AjPcMZX?=
 =?us-ascii?Q?ZxtjpLrqhvUPqIp2dAQvLJXnHmaVXWoMpJThD4tMWDF6xuofInxWJ+/TucBQ?=
 =?us-ascii?Q?us/7SRqzU6eWGkwpyVHQ4lk=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 098a09ac-385c-4f96-45bf-08d9f027364b
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 02:02:25.7116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u6u+yKqr/IsLbIvSMI3GupLVUFuyVlaq/LjtT6GJzsdajF7DqseAp78rXFgDdJr7DZYB53lnMhWBuzaNmj96vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB4510
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

len should be assigned after a null check

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 net/bluetooth/mgmt_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt_util.c b/net/bluetooth/mgmt_util.c
index edee60b..37eef2c
--- a/net/bluetooth/mgmt_util.c
+++ b/net/bluetooth/mgmt_util.c
@@ -77,11 +77,12 @@ int mgmt_send_event_skb(unsigned short channel, struct sk_buff *skb, int flag,
 {
 	struct hci_dev *hdev;
 	struct mgmt_hdr *hdr;
-	int len = skb->len;
+	int len;
 
 	if (!skb)
 		return -EINVAL;
 
+	len = skb->len;
 	hdev = bt_cb(skb)->mgmt.hdev;
 
 	/* Time stamp */
-- 
2.7.4

