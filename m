Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2EC26DECA3
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 09:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjDLHhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 03:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDLHhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 03:37:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA94E19AB
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 00:37:10 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1681285027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RQkxQvPTvjTB5S3EwtvOfTBwQl24EI140WoGiNkBG+s=;
        b=MW09NHjE0b5w53V52ZrAJ5VkN49spPATMCnsc9qgjoW4EDKZV805iagnvPySEwT1zsCx9l
        NTIAZ5xeuhBOe/RU+HaBHfVgsouZkF+DG1tZUBFswIusbtpFqaPFe+SIeJeSQA1X/pp0fP
        yEBhn2xL8UqzJkcc+hyqx6P1sdFiSgx/O+XzgbjCMSFG3CjNG6eNP96r7l5Q2aKtRdZ/rt
        hjUHgIO+aejtST9qclya1ArAvq3CAkk8t8zQ6uw/e3WTaWAg97/Aopzb5x5SJyatHqi6XA
        buWas5/KGc7KBbuP2QfvFnMOBO45DdPPPYK5MKZ25M9HXtGPBD3UKuSY3og/lA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1681285027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RQkxQvPTvjTB5S3EwtvOfTBwQl24EI140WoGiNkBG+s=;
        b=mFYbNfdzkk6Rb44H39Ue7RlLrMKpMhP3u3YBPCpGTpb6t7kJ7yKFaaL/GavogRvXU+DL/F
        T62zChYo5S4uKADQ==
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next] igc: Avoid transmit queue timeout for XDP
Date:   Wed, 12 Apr 2023 09:36:11 +0200
Message-Id: <20230412073611.62942-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

High XDP load triggers the netdev watchdog:

|NETDEV WATCHDOG: enp3s0 (igc): transmit queue 2 timed out

The reason is the Tx queue transmission start (txq->trans_start) is not updated
in XDP code path. Therefore, add it for all XDP transmission functions.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ba49728be919..e71e85e3bcc2 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2384,6 +2384,8 @@ static int igc_xdp_xmit_back(struct igc_adapter *adapter, struct xdp_buff *xdp)
 	nq = txring_txq(ring);
 
 	__netif_tx_lock(nq, cpu);
+	/* Avoid transmit queue timeout since we share it with the slow path */
+	txq_trans_cond_update(nq);
 	res = igc_xdp_init_tx_descriptor(ring, xdpf);
 	__netif_tx_unlock(nq);
 	return res;
@@ -2786,6 +2788,9 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 
 	__netif_tx_lock(nq, cpu);
 
+	/* Avoid transmit queue timeout since we share it with the slow path */
+	txq_trans_cond_update(nq);
+
 	budget = igc_desc_unused(ring);
 
 	while (xsk_tx_peek_desc(pool, &xdp_desc) && budget--) {
@@ -6311,6 +6316,9 @@ static int igc_xdp_xmit(struct net_device *dev, int num_frames,
 
 	__netif_tx_lock(nq, cpu);
 
+	/* Avoid transmit queue timeout since we share it with the slow path */
+	txq_trans_cond_update(nq);
+
 	drops = 0;
 	for (i = 0; i < num_frames; i++) {
 		int err;
-- 
2.30.2

