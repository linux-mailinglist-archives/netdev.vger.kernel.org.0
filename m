Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CE93F9C7E
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhH0QbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 12:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbhH0QbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 12:31:13 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795F2C0613CF
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 09:30:24 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j187so6139324pfg.4
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 09:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1psCo0hHdSsvpvZi1i10TA+ZorhOo3SQLpKqrNnbpKQ=;
        b=OmnqFAP7ktTCd9H3gR8AVQeDG+ud0Mtb2MSPXbpux8F/3bTLlDa8f5Vcqs7FwvrfVk
         731hNKcsoWeGTILObQXHXl5QUzZuVzwVHwtI6D2+JXxVGW+sQ7jnUj3Q7lJweJ4NAedF
         Tb3qROx9NVlnsVaFGC4Ka3YR8s7r8IkeN8bjQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1psCo0hHdSsvpvZi1i10TA+ZorhOo3SQLpKqrNnbpKQ=;
        b=K/JXU2eK/zRsaJ+KpgSmLopDilzpTZCA3B3XkfVxruUK5XcG/RcJbC3Wdx8GuAipyt
         ZngrLxxoBqFlhYMp+ejMMFEUnZE+oW0Yu63uh6dGICf4LgVv/Una0GpTFIItfGyPQCJ0
         oAMGBDMmVD84l6EuNFZb5jbYVZJOlwHIeiHg/WNLLkhSjuYWHLUm3n8BLi5u94/u/W6b
         jkQDOSlzbh8eHtBJnI33PTnN7zPvLa3QkaCNoXJLW+CO3Q+/aZV0u78Oahz4+dsCX9u5
         FqYC/W+wW3J1eGuL54hKM7ZzWg+Li/IBfqHGim9/F1gxzpsV7ZpCmTQzcu7Z/ii+Rc1F
         Fbjw==
X-Gm-Message-State: AOAM5322uNvdQNlFkVEDzNVZXk/+Xs/viHUH4QwMTiEyO/BcYgrCBARQ
        MoVj3qD3ppJltIyMnNHC00YWew==
X-Google-Smtp-Source: ABdhPJzetnDNmg6GQEa6gDwmO0Vjz/O0oS5CoVDRuSpJH609wxH+6x0AvmklOe/wlDSvwKW+u/LiYA==
X-Received: by 2002:a63:68a:: with SMTP id 132mr8698863pgg.154.1630081823959;
        Fri, 27 Aug 2021 09:30:23 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x16sm7444590pgc.49.2021.08.27.09.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 09:30:18 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        Ross Schmidt <ross.schm.dev@gmail.com>,
        Marco Cesati <marcocesati@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-staging@lists.linux.dev,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Keith Packard <keithp@keithp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        clang-built-linux@googlegroups.com, linux-hardening@vger.kernel.org
