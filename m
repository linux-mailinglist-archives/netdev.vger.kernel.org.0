Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00B83D8018
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhG0VAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbhG0U7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14949C061799
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b6so1772419pji.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3PAzWLU246y1XAJJGWj+zmXxgq3vu+t3uT7F7ts2iM=;
        b=IYhfsWGlsw3iSzV/PshzqWyl6YBx5L4bzzAy1O/DivhJOOn5XnSEfDfbmKq3pZ+0Vk
         uh7GiUZL5niXHON0wQ0k5rOANeYvbqA7jpbTdKzVDWyXzIPUHuwdFvuQCZlNfXL/s5xy
         EIQ0LWDe7jO3cVQe1/FSgbqBokHxmE/gnetDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3PAzWLU246y1XAJJGWj+zmXxgq3vu+t3uT7F7ts2iM=;
        b=t1j7fL0HQhR4CqW31KLZA9Ga5dbJ+nKEOVF1+cisRa8xFrs+9JMYney+2YknO024If
         3XZUCD2sXL1y7EtrxgLhMuxV7BzHSbDZ8aL295b7H/aKtfVHlYlBz14RfdrcBr6L6LQP
         /i40+AqZ7UTvqQv13KSy78XD4JRKqWZV/EuFPH+aG3JNy2apqGYMOKzkGcylfIpik6qD
         fmxuJnEgoXruI4LaYAlX0GOlyaBi3sSlrZk8mF5ZUl5e1KTguzMzEgYuV9swIT4hc8M+
         HcWZf3JwrS1g6DoqhPLSfymEVHCqRS18kX6g7dFRdAikZxRDPDH2WMwLDi/cLeY6GFet
         hmBQ==
X-Gm-Message-State: AOAM533RKrnIEdiG+ql4qrDQcm8aUfpmjibCjWZ8Pv9fJpS9MMbrCGLm
        d3rgri/K8k+vX/6mg9QjH1OF3w==
X-Google-Smtp-Source: ABdhPJztdkoXWjXT5QD/exKWw9kw2lZC8KEgnSRSe5hUXoJqgzkXvN7Kc2Da1tooBWFUMhMM+5Yl+Q==
X-Received: by 2002:a63:4206:: with SMTP id p6mr25847081pga.285.1627419547538;
        Tue, 27 Jul 2021 13:59:07 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id nm19sm3750853pjb.27.2021.07.27.13.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:05 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 08/64] staging: rtl8192u: Use struct_group() for memcpy() region
Date:   Tue, 27 Jul 2021 13:57:59 -0700
Message-Id: <20210727205855.411487-9-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4950; h=from:subject; bh=Auxw1wcSuXLG5PZpqLVm+ToYm1BZgRegEEtY4+3pHw8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOBQir91mVsM70reKpFOtfagOnSNOBMkJbr7LeF cLNYV1eJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzgQAKCRCJcvTf3G3AJo2aD/ 4h/gem/XLyVOoZV8fQb32viUj7rAyg4aQwHNkuWJUlBL82B2X54xsC7DFKlCa8N29O8H+qPnwHWT4K 6ICv9SY/cbNJmcNDaVRxa1zStMzYOl04p6xD9WCnFFjK4B+q9LeGI2YR5rnKXwMRVRN62lGGb2tbDG n+B7S4A3Lzj7gnCvw8H/Jh9jykK5MtMYCK3XaA8cM136SS6m+/Mz2jQkeWtGxivZP3JfUY99slNEkG 0LZ6JrK7U2HhCqW+GBrJFottbbgKHmwow4xCoIvuKHVrRe+pSDHtQkB9J3CO3kRk/B4+UUgR29S3N1 WGzHQkQOdCogIIKKhl+dGtRJkzv1E6H3AfsfHn9mRX+rlRVMuWdY7OOtWt09v9kOhJi9TJuYsCUhXd bb2iFWqiDbfnzl1cMyIJwIcRmKPa8iWe3+q44A9MO1491pridbSlGKpf8eOQJKQrrofq4o2cm2VKmy VObV/m/b4dpWYSDq+ecjCOAwd9Q2lNy5lWiCgPg/UTP9q/ZJuT+DhU92dfstVyX0UZsLQY2XjsDTcY +kcirjK4bujmk/nhABsxK1FigYwqICkmpUKU2Nw2NqvaMQuz7GFb/MwXE0F6PrttZzKLnIcWQt2RMg S0RnPStAbsoJy+Iytt3EPyIdRveCUUfgivtpUg6QthiMPmFTasWv4patQHMQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() around members addr1, addr2, and addr3 in struct
rtl_80211_hdr_4addr, and members qui, qui_type, qui_subtype, version,
and ac_info in struct ieee80211_qos_information_element, so they can be
referenced together. This will allow memcpy() and sizeof() to more easily
reason about sizes, improve readability, and avoid future warnings about
writing beyond the end of addr1 and qui. Additionally replace zero sized
arrays with flexible arrays in struct ieee_param.

