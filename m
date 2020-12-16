Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FF52DC290
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 15:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgLPO5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 09:57:51 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:41640 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLPO5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 09:57:51 -0500
Received: from madeliefje.horms.nl (tulip.horms.nl [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 8710C25B750;
        Thu, 17 Dec 2020 01:57:09 +1100 (AEDT)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id EAFA774A6; Wed, 16 Dec 2020 15:57:06 +0100 (CET)
From:   Simon Horman <simon.horman@netronome.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: [PATCH net] nfp: move indirect block cleanup to flower app stop callback
Date:   Wed, 16 Dec 2020 15:57:01 +0100
Message-Id: <20201216145701.30005-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The indirect block cleanup may cause control messages to be sent
if offloaded flows are present. However, by the time the flower app
cleanup callback is called txbufs are no longer available and attempts
to send control messages result in a NULL-pointer dereference in
nfp_ctrl_tx_one().

This problem may be resolved by moving the indirect block cleanup
to the stop callback, where txbufs are still available.

As suggested by Jakub Kicinski and Louis Peens.

Fixes: a1db217861f3 ("net: flow_offload: fix flow_indr_dev_unregister path")
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index bb448c82cdc2..c029950a81e2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -860,9 +860,6 @@ static void nfp_flower_clean(struct nfp_app *app)
 	skb_queue_purge(&app_priv->cmsg_skbs_low);
 	flush_work(&app_priv->cmsg_work);
 
-	flow_indr_dev_unregister(nfp_flower_indr_setup_tc_cb, app,
-				 nfp_flower_setup_indr_tc_release);
-
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
 		nfp_flower_qos_cleanup(app);
 
@@ -951,6 +948,9 @@ static int nfp_flower_start(struct nfp_app *app)
 static void nfp_flower_stop(struct nfp_app *app)
 {
 	nfp_tunnel_config_stop(app);
+
+	flow_indr_dev_unregister(nfp_flower_indr_setup_tc_cb, app,
+				 nfp_flower_setup_indr_tc_release);
 }
 
 static int
-- 
2.20.1

