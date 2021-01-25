Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC63E304AC7
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbhAZE7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:59:37 -0500
Received: from mail-eopbgr60090.outbound.protection.outlook.com ([40.107.6.90]:8416
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727047AbhAYMkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 07:40:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVbhYGVqLjGldjhci3lu6r+q05gZQxu14PDOAPaLmXZp4HE/xO9JZfsaBARCLWmDADNNcq6dMo+sc09MDsG40um68BZMJisf4El4GTgVEu91rYSrrGvD+wBBnxEKTbv4WqLcIOnZTa2V059vi/aSSojGWax7NGxCM0eEWLEqQZNv42cPeciIr7h+lv7nsn7obY9DQDAYEDdoqxXYKuDTnIPAxBeM3WbZ4PJhzRorYNsqPTm5/7gJMBJDzoPWunHKIwz68azx8dCtKHNPSR4I45FbJlgnswLMXXcmp2Pp97HtA9JSgjjjS4nKdKP4WoacAFUFwipTsHBOsA3cQ+WaUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPm7NGQs5OrKJdGi5Rn6D+B5GcOdz2UmAbAFLKfoJg0=;
 b=iix2JeTqXr4WiLliCXhP9BHMJVZ342LopftRBHZEpbQT4PhxwqxsPVlqJyhi3OUCoDYB97mVj8NDahgpSdeNZ3IRQQ+QtYPPnDFsck9Sg9a9rpjg2DlCmaxHrq0UlzftmkuUZ4Atjw0YhDHI5EGX4CL2TqiKNNJ6OFfoN+Mq7JACwwDz9UW+19vNAcybHEakmJJrBNVVCSyKIDP8gYQtWnbfbl3hkofN/118xRYg+X1MbX8Yb+xdy1fvpo1VTfiRfJo2uyCivHvqaGsKIbEUXKXyEv3Ehu2pFcS4gRFYqT2AB++RU+XIsZNQ5bbJpMHsOLi/SdSfVg5djtuovT+LrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPm7NGQs5OrKJdGi5Rn6D+B5GcOdz2UmAbAFLKfoJg0=;
 b=DYxgc9VHK8x5geDTc00t8xXv/Uxso/ZkVVNKt9cRj+tsqKdklc9GCJlLl5eSy8esBwo0wCjlRJgt5Kbf1UCLTO9zE/wsoXf1L8Is4+5J0y4Lx3jbfWwlAXffzZks0uQ2HWzVLzDgwhjyndye9PUYAh6M21wl+Z4ILZwCww7CGAg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1233.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:270::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Mon, 25 Jan
 2021 12:39:16 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 12:39:16 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [RFC v3 net-next] net: core: devlink: add 'dropped' stats field for DROP trap action
Date:   Mon, 25 Jan 2021 14:38:56 +0200
Message-Id: <20210125123856.1746-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR04CA0110.eurprd04.prod.outlook.com
 (2603:10a6:208:55::15) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR04CA0110.eurprd04.prod.outlook.com (2603:10a6:208:55::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Mon, 25 Jan 2021 12:39:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e8bc033-ee03-4090-c07d-08d8c12e39f8
X-MS-TrafficTypeDiagnostic: AM9P190MB1233:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB12337280B5E7FD4913F43CE2E4BD0@AM9P190MB1233.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GyPq0N5xamyU6h5ko0TYw23W/1uDFpGLO00kqC3oKDzx3KVRfBYJhsDEVj5bixaFRpEjUzws/LG6Xn3XtWRyKoI9zDyVhkhx/eq2cjTTo7h0jFE6Hwul5RzppldT00afrsPfU48htafN0Ce3PKnv86Li3OUq3MDu/PsLBPkJdPD1+u1TJRPWTwqtH+SoNHB3fyOB51NIV82mu5UIrszqnbAHknKtxmGlLfWjxp2oGrL3Aq98h5398DS8S1t9rT0YtErjGI83IT68DNMRjG90S7kAlddMxT2CsDgymdUrMigZNkjEuA4Rxo0ycHPg1xIE09zk70zS/f4D3Jyc2PIc9WgO1X+Ur8qWuNjpAGpfLKoFkDBfaMV7HLkI+U0fSNnFgwqSxIneC2Lm7cFRVaAPAVqlko4+6QMJ3s4FzFLg+2iC0S1vHLZ1gzJU4OPeAyQC9Puvn87PWYm0jZ7sHFBS5LtvXaugCMZ+s/5te46fz1icpdswPgWn6dap0ctsYH7LL6iyzIqWfo1Y1kct3XwFFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(346002)(376002)(39830400003)(2906002)(6666004)(478600001)(52116002)(1076003)(107886003)(956004)(86362001)(44832011)(4326008)(316002)(8676002)(2616005)(6512007)(5660300002)(83380400001)(186003)(26005)(16526019)(66556008)(66476007)(6916009)(8936002)(6506007)(6486002)(66946007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fTCKBWTByrE7tS5vliOHPDuTBu8B5sKiR9hu0mErJqArMjejB6VwHyjAILH1?=
 =?us-ascii?Q?bphqVivxmzd5zOg2KJUty1wVbvPSmX+uX5idL7HDSEjzfZfE6PZRwEdi7PAZ?=
 =?us-ascii?Q?uCRr3mC3DLe9mnAEFH8posc+4uRluvLo1KWIN5vWVwSz5ABaw/ftVghOenUX?=
 =?us-ascii?Q?Qpcbf4T9qfY3h5+pRlmLgHvFSCfq5xoWORUaD+iMIOfCRlpotOkF0Gn+bbWA?=
 =?us-ascii?Q?WliwFOG9hPSnWFwZXKtNtq2csqp7JY3au8dbWcgIXJiLzSxbnD8ntTir/RGG?=
 =?us-ascii?Q?5UkkUBbUy0dwOYssMk1ClBT5zNPhGga05h3j80B9SA5kHgQtp0UwbNYT6buX?=
 =?us-ascii?Q?BtPqgNJWX8UrJSUFB3zOZ0LN3SookYF+uc6hk8EuUxLlOiLDYN41XWMSZ3v1?=
 =?us-ascii?Q?5tUKiLu9UwEZ+FWT5XIe5wfIOcMSI8JMu7kRBm17Pp9X8U79cuJBO6P2iCLI?=
 =?us-ascii?Q?BfitJG/TobTCnylf6z7h75RYOkQj74wWEYPO8OA3N3qoXOgiDA//tonLZQmp?=
 =?us-ascii?Q?+VWdKJpHdtvk9pQaY7ccWBoFb3Q2bawzBqMVUMZ/FNMtRrkORj1YbjvvVo7m?=
 =?us-ascii?Q?8bQ3KTSumc9rSBGlC+bp6oEIH48+dTKUI0yy9gsObo2BXxKwfhoyz0w7Y/Y9?=
 =?us-ascii?Q?LmO+tlBZ9J9+r+Eqdh1zVG6wfxpHD2pS9zh3qp3yDuqwssllQeFxLaepGXaO?=
 =?us-ascii?Q?WdDuoZbpIB5jxTb8ai/jIdgPCMxgnLqSvtIj3fijIRH3mzNfELUxAFaretJD?=
 =?us-ascii?Q?CCka6W/PwysMPWzanrEo8Zc49HgW8ghgtgX4Vjis8rUafrZzpXl9IiO5l3RG?=
 =?us-ascii?Q?pL6i9l6cnDGa/DigfJ/jKmlY6R+rxoIZlzzavrM0rh/WVcJPgSJScaQaMXYp?=
 =?us-ascii?Q?X6/MqvZBkaay4JmKJOhZi+c85/B61lfjK6U0yUKJ4w/a+8LTkUI4KjTC6b/I?=
 =?us-ascii?Q?2198fNCd5FofFrCusgQxGk6Lq3G+uQFxW7gZ3rkpJFGZvaWeYfDqqPnq0MnL?=
 =?us-ascii?Q?hC2g6+bzX3sbjP47BNPA95ATyhs9GKaHl3wyxzBxdEeoOGF/qu+KmKl+jy9V?=
 =?us-ascii?Q?L0WqO+Lj?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e8bc033-ee03-4090-c07d-08d8c12e39f8
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 12:39:15.9559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2efzpSb6kAS37swydgeQt9/FCvk65mYkd9xhcO0nMSv4QItUP3mD+SlFUCQ/lSFHntcJ516Vm7llhwF5SR1T/IZvHrZIYbiuG5OIuCHOd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1233
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever query statistics is issued for trap with DROP action,
devlink subsystem would also fill-in statistics 'dropped' field.
In case if device driver did't register callback for hard drop
statistics querying, 'dropped' field will be omitted and not filled.
Add trap_drop_counter_get callback implementation to the netdevsim.
Add new test cases for netdevsim, to test both the callback
functionality, as well as drop statistics alteration check.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
V3:
    1) Mark subject as RFC instead of PATCH.
V2:
    1) Change commit description / subject.
    2) Remove HARD_DROP action.
    3) Remove devlink UAPI changes.
    4) Rename hard statistics get callback to be 'trap_drop_counter_get'
    5) Make callback get called for existing trap action - DROP:
       whenever statistics for trap with DROP action is queried,
       devlink subsystem would call-in callback to get stats from HW;
    6) Add changes to the netdevsim support implemented changes
       (as well as changes to make it possible to test netdevsim with
        these changes).
    7) Add new test cases to the netdevsim's kselftests to test new
       changes provided with this patchset;

