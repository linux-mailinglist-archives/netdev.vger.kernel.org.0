Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD996911D
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391329AbfGOO0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391301AbfGOO0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:26:40 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A9F0206B8;
        Mon, 15 Jul 2019 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200799;
        bh=DZ7BiE3VghbRO+3KluHtvVWdyC9txZKmk4GLMbplidA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ai00eFYrV5t4XdE4JKR5XWMX6mye42Jid2Lb7C4bYl5Lr50CzzZl1Oy3I0hFwkDk6
         rP6R/FJynwW0rZu3u8VKX7Gz+mZ3nAiZ40oDrWTqgdv7hz2PtZ2NLdkfF0O+KyN8iU
         jnl8SgZE8hj9706RQzAtLTYAdOFs3HaoNKelBiTM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vedang Patel <vedang.patel@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 133/158] igb: clear out skb->tstamp after reading the txtime
Date:   Mon, 15 Jul 2019 10:17:44 -0400
Message-Id: <20190715141809.8445-133-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vedang Patel <vedang.patel@intel.com>

[ Upstream commit 1e08511d5d01884a3c9070afd52a47799312074a ]

If a packet which is utilizing the launchtime feature (via SO_TXTIME socket
option) also requests the hardware transmit timestamp, the hardware
timestamp is not delivered to the userspace. This is because the value in
skb->tstamp is mistaken as the software timestamp.

Applications, like ptp4l, request a hardware timestamp by setting the
SOF_TIMESTAMPING_TX_HARDWARE socket option. Whenever a new timestamp is
detected by the driver (this work is done in igb_ptp_tx_work() which calls
igb_ptp_tx_hwtstamps() in igb_ptp.c[1]), it will queue the timestamp in the
ERR_QUEUE for the userspace to read. When the userspace is ready, it will
issue a recvmsg() call to collect this timestamp.  The problem is in this
recvmsg() call. If the skb->tstamp is not cleared out, it will be
interpreted as a software timestamp and the hardware tx timestamp will not
be successfully sent to the userspace. Look at skb_is_swtx_tstamp() and the
callee function __sock_recv_timestamp() in net/socket.c for more details.

Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 5aa083d9a6c9..ab76a5f77cd0 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5703,6 +5703,7 @@ static void igb_tx_ctxtdesc(struct igb_ring *tx_ring,
 	 */
 	if (tx_ring->launchtime_enable) {
 		ts = ns_to_timespec64(first->skb->tstamp);
+		first->skb->tstamp = 0;
 		context_desc->seqnum_seed = cpu_to_le32(ts.tv_nsec / 32);
 	} else {
 		context_desc->seqnum_seed = 0;
-- 
2.20.1

