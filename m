Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC75A6321C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 09:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfGIHbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 03:31:00 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33721 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726394AbfGIHbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 03:31:00 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 9 Jul 2019 10:30:57 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x697UuRG023415;
        Tue, 9 Jul 2019 10:30:57 +0300
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
Subject: [PATCH net-next v6 2/4] net/flow_dissector: add connection tracking dissection
Date:   Tue,  9 Jul 2019 10:30:49 +0300
Message-Id: <1562657451-20819-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1562657451-20819-1-git-send-email-paulb@mellanox.com>
References: <1562657451-20819-1-git-send-email-paulb@mellanox.com>
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
index b5d427b..1dcb674 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1324,6 +1324,16 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
 			   struct flow_dissector *flow_dissector,
 			   void *target_container);
 
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
index 02478e4..90bd210 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -208,6 +208,20 @@ struct flow_dissector_key_meta {
 	int ingress_ifindex;
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
@@ -234,6 +248,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_ENC_IP, /* struct flow_dissector_key_ip */
 	FLOW_DISSECTOR_KEY_ENC_OPTS, /* struct flow_dissector_key_enc_opts */
 	FLOW_DISSECTOR_KEY_META, /* struct flow_dissector_key_meta */
+	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 01ad60b..3e6fedb 100644
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
 
@@ -232,6 +236,46 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
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

