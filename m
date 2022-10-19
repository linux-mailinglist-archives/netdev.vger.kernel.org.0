Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F406039D9
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiJSGil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJSGij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:38:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EC26D85F
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3953EB82239
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4276C433C1;
        Wed, 19 Oct 2022 06:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666161514;
        bh=7HQ1deySWXZEEYDhV7KbOqdQs9aT16o8QBa/BV1ulZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DE/cxo9n3JETIHhz8RuKJpn0srxJWx0KzUsbh3udLNAe+waGN96XeOyy/AQxpedk8
         zrfDWER7Vlb8FR0hPAg7pTcjFw1B1EuIc58D+HSWBOHDAl4IVQuMlTBf7cqFJZ3/8e
         2hTzBWlyKwsXBS4WsmI9WM2yhdvU0+b92458e+13NtlwWxsOUZB1oUjsodRZvoh32O
         TeNbBqrwau2Qo6T5ZUN0J8Di5TJzowgypTCXUqphLDWpcOcWOdBd16oseTqdSAW9jl
         scq2DxK5h344CapYbmw/WHuiWcfaMYTep2s2ahlIsZ1R4Y4q/jQK8NZTJH40biPk/a
         aT5SWANQtg+Ig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Hyong Youb Kim <hyonkim@cisco.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net 01/16] net/mlx5e: Do not increment ESN when updating IPsec ESN state
Date:   Tue, 18 Oct 2022 23:37:58 -0700
Message-Id: <20221019063813.802772-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221019063813.802772-1-saeed@kernel.org>
References: <20221019063813.802772-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hyong Youb Kim <hyonkim@cisco.com>

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
Acked-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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
2.37.3

