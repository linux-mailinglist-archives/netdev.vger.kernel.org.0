Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144CA3033C7
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731247AbhAZFFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:05:17 -0500
Received: from mail-eopbgr150130.outbound.protection.outlook.com ([40.107.15.130]:15941
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728407AbhAYMvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 07:51:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OReX7tcffYQ1TRL5puztm1pYJqeW/hzbCMW5Qdva6BCrsWiX7cxbCm5yZ9/hheM/PueqeGbsCPqb3RyCuoI3TRi6Z8lnSMOEPpFIKwaf76iOL8GH+dAESbOn/OljI5SaDB3qLUNdMHTrMEFPMckm9pJ/fqw3xSKsonLQqmhH2nOVQV3v3YoS1gZvrOl0UVGOPP89L4QEBFNHsw8DL1nKLpIxMv4ULFLAYVJ4TSmi6jLrNuVX7lwJ37hIeh6w2Nor5FHLMvMEbtsUxZa37AOoIC2yE/klp4M5q9SaiUH0M1bFJLc4mpkAIehjyi7+I005v4vMbVHFMh86lzVNY54AGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuxeSiCTfhZDYbYpIu/cZ1qiQsu/1mIETbSTHakZPeo=;
 b=eyh1saB3pceD7mqx15QXmNazc75j8wvBfkzUfMWyslQTh9rMLQHWbb6Cmechnj3tzUjfjBOItNMl5CBWLf5gcDWK4aIaHv9RpQKGG+KaiMyKcESbcqdJW98EVRBYtMTWDlBUFaFcM0BfnjY576aQHhROcts1denoVtudA5s6zSFHMHPPBYha+CIn09L6W44E2Eafbwi/iuaAEVfw3rL4RD6oStp/PI+a/ZwQ6/8Ae74UP2Tnbvao0/cDomHW3VtJ2WiIHDnwkkf/0Z/WTJVdINVkJyMtHhwsXhV6d4G204nMBs5yRgHqnLfyAB1nWmQZjuOLLfxkSwBaHlnXqAoi6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuxeSiCTfhZDYbYpIu/cZ1qiQsu/1mIETbSTHakZPeo=;
 b=EBhB1457q1D713e6VUTaMtE6QyBXP7R+EHKOdul2bNbvURdjW4R4s3CYnoVw2/h+IUYdbmMFRKXaO7FxMBIWTdYlVyeqrrRQ83icJOAyj6uvsuDYqiTq+dCyk8Uw23VNM2i8m693hCGQOJK/QErnMr5w+sBpDiPWGoXFGFmN/wI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM0P190MB0642.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:197::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Mon, 25 Jan
 2021 12:31:38 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 12:31:38 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH v2 net-next] net: core: devlink: add 'dropped' stats field for DROP trap action
