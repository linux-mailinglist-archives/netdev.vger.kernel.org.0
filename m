Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4890111975F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbfLJVcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:32:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729103AbfLJVci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:32:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFE1B214AF;
        Tue, 10 Dec 2019 21:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013557;
        bh=IcOno1mqnFSoa4NxvV+ES7nTKiGmjKuk/TyPFW6PQyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTEqePgAuF8YrUhvv7877BOqocP7sXnBEBCukKboLcvhoVbEkWfw9WZP1wooLCuV0
         Z5296jc7ydHiWQbEkmjBCC8faM7khlQqOAhAAi/UvOoVUaWjUn2DIrALif28mBIrsz
         ZzgOoVgn435crdsGvvDn3Vo9QTg4P5eCu5yoPkoU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anilkumar Kolli <akolli@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 013/177] ath10k: fix backtrace on coredump
Date:   Tue, 10 Dec 2019 16:29:37 -0500
Message-Id: <20191210213221.11921-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anilkumar Kolli <akolli@codeaurora.org>

[ Upstream commit d98ddae85a4a57124f87960047b1b6419312147f ]

In a multiradio board with one QCA9984 and one AR9987
after enabling the crashdump with module parameter
coredump_mask=7, below backtrace is seen.

vmalloc: allocation failure: 0 bytes
 kworker/u4:0: page allocation failure: order:0, mode:0x80d2
 CPU: 0 PID: 6 Comm: kworker/u4:0 Not tainted 3.14.77 #130
 Workqueue: ath10k_wq ath10k_core_register_work [ath10k_core]
 (unwind_backtrace) from [<c021abf8>] (show_stack+0x10/0x14)
 (dump_stack+0x80/0xa0)
 (warn_alloc_failed+0xd0/0xfc)
 (__vmalloc_node_range+0x1b4/0x1d8)
 (__vmalloc_node+0x34/0x40)
 (vzalloc+0x24/0x30)
 (ath10k_coredump_register+0x6c/0x88 [ath10k_core])
 (ath10k_core_register_work+0x350/0xb34 [ath10k_core])
 (process_one_work+0x20c/0x32c)
 (worker_thread+0x228/0x360)

This is due to ath10k_hw_mem_layout is not defined for AR9987.
For coredump undefined hw ramdump_size is 0.
Check for the ramdump_size before allocation memory.

Tested on: AR9987, QCA9984
FW version: 10.4-3.9.0.2-00044

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/coredump.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index 4d28063052fec..385b84f24322d 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1105,9 +1105,11 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
 		dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_RAM_DATA);
 		dump_tlv->tlv_len = cpu_to_le32(crash_data->ramdump_buf_len);
-		memcpy(dump_tlv->tlv_data, crash_data->ramdump_buf,
-		       crash_data->ramdump_buf_len);
-		sofar += sizeof(*dump_tlv) + crash_data->ramdump_buf_len;
+		if (crash_data->ramdump_buf_len) {
+			memcpy(dump_tlv->tlv_data, crash_data->ramdump_buf,
+			       crash_data->ramdump_buf_len);
+			sofar += sizeof(*dump_tlv) + crash_data->ramdump_buf_len;
+		}
 	}
 
 	spin_unlock_bh(&ar->data_lock);
@@ -1154,6 +1156,9 @@ int ath10k_coredump_register(struct ath10k *ar)
 	if (test_bit(ATH10K_FW_CRASH_DUMP_RAM_DATA, &ath10k_coredump_mask)) {
 		crash_data->ramdump_buf_len = ath10k_coredump_get_ramdump_size(ar);
 
+		if (!crash_data->ramdump_buf_len)
+			return 0;
+
 		crash_data->ramdump_buf = vzalloc(crash_data->ramdump_buf_len);
 		if (!crash_data->ramdump_buf)
 			return -ENOMEM;
-- 
2.20.1

