Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498503082D9
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhA2BDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbhA2BCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:02:07 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFC4C061794
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:45 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z22so8755116edb.9
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=596GTr7YjablRJ95IP+lc9ePMIkikeVfeTL44f2UNzo=;
        b=uA+iB9j8aU1BMoKmE+hTchQz+uONNXjonVR+Xz5Bjr92iBEKXjPK/L/4l2IqscN6qb
         bFi3QsKdMWiKbrp1kb4+ZekSUpGUEZZw+Iub2/CGAsW0V5nUukiMrpql+RTgVV1xHhZH
         a2XErV8vQDFDN0RpFpg0t0pLURFCWDunZKeHEVPHx8EfXmzIMkGjMhNs0k5DpNGEIZQt
         eEqvbj4iGRY68VzpHfaSxPr7PIjWyVui2HPwUz61cZW+U+j+mW6f607NaTHYnJHKDi/f
         1CVtTudbaBmX6ZWVQS+15pSfd3Ikf34ZugK2qY3JeoMomnoBRMGtoo2IhmFa4/uwyY6r
         jowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=596GTr7YjablRJ95IP+lc9ePMIkikeVfeTL44f2UNzo=;
        b=jsSUuu+gMcchcJ+a3ZRbVwA5Or3V44YKCFD3LrUMUz1uiKOFLDKGI0NKU0RZoEoHZx
         /LTMSETTU3szCNg47vJZveutj375hSV3MX/HeOq+wWolXByJI2/hJWqEK12RTtpFjAT+
         drWXZ0gbZ0DZbSa0CLKAhf3TG+2mEZOvFUn2OHbGOATnx4qnIWzNHUEQlAV2rU8ZDQ2f
         rBX9P3mXv4nHOaJEaHQI2a2IPlzHAp/8atHQYhxNKmolbI4moFT//wohlgb1LT4/CE/3
         mjNT5XtOO1R07FtGIECfP6VnANu6wBg0bdOCfGk20vip4WI7c2bX+BE7RAs9sUYlW44C
         Me/g==
X-Gm-Message-State: AOAM532zJ3b08xINHI5eIAEtbPXBwkU7HHKYfzrt5oZjUzDcFHwAPhvI
        Bxbceti8Ul1x1YFTizyFMis=
X-Google-Smtp-Source: ABdhPJy6WDyi9tk8TnNxlU2TA2V0iwzd9iOSUEAzNWUKZ7HjRSyT3NCtKcr8AMEGUIqLvjebQBciQA==
X-Received: by 2002:a50:c8c3:: with SMTP id k3mr2536160edh.302.1611882043415;
        Thu, 28 Jan 2021 17:00:43 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f22sm3049256eje.34.2021.01.28.17.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:00:42 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v8 net-next 11/11] net: dsa: felix: perform switch setup for tag_8021q
Date:   Fri, 29 Jan 2021 03:00:09 +0200
Message-Id: <20210129010009.3959398-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129010009.3959398-1-olteanv@gmail.com>
References: <20210129010009.3959398-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Unlike sja1105, the only other user of the software-defined tag_8021q.c
tagger format, the implementation we choose for the Felix DSA switch
driver preserves full functionality under a vlan_filtering bridge
(i.e. IP termination works through the DSA user ports under all
circumstances).

The tag_8021q protocol just wants:
- Identifying the ingress switch port based on the RX VLAN ID, as seen
  by the CPU. We achieve this by using the TCAM engines (which are also
  used for tc-flower offload) to push the RX VLAN as a second, outer
  tag, on egress towards the CPU port.
- Steering traffic injected into the switch from the network stack
  towards the correct front port based on the TX VLAN, and consuming
  (popping) that header on the switch's egress.

A tc-flower pseudocode of the static configuration done by the driver
would look like this:

$ tc qdisc add dev <cpu-port> clsact
$ for eth in swp0 swp1 swp2 swp3; do \
	tc filter add dev <cpu-port> egress flower indev ${eth} \
		action vlan push id <rxvlan> protocol 802.1ad; \
	tc filter add dev <cpu-port> ingress protocol 802.1Q flower
		vlan_id <txvlan> action vlan pop \
		action mirred egress redirect dev ${eth}; \
