Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6821E17EE18
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgCJBnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:23 -0400
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:6053
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726464AbgCJBnW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0zSjaNQCHDJRtCwFTMORPJijrj16CYZ9x+dunearvUNxBxJSrDtb4v65mDRhb2ykHjXcdRTscN2MPV0aL+5oagJgNj4N2bMlFX1XEtXqiYfMIAeeFhwuAxwvakqx4gzJoBB8NCGjdwf2F8Ly5/ySpmA1TBXVlAJ1L5efC+tdvamZHguBy3QOy6ieFiadV/ynj1IuWTdjAEr6QM6cpBgf6kzgTHehZ0Z6UDNF717HlBXHtXfIKGz8RRSfhy/a0S1r3q8z1uR8+4HGcr3gOM5WzavN/pcKXkFev+b4RQPz/mCI3fNkWx+W1ybibi3iJHKko6z6bSaqfC7L8WE2PvOFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTVusWkbAGbqmdTJsHdPbHts0Edvsul2zEDV6U0cgJs=;
 b=BVuGjSTFmlJw7A2fFnW15/pcH/vREeGdHLburhe6FFTMun3VKjueDRKPhg8m4AdrvEWTaHgCE861PjtUhaRIWa5iLfuaNybu/pYIKpZySsNKyjZ8LmoIEmaNiMnkM6ZtrbHOoriSMUkaMOm4SsNt2eC4flD7xgXdwP+CFbGMM6XsvH2GQwzl7VYiFGe4FGdpRVSbF2b4w7R8OpCEmCMoaJvEXEbjsiOyjmkMUKwDcCXKsNruGMg8J6Vi63buv6XyhkLjFyyHwWZ9ZWZ3B6VxM+O93DMJRCc7ID7LEE/ZdrT8sO+CV+Vu9sQn5mHxRPDwvgJNBskht0WV60UZxkWEqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTVusWkbAGbqmdTJsHdPbHts0Edvsul2zEDV6U0cgJs=;
 b=IcCbZraOsPtPYDD5Nw0p9P0JhwWwdnSnu7Uk825HWz+jsIaaILPcj9J0cN05F0RQR5IXe4W5GCaltky3Be9i1x2UIwaV3vNfuH7i96OGRp86j48pyJ1YcDBJYDqxeF9bb6DYQ05UDbM7nFkESFaTCrDMG7kBd+6NqPNsrLBsxZ4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:43:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Majd Dibbiny <majd@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/11] net/mlx5: E-Switch, Use vport metadata matching only when mandatory
Date:   Mon,  9 Mar 2020 18:42:38 -0700
Message-Id: <20200310014246.30830-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310014246.30830-1-saeedm@mellanox.com>
References: <20200310014246.30830-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:08 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8efdafe7-4ead-444f-1fed-08d7c4946381
X-MS-TrafficTypeDiagnostic: VI1PR05MB5533:|VI1PR05MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB55331B3AF0EEEF0CBEFFCD1CBEFF0@VI1PR05MB5533.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(66476007)(16526019)(316002)(1076003)(66946007)(66556008)(8676002)(86362001)(6506007)(478600001)(107886003)(5660300002)(81166006)(81156014)(6486002)(956004)(36756003)(2906002)(6512007)(4326008)(54906003)(8936002)(26005)(2616005)(52116002)(6666004)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VoevtlpzXnD9DE6RLEHu3yhpOf+AEG17AbihAfVDeITG0hkqRdxSGV/gKdUV+1uhuAb7ODCPjDxxSXCFefzWOa9D1iqJWHqV8rFW7+iz+RAMxhEIhw3tTQhz+uTMWKJd9DYSECATZU3bMpg3uquvXOFhQEDzffAeyKNBCIrX0cikMNJUA8q8r8topW1ERBz4btlCdX9vSVM2VT3Y//yTPDFja/kmmVPgxOneW+HeqksaosEvIygzZhBVq+rr/u1YhADjqdDDs9uPMNowviVKLKD9IawCbZclQ20aK9tnnbvNLIBH2DaY14HZ3vFL5M37yKuji1b0VziRWOZQ0bufmQ7JJbD5DVCfdl6G6cuS7P01Wh1BAxhvSfen2FXKdSZ9iXRHx9zcPSo1G5BxGOjgLpWhrLJheH4YXfUAcQ4eqvTLSFd1BHqbE3PC2kedcg2bqAZRrUBnETPgTaVK2b3xbS1oho/8vJjPUD0xV22oksW9NHOzC8gvM+xn+t5Yps9XXAfYWN2UD1wjaWNlpD+bVjBVEw+onko2ezH2YFc74o4=
X-MS-Exchange-AntiSpam-MessageData: PJgHEtH8hzYzRM5VAsGxmspW5EClygq66PBK/b+wVtuYs9ljs9BvTYQEIRzs8300JG1ZMUeYZRG+oCE/S/SYSc2CCqGh5gmVFK3RygkhYrpA0XndG9nbp2Se9GWZpNiSW0kNfi71gzQEK64BYjWoMg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8efdafe7-4ead-444f-1fed-08d7c4946381
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:10.1374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jj3PK9qcz4EeOBjPth/+ye7/KABC693ZXfTq1YE5nPhBdJKkJtd7f7+oahBX253apUJq1LcsethQiUrWHm3p8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Majd Dibbiny <majd@mellanox.com>

Multi-port RoCE mode requires tagging traffic that passes through the
vport.
This matching can cause performance degradation, therefore disable it
and use the legacy matching on vhca_id and source_port when possible.

Fixes: 92ab1eb392c6 ("net/mlx5: E-Switch, Enable vport metadata matching if firmware supports it")
Signed-off-by: Majd Dibbiny <majd@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4b5b6618dff4..bd26a1891b42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2021,6 +2021,18 @@ esw_check_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
 	return true;
 }
 
+static bool
+esw_check_vport_match_metadata_mandatory(const struct mlx5_eswitch *esw)
+{
+	return mlx5_core_mp_enabled(esw->dev);
+}
+
+static bool esw_use_vport_metadata(const struct mlx5_eswitch *esw)
+{
+	return esw_check_vport_match_metadata_mandatory(esw) &&
+	       esw_check_vport_match_metadata_supported(esw);
+}
+
 int
 esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 				     struct mlx5_vport *vport)
@@ -2059,7 +2071,7 @@ static int esw_create_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
 	struct mlx5_vport *vport;
 	int err;
 
-	if (esw_check_vport_match_metadata_supported(esw))
+	if (esw_use_vport_metadata(esw))
 		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
 
 	vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
-- 
2.24.1

