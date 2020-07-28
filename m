Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C46C231360
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbgG1UAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:42 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:56865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729136AbgG1UAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ig23E4astSC76GYnJfspvhjHvJnoVREGgrCAJOXp2b7QaDMS/kLzv7NA4CN95sl9uf28IkHttDjoTaUTG/0Psm1x4Xl8dYTqJ30ePvGvI50D8IuvFndtD4OICG1lORtHA0/zF7iWEAMibzI7JmHL4OcQmmeydZ39IvUvWwXSsNK4pN7hV0fjYTMfOGv5bvDD619eSsaElFbmsJ++C2nOe3O5pIeZ9XvW6WsIHBrMQ8dM8z/iX2zl/1cdQPivcJFZflCYttWgeBqN6qY5xWF9XeOTcDhTz9pj3gdnDmYyPs2psu1n08bURbRBYc4O1lQ7ess6/u/wRpd5n9uNPG0t9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yh/WC1RGHuRNGr4ByxZYexAoCoMyD3n91nbAh5l8XQA=;
 b=Z7PGnu4jMBem3d/GsDfsN8cdfRkqyVLLazErGIRQXkewbQqfWbt4jvxfaH5XHHM9gXGV208XfcjbdXzX6cs6m7ywQV6BOkMltVCVmV5gZBCTwzkdVMXBZC/yX7ofKdsKozeEhmtq+0GCtfILF4qWNME8kblYvtjHSoK3BEHh6BfSOOqwX2tkjiVgCqEQ/XVHLDp+vflloK6BarIu4lV2mSkWXnX3NqPDOe3f/i9ETMhH0VytQ1qTOVJRAvc50uiqinjzHvWEjZ8uCxBido3cLQhyfwf5nHV+hPx6MM/JY3g7KMMU5OU6NXMkbu+tj2HZkbp+23qjQyiXOhPlJNnM4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yh/WC1RGHuRNGr4ByxZYexAoCoMyD3n91nbAh5l8XQA=;
 b=TOFdfVdTtc3aXRpLRT3fQBMme/tpwp6TFtSvzbmTXLYjmmY6i4F/SIPPi1408lBTksTr3N7jvHr5x9eEoUcO7GvlVjubecGiz9HACydbRbYvvyAdrrDVEBiaQ7kO68JS7LC7ehyTo0A7tC3og6vZio2gQ41AUgnL41pvX74Ma5E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 07/11] net/mlx5: Verify Hardware supports requested ptp function on a given pin
Date:   Tue, 28 Jul 2020 12:59:31 -0700
Message-Id: <20200728195935.155604-8-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 20:00:33 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 607b4577-159c-4128-b77c-08d83330e43e
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB25924A00EA3F4792E3611974BE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWIItAIId51PL33Y9E9BvpiRBqef8m3kHD6yOiWGXIQklzEEqG/GMx+e0Fq9Cp3THEYWTssNBAGLXfZRQ0oV+Am3JfPQng7Lxtad7lruFISLZwM4yip33QlZUK1+hiv3Ej1ZocDNqCiQhNuriyId7ey7pq/cCwbOKiPqQV7UtYs+Lyj6I1+4oPpi6VBvSjIXhry+Sagw68wQmte3+Swj5dDwppk0eyEHw5peBBAG7s300ZlPVbgr7Fp068cg7223cXiaXMlVPtyhlOx08L4YZnmMZncCQ9pw8egSFvO2gr7Mf/OFw24tHVSfMqxucd/C94+D6E4us8YU0qljgsITKyPJzkHQN/jl1vAleSmGy2P1DTopXYZS+MaJcO3Vurbs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(83380400001)(498600001)(6506007)(54906003)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(15650500001)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jBy4zgF3ZkoAfajRGlL9MpHhbJFNQIaU8Jt6/8tvK8KztlS0N9/ODrI83kRLY82WucR6CId1SW+Lbh3H64jvpppmuRCx9tn1rpirZAXzVmcMivTejq2WKAmtbBYkftnZO9isrI/FjrIKzt37TqP/eBwONXDmME0e3NpDVmjxdffQ8Bo7816ppEwSmNg+bofUfkBIM7y8lOQY1Q3Yr4Q2rZWnG2fHM3eYfl31qADp1B0M8eZHmtyMvYzQCCOnGYMmaqVJBwYXcIlQUjLHv2RPYPETCjiIewnK7+IbardoO85VKbjqj3XZ47Mdrq167weLf08tkzhNCmd6OjPvek3q6oPvlG88jJBnjfxH6RHYKdBfZzkEDZkzFPH/Outx4T4h13zB0ePHIQftuECCZC3+Hrxub/Hgu1roWQMWf8Gx+T6GUjBmrhS6oJzJZ+8UzRnP4ebrdy81fJikFsvEtguh10F7+aUrQK74uqok9L1Jhxc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 607b4577-159c-4128-b77c-08d83330e43e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:37.1629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8mQqzSkBLE10NK9WC9QRCQd9Hsr4BeQ75KWXC92Xfik4nc6NBTroCvLMpsVHIvkXBCpIjl6wvBW/gd9lyR+3Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Fix a bug where driver did not verify Hardware pin capabilities for
PTP functions.

Fixes: ee7f12205abc ("net/mlx5e: Implement 1PPS support")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 23 ++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index c6967e1a560b7..284806e331bd8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -408,10 +408,31 @@ static int mlx5_ptp_enable(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+enum {
+	MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_IN = BIT(0),
+	MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_OUT = BIT(1),
+};
+
 static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 			   enum ptp_pin_function func, unsigned int chan)
 {
-	return (func == PTP_PF_PHYSYNC) ? -EOPNOTSUPP : 0;
+	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock,
+						ptp_info);
+
+	switch (func) {
+	case PTP_PF_NONE:
+		return 0;
+	case PTP_PF_EXTTS:
+		return !(clock->pps_info.pin_caps[pin] &
+			 MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_IN);
+	case PTP_PF_PEROUT:
+		return !(clock->pps_info.pin_caps[pin] &
+			 MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_OUT);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return -EOPNOTSUPP;
 }
 
 static const struct ptp_clock_info mlx5_ptp_clock_info = {
-- 
2.26.2

