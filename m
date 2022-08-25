Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C175A051B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiHYASm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHYASi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:18:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B468A1E0;
        Wed, 24 Aug 2022 17:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77771B826C2;
        Thu, 25 Aug 2022 00:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BB8C433D6;
        Thu, 25 Aug 2022 00:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661386713;
        bh=e1vRzGoedySAGapGtHXEcGfv/Xm0FsnZ13Uu9QtS7i0=;
        h=From:To:Cc:Subject:Date:From;
        b=gIpK1XIbrGATQ5Duz/rn3APmr90UL6EX2LsJhWbwUa7V0oj4dqFc0twdPOdvXoDqT
         reoGz0L1WYga0wqXuTcOpSs0voseqeqZgE8JD5srO5s+PfgFjXWqezvWyvz70SSb2O
         DvkVNgmhTShmbisiGdTxCFnLQcBPTFQxiC9A9KAumonuOkSt1yMMpqdDximlK1GEQQ
         PjLkwPzk0XUJ5KVF+p7/BzfZ8ahbVG8CjAbz1EznUFNSDq/VXq2HRekZ2YyUmph/Qd
         vMIZcNakddxXwUShD4zrJo347sCEl2KSdoedh9dXzIp9RzXZnM0Wpxdh0uHDmRQmWL
         uvzbHGycsSU3g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, jiri@resnulli.us,
        johannes@sipsolutions.net, linux-block@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, linux-wpan@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        mptcp@lists.linux.dev, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        linux-security-module@vger.kernel.org, dev@openvswitch.org,
        linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: [PATCH net-next] genetlink: start to validate reserved header bytes
Date:   Wed, 24 Aug 2022 17:18:30 -0700
Message-Id: <20220825001830.1911524-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We had historically not checked that genlmsghdr.reserved
is 0 on input which prevents us from using those precious
bytes in the future.

One use case would be to extend the cmd field, which is
currently just 8 bits wide and 256 is not a lot of commands
for some core families.

To make sure that new families do the right thing by default
put the onus of opting out of validation on existing families.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@resnulli.us
CC: johannes@sipsolutions.net
CC: linux-block@vger.kernel.org
CC: osmocom-net-gprs@lists.osmocom.org
CC: linux-wpan@vger.kernel.org
CC: wireguard@lists.zx2c4.com
CC: linux-wireless@vger.kernel.org
CC: linux-scsi@vger.kernel.org
CC: target-devel@vger.kernel.org
CC: linux-pm@vger.kernel.org
CC: virtualization@lists.linux-foundation.org
CC: linux-cifs@vger.kernel.org
CC: cluster-devel@redhat.com
CC: mptcp@lists.linux.dev
CC: lvs-devel@vger.kernel.org
CC: netfilter-devel@vger.kernel.org
CC: linux-security-module@vger.kernel.org
CC: dev@openvswitch.org
CC: linux-s390@vger.kernel.org
CC: tipc-discussion@lists.sourceforge.net
---
 drivers/block/nbd.c                      | 1 +
 drivers/net/gtp.c                        | 1 +
 drivers/net/ieee802154/mac802154_hwsim.c | 1 +
 drivers/net/macsec.c                     | 1 +
 drivers/net/team/team.c                  | 1 +
 drivers/net/wireguard/netlink.c          | 1 +
 drivers/net/wireless/mac80211_hwsim.c    | 1 +
 drivers/target/target_core_user.c        | 1 +
 drivers/thermal/thermal_netlink.c        | 1 +
 drivers/vdpa/vdpa.c                      | 1 +
 fs/cifs/netlink.c                        | 1 +
 fs/dlm/netlink.c                         | 1 +
 fs/ksmbd/transport_ipc.c                 | 1 +
 include/linux/genl_magic_func.h          | 1 +
 include/net/genetlink.h                  | 3 +++
 kernel/taskstats.c                       | 1 +
 net/batman-adv/netlink.c                 | 1 +
 net/core/devlink.c                       | 1 +
 net/core/drop_monitor.c                  | 1 +
 net/ethtool/netlink.c                    | 1 +
 net/hsr/hsr_netlink.c                    | 1 +
 net/ieee802154/netlink.c                 | 1 +
 net/ieee802154/nl802154.c                | 1 +
 net/ipv4/fou.c                           | 1 +
 net/ipv4/tcp_metrics.c                   | 1 +
 net/ipv6/ila/ila_main.c                  | 1 +
 net/ipv6/ioam6.c                         | 1 +
 net/ipv6/seg6.c                          | 1 +
 net/l2tp/l2tp_netlink.c                  | 1 +
 net/mptcp/pm_netlink.c                   | 1 +
 net/ncsi/ncsi-netlink.c                  | 1 +
 net/netfilter/ipvs/ip_vs_ctl.c           | 1 +
 net/netlabel/netlabel_calipso.c          | 1 +
 net/netlabel/netlabel_cipso_v4.c         | 1 +
 net/netlabel/netlabel_mgmt.c             | 1 +
 net/netlabel/netlabel_unlabeled.c        | 1 +
 net/netlink/genetlink.c                  | 4 ++++
 net/nfc/netlink.c                        | 1 +
 net/openvswitch/conntrack.c              | 1 +
 net/openvswitch/datapath.c               | 3 +++
 net/openvswitch/meter.c                  | 1 +
 net/psample/psample.c                    | 1 +
 net/smc/smc_netlink.c                    | 3 ++-
 net/smc/smc_pnet.c                       | 3 ++-
 net/tipc/netlink.c                       | 1 +
 net/tipc/netlink_compat.c                | 1 +
 net/wireless/nl80211.c                   | 1 +
 47 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 2a709daefbc4..6cec9ce23fd3 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -2322,6 +2322,7 @@ static struct genl_family nbd_genl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= nbd_connect_genl_ops,
 	.n_small_ops	= ARRAY_SIZE(nbd_connect_genl_ops),
