Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2C930BFA7
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbhBBNhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:37:31 -0500
Received: from mail-vi1eur05on2119.outbound.protection.outlook.com ([40.107.21.119]:25206
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232585AbhBBNfu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 08:35:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXN5yLSpXQ24r6eVgLtD8HItrJPa/mtFCugMjaIOf2RUx2lvBasp6Lbwqey5vmKaSp/JtJOH3eQ68KG++tw884zYC0earffAOSPLeuwhMRycrcdzQejpUz3N1f2HgZrn12esXjzzH0LBhStqXQK9J16odi4k/3wU6fSxtZ8j2+M0I4ckNtQFQYfuRdNujfj+dXktZvt5KCjxUSg4txSmAePisTLu7uyvWKIjwfPcyQm2/o3XrzxFlRKyHcHtMHGILIGoIF5vZs/0RG9jB3X/CNCspZakbUi8l4lud07rjRt5H92nshzDE+m1oqgkmsEqgsasqSVHAwBc71IE/tooDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aq7CwNBR/yYyUnZqimpP8SQMqXTWx7CgDTodNSjVXJE=;
 b=FOKjZzv2GqdevJ7MHi5E7cEVNnRXkrcOd7LBp4FiYxIbXkYiZwk8nLaIxGBMsLOncRSPjxnAZsLwanSLShCPgjM8NAuES3c3GyGvrcds5DjLUEB8D+PmmFDdVoi/nyyblu9Z09GpwTuaRFPZshc15Xi2VuC3egW5py3uco74Dj5847hADsda2VTf2R/cUEejT142nkxLFa1ghnyJqNwRurvfT58MHIN2rIEEiD6iBREjfn1iU0ohMvrEvf6FDs15c20IVVOvcOPzh30U/zJWu6uIiZ+PsnG6wFezT4EIrXN+hEET5VoBestHeNeHkm3+UHq7e5WBdDbFBAMnmlJdfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aq7CwNBR/yYyUnZqimpP8SQMqXTWx7CgDTodNSjVXJE=;
 b=vO7GaElTHKGr2c/q826P59kWri3rrK80oDDnyjPdjX3SmkpceUQZANulfhofIAqQKzGBjc2DExLVC/ThPW/DJ007ZtPwII9tzrquLGTRQ9UU86pfuuO1oulyBFRiFiBhdO5LSXLLWd8TYPTxbOawC+bT2d1BRksN7xTmVoAkbHE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1044.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:267::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 2 Feb
 2021 13:35:01 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 13:35:01 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, idosch@idosch.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [RFC v4 net-next] net: core: devlink: add 'dropped' stats field for traps
Date:   Tue,  2 Feb 2021 15:34:52 +0200
Message-Id: <20210202133452.17626-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P191CA0085.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::26) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM6P191CA0085.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 2 Feb 2021 13:35:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5946767b-08a3-4d68-2607-08d8c77f571a
X-MS-TrafficTypeDiagnostic: AM9P190MB1044:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1044354B2708E23BBDB6697BE4B59@AM9P190MB1044.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qTtUNflVUDyz6xWNm6qCa6akZjBLFSUx3k0fCsrwnj7GUI9eU7+WNkOneEbWW+ZJYaZepHhe/yMOl53Nb+FreUXotrXQEIRYv90bel65KeV+avbupw/fzNpXCW8FEL0kbk40r4I8dp3oDZ7G9dvFR5tSkRKIXQlyXvoeLq6UnIsKe60dcZriuqnjuk5CalcI0M3GaY5uykj2rn2ApXoX/dDakHaBIDUvY3/Q+gVfdZrRsf9CMzgn3DM/DrVXTPfHYiM/SEEsgD3LWgu88CCF13Ze2g5j5O8OmgosgIl6YUX24IxT0/97JOiE+s97+xHdRP78y7ZNhZNj81bVfjJ0cAJtrPRFkBriH9gNlAsqpa7duDUIa1tLkrij/XLDTrFBMHI5TatPTynZz99QajHgJXJbbPgAKvwVenv86kG+jKgsZaemfw/z14aPjYSd7YDs6Ahh+T9bFIuUf22JDfyzK+o5wz2sjBEiCevtUebOeDmJUfNC+5hf8lJbTcMcNikosCvydqKcgNfLzBdlImHv+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(39830400003)(136003)(2616005)(6916009)(86362001)(2906002)(36756003)(44832011)(52116002)(26005)(8936002)(956004)(66946007)(6506007)(478600001)(66476007)(66556008)(16526019)(186003)(316002)(6666004)(1076003)(5660300002)(6512007)(6486002)(83380400001)(4326008)(107886003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RQkydKYARQ4a5tRCfHdcKtDKIt/RGzMtAnvJ4nwyNHbKS9TFgLY2AYxqPu+q?=
 =?us-ascii?Q?WdzafcgEbY4Vw+x98Fq8cDX/TjEJy0Mh9zmamD/3Vnxu66hT78Q/o5VUzRwd?=
 =?us-ascii?Q?o0LaktJlcY5hrQe+usMeYLvh6LZoojjtwCAb1g1N1aEHY3eXBgycNhnUBAQ1?=
 =?us-ascii?Q?bLEqIS1VobZ3xq9x5r/7914jASpt17MhFq5y58M6wlgYrQH1bxejBOXUK7jm?=
 =?us-ascii?Q?y2+2M+od+C5KD87zLzBWbcXG8pw9C4JcLFuERbnpGywjbCNJwgUqRnew3D4I?=
 =?us-ascii?Q?xhwik5eTKHGZrTMi/15g5upUFSxVA2SRQqG/sfGp0j/q4I0O9pIWjVH9ar2Z?=
 =?us-ascii?Q?gO4udyPrFK9rSajOFr2zlOTlgxVu63DkZC6p2k1RgpZqZV5kvT03+qlyqoE5?=
 =?us-ascii?Q?apGr0gF84j5wX8rWv7QsO4UrsPvz3fUfiBkBT6G2d3HnY13V3XBNYeiph1+d?=
 =?us-ascii?Q?lN7Gw7riJKkkSVia3I1ST4PxO+XrylwCBfAlbC/X0vvGvTjrIOZ1ZBzWs058?=
 =?us-ascii?Q?bxhzkPJ4qAi/3Fw7rXCncex9pxNQSqdANFIlEMIoKE3KJiawDiXoThb0H3tw?=
 =?us-ascii?Q?e8pJGAXcU711iQ+n3EIe1w1A7ZN0nzeGMt5t43Vt3AgTgg6/d1C+A/PdvneX?=
 =?us-ascii?Q?fezCM4HOB9SIhrcz07bFXtaFR9Z96Rd4nKN6LI2qwOUxsAW8wedX8BHOCBgk?=
 =?us-ascii?Q?jTBtajUOZdKCrNXoo/JoA+KqLgPFGhU6oZg5dAyqgKGT1pY8ZIS79Ysm0cq0?=
 =?us-ascii?Q?ou1bDm5+1oT+IwM9Pz+p/W1orciRrQ/Sir7ZYHDCe9emE+8omMukC1v1NTly?=
 =?us-ascii?Q?NELWlMAPchNCDDpwrrnydGmAuyCWW0UChuX1MlYSFy3KVN7bKYnUiQXnzR5v?=
 =?us-ascii?Q?+LDjOGXFYujvbfU8EvP/PJvEGTQIEKfzUBrPUidrARmgBtJIPg3eOF0v6NMn?=
 =?us-ascii?Q?HNGQzkEnoUnP8Grhqy05QK3fzn53udx4qDp1a/abgEgbBpyl/3fA/Zv8vrJ8?=
 =?us-ascii?Q?efBxRMqs5bBtP3f3wcrNajBXZKsIC9wnH6ed3bskLPYH7Q0srSBxjVAYnBNw?=
 =?us-ascii?Q?Z8XVEAqY?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 5946767b-08a3-4d68-2607-08d8c77f571a
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 13:35:01.0842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJTHbTxFBBFvOiGLvLGABExpVravWduk+agbkWvFireZHH/rEWKvU2wH4xsyWRARhrZHzDSaD8NSXjpxzb+FZcP2Li1fFDe6xOl8IxomxMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever query statistics is issued for trap, devlink subsystem
would also fill-in statistics 'dropped' field. This field indicates
the number of packets HW dropped and failed to report to the device driver,
and thus - to the devlink subsystem itself.
In case if device driver didn't register callback for hard drop
statistics querying, 'dropped' field will be omitted and not filled.
Add trap_drop_counter_get callback implementation to the netdevsim.
Add new test cases for netdevsim, to test both the callback
functionality, as well as drop statistics alteration check.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
V4:
    1) Change commit description / subject.
    2) Change 'dropped' statistics fill condition from
       'trap_drop_counter_get is registered' && 'trap action == drop'
       to
       'trap_drop_counter_get is registered'.
    3) Fix statistics fill condition used for wrong stats attribute:
       DEVLINK_ATTR_STATS_RX_PACKETS -> DEVLINK_ATTR_STATS_RX_DROPPED
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
---
 drivers/net/netdevsim/dev.c                   | 21 ++++++++
 drivers/net/netdevsim/netdevsim.h             |  1 +
 include/net/devlink.h                         | 10 ++++
 net/core/devlink.c                            | 53 +++++++++++++++++--
 .../drivers/net/netdevsim/devlink_trap.sh     | 10 ++++
 .../selftests/net/forwarding/devlink_lib.sh   | 26 +++++++++
 6 files changed, 117 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 816af1f55e2c..8cdd3541be0e 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -231,6 +231,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