Test-results:
# selftests: drivers/net/netdevsim: devlink_trap.sh
# TEST: Initialization                                                [ OK ]
# TEST: Trap action                                                   [ OK ]
# TEST: Trap metadata                                                 [ OK ]
# TEST: Non-existing trap                                             [ OK ]
# TEST: Non-existing trap action                                      [ OK ]
# TEST: Trap statistics                                               [ OK ]
# TEST: Trap group action                                             [ OK ]
# TEST: Non-existing trap group                                       [ OK ]
# TEST: Trap group statistics                                         [ OK ]
# TEST: Trap policer                                                  [ OK ]
# TEST: Trap policer binding                                          [ OK ]
# TEST: Port delete                                                   [ OK ]
# TEST: Device delete                                                 [ OK ]
ok 1 selftests: drivers/net/netdevsim: devlink_trap.sh


 drivers/net/netdevsim/dev.c                   | 21 +++++++
 drivers/net/netdevsim/netdevsim.h             |  1 +
 include/net/devlink.h                         | 10 ++++
 net/core/devlink.c                            | 55 +++++++++++++++++--
 .../drivers/net/netdevsim/devlink_trap.sh     | 10 ++++
 .../selftests/net/forwarding/devlink_lib.sh   | 26 +++++++++
 6 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 816af1f55e2c..1fc8c7a2a1e3 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -231,6 +231,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