+	.resv_start_op	= NBD_CMD_STATUS + 1,
 	.maxattr	= NBD_ATTR_MAX,
 	.policy = nbd_attr_policy,
 	.mcgrps		= nbd_mcast_grps,
diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index a208e2b1a9af..15c7dc82107f 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1859,6 +1859,7 @@ static struct genl_family gtp_genl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= gtp_genl_ops,
 	.n_small_ops	= ARRAY_SIZE(gtp_genl_ops),
+	.resv_start_op	= GTP_CMD_ECHOREQ + 1,
 	.mcgrps		= gtp_genl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(gtp_genl_mcgrps),
 };
diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 38c217bd7c82..2f0544dd7c2a 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -630,6 +630,7 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.small_ops = hwsim_nl_ops,
 	.n_small_ops = ARRAY_SIZE(hwsim_nl_ops),
+	.resv_start_op = MAC802154_HWSIM_CMD_NEW_EDGE + 1,
 	.mcgrps = hwsim_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(hwsim_mcgrps),
 };
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index ee6087e7b2bf..b82f9f7d0a7d 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3409,6 +3409,7 @@ static struct genl_family macsec_fam __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= macsec_genl_ops,
 	.n_small_ops	= ARRAY_SIZE(macsec_genl_ops),
+	.resv_start_op	= MACSEC_CMD_UPD_OFFLOAD + 1,
 };
 
 static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index aac133a1e27a..b1e1239dfade 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2840,6 +2840,7 @@ static struct genl_family team_nl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= team_nl_ops,
 	.n_small_ops	= ARRAY_SIZE(team_nl_ops),
+	.resv_start_op	= TEAM_CMD_PORT_LIST_GET + 1,
 	.mcgrps		= team_nl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(team_nl_mcgrps),
 };
diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index d0f3b6d7f408..0c0644e762e5 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -621,6 +621,7 @@ static const struct genl_ops genl_ops[] = {
 static struct genl_family genl_family __ro_after_init = {
 	.ops = genl_ops,
 	.n_ops = ARRAY_SIZE(genl_ops),
+	.resv_start_op = WG_CMD_SET_DEVICE + 1,
 	.name = WG_GENL_NAME,
 	.version = WG_GENL_VERSION,
 	.maxattr = WGDEVICE_A_MAX,
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 6e55f153ff26..0b0dae03c2a8 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -4912,6 +4912,7 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.small_ops = hwsim_ops,
 	.n_small_ops = ARRAY_SIZE(hwsim_ops),
+	.resv_start_op = HWSIM_CMD_DEL_MAC_ADDR + 1,
 	.mcgrps = hwsim_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(hwsim_mcgrps),
 };
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 3deaeecb712e..2940559c3086 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -486,6 +486,7 @@ static struct genl_family tcmu_genl_family __ro_after_init = {
 	.netnsok = true,
 	.small_ops = tcmu_genl_ops,
 	.n_small_ops = ARRAY_SIZE(tcmu_genl_ops),
+	.resv_start_op = TCMU_CMD_SET_FEATURES + 1,
 };
 
 #define tcmu_cmd_set_dbi_cur(cmd, index) ((cmd)->dbi_cur = (index))
diff --git a/drivers/thermal/thermal_netlink.c b/drivers/thermal/thermal_netlink.c
index 050d243a5fa1..e2d78a996b5f 100644
--- a/drivers/thermal/thermal_netlink.c
+++ b/drivers/thermal/thermal_netlink.c
@@ -693,6 +693,7 @@ static struct genl_family thermal_gnl_family __ro_after_init = {
 	.policy		= thermal_genl_policy,
 	.small_ops	= thermal_genl_ops,
 	.n_small_ops	= ARRAY_SIZE(thermal_genl_ops),
+	.resv_start_op	= THERMAL_GENL_CMD_CDEV_GET + 1,
 	.mcgrps		= thermal_genl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(thermal_genl_mcgrps),
 };
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index c06c02704461..7badf5777597 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -1183,6 +1183,7 @@ static struct genl_family vdpa_nl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.ops = vdpa_nl_ops,
 	.n_ops = ARRAY_SIZE(vdpa_nl_ops),
+	.resv_start_op = VDPA_CMD_DEV_VSTATS_GET + 1,
 };
 
 static int vdpa_init(void)
diff --git a/fs/cifs/netlink.c b/fs/cifs/netlink.c
index 291cb606f149..147d9409252c 100644
--- a/fs/cifs/netlink.c
+++ b/fs/cifs/netlink.c
@@ -51,6 +51,7 @@ struct genl_family cifs_genl_family = {
 	.policy		= cifs_genl_policy,
 	.ops		= cifs_genl_ops,
 	.n_ops		= ARRAY_SIZE(cifs_genl_ops),
+	.resv_start_op	= CIFS_GENL_CMD_SWN_NOTIFY + 1,
 	.mcgrps		= cifs_genl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(cifs_genl_mcgrps),
 };
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index 67f68d48d60c..4de4b8651c6c 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -75,6 +75,7 @@ static struct genl_family family __ro_after_init = {
 	.version	= DLM_GENL_VERSION,
 	.small_ops	= dlm_nl_ops,
 	.n_small_ops	= ARRAY_SIZE(dlm_nl_ops),
+	.resv_start_op	= DLM_CMD_HELLO + 1,
 	.module		= THIS_MODULE,
 };
 
diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
index 7cb0eeb07c80..c9aca21637d5 100644
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -197,6 +197,7 @@ static struct genl_family ksmbd_genl_family = {
 	.module		= THIS_MODULE,
 	.ops		= ksmbd_genl_ops,
 	.n_ops		= ARRAY_SIZE(ksmbd_genl_ops),
+	.resv_start_op	= KSMBD_EVENT_SPNEGO_AUTHEN_RESPONSE + 1,
 };
 
 static void ksmbd_nl_init_fixup(void)
diff --git a/include/linux/genl_magic_func.h b/include/linux/genl_magic_func.h
index 939b1a8f571b..4a4b387181ad 100644
--- a/include/linux/genl_magic_func.h
+++ b/include/linux/genl_magic_func.h
@@ -294,6 +294,7 @@ static struct genl_family ZZZ_genl_family __ro_after_init = {
 	.ops = ZZZ_genl_ops,
 	.n_ops = ARRAY_SIZE(ZZZ_genl_ops),
 	.mcgrps = ZZZ_genl_mcgrps,
+	.resv_start_op = 42, /* drbd is currently the only user */
 	.n_mcgrps = ARRAY_SIZE(ZZZ_genl_mcgrps),
 	.module = THIS_MODULE,
 };
diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index c41b20783ad0..8f780170e2f8 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -39,6 +39,8 @@ struct genl_info;
  *	undo operations done by pre_doit, for example release locks
  * @mcgrps: multicast groups used by this family
  * @n_mcgrps: number of multicast groups
