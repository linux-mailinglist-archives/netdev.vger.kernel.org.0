Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F24118182
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfLJHtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:49:33 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36608 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbfLJHtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 02:49:32 -0500
Received: by mail-pg1-f195.google.com with SMTP id k3so7835035pgc.3
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 23:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DhuZQwbxG4wIloH0YCU6dvkem4ED2A4/NTGL2KhQZkc=;
        b=HwDbgjwM9Ukws0ifn1sA/QrH3VAgC7+q1+UM1v2FNU2iMpjrlvb5/pOoJnvOjNdQpT
         dA6uDycxPOgeDxD1hOc7z+ahOpKnjknLaWYQ9OKJeU/rrk/GzGMyCHUf6ZaIv8++qiEU
         52jBRbwrb3HfRZKjz3rRvjxfFLVUkx4AizcuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DhuZQwbxG4wIloH0YCU6dvkem4ED2A4/NTGL2KhQZkc=;
        b=QtoRaVyxRDj3TSeHp6TzZLSHJVNHpfBVpgeAAImOoIwxslHeY9vtl66663nfuK7cu0
         gOMX5Zlvwz38FXiWMZG5DJkoBQwO/rrruoayQYztMac05wi15yITaWQj0gkmR6SUeFvZ
         XWlTmUy8FgdF3DX7Q4uLf4Hf5ckDd/9eIeiTbr50fUP6FjBGepWqF0ARXPIAJi8T+05m
         59vd//f68Ly+ujSF6n1oHiGWC83GlXxTeX8xgMbGHGGq8erWsD81kqPV+WdDRQV8qi3L
         Vxk1G+rYq0xTdj2cArK+/QuO80An8XqErRzSceWt9LmvuijtaXg/7qQJwrMf+ZvFFxjK
         HWSg==
X-Gm-Message-State: APjAAAW2sqtF5vqn+lMObYnPHhhRJbr5dCZlkn4CVgc9C2ujHvd+GhJd
        orBGGfZmRaOuaKnfaS8OBZkQnw==
X-Google-Smtp-Source: APXvYqxPejs4M1WdbscXCxycqz2Poi4n7gJwZDvJP81Un+Eht6mrbIDsNFasWry2+bM2Xashmn8qBw==
X-Received: by 2002:a62:6243:: with SMTP id w64mr2596442pfb.48.1575964172096;
        Mon, 09 Dec 2019 23:49:32 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm2108101pge.21.2019.12.09.23.49.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Dec 2019 23:49:31 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 3/7] bnxt_en: Return error if FW returns more data than dump length
Date:   Tue, 10 Dec 2019 02:49:09 -0500
Message-Id: <1575964153-11299-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
References: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

If any change happened in the configuration of VF in VM while
collecting live dump, there could be a race and firmware can return
more data than allocated dump length. Fix it by keeping track of
the accumulated core dump length copied so far and abort the copy
with error code if the next chunk of core dump will exceed the
original dump length.

Fixes: 6c5657d085ae ("bnxt_en: Add support for ethtool get dump.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 38 ++++++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  4 +++
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 2ccf79c..08d56ec 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3071,8 +3071,15 @@ static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg, int msg_len,
 			}
 		}
 
-		if (info->dest_buf)
-			memcpy(info->dest_buf + off, dma_buf, len);
+		if (info->dest_buf) {
+			if ((info->seg_start + off + len) <=
+			    BNXT_COREDUMP_BUF_LEN(info->buf_len)) {
+				memcpy(info->dest_buf + off, dma_buf, len);
+			} else {
+				rc = -ENOBUFS;
+				break;
+			}
+		}
 
 		if (cmn_req->req_type ==
 				cpu_to_le16(HWRM_DBG_COREDUMP_RETRIEVE))