Date:   Mon, 25 Jan 2021 14:31:21 +0200
Message-Id: <20210125123121.1540-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM3PR04CA0143.eurprd04.prod.outlook.com (2603:10a6:207::27)
 To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM3PR04CA0143.eurprd04.prod.outlook.com (2603:10a6:207::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 12:31:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dc17799-02b7-4ec3-d5e7-08d8c12d293c
X-MS-TrafficTypeDiagnostic: AM0P190MB0642:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0P190MB064239272A718F0367EE1E18E4BD0@AM0P190MB0642.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w4Y5N4mCO3E2HEiU2sb1Ib3wIcXoNLgQs2ewdCpQ8vcnIm6UWlikN0BSTJ8y0RusYeSsCNqUzaLdU9IaLSTYVxQVyPj12ub5R7UYuPZPywg6Jmg1NwwtllQ266FfuC1bkflaQzZorl8FrCZmRdF2WTBakA+FFHF8CIP8+8sQlJmKsAl7OYwtONsYJAr0H8/RBBOrdvKAe8q9ajTLZ8DjWiDaU6v30l6g9CnJsghXvfD2VDszuRXAKiL8zGk9/98cIwGlEmK5zxSrQWA7dzkes4rGuFoxptk9D69OW/gxatzdYTEUlORoKy0SfQ8s0U9IUqPmHM7QegGLhcZVUG2wmJ3FgUPePjgVSw3Ht1DEhSCTrNqDUp+dBJdaqHNVlcXzw1ZoZxsEWVkkSobl9b8fHYJxxVRU6HbqnqHtCmhoTzmLUpPXTRO77ydLwyThl7i4Ca0VauwN/vSdATfWixKWQIp0aDJ2e5J7fOqlA4m/Y18X9pPv0qJhg/342NgZqVbfFlLTal4aXpTGXfJ5Rfe/fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(39830400003)(366004)(52116002)(86362001)(66556008)(478600001)(186003)(8676002)(6506007)(4326008)(6512007)(6666004)(26005)(107886003)(6486002)(16526019)(8936002)(1076003)(6916009)(66946007)(44832011)(316002)(2906002)(956004)(2616005)(83380400001)(66476007)(5660300002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UQkm/j/KXjKvJk/2fgfq9l8d7BENIJ0RlfqEH6QL6ima99kFPhtldlpNwell?=
 =?us-ascii?Q?NMDJRwQkCoh90KfSU7Js8K9qeiNBFGcOZ729BmeZh82FCp4/9GjTrSrADCmR?=
 =?us-ascii?Q?uOW+Sm0b2yQuWwrTuRB1Hv6uiu8ZC3sStSRQwSLS8jlwnr4itNhXiel8rOTc?=
 =?us-ascii?Q?tLi4Y1mxyLp4owLTax7YkwJyGcTPddxrMPABo01GW+nGjFfvkiXte5z3gtP/?=
 =?us-ascii?Q?kesXRd2mk+Z+oZ0tx7+r/rjI+DKc+4UD8WCB9RgFlOWayfB1EmnkmvBeF2dK?=
 =?us-ascii?Q?xpjmfb3di2mmebOuU8tDfbdHrgfLXGeEtbzV3YTkQ/dexjWD+IJu1LkDwjp6?=
 =?us-ascii?Q?AUmGKZR+thCDJKRf8d8PHu/eDVYjEOjdWCMCSZvwRO7QWoCrX5+4eJ42ZxD5?=
 =?us-ascii?Q?OcIYFm1Rt55LSc9DgLHVioD6X4ETZSV6qCWR82VuN/KKwyfV+2GLy+zhWSJK?=
 =?us-ascii?Q?eNoAilC18pGB+xKF3kSlbM2paASCMeFtANMGz2XaTEllc3WiOdYleypIKK5K?=
 =?us-ascii?Q?LX7DWm2fjZmRmRUtzIcEmoada9UNlrKwrR9zmUUyLyw7VU2lng1zXslmOF2x?=
 =?us-ascii?Q?PPCvc3klnv180A/qGIpt0YsXhmi5J6oHSNXF08yL3SLaE9828gqgBF/rZSL/?=
 =?us-ascii?Q?+uBL73/rycO+88xaSoCZpy4dozYR79aRMYJUNMrWPG4iLG/NnJv5ML7r9/od?=
 =?us-ascii?Q?1VHcbvKP0l/9+JsktTmHE3TtId3gQMDznfG+AnyYaGkHvG/z3y0QenxVvfxg?=
 =?us-ascii?Q?RPs678A1minPmFaLETjDkdDbPj84NkhjuCh9oJGjQgLDAX/FYEWYXD4srO+b?=
 =?us-ascii?Q?Fgh/zkpnipKtby7IslDmYFdaWXRUE6vXrRwM1od+sWsUq3Ghmz0AEMkdZhqZ?=
 =?us-ascii?Q?sdbdyLdiF0j/Nkb3CUSgE74NYE+8vuXzA3RiEa0x5cWDIb3zWUWdVQY4uB8L?=
 =?us-ascii?Q?z/xEGWWf0xSoGL3J38wdiQ+boF1LAtYGw54nhW2mNIkbrRo7jrknqiJ49I7/?=
 =?us-ascii?Q?0LR2nRfpU3aypqiUm34OV3MvB4w3ogM9VpzNwHNJ1pvk/hOZp4H7bSmSMuKr?=
 =?us-ascii?Q?5/rcFr0E?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc17799-02b7-4ec3-d5e7-08d8c12d293c
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 12:31:38.4627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xrWlZ+VQeGlG8GuHENia+qonetNbDs5HeqYGOf3WN+Z3PrHwS8VPSgbtSeb4kuxzCtxQXknWFtGLieGYRVPqPgEDIGtTuCK2znKkhTxcmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0642
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