done

but of course since DSA does not register network interfaces for the CPU
port, this configuration would be impossible for the user to do. Also,
due to the same reason, it is impossible for the user to inadvertently
delete these rules using tc. These rules do not collide in any way with
tc-flower, they just consume some TCAM space, which is something we can
live with.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v8:
- Refactor ocelot_apply_bridge_fwd_mask.
- Call ocelot_apply_bridge_fwd_mask immediately after the is_dsa_8021q_cpu
  variable changes, i.e. in felix_8021q_cpu_port_init and
  felix_8021q_cpu_port_deinit.

Changes in v7:
Drop the rtnl_lock surrounding dsa_8021q_setup since some callers of
.{set,del}_tag_protocol now hold the rtnl_mutex and we'd run into a
deadlock if we took it. That's also why all callers needed to be
converted to hold the lock, since otherwise dsa_8021q_setup would have
no guarantees short of passing it a bool rtnl_is_held variable.

Changes in v6:
None.

Changes in v5:
Path is split from previous monolithic patch "net: dsa: felix: add new
VLAN-based tagger".

Changes in v4:
- Support simultaneous compilation of tag_ocelot.c and
  tag_ocelot_8021q.c.
- Support runtime switchover between these two taggers.
- We are now actually performing cleanup instead of just probe-time
  setup, which is required for supporting tagger switchover.

Changes in v3:
- Use a per-port bool is_dsa_8021q_cpu instead of a single dsa_8021q_cpu
  variable, to be compatible with future work where there may be
  potentially multiple tag_8021q CPU ports in a LAG.
- Initialize ocelot->npi = -1 in felix_8021q_cpu_port_init to ensure we
  don't mistakenly trigger NPI-specific code in ocelot.

Changes in v2:
Clean up the hardcoding of random VCAP filter IDs and the inclusion of a
private ocelot header.

 drivers/net/dsa/ocelot/felix.c          | 337 +++++++++++++++++++++++-
 drivers/net/dsa/ocelot/felix.h          |   1 +
 drivers/net/ethernet/mscc/ocelot.c      |  61 ++++-
 drivers/net/ethernet/mscc/ocelot_vcap.c |   1 +
 drivers/net/ethernet/mscc/ocelot_vcap.h |   3 -
 include/soc/mscc/ocelot.h               |   2 +
 include/soc/mscc/ocelot_vcap.h          |   3 +
 7 files changed, 396 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index af3cee8762ce..167463010b55 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -13,6 +13,7 @@
 #include <soc/mscc/ocelot_ana.h>
 #include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot.h>
+#include <linux/dsa/8021q.h>
 #include <linux/platform_device.h>
 #include <linux/packing.h>
 #include <linux/module.h>
@@ -24,6 +25,329 @@
 #include <net/dsa.h>
 #include "felix.h"
 
