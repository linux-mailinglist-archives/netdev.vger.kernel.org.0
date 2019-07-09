Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8312A63CEF
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfGIU4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:56:15 -0400
Received: from mail.us.es ([193.147.175.20]:36854 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729828AbfGIU4O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 16:56:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4B01628804AF
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39448114D71
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 37F62114D6E; Tue,  9 Jul 2019 22:56:12 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 824911150CC;
        Tue,  9 Jul 2019 22:56:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Jul 2019 22:56:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.194.134])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7633D4265A31;
        Tue,  9 Jul 2019 22:56:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com, phil@nwl.cc, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next,v4 04/12] net: flow_offload: add flow_block_cb_alloc() and flow_block_cb_free()
Date:   Tue,  9 Jul 2019 22:55:42 +0200
Message-Id: <20190709205550.3160-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190709205550.3160-1-pablo@netfilter.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new helper function to allocate flow_block_cb objects.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: no changes.

 include/net/flow_offload.h | 14 ++++++++++++++
 net/core/flow_offload.c    | 28 ++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 0d7d1e6d6f2a..bcc4e2fef6ba 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -255,6 +255,20 @@ struct flow_block_offload {
 	struct netlink_ext_ack *extack;
 };
 
+struct flow_block_cb {
+	struct list_head	list;
+	tc_setup_cb_t		*cb;
+	void			*cb_ident;
+	void			*cb_priv;
+	void			(*release)(void *cb_priv);
+	unsigned int		refcnt;
+};
+
+struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
+					  void *cb_ident, void *cb_priv,
+					  void (*release)(void *cb_priv));
+void flow_block_cb_free(struct flow_block_cb *block_cb);
+
 int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       struct list_head *driver_list, tc_setup_cb_t *cb,
 			       void *cb_ident, void *cb_priv, bool ingress_only);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 6d8187e8effc..d08148cb6953 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -166,6 +166,34 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_enc_opts);
 
+struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
+					  void *cb_ident, void *cb_priv,
+					  void (*release)(void *cb_priv))
+{
+	struct flow_block_cb *block_cb;
+
+	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
+	if (!block_cb)
+		return ERR_PTR(-ENOMEM);
+
+	block_cb->cb = cb;
+	block_cb->cb_ident = cb_ident;
+	block_cb->cb_priv = cb_priv;
+	block_cb->release = release;
+
+	return block_cb;
+}
+EXPORT_SYMBOL(flow_block_cb_alloc);
+
+void flow_block_cb_free(struct flow_block_cb *block_cb)
+{
+	if (block_cb->release)
+		block_cb->release(block_cb->cb_priv);
+
+	kfree(block_cb);
+}
+EXPORT_SYMBOL(flow_block_cb_free);
+
 int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       struct list_head *driver_block_list,
 			       tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
-- 
2.11.0