+ * @resv_start_op: first operation for which reserved fields of the header
+ *	can be validated, new families should leave this field at zero
  * @mcgrp_offset: starting number of multicast group IDs in this family
  *	(private)
  * @ops: the operations supported by this family
@@ -58,6 +60,7 @@ struct genl_family {
 	u8			n_ops;
 	u8			n_small_ops;
 	u8			n_mcgrps;
+	u8			resv_start_op;
 	const struct nla_policy *policy;
 	int			(*pre_doit)(const struct genl_ops *ops,
 					    struct sk_buff *skb,
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index f7e246336218..8ce3fa0c19e2 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -688,6 +688,7 @@ static struct genl_family family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.ops		= taskstats_ops,
 	.n_ops		= ARRAY_SIZE(taskstats_ops),
+	.resv_start_op	= CGROUPSTATS_CMD_GET + 1,
 	.netnsok	= true,
 };
 
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index 00875e1d8c44..a5e4a4e976cf 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -1493,6 +1493,7 @@ struct genl_family batadv_netlink_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.small_ops = batadv_netlink_ops,
 	.n_small_ops = ARRAY_SIZE(batadv_netlink_ops),
+	.resv_start_op = BATADV_CMD_SET_VLAN + 1,
 	.mcgrps = batadv_netlink_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(batadv_netlink_mcgrps),
 };
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e0073981e92d..5011a825834e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9512,6 +9512,7 @@ static struct genl_family devlink_nl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= devlink_nl_ops,
 	.n_small_ops	= ARRAY_SIZE(devlink_nl_ops),
+	.resv_start_op	= DEVLINK_CMD_SELFTESTS_RUN + 1,
 	.mcgrps		= devlink_nl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
 };
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 876664fc605e..f084a4a6b7ab 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1645,6 +1645,7 @@ static struct genl_family net_drop_monitor_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= dropmon_ops,
 	.n_small_ops	= ARRAY_SIZE(dropmon_ops),
+	.resv_start_op	= NET_DM_CMD_STATS_GET + 1,
 	.mcgrps		= dropmon_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(dropmon_mcgrps),
 };
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 0ccb177aaf04..f4e41a6e0163 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -1036,6 +1036,7 @@ static struct genl_family ethtool_genl_family __ro_after_init = {
 	.parallel_ops	= true,
 	.ops		= ethtool_genl_ops,
 	.n_ops		= ARRAY_SIZE(ethtool_genl_ops),
+	.resv_start_op	= ETHTOOL_MSG_MODULE_GET + 1,
 	.mcgrps		= ethtool_nl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(ethtool_nl_mcgrps),
 };
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 1405c037cf7a..7174a9092900 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -522,6 +522,7 @@ static struct genl_family hsr_genl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.small_ops = hsr_ops,
 	.n_small_ops = ARRAY_SIZE(hsr_ops),
+	.resv_start_op = HSR_C_SET_NODE_LIST + 1,
 	.mcgrps = hsr_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(hsr_mcgrps),
 };
diff --git a/net/ieee802154/netlink.c b/net/ieee802154/netlink.c
index b07abc38b4b3..7d2de4ee6992 100644
--- a/net/ieee802154/netlink.c
+++ b/net/ieee802154/netlink.c
@@ -132,6 +132,7 @@ struct genl_family nl802154_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= ieee802154_ops,
 	.n_small_ops	= ARRAY_SIZE(ieee802154_ops),
+	.resv_start_op	= IEEE802154_LLSEC_DEL_SECLEVEL + 1,
 	.mcgrps		= ieee802154_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(ieee802154_mcgrps),
 };
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index e0b072aecf0f..38c4f3cb010e 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2500,6 +2500,7 @@ static struct genl_family nl802154_fam __ro_after_init = {
 	.module = THIS_MODULE,
 	.ops = nl802154_ops,
 	.n_ops = ARRAY_SIZE(nl802154_ops),
+	.resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
 	.mcgrps = nl802154_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(nl802154_mcgrps),
 };
diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 025a33c1b04d..3e409bcca606 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -931,6 +931,7 @@ static struct genl_family fou_nl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= fou_nl_ops,
 	.n_small_ops	= ARRAY_SIZE(fou_nl_ops),
