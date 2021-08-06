Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5103E301E
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 22:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244573AbhHFUJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 16:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244441AbhHFUJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 16:09:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079F7C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 13:09:02 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so19580940pjb.2
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 13:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n6L9lQWvGLp2RmRr83sqFXDKRaXPPCi+3uhrZ6kADNA=;
        b=nWIt5g3GXVnW5z2AYO8uYLJsBM6J19V+JIVdl7YLTXZFqY7W9ei9/SgJ1UmRs6mpSt
         Sgf7eH9PcaBa1aXMpzUtoN8DPYTYyMKbZdxMdXYTGNWSnoGW6Y5HgZuwuV739iqL14gA
         jgS2A68AoBOi9b0r8dz5V8+OUWGDinrYH2T2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n6L9lQWvGLp2RmRr83sqFXDKRaXPPCi+3uhrZ6kADNA=;
        b=g8YF7Lh9MvymG/l6gDoaQ9BKNdwn4tC23rX/+sYvpzXJyXLV+3D4DnkKd52yKpSTfS
         xxaDmvAJEZuuQZf9tKpsm+G2ERoHcOarO55LDp4xznophaFL4h9E9mBy1TNCtuKek7IC
         M7Mk6gxj0tqki/YumFuXLsuDCywVktGlW0MN2xkteMj3K0EtPI1c0w8mv8eRg6Banmgy
         s7e49jZOfdz9JKUSxtWBON3qRT/sJoCSxA0pxtggyWrEvBC/pMtBSdeSgjlpP8eE2sB0
         qboXns+mQQg4wWH73f8zZrKyy46l0xgVJjTuVzSo9IAOBzPyWd98hmXiHYLTaSWXkDEI
         u+4g==
X-Gm-Message-State: AOAM531JD5aV0BcmLQJOirlpLEsgKtWpv3n2CotHuLUne+uBTHCz1u1O
        UzIdd+cSHghC5CpEUix7ydYF+A==
X-Google-Smtp-Source: ABdhPJyaXk/keHXFRBUqFrft8A94/ur96J4Pv6Rk2fUUwU/ShuzzjV/o1/H164HklzW6ysO8GRYZvQ==
X-Received: by 2002:a17:902:7b8b:b029:12b:8d3e:70e7 with SMTP id w11-20020a1709027b8bb029012b8d3e70e7mr3840249pll.76.1628280541543;
        Fri, 06 Aug 2021 13:09:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b20sm10911854pfl.9.2021.08.06.13.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 13:09:01 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] ipw2x00: Avoid field-overflowing memcpy()
Date:   Fri,  6 Aug 2021 13:08:55 -0700
Message-Id: <20210806200855.2870554-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4665; h=from:subject; bh=6caGhOOY446DlpmdSUBQVYbe7alelvqjsReWU0FV/Ck=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhDZbWlqznbRsXo6uyVHMPyqNKwaw98x0jc7wCkSGo 4cEIMHSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQ2W1gAKCRCJcvTf3G3AJi8lD/ 9jkPT4xmisHW9IgfwnETPhxevmZe48HyNSPt0ogmaNIQR3nP17BoJqLqbh1kgsgpeDUDDsDy1ua+mO gcrIcZOgYrYrht+RcOiVxnah/a5qQ42tAEaG6f079GUNRdCRUStdeSpRr+P/jfg24QD7+o4gkPsveA WNEwu5IwBUOg6BZ5NR9Umi1zzuf4ApLASOjiQd2q7bnbD+5mGUX3hN7r8dIyp+vrW3+fidwZrgB65n E7eYABTLvNzW1B9QaiGYO0GHFY6a4by6nBT7vzxAxnziKpACP9ByPGpf4WbAwzihh2Odhf5BDtdpD5 uaaJpEJhHMrUgFGvB8Mo0CSqIeKn9owfuOQdo8Rq5KfMHyygDQaD6cVt6uijgZBvA4P1tt9pVzOd9Q f232tFq+SFm0S4xmo+WIs/+YS9wFU66rn/33cWapsMrl297Kf/HHTlQPHz6fKMfbyijX9yqJVcVzNQ HygM9SfHUjQP9RqhiuX4DK9oXycQ6LY3iuV+e4A40NGlSoA5RDiJm8eFZEOPtDbviGGvo5YdQCpoxP aguORZY7LbjDEoI6XbdHLAPO/Q9aWARrUEXlleSGt4kFXPSmXNGB22KWAx2KdEftHEFbdxkHuy+xP/ qUd2YeQXVndotuUf4y6ZzFm854RDTRIRgnzTgcBmD4u8iG+0t1d754v5DEnQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

