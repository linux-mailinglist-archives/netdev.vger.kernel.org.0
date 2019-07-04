Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437F25FEBA
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfGDXtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:49:21 -0400
Received: from mail.us.es ([193.147.175.20]:33078 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727654AbfGDXtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 19:49:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 875A981691
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62D24114D8C
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 459A11021B2; Fri,  5 Jul 2019 01:49:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDC2ADA704;
        Fri,  5 Jul 2019 01:49:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 01:49:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C1F6B4265A31;
        Fri,  5 Jul 2019 01:49:14 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
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
        cphealy@gmail.com
Subject: [PATCH 05/15 net-next,v2] net: sched: add release callback to struct tcf_block_cb
Date:   Fri,  5 Jul 2019 01:48:33 +0200
Message-Id: <20190704234843.6601-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190704234843.6601-1-pablo@netfilter.org>
References: <20190704234843.6601-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call it on tcf_block_cb object to release the driver private block area.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/net/pkt_cls.h |  6 ++++--
 net/sched/cls_api.c   | 10 ++++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index d660cb4fad75..fd0bfb63ab70 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -73,7 +73,8 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 }
 
 struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
-					void *cb_ident, void *cb_priv);
+					void *cb_ident, void *cb_priv,
+					void (*release)(void *cb_priv));
 void tcf_block_cb_free(struct tcf_block_cb *block_cb);
 
 struct tc_block_offload;
@@ -161,7 +162,8 @@ void tc_setup_cb_block_unregister(struct tcf_block *block, tc_setup_cb_t *cb,
 }
 
 static inline struct tcf_block_cb *
-tcf_block_cb_alloc(tc_setup_cb_t *cb, void *cb_ident, void *cb_priv)
+tcf_block_cb_alloc(tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
+		   void (*release)(void *cb_priv))
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a2c1258cc8dc..534a545ea51e 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -713,6 +713,7 @@ struct tcf_block_cb {
 	struct list_head global_list;
 	struct list_head list;
 	tc_setup_cb_t *cb;
+	void (*release)(void *cb_priv);
 	void *cb_ident;
 	void *cb_priv;
 	unsigned int refcnt;
@@ -750,7 +751,8 @@ unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
 EXPORT_SYMBOL(tcf_block_cb_decref);
 
 struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
-					void *cb_ident, void *cb_priv)
+					void *cb_ident, void *cb_priv,
+					void (*release)(void *cb_priv))
 {
 	struct tcf_block_cb *block_cb;
 
@@ -760,6 +762,7 @@ struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
 
 	block_cb->cb = cb;
 	block_cb->cb_ident = cb_ident;
+	block_cb->release = release;
 	block_cb->cb_priv = cb_priv;
 
 	return block_cb;
@@ -768,6 +771,9 @@ EXPORT_SYMBOL(tcf_block_cb_alloc);
 
 void tcf_block_cb_free(struct tcf_block_cb *block_cb)
 {
+	if (block_cb->release)
+		block_cb->release(block_cb->cb_priv);
+
 	kfree(block_cb);
 }
 EXPORT_SYMBOL(tcf_block_cb_free);
@@ -801,7 +807,7 @@ struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
 	if (err)
 		return ERR_PTR(err);
 
-	block_cb = tcf_block_cb_alloc(cb, cb_ident, cb_priv);
+	block_cb = tcf_block_cb_alloc(cb, cb_ident, cb_priv, NULL);
 	if (IS_ERR(block_cb))
 		return block_cb;
 
-- 
2.11.0

