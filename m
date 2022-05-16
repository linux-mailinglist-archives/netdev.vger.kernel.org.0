Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE6528763
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 16:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244242AbiEPOrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 10:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiEPOrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 10:47:35 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2112.outbound.protection.outlook.com [40.107.113.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808E02EA10;
        Mon, 16 May 2022 07:47:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a16PsNYga6uEj8buT+4Wtx0GWx/N8wbOxEmjDaZRvqKPLGKIPWq/QG0tQt5mvXB2tyVoIi9OKudxVLr42OmO43jag3pFba9t9E7Ft5senkesyyXizp9f/ateIFZLhU8LRDKbYfAsZlVF6qph0g+73NMRrE16UndnOVKLXxiM/ILSG1ErMz5CvOn1MLu+dqkMVEadPDMrCqMlDbq7JwOc5qutFEh2XjpXSllB27N6egJ0BrVgKbxQN4ipsyJ3y4N3XNX3WhGEVYch1fnUKc1xTl3u4j8d7b+Z+8I0XDq2IPznJC2lfw/BFwMh2QL2qBQZif1Z1+558Sz54zwbiGJckg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8BA4txbgspzVX2C1LFHavD0Yqk4nFy8nDFEtQw3yyCI=;
 b=H8aovbMWV3wKAely2xsGi9GGy5eZ9w61ppLxaWSTCA7VK7YQH+wsjhMNvhgsGy4fLhfMFf6WakfkyWLF3yxa12StDFRTObUsu7yLxbY/JIr3aTv/nrK3b9AmyYHYlOXFkAHZdnmEs1eYyjmv3+lSAfPk49GKugsSX/0IwGKH7tWHY++WFJId5/9n8V5VtFn2ihggjObrrnz6+m3oLDEX/w3P7C+anqTdYEHkGC539mNGSluhOB0mYoxSSvPCqw+SjJCj4nJwB7PVD/vuzDIV2bmZx8Wc0ENuolI6LJb580f6GopJ2LllleJR0RJc7eFeWY5KN5Mh4oYXxqJtADI+IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BA4txbgspzVX2C1LFHavD0Yqk4nFy8nDFEtQw3yyCI=;
 b=X3jf59TBsXZQwIkpwwoBbtGLadnsHBBYOBawxk7L931jJNGkqbVDdqOBkQoiuKa1qdjqvYdQsVUM+LmfToROCFquEAmzRMlahQXtT/kqr0QitG/E4/eyLHC3LH4Wl/natDe45QanRPLKQbRlwUEQbOHIGTDf7GDdDtSxwlHG2o4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OS3PR01MB8588.jpnprd01.prod.outlook.com (2603:1096:604:19b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Mon, 16 May
 2022 14:47:31 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 14:47:31 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v6 2/2] ptp: ptp_clockmatrix: return -EBUSY if phase pull-in is in progress
Date:   Mon, 16 May 2022 10:47:07 -0400
Message-Id: <1652712427-14703-2-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1652712427-14703-1-git-send-email-min.li.xe@renesas.com>
References: <1652712427-14703-1-git-send-email-min.li.xe@renesas.com>
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::39) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87c1834a-8004-4d93-ea94-08da374b0177
X-MS-TrafficTypeDiagnostic: OS3PR01MB8588:EE_
X-Microsoft-Antispam-PRVS: <OS3PR01MB8588A4F4ABB69E2276B27B4BBACF9@OS3PR01MB8588.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L9smxF3aZQpdOULEqCRAUN2Bx95TiXzmMncJmsvPL+ObiT3rxy7Sqxh+7+L5uPhOt2hs9QHpYS2yO7OLO631FUjBmIarylMvfXirfZSaEuk9idIYLArYXgaXSIv6tJa2FJdi3f2nWH2tujMwWQh6VN88r8BoA0mztIYnp1W7ybZOyGhUAbfrkgTOV3Z4E5oI2j6SWdg4gHt1r24og9UT4cqvKXQATbBOBJHAwFGoZk4Eoxi9CrUvcDrDsMJLijdFgbAZv6eaZ46sWhRwmkhdwZ4XqJWJEjzE84cALFCiQL0jwvjKA0prE8gkyCUj/KIw3neidxth3EKNMppcy/O4EfPaSmt5IOq4NrgfJpWg66+tMyYt2XTT1SjZN8DuPcKVzYgoAxR2+rVnL1SjlijLeCK5v2ZtTz+8HLiih/FYlY0JgUbB1Z3QxOtbekDloqLWCCqaAWVYH+9YwM/lyUx5WpMGvu7a1NfhG0YCrPhshj3jNGLaivF5Fvt5f1T8gZWEPMiWSo/RVNPGm7TRNaEhbnFMMOHo7NiJkSWV6MslyjDSBwvxLPXDVsFM27e57rhvBTlWe+w69yWpTPsdqTFhI2B2Bn2ZViQYUyDXEMl4a7Fx64cGwBgCNRyUfYibRjVMTBaHtXXFTE22OKpxd2fs1G7it+Ow/DLPTqvZp63VLY+hMxDa/pGSaLFr3SDxtNqR7JMdc3z6se10wXXbIKkcng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(107886003)(2616005)(186003)(38350700002)(5660300002)(83380400001)(4326008)(66556008)(66946007)(66476007)(8676002)(36756003)(86362001)(6486002)(316002)(508600001)(38100700002)(52116002)(8936002)(6666004)(6506007)(26005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fUiEJpeWsJyaaCHe5N4LjtE0qBHVJ9SQhJo9BIiDNJHct0USo0vHU7e8j6+r?=
 =?us-ascii?Q?kGbshHTHG3T79/1V6/ZTS/N2Yj8eARbubI47gtEsQ9uPajVwOnJ1FCqAKl7M?=
 =?us-ascii?Q?Qej9AwQb3VWxASYTXJjhbl3yWKMEhMpkCQ7HqnLovm4mYSxxk4CzLDkKqfdm?=
 =?us-ascii?Q?J6Q7V1LoJCPUz2KwXPdhe3H5kXQ8TbfxM9ADoP2zaUrmMSeAdMav54surJkT?=
 =?us-ascii?Q?gJ8uHXP9xRU+3+3cxIkUfbd6SzUT4k7hpKlYWrhs9/d4AaRmr3BwmIEU3IuI?=
 =?us-ascii?Q?OVbuZ7maz++hyAC6lcchUObtieRQrBL0jDL7w8UrWKqvB7+47IF9xowhtkiT?=
 =?us-ascii?Q?HiCJBjr7wXTzSzRlFflXzXy6GJ0H6MT3OwgtCxjO2fVkbU83EMiC+rP02xHB?=
 =?us-ascii?Q?5fhNIk9WAhtxBxhuhGv55mJzW3oLvugA/OPRWwcuxWpvIvZaqleZPgSIwZeQ?=
 =?us-ascii?Q?/Eud+1Zkye90dyxsL/LKsCrHslA3FbHZJyznEowsjlJfbtUmNLXwO1VpDWzA?=
 =?us-ascii?Q?iITahoIADr/fYKP7ukIOTcKthBsFR2/LL1U3hnckISzBZ1wfor17pZKGBVBy?=
 =?us-ascii?Q?9J2Abo4pa/MzrBAi2vb7wX3IOJK7Aa7oVl4SEYhdBDonHy4EvPc/au4XwRy9?=
 =?us-ascii?Q?5BRTUYimIcBxxnh3k8a1LOn1BMZcvRB2yKxVqrh/x88Y+q/pNivgPwk4O/6F?=
 =?us-ascii?Q?xIcxlzH8ul6x3Fpunxg4gDoX5lR8CMxUWWdYZ8X506vD9RFvDPxfC1t8f7Ar?=
 =?us-ascii?Q?3kf8JMuqIpSM2Vk3f88bxWpPoAEQ3DcCGM4s9hT0dhpEJxaJyrQrly6HnWI+?=
 =?us-ascii?Q?M81BmlUF1Jq+g1fFWjSQehYJCVJOGMeMQT08RAfxNc3WTbscLjaIZ0xUiWnN?=
 =?us-ascii?Q?NM9pebNoYdAgacbPhrMY1y41gXmq60UAROdc0hKRhnzcFyAXZgrPdv4YOFo9?=
 =?us-ascii?Q?jNE8GII86sZUv87riMYK2/pv19MBhTbs2BQ89coMSQ+E8OQxClflHYlLR/Gh?=
 =?us-ascii?Q?6+a2mC7G4xV17UfSFcFVouoC8CVYRR0CITiNvLXHyldkHorjl+B+XUOfKg0W?=
 =?us-ascii?Q?LLJJvmOxMvMlhoRALjKyZDcMnkuY2Vu/m5w8ss1R5EUPGLKH4b+rSiJnDxlE?=
 =?us-ascii?Q?BBxFzgDvLYcX7B/DcJHmaFI13nRUIbFdFH1dJI1dGXL7PjD/7zuPlwMcwjJk?=
 =?us-ascii?Q?NGDO8MFubVLzKE3GIaUToLt3XspGTPdwsPDFZCG9HsFU2LK0BVNf92OhIM0x?=
 =?us-ascii?Q?JQZCrGjoKU3QuJZkYI176pIsFdqraSdob41ok0kG101NTRKAO5ZQzxLjlceD?=
 =?us-ascii?Q?o+8+ruPP7d/QHa50yHCJCBMWXZaY/IglMuSa8O8fhpHnT7gyPn6C1/irfY+h?=
 =?us-ascii?Q?wmk0r8ET0/eHCfjF48Lq/FlMshXhxRmaPSZozDLg3AiSvbvAHfLE4HGquU1N?=
 =?us-ascii?Q?vU3HWcwTtNUuX7ZpP1rq3FE22c0uFzYAHsY6dk8+XmT2DwiptI3KZm0arm43?=
 =?us-ascii?Q?PMrh923/bQrmfepgfiNs6yYveR5IY08g2Kpn2wLHwojsgHaMuu0LwD5SIkno?=
 =?us-ascii?Q?LIQxscp7SXaGvrOUkG33+j+n4SB1fIe6BRFHGosWbJHxcK5S+EeK+Y6XjxtK?=
 =?us-ascii?Q?u9eXseNsXLJcNRuMwNgwTP1hmvnQ37/04ff1CEVMmgsXn8VkieywgSeC3xgF?=
 =?us-ascii?Q?cZgiYazqi1StyxXO9uJjg09NUGvpr+KfnH4XpIamJLw2L3YOG1g4RZgSDgMz?=
 =?us-ascii?Q?cILzUpYr1WWjyznMxHoYkPQevxpo2F8=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c1834a-8004-4d93-ea94-08da374b0177
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 14:47:31.5400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWEg8e1e5qmqbUwd4hJgH0w2CZMyy0XM270RxV5noQCqypkpI4JgT+Ad2vsDYmYPMmXCroooAwWeSbZUgIxsfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8588
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 2507576..cb258e1 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1352,43 +1352,15 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
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
@@ -1892,7 +1864,7 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
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