@@ -3126,7 +3133,7 @@ static int bnxt_hwrm_dbg_coredump_initiate(struct bnxt *bp, u16 component_id,
 
 static int bnxt_hwrm_dbg_coredump_retrieve(struct bnxt *bp, u16 component_id,
 					   u16 segment_id, u32 *seg_len,
-					   void *buf, u32 offset)
+					   void *buf, u32 buf_len, u32 offset)
 {
 	struct hwrm_dbg_coredump_retrieve_input req = {0};
 	struct bnxt_hwrm_dbg_dma_info info = {NULL};
@@ -3141,8 +3148,11 @@ static int bnxt_hwrm_dbg_coredump_retrieve(struct bnxt *bp, u16 component_id,
 				seq_no);
 	info.data_len_off = offsetof(struct hwrm_dbg_coredump_retrieve_output,
 				     data_len);
-	if (buf)
+	if (buf) {
 		info.dest_buf = buf + offset;
+		info.buf_len = buf_len;
+		info.seg_start = offset;
+	}
 
 	rc = bnxt_hwrm_dbg_dma_data(bp, &req, sizeof(req), &info);
 	if (!rc)
@@ -3232,14 +3242,17 @@ bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
 static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 {
 	u32 ver_get_resp_len = sizeof(struct hwrm_ver_get_output);
+	u32 offset = 0, seg_hdr_len, seg_record_len, buf_len = 0;
 	struct coredump_segment_record *seg_record = NULL;
-	u32 offset = 0, seg_hdr_len, seg_record_len;
 	struct bnxt_coredump_segment_hdr seg_hdr;
 	struct bnxt_coredump coredump = {NULL};
 	time64_t start_time;
 	u16 start_utc;
 	int rc = 0, i;
 
+	if (buf)
+		buf_len = *dump_len;
+
 	start_time = ktime_get_real_seconds();
 	start_utc = sys_tz.tz_minuteswest * 60;
 	seg_hdr_len = sizeof(seg_hdr);
@@ -3272,6 +3285,12 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 		u32 duration = 0, seg_len = 0;
 		unsigned long start, end;
 
+		if (buf && ((offset + seg_hdr_len) >
+			    BNXT_COREDUMP_BUF_LEN(buf_len))) {
+			rc = -ENOBUFS;
+			goto err;
+		}
+
 		start = jiffies;
 
 		rc = bnxt_hwrm_dbg_coredump_initiate(bp, comp_id, seg_id);
@@ -3284,9 +3303,11 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 
 		/* Write segment data into the buffer */
 		rc = bnxt_hwrm_dbg_coredump_retrieve(bp, comp_id, seg_id,
-						     &seg_len, buf,
+						     &seg_len, buf, buf_len,
 						     offset + seg_hdr_len);
-		if (rc)
+		if (rc && rc == -ENOBUFS)
+			goto err;
+		else if (rc)
 			netdev_err(bp->dev,
 				   "Failed to retrieve coredump for seg = %d\n",
 				   seg_record->segment_id);
@@ -3316,7 +3337,8 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 					  rc);
 	kfree(coredump.data);
 	*dump_len += sizeof(struct bnxt_coredump_record);
-
+	if (rc == -ENOBUFS)
+		netdev_err(bp->dev, "Firmware returned large coredump buffer");
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index 4428d0a..3576d95 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -31,6 +31,8 @@ struct bnxt_coredump {
 	u16		total_segs;
 };
 
+#define BNXT_COREDUMP_BUF_LEN(len) ((len) - sizeof(struct bnxt_coredump_record))
+
 struct bnxt_hwrm_dbg_dma_info {
 	void *dest_buf;
 	int dest_buf_size;
@@ -38,6 +40,8 @@ struct bnxt_hwrm_dbg_dma_info {
 	u16 seq_off;
 	u16 data_len_off;
 	u16 segs;
+	u32 seg_start;
+	u32 buf_len;
 };
 
 struct hwrm_dbg_cmn_input {
-- 
2.5.1

