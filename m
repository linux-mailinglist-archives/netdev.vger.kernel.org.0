Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671BD230634
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgG1JLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:19 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:63277
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728338AbgG1JLS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6J8rMFpIf9pPwKPszBRjrnkv2u0VetifptUhUvZTpFm8gT55Uq3HW9cfyUv3ati+Phn0OVyk2yG0OmHMnvqaJ9mP8VuNsAEJsWvDtMwDzJAQ6fDk6zMin4Y79nIPXzGvZIVk64J23iViTMEfnvp69XZ3z7YguWCj0DzByqhE1hKR+Upa1w95EOGzVrIwV9TRIHUXEu3/tXSisDVA/7H3L/4q3VFL3TE4vRJrhxWDKzZCqNxJuOP8woqOUe+DtYGrsWBvPYKG1QzhCKfQ6Luwlm3gwIeKYaQa+ousP2AAMmG+h8LGUo4FN6aOKmYVKskziztAJ5DCuVsP/TrsrazPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbS4hf242e7gV3+n9hr3DrvbJkJ5Xo4xW1uimBlEXUQ=;
 b=mOhzK++B2TZNvcJOBnNhFjJYDjvmB5+pKncopB+ElEgBzChj3m+xYGhu9lOCOccMvtG9jDSwoSSKlJ/OU4FewLdBxrP1VJACWzoDgBi/0x67qS3xLg1x8qiom0+2CwLTENW6krSJETGaRMhGxcOcJ0rq6yctLSjMS1ZOMrVKLzcffR3j8SYKkv2M9OTuJcOwweh0P5fvZFNrMTnTjFopaDU1rRh0aLGhy2At9yHSKKAHkMBGLvySR0E1HAit8PagnyoQXGar7xBQmA1sEeQ413J+m+J/YiokNMu6Jin+pv3s/yH5Bl15OeT17YyBlBDRtho+ZrVAr0zZSB9aJfiG8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbS4hf242e7gV3+n9hr3DrvbJkJ5Xo4xW1uimBlEXUQ=;
 b=uCLv3lxNastRRx/yeFHsPeaKChoKn5JpDMI/bydwi1RbucFGwuyCdEN+aOysOQVdHMIJke4RVWUhLA8m86MWLNpIhhRiZv9Q82XdaOHLtGbnHLBm3Z1863MN64kw1uQ/x37y/UNw5eWAFimrwkAUFTRV0KPGZrYhGZYYHdQ574Q=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4638.eurprd05.prod.outlook.com (2603:10a6:802:67::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 09:11:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:11:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 05/12] net/mlx5e: Fix error path of device attach
Date:   Tue, 28 Jul 2020 02:10:28 -0700
Message-Id: <20200728091035.112067-6-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:11:09 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f34f4fd9-d2d1-4148-c856-08d832d62c00
X-MS-TrafficTypeDiagnostic: VI1PR05MB4638:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4638F7044C923CBE8968AD7ABE730@VI1PR05MB4638.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tUjmXN9bxFaHG/tYjvP8GlRgC1WxULnm8jyfmtJ/AgH1A2zRXX05WzL6Wgmf2aVNx8GMwNjRcK6pWsCnZfXAh4ewWR481aQC5cBFFOyreZ1T/+XQLg3a6S6wq45zen+9wXTofLUU9PRqkN70KtsVd7ZoNDl2VU/aZzL8ug9KeG2DObaSjUd0YPICD7ZRxWXytKhGnmqK7KHmD83JNSSLZIKjTTbj6dLvi8N/z6JpzpJa0sTgaDR/tVPDLPfY1cvEqOuJDQ1UZPlN8z0k3G4qToW3MB8nP5nNC9Uny5XcHzqlPgb2/LCsoU4gildac5TkONIKiF0ga8Ru1Q3MM5LSVZ1Ui0c0HCQcbHPBXycch9TGFYketcpAcVmVSbp2CWLd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(110136005)(52116002)(478600001)(956004)(54906003)(4326008)(8936002)(16526019)(107886003)(2616005)(186003)(6486002)(316002)(8676002)(83380400001)(6506007)(6512007)(86362001)(1076003)(5660300002)(26005)(66946007)(66476007)(66556008)(2906002)(36756003)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: D6CrSvFSuXql3c8wlXqccw3rYYTbU50WZEdsm/VrOV69bgvVL8vzkiuGW+4wZMFD99J8WC/WIaUF2s+Xn1jFZTHRFfyxh4EnteYwoYsS646J8J5NHpMJjzj9uBde2N3vo92z4GPTud+Xi0m0Zld+zE5ZP5l5j3mGYnj/hKUoljEJwLsCDrpDMquGpV/PdvbvQCVjNQ8iMQqm+NIz18+PTQ21rrBnHMkfCU5v///h46IDRjJKrXBRMWJUWapGS9qliHml8U3bln9gNMgoQSbcaK8h+3oIxaTKnviKJwe8OV4bQW2BWIVYN4KoedR9jYuu3OWUKjxhmp2eIwxr8R9UPStvCBmJciENCIbZpeXJbCmsbCivQlOX0eDPxoVcozjfXSa1bGPW1JH40RKp5F7n5+wlVOFvwetQI/9JqzrOU/VDXJTZbDbac8/vzSBkIOq0lSEoBLU0vDgmwT/Jm86rNJ1Rxx7pv+wn7i4f/fMAdDk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f34f4fd9-d2d1-4148-c856-08d832d62c00
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:11:12.0360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wRnxG/yjgf/4sToITLr0I/2VqBuiGczojfILp/bsXQNoZpCKtLHop5uZiyslk0/i8DOaSkx59oMCOvxsjlnL6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

On failure to attach the netdev, fix the rollback by re-setting the
device's state back to MLX5E_STATE_DESTROYING.

Failing to attach doesn't stop statistics polling via .ndo_get_stats64.
In this case, although the device is not attached, it falsely continues
to query the firmware for counters. Setting the device's state back to
MLX5E_STATE_DESTROYING prevents the firmware counters query.

Fixes: 26e59d8077a3 ("net/mlx5e: Implement mlx5e interface attach/detach callbacks")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 081f15074cac4..31f9ecae98df9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5390,6 +5390,8 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	profile->cleanup_tx(priv);
 
 out:
+	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
+	cancel_work_sync(&priv->update_stats_work);
 	return err;
 }
 
-- 
2.26.2

