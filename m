Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA916EB1E
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbfD2Tuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:50:32 -0400
Received: from mail.us.es ([193.147.175.20]:41730 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729271AbfD2Tub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:50:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B5471031A7
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:50:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09DF6DA70C
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:50:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 08BD2DA704; Mon, 29 Apr 2019 21:50:29 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0D26DA70E;
        Mon, 29 Apr 2019 21:50:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 29 Apr 2019 21:50:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 93D0A4265A31;
        Mon, 29 Apr 2019 21:50:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH 6/9 net-next,v2] netfilter: nf_conntrack: allow to register bridge support
Date:   Mon, 29 Apr 2019 21:50:11 +0200
Message-Id: <20190429195014.4724-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190429195014.4724-1-pablo@netfilter.org>
References: <20190429195014.4724-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds infrastructure to register and to unregister bridge
support for the conntrack module via nf_ct_bridge_register() and
nf_ct_bridge_unregister().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/net/netfilter/nf_conntrack.h        |  1 +
 include/net/netfilter/nf_conntrack_bridge.h | 13 ++++++
 net/netfilter/nf_conntrack_proto.c          | 61 +++++++++++++++++++++++++++--
 3 files changed, 72 insertions(+), 3 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_bridge.h

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index d2bc733a2ef1..5cb19ce454d1 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -49,6 +49,7 @@ union nf_conntrack_expect_proto {
 struct nf_conntrack_net {
 	unsigned int users4;
 	unsigned int users6;
+	unsigned int users_bridge;
 };
 
 #include <linux/types.h>
diff --git a/include/net/netfilter/nf_conntrack_bridge.h b/include/net/netfilter/nf_conntrack_bridge.h
new file mode 100644
index 000000000000..3be1642e04f7
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_bridge.h
@@ -0,0 +1,13 @@
+#ifndef NF_CONNTRACK_BRIDGE_
+#define NF_CONNTRACK_BRIDGE_
+
+struct nf_ct_bridge_info {
+	struct nf_hook_ops	*ops;
+	unsigned int		ops_size;
+	struct module		*me;
+};
+
+void nf_ct_bridge_register(struct nf_ct_bridge_info *info);
+void nf_ct_bridge_unregister(struct nf_ct_bridge_info *info);
+
+#endif
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 37bb530d848f..3813cb551df9 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -16,6 +16,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_bridge.h>
 #include <net/netfilter/nf_log.h>
 
 #include <linux/ip.h>
@@ -442,12 +443,14 @@ static int nf_ct_tcp_fixup(struct nf_conn *ct, void *_nfproto)
 	return 0;
 }
 
+static struct nf_ct_bridge_info *nf_ct_bridge_info;
+
 static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
 {
 	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
-	bool fixup_needed = false;
+	bool fixup_needed = false, retry = true;
 	int err = 0;
-
+retry:
 	mutex_lock(&nf_ct_proto_mutex);
 
 	switch (nfproto) {
@@ -487,6 +490,32 @@ static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
 			fixup_needed = true;
 		break;
 #endif
+	case NFPROTO_BRIDGE:
+		if (!nf_ct_bridge_info) {
+			if (!retry) {
+				err = -EPROTO;
+				goto out_unlock;
+			}
+			mutex_unlock(&nf_ct_proto_mutex);
+			request_module("nf_conntrack_bridge");
+			retry = false;
+			goto retry;
+		}
+		if (!try_module_get(nf_ct_bridge_info->me)) {
+			err = -EPROTO;
+			goto out_unlock;
+		}
+		cnet->users_bridge++;
+		if (cnet->users_bridge > 1)
+			goto out_unlock;
+
+		err = nf_register_net_hooks(net, nf_ct_bridge_info->ops,
+					    nf_ct_bridge_info->ops_size);
+		if (err)
+			cnet->users_bridge = 0;
+		else
+			fixup_needed = true;
+		break;
 	default:
 		err = -EPROTO;
 		break;
@@ -519,8 +548,16 @@ static void nf_ct_netns_do_put(struct net *net, u8 nfproto)
 						ARRAY_SIZE(ipv6_conntrack_ops));
 		break;
 #endif
+	case NFPROTO_BRIDGE:
+		if (!nf_ct_bridge_info)
+			break;
+		if (cnet->users_bridge && (--cnet->users_bridge == 0))
+			nf_unregister_net_hooks(net, nf_ct_bridge_info->ops,
+						nf_ct_bridge_info->ops_size);
+
+		module_put(nf_ct_bridge_info->me);
+		break;
 	}
-
 	mutex_unlock(&nf_ct_proto_mutex);
 }
 
@@ -560,6 +597,24 @@ void nf_ct_netns_put(struct net *net, uint8_t nfproto)
 }
 EXPORT_SYMBOL_GPL(nf_ct_netns_put);
 
+void nf_ct_bridge_register(struct nf_ct_bridge_info *info)
+{
+	WARN_ON(nf_ct_bridge_info);
+	mutex_lock(&nf_ct_proto_mutex);
+	nf_ct_bridge_info = info;
+	mutex_unlock(&nf_ct_proto_mutex);
+}
+EXPORT_SYMBOL_GPL(nf_ct_bridge_register);
+
+void nf_ct_bridge_unregister(struct nf_ct_bridge_info *info)
+{
+	WARN_ON(!nf_ct_bridge_info);
+	mutex_lock(&nf_ct_proto_mutex);
+	nf_ct_bridge_info = NULL;
+	mutex_unlock(&nf_ct_proto_mutex);
+}
+EXPORT_SYMBOL_GPL(nf_ct_bridge_unregister);
+
 int nf_conntrack_proto_init(void)
 {
 	int ret;
-- 
2.11.0

