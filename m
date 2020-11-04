Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9955D2A65ED
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgKDOJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbgKDOJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:09:38 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F82EC061A4A;
        Wed,  4 Nov 2020 06:09:38 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id z24so16725650pgk.3;
        Wed, 04 Nov 2020 06:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XImW9tcA2E8T8s/M7K6i2CJBpkrNf1hayYcS5d4M3qk=;
        b=P+YRuYfGUaLwuvbY5fTK1UERFSAOh9XJV+WOwdi1s+/Wl7G/r/BS3FxGUriBWI0Xdi
         n2B5iwjgDbxj3USkEgbBLqTOSvoyadHFdMaq33FOEWLyt3cjjWjlk3o5ekUQfn+IyAwq
         Fd9Psyyzt/0D0kiMsKWQdbhOA7lzgegXFcHoDZlW5aik1rjkHoWNIcO+ges6VQZTO8s9
         plhXqngZdDroOSmbSEpb4g/f1lbdO0tBZ5eiW85b5gigNx9y4dJ/PNfMIi86xAhMSZvx
         lV6j5821St7C5xIrGhelGc39ewKXJB0qS96y9/P5C8ypfJ+sMN8YDSkX1jthEnpWfJ+A
         TeFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XImW9tcA2E8T8s/M7K6i2CJBpkrNf1hayYcS5d4M3qk=;
        b=TlOKFy6mrUJP875AYTPTDFTqTytB8tJ35lOyUKffG3QTcjQC54xg8zZZtafbw0s9zP
         hKB9fZOTTHl5QiCtb+yeWJBkFi4bwTZ7qoJ0R9iMaAFoTnUmKBj6w5ZQNQYlot0A9D+a
         SJco0fKqHO8wlPxLjEPjpvkaqy3cZuQRueNg61J+bVTyDZW5jL205ufM3txEVEf+HRIz
         15jJigOyxxoFBmffqWRax3UkoEg19bJtz1+j4O8Qa2Tu1d64FP5XVJ6zukqb+y9wPMwQ
         Nrp/PkM7zTEZuBY/9cG+N3927qnCFpfzEX7NgqefEFoWINhw2zTZVODUdbRJ3ukcTlTw
         FszQ==
X-Gm-Message-State: AOAM532flPy1zNp8ej7eFpBt4wr0CBMnGPNp4HcrrttPajuEZJnBAKl/
        V6n4TrWwot03GBwjfO4K6aaurJkLiH1ajx1LfKo=
X-Google-Smtp-Source: ABdhPJw9LtSqlcdh8eDV2aPds2ShVc6s7k+3fU01C3m4iK4eNuDHuWnz5uRVJhncj1xOtIxuGXuWpg==
X-Received: by 2002:a17:90a:7024:: with SMTP id f33mr4490145pjk.114.1604498977816;
        Wed, 04 Nov 2020 06:09:37 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q123sm2724818pfq.56.2020.11.04.06.09.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:09:37 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 1/6] i40e: introduce lazy Tx completions for AF_XDP zero-copy
Date:   Wed,  4 Nov 2020 15:08:57 +0100
Message-Id: <1604498942-24274-2-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Introduce lazy Tx completions when a queue is used for AF_XDP
zero-copy. In the current design, each time we get into the NAPI poll
loop we try to complete as many Tx packets as possible from the
NIC. This is performed by reading the head pointer register in the NIC
that tells us how many packets have been completed. Reading this
register is expensive as it is across PCIe, so let us try to limit the
number of times it is read by only completing Tx packets to user-space
when the number of available descriptors in the Tx HW ring is below
some threshold. This will decrease the number of reads issued to the
NIC and improves performance with 1.5% - 2% for the l2fwd xdpsock
microbenchmark.

The threshold is set to the minimum possible size that the HW ring can
have. This so that we do not run into a scenario where the threshold
is higher than the configured number of descriptors in the HW ring.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 6acede0..f8815b3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -9,6 +9,8 @@
 #include "i40e_txrx_common.h"
 #include "i40e_xsk.h"
 
+#define I40E_TX_COMPLETION_THRESHOLD I40E_MIN_NUM_DESCRIPTORS
+
 int i40e_alloc_rx_bi_zc(struct i40e_ring *rx_ring)
 {
 	unsigned long sz = sizeof(*rx_ring->rx_bi_zc) * rx_ring->count;
@@ -460,12 +462,15 @@ static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
  **/
 bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
 {
+	u32 i, completed_frames, xsk_frames = 0, head_idx;
 	struct xsk_buff_pool *bp = tx_ring->xsk_pool;
-	u32 i, completed_frames, xsk_frames = 0;
-	u32 head_idx = i40e_get_head(tx_ring);
 	struct i40e_tx_buffer *tx_bi;
 	unsigned int ntc;
 
+	if (I40E_DESC_UNUSED(tx_ring) >= I40E_TX_COMPLETION_THRESHOLD)
+		goto out_xmit;
+
+	head_idx = i40e_get_head(tx_ring);
 	if (head_idx < tx_ring->next_to_clean)
 		head_idx += tx_ring->count;
 	completed_frames = head_idx - tx_ring->next_to_clean;
-- 
2.7.4

