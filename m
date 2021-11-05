Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61586446436
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbhKENj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 09:39:28 -0400
Received: from mail-eopbgr1410124.outbound.protection.outlook.com ([40.107.141.124]:20805
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229924AbhKENj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 09:39:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIMJ5acKWM0CD4G8UHwJhf3PHVGjHfgS6DBez7axtmJBDJEvMiDF6M44PPfj5hEffJDoy4UErQ7MTt+XKYmBQu7lw/3vGTr5BBKG42Hcj56ADQ5guEVIJVRPv2oFOSHbbBc+d8nUJ8csFYCipIzbB/ccRGIcKmkK512udkWKgpS5LSL/pqKBTabUxKIXmnRZVpYDfWpeGBH8LgbSjEgkEGsG+4yBxYTCU7GbxZ1lvbqgTCcN4iF0gVZgl5lG9UWF4bVSJshrScimL3USSHkkkQURbX8H6ogkWGSt+ZWfYQgc4/4pXJ44imF/6VA3rZ/ZPUp95ssUcRA5tJcf6pmG5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGKUgahTW3p6MwqEuWsq9Oal2MfRlaJcma7S0VYIbdc=;
 b=n7abxIibyQWP7NS7HVX5W/Ti5z6+A2lJsYd2Q7eJY/LaM4yRgdpYanGrCbTttP8nIFYvOqajCj/Mz9swT1bD7o0KZpSHyex2RUfmRvTk1ghypT3Xt2vkbK/KXHbzeEAadAfKGctuT92C1WbPdEhMQ2IyuWXNyDnCF0jj2SH2HHAhY8T2Ss5jjLc3Psxo0v/RQkHuZgTkXMMHHHGnPwC/yE1yrJDKakjRTOCbN+RVmfsmrFSq/b5h2X36neHkHGGToiKWgAGsTFtluwhmgalLMzgJJmr/J7gtvfoGhcblMr78aDzQqh/QGj0Jeycjf4nmrHoiUq7oWVgf9EwjK47tSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.ust.hk; dmarc=pass action=none
 header.from=connect.ust.hk; dkim=pass header.d=connect.ust.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.ust.hk;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGKUgahTW3p6MwqEuWsq9Oal2MfRlaJcma7S0VYIbdc=;
 b=2OqwBkenEYg4sGTTbH5d2esUFqSXrzO8ZdiGwm39BXGEaKCnUcr2tl7f3rVkHAY55/ya04biOoj31RPOAPysKydDGMp9BVA52H5LA3j7NhsCkKqcmqxav+ep7IczwoAP5WpPZ1beV4ry+q7KYM6Q4V8Ydm+VdBPhwP2dnhsN/ac=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none
 header.from=connect.ust.hk;
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:b7::8) by
 TYYP286MB1248.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:d7::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.13; Fri, 5 Nov 2021 13:36:46 +0000
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::c0af:a534:cead:3a04]) by TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::c0af:a534:cead:3a04%6]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 13:36:46 +0000
From:   Chengfeng Ye <cyeaa@connect.ust.hk>
To:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, wengjianfeng@yulong.com, dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chengfeng Ye <cyeaa@connect.ust.hk>
Subject: [PATCH v2] nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails
Date:   Fri,  5 Nov 2021 06:36:36 -0700
Message-Id: <20211105133636.31282-1-cyeaa@connect.ust.hk>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK0PR03CA0098.apcprd03.prod.outlook.com
 (2603:1096:203:b0::14) To TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:b7::8)
