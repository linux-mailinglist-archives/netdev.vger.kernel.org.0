Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C1223135F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgG1UAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:39 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:56865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728267AbgG1UAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4JatnxAsMiQP1f5BVIRAEL5CWWQevUjt/99dRduwn8JkU/5P139hIrru41QvXj6XqhXDVcFmETVKTNnaG7gyVFDx6hOrEnHdNJxWwS6C9F04+x0vzYbJLItnh3YlwZ9fyQ3WdpVrnzA1w0bmgidZ7LjNVst/b3+y+UnsKNeRvZSdRHNT200dplWV44BndVoT7NEJBXUB/2hJaf5aHd7QUHJqdh5UfiKukSDXKomCWm6NpkborLvhTW6ywUeyTB2lS5mVgvXak/CYKCr21/4Rto/eYcHZM6ecIe5cuAYUNT+t8t3Dit739UQCq3FCMl+HpTNyMeJTXa4VK/r9wV7hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV289PZZjkgGraaKduzqeziAVHzELgEurwDPXhDJgC0=;
 b=mReGalIYUOMPUGG/Qp9rcYGBl3LgSaVX8EK18AZEstOfGADLZdOEWTmVP0Xuq6F2VYPXBY9fXjDn2kaOf7s5oPgGcUfP99f7T8ayVMmPgiXoLLd7twWcLD54ncNC42V2u4z6F6lV5IdLXqH1/XBHQIbIC7W77wk+AqGJfB7Tzag31h3m9W4cRxaPA+X9LWiq5XRIdeKJapf/4xrhv5YG95R7gKGwNGzcmnd/IsOuuzYdLuny7u83AkEJD0UdL7Ov5b8s2jRGEOeuPfwbbTcTK5pAgtDSgSficsmwNMbj806DRqN8ueHx1we7z37jxO7DsilKscx4lY0bqj1L7w5hGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV289PZZjkgGraaKduzqeziAVHzELgEurwDPXhDJgC0=;
 b=kY5mF41Pp2fJ2QY0/+JIztkL0PWvgiw87/DxMtCvk7whFggWj2bP6fyvAPLFLimAdybO/5JcgwU+4/g5lHksLzXMt3lsl8ZvlxsRQwk36/XxQzdFmnzg/p/pMPNENahUtYPW4HG9eUytHtdCvmpJk63DL/ua0/A7R+HrgnUduOw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:32 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 06/11] net/mlx5: Fix a bug of using ptp channel index as pin index
Date:   Tue, 28 Jul 2020 12:59:30 -0700
Message-Id: <20200728195935.155604-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728195935.155604-1-saeedm@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 20:00:30 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 889636f8-5cdd-4965-7690-08d83330e25a
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB25923D37F5691245DA4ABB25BE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8OArsqOZ3Ktw/czevLkKA0oJj9yvHaUsys1mIJ5o6muALSWuQYdQZ0+uUPTJCLqkx65u2+jMBg2Dfcqfz+Of96r2aXRiq8Fw/zbo2HVskhct4H0kYqoFgoCickCuMBcwQ6lzn8+es0oKpFfLWxQhav5AYcJXDhCJJzhQg4r+n53D3jK/GLdtmxO2UqLosW9nB2N/5iOVTNmY6slK4sZjo8MuVhCD/Z9WoKofTsixJOIw1mc26wH8acu883lpsVvAzuWV+qUyRU5YhvJLqD47yxu8RwxZcQJ4tGFeB0/e7hXAp7tV2S34+zEMxWJpvn+lC4gj3mNxfuUbBTOhOVijymgoK+x0GW4SBNgzTNu1FP/Btq8cb/aJXZaOTbPpE/WV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(83380400001)(498600001)(6506007)(54906003)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r+Uj8w9GJT5eV+dui6fxntFr24s0jXJM6OBHAGucq0KWnQhULynbJW9+8RygoPYyjO5KsWxLWmj+P6bSuoXgmQEpobjqxXkyESe5OjPLzjMZ6gyL+jEyrea0tVRD7or+sj9yXMrKj6fAratwLJfEIHdh/jX9loXqQoOie4nyHHInhWlNHVI523nHTWms7KUs9Vxb2YDEqoD62joOlFKEKpd6FwMX0Ot6ngrT0xo0G5IxLXtArushPRXiUyWQ1MiGEXIK2JcXjjQer3QHAwUz4lenVrNB+CtT2jI+MQt8m5q3mFaPTtG3GhOmYUoZrBaJEdvbc6jaw92o3xFxyDjioI03nOjg3NZBelBQF9vLzSxS+gFr+m9ef0ZeQ0TuBNLaMFP/WN55jtFrAXUW8/PUUXGGDlThUP7cpedHjCW22p58NZIQYqJlhN3oV22C32l00rhZ1B0W+ZGc9rPGbnwJxsoxWBp6TqOhcDuT7Al9khI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 889636f8-5cdd-4965-7690-08d83330e25a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:32.7630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6VN38YCpGgC/DPhIesBouexMHvq3VUXlTa2Ltz/A70c4apV5DzTeP6sErZc61ui0XPQSx6znfOICS3yYafjPlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

