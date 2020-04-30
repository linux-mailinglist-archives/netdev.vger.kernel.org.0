Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8143F1C026F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgD3Q0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:26:33 -0400
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:10070
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726336AbgD3Q0c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:26:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJWQQ6OiACg10run7XnxUdB0WLKZvTtYCIwjXDrIoVNT1BEBOzJmXTGC+zoqMUrDHa9YTavvSO666qeZoKzF+wUQYjdkfVsgGyGVmxXgfvU0KVpz/KxTZf2Sl3hbtef36xkoq4fnTkhrbrl1h5idtnzWVGwJV/LYO6+agZPf7gl6PpdJip3ouJE9KTmGm4lCizUkk4Ctx1AkTCpOkx4r2hb/cP01cX2UUva/be1+4ErgVCZXeumfLzWMJKkMdkdqzwAUjFFCHrJzoVUOs5uW1KAtwTtJbvTNcahKARRBTeA/AyjxE/VIYuRv+eipP+CkpZFoAtJTsVOo5YnCotOcXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDTnDYg6sA4HUMMHwJEE5tyBd3AUT5vrm+p3jaCPNVM=;
 b=g01T+XZTwDhpQnV5fD/Ss7y5H08g9WqLpDtxT8JwYHEnuOZ0HvD/aRhRSOUQ9E5F67ekI8miixxNTsU4HTQLczSSNpif93MrPEycoUiJ7EjEFeEUzhdB/AwpiuKl6gedzzIHZ3cgKUjmfyKJnVv/MpBVGQo72fevCdpjZGD8/rzRARehANn+/L6GRhiBCpJcaeh4EkCR6sQCkOe+4yVl9svAsCz7WbXq1xhNwQ4xd6/TU0Rtq9Ryx09AGB7PO6e93Ll4tBTJE09ITCl4qMDkNh1c1DrjugybUyLvnR88utrD70dIrWHXBAeSBX5PLTyCk9bmOyOXy/pT/WqgBStrsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDTnDYg6sA4HUMMHwJEE5tyBd3AUT5vrm+p3jaCPNVM=;
 b=t8bj/5trNPFC/W/Me2sGK7lxLZ/NVAasks+86q0U+gzDA7CpgKDfWKOEqlrYF7y21eLdXalvF8lZjmuOquJbmdlEHQzW6HAhG9DtMcpd/LzQK3W+ZLUUFtTP/5Qbx6aCLaUQ02CMHVVF1h6sE4aMX64C2F9TfR1DcIBHbvNq52E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 16:26:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 16:26:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 5/7] net/mlx5: Fix forced completion access non initialized command entry
