Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CED421ADA4
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGJDrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:47:45 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:9749
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726787AbgGJDrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:47:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6F6CZaCo247VCOgE50Ng9tjtz8XZBVzMwEbtRMeOyQsPTLmqMNr//2RfS4mjYSt8hk1jmbP6l2mRSx0jIU4iUnY8bzgXuCOjdQNOrt5RfSX8/kfrkHpjuJOcaWYAxURft/ZeZgJOWmtbsp0c/GRteQlWGq24USw58VErxyF7bhftldKnLUBWz0OmhR4jcDLzrg0AYvC1BvK9S0LZy/L6qtsCNiUWkSXMuM7E9xYJ+cQV3SUadSN1TCWefAk5D29xcsSOaHtFK0poATo5tDewMFR5VzHMXdejo0h12PJLosBakPhL2dEAvCqv7YuqIz9P20tAbGy3qq9FD0/JVVdfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tULu9cUcktVEzG1PUZOdzDsbCH1EAzy04oKvszmOI/M=;
 b=gj/LKZXz3qJiz00CUv732b82Ebm1Dl6QFpkpcICNukG0LqMYCGkRC/WAUSyY2O9qqxyQTn2zvxJ6/vrbYiZ4Vxe9+FEGi6zqIltggP0x9jAuypnUcSFLnaZJuIqk467DM/uHVzL1GktnKo3dW5ODJ2dIOR6mk6HX8XU/8WNg5eWR42mXxU0Of9Vta8cWtx3MQ0ACw2T0nlm28VdPOeisxXa9m/GMOjRvpbOYXd+3KLfMJdtn33l2z+Q4AaRdU22LVBno7goUbXM5dZYPE1BcGB/rOSSkjg4ZlAxiw5kksyu3EEXFyQ/YxJeSJAHx8sKM5DGi5ZDQMjJUxGy9SP1wkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tULu9cUcktVEzG1PUZOdzDsbCH1EAzy04oKvszmOI/M=;
 b=j/HPuxHDJPYey9R62hAnAR9mb2YjZ7E+Ujp/6DE0fEuCXEVhaXQscCKUFd5inVjE3wr9w7pWo1ws1JqwdP+4ZeLAUjbjUlyEUnm6amcVjUZAYqMxFiwgRfWa5BGaogcHYR85PInC36DBXUYQF2isMPwl9fIw9HPwqah/7czZm4s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:47:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:47:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/13] net/mlx5: E-switch, When eswitch is unsupported, return -EOPNOTSUPP
Date:   Thu,  9 Jul 2020 20:44:20 -0700
Message-Id: <20200710034432.112602-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710034432.112602-1-saeedm@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:47:37 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 90463443-34bd-4f80-f3d1-08d82483fddf
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45126C9526A428625ACE7FC3BE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZXKaAxSRjJCUuzMTJUIS0wtCayUjDx08QmV7rDc8SFwA2IdwtAF8mDYYAbm2V7EQZ3SW3y/VfYVEuc5eh1PAN997K9QrjJh8aJ8+CDGRin0HfxTwQhdgPH4PYvfZGoxzaRCGEvihG01kmmK1b+LnCGdDz610sNcbAZVnMmtOJSOfTXb59okpKL2UAdXHAVdt9iROIR6rFelTXYgcp43NVthrL21IPOs2PZnjcEnwJextVYn4tzbuuyTBhZxlzSNqi1Jxaq3AvKVmtKQRFFMHBzIyFTKIAPGzT09TQ2OBCfHgjPEpUHTDzA4srl6SqXryDhLeT1zXXihGNfoVyXg5uj7aJjeKZWu7SbQUbscr9KtoflTnxcMliCUzbi0Uooyy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EhFbF07ifZp2aM2ySrNG8VkoNZqtmsf2J+dSw4COQ2GedHgvZh317xdt/aRkGNELWo9ZJphuEQeEVrpRd8w+IsG44g1ZLBMCyk7Tg8fc5vKlNU49c0Y07LTMgLPIo+6Ohnn3W5R0Pd9V0GJeVPY1k1n+F7Trw0A0kLOmbboFWHxw6utOF1ApIzKpo6I43CfF6dZIOW2Ej3TFjvwF2Zx5/apnHruXHOvN+7RNbV2/diU8muQfZqWxsBvyc+uasRk9RUpWnSoolqDGmQhmLcTwBDpR1DEJKIgLYlPCIqydj+QZhlwqwLhDAKvX53At48hif17Vqi2KlM0E5xhymjouchXdG4F+F1ODw0cZqNODTKn6jcwIIp025Xfgl8ajQaBusw2IxHTL7e2ft0Rn0BiPUxTrL0Qwwno2lXWZ41k3BrfV4rw+8vWZVbEaGnmMXJ3m/OXcQYJHDjbHn8f1e6AEfMLoqB1pUSdcxLKn5rSK0s0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90463443-34bd-4f80-f3d1-08d82483fddf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:47:40.4926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tcO2RZXxmcpmhdeRJggUxWpss/qDTXqcr/XS3x8ViJ0BKeFgYXJnfucCdzJ6ALrlTUDIX16nnLPXSGcBa//YpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

When eswitch is unsupported, currently -EPERM error code is returned
instead of -EOPNOTSUPP.

Due to this VF device's devlink virtual port is not enumerated because
port_function_get() callback returned -EPERM instead of -EOPNOTSUPP.

Hence, return the error code -EOPNOTSUPP when eswitch is unsupported.

Fixes: bd93975353d5 ("net/mlx5: E-switch, Introduce and use eswitch support check helper")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index c656c9f081c1..d70543ea57dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -69,7 +69,7 @@ static int mlx5_eswitch_check(const struct mlx5_core_dev *dev)
 		return -EOPNOTSUPP;
 
 	if (!MLX5_ESWITCH_MANAGER(dev))
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	return 0;
 }
-- 
2.26.2

