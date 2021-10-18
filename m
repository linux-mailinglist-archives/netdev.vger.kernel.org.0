Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27058431754
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 13:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhJRLdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 07:33:14 -0400
Received: from mail-eopbgr1300127.outbound.protection.outlook.com ([40.107.130.127]:9876
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229491AbhJRLdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 07:33:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUWPYV3BR1m0LHnMPIAlryWU3Ol8ulFCl00P0u3RpbcSyUgVlD0YIsIuKwY/xGVc7oVZlRUpOULc8hyEFquhmQr7Bian7h7BP9s7EsCgbY3guZZsZ9/TE5gV0MPMuKMBMp8ik5fV9dIGNV9gKwahP8csJs4NERaJnxR/MXcl3oBl2/wIeBK2MtWrD89eDVldQIW2t2qXQ5WTgMAUwLO59dkRoz8QaHlI3O9zahV7PcggEQUVLPM6gc8vqa7V/T8piSPf7tqW5UvVXyMkKQddLONNUqmwEqpELY/t4xl8TNT2aP6YR4SAEq2FeuOJKUEu35Vp1JgpTW7SY2BtpGzLYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlhWNaFd6qORY7uFhL5+jFdI7EssNdoefkfCIBPICc4=;
 b=Mpl6F80ktrP83Ep3W7x9XoHvjqh6aAJ/8ZT7L4Myz8CPTESpCerY5g8Kq0DZlGMQwIlBHJAGU83FAYvGPUHDuzEXrpW8orTZFO5MPBToE8ZOl79sRkF9h9vn3teibv1KOpd0XBXwnsJNJk9QONjT62dX+9XCUn4aSbIfo2Wo3YcubJ87uLktr0Jj+xeBeOIZJvs08T+Fi0XXfZQlvvTmghbtOC96l/w3Wram5y+QAQovsKl1v9CGcBsjhjlmlzN1jCJK1Dyw9aCBEsgNFYEGEHzOsl8+e9E7jKNyzppD7q6ljppGWVR3ri9oV4zjrBfM4MlukhtMy/6thsW5pNN9Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlhWNaFd6qORY7uFhL5+jFdI7EssNdoefkfCIBPICc4=;
 b=pDYYgI0BBdxsN+83yW8GsNbovuyA4oBXXBtLvqoWqkEUw/BQ7wjYXes8AWjclyyVAqdFyBMRWN/mdnpl8LeeGqVRTCa3TVKP5jq8cdhSldXV/xikhhI5EdVYjNx96y5ZNhkE14MXSkYp1NrU6DSeh0XGBnyK9+2M/RR9D1JPkBE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB2986.apcprd06.prod.outlook.com (2603:1096:100:2e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 11:30:59 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 11:30:59 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Qing Wang <wangqing@vivo.com>
Subject: [PATCH V2] net: bpf: switch over to memdup_user()
Date:   Mon, 18 Oct 2021 04:30:48 -0700
Message-Id: <1634556651-38702-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0011.apcprd04.prod.outlook.com
 (2603:1096:202:2::21) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (103.220.76.181) by HK2PR0401CA0011.apcprd04.prod.outlook.com (2603:1096:202:2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 11:30:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 235f7320-2875-4233-7138-08d9922ac1d8
X-MS-TrafficTypeDiagnostic: SL2PR06MB2986:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SL2PR06MB29861BB79614A6783F2FAA95BDBC9@SL2PR06MB2986.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2umuLxo0HDiI1jP65GVdxLMg6QX4sNBT7I+/87vndh5JJ0xjUa9s1AeGpvRKuN8J69S7A2oykOdP7PCvZTkjoQ3vR3k/Uu1bZNgfuOiF4EDhvmahyL7qexURRtksVBCAZa086Kdo+JQI7TQ+1mmb1oF7lXQBva/4FVzrr3GH9BF7sLTMUFQYdXrLXfYLFcCMXABpn9673juCKIJSUPOoadN5tRHk/QNVVNj1uSttBmx0trppQttZGlhtHIAcw6bywVW1zHwot8EjW0DM1M1Maa3uVPpDLt9ny7g2iV2ve7E8ODJrJbH9teECtOnOfyntkeNSwEUGRHkTiF0MevmLt5Ju1U5b4Px60EuciyMYK9oF+ej/af/+qo5q1/PFcMX2UZZbQoDRoL/8B6C1T79pICCZ7+QKzkNaFb/w/C2rx/t/OzmITzJVwcWEWiBSErIhOfhoewRDd6LzPkzX9at5ahvw35b86lyEe5ZUE3a4/vW9smDA2UUhyIOUouR5Phrv9CLHwLh5nOoOYJf3Fi92gHYBSdwybVPks/p1+9bHzIBw1nF/brNsGhsjN8rG+8WiREaXIPnA7vjkeKdy83cGT0F0KXAYbQ0Jw9xjyMCVP4LG6twL/y+Xcntivs/Ye/aXSmlKCLy51v7SOPYi+dqkRgJ6tEV7neR/wVct7sw/qJLb2SrefAomV2YLyO4GRF/pGe0yCdLA+MjLi+JaVYXR8geXgf4UsE34qbzrgGcglTY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(2616005)(956004)(107886003)(5660300002)(8676002)(8936002)(83380400001)(26005)(7416002)(86362001)(110136005)(66476007)(921005)(36756003)(4326008)(186003)(66556008)(66946007)(6512007)(6486002)(316002)(38350700002)(508600001)(2906002)(6506007)(52116002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vju7zFr3rcn8+DJvIMk02a2Ruuf91tEZdYqKKUUZ5rB9KBt2PmLdYGGxhXax?=
 =?us-ascii?Q?YNVGb+Fe3fzokn8qTYFygK04Ngfw5MJTPrhUjXw+n+yMVak17GDU5ofvo2a2?=
 =?us-ascii?Q?dS81J+WQ/GhFLXCkpKrGN2h4S/nXR38LjZuXD4BhKalye9NdILc4SyiknBmC?=
 =?us-ascii?Q?gaJYZ/E601JY7R7uZD8+ZJSN8G9HlSWFynJ1GOD8XRfAA6CAisUaQGYTMrAZ?=
 =?us-ascii?Q?B7YpmWOktvdtyATf3z7IC23p0exdcpKftMNYcKpy+3p6d5i5nFPh+17pPfQs?=
 =?us-ascii?Q?VBkbBSVI5lmXzjB1pfdVYbX8BpotccmNTeUwpmprfazPRNpTKIMbg7aERCCJ?=
 =?us-ascii?Q?dzpyRTU8xEf/udMLKdzsVAuQcZAnfyy1t/OB0cJyeR3+YeBIhb7W2XmovC7F?=
 =?us-ascii?Q?YwZ6lsaZEaUHW+7ubgPiaTdyzyveeD+hLv3ZB5oi9clVoAiPB4Df6QY/6s/f?=
 =?us-ascii?Q?PkMqm0Zw8itCeiETOJXh7Z8ZkKrYmOkDVGnQjV94hkf75iVpU/0jX30QgaRx?=
 =?us-ascii?Q?lgLzSha+QAV5rksBkDnWF6RhuTUL1OLIHy3DrEHfNTvOF93dU5EgFNKwjpSU?=
 =?us-ascii?Q?UISWoGbDsFOmuSjVlHZY1iiMMt54u37FTJVdyrGFAJSdjgCvcS6f+KED95xG?=
 =?us-ascii?Q?rgTnK1xCx39Wy7bri27CvglBvnmhK0dK+vg6/J5plVlBCz9q+V05mmO2EmhU?=
 =?us-ascii?Q?ilMKW9Wv8uUjFRRWN0W54ToL3oST431okBan3hoxyaGG2rInZhC6o4s793pl?=
 =?us-ascii?Q?PqhcQsTuJNvfBwsYecD+4ayDW/RDdJ+xQYYCdSInbyhnUUqtty9+id6TRC8X?=
 =?us-ascii?Q?YjvxGJuMlmDgHy2V+ugmXpFV0bGg6z0WFxumP95Wosm9ol/y2jeuieVELBll?=
 =?us-ascii?Q?BqNX9ChkZl4gT7tP56YEJI+WXL4PW8A0GA2IrxpKJj4GNuplhQKNyz0mtNmi?=
 =?us-ascii?Q?bWvD1E3W1Ofud3alC623nPb9ldhEAei3WVvVp0ScYkct5M18e+TKkviCecaj?=
 =?us-ascii?Q?mrq/9WUy26dSrv4XZUPJa6jJK+OUUjeOAFl1IXanpmEyxOO/tN72ZvfUUAIy?=
 =?us-ascii?Q?xF6/X8w+hyWwMuMQwzq0UegmLwEtZRQ5k3mctcMWO1lTxh3jzNEW8kH8QVSp?=
 =?us-ascii?Q?PZxy82adG5gCYkuFgQTjpZjaysOEllAWLL8yylOwywVRsMj8T+euUnqgCZQz?=
 =?us-ascii?Q?Hf//XheXokzXZ7E2tWj3KbIbwVqwOa/sWqhEgIfC4SB34ndzRVJbw8fyLLwQ?=
 =?us-ascii?Q?UG2cOCqKUhh4tvvfxaRaHiY3I14ibF1K7DjFabhhafDLVZZIPgmGiXh+cARq?=
 =?us-ascii?Q?ceUh/cy/sdypr98dCasMZpCt?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 235f7320-2875-4233-7138-08d9922ac1d8
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 11:30:59.0223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wpBYFFVt3oTpFLx7uwjVKm79WlMQgqU1HOU2qPkNQ20DccgLjwchlFSTAGPwu7Bbgoetz2InuofHRQ3/8hSqWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB2986
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the following Coccinelle warning:

net/bpf/test_run.c:361:8-15: WARNING opportunity for memdup_user
net/bpf/test_run.c:1055:8-15: WARNING opportunity for memdup_user

Use memdup_user rather than duplicating its implementation
This is a little bit restricted to reduce false positives

Signed-off-by: Qing Wang <wangqing@vivo.com>
---
 net/bpf/test_run.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 5296087..fbda8f5
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -358,13 +358,9 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 		return -EINVAL;
 
 	if (ctx_size_in) {
-		info.ctx = kzalloc(ctx_size_in, GFP_USER);
-		if (!info.ctx)
-			return -ENOMEM;
-		if (copy_from_user(info.ctx, ctx_in, ctx_size_in)) {
-			err = -EFAULT;
-			goto out;
-		}
+		info.ctx = memdup_user(ctx_in, ctx_size_in);
+		if (IS_ERR(info.ctx))
+			return PTR_ERR(info.ctx);
 	} else {
 		info.ctx = NULL;
 	}
@@ -392,7 +388,6 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 	    copy_to_user(&uattr->test.retval, &info.retval, sizeof(u32)))
 		err = -EFAULT;
 
-out:
 	kfree(info.ctx);
 	return err;
 }
@@ -1052,13 +1047,9 @@ int bpf_prog_test_run_syscall(struct bpf_prog *prog,
 		return -EINVAL;
 
 	if (ctx_size_in) {
-		ctx = kzalloc(ctx_size_in, GFP_USER);
-		if (!ctx)
-			return -ENOMEM;
-		if (copy_from_user(ctx, ctx_in, ctx_size_in)) {
-			err = -EFAULT;
-			goto out;
-		}
+		ctx = memdup_user(ctx_in, ctx_size_in);
+		if (IS_ERR(ctx))
+			return PTR_ERR(ctx);
 	}
 
 	rcu_read_lock_trace();
-- 
2.7.4