libipw_read_qos_param_element() copies a struct libipw_info_element
into a struct libipw_qos_information_element, but is actually wanting to
copy into the larger struct libipw_qos_parameter_info (the contents of
ac_params_record[] is later examined). Refactor the routine to perform
centralized checks, and copy the entire contents directly (since the id
and len members match the elementID and length members):

struct libipw_info_element {
        u8 id;
        u8 len;
        u8 data[];
} __packed;

struct libipw_qos_information_element {
        u8 elementID;
        u8 length;
        u8 qui[QOS_OUI_LEN];
        u8 qui_type;
        u8 qui_subtype;
        u8 version;
        u8 ac_info;
} __packed;

struct libipw_qos_parameter_info {
        struct libipw_qos_information_element info_element;
        u8 reserved;
        struct libipw_qos_ac_parameter ac_params_record[QOS_QUEUE_NUM];
} __packed;

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../net/wireless/intel/ipw2x00/libipw_rx.c    | 56 ++++++-------------
 1 file changed, 17 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index 5a2a723e480b..7cda31e403bd 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -927,7 +927,8 @@ static u8 qos_oui[QOS_OUI_LEN] = { 0x00, 0x50, 0xF2 };
 static int libipw_verify_qos_info(struct libipw_qos_information_element
 				     *info_element, int sub_type)
 {
-
+	if (info_element->elementID != QOS_ELEMENT_ID)
+		return -1;
 	if (info_element->qui_subtype != sub_type)
 		return -1;
 	if (memcmp(info_element->qui, qos_oui, QOS_OUI_LEN))
@@ -943,57 +944,34 @@ static int libipw_verify_qos_info(struct libipw_qos_information_element
 /*
  * Parse a QoS parameter element
  */
-static int libipw_read_qos_param_element(struct libipw_qos_parameter_info
-					    *element_param, struct libipw_info_element
-					    *info_element)
+static int libipw_read_qos_param_element(
+			struct libipw_qos_parameter_info *element_param,
+			struct libipw_info_element *info_element)
 {
-	int ret = 0;
-	u16 size = sizeof(struct libipw_qos_parameter_info) - 2;
+	size_t size = sizeof(*element_param);
 
-	if ((info_element == NULL) || (element_param == NULL))
+	if (!element_param || !info_element || info_element->len != size - 2)
 		return -1;
 
-	if (info_element->id == QOS_ELEMENT_ID && info_element->len == size) {
-		memcpy(element_param->info_element.qui, info_element->data,
-		       info_element->len);
-		element_param->info_element.elementID = info_element->id;
-		element_param->info_element.length = info_element->len;
-	} else
-		ret = -1;
-	if (ret == 0)
-		ret = libipw_verify_qos_info(&element_param->info_element,
-						QOS_OUI_PARAM_SUB_TYPE);
-	return ret;
+	memcpy(element_param, info_element, size);
+	return libipw_verify_qos_info(&element_param->info_element,
+				      QOS_OUI_PARAM_SUB_TYPE);
 }
 
 /*
  * Parse a QoS information element
  */
-static int libipw_read_qos_info_element(struct
-					   libipw_qos_information_element
-					   *element_info, struct libipw_info_element
-					   *info_element)
+static int libipw_read_qos_info_element(
+			struct libipw_qos_information_element *element_info,
+			struct libipw_info_element *info_element)
 {
-	int ret = 0;
-	u16 size = sizeof(struct libipw_qos_information_element) - 2;
+	size_t size = sizeof(struct libipw_qos_information_element) - 2;
 
-	if (element_info == NULL)
+	if (!element_info || info_element || info_element->len != size - 2)
 		return -1;
-	if (info_element == NULL)
-		return -1;
-
-	if ((info_element->id == QOS_ELEMENT_ID) && (info_element->len == size)) {
-		memcpy(element_info->qui, info_element->data,
-		       info_element->len);
-		element_info->elementID = info_element->id;
-		element_info->length = info_element->len;
-	} else
-		ret = -1;
 
-	if (ret == 0)
-		ret = libipw_verify_qos_info(element_info,
-						QOS_OUI_INFO_SUB_TYPE);
-	return ret;
+	memcpy(element_info, info_element, size);
+	return libipw_verify_qos_info(element_info, QOS_OUI_INFO_SUB_TYPE);
 }
 
 /*
-- 
2.30.2

