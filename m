Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B3618EC33
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCVUkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:40:39 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39799 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgCVUkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 16:40:39 -0400
Received: by mail-pg1-f196.google.com with SMTP id b22so6070565pgb.6
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 13:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bZjbiiryPsuV5407y2y4uhlZU+VQ5S03KD4rXypyGHo=;
        b=M8zYhGfROvusxCsdULXOH/8t6ZHsueIOj0G/coE/Bn8i8MnE3jDCyOinwZac+CN5/S
         fcllK92fg/6dp2dLnh1ewnBVo+inltGWFsyIgLbyDpP4/SjP9xBSd+1B0rKhnNRVTudb
         Wz+T4+/qxG6SlsYnJu2nEXH3YX94kZ/d+hLDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bZjbiiryPsuV5407y2y4uhlZU+VQ5S03KD4rXypyGHo=;
        b=eV8m3tMkWr/PPZMNEmw5xAXhoyGQ0kgyJgV3vclg7Te4PUkX3yDw/lx+0jp1tHH8qj
         VEREiv9ErSyReab+EtS3w9w12+rPDtPs00pbVDIUrsJu+mI9LOJzqSYbLr0nbKEcxGb5
         RYsel0WvSt0FrY7eMTO9jZfyfRtaobe/azKStvarx8HOAGmtCRwkWs7Pqe84Qkfueuh+
         88PMjB6TDuoOD3yo44isdpjUK87IiSmij5QE1DAM6QJIk8zG2RG6IbJi9ZdrIxJA/yN4
         rreNX1l+9+OOSaMUayaxm2qWTZpsp75w/mJCucydEEynZMzg3udX57ofyUEMLHVvge+J
         xesg==
X-Gm-Message-State: ANhLgQ3nfJyiloEjOD2TdIglrrGTNWVZuYYlO+wii6JFL4xXxZsacwNF
        HPylS0SPM9VNWiTsU6t/9+uhHF34yjg=
X-Google-Smtp-Source: ADFU+vsM2sD7X6RejFG9/suEk54cCDYYChFwyhbyLo5rX6yDQhdfsz+c4hFTgW4o3xiILb4HgwZ21w==
X-Received: by 2002:a05:6a00:48:: with SMTP id i8mr21788676pfk.20.1584909637716;
        Sun, 22 Mar 2020 13:40:37 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y131sm11575843pfb.78.2020.03.22.13.40.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 13:40:37 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/5] bnxt_en: Fix Priority Bytes and Packets counters in ethtool -S.
Date:   Sun, 22 Mar 2020 16:40:01 -0400
Message-Id: <1584909605-19161-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
References: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an indexing bug in determining these ethtool priority
counters.  Instead of using the queue ID to index, we need to
normalize by modulo 10 to get the index.  This index is then used
to obtain the proper CoS queue counter.  Rename bp->pri2cos to
bp->pri2cos_idx to make this more clear.

Fixes: e37fed790335 ("bnxt_en: Add ethtool -S priority counters.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 10 +++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  8 ++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c5c8eff..b66ee1d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7406,14 +7406,22 @@ static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp)
 		pri2cos = &resp2->pri0_cos_queue_id;
 		for (i = 0; i < 8; i++) {
 			u8 queue_id = pri2cos[i];
+			u8 queue_idx;
 
+			/* Per port queue IDs start from 0, 10, 20, etc */
+			queue_idx = queue_id % 10;
+			if (queue_idx > BNXT_MAX_QUEUE) {
+				bp->pri2cos_valid = false;
+				goto qstats_done;
+			}
 			for (j = 0; j < bp->max_q; j++) {
 				if (bp->q_ids[j] == queue_id)
-					bp->pri2cos[i] = j;
+					bp->pri2cos_idx[i] = queue_idx;
 			}
 		}
 		bp->pri2cos_valid = 1;
 	}
+qstats_done:
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index cabef0b..63b1706 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1716,7 +1716,7 @@ struct bnxt {
 	u16			fw_rx_stats_ext_size;
 	u16			fw_tx_stats_ext_size;
 	u16			hw_ring_stats_size;
-	u8			pri2cos[8];
+	u8			pri2cos_idx[8];
 	u8			pri2cos_valid;
 
 	u16			hwrm_max_req_len;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 1f67e67..3f8a1de 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -589,25 +589,25 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 		if (bp->pri2cos_valid) {
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_rx_bytes_pri_arr[i].base_off +
-					 bp->pri2cos[i];
+					 bp->pri2cos_idx[i];
 
 				buf[j] = le64_to_cpu(*(rx_port_stats_ext + n));
 			}
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_rx_pkts_pri_arr[i].base_off +
-					 bp->pri2cos[i];
+					 bp->pri2cos_idx[i];
 
 				buf[j] = le64_to_cpu(*(rx_port_stats_ext + n));
 			}
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_tx_bytes_pri_arr[i].base_off +
-					 bp->pri2cos[i];
+					 bp->pri2cos_idx[i];
 
 				buf[j] = le64_to_cpu(*(tx_port_stats_ext + n));
 			}
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_tx_pkts_pri_arr[i].base_off +
-					 bp->pri2cos[i];
+					 bp->pri2cos_idx[i];
 
 				buf[j] = le64_to_cpu(*(tx_port_stats_ext + n));
 			}
-- 
2.5.1

