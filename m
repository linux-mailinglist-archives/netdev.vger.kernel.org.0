Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D266026175E
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbgIHRaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:30:12 -0400
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:49369
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731598AbgIHQQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 12:16:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HC5lyTmL9lE+SSMppLoR3LMGqm3bIjCHXacd6kafFAGELbIC6e/ge2o+QY3WZ3zl8DZjOfnBZMiPW0PuRP1PjOyxUvtj+hi3JG9F2j7lENzN2zy59va1DZhkIfEOfbGdRa3xIJSYKV+sJ+81DOcmdju8CQ9jMmWLzTDgqMZIO88WZARXgZ3VgNm5OzgMKaQYHQTFUPlmS3F+alMGcw4AZmnBjj5VwH9PyvhLfQSiN4q8ccR1gFINO/524rl5Dm41INfWM5E8DoGBPytrvcWPrufvbRmuw3/HDyAMZBSVRwy53DTtPVYqYmLuWu45mxFXKae9ZsnJffmljrJWZWLPfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSVIp5U1kSAv7+3GQEyfDd9ho/84r7x/HedE7a1jg8U=;
 b=HrxzzzFuMDZDSx5YCuSWXi+PHFQCLRxIkVHckD7/DJYgC8E/7dphrCv2bJguOTU5fSavdBLy38BI9WxeodBdqjX47UZC2FfcfyUrhSQ0WYhf6b5OuIpBMiyseqtuEtvUy7bDa+p9JxM0IY642P8HSihTMPL3FWwneBegqyy10w6MENe4kUGe7xrdAwoAouPYQaJ2KnWTMPPCyON3UcOQpHhj2/+dzOsDpDf1MQokbRwC3gduHKp8HnYoA/rFHMuhAyIN2SFuT9EYKSA/+olzTRFEgI0x1l1pGqZgU4v6n66XDWU3544315bzI2AzdmnEx4JWYhMXzwB4ksnnvAOKNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSVIp5U1kSAv7+3GQEyfDd9ho/84r7x/HedE7a1jg8U=;
 b=WvT/lvy9f6YVa6UQ6tMIfWEgVX9f1WveNcGMGPeor/Nvlo5dGkfgw8ChSyVFoezxF2ktFNFjNXvhKVzrxj/nlEe5MXsFx95iseqXeM29jaCWeI/egTtPoCplLvbS0P+SdpxgW00VIXqIYVeb8Rm/oM50vHw4NDzYAXbXeKBXL64=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4353.eurprd05.prod.outlook.com (2603:10a6:208:67::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Tue, 8 Sep
 2020 14:43:10 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 14:43:10 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next v2 1/6] net/mlx5: E-switch, Read controller number from device
