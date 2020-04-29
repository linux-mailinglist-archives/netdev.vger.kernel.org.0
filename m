Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED48F1BEC39
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgD2Wzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:55:32 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:62734
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726921AbgD2Wzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 18:55:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6k7hikvIsSsIp8jDl9FKukCSmX1Ad0FS8qWtEtFntpJcrK+h8t8kqX/r/9I0EXCd6wzYghjAi48CxXgiO0PLnAqS9AY6slJOCSIz5qGJV2SEwSl+OQNdPeOKEFOMSzBN5UPvuhz5kZ6ET3gbkFL7o5ps9boaW3CvDAF6iFE5Vh1FomJaXumSbj1IAAwzfQ+C41TtHEH18J2Yr9XYua89pmvUsguWbGxz2ivt4vtawpxyszpF9/b6z9hycu2RcSL6N2eIHtJAeRVPuR/28SkC0AHqeqCDJz8i1GjtyXqY3B2FjFxwAcY4qlDSdmoEOtz61RvtfYshQAEI8vMXSjjqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDTnDYg6sA4HUMMHwJEE5tyBd3AUT5vrm+p3jaCPNVM=;
 b=h31457/oL9tR+s7Me/Mym5+Q31r2LoLrjy19KRdnf5Sn1eCeKUbaNeJ0nAox6JhCuCn7DMkRMT5Vh84UcxQKbujSy+qrdmiooUWf4c73G0lrInPXxP+WiMp5cGnhIIKD0ZwAQlsI19l7SA05zdYJy0nDCpF8jktL/hH7CzjBnK7MSqDmIX8QUlHsQU3PHDZTDSMmqIxc0A9CvBSL1i6qGnpNd+TNLcO7D/qmpHiHrJ0aULarGBX01iu5UIfKaR30u935R+Jto/caEfFQJm/aI1FljXidkE8XpekPv/R+1OJinkQ/Bm9pnsj6mfl6sHAbat4ClMK2wuyk8cSGDqu5ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDTnDYg6sA4HUMMHwJEE5tyBd3AUT5vrm+p3jaCPNVM=;
 b=LWW9DIH27mfpz5VHb0zMBdIfCL8mZABpL4giDispn71vNaadb6N7lSc0IfT/mq6ADILo7KZcUiv2PIFrxjGvWn3jfcvPiUtYKx9kWxzDJXSr/x2kYQwfHonJGmHBv4RS5Gm+QIjGB8mcUtHXpxdEeB0K+SBJ3GDZEo4B+0d8EgY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5247.eurprd05.prod.outlook.com (2603:10a6:803:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 22:55:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 22:55:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/8] net/mlx5: Fix forced completion access non initialized command entry
Date:   Wed, 29 Apr 2020 15:54:46 -0700
Message-Id: <20200429225449.60664-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200429225449.60664-1-saeedm@mellanox.com>
References: <20200429225449.60664-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0022.namprd04.prod.outlook.com (2603:10b6:a03:1d0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 22:55:19 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 414020ef-9050-4e1f-eac1-08d7ec906502
X-MS-TrafficTypeDiagnostic: VI1PR05MB5247:|VI1PR05MB5247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5247A1527BFCAD19A1F15E80BEAD0@VI1PR05MB5247.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(54906003)(478600001)(6512007)(2906002)(66556008)(6916009)(66476007)(316002)(107886003)(6486002)(52116002)(6506007)(66946007)(6666004)(2616005)(186003)(8676002)(16526019)(26005)(86362001)(8936002)(36756003)(1076003)(5660300002)(4326008)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nIViieUlXOLdOMwMpprid5hLTf0ZhbE+SWhNae4NqVoPDz6bWxiFaT78uFJkFpKVq49EUPK9kt2eZoyGNR+T199IbypbrXsPifNqUPhKS4MwufeEoxBDdXkKFXXKHivXjJFH5vYCs1tCEMzM7yInnEgR/ZhydgEVZOTTqznANfstGJo0PYCiy2XV8FOaZs3ycMyS6lWrXC2wFmJ/T22oLye8Nzl5LHtfswDdzSKlXJkrRH8f37bD5lqdF4+MMNsXx86PQfUkblpw+LKKTZCmo21L0blz9I1B6XFaznQ01a1YKYtgPmZ1yjkUWJNOs+bGi1mJQkPO8VAzf96goYWOamJpSoVOuAWSZuXPh6FJXGgram2nloEF68acfi37zb1XkhuviB41c+XDC42ZChGP04QQw2Ys3Eci5oU3vxMZSAFD/9obwaHZ/hGGaHCY2Uv8yJtUmB7NqVmLjyYuqMnplbiypJdUuclhDqpI/WkEXnwKv0M3b55ckzR/zStEejVi
X-MS-Exchange-AntiSpam-MessageData: ++pmPzQ7RDASESVWHqxQaAAmRMA8KtXrAvCUEl0Cnm6MvmMEQTaei3CMN8XhexMG88reZ5bDMJG5AZky6jpGkoCZZBU/Ay+c4mvqTLxiKtL+baTRjx6Z61i4OxeS4EfkOUcE292hX6uT3x4RBeLwSBOiXLNSAERibpFD51KLRk3gFjZwi7obnpKW21dHs/a2rh8zy02uokhhdpEGwHEf/46BgbkVzZxL/9PN4r3FYh87qRCgoQa7Bg9Vm7/Ndg9QqOaPnGAjHeSfrRKN7v7RH9M2HOZUvW2eZbXlVmwmky6Rp3DsJMJ8LMT5JisOA/C9TWqwKRPnDFsyUCfR5i4TK1faKR15kTEs1EtgoBlaZpdPWRZrQ9kWQmJP7tVh3estTUoJ5U2GYqD573N3tVwxRcqfvOaMGbV6XEfYkNKM30NZXxwWumW+sf1WqFE0Y8FuglHIihrx17WtPZWdg3gBXZzQqWiSsZDOFxWM6YlLZBBykGqicaxeqCUFZSCzrNMJFRrFYKYq7ZNMmXCKAUWZHqoE6c8miHOv+aZ81CIElW95D4sVYh9ND5pY72nhjFBgCvCJcNOFxb3Comm0SUnYy/q6OMayePO6786FSTx1d7vliUKe2z/jW+aNgracojPgdZ3B9axLUBMEhzOvoDN0AGG+MHB8NZ7jIi/KC8GgDpNgp3HzFM/BDm3yuf646kB4Bl68IPi+8zVISmSSaB8mWKPaFxTEtONb8mb9zBJ6kMxf9F3zWOAKlodjYD3nKcGIEXhiRxsPLINmouwXEsnn4lM8JulFiKDrzdhVsZOkxWg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 414020ef-9050-4e1f-eac1-08d7ec906502
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 22:55:21.2329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UqoqYLuxlIbiF0RmVXO78YFcymp8P5BnSW5LgmQnkqH8mSuz2134WEGYeTwaGIU3nh8/3mdQ4UIgYLSPp4bVTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5247
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

