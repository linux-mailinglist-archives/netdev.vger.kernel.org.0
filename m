Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5105F4CF31
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731980AbfFTNmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:42:37 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43625 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731831AbfFTNme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 09:42:34 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 Jun 2019 16:42:29 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5KDgSlN022418;
        Thu, 20 Jun 2019 16:42:29 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Jiri Pirko <jiri@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: [PATCH net-next v2 2/4] net/flow_dissector: add connection tracking dissection
Date:   Thu, 20 Jun 2019 16:42:19 +0300
Message-Id: <1561038141-31370-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
References: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Retreives connection tracking zone, mark, label, and state from
a SKB.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/linux/skbuff.h       | 10 ++++++++++
 include/net/flow_dissector.h | 15 +++++++++++++++
 net/core/flow_dissector.c    | 44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 28bdaf9..e91cc60 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1320,6 +1320,16 @@ static inline bool skb_flow_dissect_flow_keys(const struct sk_buff *skb,
 				  data, proto, nhoff, hlen, flags);
 }
 
+/* Gets a skb connection tracking info, ctinfo map should be a
+ * a map of mapsize to translate enum ip_conntrack_info states
+ * to user states.
+ */
+void
+skb_flow_dissect_ct(const struct sk_buff *skb,
+		    struct flow_dissector *flow_dissector,
+		    void *target_container,
+		    u16 *ctinfo_map,
+		    size_t mapsize);
 void
 skb_flow_dissect_tunnel_info(const struct sk_buff *skb,
 			     struct flow_dissector *flow_dissector,
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index d7ce647..76dcba3 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -200,6 +200,20 @@ struct flow_dissector_key_ip {
 	__u8	ttl;
 };
 
+/**
+ * struct flow_dissector_key_ct:
+ * @ct_state: conntrack state after converting with map
+ * @ct_mark: conttrack mark
+ * @ct_zone: conntrack zone
+ * @ct_labels: conntrack labels
+ */
+struct flow_dissector_key_ct {
+	u16	ct_state;
+	u16	ct_zone;
+	u32	ct_mark;
+	u32	ct_labels[4];
+};
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -225,6 +239,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CVLAN, /* struct flow_dissector_key_vlan */
 	FLOW_DISSECTOR_KEY_ENC_IP, /* struct flow_dissector_key_ip */
 	FLOW_DISSECTOR_KEY_ENC_OPTS, /* struct flow_dissector_key_enc_opts */
+	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index c0559af..293bffc 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -27,6 +27,10 @@
 #include <scsi/fc/fc_fcoe.h>
 #include <uapi/linux/batadv_packet.h>
 #include <linux/bpf.h>
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_labels.h>
+#endif
 
 static DEFINE_MUTEX(flow_dissector_mutex);
 
@@ -216,6 +220,46 @@ __be32 __skb_flow_get_ports(const struct sk_buff *skb, int thoff, u8 ip_proto,
 }
 
 void
+skb_flow_dissect_ct(const struct sk_buff *skb,
+		    struct flow_dissector *flow_dissector,
+		    void *target_container,
+		    u16 *ctinfo_map,
+		    size_t mapsize)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	struct flow_dissector_key_ct *key;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn_labels *cl;
+	struct nf_conn *ct;
+
+	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_CT))
+		return;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return;
+
+	key = skb_flow_dissector_target(flow_dissector,
+					FLOW_DISSECTOR_KEY_CT,
+					target_container);
+
+	if (ctinfo < mapsize)
+		key->ct_state = ctinfo_map[ctinfo];
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)
+	key->ct_zone = ct->zone.id;
+#endif
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
+	key->ct_mark = ct->mark;
+#endif
+
+	cl = nf_ct_labels_find(ct);
+	if (cl)
+		memcpy(key->ct_labels, cl->bits, sizeof(key->ct_labels));
+#endif /* CONFIG_NF_CONNTRACK */
+}
+EXPORT_SYMBOL(skb_flow_dissect_ct);
+
+void
 skb_flow_dissect_tunnel_info(const struct sk_buff *skb,
 			     struct flow_dissector *flow_dissector,
 			     void *target_container)
-- 
1.8.3.1

