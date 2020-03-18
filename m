Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED57D189421
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgCRCsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:24 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20090
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726616AbgCRCsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBmXIAk32XP4TjTQIDEDO/UNHFAgcKr3b50e9C37EXCOmaE2PqNapaQSYFP164yRPUC9bbI8vpjPXv2AM1IyKSC3gkL6goS3q26KZoCaIjyVjCkeAKA5kWI8ajKdFLtCdfRGqftTbmeITgHEeqaCJWIw0xYZMrw2k5BLxsqg0DZRiDOVEJSijyszvk8L7TWsyBtDvzyBiCZWs6urikX54qoh+Yw4avwm1WgRPD1EdgOZMhEk9gHdzDl2htEciD9NHgcugGM7Otp2b+/PPmV2bsjRWK7zsH0Y033umGY7rQaT2oH3PDvDlu+VXcBwKropDoxQ7W/dIsbCHoekxMVlAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MpvtKVJsj7qy3hmUhizjQbx13PJZs9ta2VL2whYP/4=;
 b=Yd6lsxEowlJARxWybbj8AuA571OJEDO0kjLtycNOOPOV23Az1F1ZUFoAh7KDJ2lEyihGMfphQFeQ9I8Im5PFjEEIjSkBB3pWR6OY9ov+mxnfn/Oz1jJGKZRcfp41+wDHW5SrXtP7XF68OYLRWY6ZnqhYvQJYnE0AsmbmgGa15vgXRDp7WmgWzUYQNYkN1UMBcVnDWc7Jp/4qOqgfq7ynPV8m1giqYwdJD36IT+lEZ5mhjvYYP9sC5GVaBCB53fb4XvraO5Pr1wKYkbK9xDLtqnhBHdcoGPRBDEig65EYxED95pJogQrcvl5aHpfl/qDG3cO0jFtBHNnTg2e23a9RUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7MpvtKVJsj7qy3hmUhizjQbx13PJZs9ta2VL2whYP/4=;
 b=KjRyikYhieSKbCIoaHOkWH7cagbxYzEWj4WPR4Bcq4R5g/juPdRFZEJZ2Lfj0OCjuvQqG6W1H9K4fkUNOlnssLzeT+CJuBJMHBuEdpO1bNcGHoU+UdlvSrYHDSiAwDXSSN6VlAqKrFIe7aYn+Ug6jwcvqDH3T6ciC4GeEAiC7VE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/14] net/mlx5e: en_tc: Rely just on register loopback for tunnel restoration
Date:   Tue, 17 Mar 2020 19:47:15 -0700
Message-Id: <20200318024722.26580-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318024722.26580-1-saeedm@mellanox.com>
References: <20200318024722.26580-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:11 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8edc8874-9dfa-4972-a962-08d7cae6cd48
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41096C1A4008A4A5E1F3F8B9BEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HiAR1M4FgfIYggcNSHbEAxROOvZ1txnV3Jwruf22qqsRT8OaznTQarm/mTBkfm+I69TtvUdSxBocWyJNtdOZsBt2MxoRq9kXzfplEMmBLbXikaYMvEchCa+EnDTpUF+DZEtwhwlMHUYuSN2T0w7ipv28ChttlkMAY0ECpvJ2UaygbUktCWhH+enpLV21Hs3hjEzTbNwL/oOmxSHleJxcIemowNhq5x0etNR3wlJNTAt4V72M0eorUN2qgafsJrZJ423MMcJfUDr5xMygdKUqc0tWj3BpOeQ3KloPrUW6zLKp9HE1ClMy9CBAZom9DTr/34NtE42VJZ4XaRDaWvd9FQhpuJGr9aPUB5UDwPu7jayqhHm0z7PfEXEFkeQJBJvzT9641DGm5PqZfgJ5qF1mPVgNdrs+vuWL/Cf/xxUiA77a2s4DQYJpordBrdOUV3RIFe0udfG2l8RW5+YKB8oyBYuShJSqoR4QD5P99MrUTeub98TQDSrBJwSbpbtlHMDcwI10Elj5BYNEKyBd914o3vWEm4KiYC/NZMo78C4tbJs=
X-MS-Exchange-AntiSpam-MessageData: eW9bn2gQsCVLY6gzQLJDbz+MiGgZUdAkX54dMT/RJfgoc2kIgXrhN4yA97SDlX3MZh6x3TCPif2wQD4kPxfr5BMYsk3j1AQll06UfQXX0eipkzmBFAttYpDK4o7pj3vRUicxtj5anYek/DkGEY+1Fw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8edc8874-9dfa-4972-a962-08d7cae6cd48
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:13.3423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJ4Nj1u0wRdftgBIgLKAWWvie4ZOK2za5qClGCPid1syd3bJ+TfNc5sFLZ2KG0eMnbusXpeWopnE2Zi47XZZ6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Register loopback which is needed for tunnel restoration, is now always
enabled if supported and not just with metadata enabled, check for
that instead.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 044891a03be3..a2ff7df67b46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1985,11 +1985,11 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 	*match_inner = !needs_mapping;
 
 	if ((needs_mapping || sets_mapping) &&
-	    !mlx5_eswitch_vport_match_metadata_enabled(esw)) {
+	    !mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
 		NL_SET_ERR_MSG(extack,
-			       "Chains on tunnel devices isn't supported without register metadata support");
+			       "Chains on tunnel devices isn't supported without register loopback support");
 		netdev_warn(priv->netdev,
-			    "Chains on tunnel devices isn't supported without register metadata support");
+			    "Chains on tunnel devices isn't supported without register loopback support");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.24.1