+	debugfs_create_bool("fail_trap_drop_counter_get", 0600,
+			    nsim_dev->ddir,
+			    &nsim_dev->fail_trap_drop_counter_get);
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 }
@@ -416,6 +419,7 @@ struct nsim_trap_data {
 	struct delayed_work trap_report_dw;
 	struct nsim_trap_item *trap_items_arr;
 	u64 *trap_policers_cnt_arr;
+	u64 trap_hard_drop_cnt;
 	struct nsim_dev *nsim_dev;
 	spinlock_t trap_lock;	/* Protects trap_items_arr */
 };
@@ -892,6 +896,22 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 	return 0;
 }
 
+int nsim_dev_devlink_trap_drop_counter_get(struct devlink *devlink,
+					   const struct devlink_trap *trap,
+					   u64 *p_drops)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	u64 *cnt;
+
+	if (nsim_dev->fail_trap_drop_counter_get)
+		return -EINVAL;
+
+	cnt = &nsim_dev->trap_data->trap_hard_drop_cnt;
+	*p_drops = (*cnt)++;
+
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
 					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
@@ -905,6 +925,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.trap_group_set = nsim_dev_devlink_trap_group_set,
 	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
+	.trap_drop_counter_get = nsim_dev_devlink_trap_drop_counter_get,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 48163c5f2ec9..b0d8ec7d09a5 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -219,6 +219,7 @@ struct nsim_dev {
 	bool fail_trap_group_set;
 	bool fail_trap_policer_set;
 	bool fail_trap_policer_counter_get;
+	bool fail_trap_drop_counter_get;
 	struct {
 		struct udp_tunnel_nic_shared utn_shared;
 		u32 __ports[2][NSIM_UDP_TUNNEL_N_PORTS];
diff --git a/include/net/devlink.h b/include/net/devlink.h
index f466819cc477..0b9ed24533c5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1294,6 +1294,16 @@ struct devlink_ops {
 				     const struct devlink_trap_group *group,
 				     enum devlink_trap_action action,
 				     struct netlink_ext_ack *extack);
+	/**
+	 * @trap_drop_counter_get: Trap drop counter get function.
+	 *
+	 * Should be used by device drivers to report number of packets
+	 * that have been dropped, and cannot be passed to the devlink
+	 * subsystem by the underlying device.
+	 */
+	int (*trap_drop_counter_get)(struct devlink *devlink,
+				     const struct devlink_trap *trap,
+				     u64 *p_drops);
 	/**
 	 * @trap_policer_init: Trap policer initialization function.
 	 *
diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee828e4b1007..2bb129cdf722 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6791,8 +6791,9 @@ static void devlink_trap_stats_read(struct devlink_stats __percpu *trap_stats,
 	}
 }
 
-static int devlink_trap_stats_put(struct sk_buff *msg,
-				  struct devlink_stats __percpu *trap_stats)
+static int
+devlink_trap_group_stats_put(struct sk_buff *msg,
+			     struct devlink_stats __percpu *trap_stats)
 {
 	struct devlink_stats stats;
 	struct nlattr *attr;
@@ -6820,6 +6821,52 @@ static int devlink_trap_stats_put(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int devlink_trap_stats_put(struct sk_buff *msg, struct devlink *devlink,
+				  const struct devlink_trap_item *trap_item)
+{
+	struct devlink_stats stats;
+	struct nlattr *attr;
+	u64 drops = 0;
+	int err;
+
+	if (trap_item->action == DEVLINK_TRAP_ACTION_DROP &&
+	    devlink->ops->trap_drop_counter_get) {
+		err = devlink->ops->trap_drop_counter_get(devlink,
+							  trap_item->trap,
+							  &drops);
+		if (err)
+			return err;
+	}
+
+	devlink_trap_stats_read(trap_item->stats, &stats);
+
+	attr = nla_nest_start(msg, DEVLINK_ATTR_STATS);
+	if (!attr)
+		return -EMSGSIZE;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_DROPPED, drops,
+			      DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (trap_item->action == DEVLINK_TRAP_ACTION_DROP &&
+	    devlink->ops->trap_drop_counter_get &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_PACKETS,
+			      stats.rx_packets, DEVLINK_ATTR_PAD))
+			goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_BYTES,
+			      stats.rx_bytes, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, attr);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, attr);
+	return -EMSGSIZE;
+}
+
 static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 				const struct devlink_trap_item *trap_item,
 				enum devlink_command cmd, u32 portid, u32 seq,
@@ -6857,7 +6904,7 @@ static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
-	err = devlink_trap_stats_put(msg, trap_item->stats);
+	err = devlink_trap_stats_put(msg, devlink, trap_item);
 	if (err)
 		goto nla_put_failure;
 
@@ -7074,7 +7121,7 @@ devlink_nl_trap_group_fill(struct sk_buff *msg, struct devlink *devlink,
 			group_item->policer_item->policer->id))
 		goto nla_put_failure;
 
-	err = devlink_trap_stats_put(msg, group_item->stats);
+	err = devlink_trap_group_stats_put(msg, group_item->stats);
 	if (err)
 		goto nla_put_failure;
 
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
index da49ad2761b5..ff4f3617e0c5 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
@@ -163,6 +163,16 @@ trap_stats_test()
 			devlink_trap_action_set $trap_name "drop"
 			devlink_trap_stats_idle_test $trap_name
 			check_err $? "Stats of trap $trap_name not idle when action is drop"
+
+			echo "y"> $DEBUGFS_DIR/fail_trap_drop_counter_get
+			devlink -s trap show $DEVLINK_DEV trap $trap_name &> /dev/null
+			check_fail $? "Managed to read trap (hard dropped) statistics when should not"
+			echo "n"> $DEBUGFS_DIR/fail_trap_drop_counter_get
+			devlink -s trap show $DEVLINK_DEV trap $trap_name &> /dev/null
+			check_err $? "Did not manage to read trap (hard dropped) statistics when should"
+
+			devlink_trap_drop_stats_idle_test $trap_name
+			check_fail $? "Drop stats of trap $trap_name idle when should not"
 		else
 			devlink_trap_stats_idle_test $trap_name
 			check_fail $? "Stats of non-drop trap $trap_name idle when should not"
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 9c12c4fd3afc..2094ba025af5 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -318,6 +318,14 @@ devlink_trap_rx_bytes_get()
 		| jq '.[][][]["stats"]["rx"]["bytes"]'
 }
 
+devlink_trap_drop_packets_get()
+{
+	local trap_name=$1; shift
+
+	devlink -js trap show $DEVLINK_DEV trap $trap_name \
+		| jq '.[][][]["stats"]["rx"]["dropped"]'
+}
+
 devlink_trap_stats_idle_test()
 {
 	local trap_name=$1; shift
@@ -339,6 +347,24 @@ devlink_trap_stats_idle_test()
 	fi
 }
 
+devlink_trap_drop_stats_idle_test()
+{
+	local trap_name=$1; shift
+	local t0_packets t0_bytes
+
+	t0_packets=$(devlink_trap_drop_packets_get $trap_name)
+
+	sleep 1
+
+	t1_packets=$(devlink_trap_drop_packets_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
 devlink_traps_enable_all()
 {
 	local trap_name
-- 
2.17.1

