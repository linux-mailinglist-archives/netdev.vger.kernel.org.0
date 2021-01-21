Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59DB2FF008
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbhAUQTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731507AbhAUQEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 11:04:05 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B761C0617A9
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:42 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id hs11so3355600ejc.1
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bm9qBC8ap96BR+8NABDb1wab8/vNSBiRP15yEdYFMis=;
        b=qar2ZveDllm3oSVbp1hB/GAUqXeNcl8DbqHTTXwVaC9XCSl5lh8S/G75at1iRNZqOo
         OPbtJXXPTK+7HRjjcn/cQixUUFbOv6qXybFBsZYsU7IXqSp07ECeW30wscpGNohQI6kP
         RXZuH9nVX6oS6/t5H706B03onB5e1PzGWrDcB/lBZiKud2qCaa36AzWn+MBUSqQL7S7F
         7n1HRgStysWvVdjF3G46PZfijEp9N4Lkn5moPiGVCEz/RbBBLCJxEJIdzzCeDMell33V
         RQUzZFn1HUz1IIy+oWFtJ3nxGG1qIWcPdOvj3da42ycV5IK5zZXrbrmHf4d4QScHNulI
         qDLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bm9qBC8ap96BR+8NABDb1wab8/vNSBiRP15yEdYFMis=;
        b=S9XeJLXoUPpQN7Cse9gHWv+ownSPm+2PCi3a6sXqFN/nTb+TNbP1KSKl5gkCtj6e73
         N8C/O2sRK2NnD5JueE4N6ZsVYNlh/PyrzZ+XmnCa0/i2TRfMEP7/0J6lGTS+LA6OAd06
         nj3HRt7WBJdgfNZbVfy6Pox2BXK4pY/JT9c/BR3xIn2YuUUlsBKCPp8YG80XRwqd9svt
         Hi9fWB6DMy/30I8opP/y2Lkl8r8Rey6M0CvUKXuj5SBA0P6+/8CiaKnedNjGz9AJJhFV
         C/DK/LSYkI5kqeombANhvX06GRpJt0YEXrBEFHEl7Fe+4GCWTCoeBvm0LJP3VJ3Ms6rg
         /p9A==
X-Gm-Message-State: AOAM5313TLxTP5EJZOElL93jBeqEJTPMPkSItLT/a2N8S5K9R9C7LXS+
        BoTatYKfO5TkYj3u+n/aM2I=
X-Google-Smtp-Source: ABdhPJz8JuXr8GktSCUEwg3AcSFn+Jq9d+1NIcRx/4gJamfx+GXTdiPGxIJ8V3CTJEH+/aeQABi6tA==
X-Received: by 2002:a17:906:3b0b:: with SMTP id g11mr92321ejf.169.1611244960825;
        Thu, 21 Jan 2021 08:02:40 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id zk10sm2419973ejb.10.2021.01.21.08.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 08:02:40 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 10/10] net: dsa: felix: perform switch setup for tag_8021q
Date:   Thu, 21 Jan 2021 18:01:31 +0200
Message-Id: <20210121160131.2364236-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121160131.2364236-1-olteanv@gmail.com>
References: <20210121160131.2364236-1-olteanv@gmail.com>
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

 drivers/net/dsa/ocelot/felix.c          | 332 ++++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix.h          |   1 +
 drivers/net/ethernet/mscc/ocelot.c      |  33 ++-
 drivers/net/ethernet/mscc/ocelot_vcap.c |   1 +
 drivers/net/ethernet/mscc/ocelot_vcap.h |   3 -
 include/soc/mscc/ocelot.h               |   1 +
 include/soc/mscc/ocelot_vcap.h          |   3 +
 7 files changed, 363 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f45dfb800bcb..7096b5985199 100644
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
@@ -24,6 +25,331 @@
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
+}
+
+static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
+{
+	ocelot->ports[port]->is_dsa_8021q_cpu = false;
+
+	/* Restore PGID_CPU */
+	ocelot_write_rix(ocelot, BIT(ocelot->num_phys_ports), ANA_PGID_PGID,
+			 PGID_CPU);
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
+	ocelot_apply_bridge_fwd_mask(ocelot);
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
+	rtnl_lock();
+	err = dsa_8021q_setup(felix->dsa_8021q_ctx, true);
+	rtnl_unlock();
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
+	rtnl_lock();
+	err = dsa_8021q_setup(felix->dsa_8021q_ctx, false);
+	rtnl_unlock();
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
@@ -119,6 +445,9 @@ static int felix_set_tag_protocol(struct dsa_switch *ds, int cpu,
 	case DSA_TAG_PROTO_OCELOT:
 		err = felix_setup_tag_npi(ds, cpu);
 		break;
+	case DSA_TAG_PROTO_OCELOT_8021Q:
+		err = felix_setup_tag_8021q(ds, cpu);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 	}
@@ -133,6 +462,9 @@ static void felix_del_tag_protocol(struct dsa_switch *ds, int cpu,
 	case DSA_TAG_PROTO_OCELOT:
 		felix_teardown_tag_npi(ds, cpu);
 		break;
+	case DSA_TAG_PROTO_OCELOT_8021Q:
+		felix_teardown_tag_8021q(ds, cpu);
+		break;
 	default:
 		break;
 	}
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
index ebc797a08506..4217d5e18689 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -891,16 +891,37 @@ EXPORT_SYMBOL(ocelot_get_ts_info);
 
 void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 {
+	unsigned long cpu_fwd_mask = 0;
 	int port;
 
+	/* If a DSA tag_8021q CPU exists, it needs to be unconditionally
+	 * (i.e. regardless of whether the port is bridged or standalone)
+	 * included in the regular forwarding path, as opposed to the
+	 * hardware-based CPU port module which can be a destination for
+	 * packets even if it isn't part of PGID_SRC.
+	 */
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		if (ocelot->ports[port]->is_dsa_8021q_cpu)
+			cpu_fwd_mask |= BIT(port);
+
 	/* Apply FWD mask. The loop is needed to add/remove the current port as
 	 * a source for the other ports.
 	 */
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (ocelot->bridge_fwd_mask & BIT(port)) {
-			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
+		/* Standalone ports forward only to DSA tag_8021q CPU ports */
+		unsigned long mask = cpu_fwd_mask;
+
+		/* The DSA tag_8021q CPU ports need to be able to forward
+		 * packets to all other ports except for themselves
+		 */
+		if (ocelot->ports[port]->is_dsa_8021q_cpu) {
+			mask = GENMASK(ocelot->num_phys_ports - 1, 0);
+			mask &= ~cpu_fwd_mask;
+		} else if (ocelot->bridge_fwd_mask & BIT(port)) {
 			int lag;
 
+			mask |= ocelot->bridge_fwd_mask & ~BIT(port);
+
 			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
 				unsigned long bond_mask = ocelot->lags[lag];
 
@@ -912,13 +933,9 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 					break;
 				}
 			}
-
-			ocelot_write_rix(ocelot, mask,
-					 ANA_PGID_PGID, PGID_SRC + port);
-		} else {
-			ocelot_write_rix(ocelot, 0,
-					 ANA_PGID_PGID, PGID_SRC + port);
 		}
+
+		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + port);
 	}
 }
 EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
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
index fba24a0327d4..6a61c499a30d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -610,6 +610,7 @@ struct ocelot_port {
 	phy_interface_t			phy_mode;
 
 	u8				*xmit_template;
+	bool				is_dsa_8021q_cpu;
 };
 
 struct ocelot {
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