Subject: [PATCH v3 3/5] treewide: Replace 0-element memcpy() destinations with flexible arrays
Date:   Fri, 27 Aug 2021 09:30:13 -0700
Message-Id: <20210827163015.3141722-4-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210827163015.3141722-1-keescook@chromium.org>
References: <20210827163015.3141722-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9615; h=from:subject; bh=DQFK9rz+vbtwSe8m1jRGSzDk89AmiraaMvJ3vzaHm8Y=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhKRMWNfZsDewA0npSo8PMQq7ndkNGBWcmzgJmKRrJ 1BkWyaKJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYSkTFgAKCRCJcvTf3G3AJr0uD/ 4mAYPTqz/QSFVNhxAMqLvTQS1+RgNFauOCioQYwm1AMJdQ8XhUGVPZ5u7bpT77mQ4ShRsILG1SKcRq X2v0DzW0lK/aU0unUk0NzIIVHn5L2izCW1x66txy02zy1EMGvgy7A4k25ef19jKZn5W0nYlHFokzsB OmUn/u9jfMVp0lQlJZYc5u+oLNwFHerFEME+eQuB2GPR2MXgGmItzHkhlJ3rg5zOITlORtNZxpTuQE cJa6WU27FaSI4SzOoLDXs2bJ8/uNKRq6Rm1fLN0IFrV6TxBUExu2x9TDuCPrLsayDjtWDSed96v4k3 wf7j2rtoN4ra8X84L3mtuBv0ye7UDIiMJrBxwqqmJLPsiNLECTfh/s8YcmypPEMFyIrQx5lHhQEFgU yIcdbY5hY/Ok2A2Jh9vgkjghochXbxfy1R7sboEoh9ZipKOWdIQEIt+Ihat2UsOcNi7XQRsoVM/UhF 4zRfIi3vicfpkpZGiU/orZN69+ouZyzFrNKcsK6TgjJVBU0cZR148+Pi0cb3phPtxrczreV4TbQTIw 2raMJPQBueGoeiduPt9tuBXiwVseZeVNQHRSk9A33Vkod3D6cjAVs/jPrlFG64umQd1zgHY7FFYjpJ rj9R4U+O5+aKEKzGT+UWyv+E+X7NizZ0dcfT+jBtMTEqj6BRx8G/j32rnqLQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 0-element arrays that are used as memcpy() destinations are actually
flexible arrays. Adjust their structures accordingly so that memcpy()
can better reason able their destination size (i.e. they need to be seen
as "unknown" length rather than "zero").

