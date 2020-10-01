Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA5B280AAA
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 00:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733267AbgJAW7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 18:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733120AbgJAW7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 18:59:45 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F3920872;
        Thu,  1 Oct 2020 22:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601593183;
        bh=nV3lTbbn3NkLMFwuZ2wI5Cfj5upfFd79pvMOsTDBzq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyvCK6YJ9kf+dPMEcSd0/0xSYzoYGVhqXHq9M9fUv+B0A3b3kHCaEQtu/lBqE5p1d
         IVTCgKh7wfvbLUKrYf86ZKroynTAaBvrAkqwAFFFhCtjoBMBLc4FBlkouRZxo7cuAO
         63kU6G7xhuqmFienssS4MDW4pzlCHW4ju61axMTU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 03/10] genetlink: move to smaller ops wherever possible
Date:   Thu,  1 Oct 2020 15:59:26 -0700
Message-Id: <20201001225933.1373426-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001225933.1373426-1-kuba@kernel.org>
References: <20201001225933.1373426-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bulk of the genetlink users can use smaller ops, move them.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/block/nbd.c                      |  6 +++---
 drivers/net/gtp.c                        |  6 +++---
 drivers/net/ieee802154/mac802154_hwsim.c |  6 +++---
 drivers/net/macsec.c                     |  6 +++---
 drivers/net/team/team.c                  |  6 +++---
 drivers/net/wireless/mac80211_hwsim.c    |  6 +++---
 drivers/target/target_core_user.c        |  6 +++---
 drivers/thermal/thermal_netlink.c        |  6 +++---
 fs/dlm/netlink.c                         |  6 +++---
 kernel/taskstats.c                       |  6 +++---
 net/batman-adv/netlink.c                 |  6 +++---
 net/core/devlink.c                       |  6 +++---
 net/core/drop_monitor.c                  |  6 +++---
 net/hsr/hsr_netlink.c                    |  6 +++---
 net/ieee802154/netlink.c                 |  6 +++---
 net/ipv4/fou.c                           |  6 +++---
 net/ipv4/tcp_metrics.c                   |  6 +++---
 net/l2tp/l2tp_netlink.c                  |  6 +++---
 net/mptcp/pm_netlink.c                   |  6 +++---
 net/ncsi/ncsi-netlink.c                  |  6 +++---
 net/netfilter/ipvs/ip_vs_ctl.c           |  6 +++---
 net/netlabel/netlabel_calipso.c          |  6 +++---
 net/netlabel/netlabel_cipso_v4.c         |  6 +++---
 net/netlabel/netlabel_mgmt.c             |  6 +++---
 net/netlabel/netlabel_unlabeled.c        |  6 +++---
 net/openvswitch/conntrack.c              |  6 +++---
 net/openvswitch/datapath.c               | 24 ++++++++++++------------
 net/openvswitch/meter.c                  |  6 +++---
 net/psample/psample.c                    |  6 +++---
 net/tipc/netlink_compat.c                |  6 +++---
 net/wimax/stack.c                        |  6 +++---
 net/wireless/nl80211.c                   |  5 +++++
 32 files changed, 107 insertions(+), 102 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index edf8b632e3d2..ab2bbe2208ef 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -2183,7 +2183,7 @@ static int nbd_genl_reconfigure(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-static const struct genl_ops nbd_connect_genl_ops[] = {
+static const struct genl_small_ops nbd_connect_genl_ops[] = {
 	{
 		.cmd	= NBD_CMD_CONNECT,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -2215,8 +2215,8 @@ static struct genl_family nbd_genl_family __ro_after_init = {
 	.name		= NBD_GENL_FAMILY_NAME,
 	.version	= NBD_GENL_VERSION,
 	.module		= THIS_MODULE,
-	.ops		= nbd_connect_genl_ops,
-	.n_ops		= ARRAY_SIZE(nbd_connect_genl_ops),
+	.small_ops	= nbd_connect_genl_ops,
+	.n_small_ops	= ARRAY_SIZE(nbd_connect_genl_ops),
 	.maxattr	= NBD_ATTR_MAX,
 	.policy = nbd_attr_policy,
 	.mcgrps		= nbd_mcast_grps,
diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 611722eafed8..c09fe18c6c52 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1339,7 +1339,7 @@ static const struct nla_policy gtp_genl_policy[GTPA_MAX + 1] = {
 	[GTPA_O_TEI]		= { .type = NLA_U32, },
 };
 
-static const struct genl_ops gtp_genl_ops[] = {
+static const struct genl_small_ops gtp_genl_ops[] = {
 	{
 		.cmd = GTP_CMD_NEWPDP,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -1369,8 +1369,8 @@ static struct genl_family gtp_genl_family __ro_after_init = {
 	.policy = gtp_genl_policy,
 	.netnsok	= true,
 	.module		= THIS_MODULE,
-	.ops		= gtp_genl_ops,
-	.n_ops		= ARRAY_SIZE(gtp_genl_ops),
+	.small_ops	= gtp_genl_ops,
+	.n_small_ops	= ARRAY_SIZE(gtp_genl_ops),
 	.mcgrps		= gtp_genl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(gtp_genl_mcgrps),
 };
diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index c20e7ef18bc9..c0bf7d78276e 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -583,7 +583,7 @@ static const struct nla_policy hwsim_genl_policy[MAC802154_HWSIM_ATTR_MAX + 1] =
 };
 
 /* Generic Netlink operations array */
-static const struct genl_ops hwsim_nl_ops[] = {
+static const struct genl_small_ops hwsim_nl_ops[] = {
 	{
 		.cmd = MAC802154_HWSIM_CMD_NEW_RADIO,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -628,8 +628,8 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
 	.maxattr = MAC802154_HWSIM_ATTR_MAX,
 	.policy = hwsim_genl_policy,
 	.module = THIS_MODULE,
-	.ops = hwsim_nl_ops,
-	.n_ops = ARRAY_SIZE(hwsim_nl_ops),
+	.small_ops = hwsim_nl_ops,
+	.n_small_ops = ARRAY_SIZE(hwsim_nl_ops),
 	.mcgrps = hwsim_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(hwsim_mcgrps),
 };
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 124045cbcda3..3f4d8c6625de 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3285,7 +3285,7 @@ static int macsec_dump_txsc(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static const struct genl_ops macsec_genl_ops[] = {
+static const struct genl_small_ops macsec_genl_ops[] = {
 	{
 		.cmd = MACSEC_CMD_GET_TXSC,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -3361,8 +3361,8 @@ static struct genl_family macsec_fam __ro_after_init = {
 	.policy = macsec_genl_policy,
 	.netnsok	= true,
 	.module		= THIS_MODULE,
-	.ops		= macsec_genl_ops,
-	.n_ops		= ARRAY_SIZE(macsec_genl_ops),
+	.small_ops	= macsec_genl_ops,
+	.n_small_ops	= ARRAY_SIZE(macsec_genl_ops),
 };
 
 static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8c1e02752ff6..a0c8c2fe6c3e 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2795,7 +2795,7 @@ static int team_nl_cmd_port_list_get(struct sk_buff *skb,
 	return err;
 }
 
-static const struct genl_ops team_nl_ops[] = {
+static const struct genl_small_ops team_nl_ops[] = {
 	{
 		.cmd = TEAM_CMD_NOOP,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -2832,8 +2832,8 @@ static struct genl_family team_nl_family __ro_after_init = {
 	.policy = team_nl_policy,
 	.netnsok	= true,
 	.module		= THIS_MODULE,
-	.ops		= team_nl_ops,
-	.n_ops		= ARRAY_SIZE(team_nl_ops),
+	.small_ops	= team_nl_ops,
+	.n_small_ops	= ARRAY_SIZE(team_nl_ops),
 	.mcgrps		= team_nl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(team_nl_mcgrps),
 };
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index dce3bc9c9f84..7a86145b8226 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3886,7 +3886,7 @@ static int hwsim_dump_radio_nl(struct sk_buff *skb,
 }
 
 /* Generic Netlink operations array */
-static const struct genl_ops hwsim_ops[] = {
+static const struct genl_small_ops hwsim_ops[] = {
 	{
 		.cmd = HWSIM_CMD_REGISTER,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -3930,8 +3930,8 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
 	.policy = hwsim_genl_policy,
 	.netnsok = true,
 	.module = THIS_MODULE,
-	.ops = hwsim_ops,
-	.n_ops = ARRAY_SIZE(hwsim_ops),
+	.small_ops = hwsim_ops,
+	.n_small_ops = ARRAY_SIZE(hwsim_ops),
 	.mcgrps = hwsim_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(hwsim_mcgrps),
 };
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9b7592350502..1a060a2c98d6 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -436,7 +436,7 @@ static int tcmu_genl_set_features(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-static const struct genl_ops tcmu_genl_ops[] = {
+static const struct genl_small_ops tcmu_genl_ops[] = {
 	{
 		.cmd	= TCMU_CMD_SET_FEATURES,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -474,8 +474,8 @@ static struct genl_family tcmu_genl_family __ro_after_init = {
 	.mcgrps = tcmu_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(tcmu_mcgrps),
 	.netnsok = true,
-	.ops = tcmu_genl_ops,
-	.n_ops = ARRAY_SIZE(tcmu_genl_ops),
+	.small_ops = tcmu_genl_ops,
+	.n_small_ops = ARRAY_SIZE(tcmu_genl_ops),
 };
 
 #define tcmu_cmd_set_dbi_cur(cmd, index) ((cmd)->dbi_cur = (index))
diff --git a/drivers/thermal/thermal_netlink.c b/drivers/thermal/thermal_netlink.c
index e9999d5dfdd5..da2891fcac89 100644
--- a/drivers/thermal/thermal_netlink.c
+++ b/drivers/thermal/thermal_netlink.c
@@ -601,7 +601,7 @@ static int thermal_genl_cmd_doit(struct sk_buff *skb,
 	return ret;
 }
 
-static const struct genl_ops thermal_genl_ops[] = {
+static const struct genl_small_ops thermal_genl_ops[] = {
 	{
 		.cmd = THERMAL_GENL_CMD_TZ_GET_ID,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -635,8 +635,8 @@ static struct genl_family thermal_gnl_family __ro_after_init = {
 	.version	= THERMAL_GENL_VERSION,
 	.maxattr	= THERMAL_GENL_ATTR_MAX,
 	.policy		= thermal_genl_policy,
-	.ops		= thermal_genl_ops,
-	.n_ops		= ARRAY_SIZE(thermal_genl_ops),
+	.small_ops	= thermal_genl_ops,
+	.n_small_ops	= ARRAY_SIZE(thermal_genl_ops),
 	.mcgrps		= thermal_genl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(thermal_genl_mcgrps),
 };
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index e338c407cb75..67f68d48d60c 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -62,7 +62,7 @@ static int user_cmd(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-static const struct genl_ops dlm_nl_ops[] = {
+static const struct genl_small_ops dlm_nl_ops[] = {
 	{
 		.cmd	= DLM_CMD_HELLO,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -73,8 +73,8 @@ static const struct genl_ops dlm_nl_ops[] = {
 static struct genl_family family __ro_after_init = {
 	.name		= DLM_GENL_NAME,
 	.version	= DLM_GENL_VERSION,
-	.ops		= dlm_nl_ops,
-	.n_ops		= ARRAY_SIZE(dlm_nl_ops),
+	.small_ops	= dlm_nl_ops,
+	.n_small_ops	= ARRAY_SIZE(dlm_nl_ops),
 	.module		= THIS_MODULE,
 };
 
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index e2ac0e37c4ae..ef4de29fbe8a 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -644,7 +644,7 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 	nlmsg_free(rep_skb);
 }
 
-static const struct genl_ops taskstats_ops[] = {
+static const struct genl_small_ops taskstats_ops[] = {
 	{
 		.cmd		= TASKSTATS_CMD_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -687,8 +687,8 @@ static struct genl_family family __ro_after_init = {
 	.version	= TASKSTATS_GENL_VERSION,
 	.maxattr	= TASKSTATS_CMD_ATTR_MAX,
 	.module		= THIS_MODULE,
-	.ops		= taskstats_ops,
-	.n_ops		= ARRAY_SIZE(taskstats_ops),
+	.small_ops	= taskstats_ops,
+	.n_small_ops	= ARRAY_SIZE(taskstats_ops),
 	.pre_doit	= taskstats_pre_doit,
 };
 
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index dc193618a761..c7a55647b520 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -1350,7 +1350,7 @@ static void batadv_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 	}
 }
 
-static const struct genl_ops batadv_netlink_ops[] = {
+static const struct genl_small_ops batadv_netlink_ops[] = {
 	{
 		.cmd = BATADV_CMD_GET_MESH,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -1484,8 +1484,8 @@ struct genl_family batadv_netlink_family __ro_after_init = {
 	.pre_doit = batadv_pre_doit,
 	.post_doit = batadv_post_doit,
 	.module = THIS_MODULE,
-	.ops = batadv_netlink_ops,
-	.n_ops = ARRAY_SIZE(batadv_netlink_ops),
+	.small_ops = batadv_netlink_ops,
+	.n_small_ops = ARRAY_SIZE(batadv_netlink_ops),
 	.mcgrps = batadv_netlink_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(batadv_netlink_mcgrps),
 };
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6f2863e717a9..09442ab012ae 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7121,7 +7121,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
 };
 
-static const struct genl_ops devlink_nl_ops[] = {
+static const struct genl_small_ops devlink_nl_ops[] = {
 	{
 		.cmd = DEVLINK_CMD_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -7446,8 +7446,8 @@ static struct genl_family devlink_nl_family __ro_after_init = {
 	.pre_doit	= devlink_nl_pre_doit,
 	.post_doit	= devlink_nl_post_doit,
 	.module		= THIS_MODULE,
-	.ops		= devlink_nl_ops,
-	.n_ops		= ARRAY_SIZE(devlink_nl_ops),
+	.small_ops	= devlink_nl_ops,
+	.n_small_ops	= ARRAY_SIZE(devlink_nl_ops),
 	.mcgrps		= devlink_nl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
 };
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index a28b743489c5..571f191c06d9 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1575,7 +1575,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
 	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
 };
 
-static const struct genl_ops dropmon_ops[] = {
+static const struct genl_small_ops dropmon_ops[] = {
 	{
 		.cmd = NET_DM_CMD_CONFIG,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -1625,8 +1625,8 @@ static struct genl_family net_drop_monitor_family __ro_after_init = {
 	.pre_doit	= net_dm_nl_pre_doit,
 	.post_doit	= net_dm_nl_post_doit,
 	.module		= THIS_MODULE,
-	.ops		= dropmon_ops,
-	.n_ops		= ARRAY_SIZE(dropmon_ops),
+	.small_ops	= dropmon_ops,
+	.n_small_ops	= ARRAY_SIZE(dropmon_ops),
 	.mcgrps		= dropmon_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(dropmon_mcgrps),
 };
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 0e4681cf71db..f3c8f91dbe2c 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -493,7 +493,7 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	return res;
 }
 
-static const struct genl_ops hsr_ops[] = {
+static const struct genl_small_ops hsr_ops[] = {
 	{
 		.cmd = HSR_C_GET_NODE_STATUS,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -518,8 +518,8 @@ static struct genl_family hsr_genl_family __ro_after_init = {
 	.policy = hsr_genl_policy,
 	.netnsok = true,
 	.module = THIS_MODULE,
-	.ops = hsr_ops,
-	.n_ops = ARRAY_SIZE(hsr_ops),
+	.small_ops = hsr_ops,
+	.n_small_ops = ARRAY_SIZE(hsr_ops),
 	.mcgrps = hsr_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(hsr_mcgrps),
 };
diff --git a/net/ieee802154/netlink.c b/net/ieee802154/netlink.c
index 7fe3b6b6c495..b07abc38b4b3 100644
--- a/net/ieee802154/netlink.c
+++ b/net/ieee802154/netlink.c
@@ -81,7 +81,7 @@ int ieee802154_nl_reply(struct sk_buff *msg, struct genl_info *info)
 	return genlmsg_reply(msg, info);
 }
 
-static const struct genl_ops ieee802154_ops[] = {
+static const struct genl_small_ops ieee802154_ops[] = {
 	/* see nl-phy.c */
 	IEEE802154_DUMP(IEEE802154_LIST_PHY, ieee802154_list_phy,
 			ieee802154_dump_phy),
@@ -130,8 +130,8 @@ struct genl_family nl802154_family __ro_after_init = {
 	.maxattr	= IEEE802154_ATTR_MAX,
 	.policy		= ieee802154_policy,
 	.module		= THIS_MODULE,
-	.ops		= ieee802154_ops,
-	.n_ops		= ARRAY_SIZE(ieee802154_ops),
+	.small_ops	= ieee802154_ops,
+	.n_small_ops	= ARRAY_SIZE(ieee802154_ops),
 	.mcgrps		= ieee802154_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(ieee802154_mcgrps),
 };
diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 5308cfa3de62..e5f69b0bf3df 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -911,7 +911,7 @@ static int fou_nl_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static const struct genl_ops fou_nl_ops[] = {
+static const struct genl_small_ops fou_nl_ops[] = {
 	{
 		.cmd = FOU_CMD_ADD,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -940,8 +940,8 @@ static struct genl_family fou_nl_family __ro_after_init = {
 	.policy = fou_nl_policy,
 	.netnsok	= true,
 	.module		= THIS_MODULE,
-	.ops		= fou_nl_ops,
-	.n_ops		= ARRAY_SIZE(fou_nl_ops),
+	.small_ops	= fou_nl_ops,
+	.n_small_ops	= ARRAY_SIZE(fou_nl_ops),
 };
 
 size_t fou_encap_hlen(struct ip_tunnel_encap *e)
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 279db8822439..6b27c481fe18 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -943,7 +943,7 @@ static int tcp_metrics_nl_cmd_del(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-static const struct genl_ops tcp_metrics_nl_ops[] = {
+static const struct genl_small_ops tcp_metrics_nl_ops[] = {
 	{
 		.cmd = TCP_METRICS_CMD_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -966,8 +966,8 @@ static struct genl_family tcp_metrics_nl_family __ro_after_init = {
 	.policy = tcp_metrics_nl_policy,
 	.netnsok	= true,
 	.module		= THIS_MODULE,
-	.ops		= tcp_metrics_nl_ops,
-	.n_ops		= ARRAY_SIZE(tcp_metrics_nl_ops),
+	.small_ops	= tcp_metrics_nl_ops,
+	.n_small_ops	= ARRAY_SIZE(tcp_metrics_nl_ops),
 };
 
 static unsigned int tcpmhash_entries;
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 5ca5056e9636..83956c9ee1fc 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -914,7 +914,7 @@ static const struct nla_policy l2tp_nl_policy[L2TP_ATTR_MAX + 1] = {
 	},
 };
 
-static const struct genl_ops l2tp_nl_ops[] = {
+static const struct genl_small_ops l2tp_nl_ops[] = {
 	{
 		.cmd = L2TP_CMD_NOOP,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -981,8 +981,8 @@ static struct genl_family l2tp_nl_family __ro_after_init = {
 	.policy = l2tp_nl_policy,
 	.netnsok	= true,
 	.module		= THIS_MODULE,
-	.ops		= l2tp_nl_ops,
-	.n_ops		= ARRAY_SIZE(l2tp_nl_ops),
+	.small_ops	= l2tp_nl_ops,
+	.n_small_ops	= ARRAY_SIZE(l2tp_nl_ops),
 	.mcgrps		= l2tp_multicast_group,
 	.n_mcgrps	= ARRAY_SIZE(l2tp_multicast_group),
 };
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 5a0e4d11bcc3..9f9cd41b7733 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1054,7 +1054,7 @@ mptcp_nl_cmd_get_limits(struct sk_buff *skb, struct genl_info *info)
 	return -EMSGSIZE;
 }
 
-static struct genl_ops mptcp_pm_ops[] = {
+static struct genl_small_ops mptcp_pm_ops[] = {
 	{
 		.cmd    = MPTCP_PM_CMD_ADD_ADDR,
 		.doit   = mptcp_nl_cmd_add_addr,
@@ -1093,8 +1093,8 @@ static struct genl_family mptcp_genl_family __ro_after_init = {
 	.policy		= mptcp_pm_policy,
 	.netnsok	= true,
 	.module		= THIS_MODULE,
-	.ops		= mptcp_pm_ops,
-	.n_ops		= ARRAY_SIZE(mptcp_pm_ops),
+	.small_ops	= mptcp_pm_ops,
+	.n_small_ops	= ARRAY_SIZE(mptcp_pm_ops),
 	.mcgrps		= mptcp_pm_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(mptcp_pm_mcgrps),
 };
diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index 8b386d766e7d..adddc7707aa4 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -716,7 +716,7 @@ static int ncsi_set_channel_mask_nl(struct sk_buff *msg,
 	return 0;
 }
 
-static const struct genl_ops ncsi_ops[] = {
+static const struct genl_small_ops ncsi_ops[] = {
 	{
 		.cmd = NCSI_CMD_PKG_INFO,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -762,8 +762,8 @@ static struct genl_family ncsi_genl_family __ro_after_init = {
 	.maxattr = NCSI_ATTR_MAX,
 	.policy = ncsi_genl_policy,
 	.module = THIS_MODULE,
-	.ops = ncsi_ops,
-	.n_ops = ARRAY_SIZE(ncsi_ops),
+	.small_ops = ncsi_ops,
+	.n_small_ops = ARRAY_SIZE(ncsi_ops),
 };
 
 int ncsi_init_netlink(struct net_device *dev)
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 8dbfd84322a8..e279ded4e306 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3893,7 +3893,7 @@ static int ip_vs_genl_get_cmd(struct sk_buff *skb, struct genl_info *info)
 }
 
 
-static const struct genl_ops ip_vs_genl_ops[] = {
+static const struct genl_small_ops ip_vs_genl_ops[] = {
 	{
 		.cmd	= IPVS_CMD_NEW_SERVICE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -4001,8 +4001,8 @@ static struct genl_family ip_vs_genl_family __ro_after_init = {
 	.policy = ip_vs_cmd_policy,
 	.netnsok        = true,         /* Make ipvsadm to work on netns */
 	.module		= THIS_MODULE,
-	.ops		= ip_vs_genl_ops,
-	.n_ops		= ARRAY_SIZE(ip_vs_genl_ops),
+	.small_ops	= ip_vs_genl_ops,
+	.n_small_ops	= ARRAY_SIZE(ip_vs_genl_ops),
 };
 
 static int __init ip_vs_genl_register(void)
diff --git a/net/netlabel/netlabel_calipso.c b/net/netlabel/netlabel_calipso.c
index 1a98247ab148..4e62f2ad3575 100644
--- a/net/netlabel/netlabel_calipso.c
+++ b/net/netlabel/netlabel_calipso.c
@@ -304,7 +304,7 @@ static int netlbl_calipso_remove(struct sk_buff *skb, struct genl_info *info)
 /* NetLabel Generic NETLINK Command Definitions
  */
 
-static const struct genl_ops netlbl_calipso_ops[] = {
+static const struct genl_small_ops netlbl_calipso_ops[] = {
 	{
 	.cmd = NLBL_CALIPSO_C_ADD,
 	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -342,8 +342,8 @@ static struct genl_family netlbl_calipso_gnl_family __ro_after_init = {
 	.maxattr = NLBL_CALIPSO_A_MAX,
 	.policy = calipso_genl_policy,
 	.module = THIS_MODULE,
-	.ops = netlbl_calipso_ops,
-	.n_ops = ARRAY_SIZE(netlbl_calipso_ops),
+	.small_ops = netlbl_calipso_ops,
+	.n_small_ops = ARRAY_SIZE(netlbl_calipso_ops),
 };
 
 /* NetLabel Generic NETLINK Protocol Functions
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 0f16080b87cb..726dda95934c 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -724,7 +724,7 @@ static int netlbl_cipsov4_remove(struct sk_buff *skb, struct genl_info *info)
  * NetLabel Generic NETLINK Command Definitions
  */
 
-static const struct genl_ops netlbl_cipsov4_ops[] = {
+static const struct genl_small_ops netlbl_cipsov4_ops[] = {
 	{
 	.cmd = NLBL_CIPSOV4_C_ADD,
 	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -762,8 +762,8 @@ static struct genl_family netlbl_cipsov4_gnl_family __ro_after_init = {
 	.maxattr = NLBL_CIPSOV4_A_MAX,
 	.policy = netlbl_cipsov4_genl_policy,
 	.module = THIS_MODULE,
-	.ops = netlbl_cipsov4_ops,
-	.n_ops = ARRAY_SIZE(netlbl_cipsov4_ops),
+	.small_ops = netlbl_cipsov4_ops,
+	.n_small_ops = ARRAY_SIZE(netlbl_cipsov4_ops),
 };
 
 /*
diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index e7a25fbfaf8b..eb1d66d20afb 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -757,7 +757,7 @@ static int netlbl_mgmt_version(struct sk_buff *skb, struct genl_info *info)
  * NetLabel Generic NETLINK Command Definitions
  */
 
-static const struct genl_ops netlbl_mgmt_genl_ops[] = {
+static const struct genl_small_ops netlbl_mgmt_genl_ops[] = {
 	{
 	.cmd = NLBL_MGMT_C_ADD,
 	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -823,8 +823,8 @@ static struct genl_family netlbl_mgmt_gnl_family __ro_after_init = {
 	.maxattr = NLBL_MGMT_A_MAX,
 	.policy = netlbl_mgmt_genl_policy,
 	.module = THIS_MODULE,
-	.ops = netlbl_mgmt_genl_ops,
-	.n_ops = ARRAY_SIZE(netlbl_mgmt_genl_ops),
+	.small_ops = netlbl_mgmt_genl_ops,
+	.n_small_ops = ARRAY_SIZE(netlbl_mgmt_genl_ops),
 };
 
 /*
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 77bb1bb22c3b..2e8e3f7b2111 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1301,7 +1301,7 @@ static int netlbl_unlabel_staticlistdef(struct sk_buff *skb,
  * NetLabel Generic NETLINK Command Definitions
  */
 
-static const struct genl_ops netlbl_unlabel_genl_ops[] = {
+static const struct genl_small_ops netlbl_unlabel_genl_ops[] = {
 	{
 	.cmd = NLBL_UNLABEL_C_STATICADD,
 	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -1367,8 +1367,8 @@ static struct genl_family netlbl_unlabel_gnl_family __ro_after_init = {
 	.maxattr = NLBL_UNLABEL_A_MAX,
 	.policy = netlbl_unlabel_genl_policy,
 	.module = THIS_MODULE,
-	.ops = netlbl_unlabel_genl_ops,
-	.n_ops = ARRAY_SIZE(netlbl_unlabel_genl_ops),
+	.small_ops = netlbl_unlabel_genl_ops,
+	.n_small_ops = ARRAY_SIZE(netlbl_unlabel_genl_ops),
 };
 
 /*
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e86b9601f5b1..18af10b7ef0e 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2231,7 +2231,7 @@ static int ovs_ct_limit_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static struct genl_ops ct_limit_genl_ops[] = {
+static struct genl_small_ops ct_limit_genl_ops[] = {
 	{ .cmd = OVS_CT_LIMIT_CMD_SET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
@@ -2263,8 +2263,8 @@ struct genl_family dp_ct_limit_genl_family __ro_after_init = {
 	.policy = ct_limit_policy,
 	.netnsok = true,
 	.parallel_ops = true,
-	.ops = ct_limit_genl_ops,
-	.n_ops = ARRAY_SIZE(ct_limit_genl_ops),
+	.small_ops = ct_limit_genl_ops,
+	.n_small_ops = ARRAY_SIZE(ct_limit_genl_ops),
 	.mcgrps = &ovs_ct_limit_multicast_group,
 	.n_mcgrps = 1,
 	.module = THIS_MODULE,
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 00df39b736ed..832f898edb6a 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -652,7 +652,7 @@ static const struct nla_policy packet_policy[OVS_PACKET_ATTR_MAX + 1] = {
 	[OVS_PACKET_ATTR_HASH] = { .type = NLA_U64 },
 };
 
-static const struct genl_ops dp_packet_genl_ops[] = {
+static const struct genl_small_ops dp_packet_genl_ops[] = {
 	{ .cmd = OVS_PACKET_CMD_EXECUTE,
 	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
@@ -668,8 +668,8 @@ static struct genl_family dp_packet_genl_family __ro_after_init = {
 	.policy = packet_policy,
 	.netnsok = true,
 	.parallel_ops = true,
-	.ops = dp_packet_genl_ops,
-	.n_ops = ARRAY_SIZE(dp_packet_genl_ops),
+	.small_ops = dp_packet_genl_ops,
+	.n_small_ops = ARRAY_SIZE(dp_packet_genl_ops),
 	.module = THIS_MODULE,
 };
 
@@ -1453,7 +1453,7 @@ static const struct nla_policy flow_policy[OVS_FLOW_ATTR_MAX + 1] = {
 	[OVS_FLOW_ATTR_UFID_FLAGS] = { .type = NLA_U32 },
 };
 
-static const struct genl_ops dp_flow_genl_ops[] = {
+static const struct genl_small_ops dp_flow_genl_ops[] = {
 	{ .cmd = OVS_FLOW_CMD_NEW,
 	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
@@ -1485,8 +1485,8 @@ static struct genl_family dp_flow_genl_family __ro_after_init = {
 	.policy = flow_policy,
 	.netnsok = true,
 	.parallel_ops = true,
-	.ops = dp_flow_genl_ops,
-	.n_ops = ARRAY_SIZE(dp_flow_genl_ops),
+	.small_ops = dp_flow_genl_ops,
+	.n_small_ops = ARRAY_SIZE(dp_flow_genl_ops),
 	.mcgrps = &ovs_dp_flow_multicast_group,
 	.n_mcgrps = 1,
 	.module = THIS_MODULE,
@@ -1918,7 +1918,7 @@ static const struct nla_policy datapath_policy[OVS_DP_ATTR_MAX + 1] = {
 		PCPU_MIN_UNIT_SIZE / sizeof(struct mask_cache_entry)),
 };
 
-static const struct genl_ops dp_datapath_genl_ops[] = {
+static const struct genl_small_ops dp_datapath_genl_ops[] = {
 	{ .cmd = OVS_DP_CMD_NEW,
 	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
@@ -1950,8 +1950,8 @@ static struct genl_family dp_datapath_genl_family __ro_after_init = {
 	.policy = datapath_policy,
 	.netnsok = true,
 	.parallel_ops = true,
-	.ops = dp_datapath_genl_ops,
-	.n_ops = ARRAY_SIZE(dp_datapath_genl_ops),
+	.small_ops = dp_datapath_genl_ops,
+	.n_small_ops = ARRAY_SIZE(dp_datapath_genl_ops),
 	.mcgrps = &ovs_dp_datapath_multicast_group,
 	.n_mcgrps = 1,
 	.module = THIS_MODULE,
@@ -2401,7 +2401,7 @@ static const struct nla_policy vport_policy[OVS_VPORT_ATTR_MAX + 1] = {
 	[OVS_VPORT_ATTR_NETNSID] = { .type = NLA_S32 },
 };
 
-static const struct genl_ops dp_vport_genl_ops[] = {
+static const struct genl_small_ops dp_vport_genl_ops[] = {
 	{ .cmd = OVS_VPORT_CMD_NEW,
 	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
@@ -2433,8 +2433,8 @@ struct genl_family dp_vport_genl_family __ro_after_init = {
 	.policy = vport_policy,
 	.netnsok = true,
 	.parallel_ops = true,
-	.ops = dp_vport_genl_ops,
-	.n_ops = ARRAY_SIZE(dp_vport_genl_ops),
+	.small_ops = dp_vport_genl_ops,
+	.n_small_ops = ARRAY_SIZE(dp_vport_genl_ops),
 	.mcgrps = &ovs_dp_vport_multicast_group,
 	.n_mcgrps = 1,
 	.module = THIS_MODULE,
diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 3d3d8e094546..50541e874726 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -672,7 +672,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 	return false;
 }
 
-static struct genl_ops dp_meter_genl_ops[] = {
+static struct genl_small_ops dp_meter_genl_ops[] = {
 	{ .cmd = OVS_METER_CMD_FEATURES,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = 0,		  /* OK for unprivileged users. */
@@ -711,8 +711,8 @@ struct genl_family dp_meter_genl_family __ro_after_init = {
 	.policy = meter_policy,
 	.netnsok = true,
 	.parallel_ops = true,
-	.ops = dp_meter_genl_ops,
-	.n_ops = ARRAY_SIZE(dp_meter_genl_ops),
+	.small_ops = dp_meter_genl_ops,
+	.n_small_ops = ARRAY_SIZE(dp_meter_genl_ops),
 	.mcgrps = &ovs_meter_multicast_group,
 	.n_mcgrps = 1,
 	.module = THIS_MODULE,
diff --git a/net/psample/psample.c b/net/psample/psample.c
index a042261a45c5..33e238c965bd 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -96,7 +96,7 @@ static int psample_nl_cmd_get_group_dumpit(struct sk_buff *msg,
 	return msg->len;
 }
 
-static const struct genl_ops psample_nl_ops[] = {
+static const struct genl_small_ops psample_nl_ops[] = {
 	{
 		.cmd = PSAMPLE_CMD_GET_GROUP,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -112,8 +112,8 @@ static struct genl_family psample_nl_family __ro_after_init = {
 	.netnsok	= true,
 	.module		= THIS_MODULE,
 	.mcgrps		= psample_nl_mcgrps,
-	.ops		= psample_nl_ops,
-	.n_ops		= ARRAY_SIZE(psample_nl_ops),
+	.small_ops	= psample_nl_ops,
+	.n_small_ops	= ARRAY_SIZE(psample_nl_ops),
 	.n_mcgrps	= ARRAY_SIZE(psample_nl_mcgrps),
 };
 
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 90e3c70a91ad..1c7aa51cc2a3 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -1337,7 +1337,7 @@ static int tipc_nl_compat_recv(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static const struct genl_ops tipc_genl_compat_ops[] = {
+static const struct genl_small_ops tipc_genl_compat_ops[] = {
 	{
 		.cmd		= TIPC_GENL_CMD,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -1352,8 +1352,8 @@ static struct genl_family tipc_genl_compat_family __ro_after_init = {
 	.maxattr	= 0,
 	.netnsok	= true,
 	.module		= THIS_MODULE,
-	.ops		= tipc_genl_compat_ops,
-	.n_ops		= ARRAY_SIZE(tipc_genl_compat_ops),
+	.small_ops	= tipc_genl_compat_ops,
+	.n_small_ops	= ARRAY_SIZE(tipc_genl_compat_ops),
 };
 
 int __init tipc_netlink_compat_start(void)
diff --git a/net/wimax/stack.c b/net/wimax/stack.c
index 4b9b1c5e8f3a..b6dd9d956ed8 100644
--- a/net/wimax/stack.c
+++ b/net/wimax/stack.c
@@ -401,7 +401,7 @@ static const struct nla_policy wimax_gnl_policy[WIMAX_GNL_ATTR_MAX + 1] = {
 	},
 };
 
-static const struct genl_ops wimax_gnl_ops[] = {
+static const struct genl_small_ops wimax_gnl_ops[] = {
 	{
 		.cmd = WIMAX_GNL_OP_MSG_FROM_USER,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -560,8 +560,8 @@ struct genl_family wimax_gnl_family __ro_after_init = {
 	.maxattr = WIMAX_GNL_ATTR_MAX,
 	.policy = wimax_gnl_policy,
 	.module = THIS_MODULE,
-	.ops = wimax_gnl_ops,
-	.n_ops = ARRAY_SIZE(wimax_gnl_ops),
+	.small_ops = wimax_gnl_ops,
+	.n_small_ops = ARRAY_SIZE(wimax_gnl_ops),
 	.mcgrps = wimax_gnl_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(wimax_gnl_mcgrps),
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1a212db7a300..ee852e70ac12 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14603,6 +14603,9 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+};
+
+static const struct genl_small_ops nl80211_small_ops[] = {
 	{
 		.cmd = NL80211_CMD_SET_WIPHY,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -15464,6 +15467,8 @@ static struct genl_family nl80211_fam __ro_after_init = {
 	.module = THIS_MODULE,
 	.ops = nl80211_ops,
 	.n_ops = ARRAY_SIZE(nl80211_ops),
+	.small_ops = nl80211_small_ops,
+	.n_small_ops = ARRAY_SIZE(nl80211_small_ops),
 	.mcgrps = nl80211_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(nl80211_mcgrps),
 	.parallel_ops = true,
-- 
2.26.2

