Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2381DF390
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbgEWAlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:15 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:1415
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387413AbgEWAlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJqiEDZ9E5kNCUZc2ksugZoxgmy429WlGeWHMklLge+IiNuz3Gqyr+Q7Bwv4BwTKYQ4r/iV+6b68nN0Um70bIjYzXEfwVIrE9Qi8xZIP+HI8InDLwAyR1lxWWC2afaHnmem5g8G+2AKKrBzTQ0xryXd9OQzmTSK72iSwVBhFZKWI+TCP8+YU6De2yzZmSXmIMdc4SqrGpqGeBj0rTNJDhspMHqBm2o6j/RKA/K1x6wjhytUAzoQKWJnybj9ScU6XMjP4a5eLWlSU6SfTHnOKSftjTPWIZn7GL2D80Dw1rnooFwGavBGE/j/yV/BoH9spov9TTS6irsq+C7ZXe/7qQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwIUsbM+UtO69Xoyyw9GBTNFlJ7Q3t9gOyYHXh9fwAk=;
 b=f0Jh8JcBPgRzsypZy36DyB4rkwqEPHu2taFEGLUGOCFuOfobxTzlhrVey92pQVxBfh/CvbjBfSEiPamPgHzcfxetJKbnsEbmHsvsJXD6cmyGJVYdDvR+sPfR+I3O/NCBkCua1bx7hFKx0gXKRLLLFp1M6hQ6H4KPSy+/BhvUMLMjXPNoTKQi5t/vrKOuNyYTUGkSkoa4TTR8/yOOPYVNN1xXl7qvMOqgX5HoVpDMvvODMy/S5Jailyl2oz5s2TkwDg11b27c04V8KUZFvH3RbLWKQlFCDJ5+RHVYTXfbeZtHUn9qtT+F8SIcZK9TLideQJ+uR4WXbHmyaj/fJQHqbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwIUsbM+UtO69Xoyyw9GBTNFlJ7Q3t9gOyYHXh9fwAk=;
 b=MB0H05pCC6KS3RdZXHdr67dKfZAi3GNHkLbCpyCyrdlRxVJ+gc3tvGM8HOEqSN8YVMGTDrd2lsJBuWp3I2KlOoq699PK05Y8voSsunvK+UTJEoyRqJruahya5/aJ+I7h6U4uv1tObAvy2Hm0wrtKQQXnGssBC7MHoivft4ucjao=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 01/13] net/mlx5: Add command entry handling completion
Date:   Fri, 22 May 2020 17:40:37 -0700
Message-Id: <20200523004049.34832-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200523004049.34832-1-saeedm@mellanox.com>
References: <20200523004049.34832-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:06 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 035ff3dd-245f-48ce-e6dc-08d7feb1fbd6
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5391E646085504B1916CBD8ABEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:359;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NYrSuVr5QvEg3BmOr6dbxQoHuq9YdbfUU+hRUuT0gEGOy06xjTsssGUxj2IAbOOfOr62jSFNQCni6GmNPmOOkCTpuYTjKNDZ3VSjIjo/gvrSXKNH7rRNS10or/xhud4HCcTN1nHgkjC7mVNm+uOm50J5F8d+fCeG4znc2ZK9k9fAFzna29jzhCxLnkH65AZzLR9bQwtXv3ewwj6wjPxhM1WGK4csFV6mbpRALthDp3tlEdNn8yKZtIOAB2+hEH386uL8/HKDgoACkgzidku7+wNskIArnpvUJ2HKjpUNbelQBOg8ncrjAOOy0TL6kahWT89+D2OTmAly3QGCunB4BM0kXG555CuzRSDBiKcstwYPw7S/P2Pu7i+tREhjNbLx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: N+zOTE9N7I7S4rbybcFCYPyH2eISI/lSr7qvEJiCJ7XSvAqRLC/PQoEz7WdzmNrpTr+Qdo0RcOhcqP1sMprs15JygtnPe9FasGlaCp7troB4uY3IWeWgCFp3mXseBseNN2PA9ydmQoN/2ospFmLnFlQziDfsN6HDY0F+LlpKVJOrBaYJfHE+5xvBOkPrKCeFsLBF+iqbGMpQ04qddS8p1UflXJHYWiFPTQNzdAZStHrEN1LVI2XaDvEKwMVg60hDpn0AoEV3Yme5oEui54VOGzoOo/z/uEpBOVAxXaXmUhg4t9b2ycFzusAoiO1sENTz2bG0USM6Ep1n5OicVcgVg4uaHYupLOAZPImgtH1fj0vzZ08JahMdZOaCK0NdM+sDJdlrbMEU6vP8CLwhIEDaPxVBHFupBVnFeEsxbTkubukV0PNPQ523TK7pJWiZcVWmlUpuxXy4Gdnqivy0yc0lUCDXrFp2TbNhlyt/eTEn1hc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 035ff3dd-245f-48ce-e6dc-08d7feb1fbd6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:08.5964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PvvRvjHCEo2/hoLwDcEZ9Vt1D2lkkS8Nhf0bIYcCvNGKiUEoERxrHRF+yZZ1dQrKLaH5cjGhuuJu55x6B/0PZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