On PTP mlx5_ptp_enable(on=0) flow, driver mistakenly used channel index
as pin index.

After ptp patch marked in fixes tag was introduced, driver can freely
call ptp_find_pin() as part of the .enable() callback.

Fix driver mlx5_ptp_enable(on=0) flow to always use ptp_find_pin(). With
that, Driver will use the correct pin index in mlx5_ptp_enable(on=0) flow.

In addition, when initializing the pins, always set channel to zero. As
all pins can be attached to all channels, let ptp_set_pinfunc() to move
them between the channels.

For stable branches, this fix to be applied only on kernels that includes
both patches in fixes tag. Otherwise, mlx5_ptp_enable(on=0) will be stuck
on pincfg_mux.

Fixes: 62582a7ee783 ("ptp: Avoid deadlocks in the programmable pin code.")
Fixes: ee7f12205abc ("net/mlx5e: Implement 1PPS support")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index ef0706d15a5b7..c6967e1a560b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -273,17 +273,17 @@ static int mlx5_extts_configure(struct ptp_clock_info *ptp,
 	if (rq->extts.index >= clock->ptp_info.n_pins)
 		return -EINVAL;
 
+	pin = ptp_find_pin(clock->ptp, PTP_PF_EXTTS, rq->extts.index);
+	if (pin < 0)
+		return -EBUSY;
+
 	if (on) {
-		pin = ptp_find_pin(clock->ptp, PTP_PF_EXTTS, rq->extts.index);
-		if (pin < 0)
-			return -EBUSY;
 		pin_mode = MLX5_PIN_MODE_IN;
 		pattern = !!(rq->extts.flags & PTP_FALLING_EDGE);
 		field_select = MLX5_MTPPS_FS_PIN_MODE |
 			       MLX5_MTPPS_FS_PATTERN |
 			       MLX5_MTPPS_FS_ENABLE;
 	} else {
-		pin = rq->extts.index;
 		field_select = MLX5_MTPPS_FS_ENABLE;
 	}
 
@@ -331,12 +331,12 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 	if (rq->perout.index >= clock->ptp_info.n_pins)
 		return -EINVAL;
 
-	if (on) {
-		pin = ptp_find_pin(clock->ptp, PTP_PF_PEROUT,
-				   rq->perout.index);
-		if (pin < 0)
-			return -EBUSY;
+	pin = ptp_find_pin(clock->ptp, PTP_PF_PEROUT,
+			   rq->perout.index);
+	if (pin < 0)
+		return -EBUSY;
 
+	if (on) {
 		pin_mode = MLX5_PIN_MODE_OUT;
 		pattern = MLX5_OUT_PATTERN_PERIODIC;
 		ts.tv_sec = rq->perout.period.sec;
@@ -362,7 +362,6 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 			       MLX5_MTPPS_FS_ENABLE |
 			       MLX5_MTPPS_FS_TIME_STAMP;
 	} else {
-		pin = rq->perout.index;
 		field_select = MLX5_MTPPS_FS_ENABLE;
 	}
 
@@ -452,7 +451,7 @@ static int mlx5_init_pin_config(struct mlx5_clock *clock)
 			 "mlx5_pps%d", i);
 		clock->ptp_info.pin_config[i].index = i;
 		clock->ptp_info.pin_config[i].func = PTP_PF_NONE;
-		clock->ptp_info.pin_config[i].chan = i;
+		clock->ptp_info.pin_config[i].chan = 0;
 	}
 
 	return 0;
-- 
2.26.2

