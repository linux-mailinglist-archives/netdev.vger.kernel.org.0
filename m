Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4595230636
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgG1JL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:26 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:63277
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728467AbgG1JLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ireb0wGn6+Ub0gMuNHVf6Lfb5XMzcEPa8uN1E2AxVaSVJAw1QOz3ugQD77hFtnWZGag7CHQiVuF3ws3OegZokZc18DxGKcStAl5Rwwt7GQFNqa/49fsHPmdYVVWUPc/eUTgVYBCUWm6Qi5RSuNf4JFmGumPvLq0Zkum4DOmJKOHauGPqXvmH3GR8uzoQuuBUtmyHlcr404KQLwjatNXfoHEu2RrvamtSBOqqU11ML3UDuK2Vji8bq6YnPRdpORU6lrh35atibPW7iGyaQmmUsYFFm42fWSbhIRjR0YonCyK7J2xeZuB2PagP6xPbLHESTe6sRBosGVrOksgo5lpyMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV289PZZjkgGraaKduzqeziAVHzELgEurwDPXhDJgC0=;
 b=SeCkysU7LYfg10GvpfLb7/WGEFIl7YyizFmxwmZxNM2X/hz8zXf3a19f6g0uH7okzY5LcCXIqmcp3HBNrteOed6D+IYKYAU1zSTl2diXFreDW1TOcS8XdwlAvMeevmcXqPHXLTqjH69Mpbv7/WjR5BPHAHLjnEUtSK+8A7gMGXrWwqxbeC9RkqMUNLiQtB2NHbBPEMqUhMM7YL6mtD6sufiQYN5fdSzJNS+WApyTQUzSoy+OoxN4EG+HgZ9BoPbf2B2lbZzMiZMhgVevGJaqISEllP2iCK+LpHBdrHfnb/zY1l6rTCp/Kv4NvzWoFLovSBmW1ijtUhdjLNKIi2b4+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV289PZZjkgGraaKduzqeziAVHzELgEurwDPXhDJgC0=;
 b=KEuWr47MOrbKWO+N9GVudQgexoNrhIWq5lE1y3xTJYLe2r5itblx7oFFfqDDFmjh/YZF0o8JwS1Y9iep0Y150lwVGTpXsWuDyRnamYZxlIJ0az7shNXP5jm7+KXPYaZSJxhB7cXatipVLk56BcegIZw1Ah0HfMeMahixp7ekiqM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4638.eurprd05.prod.outlook.com (2603:10a6:802:67::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 09:11:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:11:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 07/12] net/mlx5: Fix a bug of using ptp channel index as pin index
Date:   Tue, 28 Jul 2020 02:10:30 -0700
Message-Id: <20200728091035.112067-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728091035.112067-1-saeedm@mellanox.com>
References: <20200728091035.112067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:254::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:11:17 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d16971aa-ddce-48d5-787d-08d832d63021
X-MS-TrafficTypeDiagnostic: VI1PR05MB4638:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB46389B86541D7479C59D8E66BE730@VI1PR05MB4638.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f0fjFhWmTBHG3quYhCO5FbO0ZRQxDjx69F9fFgM5xWU3YUMld0oy56k78VZTZ87QM61WwFn8Ngvb0N1SzHsGYeGSaAclaIGCXjL+ltSVr3R9ctkERkGvKh45RFO5N+8HM0HnmlzQi0/fcyaFt9YpR08YvZiDfl+qy1Q6hAq6rXoTpE2kR8YcmJ1qjQMlWYPl83Hv04zBQpQ/Af/CgVq854dk+o3HEQ5/xFUrukxD30YNeOMKZnHzm0VthX1ZK7Xt1bewWUBN942CVGHl5TH1DbgpadXx6DEqgjvQXpuaqBTbHrnuUf20JD99LnySgOXkz0vEwHESrbMQvSgdxhov201WJR6PwMdAy0BA1ZE3RLTybfE4aGLH4XlS6My9YW37
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(110136005)(52116002)(478600001)(956004)(54906003)(4326008)(8936002)(16526019)(107886003)(2616005)(186003)(6486002)(316002)(8676002)(83380400001)(6506007)(6512007)(86362001)(1076003)(5660300002)(26005)(66946007)(66476007)(66556008)(2906002)(36756003)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WrqSvQ+pYF6fDeEvyBuj0RwQCq9GTvEbnwWqL+Ir/eHO/pZJffQWHf1y3LyTxCQOVeu1IaFiSwsbRSQvD1dHQAHe4GIQ5A7/vl7bG7Wp5JhqDY3wzcT4aqNEp3KrAwx+lBnFcoaArXG7WU3PXTnWJvcYdl7kySNV1OU3AvKLM/lkaha7Qn3BUi+SVhuaQUqosu90F/yr+zt0EkzJ5XJ9aS6g8bdykiiytnmFhaznBXl/i+E6JW4gQSRRJ8O7YRguUId77Jppn2QVzoukQKag3i0YaAOfbDjtArewQC37l6z8nyCAaOE27eLFd6eRExS0sebO13B8ClEbj8Oqk3dE857Ed6dQ1nHPX94YRWw16UfZTRAAnEC5r1LPR0PdLyGKSRQcymOj5AFPTU9yBOONbgRqaHx8syrAO1m+WaiVwyVsZn8IOsQ0CLuTstnrEjf2pVRa7l9cmoJaF7BUwMtno5uA/x/PKvCCFy5N9iEJO9E=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d16971aa-ddce-48d5-787d-08d832d63021
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:11:20.5202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fki0IYjKc7IqCczWuUerughrAmum0Jjau5ehn56bWBO1euRamPAGcQ7+XxCHv8PxGz4SZPrKetIJ/31rOxcVoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4638
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

