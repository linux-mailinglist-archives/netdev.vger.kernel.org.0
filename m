Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC253F9C86
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 18:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbhH0QbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 12:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbhH0QbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 12:31:16 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C52C0613D9
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 09:30:27 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso9236322pjh.5
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 09:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AmRGvbkZ+HWY5GZhyZd4YkSqh2o2/5UvgQvzBZ7Y2Ws=;
        b=PbsJrBMRKF/2vojBT1FJDhx/vuIEAl3DBhXymIuoiS3bjtC9u99BlyecfyeUVCLo7H
         ghgkOa3TLsAFj8jiEcFUTOTXDRCXv6iJOcqITBEi4O8pF5th6eTPpBnLanlrW86k8Glf
         T+nSBgmKSMw4IjvwkQjpua7f8NsWP0yhHmDvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AmRGvbkZ+HWY5GZhyZd4YkSqh2o2/5UvgQvzBZ7Y2Ws=;
        b=B1F8hL9YASgTzMWLXNIbX/45Z/LpVjlVmHSz05s/z/2SRtnAzs7YGKOfmnMciEVZLB
         RffxCFfNzaWFfjHFvyWiClnfA0oztpUslIISezKyhzgEdbxIsPs6k1k1CUZogHn2TO6L
         lMPm35OPBZ+9pj3BIzCU4w9aAUnW1bjEwooqo2DaiH4I8Z5LmjEFk2dvhKZ/HIkwGyic
         wSpzouzv17D6huXiqaa0ZqwFWozlJzs45wl7ZTMgKOckyLxJjwjHbwnnKAmsUr+DmnHc
         91iTx+DvAMNkB6gDjpqx4pB/MNQcKBZaUwWMq/b5v+1E1vnx97LC7KREfb9XJFykIZ2j
         6GzA==
X-Gm-Message-State: AOAM5335ISHaFlDyPPxnfHF6SF/erRMh5s+2rT0S8PW7UAkw4Po1qwjw
        47lA3IL4XQH/V25XxHCC2uG47A==
X-Google-Smtp-Source: ABdhPJzfk4UnyWU+F8v5+CWMNHDk8HKgiEMVa3XrHpLNd6CNMykmib0yPZjm6yRM9/7ypO678H9nig==
X-Received: by 2002:a17:90a:a404:: with SMTP id y4mr11944751pjp.52.1630081827075;
        Fri, 27 Aug 2021 09:30:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i6sm6964852pfa.44.2021.08.27.09.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 09:30:18 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Luca Coelho <luciano.coelho@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-crypto@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-can@vger.kernel.org,
        bpf@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Keith Packard <keithp@keithp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        clang-built-linux@googlegroups.com, linux-hardening@vger.kernel.org
Subject: [PATCH v3 2/5] treewide: Replace open-coded flex arrays in unions
Date:   Fri, 27 Aug 2021 09:30:12 -0700
Message-Id: <20210827163015.3141722-3-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210827163015.3141722-1-keescook@chromium.org>
References: <20210827163015.3141722-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12270; h=from:subject; bh=eFCqj8TgCluR7qHynURYZ3UAYbkKodDwENZe+J/Ww2Q=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhKRMWXBl23f3wYmfAA9oafQAsGo7DW0itqZdpWZf5 gSdVkAKJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYSkTFgAKCRCJcvTf3G3AJmBoD/ 42XX6WCHs/GxmJ0TRmk9fQ9rZ0aHarUT5iOQDO54UR5mO7QGfQLZBAekcL6VoOCcFmDb8/kMN69aKi i1tMqoKXTehr4M+M/PSneXVzBBt6oNUBt0hfn4tvTpdvKaJcSUXIzG6gYaQSNb9+pWESUnOdIHD4U8 QwTOE+Cf0d8Eoja+9ApWCBj4XHZY9GsHStcT/EYsTrOaurp2Jmqo79kOiZht1P4qIYmAiIOD9bgjuE wSRzPl33zylBStMO+CNTK2h9g2lTc0p3ln3sxbHSs9f4UW8HXohR7GcY/ZnsXWQfrwL6GPeaTI4U0f D7r2CkyaraTarN7iBaeUo6KBSAzyJ0grjvLiyrVj/FN7IN5lfNdZwO1ENj84mo4yv/GJJWv/QHK8t+ PTYJgTE9ukqmToa/Yb+8+fiSA2uaEy431jAL3ZPrJiOGvLB4sAWRNxiHjHi/h02kGzJ+Um9pA0i1Ef +TDsmdMun7/PqRLWm8Ss0xXm8TpMOkROtyjTWTipN4rlIzGCkVch6/nis3RmICdpmLsnw/yDZuB/RM y4lwcbImf2olvkiavsNRHqQMSNEHxMMuxa6GEhPc1CouLFUypjkv8lOffUdV2C6oDRBR78XRINU9i2 /lnvW1jKL07JSC30nYUaj409ff+zY4sMBCbcV00kH+L/BunY6FL8zDvfy8qA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In support of enabling -Warray-bounds and -Wzero-length-bounds and
correctly handling run-time memcpy() bounds checking, replace all
open-coded flexible arrays (i.e. 0-element arrays) in unions with the
DECLARE_FLEX_ARRAY() helper macro.

