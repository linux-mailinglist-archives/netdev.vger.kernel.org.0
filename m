Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18EB39F8D
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfFHMFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:44 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39867 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfFHMFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so4194818wma.4;
        Sat, 08 Jun 2019 05:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fegUdc32mRfOk+AIf8+8oiKgbt/kZU0AMdC5SBIqumA=;
        b=rCGXGLeqFmVkkgzSjuzkGzyKtH21rGvtLMFVDd/3j6mw3za3JpQoMkGrp8BU7bQXjp
         T98WuS1dgwNkE2fi14ForrjbhMLubUPkU5uympZOnUtok+/5pjbFutdPG/Q+SoSanDK3
         77xfdsrEklSje1YCaHlj3BxkRgohNibo5oPhCDnGV8rrajMGlQe9hVGbhgcXhpjzjWoE
         sagfvjL4yXtl3JlJkBU5xjX+lrs94HhECXBc1CEcPhUMa2kEwPPwrXcwVQ5jjy0TBEzO
         oKSDUJcMW9wYyU20600ArSl4o3HIkxdxVI519zWpgC3jiV3woXGIr9h13EinxPMDpiFy
         EvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fegUdc32mRfOk+AIf8+8oiKgbt/kZU0AMdC5SBIqumA=;
        b=Yj6EaGpPPPr+Lu2AzMwO8jCXGYp6FWcL4FCAa6xHEH35ssW3wQPHRPDbW1RFqRyeXY
         aStRhxDLD8FRgsVJXWWgq+7jjXstOLmVlqfD8nFpc5IS4yDA0PdHkjDrzws9xgaS21V7
         dCX1yg59dlofSsQRZr4FSvOR8Slrz6FKq5eoC1vJcUcE3k3bFTRrdHeH2hTfI7T4o41Q
         StJU0cpje/VuMuBmjDR/xVbbSbX9OgyUynAEE/TbJrRSTx8aWzpV4fz+sbdeHUC3UXpD
         VgMCBxwxXdT1WfVsMestLCNELvncWl4uuZuOhSZU+HHk4pwxZQ1DKsZRbKjF0f6gUoRJ
         oaUg==
X-Gm-Message-State: APjAAAXwgkzelLAZAfQCYU4/tSlhU/5aZZXqMcKgnx+6sPhL0hXrEXZI
        2UnfP7UUEygzZ0NMaTxFK5E=
X-Google-Smtp-Source: APXvYqx2RCnzPP/0DUFZkADebBPu+AtcFSAmwM5z++ijlXxqm/HnTxK3mJKbBQ7m9h9QipN/Mah+jA==
X-Received: by 2002:a1c:23c4:: with SMTP id j187mr7125955wmj.176.1559995540935;
        Sat, 08 Jun 2019 05:05:40 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 06/17] net: dsa: sja1105: Limit use of incl_srcpt to bridge+vlan mode
Date:   Sat,  8 Jun 2019 15:04:32 +0300
Message-Id: <20190608120443.21889-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The incl_srcpt setting makes the switch mangle the destination MACs of
multicast frames trapped to the CPU - a primitive tagging mechanism that
works even when we cannot use the 802.1Q software features.

The downside is that the two multicast MAC addresses that the switch
traps for L2 PTP (01-80-C2-00-00-0E and 01-1B-19-00-00-00) quickly turn
into a lot more, as the switch encodes the source port and switch id
into bytes 3 and 4 of the MAC. The resulting range of MAC addresses
would need to be installed manually into the DSA master port's multicast
MAC filter, and even then, most devices might not have a large enough
MAC filtering table.

As a result, only limit use of incl_srcpt to when it's strictly
necessary: when under a VLAN filtering bridge.  This fixes PTP in
non-bridged mode (standalone ports). Otherwise, PTP frames, as well as
metadata follow-up frames holding RX timestamps won't be received
because they will be blocked by the master port's MAC filter.
Linuxptp doesn't help, because it only requests the addition of the
unmodified PTP MACs to the multicast filter.
This issue is not seen in bridged mode because the master port is put in
promiscuous mode when the slave ports are enslaved to a bridge.
Therefore, there is no downside to having the incl_srcpt mechanism
active there.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:

Moved most of the changes in 03/17 which makes the diff cleaner.

Changes in v3:

None.

Changes in v2:

Patch is new.

 drivers/net/dsa/sja1105/sja1105_main.c |  9 +++++++--
 net/dsa/tag_sja1105.c                  | 18 +++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ecb54b828593..ea854ea903d1 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -392,11 +392,11 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.hostprio = 0,
 		.mac_fltres1 = SJA1105_LINKLOCAL_FILTER_A,
 		.mac_flt1    = SJA1105_LINKLOCAL_FILTER_A_MASK,
-		.incl_srcpt1 = true,
+		.incl_srcpt1 = false,
 		.send_meta1  = false,
 		.mac_fltres0 = SJA1105_LINKLOCAL_FILTER_B,
 		.mac_flt0    = SJA1105_LINKLOCAL_FILTER_B_MASK,
-		.incl_srcpt0 = true,
+		.incl_srcpt0 = false,
 		.send_meta0  = false,
 		/* The destination for traffic matching mac_fltres1 and
 		 * mac_fltres0 on all ports except host_port. Such traffic
@@ -1435,6 +1435,11 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	general_params->tpid = tpid;
 	/* EtherType used to identify inner tagged (C-tag) VLAN traffic */
 	general_params->tpid2 = tpid2;
+	/* When VLAN filtering is on, we need to at least be able to
+	 * decode management traffic through the "backup plan".
+	 */
+	general_params->incl_srcpt1 = enabled;
+	general_params->incl_srcpt0 = enabled;
 
 	rc = sja1105_static_config_reload(priv);
 	if (rc)
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 77eeea004e92..cd8e0bfb5e75 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -69,15 +69,24 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	int source_port, switch_id;
 	struct vlan_ethhdr *hdr;
 	u16 tpid, vid, tci;
+	bool is_link_local;
 	bool is_tagged;
 
 	hdr = vlan_eth_hdr(skb);
 	tpid = ntohs(hdr->h_vlan_proto);
 	is_tagged = (tpid == ETH_P_SJA1105);
+	is_link_local = sja1105_is_link_local(skb);
 
 	skb->offload_fwd_mark = 1;
 
-	if (sja1105_is_link_local(skb)) {
+	if (is_tagged) {
+		/* Normal traffic path. */
+		tci = ntohs(hdr->h_vlan_TCI);
+		vid = tci & VLAN_VID_MASK;
+		source_port = dsa_8021q_rx_source_port(vid);
+		switch_id = dsa_8021q_rx_switch_id(vid);
+		skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	} else if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
 		 * the incl_srcpt options.
@@ -88,12 +97,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		hdr->h_dest[3] = 0;
 		hdr->h_dest[4] = 0;
 	} else {
-		/* Normal traffic path. */
-		tci = ntohs(hdr->h_vlan_TCI);
-		vid = tci & VLAN_VID_MASK;
-		source_port = dsa_8021q_rx_source_port(vid);
-		switch_id = dsa_8021q_rx_switch_id(vid);
-		skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+		return NULL;
 	}
 
 	skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
-- 
2.17.1

