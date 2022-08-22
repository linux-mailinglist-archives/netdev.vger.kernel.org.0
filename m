Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B6359B8B9
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 07:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiHVF1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 01:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiHVF1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 01:27:01 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 21 Aug 2022 22:27:00 PDT
Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204F0255A8
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 22:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2338; q=dns/txt; s=iport;
  t=1661146019; x=1662355619;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1Rd0yPl23lrqxI7PakrPsr0Hb8oH+BQlMqi6raim+Os=;
  b=L9hK5gEUz7hBi2oHFv4pLD2LVkcgydU1IOVvCn98nk3l+2/TmImqurDm
   9WCCrGmOHiG1PeV2jNl3JjQRPwBCW1RY6a88fJmQFuSM9xhABHkrYb4CC
   3AqUFAxPoL/rgxXTeXb8H7OzobQrLCwhTMFw06z399Mkx02gibb9C/6TR
   g=;
X-IronPort-AV: E=Sophos;i="5.91,230,1647302400"; 
   d="scan'208";a="1062338766"
Received: from rcdn-core-1.cisco.com ([173.37.93.152])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 22 Aug 2022 05:25:56 +0000
Received: from cisco.com (savbu-usnic-a.cisco.com [10.193.184.48])
        by rcdn-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 27M5Puft021653;
        Mon, 22 Aug 2022 05:25:57 GMT
Received: by cisco.com (Postfix, from userid 508933)
        id 854A320F2003; Sun, 21 Aug 2022 22:25:56 -0700 (PDT)
From:   Hyong Youb Kim <hyonkim@cisco.com>
To:     saeedm@nvidia.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        aviadye@mellanox.com, steffen.klassert@secunet.com,
        Hyong Youb Kim <hyonkim@cisco.com>
Subject: [PATCH] net/mlx5e: Do not increment ESN when updating IPsec ESN state
Date:   Sun, 21 Aug 2022 22:25:51 -0700
Message-Id: <20220822052551.26903-1-hyonkim@cisco.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-SMTP-Client: 10.193.184.48, savbu-usnic-a.cisco.com
X-Outbound-Node: rcdn-core-1.cisco.com
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIMWL_WL_MED,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An offloaded SA stops receiving after about 2^32 + replay_window
packets. For example, when SA reaches <seq-hi 0x1, seq 0x2c>, all
subsequent packets get dropped with SA-icv-failure (integrity_failed).

To reproduce the bug:
- ConnectX-6 Dx with crypto enabled (FW 22.30.1004)
- ipsec.conf:
  nic-offload = yes
  replay-window = 32
  esn = yes
  salifetime=24h
- Run netperf for a long time to send more than 2^32 packets
  netperf -H <device-under-test> -t TCP_STREAM -l 20000

When 2^32 + replay_window packets are received, the replay window
moves from the 2nd half of subspace (overlap=1) to the 1st half
(overlap=0). The driver then updates the 'esn' value in NIC
(i.e. seq_hi) as follows.

 seq_hi = xfrm_replay_seqhi(seq_bottom)
 new esn in NIC = seq_hi + 1

The +1 increment is wrong, as seq_hi already contains the correct
seq_hi. For example, when seq_hi=1, the driver actually tells NIC to
use seq_hi=2 (esn). This incorrect esn value causes all subsequent
packets to fail integrity checks (SA-icv-failure). So, do not
increment.

Fixes: cb01008390bb ("net/mlx5: IPSec, Add support for ESN")
Signed-off-by: Hyong Youb Kim <hyonkim@cisco.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 2a8fd7020622..a715601865d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -101,7 +101,6 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct xfrm_replay_state_esn *replay_esn;
 	u32 seq_bottom = 0;
 	u8 overlap;
-	u32 *esn;
 
 	if (!(sa_entry->x->props.flags & XFRM_STATE_ESN)) {
 		sa_entry->esn_state.trigger = 0;
@@ -116,11 +115,9 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	sa_entry->esn_state.esn = xfrm_replay_seqhi(sa_entry->x,
 						    htonl(seq_bottom));
-	esn = &sa_entry->esn_state.esn;
 
 	sa_entry->esn_state.trigger = 1;
 	if (unlikely(overlap && seq_bottom < MLX5E_IPSEC_ESN_SCOPE_MID)) {
-		++(*esn);
 		sa_entry->esn_state.overlap = 0;
 		return true;
 	} else if (unlikely(!overlap &&
-- 
2.35.2