+	.resv_start_op	= FOU_CMD_GET + 1,
 };
 
 size_t fou_encap_hlen(struct ip_tunnel_encap *e)
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index d58e672be31c..82f4575f9cd9 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -969,6 +969,7 @@ static struct genl_family tcp_metrics_nl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= tcp_metrics_nl_ops,
 	.n_small_ops	= ARRAY_SIZE(tcp_metrics_nl_ops),
+	.resv_start_op	= TCP_METRICS_CMD_DEL + 1,
 };
 
 static unsigned int tcpmhash_entries;
diff --git a/net/ipv6/ila/ila_main.c b/net/ipv6/ila/ila_main.c
index 36c58aa257e8..3faf62530d6a 100644
--- a/net/ipv6/ila/ila_main.c
+++ b/net/ipv6/ila/ila_main.c
@@ -55,6 +55,7 @@ struct genl_family ila_nl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.ops		= ila_nl_ops,
 	.n_ops		= ARRAY_SIZE(ila_nl_ops),
+	.resv_start_op	= ILA_CMD_FLUSH + 1,
 };
 
 static __net_init int ila_init_net(struct net *net)
diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 1098131ed90c..571f0e4d9cf3 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -619,6 +619,7 @@ static struct genl_family ioam6_genl_family __ro_after_init = {
 	.parallel_ops	= true,
 	.ops		= ioam6_genl_ops,
 	.n_ops		= ARRAY_SIZE(ioam6_genl_ops),
+	.resv_start_op	= IOAM6_CMD_NS_SET_SCHEMA + 1,
 	.module		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 73aaabf0e966..5421cc7c935f 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -499,6 +499,7 @@ static struct genl_family seg6_genl_family __ro_after_init = {
 	.parallel_ops	= true,
 	.ops		= seg6_genl_ops,
 	.n_ops		= ARRAY_SIZE(seg6_genl_ops),
+	.resv_start_op	= SEG6_CMD_GET_TUNSRC + 1,
 	.module		= THIS_MODULE,
 };
 
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 96eb91be9238..a901fd14fe3b 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -989,6 +989,7 @@ static struct genl_family l2tp_nl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= l2tp_nl_ops,
 	.n_small_ops	= ARRAY_SIZE(l2tp_nl_ops),
+	.resv_start_op	= L2TP_CMD_SESSION_GET + 1,
 	.mcgrps		= l2tp_multicast_group,
 	.n_mcgrps	= ARRAY_SIZE(l2tp_multicast_group),
 };
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 291b5da42fdb..a3e4ee7af0ee 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -2280,6 +2280,7 @@ static struct genl_family mptcp_genl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= mptcp_pm_ops,
 	.n_small_ops	= ARRAY_SIZE(mptcp_pm_ops),
+	.resv_start_op	= MPTCP_PM_CMD_SUBFLOW_DESTROY + 1,
 	.mcgrps		= mptcp_pm_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(mptcp_pm_mcgrps),
 };
diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index c189b4c8a182..d27f4eccce6d 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -768,6 +768,7 @@ static struct genl_family ncsi_genl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.small_ops = ncsi_ops,
 	.n_small_ops = ARRAY_SIZE(ncsi_ops),
+	.resv_start_op = NCSI_CMD_SET_CHANNEL_MASK + 1,
 };
 
 static int __init ncsi_init_netlink(void)
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index efab2b06d373..818b0b058b10 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4005,6 +4005,7 @@ static struct genl_family ip_vs_genl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= ip_vs_genl_ops,
 	.n_small_ops	= ARRAY_SIZE(ip_vs_genl_ops),
+	.resv_start_op	= IPVS_CMD_FLUSH + 1,
 };
 
 static int __init ip_vs_genl_register(void)
diff --git a/net/netlabel/netlabel_calipso.c b/net/netlabel/netlabel_calipso.c
index 91a19c3ea1a3..f1d5b8465217 100644
--- a/net/netlabel/netlabel_calipso.c
+++ b/net/netlabel/netlabel_calipso.c
@@ -344,6 +344,7 @@ static struct genl_family netlbl_calipso_gnl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.small_ops = netlbl_calipso_ops,
 	.n_small_ops = ARRAY_SIZE(netlbl_calipso_ops),