Date:   Thu, 30 Apr 2020 09:25:49 -0700
Message-Id: <20200430162551.14997-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430162551.14997-1-saeedm@mellanox.com>
References: <20200430162551.14997-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:a03:54::47) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0070.namprd02.prod.outlook.com (2603:10b6:a03:54::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 16:26:25 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93b5d377-ac4d-452e-c812-08d7ed233b50
X-MS-TrafficTypeDiagnostic: VI1PR05MB5376:|VI1PR05MB5376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5376ED51979CB9A82566D251BEAA0@VI1PR05MB5376.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bJG20TJcRiPCPbfxrylOybSshR+4h4Rq6Rnt5EH3W7nKmSwEnUvNyP/MkAny5DVMcvift4VW0M/VBnBpxTWDGzAwXnWJDRihpvF2mECEZTikmgQvo0fDmNCDKiHIB0LNRFWLedNMx/mPs+tS2qJSOCZdEL9WQKMYl2M+rEZPgh3uEGLFkgsWTkSrUi24W00wuwaV3g6dJRtdnshWrFi2ufoTG6Us+DW8RKuikWWsTI3vvMojPQTRXvV9CxRSHxT2Ne6bJZcPFvcKK8MLkeVbev3KpVQ9EyhjOwIVbg3idsoimwgDShSwgKt949cDrL4DgTh+k62nBbcLqJtkN9Fe0um9Y1BrksiamhXOdkIsv3d6npJlc6Stk90YyVV5gu5fIdFp7mCAwCgqviu1E/mn5I/SVCKyzuyNPVQhZwVObTOUNtdiXA4wdUX/GPM1ekUGsNls5ouIN5tOOJ3D2gmgJwt74m/h+Psj03BFiEn1kUFJ3yohED1NwllVtiLVJ/f/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(8936002)(6916009)(107886003)(36756003)(4326008)(66476007)(6486002)(54906003)(8676002)(66556008)(66946007)(2906002)(26005)(6512007)(1076003)(316002)(956004)(6506007)(86362001)(6666004)(52116002)(2616005)(5660300002)(186003)(16526019)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gSwoa9fwUdIrsSDoRfLTlJlQeBXTv/T5ACq1ZS/6rOqk3ny36JwsSQh9kZnToAK322NDUGRVBYZCwT3te2/i+HwKFBV7Mje8k5O2BxbO+93FyUb61fUkuB9SPxwzMMGzuravCr19fzxc3gFcyuU0NjR9D6PBqSWbhEuUSRXEJv3uDOsxCiZEg+f7GiozHN87vvoVXpRvB0vM1RhftswyMvdQjVgDkY6Y4xvD+H9xPJ206WwIutGUh6xenYjp2MA4VQZgGwTd48zhAzJvMEXnmQGMcI0vkfbyvouzUL23SRwzP3rdtBOOcOOw5hLkOaegdFX/ggyXHYzYsZDp5OerrHltCN4gd9BDkDx/OVlaNZle+jYQ8v1jyvT+M5sSsIu8KFLcUxQ1u61PGYxRVmV8u/3/W/EffQt81q9V2D9sy+vKLGxZahZA6JGXpLwp28mNxHmB7GEPmIR5AcrLMiFDRT5283CtDGQKR3oQFcGlW94gfHiDhxyHbXe6pYU+QbAqihiQfbDmw7pSt5hX76ii5JzkA3yGM+roFsSDBNCtNW5eCvDbLEz0qugCwAK17biAw2BvKgZAqfexVWSLO68Z83sBN3t6/Sf2onCRfGg1vetUScYmb+PmqQiUZOGTGRCKgQnawZULlad+xie+naNSDaPeq8aQvXOiVfrF6rzhHSRn1hD0H72fk1Rq2dMXcWsa5ky8g8yyPpL0ncfGY6F89ID14x2+tYLm23yi3o4k/86sXPF4IjZs/SIGXacv2b7uplciUgl7ik5wXXVOQa4VYrthkjgnnXQjETGvSBi+rrw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b5d377-ac4d-452e-c812-08d7ed233b50
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 16:26:27.2961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 55sZvrQekfHmaCb/S2Sud3wtrd+vZsY6VrcpXJcxi5k2seAXpDofTy25yXqeW7/LniEJvpe/6h/dcCJC/eWjTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

mlx5_cmd_flush() will trigger forced completions to all valid command
entries. Triggered by an asynch event such as fast teardown it can
happen at any stage of the command, including command initialization.
It will trigger forced completion and that can lead to completion on an
uninitialized command entry.

Setting MLX5_CMD_ENT_STATE_PENDING_COMP only after command entry is
initialized will ensure force completion is treated only if command
entry is initialized.

Fixes: 73dd3a4839c1 ("net/mlx5: Avoid using pending command interface slots")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 34cba97f7bf4..d7470f8d355e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -888,7 +888,6 @@ static void cmd_work_handler(struct work_struct *work)
 	}
 
 	cmd->ent_arr[ent->idx] = ent;
-	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 	lay = get_inst(cmd, ent->idx);
 	ent->lay = lay;
 	memset(lay, 0, sizeof(*lay));
@@ -910,6 +909,7 @@ static void cmd_work_handler(struct work_struct *work)
 
 	if (ent->callback)
 		schedule_delayed_work(&ent->cb_timeout_work, cb_timeout);
+	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
 	/* Skip sending command to fw if internal error */
 	if (pci_channel_offline(dev->pdev) ||
-- 
2.25.4

