Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCC991DE2
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 09:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfHSHdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 03:33:33 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56795 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725790AbfHSHdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 03:33:33 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 19 Aug 2019 10:33:26 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7J7XQL0025330;
        Mon, 19 Aug 2019 10:33:26 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net] nfp: flower: verify that block cb is not busy before binding
Date:   Mon, 19 Aug 2019 10:33:04 +0300
Message-Id: <20190819073304.9419-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When processing FLOW_BLOCK_BIND command on indirect block, check that flow
block cb is not busy.

Fixes: 0d4fd02e7199 ("net: flow_offload: add flow_block_cb_is_busy() and use it")
Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index e209f150c5f2..9917d64694c6 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1416,6 +1416,13 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
+		cb_priv = nfp_flower_indr_block_cb_priv_lookup(app, netdev);
+		if (cb_priv &&
+		    flow_block_cb_is_busy(nfp_flower_setup_indr_block_cb,
+					  cb_priv,
+					  &nfp_block_cb_list))
+			return -EBUSY;
+
 		cb_priv = kmalloc(sizeof(*cb_priv), GFP_KERNEL);
 		if (!cb_priv)
 			return -ENOMEM;
-- 
2.21.0