This fixes warnings such as:

fs/hpfs/anode.c: In function 'hpfs_add_sector_to_btree':
fs/hpfs/anode.c:209:27: warning: array subscript 0 is outside the bounds of an interior zero-length array 'struct bplus_internal_node[0]' [-Wzero-length-bounds]
  209 |    anode->btree.u.internal[0].down = cpu_to_le32(a);
      |    ~~~~~~~~~~~~~~~~~~~~~~~^~~
In file included from fs/hpfs/hpfs_fn.h:26,
                 from fs/hpfs/anode.c:10:
fs/hpfs/hpfs.h:412:32: note: while referencing 'internal'
  412 |     struct bplus_internal_node internal[0]; /* (internal) 2-word entries giving
      |                                ^~~~~~~~

drivers/net/can/usb/etas_es58x/es58x_fd.c: In function 'es58x_fd_tx_can_msg':
drivers/net/can/usb/etas_es58x/es58x_fd.c:360:35: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[]'} [-Wzero-length-bounds]
  360 |  tx_can_msg = (typeof(tx_can_msg))&es58x_fd_urb_cmd->raw_msg[msg_len];
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:22,
                 from drivers/net/can/usb/etas_es58x/es58x_fd.c:17:
drivers/net/can/usb/etas_es58x/es58x_fd.h:231:6: note: while referencing 'raw_msg'
  231 |   u8 raw_msg[0];
      |      ^~~~~~~

Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc: Rohit Maheshwari <rohitm@chelsio.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Mordechay Goodstein <mordechay.goodstein@intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: linux-crypto@vger.kernel.org
Cc: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-can@vger.kernel.org
Cc: bpf@vger.kernel.org
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # drivers/net/can/usb/etas_es58x/*
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/chelsio/chcr_crypto.h              | 14 +++++++++-----
 drivers/net/can/usb/etas_es58x/es581_4.h          |  2 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.h         |  2 +-
 drivers/net/wireless/ath/ath10k/htt.h             |  7 +++++--
 drivers/net/wireless/intel/iwlegacy/commands.h    |  6 ++++--
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h |  6 ++++--
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h    |  6 ++++--
 drivers/scsi/aic94xx/aic94xx_sds.c                |  6 ++++--
 fs/hpfs/hpfs.h                                    |  8 ++++----
 include/linux/filter.h                            |  6 ++++--
 include/scsi/sas.h                                | 12 ++++++++----
 include/uapi/rdma/rdma_user_rxe.h                 |  4 ++--
 include/uapi/sound/asoc.h                         |  4 ++--
 13 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index e89f9e0094b4..c7816c83e324 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -222,8 +222,10 @@ struct chcr_authenc_ctx {
 };
 
 struct __aead_ctx {
-	struct chcr_gcm_ctx gcm[0];
-	struct chcr_authenc_ctx authenc[];
+	union {
+		DECLARE_FLEX_ARRAY(struct chcr_gcm_ctx, gcm);
+		DECLARE_FLEX_ARRAY(struct chcr_authenc_ctx, authenc);
+	};
 };
 
 struct chcr_aead_ctx {
@@ -245,9 +247,11 @@ struct hmac_ctx {
 };
 
 struct __crypto_ctx {
-	struct hmac_ctx hmacctx[0];
-	struct ablk_ctx ablkctx[0];
-	struct chcr_aead_ctx aeadctx[];
+	union {
+		DECLARE_FLEX_ARRAY(struct hmac_ctx, hmacctx);
+		DECLARE_FLEX_ARRAY(struct ablk_ctx, ablkctx);
+		DECLARE_FLEX_ARRAY(struct chcr_aead_ctx, aeadctx);
+	};
 };
 
 struct chcr_context {
diff --git a/drivers/net/can/usb/etas_es58x/es581_4.h b/drivers/net/can/usb/etas_es58x/es581_4.h
index 4bc60a6df697..667ecb77168c 100644
--- a/drivers/net/can/usb/etas_es58x/es581_4.h
+++ b/drivers/net/can/usb/etas_es58x/es581_4.h
@@ -192,7 +192,7 @@ struct es581_4_urb_cmd {
 		struct es581_4_rx_cmd_ret rx_cmd_ret;
 		__le64 timestamp;
 		u8 rx_cmd_ret_u8;
-		u8 raw_msg[0];
+		DECLARE_FLEX_ARRAY(u8, raw_msg);
 	} __packed;
 
 	__le16 reserved_for_crc16_do_not_use;
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.h b/drivers/net/can/usb/etas_es58x/es58x_fd.h
index ee18a87e40c0..e33003f96e5e 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.h
@@ -228,7 +228,7 @@ struct es58x_fd_urb_cmd {
 		struct es58x_fd_tx_ack_msg tx_ack_msg;
 		__le64 timestamp;
 		__le32 rx_cmd_ret_le32;
-		u8 raw_msg[0];
+		DECLARE_FLEX_ARRAY(u8, raw_msg);
 	} __packed;
 
 	__le16 reserved_for_crc16_do_not_use;
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index ec689e3ce48a..a6de08d3bf4a 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1674,8 +1674,11 @@ struct htt_tx_fetch_ind {
 	__le32 token;
 	__le16 num_resp_ids;
 	__le16 num_records;
-	__le32 resp_ids[0]; /* ath10k_htt_get_tx_fetch_ind_resp_ids() */
-	struct htt_tx_fetch_record records[];
+	union {
+		/* ath10k_htt_get_tx_fetch_ind_resp_ids() */
+		DECLARE_FLEX_ARRAY(__le32, resp_ids);
+		DECLARE_FLEX_ARRAY(struct htt_tx_fetch_record, records);
+	};
 } __packed;
 
 static inline void *