+static int felix_tag_8021q_rxvlan_add(struct felix *felix, int port, u16 vid,
+				      bool pvid, bool untagged)
+{
+	struct ocelot_vcap_filter *outer_tagging_rule;
+	struct ocelot *ocelot = &felix->ocelot;
+	struct dsa_switch *ds = felix->ds;
+	int key_length, upstream, err;
+
+	/* We don't need to install the rxvlan into the other ports' filtering
+	 * tables, because we're just pushing the rxvlan when sending towards
+	 * the CPU
+	 */
+	if (!pvid)
+		return 0;
+
+	key_length = ocelot->vcap[VCAP_ES0].keys[VCAP_ES0_IGR_PORT].length;
+	upstream = dsa_upstream_port(ds, port);
+
+	outer_tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter),
+				     GFP_KERNEL);
+	if (!outer_tagging_rule)
+		return -ENOMEM;
+
+	outer_tagging_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	outer_tagging_rule->prio = 1;
+	outer_tagging_rule->id.cookie = port;
+	outer_tagging_rule->id.tc_offload = false;
+	outer_tagging_rule->block_id = VCAP_ES0;
+	outer_tagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	outer_tagging_rule->lookup = 0;
+	outer_tagging_rule->ingress_port.value = port;
+	outer_tagging_rule->ingress_port.mask = GENMASK(key_length - 1, 0);
+	outer_tagging_rule->egress_port.value = upstream;
+	outer_tagging_rule->egress_port.mask = GENMASK(key_length - 1, 0);
+	outer_tagging_rule->action.push_outer_tag = OCELOT_ES0_TAG;
+	outer_tagging_rule->action.tag_a_tpid_sel = OCELOT_TAG_TPID_SEL_8021AD;
+	outer_tagging_rule->action.tag_a_vid_sel = 1;
+	outer_tagging_rule->action.vid_a_val = vid;
+
+	err = ocelot_vcap_filter_add(ocelot, outer_tagging_rule, NULL);
+	if (err)
+		kfree(outer_tagging_rule);
+
+	return err;
+}
+
+static int felix_tag_8021q_txvlan_add(struct felix *felix, int port, u16 vid,
+				      bool pvid, bool untagged)
+{
+	struct ocelot_vcap_filter *untagging_rule, *redirect_rule;
+	struct ocelot *ocelot = &felix->ocelot;
+	struct dsa_switch *ds = felix->ds;
+	int upstream, err;
+
+	/* tag_8021q.c assumes we are implementing this via port VLAN
+	 * membership, which we aren't. So we don't need to add any VCAP filter
+	 * for the CPU port.
+	 */
+	if (ocelot->ports[port]->is_dsa_8021q_cpu)
+		return 0;
+
+	untagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
+	if (!untagging_rule)
+		return -ENOMEM;
+
+	redirect_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
+	if (!redirect_rule) {
+		kfree(untagging_rule);
+		return -ENOMEM;
+	}
+
+	upstream = dsa_upstream_port(ds, port);
+
+	untagging_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	untagging_rule->ingress_port_mask = BIT(upstream);
+	untagging_rule->vlan.vid.value = vid;
+	untagging_rule->vlan.vid.mask = VLAN_VID_MASK;
+	untagging_rule->prio = 1;
+	untagging_rule->id.cookie = port;
+	untagging_rule->id.tc_offload = false;
+	untagging_rule->block_id = VCAP_IS1;
+	untagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	untagging_rule->lookup = 0;
+	untagging_rule->action.vlan_pop_cnt_ena = true;
+	untagging_rule->action.vlan_pop_cnt = 1;
+	untagging_rule->action.pag_override_mask = 0xff;
+	untagging_rule->action.pag_val = port;
+
+	err = ocelot_vcap_filter_add(ocelot, untagging_rule, NULL);
+	if (err) {
+		kfree(untagging_rule);
+		kfree(redirect_rule);
+		return err;
+	}
+
+	redirect_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	redirect_rule->ingress_port_mask = BIT(upstream);
+	redirect_rule->pag = port;
+	redirect_rule->prio = 1;
+	redirect_rule->id.cookie = port;
+	redirect_rule->id.tc_offload = false;
+	redirect_rule->block_id = VCAP_IS2;
+	redirect_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	redirect_rule->lookup = 0;
+	redirect_rule->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
+	redirect_rule->action.port_mask = BIT(port);
+
+	err = ocelot_vcap_filter_add(ocelot, redirect_rule, NULL);
+	if (err) {
+		ocelot_vcap_filter_del(ocelot, untagging_rule);
+		kfree(redirect_rule);
+		return err;
+	}
+
+	return 0;
+}
+
+static int felix_tag_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
+				    u16 flags)
+{
+	bool untagged = flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = flags & BRIDGE_VLAN_INFO_PVID;
+	struct ocelot *ocelot = ds->priv;
+
+	if (vid_is_dsa_8021q_rxvlan(vid))
+		return felix_tag_8021q_rxvlan_add(ocelot_to_felix(ocelot),
+						  port, vid, pvid, untagged);
+
+	if (vid_is_dsa_8021q_txvlan(vid))
+		return felix_tag_8021q_txvlan_add(ocelot_to_felix(ocelot),
+						  port, vid, pvid, untagged);
+
+	return 0;
+}
+
+static int felix_tag_8021q_rxvlan_del(struct felix *felix, int port, u16 vid)
+{
+	struct ocelot_vcap_filter *outer_tagging_rule;
+	struct ocelot_vcap_block *block_vcap_es0;
+	struct ocelot *ocelot = &felix->ocelot;
+
+	block_vcap_es0 = &ocelot->block[VCAP_ES0];
+
+	outer_tagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_es0,
+								 port, false);
+	/* In rxvlan_add, we had the "if (!pvid) return 0" logic to avoid
+	 * installing outer tagging ES0 rules where they weren't needed.
+	 * But in rxvlan_del, the API doesn't give us the "flags" anymore,
+	 * so that forces us to be slightly sloppy here, and just assume that
+	 * if we didn't find an outer_tagging_rule it means that there was
+	 * none in the first place, i.e. rxvlan_del is called on a non-pvid
+	 * port. This is most probably true though.
+	 */
+	if (!outer_tagging_rule)
+		return 0;
+
+	return ocelot_vcap_filter_del(ocelot, outer_tagging_rule);
+}
+
+static int felix_tag_8021q_txvlan_del(struct felix *felix, int port, u16 vid)
+{
+	struct ocelot_vcap_filter *untagging_rule, *redirect_rule;
+	struct ocelot_vcap_block *block_vcap_is1;
+	struct ocelot_vcap_block *block_vcap_is2;
+	struct ocelot *ocelot = &felix->ocelot;
+	int err;
+
+	if (ocelot->ports[port]->is_dsa_8021q_cpu)
+		return 0;
+
+	block_vcap_is1 = &ocelot->block[VCAP_IS1];
+	block_vcap_is2 = &ocelot->block[VCAP_IS2];
+
+	untagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is1,
+							     port, false);
+	if (!untagging_rule)
+		return 0;
+
+	err = ocelot_vcap_filter_del(ocelot, untagging_rule);
+	if (err)
+		return err;
+
+	redirect_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is2,
+							    port, false);
+	if (!redirect_rule)
+		return 0;
+
+	return ocelot_vcap_filter_del(ocelot, redirect_rule);
+}
+
+static int felix_tag_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	if (vid_is_dsa_8021q_rxvlan(vid))
+		return felix_tag_8021q_rxvlan_del(ocelot_to_felix(ocelot),
+						  port, vid);
+
+	if (vid_is_dsa_8021q_txvlan(vid))
+		return felix_tag_8021q_txvlan_del(ocelot_to_felix(ocelot),
+						  port, vid);
+
+	return 0;
+}
+
+static const struct dsa_8021q_ops felix_tag_8021q_ops = {
+	.vlan_add	= felix_tag_8021q_vlan_add,
+	.vlan_del	= felix_tag_8021q_vlan_del,
+};
+
+/* Alternatively to using the NPI functionality, that same hardware MAC
+ * connected internally to the enetc or fman DSA master can be configured to
+ * use the software-defined tag_8021q frame format. As far as the hardware is
+ * concerned, it thinks it is a "dumb switch" - the queues of the CPU port
+ * module are now disconnected from it, but can still be accessed through
+ * register-based MMIO.
+ */
+static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
+{
+	ocelot->ports[port]->is_dsa_8021q_cpu = true;
+	ocelot->npi = -1;
+
+	/* Overwrite PGID_CPU with the non-tagging port */
+	ocelot_write_rix(ocelot, BIT(port), ANA_PGID_PGID, PGID_CPU);
+
+	ocelot_apply_bridge_fwd_mask(ocelot);
+}
+
+static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
+{
+	ocelot->ports[port]->is_dsa_8021q_cpu = false;
+
+	/* Restore PGID_CPU */
+	ocelot_write_rix(ocelot, BIT(ocelot->num_phys_ports), ANA_PGID_PGID,
+			 PGID_CPU);
+
+	ocelot_apply_bridge_fwd_mask(ocelot);
+}
+
+static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	unsigned long cpu_flood;
+	int port, err;
+
+	felix_8021q_cpu_port_init(ocelot, cpu);
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
+		/* This overwrites ocelot_init():
+		 * Do not forward BPDU frames to the CPU port module,
+		 * for 2 reasons:
+		 * - When these packets are injected from the tag_8021q
+		 *   CPU port, we want them to go out, not loop back
+		 *   into the system.
+		 * - STP traffic ingressing on a user port should go to
+		 *   the tag_8021q CPU port, not to the hardware CPU
+		 *   port module.
+		 */
+		ocelot_write_gix(ocelot,
+				 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0),
+				 ANA_PORT_CPU_FWD_BPDU_CFG, port);
+	}
+
+	/* In tag_8021q mode, the CPU port module is unused. So we
+	 * want to disable flooding of any kind to the CPU port module,
+	 * since packets going there will end in a black hole.
+	 */
+	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
+	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_UC);
+	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_MC);
+
+	felix->dsa_8021q_ctx = kzalloc(sizeof(*felix->dsa_8021q_ctx),
+				       GFP_KERNEL);
+	if (!felix->dsa_8021q_ctx)
+		return -ENOMEM;
+
+	felix->dsa_8021q_ctx->ops = &felix_tag_8021q_ops;
+	felix->dsa_8021q_ctx->proto = htons(ETH_P_8021AD);
+	felix->dsa_8021q_ctx->ds = ds;
+
+	err = dsa_8021q_setup(felix->dsa_8021q_ctx, true);
+	if (err)
+		goto out_free_dsa_8021_ctx;
+
+	return 0;
+
+out_free_dsa_8021_ctx:
+	kfree(felix->dsa_8021q_ctx);
+	return err;
+}
+
+static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int err, port;
+
+	err = dsa_8021q_setup(felix->dsa_8021q_ctx, false);
+	if (err)
+		dev_err(ds->dev, "dsa_8021q_setup returned %d", err);
+
+	kfree(felix->dsa_8021q_ctx);
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
+		/* Restore the logic from ocelot_init:
+		 * do not forward BPDU frames to the front ports.
+		 */
+		ocelot_write_gix(ocelot,
+				 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0xffff),
+				 ANA_PORT_CPU_FWD_BPDU_CFG,
+				 port);
+	}
+
+	felix_8021q_cpu_port_deinit(ocelot, cpu);
+}
+
 /* The CPU port module is connected to the Node Processor Interface (NPI). This
  * is the mode through which frames can be injected from and extracted to an
  * external CPU, over Ethernet. In NXP SoCs, the "external CPU" is the ARM CPU
@@ -107,6 +431,9 @@ static int felix_set_tag_protocol(struct dsa_switch *ds, int cpu,
 	case DSA_TAG_PROTO_OCELOT:
 		err = felix_setup_tag_npi(ds, cpu);
 		break;
+	case DSA_TAG_PROTO_OCELOT_8021Q:
+		err = felix_setup_tag_8021q(ds, cpu);
+		break;
 	default:
 		err = -EPROTONOSUPPORT;
 	}
@@ -121,11 +448,18 @@ static void felix_del_tag_protocol(struct dsa_switch *ds, int cpu,
 	case DSA_TAG_PROTO_OCELOT:
 		felix_teardown_tag_npi(ds, cpu);
 		break;
+	case DSA_TAG_PROTO_OCELOT_8021Q:
+		felix_teardown_tag_8021q(ds, cpu);
+		break;
 	default:
 		break;
 	}
 }
 
+/* This always leaves the switch in a consistent state, because although the
+ * tag_8021q setup can fail, the NPI setup can't. So either the change is made,
+ * or the restoration is guaranteed to work.
+ */
 static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
 				     enum dsa_tag_protocol proto)
 {
@@ -134,7 +468,8 @@ static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
 	enum dsa_tag_protocol old_proto = felix->tag_proto;
 	int err;
 
-	if (proto != DSA_TAG_PROTO_OCELOT)
+	if (proto != DSA_TAG_PROTO_OCELOT &&
+	    proto != DSA_TAG_PROTO_OCELOT_8021Q)
 		return -EPROTONOSUPPORT;
 
 	felix_del_tag_protocol(ds, cpu, old_proto);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 264b3bbdc4d1..9d4459f2fffb 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -48,6 +48,7 @@ struct felix {
 	struct lynx_pcs			**pcs;
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
+	struct dsa_8021q_context	*dsa_8021q_ctx;
 	enum dsa_tag_protocol		tag_proto;
 };
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 714165c2f85a..5f21799ad85b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -889,18 +889,60 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
+static u32 ocelot_get_dsa_8021q_cpu_mask(struct ocelot *ocelot)
 {
+	u32 mask = 0;
 	int port;
 
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port)
+			continue;
+
+		if (ocelot_port->is_dsa_8021q_cpu)
+			mask |= BIT(port);
+	}
+
+	return mask;
+}
+
+void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
+{
+	unsigned long cpu_fwd_mask;
+	int port;
+
+	/* If a DSA tag_8021q CPU exists, it needs to be included in the
+	 * regular forwarding path of the front ports regardless of whether
+	 * those are bridged or standalone.
+	 * If DSA tag_8021q is not used, this returns 0, which is fine because
+	 * the hardware-based CPU port module can be a destination for packets
+	 * even if it isn't part of PGID_SRC.
+	 */
+	cpu_fwd_mask = ocelot_get_dsa_8021q_cpu_mask(ocelot);
+
 	/* Apply FWD mask. The loop is needed to add/remove the current port as
 	 * a source for the other ports.
 	 */
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (ocelot->bridge_fwd_mask & BIT(port)) {
-			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		unsigned long mask;
+
+		if (!ocelot_port) {
+			/* Unused ports can't send anywhere */
+			mask = 0;
+		} else if (ocelot_port->is_dsa_8021q_cpu) {
+			/* The DSA tag_8021q CPU ports need to be able to
+			 * forward packets to all other ports except for
+			 * themselves
+			 */
+			mask = GENMASK(ocelot->num_phys_ports - 1, 0);
+			mask &= ~cpu_fwd_mask;
+		} else if (ocelot->bridge_fwd_mask & BIT(port)) {
 			int lag;
 
+			mask = ocelot->bridge_fwd_mask & ~BIT(port);
+
 			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
 				unsigned long bond_mask = ocelot->lags[lag];
 
@@ -912,15 +954,18 @@ static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 					break;
 				}
 			}
-
-			ocelot_write_rix(ocelot, mask,
-					 ANA_PGID_PGID, PGID_SRC + port);
 		} else {
-			ocelot_write_rix(ocelot, 0,
-					 ANA_PGID_PGID, PGID_SRC + port);
+			/* Standalone ports forward only to DSA tag_8021q CPU
+			 * ports (if those exist), or to the hardware CPU port
+			 * module otherwise.
+			 */
+			mask = cpu_fwd_mask;
 		}
