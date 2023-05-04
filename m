Return-Path: <netdev+bounces-342-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99FF96F734E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:42:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6C4A1C21276
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC02F4E6;
	Thu,  4 May 2023 19:41:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB48EEDC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D9DC433A0;
	Thu,  4 May 2023 19:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229307;
	bh=tU2yWWf+fXit+lYbclQs/l+cPlES+3C5m/4vEUaCOCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGiVNk1bfUql4Gh/MeNhT1gOkc/p7Q2ReQFN+ZE9ibzLFSqQzZXKEN3K8jcJ1mj07
	 71GN/KnH2fp1+eGvOxdAG3sNmoMERTvqUxb9FwQL6JV6bH7qcNAdwtlsRT/Fo0OXUx
	 dIAZV2WPCk29YkwvxRULUz3ScHj6lwjKoL6GPVVHLlrAnnHceDGB1MlmsF+DQgma6z
	 W+ddnA8qWj4TuXP1Hm4KDhtNEQ5g/I0Om/OxYNWzKDVC017LwL/wYFeiGH1wmbUrFl
	 mUZFP9vvaF4CZ9ga1nF9noRM+DY4ee9UqXjEHDSmWQ7LxhWmW+UDM6zfKVpR6MnkOS
	 XjcC/pm6yMOsg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	kvalo@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 02/59] wifi: ath12k: Handle lock during peer_id find
Date: Thu,  4 May 2023 15:40:45 -0400
Message-Id: <20230504194142.3805425-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194142.3805425-1-sashal@kernel.org>
References: <20230504194142.3805425-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ramya Gnanasekar <quic_rgnanase@quicinc.com>

[ Upstream commit 95a389e2ff3212d866cc51c77d682d2934074eb8 ]

ath12k_peer_find_by_id() requires that the caller hold the
ab->base_lock. Currently the WBM error path does not hold
the lock and calling that function, leads to the
following lockdep_assert()in QCN9274:

[105162.160893] ------------[ cut here ]------------
[105162.160916] WARNING: CPU: 3 PID: 0 at drivers/net/wireless/ath/ath12k/peer.c:71 ath12k_peer_find_by_id+0x52/0x60 [ath12k]
[105162.160933] Modules linked in: ath12k(O) qrtr_mhi qrtr mac80211 cfg80211 mhi qmi_helpers libarc4 nvme nvme_core [last unloaded: ath12k(O)]
[105162.160967] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W  O       6.1.0-rc2+ #3
[105162.160972] Hardware name: Intel(R) Client Systems NUC8i7HVK/NUC8i7HVB, BIOS HNKBLi70.86A.0056.2019.0506.1527 05/06/2019
[105162.160977] RIP: 0010:ath12k_peer_find_by_id+0x52/0x60 [ath12k]
[105162.160990] Code: 07 eb 0f 39 68 24 74 0a 48 8b 00 48 39 f8 75 f3 31 c0 5b 5d c3 48 8d bf b0 f2 00 00 be ff ff ff ff e8 22 20 c4 e2 85 c0 75 bf <0f> 0b eb bb 66 2e 0f 1f 84 00 00 00 00 00 41 54 4c 8d a7 98 f2 00
[105162.160996] RSP: 0018:ffffa223001acc60 EFLAGS: 00010246
[105162.161003] RAX: 0000000000000000 RBX: ffff9f0573940000 RCX: 0000000000000000
[105162.161008] RDX: 0000000000000001 RSI: ffffffffa3951c8e RDI: ffffffffa39a96d7
[105162.161013] RBP: 000000000000000a R08: 0000000000000000 R09: 0000000000000000
[105162.161017] R10: ffffa223001acb40 R11: ffffffffa3d57c60 R12: ffff9f057394f2e0
[105162.161022] R13: ffff9f0573940000 R14: ffff9f04ecd659c0 R15: ffff9f04d5a9b040
[105162.161026] FS:  0000000000000000(0000) GS:ffff9f0575600000(0000) knlGS:0000000000000000
[105162.161031] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[105162.161036] CR2: 00001d5c8277a008 CR3: 00000001e6224006 CR4: 00000000003706e0
[105162.161041] Call Trace:
[105162.161046]  <IRQ>
[105162.161051]  ath12k_dp_rx_process_wbm_err+0x6da/0xaf0 [ath12k]
[105162.161072]  ? ath12k_dp_rx_process_err+0x80e/0x15a0 [ath12k]
[105162.161084]  ? __lock_acquire+0x4ca/0x1a60
[105162.161104]  ath12k_dp_service_srng+0x263/0x310 [ath12k]
[105162.161120]  ath12k_pci_ext_grp_napi_poll+0x1c/0x70 [ath12k]
[105162.161133]  __napi_poll+0x22/0x260
[105162.161141]  net_rx_action+0x2f8/0x380
[105162.161153]  __do_softirq+0xd0/0x4c9
[105162.161162]  irq_exit_rcu+0x88/0xe0
[105162.161169]  common_interrupt+0xa5/0xc0
[105162.161174]  </IRQ>
[105162.161179]  <TASK>
[105162.161184]  asm_common_interrupt+0x22/0x40

Handle spin lock/unlock in WBM error path to hold the necessary lock
expected by ath12k_peer_find_by_id().

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0-03171-QCAHKSWPL_SILICONZ-1

Signed-off-by: Ramya Gnanasekar <quic_rgnanase@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230122014936.3594-1-quic_rgnanase@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 83a43ad48c512..de9a4ca66c664 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -3494,11 +3494,14 @@ static int ath12k_dp_rx_h_null_q_desc(struct ath12k *ar, struct sk_buff *msdu,
 	msdu_len = ath12k_dp_rx_h_msdu_len(ab, desc);
 	peer_id = ath12k_dp_rx_h_peer_id(ab, desc);
 
+	spin_lock(&ab->base_lock);
 	if (!ath12k_peer_find_by_id(ab, peer_id)) {
+		spin_unlock(&ab->base_lock);
 		ath12k_dbg(ab, ATH12K_DBG_DATA, "invalid peer id received in wbm err pkt%d\n",
 			   peer_id);
 		return -EINVAL;
 	}
+	spin_unlock(&ab->base_lock);
 
 	if (!rxcb->is_frag && ((msdu_len + hal_rx_desc_sz) > DP_RX_BUFFER_SIZE)) {
 		/* First buffer will be freed by the caller, so deduct it's length */
-- 
2.39.2


