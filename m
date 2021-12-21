Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627B347BA79
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 08:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhLUHKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 02:10:16 -0500
Received: from smtpbg126.qq.com ([106.55.201.22]:33305 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234654AbhLUHKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 02:10:16 -0500
X-QQ-mid: bizesmtp41t1640070578t2i5c3l1
Received: from localhost.localdomain (unknown [118.121.67.96])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 21 Dec 2021 15:09:36 +0800 (CST)
X-QQ-SSF: 01000000002000D0K000B00A0000000
X-QQ-FEAT: d3XYZ9avhmBkxdp3cJjJUkWcvy6tvwLLFwxsRA36TCJo7BtDaJdb2vDgvmmlm
        F1Sa/fCRJfaPV4sA9uo+N1en9xhnntL7uMXzYyII9LmkSSqtNt6zD6XUtJ5UGteWh6DUayZ
        Qnp+4HpaXGq1kMcK8hEFk9y5cUNNwl+lcDurj/NOAlbwuT1AMYoIljBglk1PzEkGWOn4gvQ
        N/DKttYpVrdD4aXPnnobAZYOflCQ/myaDLqmvQ5/m7wYe6w3T4neelF2oYTrLnUger6MuFD
        BtNpgHp4qPrrdSzfmNX1lyjgMAnzQ99X7WLMQsJUy8pOcjfY/AX413zwl7tsUft/598YdXM
        dTZvMYCSj7Rpv27SKOxOoXJ865lFek48+4gEMqF
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, kvalo@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] ath10k: replace strlcpy with strscpy
Date:   Tue, 21 Dec 2021 15:09:31 +0800
Message-Id: <20211221070931.725720-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The strlcpy should not be used because it doesn't limit the source
length. So that it will lead some potential bugs.

But the strscpy doesn't require reading memory from the src string
beyond the specified "count" bytes, and since the return value is
easier to error-check than strlcpy()'s. In addition, the implementation
is robust to the string changing out from underneath it, unlike the
current strlcpy() implementation.

Thus, replace strlcpy with strscpy.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/wireless/ath/ath10k/coredump.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index 55e7e11d06d9..fe6b6f97a916 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1522,7 +1522,7 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 	mutex_lock(&ar->dump_mutex);
 
 	dump_data = (struct ath10k_dump_file_data *)(buf);
-	strlcpy(dump_data->df_magic, "ATH10K-FW-DUMP",
+	strscpy(dump_data->df_magic, "ATH10K-FW-DUMP",
 		sizeof(dump_data->df_magic));
 	dump_data->len = cpu_to_le32(len);
 
@@ -1543,11 +1543,11 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 	dump_data->vht_cap_info = cpu_to_le32(ar->vht_cap_info);
 	dump_data->num_rf_chains = cpu_to_le32(ar->num_rf_chains);
 
-	strlcpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
+	strscpy(dump_data->fw_ver, ar->hw->wiphy->fw_version,
 		sizeof(dump_data->fw_ver));
 
 	dump_data->kernel_ver_code = 0;
-	strlcpy(dump_data->kernel_ver, init_utsname()->release,
+	strscpy(dump_data->kernel_ver, init_utsname()->release,
 		sizeof(dump_data->kernel_ver));
 
 	dump_data->tv_sec = cpu_to_le64(crash_data->timestamp.tv_sec);
-- 
2.34.1

