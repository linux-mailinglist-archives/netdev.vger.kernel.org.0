Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD327894B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfG2KLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:17 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43702 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbfG2KLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so27782072pfg.10
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dEexkCKQ46LAP6Wd95YEsLglX8VdrbEQxppcbs5fWg8=;
        b=TnH8rdncCNBEdi9h8zXLpJFk4xRtraK7f0/VO/zMxNXnm38LK3O97SU85uB90mPO/Q
         BFBQXr+3JlJpD37ImyzhLLE4ov9DW8Sp9qypnqZdPnS7Yb35GuidcziI3Ko7IZvX4LvH
         BUNAH26ntyMdpMT4Mmx5QUg57Eas8jILhRqUI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dEexkCKQ46LAP6Wd95YEsLglX8VdrbEQxppcbs5fWg8=;
        b=iBj4kpi9xNPQFBqX+1XKml+qH7ZCk5ayEALyvMwu+p5zw2lkkgBZhQBJwcU0+IE47y
         k9fX62NZoCA4SIOe4MVUB5LRb0EPrVZEPZt5/hYKeys4s5eFaNTb50+lnQ6jSTA5hJ+d
         RrMzAGFn1lsE4QpgSzXJXMkjeV1M8ix8F1y6WmjYpISE3N/h/cCsvjJuasPL94VIWyHW
         MXiXBas8+qsjVF6Q+02XT7SS0BMT2U1cTDF0Uk/qZDGk7A5L1Oxcv3NfHCY+rOmsjNGp
         oQFztKrtyGUVshDg0oXOi4Q5w66q3aZHJdyxxBgJEnO3ATI2K7xydEADGIXoslDTCENr
         ZgAQ==
X-Gm-Message-State: APjAAAWTbHJCTbMMGIklALs1L6uV5iL45WIzwytVI/3qCNv/1Bbx/Elx
        +iz/ffTAKgiuknzOMtJQTwds5A==
X-Google-Smtp-Source: APXvYqzP6PTVhvc29vlBC5Fp+d9oSmgaKde7aZ9r7xXt3ixvreNcKtq+x1nei+a/KClh0RrZ2a0iqw==
X-Received: by 2002:a65:430b:: with SMTP id j11mr101794877pgq.383.1564395075678;
        Mon, 29 Jul 2019 03:11:15 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:14 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 02/16] bnxt_en: Add TPA structure definitions for BCM57500 chips.
