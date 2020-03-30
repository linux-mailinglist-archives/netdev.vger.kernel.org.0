Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED10E197571
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgC3HR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:17:26 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:55440
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729378AbgC3HRZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:17:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhmNSQgGsesQpWeLKkm1Fn4y8imRUWBMFAH6fWsSpu8H/rqJbXjVAMWi972aZP5SR6NnhsfhTmI83IUYXFYiF/pXjYwfSyXExH6EuCdZQNsSCQ2BthpOieK8LIfnZoZQaiZPn0C2qUkB7bmCYCsWZyww4BbU0TK9iNi7oAvMHa5JoNT/MvonAsfnT1SsgsTOrEkl4A8M3PYCJe7FQJbQ4NWepEVskgLhQ1RUaPaYrGjoQC7quXhuBQGbqVvImvnt4DSjD3NpyWL5mmdV2frfLKsdme/Yre4ssns+H4Gek2KY7brBvu6iG80RUrIvVnj3kMNhXx/2HD6bpyZMJ0Z0Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4p4h4bzZM5sfOuNVujcefEYRTWgc4pQScq+9NYgU9g=;
 b=EsrEgbxm1WJez57hdE3R7pmjtL4iTzwALhI9+fwnjrvCo/PBSpikFCHpgmfpMFUhIioJL0TPs37g3VxI0VqJfnxjdf9sE57HMX/TGHOhukdlIORLGI1QzzeggtubOqcJUqMP/UUW+xUFM/PAMlbCYh9vBSDLfRwRgexIaM3fCAUdoUtzFRDZ8AxNDMYpPVl9hzdWaa5ZxKBeS67X2wKMC04IjYsRMyh0DeNQ19WhkaMvs+/IPBz+NDmvGRRLJEElJJVFSTPhLqjz4fW/BDajCeD7QrP8/dhX22nS6Xc5XVAvzoXUyyf+ymWu1ew2c+gH2ElYIE9iTBwRDeAMgOpAlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4p4h4bzZM5sfOuNVujcefEYRTWgc4pQScq+9NYgU9g=;
 b=ZBedvmKeViap8lyNBNUJQWSfQHQSmmUKMonir1H/oMJEOQy2zSbkf52o2bo+WBoSaucBX7lAKX0m3ddlhGoEbPypr2ivXkAGenjkzU8MCsjSFI4Lx48cIZfZ9U34IJTf5PbCEUlSRRmit/O4iFM5hRZ4vUMbw3quBBvlYIPAM+A=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4989.eurprd05.prod.outlook.com (20.177.52.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 07:17:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 07:17:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 1/4] net/mlx5: Use a separate work queue for fib event handling
Date:   Mon, 30 Mar 2020 00:16:52 -0700
Message-Id: <20200330071655.169823-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200330071655.169823-1-saeedm@mellanox.com>
References: <20200330071655.169823-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 07:17:19 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 153da801-f0e5-4794-0e59-08d7d47a6327
X-MS-TrafficTypeDiagnostic: VI1PR05MB4989:|VI1PR05MB4989:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB498914468E67972EB924620EBECB0@VI1PR05MB4989.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(5660300002)(6512007)(8676002)(107886003)(478600001)(81156014)(66476007)(86362001)(66556008)(4326008)(6486002)(66946007)(6506007)(16526019)(6666004)(54906003)(52116002)(1076003)(8936002)(81166006)(186003)(26005)(2906002)(316002)(956004)(2616005)(36756003)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RltNxgzVEgW0HrfERT5ABjp+mmOtjqRVk4TWTgKvgnM7zBIASmYVkYRJ0Byu+mRNAn7Tf/h9GUo9cDENPfnh6mkzmJ5p5CeF5xf5LaNW00cdQbKYXdAPgvTqA9p6muaEc3q7u/ahheK2Fzs9mf3lDffxadPghcxBoxITyd+d7V18hnpYgHzDamTEQNUFI7gyX0F4UgIP8U0ciXk5+60Lo8ZkGyx5fmkIeDU8RuRuoFEi/2BH0ceS5J4LzwiresuvFDgjVyz/E73vgQaogWXHxagCeU7B6vLdvb3HRGhh9GWPdqQQMuufm1cGfSlWe0p8YHuvmbTUFD7JNiP30F3SZKARa/o4rukAhZcylYgXvZGS4hJ8BQo56hBc68CFmH6XAE5SWa+vNOOt4fozhaBcJ+Sa7mtBi1EyhatnzymdjgedBG/nf/FL8Wepac8UprnhDiqL+eJxeKelOWBacBdpzaHAixNX6/ft7UjCEuus89XHf0DlMd3yiPFIbpk8Pw98
X-MS-Exchange-AntiSpam-MessageData: 2MuyFWINC3PPwmiO0cY1Lt7iMRlucifSTg9ghHIxNXxXIUwH1dR69fY1P1jG/ogD3UYh7qUyj/0idpV1PITw6fBi5lVFjCH5UBviYcD+9MJq7RBKQvFXDZXmErQvKvSECz4cPSrorV2BFUb3FmXMcA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 153da801-f0e5-4794-0e59-08d7d47a6327
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 07:17:21.2516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +jCb5snk/xyQIxdLgOuDjQsuRP4P9NeAcO1AEsyiWe7KAynFFLiEzqnEY+kovD43LQY8OWNPLYPI/ziSLb0ymQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4989
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

