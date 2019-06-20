Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8084DA98
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfFTTtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:49:43 -0400
Received: from mail.us.es ([193.147.175.20]:54028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfFTTtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:49:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 134A8B60E7
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D81BADA705
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A3E23DA702; Thu, 20 Jun 2019 21:49:38 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D049FDA705;
        Thu, 20 Jun 2019 21:49:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 21:49:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9215A4265A2F;
        Thu, 20 Jun 2019 21:49:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: [PATCH net-next 05/12] net: sched: add release callback to struct tcf_block_cb
Date:   Thu, 20 Jun 2019 21:49:10 +0200
Message-Id: <20190620194917.2298-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190620194917.2298-1-pablo@netfilter.org>
References: <20190620194917.2298-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call it on tcf_block_cb object to release the driver private block area.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/pkt_cls.h |  6 ++++--
 net/sched/cls_api.c   | 10 ++++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 4fbed2ccfa6b..db4d32266a03 100644
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
 	return NULL;
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 78050d16ff74..707c2ae0a15f 100644
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
 	if (!block_cb)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.11.0

