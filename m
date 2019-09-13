Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED72B1C3B
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388197AbfIMLbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:31 -0400
Received: from correo.us.es ([193.147.175.20]:42650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388158AbfIMLb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 412E54FFE06
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 331F0A7E20
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 28D6DA7E2B; Fri, 13 Sep 2019 13:31:25 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C7F8A7E23;
        Fri, 13 Sep 2019 13:31:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D4B7942EE393;
        Fri, 13 Sep 2019 13:31:22 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 21/27] netfilter: conntrack: wrap two inline functions in config checks.
Date:   Fri, 13 Sep 2019 13:30:56 +0200
Message-Id: <20190913113102.15776-22-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

nf_conntrack_synproxy.h contains three inline functions.  The contents
of two of them are wrapped in CONFIG_NETFILTER_SYNPROXY checks and just
return NULL if it is not enabled.  The third does nothing if they return
NULL, so wrap its contents as well.

nf_ct_timeout_data is only called if CONFIG_NETFILTER_TIMEOUT is
enabled.  Wrap its contents in a CONFIG_NETFILTER_TIMEOUT check like the
other inline functions in nf_conntrack_timeout.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_synproxy.h | 2 ++
 include/net/netfilter/nf_conntrack_timeout.h  | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index c22f0c11cc82..6a3ab081e4bf 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -32,6 +32,7 @@ static inline struct nf_conn_synproxy *nfct_synproxy_ext_add(struct nf_conn *ct)
 static inline bool nf_ct_add_synproxy(struct nf_conn *ct,
 				      const struct nf_conn *tmpl)
 {
+#if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
 	if (tmpl && nfct_synproxy(tmpl)) {
 		if (!nfct_seqadj_ext_add(ct))
 			return false;
@@ -39,6 +40,7 @@ static inline bool nf_ct_add_synproxy(struct nf_conn *ct,
 		if (!nfct_synproxy_ext_add(ct))
 			return false;
 	}
+#endif
 
 	return true;
 }
diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 00a8fbb2d735..6dd72396f534 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -32,6 +32,7 @@ struct nf_conn_timeout {
 static inline unsigned int *
 nf_ct_timeout_data(const struct nf_conn_timeout *t)
 {
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	struct nf_ct_timeout *timeout;
 
 	timeout = rcu_dereference(t->timeout);
@@ -39,6 +40,9 @@ nf_ct_timeout_data(const struct nf_conn_timeout *t)
 		return NULL;
 
 	return (unsigned int *)timeout->data;
+#else
+	return NULL;
+#endif
 }
 
 static inline
-- 
2.11.0