+	.resv_start_op = NLBL_CALIPSO_C_LISTALL + 1,
 };
 
 /* NetLabel Generic NETLINK Protocol Functions
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 894e6b8f1a86..fa08ee75ac06 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -767,6 +767,7 @@ static struct genl_family netlbl_cipsov4_gnl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.small_ops = netlbl_cipsov4_ops,
 	.n_small_ops = ARRAY_SIZE(netlbl_cipsov4_ops),
+	.resv_start_op = NLBL_CIPSOV4_C_LISTALL + 1,
 };
 
 /*
diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index 032b7d7b32c7..689eaa2afbec 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -826,6 +826,7 @@ static struct genl_family netlbl_mgmt_gnl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.small_ops = netlbl_mgmt_genl_ops,
 	.n_small_ops = ARRAY_SIZE(netlbl_mgmt_genl_ops),
+	.resv_start_op = NLBL_MGMT_C_VERSION + 1,
 };
 
 /*
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 0555dffd80e0..9996883bf2b7 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1374,6 +1374,7 @@ static struct genl_family netlbl_unlabel_gnl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.small_ops = netlbl_unlabel_genl_ops,
 	.n_small_ops = ARRAY_SIZE(netlbl_unlabel_genl_ops),
+	.resv_start_op = NLBL_UNLABEL_C_STATICLISTDEF + 1,
 };
 
 /*
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 57010927e20a..a1a7b2d7738e 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -757,6 +757,9 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
 		return -EINVAL;
 
+	if (hdr->cmd >= family->resv_start_op && hdr->reserved)
+		return -EINVAL;
+
 	if (genl_get_cmd(hdr->cmd, family, &op))
 		return -EOPNOTSUPP;
 
@@ -1348,6 +1351,7 @@ static struct genl_family genl_ctrl __ro_after_init = {
 	.module = THIS_MODULE,
 	.ops = genl_ctrl_ops,
 	.n_ops = ARRAY_SIZE(genl_ctrl_ops),
+	.resv_start_op = CTRL_CMD_GETPOLICY + 1,
 	.mcgrps = genl_ctrl_groups,
 	.n_mcgrps = ARRAY_SIZE(genl_ctrl_groups),
 	.id = GENL_ID_CTRL,
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 7c62417ccfd7..9d91087b9399 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1783,6 +1783,7 @@ static struct genl_family nfc_genl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.ops = nfc_genl_ops,
 	.n_ops = ARRAY_SIZE(nfc_genl_ops),
+	.resv_start_op = NFC_CMD_DEACTIVATE_TARGET + 1,
 	.mcgrps = nfc_genl_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(nfc_genl_mcgrps),
 };
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4e70df91d0f2..48e8f5c29b67 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2283,6 +2283,7 @@ struct genl_family dp_ct_limit_genl_family __ro_after_init = {
 	.parallel_ops = true,
 	.small_ops = ct_limit_genl_ops,
 	.n_small_ops = ARRAY_SIZE(ct_limit_genl_ops),
+	.resv_start_op = OVS_CT_LIMIT_CMD_GET + 1,
 	.mcgrps = &ovs_ct_limit_multicast_group,
 	.n_mcgrps = 1,
 	.module = THIS_MODULE,
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 45f9a7b3410e..1d6397eaadf0 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -692,6 +692,7 @@ static struct genl_family dp_packet_genl_family __ro_after_init = {
 	.parallel_ops = true,
 	.small_ops = dp_packet_genl_ops,
 	.n_small_ops = ARRAY_SIZE(dp_packet_genl_ops),
+	.resv_start_op = OVS_PACKET_CMD_EXECUTE + 1,
 	.module = THIS_MODULE,
 };
 
@@ -1509,6 +1510,7 @@ static struct genl_family dp_flow_genl_family __ro_after_init = {
 	.parallel_ops = true,
 	.small_ops = dp_flow_genl_ops,
 	.n_small_ops = ARRAY_SIZE(dp_flow_genl_ops),
+	.resv_start_op = OVS_FLOW_CMD_SET + 1,
 	.mcgrps = &ovs_dp_flow_multicast_group,
 	.n_mcgrps = 1,
 	.module = THIS_MODULE,
@@ -2040,6 +2042,7 @@ static struct genl_family dp_datapath_genl_family __ro_after_init = {
 	.parallel_ops = true,
 	.small_ops = dp_datapath_genl_ops,
 	.n_small_ops = ARRAY_SIZE(dp_datapath_genl_ops),
+	.resv_start_op = OVS_DP_CMD_SET + 1,
 	.mcgrps = &ovs_dp_datapath_multicast_group,
 	.n_mcgrps = 1,
 	.module = THIS_MODULE,
diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 04a060ac7fdf..51111a9009bd 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -720,6 +720,7 @@ struct genl_family dp_meter_genl_family __ro_after_init = {
 	.parallel_ops = true,
 	.small_ops = dp_meter_genl_ops,
 	.n_small_ops = ARRAY_SIZE(dp_meter_genl_ops),
+	.resv_start_op = OVS_METER_CMD_GET + 1,
 	.mcgrps = &ovs_meter_multicast_group,
 	.n_mcgrps = 1,
 	.module = THIS_MODULE,
diff --git a/net/psample/psample.c b/net/psample/psample.c
index 118d5d2a81a0..81a794e36f53 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -115,6 +115,7 @@ static struct genl_family psample_nl_family __ro_after_init = {
 	.mcgrps		= psample_nl_mcgrps,
 	.small_ops	= psample_nl_ops,
 	.n_small_ops	= ARRAY_SIZE(psample_nl_ops),
+	.resv_start_op	= PSAMPLE_CMD_GET_GROUP + 1,
 	.n_mcgrps	= ARRAY_SIZE(psample_nl_mcgrps),
 };
 
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index c5a62f6f52ba..621c46c70073 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -142,7 +142,8 @@ struct genl_family smc_gen_nl_family __ro_after_init = {
 	.netnsok =	true,
 	.module =	THIS_MODULE,
 	.ops =		smc_gen_nl_ops,
-	.n_ops =	ARRAY_SIZE(smc_gen_nl_ops)
+	.n_ops =	ARRAY_SIZE(smc_gen_nl_ops),
+	.resv_start_op = SMC_NETLINK_DISABLE_HS_LIMITATION + 1,
 };
 
 int __init smc_nl_init(void)
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 4c3bf6db7038..25fb2fd186e2 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -715,7 +715,8 @@ static struct genl_family smc_pnet_nl_family __ro_after_init = {
 	.netnsok = true,
 	.module = THIS_MODULE,
 	.ops = smc_pnet_ops,
-	.n_ops =  ARRAY_SIZE(smc_pnet_ops)
+	.n_ops =  ARRAY_SIZE(smc_pnet_ops),
+	.resv_start_op = SMC_PNETID_FLUSH + 1,
 };
 
 bool smc_pnet_is_ndev_pnetid(struct net *net, u8 *pnetid)
diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index c447cb5f879e..e8fd257c0e68 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -294,6 +294,7 @@ struct genl_family tipc_genl_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.ops		= tipc_genl_v2_ops,
 	.n_ops		= ARRAY_SIZE(tipc_genl_v2_ops),
+	.resv_start_op	= TIPC_NL_ADDR_LEGACY_GET + 1,
 };
 
 int __init tipc_netlink_start(void)
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 0749df80454d..fc68733673ba 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -1357,6 +1357,7 @@ static struct genl_family tipc_genl_compat_family __ro_after_init = {
 	.module		= THIS_MODULE,
 	.small_ops	= tipc_genl_compat_ops,
 	.n_small_ops	= ARRAY_SIZE(tipc_genl_compat_ops),
+	.resv_start_op	= TIPC_GENL_CMD + 1,
 };
 
 int __init tipc_netlink_compat_start(void)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2705e3ee8fc4..58c29b52d48b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17141,6 +17141,7 @@ static struct genl_family nl80211_fam __ro_after_init = {
 	.n_ops = ARRAY_SIZE(nl80211_ops),
 	.small_ops = nl80211_small_ops,
 	.n_small_ops = ARRAY_SIZE(nl80211_small_ops),
+	.resv_start_op = NL80211_CMD_REMOVE_LINK_STA + 1,
 	.mcgrps = nl80211_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(nl80211_mcgrps),
 	.parallel_ops = true,
-- 
2.37.2