When FW response to commands is very slow and all command entries in
use are waiting for completion we can have a race where commands can get
timeout before they get out of the queue and handled. Timeout
completion on uninitialized command will cause releasing command's
buffers before accessing it for initialization and then we will get NULL
pointer exception while trying access it. It may also cause releasing
buffers of another command since we may have timeout completion before
even allocating entry index for this command.
Add entry handling completion to avoid this race.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 14 ++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index cede5bdfd598..d695b75bc0af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -861,6 +861,7 @@ static void cmd_work_handler(struct work_struct *work)
 	int alloc_ret;
 	int cmd_mode;
 
+	complete(&ent->handling);
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
 	if (!ent->page_queue) {
@@ -978,6 +979,11 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 	struct mlx5_cmd *cmd = &dev->cmd;
 	int err;
 
+	if (!wait_for_completion_timeout(&ent->handling, timeout) &&
+	    cancel_work_sync(&ent->work)) {
+		ent->ret = -ECANCELED;
+		goto out_err;
+	}
 	if (cmd->mode == CMD_MODE_POLLING || ent->polling) {
 		wait_for_completion(&ent->done);
 	} else if (!wait_for_completion_timeout(&ent->done, timeout)) {
@@ -985,12 +991,17 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
 	}
 
+out_err:
 	err = ent->ret;
 
 	if (err == -ETIMEDOUT) {
 		mlx5_core_warn(dev, "%s(0x%x) timeout. Will cause a leak of a command resource\n",
 			       mlx5_command_str(msg_to_opcode(ent->in)),
 			       msg_to_opcode(ent->in));
+	} else if (err == -ECANCELED) {
+		mlx5_core_warn(dev, "%s(0x%x) canceled on out of queue timeout.\n",
+			       mlx5_command_str(msg_to_opcode(ent->in)),
+			       msg_to_opcode(ent->in));
 	}
 	mlx5_core_dbg(dev, "err %d, delivery status %s(%d)\n",
 		      err, deliv_status_to_str(ent->status), ent->status);
@@ -1026,6 +1037,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	ent->token = token;
 	ent->polling = force_polling;
 
+	init_completion(&ent->handling);
 	if (!callback)
 		init_completion(&ent->done);
 
@@ -1045,6 +1057,8 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	err = wait_func(dev, ent);
 	if (err == -ETIMEDOUT)
 		goto out;
+	if (err == -ECANCELED)
+		goto out_free;
 
 	ds = ent->ts2 - ent->ts1;
 	op = MLX5_GET(mbox_in, in->first.data, opcode);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 6f8f79ef829b..9b1f29f26c27 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -743,6 +743,7 @@ struct mlx5_cmd_work_ent {
 	struct delayed_work	cb_timeout_work;
 	void		       *context;
 	int			idx;
+	struct completion	handling;
 	struct completion	done;
 	struct mlx5_cmd        *cmd;
 	struct work_struct	work;
-- 
2.25.4

