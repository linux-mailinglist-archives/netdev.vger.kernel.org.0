Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4104DA94
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfFTTti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:49:38 -0400
Received: from mail.us.es ([193.147.175.20]:54028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726699AbfFTTth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:49:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 462EDB6355
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 189DDDA70C
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0C578DA704; Thu, 20 Jun 2019 21:49:35 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B11EDA703;
        Thu, 20 Jun 2019 21:49:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 21:49:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3B9FC4265A2F;
        Thu, 20 Jun 2019 21:49:31 +0200 (CEST)
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
Subject: [PATCH net-next 03/12] net: sched: add tcf_block_cb_free()
Date:   Thu, 20 Jun 2019 21:49:08 +0200
Message-Id: <20190620194917.2298-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190620194917.2298-1-pablo@netfilter.org>
References: <20190620194917.2298-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just a stub to release tcf_block_cb objects, follow up patch extends it
to have a release callback in it for the private data.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/pkt_cls.h | 5 +++++
 net/sched/cls_api.c   | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 276a17a3547b..2816297449ee 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -74,6 +74,7 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 
 struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
 					void *cb_ident, void *cb_priv);
+void tcf_block_cb_free(struct tcf_block_cb *block_cb);
 void *tcf_block_cb_priv(struct tcf_block_cb *block_cb);
 struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
 					 tc_setup_cb_t *cb, void *cb_ident);
@@ -158,6 +159,10 @@ tcf_block_cb_alloc(tc_setup_cb_t *cb, void *cb_ident, void *cb_priv)
 	return NULL;
 }
 
+static inline void tcf_block_cb_free(struct tcf_block_cb *block_cb)
+{
+}
+
 static inline
 void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
 {
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c01d825edab5..b86475ab8f63 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -763,6 +763,12 @@ struct tcf_block_cb *tcf_block_cb_alloc(tc_setup_cb_t *cb,
 }
 EXPORT_SYMBOL(tcf_block_cb_alloc);
 
+void tcf_block_cb_free(struct tcf_block_cb *block_cb)
+{
+	kfree(block_cb);
+}
+EXPORT_SYMBOL(tcf_block_cb_free);
+
 struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
 					     tc_setup_cb_t *cb, void *cb_ident,
 					     void *cb_priv,
-- 
2.11.0