"pahole" shows no size nor member offset changes to struct
rtl_80211_hdr_4addr nor struct ieee80211_qos_information_element. "objdump
-d" shows no meaningful object code changes (i.e. only source line number
induced differences and optimizations).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../staging/rtl8192u/ieee80211/ieee80211.h    | 24 +++++++++++--------
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c |  3 ++-
 .../staging/rtl8192u/ieee80211/ieee80211_rx.c |  8 +++----
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index 7903c777a417..6ae8d7504558 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -303,7 +303,7 @@ struct ieee_param {
 		struct {
 			u32 len;
 			u8 reserved[32];
-			u8 data[0];
+			u8 data[];
 		} wpa_ie;
 		struct{
 			int command;
@@ -316,7 +316,7 @@ struct ieee_param {
 			u8 idx;
 			u8 seq[8]; /* sequence counter (set: RX, get: TX) */
 			u16 key_len;
-			u8 key[0];
+			u8 key[];
 		} crypt;
 	} u;
 };
@@ -917,9 +917,11 @@ struct rtl_80211_hdr_3addr {
 struct rtl_80211_hdr_4addr {
 	__le16 frame_ctl;
 	__le16 duration_id;
-	u8 addr1[ETH_ALEN];
-	u8 addr2[ETH_ALEN];
-	u8 addr3[ETH_ALEN];
+	struct_group(addrs,
+		u8 addr1[ETH_ALEN];
+		u8 addr2[ETH_ALEN];
+		u8 addr3[ETH_ALEN];
+	);
 	__le16 seq_ctl;
 	u8 addr4[ETH_ALEN];
 	u8 payload[];
@@ -1100,11 +1102,13 @@ typedef union _frameqos {
 struct ieee80211_qos_information_element {
 	u8 elementID;
 	u8 length;
-	u8 qui[QOS_OUI_LEN];
-	u8 qui_type;
-	u8 qui_subtype;
-	u8 version;
-	u8 ac_info;
+	struct_group(data,
+		u8 qui[QOS_OUI_LEN];
+		u8 qui_type;
+		u8 qui_subtype;
+		u8 version;
+		u8 ac_info;
+	);
 } __packed;
 
 struct ieee80211_qos_ac_parameter {
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
index c241cf484023..61f9a189c90c 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
@@ -141,7 +141,8 @@ static int ccmp_init_iv_and_aad(struct rtl_80211_hdr_4addr *hdr,
 	pos = (u8 *)hdr;
 	aad[0] = pos[0] & 0x8f;
 	aad[1] = pos[1] & 0xc7;
-	memcpy(aad + 2, hdr->addr1, 3 * ETH_ALEN);
+	BUILD_BUG_ON(sizeof(hdr->addrs) != 3 * ETH_ALEN);
+	memcpy(aad + 2, &hdr->addrs, 3 * ETH_ALEN);
 	pos = (u8 *)&hdr->seq_ctl;
 	aad[20] = pos[0] & 0x0f;
 	aad[21] = 0; /* all bits masked */
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index b0e01ee65f7f..d5557ee0a3b7 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -1332,13 +1332,13 @@ static int ieee80211_read_qos_param_element(struct ieee80211_qos_parameter_info
 					    *info_element)
 {
 	int ret = 0;
-	u16 size = sizeof(struct ieee80211_qos_parameter_info) - 2;
+	u16 size = sizeof(element_param->info_element.data);
 
 	if (!info_element || !element_param)
 		return -1;
 
 	if (info_element->id == QOS_ELEMENT_ID && info_element->len == size) {
-		memcpy(element_param->info_element.qui, info_element->data,
+		memcpy(&element_param->info_element.data, info_element->data,
 		       info_element->len);
 		element_param->info_element.elementID = info_element->id;
 		element_param->info_element.length = info_element->len;
@@ -1358,7 +1358,7 @@ static int ieee80211_read_qos_info_element(
 		struct ieee80211_info_element *info_element)
 {
 	int ret = 0;
-	u16 size = sizeof(struct ieee80211_qos_information_element) - 2;
+	u16 size = sizeof(element_info->data);
 
 	if (!element_info)
 		return -1;
@@ -1366,7 +1366,7 @@ static int ieee80211_read_qos_info_element(
 		return -1;
 
 	if ((info_element->id == QOS_ELEMENT_ID) && (info_element->len == size)) {
-		memcpy(element_info->qui, info_element->data,
+		memcpy(&element_info->data, info_element->data,
 		       info_element->len);
 		element_info->elementID = info_element->id;
 		element_info->length = info_element->len;
-- 
2.30.2

