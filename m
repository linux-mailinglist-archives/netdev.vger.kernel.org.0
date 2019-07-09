Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED9E63CFC
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfGIU4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:56:32 -0400
Received: from mail.us.es ([193.147.175.20]:37302 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729869AbfGIU4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 16:56:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B40A928804AF
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9080211510C
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 68B1B115103; Tue,  9 Jul 2019 22:56:28 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1ECFEFB37C;
        Tue,  9 Jul 2019 22:56:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Jul 2019 22:56:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.194.134])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 19FAA4265A32;
        Tue,  9 Jul 2019 22:56:23 +0200 (CEST)
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
Subject: [PATCH net-next,v4 10/12] net: flow_offload: add flow_block_cb_is_busy() and use it
Date:   Tue,  9 Jul 2019 22:55:48 +0200
Message-Id: <20190709205550.3160-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190709205550.3160-1-pablo@netfilter.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a function to check if flow block callback is already in
use.  Call this new function from flow_block_cb_setup_simple() and from
drivers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: no changes.

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    |  4 ++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c      |  4 ++++
 drivers/net/ethernet/mscc/ocelot_tc.c               |  3 +++
 drivers/net/ethernet/netronome/nfp/flower/offload.c |  4 ++++
 include/net/flow_offload.h                          |  3 +++
 net/core/flow_offload.c                             | 18 ++++++++++++++++++
 net/dsa/slave.c                                     |  3 +++
 7 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 897a9511227c..b976f16e828c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -721,6 +721,10 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		if (indr_priv)
 			return -EEXIST;
 
+		if (flow_block_cb_is_busy(mlx5e_rep_indr_setup_block_cb,
+					  indr_priv, &mlx5e_block_cb_list))
+			return -EBUSY;
+
 		indr_priv = kmalloc(sizeof(*indr_priv), GFP_KERNEL);
 		if (!indr_priv)
 			return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 65bea6be84d6..35adc174f277 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1698,6 +1698,10 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
+		if (flow_block_cb_is_busy(cb, mlxsw_sp_port,
+					  &mlxsw_sp_block_cb_list))
+			return -EBUSY;
+
 		block_cb = flow_block_cb_alloc(f->net, cb, mlxsw_sp_port,
 					       mlxsw_sp_port, NULL);
 		if (IS_ERR(block_cb))
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 935a774cb291..9e6464ffae5d 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -153,6 +153,9 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
+		if (flow_block_cb_is_busy(cb, port, &ocelot_block_cb_list))
+			return -EBUSY;
+
 		block_cb = flow_block_cb_alloc(f->net, cb, port, port, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index ddd6b509f27e..1b38cfeb646c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1320,6 +1320,10 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
+		if (flow_block_cb_is_busy(nfp_flower_setup_tc_block_cb, repr,
+					  &nfp_block_cb_list))
+			return -EBUSY;
+
 		block_cb = flow_block_cb_alloc(f->net,
 					       nfp_flower_setup_tc_block_cb,
 					       repr, repr, NULL);
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index e8ff62ba1d8f..2e780dbee168 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -291,6 +291,9 @@ static inline void flow_block_cb_remove(struct flow_block_cb *block_cb,
 	list_move(&block_cb->list, &offload->cb_list);
 }
 
+bool flow_block_cb_is_busy(tc_setup_cb_t *cb, void *cb_ident,
+			   struct list_head *driver_block_list);
+
 int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       struct list_head *driver_list, tc_setup_cb_t *cb,
 			       void *cb_ident, void *cb_priv, bool ingress_only);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index a1b36b47dd89..76f8db3841d7 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -228,6 +228,21 @@ unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb)
 }
 EXPORT_SYMBOL(flow_block_cb_decref);
 
+bool flow_block_cb_is_busy(tc_setup_cb_t *cb, void *cb_ident,
+			   struct list_head *driver_block_list)
+{
+	struct flow_block_cb *block_cb;
+
+	list_for_each_entry(block_cb, driver_block_list, driver_list) {
+		if (block_cb->cb == cb &&
+		    block_cb->cb_ident == cb_ident)
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(flow_block_cb_is_busy);
+
 int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       struct list_head *driver_block_list,
 			       tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
@@ -243,6 +258,9 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
+		if (flow_block_cb_is_busy(cb, cb_ident, driver_block_list))
+			return -EBUSY;
+
 		block_cb = flow_block_cb_alloc(f->net, cb, cb_ident,
 					       cb_priv, NULL);
 		if (IS_ERR(block_cb))
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 90c32fd680db..9bcb598fc840 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -961,6 +961,9 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
+		if (flow_block_cb_is_busy(cb, dev, &dsa_slave_block_cb_list))
+			return -EBUSY;
+
 		block_cb = flow_block_cb_alloc(f->net, cb, dev, dev, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
-- 
2.11.0