Date:   Mon, 29 Jul 2019 06:10:19 -0400
Message-Id: <1564395033-19511-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new chips have a slightly modified TPA interface for LRO/GRO_HW.
Modify the TPA structures so that the same structures can also be
used on the new chips.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 67 +++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 16694b7..650d800 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -113,6 +113,7 @@ struct tx_cmp {
 	 #define CMP_TYPE_RX_AGG_CMP				 18
 	 #define CMP_TYPE_RX_L2_TPA_START_CMP			 19
 	 #define CMP_TYPE_RX_L2_TPA_END_CMP			 21
+	 #define CMP_TYPE_RX_TPA_AGG_CMP			 22
 	 #define CMP_TYPE_STATUS_CMP				 32
 	 #define CMP_TYPE_REMOTE_DRIVER_REQ			 34
 	 #define CMP_TYPE_REMOTE_DRIVER_RESP			 36
@@ -263,14 +264,21 @@ struct rx_agg_cmp {
 	u32 rx_agg_cmp_opaque;
 	__le32 rx_agg_cmp_v;
 	#define RX_AGG_CMP_V					(1 << 0)
+	#define RX_AGG_CMP_AGG_ID				(0xffff << 16)
+	 #define RX_AGG_CMP_AGG_ID_SHIFT			 16
 	__le32 rx_agg_cmp_unused;
 };
 
+#define TPA_AGG_AGG_ID(rx_agg)				\
+	((le32_to_cpu((rx_agg)->rx_agg_cmp_v) &		\
+	 RX_AGG_CMP_AGG_ID) >> RX_AGG_CMP_AGG_ID_SHIFT)
+
 struct rx_tpa_start_cmp {
 	__le32 rx_tpa_start_cmp_len_flags_type;
 	#define RX_TPA_START_CMP_TYPE				(0x3f << 0)
 	#define RX_TPA_START_CMP_FLAGS				(0x3ff << 6)
 	 #define RX_TPA_START_CMP_FLAGS_SHIFT			 6
+	#define RX_TPA_START_CMP_FLAGS_ERROR			(0x1 << 6)
 	#define RX_TPA_START_CMP_FLAGS_PLACEMENT		(0x7 << 7)
 	 #define RX_TPA_START_CMP_FLAGS_PLACEMENT_SHIFT		 7
 	 #define RX_TPA_START_CMP_FLAGS_PLACEMENT_JUMBO		 (0x1 << 7)
@@ -278,6 +286,7 @@ struct rx_tpa_start_cmp {
 	 #define RX_TPA_START_CMP_FLAGS_PLACEMENT_GRO_JUMBO	 (0x5 << 7)
 	 #define RX_TPA_START_CMP_FLAGS_PLACEMENT_GRO_HDS	 (0x6 << 7)
 	#define RX_TPA_START_CMP_FLAGS_RSS_VALID		(0x1 << 10)
+	#define RX_TPA_START_CMP_FLAGS_TIMESTAMP		(0x1 << 11)
 	#define RX_TPA_START_CMP_FLAGS_ITYPES			(0xf << 12)
 	 #define RX_TPA_START_CMP_FLAGS_ITYPES_SHIFT		 12
 	 #define RX_TPA_START_CMP_FLAGS_ITYPE_TCP		 (0x2 << 12)
@@ -291,6 +300,8 @@ struct rx_tpa_start_cmp {
 	 #define RX_TPA_START_CMP_RSS_HASH_TYPE_SHIFT		 9
 	#define RX_TPA_START_CMP_AGG_ID				(0x7f << 25)
 	 #define RX_TPA_START_CMP_AGG_ID_SHIFT			 25
+	#define RX_TPA_START_CMP_AGG_ID_P5			(0xffff << 16)
+	 #define RX_TPA_START_CMP_AGG_ID_SHIFT_P5		 16
 
 	__le32 rx_tpa_start_cmp_rss_hash;
 };
@@ -308,6 +319,14 @@ struct rx_tpa_start_cmp {
 	((le32_to_cpu((rx_tpa_start)->rx_tpa_start_cmp_misc_v1) &	\
 	 RX_TPA_START_CMP_AGG_ID) >> RX_TPA_START_CMP_AGG_ID_SHIFT)
 
+#define TPA_START_AGG_ID_P5(rx_tpa_start)				\
+	((le32_to_cpu((rx_tpa_start)->rx_tpa_start_cmp_misc_v1) &	\
+	 RX_TPA_START_CMP_AGG_ID_P5) >> RX_TPA_START_CMP_AGG_ID_SHIFT_P5)
+
+#define TPA_START_ERROR(rx_tpa_start)					\
+	((rx_tpa_start)->rx_tpa_start_cmp_len_flags_type &		\
+	 cpu_to_le32(RX_TPA_START_CMP_FLAGS_ERROR))
+
 struct rx_tpa_start_cmp_ext {
 	__le32 rx_tpa_start_cmp_flags2;
 	#define RX_TPA_START_CMP_FLAGS2_IP_CS_CALC		(0x1 << 0)
@@ -315,10 +334,20 @@ struct rx_tpa_start_cmp_ext {
 	#define RX_TPA_START_CMP_FLAGS2_T_IP_CS_CALC		(0x1 << 2)
 	#define RX_TPA_START_CMP_FLAGS2_T_L4_CS_CALC		(0x1 << 3)
 	#define RX_TPA_START_CMP_FLAGS2_IP_TYPE			(0x1 << 8)
+	#define RX_TPA_START_CMP_FLAGS2_CSUM_CMPL_VALID		(0x1 << 9)
+	#define RX_TPA_START_CMP_FLAGS2_EXT_META_FORMAT		(0x3 << 10)
+	 #define RX_TPA_START_CMP_FLAGS2_EXT_META_FORMAT_SHIFT	 10
+	#define RX_TPA_START_CMP_FLAGS2_CSUM_CMPL		(0xffff << 16)
+	 #define RX_TPA_START_CMP_FLAGS2_CSUM_CMPL_SHIFT	 16
 
 	__le32 rx_tpa_start_cmp_metadata;
 	__le32 rx_tpa_start_cmp_cfa_code_v2;
 	#define RX_TPA_START_CMP_V2				(0x1 << 0)
+	#define RX_TPA_START_CMP_ERRORS_BUFFER_ERROR_MASK	(0x7 << 1)
+	 #define RX_TPA_START_CMP_ERRORS_BUFFER_ERROR_SHIFT	 1
+	 #define RX_TPA_START_CMP_ERRORS_BUFFER_ERROR_NO_BUFFER	 (0x0 << 1)
+	 #define RX_TPA_START_CMP_ERRORS_BUFFER_ERROR_BAD_FORMAT (0x3 << 1)
+	 #define RX_TPA_START_CMP_ERRORS_BUFFER_ERROR_FLUSH	 (0x5 << 1)
 	#define RX_TPA_START_CMP_CFA_CODE			(0xffff << 16)
 	 #define RX_TPA_START_CMPL_CFA_CODE_SHIFT		 16
 	__le32 rx_tpa_start_cmp_hdr_info;
@@ -332,6 +361,11 @@ struct rx_tpa_start_cmp_ext {
 	(!!((rx_tpa_start)->rx_tpa_start_cmp_flags2 &		\
 	    cpu_to_le32(RX_TPA_START_CMP_FLAGS2_IP_TYPE)))
 
+#define TPA_START_ERROR_CODE(rx_tpa_start)				\
+	((le32_to_cpu((rx_tpa_start)->rx_tpa_start_cmp_cfa_code_v2) &	\
+	  RX_TPA_START_CMP_ERRORS_BUFFER_ERROR_MASK) >>			\
+	 RX_TPA_START_CMP_ERRORS_BUFFER_ERROR_SHIFT)
+
 struct rx_tpa_end_cmp {
 	__le32 rx_tpa_end_cmp_len_flags_type;
 	#define RX_TPA_END_CMP_TYPE				(0x3f << 0)
@@ -361,6 +395,8 @@ struct rx_tpa_end_cmp {
 	 #define RX_TPA_END_CMP_PAYLOAD_OFFSET_SHIFT		 16
 	#define RX_TPA_END_CMP_AGG_ID				(0x7f << 25)
 	 #define RX_TPA_END_CMP_AGG_ID_SHIFT			 25
+	#define RX_TPA_END_CMP_AGG_ID_P5			(0xffff << 16)
+	 #define RX_TPA_END_CMP_AGG_ID_SHIFT_P5			 16
 
 	__le32 rx_tpa_end_cmp_tsdelta;
 	#define RX_TPA_END_GRO_TS				(0x1 << 31)
@@ -370,6 +406,18 @@ struct rx_tpa_end_cmp {
 	((le32_to_cpu((rx_tpa_end)->rx_tpa_end_cmp_misc_v1) &		\
 	 RX_TPA_END_CMP_AGG_ID) >> RX_TPA_END_CMP_AGG_ID_SHIFT)
 
+#define TPA_END_AGG_ID_P5(rx_tpa_end)					\
+	((le32_to_cpu((rx_tpa_end)->rx_tpa_end_cmp_misc_v1) &		\
+	 RX_TPA_END_CMP_AGG_ID_P5) >> RX_TPA_END_CMP_AGG_ID_SHIFT_P5)
+
+#define TPA_END_PAYLOAD_OFF(rx_tpa_end)					\
+	((le32_to_cpu((rx_tpa_end)->rx_tpa_end_cmp_misc_v1) &		\
+	 RX_TPA_END_CMP_PAYLOAD_OFFSET) >> RX_TPA_END_CMP_PAYLOAD_OFFSET_SHIFT)
+
+#define TPA_END_AGG_BUFS(rx_tpa_end)					\
+	((le32_to_cpu((rx_tpa_end)->rx_tpa_end_cmp_misc_v1) &		\
+	 RX_TPA_END_CMP_AGG_BUFS) >> RX_TPA_END_CMP_AGG_BUFS_SHIFT)
+
 #define TPA_END_TPA_SEGS(rx_tpa_end)					\
 	((le32_to_cpu((rx_tpa_end)->rx_tpa_end_cmp_misc_v1) &		\
 	 RX_TPA_END_CMP_TPA_SEGS) >> RX_TPA_END_CMP_TPA_SEGS_SHIFT)
@@ -389,6 +437,10 @@ struct rx_tpa_end_cmp {
 struct rx_tpa_end_cmp_ext {
 	__le32 rx_tpa_end_cmp_dup_acks;
 	#define RX_TPA_END_CMP_TPA_DUP_ACKS			(0xf << 0)
+	#define RX_TPA_END_CMP_PAYLOAD_OFFSET_P5		(0xff << 16)
+	 #define RX_TPA_END_CMP_PAYLOAD_OFFSET_SHIFT_P5		 16
+	#define RX_TPA_END_CMP_AGG_BUFS_P5			(0xff << 24)
+	 #define RX_TPA_END_CMP_AGG_BUFS_SHIFT_P5		 24
 
 	__le32 rx_tpa_end_cmp_seg_len;
 	#define RX_TPA_END_CMP_TPA_SEG_LEN			(0xffff << 0)
@@ -396,7 +448,13 @@ struct rx_tpa_end_cmp_ext {
 	__le32 rx_tpa_end_cmp_errors_v2;
 	#define RX_TPA_END_CMP_V2				(0x1 << 0)
 	#define RX_TPA_END_CMP_ERRORS				(0x3 << 1)
+	#define RX_TPA_END_CMP_ERRORS_P5			(0x7 << 1)
 	#define RX_TPA_END_CMPL_ERRORS_SHIFT			 1
+	 #define RX_TPA_END_CMP_ERRORS_BUFFER_ERROR_NO_BUFFER	 (0x0 << 1)
+	 #define RX_TPA_END_CMP_ERRORS_BUFFER_ERROR_NOT_ON_CHIP	 (0x2 << 1)
+	 #define RX_TPA_END_CMP_ERRORS_BUFFER_ERROR_BAD_FORMAT	 (0x3 << 1)
+	 #define RX_TPA_END_CMP_ERRORS_BUFFER_ERROR_RSV_ERROR	 (0x4 << 1)
+	 #define RX_TPA_END_CMP_ERRORS_BUFFER_ERROR_FLUSH	 (0x5 << 1)
 
 	u32 rx_tpa_end_cmp_start_opaque;
 };
@@ -405,6 +463,15 @@ struct rx_tpa_end_cmp_ext {
 	((rx_tpa_end_ext)->rx_tpa_end_cmp_errors_v2 &			\
 	 cpu_to_le32(RX_TPA_END_CMP_ERRORS))
 
+#define TPA_END_PAYLOAD_OFF_P5(rx_tpa_end_ext)				\
+	((le32_to_cpu((rx_tpa_end_ext)->rx_tpa_end_cmp_dup_acks) &	\
+	 RX_TPA_END_CMP_PAYLOAD_OFFSET_P5) >>				\
+	RX_TPA_END_CMP_PAYLOAD_OFFSET_SHIFT_P5)
+
+#define TPA_END_AGG_BUFS_P5(rx_tpa_end_ext)				\
+	((le32_to_cpu((rx_tpa_end_ext)->rx_tpa_end_cmp_dup_acks) &	\
+	 RX_TPA_END_CMP_AGG_BUFS_P5) >> RX_TPA_END_CMP_AGG_BUFS_SHIFT_P5)
+
 struct nqe_cn {
 	__le16	type;
 	#define NQ_CN_TYPE_MASK           0x3fUL
-- 
2.5.1

