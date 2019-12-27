Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16DDA12B863
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfL0RzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbfL0RmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D354921927;
        Fri, 27 Dec 2019 17:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468538;
        bh=AuZ9tPBib5XjV9HSGCQZWmubqnvSSlrLHWhHcR003Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Ljanpz76CVckb69aQbXMZ3QTK4y1RTVDXx10MDoW4KK0qip/v6LnFiE3mtGI+dvp
         fh7VyWcznL1KycNUJfy6cedB/tNLzElAK3tPJj7ofWYgwsxn8GT4kyJVWkrAFO1y53
         f/uGuJyoREjKUIY7/aH4Q8Cx8RmHApgO8mAQgzHU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.4 068/187] bnxt_en: Return error if FW returns more data than dump length
Date:   Fri, 27 Dec 2019 12:38:56 -0500
Message-Id: <20191227174055.4923-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit c74751f4c39232c31214ec6a3bc1c7e62f5c728b ]

If any change happened in the configuration of VF in VM while
collecting live dump, there could be a race and firmware can return
more data than allocated dump length. Fix it by keeping track of
the accumulated core dump length copied so far and abort the copy
with error code if the next chunk of core dump will exceed the
original dump length.

Fixes: 6c5657d085ae ("bnxt_en: Add support for ethtool get dump.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 38 +++++++++++++++----
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  4 ++
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 51c140476717..a3dcd11bfd98 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3062,8 +3062,15 @@ static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg, int msg_len,
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
@@ -3117,7 +3124,7 @@ static int bnxt_hwrm_dbg_coredump_initiate(struct bnxt *bp, u16 component_id,
 
 static int bnxt_hwrm_dbg_coredump_retrieve(struct bnxt *bp, u16 component_id,
 					   u16 segment_id, u32 *seg_len,
-					   void *buf, u32 offset)
+					   void *buf, u32 buf_len, u32 offset)
 {
 	struct hwrm_dbg_coredump_retrieve_input req = {0};
 	struct bnxt_hwrm_dbg_dma_info info = {NULL};
@@ -3132,8 +3139,11 @@ static int bnxt_hwrm_dbg_coredump_retrieve(struct bnxt *bp, u16 component_id,
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
@@ -3223,14 +3233,17 @@ bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
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
@@ -3263,6 +3276,12 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
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
@@ -3275,9 +3294,11 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 
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
@@ -3307,7 +3328,8 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 					  rc);
 	kfree(coredump.data);
 	*dump_len += sizeof(struct bnxt_coredump_record);
-
+	if (rc == -ENOBUFS)
+		netdev_err(bp->dev, "Firmware returned large coredump buffer");
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index b5b65b3f8534..3998f6e809a9 100644
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
2.20.1

