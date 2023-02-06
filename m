Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA15C68C1E7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjBFPm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjBFPmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:42:08 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAF61817C
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:41:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZgbgmd/ryzAX0IQKRlzy4RdXHZOx4lB/F/jZqe5cJVKGt/Qh+7ZiGOQeaAfHS8SKGBP+0oPPDo/UD9ENoj8G0Ynbe58cIDcs+91sUkCfdiajVYDFuVOTirGGmzXYg3rGk8qIpJiMy76ZS5j/Vpihj2+8ekScKmBMtFRJhMicXpzzhtrLcSBzob/ICwZ51nnokWw9X2ew6+RwR8kIH2L3WOFNkbDxYn3Okc6dLicCFqBmfRBDPQfZ41JBTDL7FSEvi7XrJpYaUtZVueEEy0DFs5DpbHWb33qe5HQhqSXScalIObeSDsgw9ZmkeebHH/m0OK88urkkPLAfnUphMIm+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXNAmxhG2lv5RfmPJrpgwLioy0rKVwPMOBcWzT8exDk=;
 b=nZNHjMB51ABn8stnrasvp6wJEUgcIJSCmwlYYVrWFUwXE8din/R83qGSajNiXLKWPn8rSyfMyDZyTOqqITqW4MDWWHdAN+O7hrbXlVxj55/NlXFsg18gJRwIhyq7JDPO7oSVxGCtEzam/XKMVk/O5evJO4ZEu+cv+lkCwAmq92Du5PW+PSTeAd+zVIsPSCe01cYBi7irdu4E2UPeMrxwEpODKIp/Z5j1LdLFD/gpRVRAJ79joMsnLTeEHCF9b9BY/rbxvZAKDBG4Dm+8pbPfTD8JkZjI18+L1yN5yXIPGJdzo+EGsRxaXXMyBbnQy1mVPDfl7z4SA2iqHmSbbQC0kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXNAmxhG2lv5RfmPJrpgwLioy0rKVwPMOBcWzT8exDk=;
 b=UK9ommvQPw0Os0vYpDvltCMbnVCUVCAAMvm8r8sAkFz0fItfc0TVfW34KWZBopnKdYKJyA1baSK0Ia+p3v/mIY2gKnN9pWsPqzOhA0cCSa7kaK4Dl20RnftGbSsHk/zeyZxIWqUn4uyglyq7EATDJQESZwObNE3Gqv1AM+brLC2Nqq5IGhI0ysrkXVzrzfD1reCm8p6SkgI73jfzjHxzAhsxz5h8NXlK6Cfmz+iHKa/2n8bdwrc0A5gkbnmKfmcjBJQ7M1O117aBMChT6fK3aFvpIZfKjSvrxOkOJBh6aYzficucLEtL+vjFakJ9lidm8o3Ct5BpEouDwnW8k0yUEA==
Received: from BN9PR03CA0508.namprd03.prod.outlook.com (2603:10b6:408:130::33)
 by DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 15:40:05 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::6f) by BN9PR03CA0508.outlook.office365.com
 (2603:10b6:408:130::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 15:40:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.31 via Frontend Transport; Mon, 6 Feb 2023 15:40:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:53 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:50 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Jacob Keller <jacob.e.keller@intel.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Danielle Ratson" <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/6] mlxsw: spectrum_acl_tcam: Make fini symmetric to init
Date:   Mon, 6 Feb 2023 16:39:20 +0100
Message-ID: <07b8fde3de6cf9cab7cc61eb52b7513bb07e7522.1675692666.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675692666.git.petrm@nvidia.com>
References: <cover.1675692666.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT039:EE_|DM6PR12MB4042:EE_
X-MS-Office365-Filtering-Correlation-Id: 13cec487-a84a-46a2-147c-08db08586b13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 04r9MEB7+UIYU6ANq4csKSHtItOArociARVkIIRDSw7czUAHfQ1wxQEFAwY6B05RSalg03Md/1xrPTU0MRnkPSc0H2syAlW3ON4z9duXBFrfL4GcuWHHovemcbi5EfTQ24V5sbTIkpHnYVKbPYUWimrtzo1Y6Ka6A5hcGfveMLH15Cq0vSYK2zDVIGumA1b2MdR6WgwWqkNW+klRjuyXxMZ/n6SGnpz2nXA29u7li30P5F06dcPZwz6uHyMDNZ/yLOrUZpzrHPLIhWUxoOJeLXMQWZrRGDUgm3mEG3BsP37gJgou77hGtgMVE3MmKCH7YjRDszKN1zmN/nDcniCqoI+7pcJODEGSFpNBPIQrBJUfD6bi8RhNSas1BnOARBtdlDUlaH2E0w6b1o3eGAgIeq43WoEoq+kvfMQDRPiiIdC9yaKYDtD9EshwLS8Y6jUU1sbU1mwB8db7LU8V0poUGdvmqn4/+vfoaRvkg+Y565rBETKnn0lOj/etXn2jSiCNHJkOpXX1Bu1nDkasxbkmohla7u3+eWJjXFc+07WO1alnBVef2Om1Kqvjd9R7Tjfn3msYXRHizR9PkAJyhil8bfLhGwbTm8YxhWliwS77aq6SZnlAY5odBrtvu+MCOsEdpgVIcrCMhSOJ77YxpHFRlg+4XGHoLu68mdVxhUm/thauniHKHE87RAyh9lQISD2fpegegF27qIkBlx+8KpFNdA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199018)(36840700001)(40470700004)(46966006)(40460700003)(54906003)(110136005)(316002)(478600001)(7636003)(36756003)(2906002)(82740400003)(86362001)(40480700001)(356005)(82310400005)(2616005)(47076005)(336012)(426003)(83380400001)(6666004)(70206006)(5660300002)(107886003)(4326008)(8676002)(41300700001)(70586007)(8936002)(16526019)(186003)(26005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:40:04.7270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13cec487-a84a-46a2-147c-08db08586b13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Move mutex_destroy() to the end to make the function symmetric with
mlxsw_sp_acl_tcam_init(). No functional changes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 7cbfd34d02de..2445957355cd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -88,10 +88,10 @@ void mlxsw_sp_acl_tcam_fini(struct mlxsw_sp *mlxsw_sp,
 {
 	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
 
-	mutex_destroy(&tcam->lock);
 	ops->fini(mlxsw_sp, tcam->priv);
 	bitmap_free(tcam->used_groups);
 	bitmap_free(tcam->used_regions);
+	mutex_destroy(&tcam->lock);
 }
 
 int mlxsw_sp_acl_tcam_priority_get(struct mlxsw_sp *mlxsw_sp,
-- 
2.39.0