diff --git a/drivers/net/wireless/intel/iwlegacy/commands.h b/drivers/net/wireless/intel/iwlegacy/commands.h
index 89c6671b32bc..4a97310f8fee 100644
--- a/drivers/net/wireless/intel/iwlegacy/commands.h
+++ b/drivers/net/wireless/intel/iwlegacy/commands.h
@@ -1408,8 +1408,10 @@ struct il3945_tx_cmd {
 	 * MAC header goes here, followed by 2 bytes padding if MAC header
 	 * length is 26 or 30 bytes, followed by payload data
 	 */
-	u8 payload[0];
-	struct ieee80211_hdr hdr[];
+	union {
+		DECLARE_FLEX_ARRAY(u8, payload);
+		DECLARE_FLEX_ARRAY(struct ieee80211_hdr, hdr);
+	};
 } __packed;
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
index 235c7a2e3483..75a4b8e26232 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
@@ -1251,8 +1251,10 @@ struct iwl_tx_cmd {
 	 * MAC header goes here, followed by 2 bytes padding if MAC header
 	 * length is 26 or 30 bytes, followed by payload data
 	 */
-	u8 payload[0];
-	struct ieee80211_hdr hdr[];
+	union {
+		DECLARE_FLEX_ARRAY(u8, payload);
+		DECLARE_FLEX_ARRAY(struct ieee80211_hdr, hdr);
+	};
 } __packed;
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index 24e4a82a55da..66c5487e857e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -713,8 +713,10 @@ struct iwl_mvm_compressed_ba_notif {
 	__le32 tx_rate;
 	__le16 tfd_cnt;
 	__le16 ra_tid_cnt;
-	struct iwl_mvm_compressed_ba_ratid ra_tid[0];
-	struct iwl_mvm_compressed_ba_tfd tfd[];
+	union {
+		DECLARE_FLEX_ARRAY(struct iwl_mvm_compressed_ba_ratid, ra_tid);
+		DECLARE_FLEX_ARRAY(struct iwl_mvm_compressed_ba_tfd, tfd);
+	};
 } __packed; /* COMPRESSED_BA_RES_API_S_VER_4 */
 
 /**
diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 46815e65f7a4..5def83c88f13 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -517,8 +517,10 @@ struct asd_ms_conn_map {
 	u8    num_nodes;
 	u8    usage_model_id;
 	u32   _resvd;
-	struct asd_ms_conn_desc conn_desc[0];
-	struct asd_ms_node_desc node_desc[];
+	union {
+		DECLARE_FLEX_ARRAY(struct asd_ms_conn_desc, conn_desc);
+		DECLARE_FLEX_ARRAY(struct asd_ms_node_desc, node_desc);
+	};
 } __attribute__ ((packed));
 
 struct asd_ctrla_phy_entry {
diff --git a/fs/hpfs/hpfs.h b/fs/hpfs/hpfs.h
index d92c4af3e1b4..281dec8f636b 100644
--- a/fs/hpfs/hpfs.h
+++ b/fs/hpfs/hpfs.h
@@ -409,10 +409,10 @@ struct bplus_header
   __le16 first_free;			/* offset from start of header to
 					   first free node in array */
   union {
-    struct bplus_internal_node internal[0]; /* (internal) 2-word entries giving
-					       subtree pointers */
-    struct bplus_leaf_node external[0];	    /* (external) 3-word entries giving
-					       sector runs */
+	/* (internal) 2-word entries giving subtree pointers */
+	DECLARE_FLEX_ARRAY(struct bplus_internal_node, internal);
+	/* (external) 3-word entries giving sector runs */
+	DECLARE_FLEX_ARRAY(struct bplus_leaf_node, external);
   } u;
 };
 
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 472f97074da0..5ca52bfa5868 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -572,8 +572,10 @@ struct bpf_prog {
 	struct bpf_prog_aux	*aux;		/* Auxiliary fields */
 	struct sock_fprog_kern	*orig_prog;	/* Original BPF program */
 	/* Instructions for interpreter */
-	struct sock_filter	insns[0];
-	struct bpf_insn		insnsi[];
+	union {
+		DECLARE_FLEX_ARRAY(struct sock_filter, insns);
+		DECLARE_FLEX_ARRAY(struct bpf_insn, insnsi);
+	};
 };
 
 struct sk_filter {
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index 4726c1bbec65..64154c1fed02 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -323,8 +323,10 @@ struct ssp_response_iu {
 	__be32 sense_data_len;
 	__be32 response_data_len;
 
-	u8     resp_data[0];
-	u8     sense_data[];
+	union {
+		DECLARE_FLEX_ARRAY(u8, resp_data);
+		DECLARE_FLEX_ARRAY(u8, sense_data);
+	};
 } __attribute__ ((packed));
 
 struct ssp_command_iu {
@@ -554,8 +556,10 @@ struct ssp_response_iu {
 	__be32 sense_data_len;
 	__be32 response_data_len;
 
-	u8     resp_data[0];
-	u8     sense_data[];
+	union {
+		DECLARE_FLEX_ARRAY(u8, resp_data);
+		DECLARE_FLEX_ARRAY(u8, sense_data);
+	};
 } __attribute__ ((packed));
 
 struct ssp_command_iu {
diff --git a/include/uapi/rdma/rdma_user_rxe.h b/include/uapi/rdma/rdma_user_rxe.h
index e283c2220aba..7f44d54bb0ab 100644
--- a/include/uapi/rdma/rdma_user_rxe.h
+++ b/include/uapi/rdma/rdma_user_rxe.h
@@ -141,8 +141,8 @@ struct rxe_dma_info {
 	__u32			sge_offset;
 	__u32			reserved;
 	union {
-		__u8		inline_data[0];
-		struct rxe_sge	sge[0];
+		__DECLARE_FLEX_ARRAY(__u8, inline_data);
+		__DECLARE_FLEX_ARRAY(struct rxe_sge, sge);
 	};
 };
 
diff --git a/include/uapi/sound/asoc.h b/include/uapi/sound/asoc.h
index da61398b1f8f..053949287ce8 100644
--- a/include/uapi/sound/asoc.h
+++ b/include/uapi/sound/asoc.h
@@ -240,8 +240,8 @@ struct snd_soc_tplg_vendor_array {
 struct snd_soc_tplg_private {
 	__le32 size;	/* in bytes of private data */
 	union {
-		char data[0];
-		struct snd_soc_tplg_vendor_array array[0];
+		__DECLARE_FLEX_ARRAY(char, data);
+		__DECLARE_FLEX_ARRAY(struct snd_soc_tplg_vendor_array, array);
 	};
 } __attribute__((packed));
 
-- 
2.30.2

