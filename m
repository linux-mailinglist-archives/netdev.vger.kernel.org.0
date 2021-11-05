Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1D3446403
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhKENWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 09:22:00 -0400
Received: from mail-eopbgr1400135.outbound.protection.outlook.com ([40.107.140.135]:40107
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232883AbhKENVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 09:21:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1B/ubheNQTgM86yA0yPI33W5uXX7ik4LBx8TInNR/PCFe8IC2Ad+SipHfKGM9mM0F0wqGimhGgMbXfxG6blfEBtUnYyj+sSe5EeMoBsl/sReyddcD3q0nWbuR+ryj58T0fYj/ZiOlO8pNF3oNEA1YuMgvrfmVOqR/CveIxZg4QExk0A++0/5OzvqgtGQfpjOJI/4jQ8XKdx/mXFW97q2s2/ssbrfJCYKNtXuNP8ZKCG/0OFxsMlpnIbYUiiON22SoeNhWFO0RG1w1bbthKym1FxRa0tddyJ5oc4EmPwLR5JNL79oStNNyz85rv+zHyylUNK/ExR7XKYLOy4uk+sZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7b0Dfcy6LoOScHoU3ZfiVc80vXEFqqb0oWKDo/gT4c=;
 b=D0VTPL7X3vY4Ik0ZvbZMRVMTiUAOVXrgK8vqWcszdu+UpD0+R4kVT3jiRydy8OtV6x59y4LQrRzzfDpOfbxLySzkK+vlNA8rN6JiZdUAIsK4Vf1QdXHp7ZV1i1jFfNuROQ8CxvhwdQN2/zBwyPFwNoQ625maDzMuYWnqC4wqO8C9KeWUsM3Ggd/nQxQ8kEW4UM9BnSKxxV3uvrCAMCrhHFoPskHQaAyOh+Y5i0SnzcR4OWFrmK5plZxsWbsH2R0MM31tGHuCrAhdn3bKV60Q4kQrj9x0JlELOeANJ5IklzOFLzEx2jB5sYNMeKKSlo9YWtCjNpeovnPdk663bpxRjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.ust.hk; dmarc=pass action=none
 header.from=connect.ust.hk; dkim=pass header.d=connect.ust.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.ust.hk;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7b0Dfcy6LoOScHoU3ZfiVc80vXEFqqb0oWKDo/gT4c=;
 b=MpKxV9eg7R1HWO+lppHC54tSmDS6sBnH7EB/8Baf5L5u47ShrD1oTrNYDPO2VBPe4jia2faDcCHUpqUB/EgovDL6U2VjeygAl9p+D+XR+wGzHNkRpa4BDTeWcCHoxsJ4iqgrtluU9IMjiRrojRKf2iez/e/X9h/XzwQbq9eFsIc=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none
 header.from=connect.ust.hk;
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:b7::8) by
 TYAP286MB0428.JPNP286.PROD.OUTLOOK.COM (2603:1096:404:8030::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 5 Nov
 2021 13:19:07 +0000
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::c0af:a534:cead:3a04]) by TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::c0af:a534:cead:3a04%6]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 13:19:07 +0000
From:   Chengfeng Ye <cyeaa@connect.ust.hk>
To:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, wengjianfeng@yulong.com, dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chengfeng Ye <cyeaa@connect.ust.hk>
Subject: [PATCH] nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails
Date:   Fri,  5 Nov 2021 06:18:51 -0700
Message-Id: <20211105131851.30256-1-cyeaa@connect.ust.hk>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK0PR01CA0053.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::17) To TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:b7::8)
MIME-Version: 1.0
Received: from ubuntu.localdomain (175.159.124.155) by HK0PR01CA0053.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 13:19:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 618a8ef9-1876-44c3-6edd-08d9a05ed84a
X-MS-TrafficTypeDiagnostic: TYAP286MB0428:
X-Microsoft-Antispam-PRVS: <TYAP286MB0428EB5E2E29BAB17960556D8A8E9@TYAP286MB0428.JPNP286.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pJq8v+mNfTyKXfpGQC5KwiPGBCCjhpv+wIxLbeU9pZeLmVUAhoOFbNs28SqP1YpPo74ojHg91VRf35ifMwQPoVCeNIhJCCgY2FA6MX4eAqEMKYP8irmW6Z9NMSIhjAXD0jTd8RHn06RBjMDsjBddx9EJxG07LKayRG1ge8ikIFKZ3SOuW0HJZmpWdZvW0uyYRE1ly1sYKMwvOC2hu/SghzZaSB9ardhKvpsiXEKtiIuRpUxctm6oxYLxFlbfwrcHUhzOfmb3IqrkIdw8qBWTTo+4JHDyho7gB2PaJNIBQqLyAg86SBZgcmjOP5Y2i47rLo0uO0Ixlx49anK4wnTSrmlp3NSDHaielXJxmFMv/DirIvis98x9VkEShNtBOq3rH2Gy79fXKxj5AxH8DOMBB90rijb/H6R4u03L8yvnWe4wFULxoqkmrTQNRBeH4f8IPjCvcPAjxwsT7CamIlBD7XlXn9nKyFWGWCR1iHOk6cDpNvuH05WNRqbto5f+g/wGchOzpW/TCIkHjBaP7XfP79iMmj9+0ur8gXyecNB2eibULipMgcp3Ksmf+DfpAkGwzcSXQzzXZzvk7nfzYo1pCvCzIwL4uKJLNMn58HDxE/sndv03frvvZDicH/bn21IFGG5n1iharMYOfhllEvNGVet+Mbx9vGtAntidWiorwUE+MzLXA2lZH1EA0aOTireq3gpgrvd1RY4YXYcaMA/oIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(66476007)(956004)(66556008)(2616005)(498600001)(86362001)(66946007)(4326008)(8676002)(2906002)(186003)(6512007)(6486002)(52116002)(26005)(6666004)(38100700002)(1076003)(107886003)(5660300002)(83380400001)(6506007)(38350700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xZIKJhJVYkNc/urUttSoBmyJ1QCrfi32ZR9Ebqnd5qclKtL0aOSV/ibp12Ez?=
 =?us-ascii?Q?3ONiAjjTP4EMtzZfGl9H9xpmgUcI0TsxFnvOtXAHNH0+AGO+ZJc+yEMDw+4E?=
 =?us-ascii?Q?XPq15Z8C2SxaXjzaW2Qrrr8Xmvehzq5FOmZNoAMpjBPv1PuCygr5eovMXtk4?=
 =?us-ascii?Q?7PJloL9GR5xfB0LZ4dS69onUFTkGQgRMY4XPEzhGbkl2ZW+au4ujxe7ES4fb?=
 =?us-ascii?Q?2owvK3tclBHVysa7SHw5aWco5kRhlbC9Wa/g9PAabDha39lFe80wbW5Grykv?=
 =?us-ascii?Q?SnkXEVc09Bh9Eq6mAde/qP5Lvf/iQstPFbFhMVKUMwU37COSLKX0iFlaY4Xo?=
 =?us-ascii?Q?3kiVwsliSLpAJNXcPJcqLvhyyUtVrObSvScMMj7KroiH3TNaeQqtW1RAIbcg?=
 =?us-ascii?Q?u4xh+yuGA82XXGTmBYR5vANn9M6pUb+MmrB0KZjDDEiiJsCxObdVAeU4uv/h?=
 =?us-ascii?Q?qqd+OQ5R0NkTU2Y9p+rDpY+2FzyCRRhz+VFHCeXr/dk4bslrVdaaOTqYD/bM?=
 =?us-ascii?Q?/gg6T7QL/k7tu9tlMqF7Om1ewnxDlcOb8Tu3LdoVVGwsWS/P6dbyii83s2Kb?=
 =?us-ascii?Q?Z9Sbtbc1TeU+/H6uLjEiXhwmfCrI+DHVwxjPQaNouGVlR0ZyrMHaKL4HbVgu?=
 =?us-ascii?Q?GI/pAhg1JoCA4kPkDcaeDFFoBHrrB5S832/LQQMhovbIr8PEee5SXKXsddXZ?=
 =?us-ascii?Q?UNcfgPDknOcbcC5QgkVnv8FvDZ/QDk9d/uMdGkRHNRR2lZCf76UCl/M9N6NQ?=
 =?us-ascii?Q?mQz8k9YDKn5JElW/jb2H3mFlLQXhkBF/WHI2ace8r16toLAeLqmwUlsJw1M8?=
 =?us-ascii?Q?OyLTfi/ExuWCg9f+JhKmY9DwsCb24N3jV4gP+SdkdEzBmbQQsgsP2ATnE2Wx?=
 =?us-ascii?Q?PEW0pWLT1GjqT85drkzZnJkDxKqp6U6/G5pJiy7wRW6VHN1mMjjFVx4UC4Su?=
 =?us-ascii?Q?xctAzRm85eg5BOmo235jSRTD1tk4ma77siU0v4QN42E4kbKsf+4X0dY+0buK?=
 =?us-ascii?Q?vniv4xLtLE2MSu1ew9ZmI/CcQyjIetbmVUOLmFnd41CLYSR6XtusoqtsVrr3?=
 =?us-ascii?Q?sYD/ATvxaQWUas62jeO2r5oZYeEvETNAkuD79j4YRJpzaNSGqEcMR8uyoesz?=
 =?us-ascii?Q?U3VZdGXDfxUkTxR7YHgrhRD0l8uLrvMRMjBuUhWbh3Y3/OJKcHPf6yds2q4s?=
 =?us-ascii?Q?v7An6QUFH5ZX7fI+d//CX3NVidLF87wrirNydbCKI7va9mCfBjLLWOYS9uVZ?=
 =?us-ascii?Q?bnTA6HusO654/Qg47o9tmcSmEY/bccv8L8lDBpCH8FKXOEONmjazHg6IpvIC?=
 =?us-ascii?Q?PwMzrriAx3x+JlU1FkBltfvjTFqUP8N3YEnqQZcmBXo1BAkM0tIkx7hLK/UI?=
 =?us-ascii?Q?h7VaDai7KWlxqqTJLGUBiWYdr8ALG/DSmhX/k6DCT4kQ6acu292b19yhspO1?=
 =?us-ascii?Q?A2lyGZthS4eDoA187DkFTOMOxbZm6I4132C0ivl/E1zYRQF7wnUTGAqF/lWz?=
 =?us-ascii?Q?95InVvt5YJVPfHUFXWuCxtoOhQgKF7pY/HBvu5DAoHJZ+j5Fk+ltHvJ8mdM/?=
 =?us-ascii?Q?PllvX7FeHvsqvSCl9mpWsD00CLyGaEjt7t8yBMIAjDJw+/3l0fhynsYVPCf9?=
 =?us-ascii?Q?WNY1rcXXfSgzzitn+8qkin0=3D?=
X-OriginatorOrg: connect.ust.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: 618a8ef9-1876-44c3-6edd-08d9a05ed84a
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 13:19:06.8629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6c1d4152-39d0-44ca-88d9-b8d6ddca0708
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbT2sz0FiCu/jXfN8s17rlRdvWgFsrVJbugwNf+/QfbsL5Dv9jFD2pw1WokvG10a6khQzNGxJqQJcX6ZLIxpyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAP286MB0428
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb is already freed by dev_kfree_skb in pn533_fill_fragment_skbs,
but follow error handler branch when pn533_fill_fragment_skbs()
fails, skb is freed again, results in double free issue. Fix this
by not free skb when pn533_fill_fragment_skbs() return value <= 0.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
---
 drivers/nfc/pn533/pn533.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 787bcbd290f7..226ae4357f7f 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2285,8 +2285,10 @@ static int pn533_transceive(struct nfc_dev *nfc_dev,
 		/* jumbo frame ? */
 		if (skb->len > PN533_CMD_DATAEXCH_DATA_MAXLEN) {
 			rc = pn533_fill_fragment_skbs(dev, skb);
-			if (rc <= 0)
-				goto error;
+			if (rc <= 0) {
+				kfree(arg);
+				return rc;
+			}
 
 			skb = skb_dequeue(&dev->fragment_skb);
 			if (!skb) {
@@ -2353,8 +2355,11 @@ static int pn533_tm_send(struct nfc_dev *nfc_dev, struct sk_buff *skb)
 	/* let's split in multiple chunks if size's too big */
 	if (skb->len > PN533_CMD_DATAEXCH_DATA_MAXLEN) {
 		rc = pn533_fill_fragment_skbs(dev, skb);
-		if (rc <= 0)
-			goto error;
+		if (rc <= 0) {
+			if (rc < 0)
+				skb_queue_purge(&dev->fragment_skb);
+			return rc;
+		}
 
 		/* get the first skb */
 		skb = skb_dequeue(&dev->fragment_skb);
-- 
2.17.1