MIME-Version: 1.0
Received: from ubuntu.localdomain (175.159.124.155) by HK0PR03CA0098.apcprd03.prod.outlook.com (2603:1096:203:b0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 13:36:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2db9c7db-57fd-4a10-5d26-08d9a0614f6d
X-MS-TrafficTypeDiagnostic: TYYP286MB1248:
X-Microsoft-Antispam-PRVS: <TYYP286MB12481CB7C84ACF5B1F9362218A8E9@TYYP286MB1248.JPNP286.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMMSrdQckqZoHaPF0+2LNMT4VIMm7iJfmInx2ya526dpLiYjwmL5yOZndcHqb5X60lZRKNaiNSzON8O7LxZ91AHdtD80kmftX1Kns4jrDTVKCbqgdQCO5VlJqc73eJOUUfx+yiuVJcsT4gpkwYIIHuDQt3a+Gecohf7dNJXjirbrIkunK+SZTtbKglGvWlk1yCt2I0lNZf8XpCasHlGGHPPBPDE2eVAiQA9s4s+vmXBdy6DSImrMrQpdQIpIUaFhaV1RxTrffTwS69k83/cswU0wsTzg8JiDpWx0eFSImayVJQ0+uWxqAd6kKPw08UnkphS4F3oshRLG/e2weZ0+wfMAX/T9Q2r9G2MAE2+cFe6n3sbEoX4SPc1DKoLRg/zd1fb2vl1Cv6pEsv902gxPSwLrDFfFhZqlt0QMIRPlcYFNz2yFEv1bP2z24JboTy6dzNX/orPxa56VU1ej+hW8G7If20Xc/Nd2tGceOuKr1NqqI545xLiP9Z89KbWJGbMz839clHHgAwVrY6JYiIIZv5XtuHmyPXasiOVye9BhrZ6BfIX9XcVcC/9lHEIjZh4jmQHd1TMm0Zo1JMzc+hoh0LYWlOLUnSbGnjus6H2IY3eHiLp4WMxNvfGvAoOfhGBCDWOPBdCG16ZOrjIyO5oTJnL9TEjuM/hmUeQZnC801nG0l3alZaWX4FAIggOoJMo5evERg8z69Xq9Mw2F55u67Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(38100700002)(38350700002)(66476007)(52116002)(66946007)(66556008)(8936002)(86362001)(36756003)(2616005)(498600001)(83380400001)(5660300002)(956004)(107886003)(2906002)(6486002)(6666004)(186003)(26005)(6512007)(6506007)(1076003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vJsGyPMYb08D9iod+KkbW+f458ubtEzYUDVnc1Am7npq/N3WFQMClh5DEEJQ?=
 =?us-ascii?Q?IED+HVob7Cyki03MPHmaS9Q0y/2KOQ7japsw7iwhQ8SmW5dtfRD83Uj692Yj?=
 =?us-ascii?Q?F2f/WbuzgbfQmIboTGWp6poS3ZrZ85eWL2PBf2mjxY67xj7Fx1dMvNdu+evv?=
 =?us-ascii?Q?U3yxCWoK/DsE1EtzYg3wXpjXZInBoW+7PDAd4aMrJONn/uYHiNdfRLTjtROZ?=
 =?us-ascii?Q?zEIPN6zDLkavs4C0UN9Ok1C1OBExkI7MUBJw9UIUT9PaolZsZIGxeCbAgEXx?=
 =?us-ascii?Q?a0kB4JQSNvhkdBSev7aO8IBBOpJSMhfPUlZQM2xga1PP6xzIMNg9ulhe2hcb?=
 =?us-ascii?Q?YR7KySeNdSWZ5+adN9NmqljqM9PXmkqzHZwIv403nV2UDjPEnzb9lfiMU/bE?=
 =?us-ascii?Q?S+vKaN9ibInsE1XfKikKlqSl4PlNd5SnQjJkAZlrXCLC+PNzwJ7HGoE0Gcqc?=
 =?us-ascii?Q?oUy3jPq5hd4udOyuVD+zpSvECSDaS7WanlFhBINXZjIcMO1tCH+3mnXD2ygH?=
 =?us-ascii?Q?e9vSoVadii6V7dv2vhS66iSxuDg/EBnOoOnLkYgIWJMFWdYRrm7HbPvFj0aF?=
 =?us-ascii?Q?Q69zBzH+2gKn1OV+CwpYjeZ2lo2CvAFhdr14EpiOB533EtUjhOb8lzeFasRU?=
 =?us-ascii?Q?rtkezUpF02h4ZMxoWvmVSjilLTZP9FOmGv6kd5y6JANoyAw+08vWbmPctlMK?=
 =?us-ascii?Q?9VvuR3eJ2uzt1tnt+zsfCRTmg9uKeR8y14T8aF+p9uONjviInEP7W2RWfR5S?=
 =?us-ascii?Q?6kLFsqsFD65Krxlu3X0P3BGY5GBKRBAAdYmiqlLDznn61i/2yvmQmHlJ0SrH?=
 =?us-ascii?Q?k1gABtk3xvzDFc0IXInoAtKUJv8La04AxdjII1yHRoeJwg/6VTSFl8joLGfB?=
 =?us-ascii?Q?02T+SCQUywKtWOpAIDKZMYHEUAmi9trScHh33aVrCkWbgphnH6pdCtExBEym?=
 =?us-ascii?Q?FUKkJkGPtiQgn7PszUdIa0jAYQVzm3P1fiUGBDXMxxrg3mEPw4gQX2KSfs8x?=
 =?us-ascii?Q?qPlTjWUSik4JdXCuGXeG1FO6j4EPmjJjCrZgyNNYgCuxsPBiJEDcHMTuPVLQ?=
 =?us-ascii?Q?Qn69P9uCa3HgmMyi7l8/xh27XaAvFI6jPhK0/aBiHzN14WefhWHExEcyv55y?=
 =?us-ascii?Q?nZlK1/BUzRR0zUtibKaVNoDeAYi6peIMQgTun68H1nQnXvYF1a4I4Hdr4aPU?=
 =?us-ascii?Q?kl198zQNzKA6eUNvSGi1wBIdxObTXPByW+ta4oowpAKgSdlKDUfOrQOwCan1?=
 =?us-ascii?Q?qkxD80IaPb7tnmtsYD2R99/cntgdko2TQoc0KPI1eibwenbbtoPXJICjI1KD?=
 =?us-ascii?Q?KgbgAn9fNf4h+GSI5kLpq8rj0yiI5wJ6jBSxKP+/w4YKjDxVJUbB9q+J+uII?=
 =?us-ascii?Q?XEqt2c9gvaU99oHwasB6oKW2PPLYrOnvonsubgg9qoaADKWTuJD2BFEdTFSm?=
 =?us-ascii?Q?c35F4nvf8GzSWEzmTiHJYW4DPpFsu0QrqSOjiM63z7yw06RIivcyA3Lmyhy2?=
 =?us-ascii?Q?sBJDvql8Zmwe7mIuP9aYM6L7PENmGlCCOip5nuWYtKnN6OdPY3ZpCK/DVOHl?=
 =?us-ascii?Q?dF4ES+9j7OlOZp2+TQNXfCjPVUsJTkrzKiXpngWo7v79cB6DlPlvnkVe3hyw?=
 =?us-ascii?Q?92LmDfhCP3V9OTCyCJZADbM=3D?=
X-OriginatorOrg: connect.ust.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db9c7db-57fd-4a10-5d26-08d9a0614f6d
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 13:36:45.6177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6c1d4152-39d0-44ca-88d9-b8d6ddca0708
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T603hoSy8UBoxjiQg5Xc0Fi1xxKBVc7MN8iYbhCcYQ5H392ZQf5Q+6yasO+VnorEtpcxM/WyLs73YX5Wfh6XtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYP286MB1248
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb is already freed by dev_kfree_skb in pn533_fill_fragment_skbs,
but follow error handler branch when pn533_fill_fragment_skbs()
fails, skb is freed again, results in double free issue. Fix this
by not free skb in error path of pn533_fill_fragment_skbs.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
---
 drivers/nfc/pn533/pn533.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 787bcbd290f7..a491db46e3bd 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2216,7 +2216,7 @@ static int pn533_fill_fragment_skbs(struct pn533 *dev, struct sk_buff *skb)
 		frag = pn533_alloc_skb(dev, frag_size);
 		if (!frag) {
 			skb_queue_purge(&dev->fragment_skb);
-			break;
+			return -ENOMEM;
 		}
 
 		if (!dev->tgt_mode) {
@@ -2285,7 +2285,7 @@ static int pn533_transceive(struct nfc_dev *nfc_dev,
 		/* jumbo frame ? */
 		if (skb->len > PN533_CMD_DATAEXCH_DATA_MAXLEN) {
 			rc = pn533_fill_fragment_skbs(dev, skb);
-			if (rc <= 0)
+			if (rc < 0)
 				goto error;
 
 			skb = skb_dequeue(&dev->fragment_skb);
@@ -2353,7 +2353,7 @@ static int pn533_tm_send(struct nfc_dev *nfc_dev, struct sk_buff *skb)
 	/* let's split in multiple chunks if size's too big */
 	if (skb->len > PN533_CMD_DATAEXCH_DATA_MAXLEN) {
 		rc = pn533_fill_fragment_skbs(dev, skb);
-		if (rc <= 0)
+		if (rc < 0)
 			goto error;
 
 		/* get the first skb */
-- 
2.17.1

