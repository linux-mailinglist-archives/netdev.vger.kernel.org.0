Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552E0625AB
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391351AbfGHQGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:06:35 -0400
Received: from mail.us.es ([193.147.175.20]:52862 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391258AbfGHQGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 12:06:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3475FB6328
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 18:06:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25BE5A0AC7
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 18:06:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 24803DA708; Mon,  8 Jul 2019 18:06:32 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D8DB1021B2;
        Mon,  8 Jul 2019 18:06:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 18:06:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D7FFA4265A2F;
        Mon,  8 Jul 2019 18:06:27 +0200 (CEST)
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
        cphealy@gmail.com, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next,v3 06/11] net: flow_offload: add flow_block_cb_{priv,incref,decref}()
Date:   Mon,  8 Jul 2019 18:06:08 +0200
Message-Id: <20190708160614.2226-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708160614.2226-1-pablo@netfilter.org>
References: <20190708160614.2226-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch completes the flow block API to introduce:

* flow_block_cb_priv() to accept callback private data.
* flow_block_cb_incref() to bump reference counter on this flow block.
* flow_block_cb_decref() to decrement the reference counter.

These function are taken from the existing tcf_block_cb_priv(),
tcf_block_cb_incref() and tcf_block_cb_decref().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: missing in previous batch.

 include/net/flow_offload.h |  4 ++++
 net/core/flow_offload.c    | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 06acde2960fa..342e6aef7e3a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -277,6 +277,10 @@ struct flow_block_cb *flow_block_cb_lookup(struct net *net,
 					   struct list_head *driver_flow_block_list,
 					   tc_setup_cb_t *cb, void *cb_ident);
 
+void *flow_block_cb_priv(struct flow_block_cb *block_cb);
+void flow_block_cb_incref(struct flow_block_cb *block_cb);
+unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb);
+
 static inline void flow_block_cb_add(struct flow_block_cb *block_cb,
 				     struct flow_block_offload *offload)
 {
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 85fd5f4a1e0f..916ff32e53e7 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -212,6 +212,24 @@ struct flow_block_cb *flow_block_cb_lookup(struct net *net,
 }
 EXPORT_SYMBOL(flow_block_cb_lookup);
 
+void *flow_block_cb_priv(struct flow_block_cb *block_cb)
+{
+	return block_cb->cb_priv;
+}
+EXPORT_SYMBOL(flow_block_cb_priv);
+
+void flow_block_cb_incref(struct flow_block_cb *block_cb)
+{
+	block_cb->refcnt++;
+}
+EXPORT_SYMBOL(flow_block_cb_incref);
+
+unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb)
+{
+	return --block_cb->refcnt;
+}
+EXPORT_SYMBOL(flow_block_cb_decref);
+
 int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       struct list_head *driver_block_list,
 			       tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
-- 
2.11.0