+	debugfs_create_bool("fail_trap_counter_get", 0600,
+			    nsim_dev->ddir,
+			    &nsim_dev->fail_trap_counter_get);
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 }
@@ -416,6 +419,7 @@ struct nsim_trap_data {
 	struct delayed_work trap_report_dw;
 	struct nsim_trap_item *trap_items_arr;
 	u64 *trap_policers_cnt_arr;
+	u64 trap_pkt_cnt;
 	struct nsim_dev *nsim_dev;
 	spinlock_t trap_lock;	/* Protects trap_items_arr */
 };
@@ -892,6 +896,22 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 	return 0;
 }
 
+int nsim_dev_devlink_trap_hw_counter_get(struct devlink *devlink,
+					 const struct devlink_trap *trap,
+					 u64 *p_drops)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	u64 *cnt;
+
+	if (nsim_dev->fail_trap_counter_get)
+		return -EINVAL;
+
+	cnt = &nsim_dev->trap_data->trap_pkt_cnt;
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
+	.trap_drop_counter_get = nsim_dev_devlink_trap_hw_counter_get,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 48163c5f2ec9..f9aa8429549a 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -219,6 +219,7 @@ struct nsim_dev {
 	bool fail_trap_group_set;
 	bool fail_trap_policer_set;
 	bool fail_trap_policer_counter_get;
+	bool fail_trap_counter_get;
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
index ee828e4b1007..f59c49c070c8 100644
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
@@ -6820,6 +6821,50 @@ static int devlink_trap_stats_put(struct sk_buff *msg,
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
+	if (devlink->ops->trap_drop_counter_get) {
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
+	if (devlink->ops->trap_drop_counter_get &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_DROPPED, drops,
+			      DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_PACKETS,
+			      stats.rx_packets, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
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
@@ -6857,7 +6902,7 @@ static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
-	err = devlink_trap_stats_put(msg, trap_item->stats);
+	err = devlink_trap_stats_put(msg, devlink, trap_item);
 	if (err)
 		goto nla_put_failure;
 
@@ -7074,7 +7119,7 @@ devlink_nl_trap_group_fill(struct sk_buff *msg, struct devlink *devlink,
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

