Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAB5320C96
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 19:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhBUS2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 13:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhBUS2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 13:28:40 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0789CC061786
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 10:27:59 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:2934:574d:d80c:39f5])
        by laurent.telenet-ops.be with bizsmtp
        id XuTw240073eQ4Ry01uTwbv; Sun, 21 Feb 2021 19:27:56 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lDtSV-000YhP-P7; Sun, 21 Feb 2021 19:27:55 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1lDtSV-008gzw-3G; Sun, 21 Feb 2021 19:27:55 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] ath11k: qmi: use %pad to format dma_addr_t
Date:   Sun, 21 Feb 2021 19:27:54 +0100
Message-Id: <20210221182754.2071863-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_ARCH_DMA_ADDR_T_64BIT=n:

    drivers/net/wireless/ath/ath11k/qmi.c: In function ‘ath11k_qmi_respond_fw_mem_request’:
    drivers/net/wireless/ath/ath11k/qmi.c:1690:8: warning: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 5 has type ‘dma_addr_t’ {aka ‘unsigned int’} [-Wformat=]
     1690 |        "qmi req mem_seg[%d] 0x%llx %u %u\n", i,
	  |        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     1691 |         ab->qmi.target_mem[i].paddr,
	  |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~
	  |                              |
	  |                              dma_addr_t {aka unsigned int}
    drivers/net/wireless/ath/ath11k/debug.h:64:30: note: in definition of macro ‘ath11k_dbg’
       64 |   __ath11k_dbg(ar, dbg_mask, fmt, ##__VA_ARGS__); \
	  |                              ^~~
    drivers/net/wireless/ath/ath11k/qmi.c:1690:34: note: format string is defined here
     1690 |        "qmi req mem_seg[%d] 0x%llx %u %u\n", i,
	  |                               ~~~^
	  |                                  |
	  |                                  long long unsigned int
	  |                               %x

Fixes: d5395a5486596308 ("ath11k: qmi: add debug message for allocated memory segment addresses and sizes")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 1aca841cd147cfee..7968fe4eda22a839 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1687,8 +1687,8 @@ static int ath11k_qmi_respond_fw_mem_request(struct ath11k_base *ab)
 			req->mem_seg[i].size = ab->qmi.target_mem[i].size;
 			req->mem_seg[i].type = ab->qmi.target_mem[i].type;
 			ath11k_dbg(ab, ATH11K_DBG_QMI,
-				   "qmi req mem_seg[%d] 0x%llx %u %u\n", i,
-				    ab->qmi.target_mem[i].paddr,
+				   "qmi req mem_seg[%d] %pad %u %u\n", i,
+				    &ab->qmi.target_mem[i].paddr,
 				    ab->qmi.target_mem[i].size,
 				    ab->qmi.target_mem[i].type);
 		}
-- 
2.25.1

