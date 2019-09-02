Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCACA50CC
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbfIBIDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:03:42 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:51350 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725839AbfIBICR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:02:17 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 92267C0436;
        Mon,  2 Sep 2019 08:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567411337; bh=hu2YS9Oelxiw/a+6Er0HIzbWLUC4uM2NmfdyKKUqwaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=I8ouv+mMCRWZAQd34jWVMzGjI/8dCLtZ2dVxeY68H28QJhSkoFzUqmw4WyG+DX0XE
         73T2ewRC4OIJZ7jb7uu1ZxW2Og5uOZ7R5pLlpQTAlf4JFBh1bddd87r7pgBqxNIoCB
         ASbjH5Qt+MO7Yo8s+oyGenDLrt/nJc4l0AbJpebhjYsSquWcoC573ZuPvDb6nnEnkj
         +Ri49e7l0UVEzEAHZbC4eiU4I0Thq19+yo1awMzvrgkh/sDqMA+sQ6dOosZxBWcQ4j
         US7e9AGRHZ4LlZaj3oL3vkGhio5clqCIyf+dUaxhbD7WXLOvyURyh5kYXn4Flo+FXo
         7hICYkWN1y1sQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 546A1A0072;
        Mon,  2 Sep 2019 08:02:15 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/13] net: stmmac: selftests: Add selftest for L3/L4 Filters
Date:   Mon,  2 Sep 2019 10:01:47 +0200
Message-Id: <f2b536e9370a448a40fc411712e717d4c605a3f5.1567410970.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the selftests for L3 and L4 filters with DA/SA/DP/SP support.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 254 ++++++++++++++++++++-
 1 file changed, 253 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index d3234338a0ca..8e9d0aeda817 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -164,7 +164,7 @@ static struct sk_buff *stmmac_test_get_udp_skb(struct stmmac_priv *priv,
 		iplen += sizeof(*uhdr);
 	ihdr->tot_len = htons(iplen);
 	ihdr->frag_off = 0;
-	ihdr->saddr = 0;
+	ihdr->saddr = htonl(attr->ip_src);
 	ihdr->daddr = htonl(attr->ip_dst);
 	ihdr->tos = 0;
 	ihdr->id = 0;
@@ -1168,6 +1168,234 @@ static int stmmac_test_svlanoff(struct stmmac_priv *priv)
 	return stmmac_test_vlanoff_common(priv, true);
 }
 
