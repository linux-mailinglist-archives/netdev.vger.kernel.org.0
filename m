Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973CF52355E
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244574AbiEKOZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242913AbiEKOZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:25:37 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2112.outbound.protection.outlook.com [40.107.114.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A23964737;
        Wed, 11 May 2022 07:25:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9ViiWhZzNurn4F5xVSb8ZqJtGU7yP61gwRI/3q6dz5+XI0NwaKFD4/GODNyUcC2Hn4LfYul0yVAp9d2zWOwzSAaSX5PTl90zs3aW5CtYvMYgPB+eA7FVfryDM3hji+pjHtxdTW/R0qSSdJ3psLjBnN7DTuMEgeZe9JsiJPVf8V4HLPPvVpaJNeIdF/y6xEaqkdib1mxNSGK8mmb02gz3GfTEpwpq9Im8Sqf14jGXfTF3i8iEPcsM0FB9GDrLowSSMtUGGpt25f1yVAA82n85brs5nh92h0xF/PHWrAHIvi7yIXdongftEqz7FRFVXPozb/+6VEE/hvua0PrMVDxNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SLGe36sfTPr6X3bEb/UxR3gcJbp6tf3M0YK1pXELk4=;
 b=d/OzeNM5Bez8Sxgw3AXif3ELVzoWWiJ44pup1UBuP2hkkKIzCGu2GaKBSlTj/s32ICUJiHU+AC8lcKp2/gsgko2ymDPrXWLl3D7+/Px7SpGPd0mFqxcNgZqNLBPUPD3hKfqnz1YGSDms27lBxJ/TDkOLmbZhw7DdmN6jASfCVkU1uRNwsUQKLMHt/V1NJp0I9zULoZ4so0JOZdP6adgeuO6ZMPHHoq9CSrmBiX1w2dcbfnzNlZGSrIpXIlBOCI2ucEAPApqo8htDmnv4OpO9JPzNnn4VkkR1Wt3VUtnvKhHvp8sMyc05neQEB3oCZKv7klnQnPoMHOV7ZP8fXGpV1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SLGe36sfTPr6X3bEb/UxR3gcJbp6tf3M0YK1pXELk4=;
 b=i1hrbyA/TiOlBmU/XxfKS3F7NvzC9OeMfcznjD/sxm3JIhHUsZXoo30rjWS5Ig/9Jkf8xXCilhyR0QTSt4NtLQvlINOroBkRTrSmmbCCSOMmznPrv7MgpPSnXBfapx8gphaTFjfC/hrdV5qv7xZUWfgbZvjlqm/f+6qPpQkrk4w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OSAPR01MB4850.jpnprd01.prod.outlook.com (2603:1096:604:69::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Wed, 11 May
 2022 14:25:35 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 14:25:35 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v5 2/3] ptp: ptp_clockmatrix: return -EBUSY if phase pull-in is in progress
Date:   Wed, 11 May 2022 10:25:13 -0400
Message-Id: <1652279114-25939-2-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1652279114-25939-1-git-send-email-min.li.xe@renesas.com>
References: <1652279114-25939-1-git-send-email-min.li.xe@renesas.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0203.namprd03.prod.outlook.com
 (2603:10b6:408:f9::28) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2a24860-0a8f-4e6c-d74e-08da335a1cb6
X-MS-TrafficTypeDiagnostic: OSAPR01MB4850:EE_
X-Microsoft-Antispam-PRVS: <OSAPR01MB4850E0D26BC6463375D79C77BAC89@OSAPR01MB4850.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sL5vMlchj+1dyrhseTj1eFhN/tde1VyBwb85ADCnHM8ozEAWe1Qgoanqyyq0PyzoZvcQvqxX/ShHOjnufyYgPJBCCMZ0hUUSRPmzKRv2ZnwJAEK86BPgjfBVBBaQVhcnL9VP1inn+GluRH3fOG+xtUVuXg/aA7pED4Js32NR6bUoz2AndF+GbJ5UnS3QLLFpWb6DGqZXOt7NKtBAI6cYBaX8nd7i/76VwaiMV4Un2K9lk6CnmuRROnFlXf8queHvzgdBX/0dcz+XA8cVFpCepNUnCGrjfhuTpdtgJbL08iklhi/K6yHzWK9Cqbdmix4FHmna6r9dWGyBSabeD6MClMdA74qHpkAPpZi7Rcm9rn6BXsuuFeaA7dMGSgpYaQXDi3OcnM59Zm/iD9ORXSC/3QN9dHXUS9HE+zwCzQDhBbvugSmFPn/SV7nsR6MlY+9GUmuYDpzLTalX+ylQU4mtfkM6DaGcF6D7ioxN9ZkWtTFiI2apc01vbWRE9GwJj8Xip62bLRvGNcUFz5pkQidTxYhr7u7v+CA7Jy3nLrcWuwxwBRxP6iVExBp2bS9KN1OukO8tw3kPhyNqjHx27pfMLGDJfjmSKBqQa3imxd4mL9/lWmIUo6REHz90m1psdmoKFxVW/RGamU7Pl6h5MtNUvOymT+Byk3lISBkPQIFa+2x4ax+GLoYnmT5Ieg/dkH/eUpQckGHtqBMzmQzuR9G9cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(107886003)(508600001)(6512007)(26005)(6506007)(186003)(52116002)(316002)(86362001)(6666004)(2906002)(5660300002)(83380400001)(36756003)(2616005)(4326008)(8676002)(66476007)(66946007)(66556008)(38100700002)(38350700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Xu9/u4vOOPUiggt18SkO1XHXVvL3HNPXLmWKOC+Xf+entBQh5mnwLFxDCh3?=
 =?us-ascii?Q?B9O5T5VdlYmoy1rz6WUvPW7eXlnKvQJupD8NIcZaLgnT0kU1k0xqSh1o8nMM?=
 =?us-ascii?Q?uln93glC13AJReIerHVulI6qwjqUFWH4+09ZSIoqYvW0oy+thJRDAnZOoX3j?=
 =?us-ascii?Q?fCc8W1a4EBSJtKQo1ykE2FsqnRX/4txRcXHTmjXNra5UwF0+f5J8WnwR1xRi?=
 =?us-ascii?Q?6lizPnTqssIL2xhzGqUOd/bIL0y7/nBSZl8wMtSrZuE+XTHgMIaZn4EzoaIU?=
 =?us-ascii?Q?IDP/R2pHIXR8RDdAAww7/On1wxTIYiS51IWSjBxQF8KkGyXJkh0rYyOqv067?=
 =?us-ascii?Q?JH/3Ziu1I1Dk8Kpg0LrgtRvoQB4tzUDR7KhDgPpzzDdg2b+RUOZFFMpAzV2R?=
 =?us-ascii?Q?ov1SdlhvX6gpwXomBXvIyo3ijYCgNb4EjkbRQZrXhTEScbzgnkhYr8DMo3CJ?=
 =?us-ascii?Q?NQWOvWgGQ155en7Q55t7TzMyshnwDA0Mw4mCwKI81iYgF0IApoJeJCQxizww?=
 =?us-ascii?Q?pPWRhmjcPSBp4bpN/8j0t36tm1JxVIqSzYug0gFN08Yr1OXSegHVTf7WDW63?=
 =?us-ascii?Q?f8/Vmnj3P7cAenY2DUKZ3ZsYRSrbI4mDnEarVNj7Muopq7K1b6vrhL6eoAaV?=
 =?us-ascii?Q?qsuKTCCX55sBkMP206XrdT6g/FGHku2KbhzS/S2Hbpqz3xGnvTQVflrgErHh?=
 =?us-ascii?Q?mSUovOsm64HxcnlvTFPuMaJceNVGw1jBNjD/ANmmP4KPilZr71dVbSFZdyQI?=
 =?us-ascii?Q?TMw0gln4kDubg/vnlTZ+C1fS4RxbEOcc5lm3P5LIPKGEjjKbFLzqyOFSYSe0?=
 =?us-ascii?Q?fwmrUag2Pc3UJyI1HVZCzpS2Pv2EyxLtHRp36Lnp3ntlVBCUcNiwDrvJ/8Hm?=
 =?us-ascii?Q?R4iqRJD8slQf6im/5Lt8Fl09ElBka6ppjJMMiofS4whQz75gs49ATTrH7yoN?=
 =?us-ascii?Q?f26grvwYvgyBafDxvhjCCUF2YIIZgNaBn+gd6BR5P+e4dQRCnbCrkk4oRRb+?=
 =?us-ascii?Q?E7ey1e0UKIwMKYGnQDwSnqvlFMMUS9DKrSTNjDhhcwZU841IV8WRI4nbQYaQ?=
 =?us-ascii?Q?04JVslfi5JwdENLfKmGBEPX/VnLTua5FN/6CapvBO3Enud6SR0D9u+C0XTy6?=
 =?us-ascii?Q?vL3iRjucLnKHvYFxQ1DDQY3u+lPK6jNZdlRoVlnnKCA4tCMEJtpSPNkM5cOY?=
 =?us-ascii?Q?ZQx5yFqoz09ivZsVXd1ePpiq2RKCCQmwga8/rfGkFBqEO9GIemCCdkPoGzdW?=
 =?us-ascii?Q?rwP2tsBmebik/9/w5FHBp/c605CZpxjP02qqvqEm9lTIT6Ldn+HnXgxGRMzY?=
 =?us-ascii?Q?3z/YSYZfkPAmaxWWFkuOysGudfocOzmwclYcuwDEPwvYZiIc7Tg6C3oZ8vSX?=
 =?us-ascii?Q?AbEgmD/Uzn0EeKsOEk90/gqzy3DODEaJJaJmbpI/H9MVFz5yOl7Ob78/FYfp?=
 =?us-ascii?Q?QFVwSu/yzbiY9OUUxYC+GUFd/fXL2DCUIWjyYAnOVPnukY44U+Cs6AoQ800o?=
 =?us-ascii?Q?F4snvgXhcpMzvSfdf8KioPlJQie19gTBpEMkFYtFFQniwluPkqqn4ZFSEuIY?=
 =?us-ascii?Q?Y2R+VskzTlUVM/UPplyDwfwfgiIo+Qi+4iSqrU4AArshY75uRpFrJd9tV9u3?=
 =?us-ascii?Q?JgLRr+cjhuUPosQCNr2iL9krUtLlfexdWkJ4DSnYf1RoQZmCeW3sGBwZiCRI?=
 =?us-ascii?Q?9GEXxkWhNdkIdfTrpo4wsucewzzFVDXGnSmaf0FtHxrOMES38ePuBDS0CPmJ?=
 =?us-ascii?Q?KI9D5IUSlZpfDPOjX3mPdFL3buOVXVU=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a24860-0a8f-4e6c-d74e-08da335a1cb6
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 14:25:35.0351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x9dRXfFFMx0eY5+5Xr/zdfgSEJPHB9JEhANGfCFZG9gMVvtClanljtzS/QKiidaDN1pXpyJSdcoISLc1MycVig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4850
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also removes PEROUT_ENABLE_OUTPUT_MASK

Signed-off-by: Min Li <min.li.xe@renesas.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_clockmatrix.c | 32 ++------------------------------
 drivers/ptp/ptp_clockmatrix.h |  2 --
 2 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index aaff5cd..ea87487 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1363,43 +1363,15 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
 	return idtcm_write(idtcm, (u16)base, OUT_CTRL_1, &val, sizeof(val));
 }
 
-static int idtcm_output_mask_enable(struct idtcm_channel *channel,
-				    bool enable)
-{
-	u16 mask;
-	int err;
-	u8 outn;
-
-	mask = channel->output_mask;
-	outn = 0;
-
-	while (mask) {
-		if (mask & 0x1) {
-			err = idtcm_output_enable(channel, enable, outn);
-			if (err)
-				return err;
-		}
-
-		mask >>= 0x1;
-		outn++;
-	}
-
-	return 0;
-}
-
 static int idtcm_perout_enable(struct idtcm_channel *channel,
 			       struct ptp_perout_request *perout,
 			       bool enable)
 {
 	struct idtcm *idtcm = channel->idtcm;
-	unsigned int flags = perout->flags;
 	struct timespec64 ts = {0, 0};
 	int err;
 
-	if (flags == PEROUT_ENABLE_OUTPUT_MASK)
-		err = idtcm_output_mask_enable(channel, enable);
-	else
-		err = idtcm_output_enable(channel, enable, perout->index);
+	err = idtcm_output_enable(channel, enable, perout->index);
 
 	if (err) {
 		dev_err(idtcm->dev, "Unable to set output enable");
@@ -1903,7 +1875,7 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	int err;
 
 	if (channel->phase_pull_in == true)
-		return 0;
+		return -EBUSY;
 
 	mutex_lock(idtcm->lock);
 
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 4379650..bf1e49409 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -54,8 +54,6 @@
 #define LOCK_TIMEOUT_MS			(2000)
 #define LOCK_POLL_INTERVAL_MS		(10)
 
-#define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
-
 #define IDTCM_MAX_WRITE_COUNT		(512)
 
 #define PHASE_PULL_IN_MAX_PPB		(144000)
-- 
2.7.4