Date:   Tue,  8 Sep 2020 17:42:36 +0300
Message-Id: <20200908144241.21673-2-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908144241.21673-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
 <20200908144241.21673-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:806:6e::25) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SA9PR11CA0020.namprd11.prod.outlook.com (2603:10b6:806:6e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 14:43:08 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 822a48b5-2d6b-46ef-2c24-08d854058192
X-MS-TrafficTypeDiagnostic: AM0PR05MB4353:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB4353652ADD7761BA3812092AD1290@AM0PR05MB4353.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:161;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UCP5cql0prpdd+DOhPcL7cbgg7ENIifPoL6jQHFxc5Vr3YAs6PfHs5DGhuyG3Vaj9KBJVNdpBc3+t1mOwL5J/2LTXmDjQVLBgGJGUWbpGS44LFScSartyAnY2LQgDhUtHrcmz6NWISAjo3yPw5ohm3jjZYZu8qjLfKMjB6xTSytbmzKMukupVKEol70f8EAPerWHLxSHDdTgX1cFvJWjLsL9yCT1H+I2lsbLFOuI9ZV5r43sMiAEi2CmHGJ5zWX7fC7G450Fqk6KDmxVcwidT8Jxr6zVnrb/eqPqkgT9ImN1CSqSbkTEEFm9PlVvz0ja2MD9OY4Ut+XqLxe040gZeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(6666004)(498600001)(26005)(1076003)(6512007)(6506007)(86362001)(4326008)(52116002)(54906003)(5660300002)(2906002)(36756003)(66946007)(8676002)(83380400001)(66556008)(66476007)(956004)(16526019)(8936002)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UczzYlzoke+wYj0qArL5oerz4383Pxs1jgZhmkQ7EOSOwH7CYXXGTLPKRosRt4juib+h+yQOJ9Zcgr+XPfPEAqHuOsJRGigpnVZfoXfOI44KLy52mSKDwu0MgAoiZvGfmGAEH+RyxVuKeo6aLFE0iyFnBHWJkfW+L21uNeU24ZOh+2XIjjXdkaxBbyMk29kMoOhk28IbzDPtvyCrFTxJsH34OnxV5RfYzYbjhXLDu6BvTvcNooLX9WYPY7gMPk5tZCuvcActCDhsx7fd9tVzjwcnHRjQoMua8RSJMaFcvKUntXqu+ijJR/DFqVS9JPxWG4hKDejnjf27vYRIfOqKzGoj7SVR6EV6fJNLiiie+86uOqk9ufoVov5FkccZubhV1rtVnBFsX1dVGgInTSPUcRobfkLSx7FX3tLUN4tRLilxUb66Hth6Zqwu2EweJEtvs9aMk5NcC6vVcs9A+bXa2P8CMURFtHRa3JikauoHq5ZYD/2UzsjsU0ZJDE2emuIhMfUbPGmLWMOYtLsBOPDXFOAIm96c/ZNPOne7TNoMxq+gA7MxsJ3ZEF3GKl9OrypRyb7nczn1jJj58CpHMVbadzN5GQI4GpnaLtHXh7YfuxBxKQlOoo130nc4RyRlimgEK+FL7d3TtnD77xzzAYnXKA==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 822a48b5-2d6b-46ef-2c24-08d854058192
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 14:43:10.0234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZe552WMrhP4aJWnaDyPypgXIB5ugZCsGvS+pei5BJhz0qjTi8uhSuswvATqWpZkqcU3jl3YVX14zS8VUK51rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4353
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

ECPF supports one external host controller. Read controller number
from the device.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
Changelog:
v1->v2:
 - Removed controller number setting invocation as it
   is part of different API
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 22 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 867d8120b8a5..7455fbd21a0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -217,6 +217,7 @@ struct mlx5_esw_offload {
 	atomic64_t num_flows;
 	enum devlink_eswitch_encap_mode encap;
 	struct ida vport_metadata_ida;
+	unsigned int host_number; /* ECPF supports one external host */
 };
 
 /* E-Switch MC FDB table hash node */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d2516922d867..b381cbca5852 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2110,6 +2110,24 @@ int mlx5_esw_funcs_changed_handler(struct notifier_block *nb, unsigned long type
 	return NOTIFY_OK;
 }
 
+static int mlx5_esw_host_number_init(struct mlx5_eswitch *esw)
+{
+	const u32 *query_host_out;
+
+	if (!mlx5_core_is_ecpf_esw_manager(esw->dev))
+		return 0;
+
+	query_host_out = mlx5_esw_query_functions(esw->dev);
+	if (IS_ERR(query_host_out))
+		return PTR_ERR(query_host_out);
+
+	/* Mark non local controller with non zero controller number. */
+	esw->offloads.host_number = MLX5_GET(query_esw_functions_out, query_host_out,
+					     host_params_context.host_number);
+	kvfree(query_host_out);
+	return 0;
+}
+
 int esw_offloads_enable(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
@@ -2124,6 +2142,10 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	mutex_init(&esw->offloads.termtbl_mutex);
 	mlx5_rdma_enable_roce(esw->dev);
 
+	err = mlx5_esw_host_number_init(esw);
+	if (err)
+		goto err_vport_metadata;
+
 	err = esw_set_passing_vport_metadata(esw, true);
 	if (err)
 		goto err_vport_metadata;
-- 
2.26.2

