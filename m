Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96E45296DA
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbiEQBl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiEQBlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:41:51 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2106.outbound.protection.outlook.com [40.107.215.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF6C3A5C5;
        Mon, 16 May 2022 18:41:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDe4lMP7XSJQcsekrTaMf/j80C4KPsWDmcG12lPGxHp0bS6mtpAFLihzjy2O1DAi0lWhmAJQxLtIGBuh926XxD+zV0OGXTIw5n9e7Z5f7+KrwI0vWa6vz1HuDl7ewvdmq1FRKPQIrB2y6GjmHi45ghV7xcbSK0ZhkBp7/lwO0nituSRfHhJSSSdl02jc3qc9btfOULHg2BLDmy5TLkAhJpoGmdsMCroLLcBHctVas9A8qyR51mbyinKJ9+WTGGExXWkZeFZEnnsbRjgU3rk+9snWYPwa5mWms+HXCmgN/SGr4GcNDiiKLHwiOTMMtY9PZeDQM5v41RY+/KKw5nGrWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AObHoiBij1efeldOrZmwrrRrewwMjCsskswTDFEPoPY=;
 b=Fh1M7+LST1nsds8EM3AodaaVYuhz0VF+Lq4vh2L5VHJdk5e+iRmgImgBghdD9QM8qSXzZVeWVqrUW/tU37+kfugFgZd1ku69pRdC8pejrjbAGb5vX4Zgq55aevOQd3o74SO+LDQxYYu8nUUeYVEv3kRx6AUjpx2sXTDN7gPUL2BrnvDxd4Ey4e5lXL3GIEIhQFs4+HQ+S7hxxxdwk+4UW730PIY38VFZqC1YcsG94hpT/Ij3rlOvN5BWLGdFXD2EqF+DoT45bP//pBSNlz9Jr3cb7mGT+Cw4/rr4+Li7Zo0QY9kUIIC8tU8Ef3QDIMRoZd5Gd459Og37cRd2rjJmbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AObHoiBij1efeldOrZmwrrRrewwMjCsskswTDFEPoPY=;
 b=WhBpecQ1SYrTGQ6CncqGhbwl15xo0pEqapttPntDr4tFp7fCPpT8hs8HgGs1j2ebFIPPgJ8wdzc3p12pQjJpsVg0JyyqqgjSGELk+M1s1GnOA/crL9YaGrfw1uhAWGx48EV4sN18EAfq2mmPi/Q1MkRldFHrSezS4M6w5SXcU9U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com (2603:1096:301:37::11)
 by TYZPR06MB5226.apcprd06.prod.outlook.com (2603:1096:400:1fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 01:41:46 +0000
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::4dea:1528:e16a:bad4]) by PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::4dea:1528:e16a:bad4%7]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 01:41:46 +0000
From:   Bernard Zhao <bernard@vivo.com>
To:     Solomon Peachy <pizza@shaftnet.org>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zhaojunkui2008@126.com, Bernard Zhao <bernard@vivo.com>
Subject: [PATCH] st/cw1200: cleanup the code a bit
Date:   Mon, 16 May 2022 18:41:36 -0700
Message-Id: <20220517014136.410450-1-bernard@vivo.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0009.apcprd06.prod.outlook.com
 (2603:1096:202:2e::21) To PSAPR06MB4021.apcprd06.prod.outlook.com
 (2603:1096:301:37::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14b9c852-b497-4dce-2e23-08da37a666e8
X-MS-TrafficTypeDiagnostic: TYZPR06MB5226:EE_
X-Microsoft-Antispam-PRVS: <TYZPR06MB522635700247820EB812AFC7DFCE9@TYZPR06MB5226.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: djVGK34mXYfLsuxNGjTCeSuTdT/A0AbhZzQJ6xOy0WHl2cuIOtEFXpy+o7QgBrG2PE+S7kTZQAl0SJSftzReULcTBUGPE7X+vihcP+11HbaSTOh+ooAoyvw0n9a6DtaO9L4Vtjbvf/isFTXVq91TC1jnHS8eii8JunFE4LXjhJ99WCjkBSl2jjvdJaiMGxScPoXedwjfzpCZjUdIdg6wo9gUbIoRwmCBi+c30nH2mX5fhoYXhwPcP9sG3FY574sZYv37PmtedWCIb1carkxlTujnP4c/c2/Vrb56rfcOSYucmEyfh8fcgL81nmCn0+Ql0Vpobv1AQHi1Qm2ilHn8ub9XjoXwdvbEVNt9Y7tntLfILdqoUdcRhxe1a/w503rxKvh1NWVx2oez+VgfrLBPmIobiV3K1nX2TjCF1CndIqWRP/6X7OMoryhRvxPFypKNHjh/PE+iFPBUP3k1/WMgpPQmPdAmWHvSpU6E6rlxxGIfM5af8nKNvNn/FyeALcwK2NXFXr7H6OInf6F6eA3okOLjqcpYXAlqAbqpg2FkS87Wq88iuU/Ugo9cB3PypcaFeassa1rKgX18oBoHkmRt62YQGoLJQ8U7rjlrUfWZnCw4W/XfNR/5Xkr7+qKOZoLlKrf5lBJRoIEs3GBUE8EfWhJqxpghzkZocVXLhrJzAZe4/h3D5frwtegm+yqGQqpX/4QcnuDJ+FubgNPyrt9gJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4021.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(8936002)(2616005)(83380400001)(6486002)(52116002)(5660300002)(36756003)(26005)(2906002)(107886003)(1076003)(86362001)(4744005)(6666004)(6512007)(186003)(110136005)(316002)(38350700002)(6506007)(38100700002)(66946007)(66476007)(66556008)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6FUS4uM49XV23j2es93ACtc5JVrdEx2euEvVitnSHQEcy8l2b36axCWpHQiD?=
 =?us-ascii?Q?u8epFk6JmB/bctD8zbnW+SBKsgJcECjqF/zdLbYv5Kkh2h1rxPFx+9Y9NwjL?=
 =?us-ascii?Q?KXP1e1WgArywv3aL5RFQ0U1oLDPdULi6ilVI/uoCky0q0E4kRMG+LqqLCJE8?=
 =?us-ascii?Q?3X81QoYLR7zQV1lgRyPaAyIIeHlbnoFogvKprU5jIW0G9UM9G5jN3FxwSt6p?=
 =?us-ascii?Q?WcSMNttpFJnZEvY115OhmRVr4IDcT/BRa6vido2ZeIN1/GhadErRwAwQaOwz?=
 =?us-ascii?Q?vw49/PO/Tb7yVb+ZADC4zS3JngLf1OPtbh13Wa3+DjcIhRkyaTC9mN7I0cW7?=
 =?us-ascii?Q?j1PepTbnkkC0N99MwDfaiKK/EmhzpwajU9ofML0FjXNZEjkMwngBrXjXqyAm?=
 =?us-ascii?Q?VLQ3bpqhXdjkDKQ+BU2ZP6QuBPRRXqqaqrJ2SQi7O/unw4hcZ/BZEgHlOrcz?=
 =?us-ascii?Q?iU+jP5FQazEL5R5q9fT8wJN3E+1Ed0i3UwNPQrYCpa1+ZCoRequfTGDy82lD?=
 =?us-ascii?Q?TWamBeEOcDia7rtqOS6fj9RWZ6CS/ET7aoKS1P6Rkuz334XZTEw6fvJnMLQz?=
 =?us-ascii?Q?5ojQ994DEOjDxrS7K8NfMyJLGjqc0jpEHO8/a9rEgigny0kN1c9yQ/ClRiQB?=
 =?us-ascii?Q?9QSEB3QHe3wsBCnbqU7qFaOYZWM/2uDL2m/bHxAr5sM4KyOgMvlDAXBhgD0D?=
 =?us-ascii?Q?JgJhw9fitmFfmwHojt9oUlbkj9N1kmJUYKHIzjUUg17dWOmbwR+YQR4wrQPB?=
 =?us-ascii?Q?X4EVnNHsnb3C5Zw9SOdiK3rXTq6tRsUpVyH/XdnVQzRggtLu7YLjvrGzmOq+?=
 =?us-ascii?Q?FRKm8QxsBaGYSZi4tY3XXpK7TEnByWgdGujd3xm0hUnRzSykn0+JpEeALfsd?=
 =?us-ascii?Q?oPYJMz32CB67dHJUV7o+ZgMYz0mid3mR+RdAgQddKPkqWu3XQPrWSFPzXrp2?=
 =?us-ascii?Q?zNOAFwWnsn9I32COsrNTvQboZ+bc9sySaKANh4tgP3PcvfFwLDm9QsQVlyiJ?=
 =?us-ascii?Q?Ai0Qo8eEoWlEdIN+JKeDs4pxzYcrS1C9vjgVc9KhJ1ewZJZ6rGuOp/NqWScS?=
 =?us-ascii?Q?+/ac/jTVy+hp/CI76UxJQHhRmFddqwYQ1UHx6RZD4Z1sv9W8cw11WLwf32Rp?=
 =?us-ascii?Q?/o5fsfICAFGNgCaLJr1/uH8wLSGzXFKHpPWRk70h6orQTttoES2Zn8s2nVlk?=
 =?us-ascii?Q?N/50qSJRCDI+kL6xWOqSg9fXe5GHgRLqKMpvKD5l9KSzksZoC2eVte6hHfej?=
 =?us-ascii?Q?JjVnstH2OsytPaz901ebzYLDNI6E51xsiF+jCPYEg9Y8iadAiWuCW5nkZrCk?=
 =?us-ascii?Q?69Wy7R4AgbGmP0FvXS0oZOwISlGEi5Iva0ZUBM+uqAPfi1P1zHlRrASCGNML?=
 =?us-ascii?Q?qp/NRedeDV6oVyRuTAwb8FcF2EslHpPcwWonTp916gCB/LNb+LS3ZKtWFGDq?=
 =?us-ascii?Q?UJHF2VQyBxnABkOUY8EVHfRYEX9wWm07vdqF+/HQa2Cxv0+XzcC29DrcVdj3?=
 =?us-ascii?Q?Bu0miLG/lCGfsBU9o8WfXF0j0ppIHTiF0W7/m/3DaRyLomNlZZhMB0HbHXmJ?=
 =?us-ascii?Q?3vYd471t3HAg5Kf5RdtWYkSJWwrkmjzrxs3fM3bF/SjzqhND97MnyGYwWsNC?=
 =?us-ascii?Q?uv/vrbDpptwrKaEhooceXVqh5svT8JlMkJY//dnh1vi2ixtuv20WmEyFEqaD?=
 =?us-ascii?Q?ly1pSuJaS2XfaNo7rn5TbfpFpkxBCV9fMxzy/yg4/Kj6EL7t+Riwc1cCIorj?=
 =?us-ascii?Q?3wiAk3rZyw=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b9c852-b497-4dce-2e23-08da37a666e8
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4021.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 01:41:45.9749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Zwet0jFGlftd8v9LMCtgZMbprxJbAVNdJq2PeKbjKiFAeRqK6uSmfUgXCpmjSSMiJRcNsNFsIKfSHCqMggjVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5226
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete if NULL check before dev_kfree_skb call.
This change is to cleanup the code a bit.

Signed-off-by: Bernard Zhao <bernard@vivo.com>
---
 drivers/net/wireless/st/cw1200/bh.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/bh.c b/drivers/net/wireless/st/cw1200/bh.c
index 10e019cddcc6..3b4ded2ac801 100644
--- a/drivers/net/wireless/st/cw1200/bh.c
+++ b/drivers/net/wireless/st/cw1200/bh.c
@@ -327,18 +327,12 @@ static int cw1200_bh_rx_helper(struct cw1200_common *priv,
 	if (WARN_ON(wsm_handle_rx(priv, wsm_id, wsm, &skb_rx)))
 		goto err;
 
-	if (skb_rx) {
-		dev_kfree_skb(skb_rx);
-		skb_rx = NULL;
-	}
+	dev_kfree_skb(skb_rx);
 
 	return 0;
 
 err:
-	if (skb_rx) {
-		dev_kfree_skb(skb_rx);
-		skb_rx = NULL;
-	}
+	dev_kfree_skb(skb_rx);
 	return -1;
 }
 
-- 
2.33.1