+#ifdef CONFIG_NET_CLS_ACT
+static int __stmmac_test_l3filt(struct stmmac_priv *priv, u32 dst, u32 src,
+				u32 dst_mask, u32 src_mask)
+{
+	struct flow_dissector_key_ipv4_addrs key, mask;
+	unsigned long dummy_cookie = 0xdeadbeef;
+	struct flow_dissector dissector = { };
+	struct stmmac_packet_attrs attr = { };
+	struct flow_cls_offload cls = { };
+	struct flow_rule *rule;
+	int ret;
+
+	if (!tc_can_offload(priv->dev))
+		return -EOPNOTSUPP;
+	if (!priv->dma_cap.l3l4fnum)
+		return -EOPNOTSUPP;
+	if (priv->rss.enable) {
+		struct stmmac_rss rss = { .enable = false, };
+
+		stmmac_rss_configure(priv, priv->hw, &rss,
+				     priv->plat->rx_queues_to_use);
+	}
+
+	dissector.used_keys |= (1 << FLOW_DISSECTOR_KEY_IPV4_ADDRS);
+	dissector.offset[FLOW_DISSECTOR_KEY_IPV4_ADDRS] = 0;
+
+	cls.common.chain_index = 0;
+	cls.command = FLOW_CLS_REPLACE;
+	cls.cookie = dummy_cookie;
+
+	rule = kzalloc(struct_size(rule, action.entries, 1), GFP_KERNEL);
+	if (!rule) {
+		ret = -ENOMEM;
+		goto cleanup_rss;
+	}
+
+	rule->match.dissector = &dissector;
+	rule->match.key = (void *)&key;
+	rule->match.mask = (void *)&mask;
+
+	key.src = htonl(src);
+	key.dst = htonl(dst);
+	mask.src = src_mask;
+	mask.dst = dst_mask;
+
+	cls.rule = rule;
+
+	rule->action.entries[0].id = FLOW_ACTION_DROP;
+	rule->action.num_entries = 1;
+
+	attr.dst = priv->dev->dev_addr;
+	attr.ip_dst = dst;
+	attr.ip_src = src;
+
+	/* Shall receive packet */
+	ret = __stmmac_test_loopback(priv, &attr);
+	if (ret)
+		goto cleanup_rule;
+
+	ret = stmmac_tc_setup_cls(priv, priv, &cls);
+	if (ret)
+		goto cleanup_rule;
+
+	/* Shall NOT receive packet */
+	ret = __stmmac_test_loopback(priv, &attr);
+	ret = ret ? 0 : -EINVAL;
+
+	cls.command = FLOW_CLS_DESTROY;
+	stmmac_tc_setup_cls(priv, priv, &cls);
+cleanup_rule:
+	kfree(rule);
+cleanup_rss:
+	if (priv->rss.enable) {
+		stmmac_rss_configure(priv, priv->hw, &priv->rss,
+				     priv->plat->rx_queues_to_use);
+	}
+
+	return ret;
+}
+#else
+static int __stmmac_test_l3filt(struct stmmac_priv *priv, u32 dst, u32 src,
+				u32 dst_mask, u32 src_mask)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+static int stmmac_test_l3filt_da(struct stmmac_priv *priv)
+{
+	u32 addr = 0x10203040;
+
+	return __stmmac_test_l3filt(priv, addr, 0, ~0, 0);
+}
+
+static int stmmac_test_l3filt_sa(struct stmmac_priv *priv)
+{
+	u32 addr = 0x10203040;
+
+	return __stmmac_test_l3filt(priv, 0, addr, 0, ~0);
+}
+
+#ifdef CONFIG_NET_CLS_ACT
+static int __stmmac_test_l4filt(struct stmmac_priv *priv, u32 dst, u32 src,
+				u32 dst_mask, u32 src_mask, bool udp)
+{
+	struct {
+		struct flow_dissector_key_basic bkey;
+		struct flow_dissector_key_ports key;
+	} __aligned(BITS_PER_LONG / 8) keys;
+	struct {
+		struct flow_dissector_key_basic bmask;
+		struct flow_dissector_key_ports mask;
+	} __aligned(BITS_PER_LONG / 8) masks;
+	unsigned long dummy_cookie = 0xdeadbeef;
+	struct flow_dissector dissector = { };
+	struct stmmac_packet_attrs attr = { };
+	struct flow_cls_offload cls = { };
+	struct flow_rule *rule;
+	int ret;
+
+	if (!tc_can_offload(priv->dev))
+		return -EOPNOTSUPP;
+	if (!priv->dma_cap.l3l4fnum)
+		return -EOPNOTSUPP;
+	if (priv->rss.enable) {
+		struct stmmac_rss rss = { .enable = false, };
+
+		stmmac_rss_configure(priv, priv->hw, &rss,
+				     priv->plat->rx_queues_to_use);
+	}
+
+	dissector.used_keys |= (1 << FLOW_DISSECTOR_KEY_BASIC);
+	dissector.used_keys |= (1 << FLOW_DISSECTOR_KEY_PORTS);
+	dissector.offset[FLOW_DISSECTOR_KEY_BASIC] = 0;
+	dissector.offset[FLOW_DISSECTOR_KEY_PORTS] = offsetof(typeof(keys), key);
+
+	cls.common.chain_index = 0;
+	cls.command = FLOW_CLS_REPLACE;
+	cls.cookie = dummy_cookie;
+
+	rule = kzalloc(struct_size(rule, action.entries, 1), GFP_KERNEL);
+	if (!rule) {
+		ret = -ENOMEM;
+		goto cleanup_rss;
+	}
+
+	rule->match.dissector = &dissector;
+	rule->match.key = (void *)&keys;
+	rule->match.mask = (void *)&masks;
+
+	keys.bkey.ip_proto = udp ? IPPROTO_UDP : IPPROTO_TCP;
+	keys.key.src = htons(src);
+	keys.key.dst = htons(dst);
+	masks.mask.src = src_mask;
+	masks.mask.dst = dst_mask;
+
+	cls.rule = rule;
+
+	rule->action.entries[0].id = FLOW_ACTION_DROP;
+	rule->action.num_entries = 1;
+
+	attr.dst = priv->dev->dev_addr;
+	attr.tcp = !udp;
+	attr.sport = src;
+	attr.dport = dst;
+	attr.ip_dst = 0;
+
+	/* Shall receive packet */
+	ret = __stmmac_test_loopback(priv, &attr);
+	if (ret)
+		goto cleanup_rule;
+
+	ret = stmmac_tc_setup_cls(priv, priv, &cls);
+	if (ret)
+		goto cleanup_rule;
+
+	/* Shall NOT receive packet */
+	ret = __stmmac_test_loopback(priv, &attr);
+	ret = ret ? 0 : -EINVAL;
+
+	cls.command = FLOW_CLS_DESTROY;
+	stmmac_tc_setup_cls(priv, priv, &cls);
+cleanup_rule:
+	kfree(rule);
+cleanup_rss:
+	if (priv->rss.enable) {
+		stmmac_rss_configure(priv, priv->hw, &priv->rss,
+				     priv->plat->rx_queues_to_use);
+	}
+
+	return ret;
+}
+#else
+static int __stmmac_test_l4filt(struct stmmac_priv *priv, u32 dst, u32 src,
+				u32 dst_mask, u32 src_mask, bool udp)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+static int stmmac_test_l4filt_da_tcp(struct stmmac_priv *priv)
+{
+	u16 dummy_port = 0x123;
+
+	return __stmmac_test_l4filt(priv, dummy_port, 0, ~0, 0, false);
+}
+
+static int stmmac_test_l4filt_sa_tcp(struct stmmac_priv *priv)
+{
+	u16 dummy_port = 0x123;
+
+	return __stmmac_test_l4filt(priv, 0, dummy_port, 0, ~0, false);
+}
+
+static int stmmac_test_l4filt_da_udp(struct stmmac_priv *priv)
+{
+	u16 dummy_port = 0x123;
+
+	return __stmmac_test_l4filt(priv, dummy_port, 0, ~0, 0, true);
+}
+
+static int stmmac_test_l4filt_sa_udp(struct stmmac_priv *priv)
+{
+	u16 dummy_port = 0x123;
+
+	return __stmmac_test_l4filt(priv, 0, dummy_port, 0, ~0, true);
+}
+
 #define STMMAC_LOOPBACK_NONE	0
 #define STMMAC_LOOPBACK_MAC	1
 #define STMMAC_LOOPBACK_PHY	2
@@ -1253,6 +1481,30 @@ static const struct stmmac_test {
 		.name = "SVLAN TX Insertion  ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_svlanoff,
+	}, {
+		.name = "L3 DA Filtering     ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_l3filt_da,
+	}, {
+		.name = "L3 SA Filtering     ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_l3filt_sa,
+	}, {
+		.name = "L4 DA TCP Filtering ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_l4filt_da_tcp,
+	}, {
+		.name = "L4 SA TCP Filtering ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_l4filt_sa_tcp,
+	}, {
+		.name = "L4 DA UDP Filtering ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_l4filt_da_udp,
+	}, {
+		.name = "L4 SA UDP Filtering ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_l4filt_sa_udp,
 	},
 };
 
-- 
2.7.4