In VF lag mode when remove the bonding module without bring down the
bond device first, we could potentially have circular dependency when we
unload IB devices and also handle fib events:
1. The bond work starts first;
2. The "modprobe -rv bonding" process tries to release the bond device,
   with the "pernet_ops_rwsem" lock hold;
3. The bond work blocks in unregister_netdevice_notifier() and waits for
the lock because fib event came right before;
4. The kernel fib module tries to free all the fib entries by broadcasting
   the "FIB_EVENT_NH_DEL" event;
5. Upon the fib event this lag_mp module holds the fib lock and queue a
   fib work.
So:
   bond work -> modprobe task -> kernel fib module -> lag_mp -> bond work

Today we either reload IB devices in roce lag in nic mode or either handle
fib events in switchdev mode, but a new feature could change that we'll
need to reload IB devices also in switchdev mode so this is a future proof
fix as one may not notice this later.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 14 ++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 416676c35b1f..e9089a793632 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -93,9 +93,8 @@ static void mlx5_lag_set_port_affinity(struct mlx5_lag *ldev,
 static void mlx5_lag_fib_event_flush(struct notifier_block *nb)
 {
 	struct lag_mp *mp = container_of(nb, struct lag_mp, fib_nb);
-	struct mlx5_lag *ldev = container_of(mp, struct mlx5_lag, lag_mp);
 
-	flush_workqueue(ldev->wq);
+	flush_workqueue(mp->wq);
 }
 
 struct mlx5_fib_event_work {
@@ -293,7 +292,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		return NOTIFY_DONE;
 	}
 
-	queue_work(ldev->wq, &fib_work->work);
+	queue_work(mp->wq, &fib_work->work);
 
 	return NOTIFY_DONE;
 }
@@ -306,11 +305,17 @@ int mlx5_lag_mp_init(struct mlx5_lag *ldev)
 	if (mp->fib_nb.notifier_call)
 		return 0;
 
+	mp->wq = create_singlethread_workqueue("mlx5_lag_mp");
+	if (!mp->wq)
+		return -ENOMEM;
+
 	mp->fib_nb.notifier_call = mlx5_lag_fib_event;
 	err = register_fib_notifier(&init_net, &mp->fib_nb,
 				    mlx5_lag_fib_event_flush, NULL);
-	if (err)
+	if (err) {
+		destroy_workqueue(mp->wq);
 		mp->fib_nb.notifier_call = NULL;
+	}
 
 	return err;
 }
@@ -323,5 +328,6 @@ void mlx5_lag_mp_cleanup(struct mlx5_lag *ldev)
 		return;
 
 	unregister_fib_notifier(&init_net, &mp->fib_nb);
+	destroy_workqueue(mp->wq);
 	mp->fib_nb.notifier_call = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
index 79be89e9c7a4..258ac7b2964e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
@@ -16,6 +16,7 @@ enum mlx5_lag_port_affinity {
 struct lag_mp {
 	struct notifier_block     fib_nb;
 	struct fib_info           *mfi; /* used in tracking fib events */
+	struct workqueue_struct   *wq;
 };
 
 #ifdef CONFIG_MLX5_ESWITCH
-- 
2.25.1