In some cases, use of the DECLARE_FLEX_ARRAY() helper is needed when a
flexible array is alone in a struct.

Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Fabio Aiuto <fabioaiuto83@gmail.com>
Cc: Ross Schmidt <ross.schm.dev@gmail.com>
Cc: Marco Cesati <marcocesati@gmail.com>
Cc: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-staging@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ath/ath10k/bmi.h         | 10 +++----
 drivers/scsi/qla4xxx/ql4_def.h                |  4 +--
 drivers/staging/rtl8188eu/include/ieee80211.h |  6 ++--
 drivers/staging/rtl8712/ieee80211.h           |  4 +--
 drivers/staging/rtl8723bs/include/ieee80211.h |  6 ++--
 include/linux/ieee80211.h                     | 30 +++++++++----------
 include/uapi/linux/dlm_device.h               |  4 +--
 7 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index f6fadcbdd86e..0685c0d2d4ea 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -109,7 +109,7 @@ struct bmi_cmd {
 		struct {
 			__le32 addr;
 			__le32 len;
-			u8 payload[0];
+			u8 payload[];
 		} write_mem;
 		struct {
 			__le32 addr;
@@ -138,18 +138,18 @@ struct bmi_cmd {
 		} rompatch_uninstall;
 		struct {
 			__le32 count;
-			__le32 patch_ids[0]; /* length of @count */
+			__le32 patch_ids[]; /* length of @count */
 		} rompatch_activate;
 		struct {
 			__le32 count;
-			__le32 patch_ids[0]; /* length of @count */
+			__le32 patch_ids[]; /* length of @count */
 		} rompatch_deactivate;
 		struct {
 			__le32 addr;
 		} lz_start;
 		struct {
 			__le32 len; /* max BMI_MAX_DATA_SIZE */
-			u8 payload[0]; /* length of @len */
+			u8 payload[]; /* length of @len */
 		} lz_data;
 		struct {
 			u8 name[BMI_NVRAM_SEG_NAME_SZ];
@@ -160,7 +160,7 @@ struct bmi_cmd {
 
 union bmi_resp {
 	struct {
-		u8 payload[0];
+		DECLARE_FLEX_ARRAY(u8, payload);
 	} read_mem;
 	struct {
 		__le32 result;
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 031569c496e5..69a590546bf9 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -366,13 +366,13 @@ struct qla4_work_evt {
 		struct {
 			enum iscsi_host_event_code code;
 			uint32_t data_size;
-			uint8_t data[0];
+			uint8_t data[];
 		} aen;
 		struct {
 			uint32_t status;
 			uint32_t pid;
 			uint32_t data_size;
-			uint8_t data[0];
+			uint8_t data[];
 		} ping;
 	} u;
 };
diff --git a/drivers/staging/rtl8188eu/include/ieee80211.h b/drivers/staging/rtl8188eu/include/ieee80211.h
index da6245a77d5d..aa5c1a513495 100644
--- a/drivers/staging/rtl8188eu/include/ieee80211.h
+++ b/drivers/staging/rtl8188eu/include/ieee80211.h
@@ -199,7 +199,7 @@ struct ieee_param {
 		struct {
 			u32 len;
 			u8 reserved[32];
-			u8 data[0];
+			u8 data[];
 		} wpa_ie;
 		struct {
 			int command;
@@ -212,7 +212,7 @@ struct ieee_param {
 			u8 idx;
 			u8 seq[8]; /* sequence counter (set: RX, get: TX) */
 			u16 key_len;
-			u8 key[0];
+			u8 key[];
 		} crypt;
 #ifdef CONFIG_88EU_AP_MODE
 		struct {
@@ -224,7 +224,7 @@ struct ieee_param {
 		} add_sta;
 		struct {
 			u8	reserved[2];/* for set max_num_sta */
-			u8	buf[0];
+			u8	buf[];
 		} bcn_ie;
 #endif
 
diff --git a/drivers/staging/rtl8712/ieee80211.h b/drivers/staging/rtl8712/ieee80211.h
index 61eff7c5746b..65ceaca9b51e 100644
--- a/drivers/staging/rtl8712/ieee80211.h
+++ b/drivers/staging/rtl8712/ieee80211.h
@@ -78,7 +78,7 @@ struct ieee_param {
 		struct {
 			u32 len;
 			u8 reserved[32];
-			u8 data[0];
+			u8 data[];
 		} wpa_ie;
 		struct {
 			int command;
@@ -91,7 +91,7 @@ struct ieee_param {
 			u8 idx;
 			u8 seq[8]; /* sequence counter (set: RX, get: TX) */
 			u16 key_len;
-			u8 key[0];
+			u8 key[];
 		} crypt;
 	} u;
 };
diff --git a/drivers/staging/rtl8723bs/include/ieee80211.h b/drivers/staging/rtl8723bs/include/ieee80211.h
index 378c21595e05..89c311cd20a6 100644
--- a/drivers/staging/rtl8723bs/include/ieee80211.h
+++ b/drivers/staging/rtl8723bs/include/ieee80211.h
@@ -180,7 +180,7 @@ struct ieee_param {
 		struct {
 			u32 len;
 			u8 reserved[32];
-			u8 data[0];
+			u8 data[];
 		} wpa_ie;
 	        struct{
 			int command;
@@ -193,7 +193,7 @@ struct ieee_param {
 			u8 idx;
 			u8 seq[8]; /* sequence counter (set: RX, get: TX) */
 			u16 key_len;
-			u8 key[0];
+			u8 key[];
 		} crypt;
 		struct {
 			u16 aid;
@@ -204,7 +204,7 @@ struct ieee_param {
 		} add_sta;
 		struct {
 			u8 reserved[2];/* for set max_num_sta */
-			u8 buf[0];
+			u8 buf[];
 		} bcn_ie;
 	} u;
 };
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a6730072d13a..445597c03cd1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1101,7 +1101,7 @@ struct ieee80211_mgmt {
 			__le16 auth_transaction;
 			__le16 status_code;
 			/* possibly followed by Challenge text */
-			u8 variable[0];
+			u8 variable[];
 		} __packed auth;
 		struct {
 			__le16 reason_code;
@@ -1110,26 +1110,26 @@ struct ieee80211_mgmt {
 			__le16 capab_info;
 			__le16 listen_interval;
 			/* followed by SSID and Supported rates */
-			u8 variable[0];
+			u8 variable[];
 		} __packed assoc_req;
 		struct {
 			__le16 capab_info;
 			__le16 status_code;
 			__le16 aid;
 			/* followed by Supported rates */
-			u8 variable[0];
+			u8 variable[];
 		} __packed assoc_resp, reassoc_resp;
 		struct {
 			__le16 capab_info;
 			__le16 status_code;
-			u8 variable[0];
+			u8 variable[];
 		} __packed s1g_assoc_resp, s1g_reassoc_resp;
 		struct {
 			__le16 capab_info;
 			__le16 listen_interval;
 			u8 current_ap[ETH_ALEN];
 			/* followed by SSID and Supported rates */
-			u8 variable[0];
+			u8 variable[];
 		} __packed reassoc_req;
 		struct {
 			__le16 reason_code;
@@ -1140,11 +1140,11 @@ struct ieee80211_mgmt {
 			__le16 capab_info;
 			/* followed by some of SSID, Supported rates,
 			 * FH Params, DS Params, CF Params, IBSS Params, TIM */
-			u8 variable[0];
+			u8 variable[];
 		} __packed beacon;
 		struct {
 			/* only variable items: SSID, Supported rates */
-			u8 variable[0];
+			DECLARE_FLEX_ARRAY(u8, variable);
 		} __packed probe_req;
 		struct {
 			__le64 timestamp;
@@ -1152,7 +1152,7 @@ struct ieee80211_mgmt {
 			__le16 capab_info;
 			/* followed by some of SSID, Supported rates,
 			 * FH Params, DS Params, CF Params, IBSS Params */
-			u8 variable[0];
+			u8 variable[];
 		} __packed probe_resp;
 		struct {
 			u8 category;
@@ -1161,16 +1161,16 @@ struct ieee80211_mgmt {
 					u8 action_code;
 					u8 dialog_token;
 					u8 status_code;
-					u8 variable[0];
+					u8 variable[];
 				} __packed wme_action;
 				struct{
 					u8 action_code;
-					u8 variable[0];
+					u8 variable[];
 				} __packed chan_switch;
 				struct{
 					u8 action_code;
 					struct ieee80211_ext_chansw_ie data;
-					u8 variable[0];
+					u8 variable[];
 				} __packed ext_chan_switch;
 				struct{
 					u8 action_code;
@@ -1186,7 +1186,7 @@ struct ieee80211_mgmt {
 					__le16 timeout;
 					__le16 start_seq_num;
 					/* followed by BA Extension */
-					u8 variable[0];
+					u8 variable[];
 				} __packed addba_req;
 				struct{
 					u8 action_code;
@@ -1202,11 +1202,11 @@ struct ieee80211_mgmt {
 				} __packed delba;
 				struct {
 					u8 action_code;
-					u8 variable[0];
+					u8 variable[];
 				} __packed self_prot;
 				struct{
 					u8 action_code;
-					u8 variable[0];
+					u8 variable[];
 				} __packed mesh_action;
 				struct {
 					u8 action;
@@ -1250,7 +1250,7 @@ struct ieee80211_mgmt {
 					u8 toa[6];
 					__le16 tod_error;
 					__le16 toa_error;
-					u8 variable[0];
+					u8 variable[];
 				} __packed ftm;
 			} u;
 		} __packed action;
diff --git a/include/uapi/linux/dlm_device.h b/include/uapi/linux/dlm_device.h
index f880d2831160..e83954c69fff 100644
--- a/include/uapi/linux/dlm_device.h
+++ b/include/uapi/linux/dlm_device.h
@@ -45,13 +45,13 @@ struct dlm_lock_params {
 	void __user *bastaddr;
 	struct dlm_lksb __user *lksb;
 	char lvb[DLM_USER_LVB_LEN];
-	char name[0];
+	char name[];
 };
 
 struct dlm_lspace_params {
 	__u32 flags;
 	__u32 minor;
-	char name[0];
+	char name[];
 };
 
 struct dlm_purge_params {
-- 
2.30.2

