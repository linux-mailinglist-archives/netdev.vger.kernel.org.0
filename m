Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2EB7625B6
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391439AbfGHQGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:06:51 -0400
Received: from mail.us.es ([193.147.175.20]:53392 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391429AbfGHQGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 12:06:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C74BAB60DB
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 18:06:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AEA8F1153FA
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 18:06:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 59629117041; Mon,  8 Jul 2019 18:06:38 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9B72114D9A;
        Mon,  8 Jul 2019 18:06:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 18:06:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 93EE34265A2F;
        Mon,  8 Jul 2019 18:06:32 +0200 (CEST)
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
Subject: [PATCH net-next,v3 09/11] net: sched: remove tcf block API
Date:   Mon,  8 Jul 2019 18:06:11 +0200
Message-Id: <20190708160614.2226-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708160614.2226-1-pablo@netfilter.org>
References: <20190708160614.2226-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unused, now replaced by flow block API.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: remove tcf_block_cb_priv(), tcf_block_cb_lookup(), tcf_block_cb_incref()
    tcf_block_cb_decref() too.
    Formely known as "net: sched: remove tcf_block_cb_{register,unregister}()"

 include/net/pkt_cls.h | 69 ------------------------------------
 net/sched/cls_api.c   | 98 ---------------------------------------------------
 2 files changed, 167 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 9cf606b88526..17c388090c3c 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -66,22 +66,6 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 	return block->q;
 }
 
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb);
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident);
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb);
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb);
-struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
-					     tc_setup_cb_t *cb, void *cb_ident,
-					     void *cb_priv,
-					     struct netlink_ext_ack *extack);
-int tcf_block_cb_register(struct tcf_block *block,
-			  tc_setup_cb_t *cb, void *cb_ident,
-			  void *cb_priv, struct netlink_ext_ack *extack);
-void __tcf_block_cb_unregister(struct tcf_block *block,
-			       struct tcf_block_cb *block_cb);
-void tcf_block_cb_unregister(struct tcf_block *block,
-			     tc_setup_cb_t *cb, void *cb_ident);
 int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				tc_indr_block_bind_cb_t *cb, void *cb_ident);
 int tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
@@ -145,59 +129,6 @@ void tc_setup_cb_block_unregister(struct tcf_block *block, tc_setup_cb_t *cb,
 }
 
 static inline
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
-{
-	return NULL;
-}
-
-static inline
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident)
-{
-	return NULL;
-}
-
-static inline
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb)
-{
-}
-
-static inline
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
-{
-	return 0;
-}
-
-static inline
-struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
-					     tc_setup_cb_t *cb, void *cb_ident,
-					     void *cb_priv,
-					     struct netlink_ext_ack *extack)
-{
-	return NULL;
-}
-
-static inline
-int tcf_block_cb_register(struct tcf_block *block,
-			  tc_setup_cb_t *cb, void *cb_ident,
-			  void *cb_priv, struct netlink_ext_ack *extack)
-{
-	return 0;
-}
-
-static inline
-void __tcf_block_cb_unregister(struct tcf_block *block,
-			       struct tcf_block_cb *block_cb)
-{
-}
-
-static inline
-void tcf_block_cb_unregister(struct tcf_block *block,
-			     tc_setup_cb_t *cb, void *cb_ident)
-{
-}
-
-static inline
 int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				tc_indr_block_bind_cb_t *cb, void *cb_ident)
 {
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index cc87f6a2191f..ed568c534675 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1512,43 +1512,6 @@ void tcf_block_put(struct tcf_block *block)
 
 EXPORT_SYMBOL(tcf_block_put);
 
-struct tcf_block_cb {
-	struct list_head list;
-	tc_setup_cb_t *cb;
-	void *cb_ident;
-	void *cb_priv;
-	unsigned int refcnt;
-};
-
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
-{
-	return block_cb->cb_priv;
-}
-EXPORT_SYMBOL(tcf_block_cb_priv);
-
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident)
-{	struct tcf_block_cb *block_cb;
-
-	list_for_each_entry(block_cb, &block->cb_list, list)
-		if (block_cb->cb == cb && block_cb->cb_ident == cb_ident)
-			return block_cb;
-	return NULL;
-}
-EXPORT_SYMBOL(tcf_block_cb_lookup);
-
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb)
-{
-	block_cb->refcnt++;
-}
-EXPORT_SYMBOL(tcf_block_cb_incref);
-
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
-{
-	return --block_cb->refcnt;
-}
-EXPORT_SYMBOL(tcf_block_cb_decref);
-
 static int
 tcf_block_playback_offloads(struct tcf_block *block, tc_setup_cb_t *cb,
 			    void *cb_priv, bool add, bool offload_in_use,
@@ -1590,67 +1553,6 @@ tcf_block_playback_offloads(struct tcf_block *block, tc_setup_cb_t *cb,
 	return err;
 }
 
-struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
-					     tc_setup_cb_t *cb, void *cb_ident,
-					     void *cb_priv,
-					     struct netlink_ext_ack *extack)
-{
-	struct tcf_block_cb *block_cb;
-	int err;
-
-	/* Replay any already present rules */
-	err = tcf_block_playback_offloads(block, cb, cb_priv, true,
-					  tcf_block_offload_in_use(block),
-					  extack);
-	if (err)
-		return ERR_PTR(err);
-
-	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
-	if (!block_cb)
-		return ERR_PTR(-ENOMEM);
-	block_cb->cb = cb;
-	block_cb->cb_ident = cb_ident;
-	block_cb->cb_priv = cb_priv;
-	list_add(&block_cb->list, &block->cb_list);
-	return block_cb;
-}
-EXPORT_SYMBOL(__tcf_block_cb_register);
-
-int tcf_block_cb_register(struct tcf_block *block,
-			  tc_setup_cb_t *cb, void *cb_ident,
-			  void *cb_priv, struct netlink_ext_ack *extack)
-{
-	struct tcf_block_cb *block_cb;
-
-	block_cb = __tcf_block_cb_register(block, cb, cb_ident, cb_priv,
-					   extack);
-	return PTR_ERR_OR_ZERO(block_cb);
-}
-EXPORT_SYMBOL(tcf_block_cb_register);
-
-void __tcf_block_cb_unregister(struct tcf_block *block,
-			       struct tcf_block_cb *block_cb)
-{
-	tcf_block_playback_offloads(block, block_cb->cb, block_cb->cb_priv,
-				    false, tcf_block_offload_in_use(block),
-				    NULL);
-	list_del(&block_cb->list);
-	kfree(block_cb);
-}
-EXPORT_SYMBOL(__tcf_block_cb_unregister);
-
-void tcf_block_cb_unregister(struct tcf_block *block,
-			     tc_setup_cb_t *cb, void *cb_ident)
-{
-	struct tcf_block_cb *block_cb;
-
-	block_cb = tcf_block_cb_lookup(block, cb, cb_ident);
-	if (!block_cb)
-		return;
-	__tcf_block_cb_unregister(block, block_cb);
-}
-EXPORT_SYMBOL(tcf_block_cb_unregister);
-
 static int tcf_block_bind(struct tcf_block *block,
 			  struct flow_block_offload *bo)
 {
-- 
2.11.0