+
+		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + port);
 	}
 }
+EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index b82fd4103a68..37a232911395 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1009,6 +1009,7 @@ ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int cookie,
 
 	return NULL;
 }
+EXPORT_SYMBOL(ocelot_vcap_block_find_filter_by_id);
 
 /* If @on=false, then SNAP, ARP, IP and OAM frames will not match on keys based
  * on destination and source MAC addresses, but only on higher-level protocol
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index 3b0c7916056e..523611ccc48f 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -14,9 +14,6 @@
 
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *rule);
-struct ocelot_vcap_filter *
-ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id,
-				    bool tc_offload);
 
 void ocelot_detect_vcap_constants(struct ocelot *ocelot);
 int ocelot_vcap_init(struct ocelot *ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 93c22627dedd..6a61c499a30d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -610,6 +610,7 @@ struct ocelot_port {
 	phy_interface_t			phy_mode;
 
 	u8				*xmit_template;
+	bool				is_dsa_8021q_cpu;
 };
 
 struct ocelot {
@@ -760,6 +761,7 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			struct phy_device *phydev);
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
+void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot);
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge);
 int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 76e01c927e17..25fd525aaf92 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -693,5 +693,8 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 			   struct netlink_ext_ack *extack);
 int ocelot_vcap_filter_del(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *rule);
+struct ocelot_vcap_filter *
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id,
+				    bool tc_offload);
 
 #endif /* _OCELOT_VCAP_H_ */
-- 
2.25.1

