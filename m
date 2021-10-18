Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7464311C0
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 10:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhJRIEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 04:04:32 -0400
Received: from mail-eopbgr1320138.outbound.protection.outlook.com ([40.107.132.138]:34578
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231131AbhJRIEZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 04:04:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GF/Jg0mrfmsGo14C5SQymkvYGuuYfxQWKKdvVh2j6MkxlL3Munj8HvHYMIjvVEFsW2cowdyX4qQBFffDeE3FnEwBqzwd/HmY5AwVyWe8jubhAlxkCETpOC2Mo7klkHDOt/zAleyABdZxnUOMCmzsYOCUeHCXbM0lMhjzsADeu7PiIuVJB7NJSaMRkxc5hsWoLxWSG5FpGF+ZixtcOCpXHaf39n9YA85AZSQL0BaskKtCOb3ReHww5FoXvCRps0W/TQZcXL5oVGtavxJ4ZYqgapbTzQrv1M/yVGUUbO5WXeBczRyRec7MCyRBRGiogXQXoAUH5zSQI4gBoCkJB5oSxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8fFpyHXk9zLsLJjUT7wiSSQFl+XSANp6PXOV0T9cKJ0=;
 b=Rz+gSeunuxFNtBjAf4Zv/ArsHVBka196k373g8YGMBLP3NZtY7a49IEiQBVAC2OCMJZTQvSGPSRA31oReDwhJa6V5EYIvoTwHWgrfPXBSeLAVgczhrky1b1zTZ+Of9NbdxwDs8BzdBNtG667xvE3lCla9s5PJ98DU+IM4OfRoXQK0SPKId5mkx9ZMEA9AGpWvdsDy+jljFa6ui27SBk79PUvRtK064iVnlSYQoIBvzaVA48wFY4u71f2sCgPMtPmULSGK5OuMAPUjYBqrWu6zx9FTvCyxJpgkSSA2GRTa1tBXbFVJy5WbHynamvKL2JKh2Iq9l6QP1J1KX7tNyq3jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fFpyHXk9zLsLJjUT7wiSSQFl+XSANp6PXOV0T9cKJ0=;
 b=KLdeafj8KnZ3dF9DE8UMSMmKJreTjTwRmmnyZlABQpTODDd5OP8HyeUPyodqxD91qnQsGj+TVyCthYL0yrLnd0WWVBvnGC+r7EY51FTFKT+4ceq7rCvrt/Zb+z7LiiDz+04UjZGzYVOp81SPbQvZ6E4X5oeRk4OwJ92NMtR14YA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3161.apcprd06.prod.outlook.com (2603:1096:100:33::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 08:01:47 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 08:01:47 +0000
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
Subject: [PATCH] net: bpf: switch over to memdup_user()
Date:   Mon, 18 Oct 2021 01:01:31 -0700
Message-Id: <1634544092-37014-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0005.apcprd04.prod.outlook.com
 (2603:1096:3:1::15) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (103.220.76.181) by SG2PR0401CA0005.apcprd04.prod.outlook.com (2603:1096:3:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 08:01:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f07d66d8-3320-47c8-9713-08d9920d8880
X-MS-TrafficTypeDiagnostic: SL2PR06MB3161:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SL2PR06MB3161908C7170FF9E94976DF6BDBC9@SL2PR06MB3161.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mWUAii6R+Dl2ZYjOFPSUB9l8050oVLrI6hQMJHkFblKFLJDTB58UTxQzK9jUrgovegTkWMzPmbh7l2zfv6/eNALWvbt9qfXmU6Hlg7Xhmo/H6HG84q+TgGse2PJ4T48VNFci03YTmU8Pry7oJ2v+A00mFOQ3ESos6XFF+q+EP1vYY+3DHy+7F457KEx558hDnuouHoa4/WIDc2LGfLTWS3Jzfoo5sAVYFeWFVr/FBqJtmWEgX2BC7HzbLNr7EHvCLR6AFgqheef0J2cZmaJpu7uJtKxQ7eP9Nj1o51SNYahNVjjk+nqoc00amMANCQK1RwBtntrm1TK1Z+B3tfES7zAQ0Y9LgF40NTg6XcL7dCFhRvW3Le8FQWcv+vRIZOUZsghQac43iZQCG+D7PLNIq8lqqINIhK8ktIJ+yO5YwwTSxzeMIl5p8uqr/QdaO311rRU7vK3Au62W5ZED2ij7WQ5gjRyMG9q7I0drH0oNQ44cR8I07W6SdC7LomV7VPHcsxZ7jSF75HARD9A4Aoosqa3dsynavrC5m/EVHI7d6cPpM+aSKKqDhB37wspf1ew2vPsE93xpVj6ViQdtZqtb5fgmar2iVBdB/f0LnL9K6WM8nZLjfWm9HIRUwfBapyAOEiXCy4dN3/vMOiAIMbZEc9q0s/jw3N+zAhXDPWtKEMFkfYMT3jDff+ze3OcqKefnaYCx/zx3oqQtbrXx73N7VrSsDLNVeXxoSt90rCtriWs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(7416002)(508600001)(66476007)(66556008)(921005)(83380400001)(36756003)(66946007)(6486002)(6512007)(107886003)(26005)(5660300002)(86362001)(956004)(52116002)(186003)(2616005)(6666004)(110136005)(8676002)(316002)(6506007)(4326008)(38100700002)(38350700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oJomrw6TT2UfWWKwMQz99/+Oe8Dr/cBV7YRnaj0UFwuxc40yMbnnJ7badS2m?=
 =?us-ascii?Q?dyilPQs6nbU9bd9Cg0JZqvQJYJBe46Gtwi4xlaZt0o5kqCvB+H6RgyuOYMna?=
 =?us-ascii?Q?5RrlgDlS/uvXWi9w7+bALDBEW/JPCXC8uKyw09Py6qasM7ZiVJBrTPD0vUYu?=
 =?us-ascii?Q?26xwmyzc9elvD3RS/dnzgiHg5fAIeWP8jWotce5sG6O5Ef4ElGgaDuPrGhkM?=
 =?us-ascii?Q?y+LY6RM0eiXoy64CeB5vPVwqY6fXlJJURT1BwVOxD5SgzrKrv3tLYWk65WwH?=
 =?us-ascii?Q?PfwfV1eiOPLkzVdvQ5iATXDs3apOQuyDhuvPbP9ywwvH4LdvfHamuUxgc4SM?=
 =?us-ascii?Q?JMW1km0zZjGeikSwJLamVsBsyqKPe16+vUDXGt26CM3Yq5T9ngYXkOJHiGuc?=
 =?us-ascii?Q?soO5zubOeYyXkSh0YZABcO+Q5EUoVjJm6aUEEjBOaFMExGjT01EuUW1ptGre?=
 =?us-ascii?Q?fY+NimmwCQlcMAb6vP4jQ4zzSLy32+1m+EaeTOhQAROvixHgfnm+laTU/1OH?=
 =?us-ascii?Q?JERphDz2tVuhpr48BAOtxNLBA66kQAdudmAp8VgKW3/X4niHQyaBwOki4Ph9?=
 =?us-ascii?Q?Wsotbr+05ZOxcn77Ka7ZX62sIFQdCEew+EoJdk3IMdzntWB9oNfn6KVk2Fde?=
 =?us-ascii?Q?+TVylJRoeIaqlYM7b7HwevRyvXabfD7rnVO0AH43iLljRmny1khh792LMHnj?=
 =?us-ascii?Q?87/9/nEAYL0D8vY9bjoUVEPMiIEDLuEJ6Ch8bo+FoGzzV7i34rp8U2sgrN7m?=
 =?us-ascii?Q?qHDeM9qPoaN2M+9MCtphEctNMMShJfdCd/btwdqUY6kEweRKd2KuT86y78OW?=
 =?us-ascii?Q?GA9Gjj2fRToTYTbRweMp2u462Nt68fwSm0tk+9NGVdz+Vh1qZq9i6gb0/P15?=
 =?us-ascii?Q?yGrPOPHhzCK+l3W/N/jrvjUva5LiEDyIyV7/Yqy/SNyXY5i72e4+ivnwjTdp?=
 =?us-ascii?Q?lAO+UN4bpBHtF8MN7obPERi2pr3cptd+C5lmlEV9k0E/ARcR/9ntNTvzdUpq?=
 =?us-ascii?Q?HvMfA0KYLCdDrDUANzMG2Bv9/FJlC3/YZ3RSB3MlMzMchVr1doZj7F0UV7m+?=
 =?us-ascii?Q?hXrXSUqUqjPUCNgiJA9A0NWbJXApeBeEu3YkHO5i02InIQISJGg+nVPEDJXn?=
 =?us-ascii?Q?UXGboLwocmVk5k4rjU/EG/OSMEcR0vI1udRQ+hYMPuF0wCFZ6wRZud4e8F5f?=
 =?us-ascii?Q?aw2eQ2reAIKpGcNglHYWVT4wuSFVFfJkkaMueuhrjkDlXXsFuvSVzjMSXlN1?=
 =?us-ascii?Q?KmaQJBM8RVMtuGmJdZdGt6qDGXsp94Kla7IqHOyXFrY60VAKwul1jYj5HU+4?=
 =?us-ascii?Q?5kAnsSLT6HDX7sFkcmuii1P/?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f07d66d8-3320-47c8-9713-08d9920d8880
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 08:01:47.2944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dIF5yRP5Tib877SFg0Xl8bZrVS8EfBszet9rYo0N+inWUwYXdeBg860yJgksFtrwXH7xRQMmASCTfuC5sqNxbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3161
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
+			return ERR_PTR(PTR_ERR(info.ctx));
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
+			return ERR_PTR(PTR_ERR(ctx));
 	}
 
 	rcu_read_lock_trace();
-- 
2.7.4

