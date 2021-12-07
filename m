Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6644546B2F5
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 07:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbhLGGhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 01:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236878AbhLGGhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 01:37:47 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD11C061359
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 22:34:17 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b11so8703575pld.12
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 22:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Emt2JkswUzgDqf8sxIuCj+2Zu8uEYoGq5UFr0+ay5HA=;
        b=WbU7Bo1bBi+0M30NcQocYYFYvWJbyD2SKlgPg8opHPZE5xdf8ckwrc923/DyVSkxxz
         wiHVA7Rl9qycdT4RA/ky6RYmzL57DkvsCI5LZjz5hs/uVFs2gDhpQo6KrhmTjozicHLe
         iVaL/a87TfTZhcO+uoawWSqHwz0nXd84ny6wQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Emt2JkswUzgDqf8sxIuCj+2Zu8uEYoGq5UFr0+ay5HA=;
        b=N9L8wRSvtqyO6OZWg/DEKyUY52NrdUaC/Fwqfviej4RbUMFT5cUdCyf/NOBCA/GNxw
         Zf+mm/QENwMLjsVvJ6q4Qzpe4MZofui1F7ekwSL27soK4cxPlVkuv9zyt4JRWwoIlN+d
         rsa57QGdOkWRl7yi9GwvYsiKonY6wjJPxpQJeV4Sgsv06FOoOMhssx/sDkFT1mr8Qx6D
         xZ6ru922C7QxWpdAIVc8qPYXoc7JfRsdHKfH5hVyLqwIdxXXWNV6UUuiB7CmQqGauPAE
         arbO/f6ou9KwwBVAUwOJquBPHEjSZHFAHBjXgGbGIdeatcrF+Pcru/ULzZqSJO+dQ4r5
         Hh6w==
X-Gm-Message-State: AOAM532Rq/Hg5XzF+Fm4masUPDsXNfKhk6qSqNC551L+Ke3Wfv6wnEgN
        xiuyMvQMWz+XO8Gx0y9BdnjnXQ==
X-Google-Smtp-Source: ABdhPJyiiwA2wiGhlQqwZM26X0WYC07uDsFWVWP0yM+rE9SWJ4ijWo4/kPswqvZNJ0M70dYFiLBURQ==
X-Received: by 2002:a17:903:11cd:b0:143:d220:fdd8 with SMTP id q13-20020a17090311cd00b00143d220fdd8mr48711514plh.79.1638858856978;
        Mon, 06 Dec 2021 22:34:16 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e7sm9120984pfv.156.2021.12.06.22.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 22:34:16 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Andreas Noever <andreas.noever@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] thunderbolt: xdomain: Avoid potential stack OOB read
Date:   Mon,  6 Dec 2021 22:34:13 -0800
Message-Id: <20211207063413.2698788-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4387; h=from:subject; bh=BIm58zF4mV3fKF2Ss4EiT2c/TJ3cCjC0s1vkTlp0s78=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhrwBl6bk7nUxAvxrQ05Ute7jLqPxYkReEtXtbE01y yQr7vwuJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYa8AZQAKCRCJcvTf3G3AJt85EA CZ6aWdb8Vi5rtu0wU4tbc5S5o1pxM40CH1bQQPMrwCGjpjH0T5QJRr2+YdSlOKFsbPWtbPA9ZCEiH0 rL0iuv6zLHJP+5C0HBDpd7PCM44cgKJ5/lzldXijI1gPJLfsJT0LLhFgnG7sdQG7XmyW+fxagC2ang Jd4Gu379X/vg5xDc6Mw3cbSKOYF7yA16LFAujWo2oBwGyYZV3g2iH1U2cW7Y9pfom+iVNyDpTG9fRr O1/mY2kPNh2qPrTtDkP5boz1L8AvwRpIs00yDdj2iKRGYb/etDreuuJetitWWsMGaPyaOdenaet4SC qZWxzWMe7nvxk/OUdkRwFpPUCCnxpO+RtE+EsI9K4fMHASEBnAo0cTbTfW2UxjhUkpKCBTgA2oYNBq vDsCY9x2SHZvtIjsUkZ05CEWysReRqtx2m/uI1xlkALWvtQ5nIra2aQuG2Lzgd01rFyBt1T9aQ+kud QHaZqP9torrBTIoOKsAH58k6ogl9HYd30p7Cu1B37ez6V+CXg32yEQV8Rhe+jATuXI+tEwnSQTvuLy jCZqnisF/79yqyTCLU8eWPbDaPsCaK2YlvmZmXynyb1VBu0x11KnHCwFjsaEoKIh7IadY6ibTQc06C TTniJcFECZx+greYyKuAgR1QVjHEozYUPdt9geTnc2cy8VJG+JvSTeEUt1Lg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tb_xdp_properties_changed_request() was calling tb_xdp_handle_error() with
a struct tb_xdp_properties_changed_response on the stack, which does not
have the "error" field present when cast to struct tb_xdp_error_response.
This was detected when building with -Warray-bounds:

drivers/thunderbolt/xdomain.c: In function 'tb_xdomain_properties_changed':
drivers/thunderbolt/xdomain.c:226:22: error: array subscript 'const struct tb_xdp_error_response[0]' is partly outside array bounds of 'struct tb_xdp_properties_changed_response[1]' [-Werror=array-bounds]
  226 |         switch (error->error) {
      |                 ~~~~~^~~~~~~
drivers/thunderbolt/xdomain.c:448:51: note: while referencing 'res'
  448 |         struct tb_xdp_properties_changed_response res;
      |                                                   ^~~

Add union containing struct tb_xdp_error_response to structures passed
to tb_xdp_handle_error(), so that the "error" field will be present.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/thunderbolt/tb_msgs.h | 47 ++++++++++++++++++++++-------------
 drivers/thunderbolt/xdomain.c | 16 +++++-------
 2 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/thunderbolt/tb_msgs.h b/drivers/thunderbolt/tb_msgs.h
index bcabfcb2fd03..fe1afa44c56d 100644
--- a/drivers/thunderbolt/tb_msgs.h
+++ b/drivers/thunderbolt/tb_msgs.h
@@ -535,15 +535,25 @@ struct tb_xdp_header {
 	u32 type;
 };
 
+struct tb_xdp_error_response {
+	struct tb_xdp_header hdr;
+	u32 error;
+};
+
 struct tb_xdp_uuid {
 	struct tb_xdp_header hdr;
 };
 
 struct tb_xdp_uuid_response {
-	struct tb_xdp_header hdr;
-	uuid_t src_uuid;
-	u32 src_route_hi;
-	u32 src_route_lo;
+	union {
+		struct tb_xdp_error_response err;
+		struct {
+			struct tb_xdp_header hdr;
+			uuid_t src_uuid;
+			u32 src_route_hi;
+			u32 src_route_lo;
+		};
+	};
 };
 
 struct tb_xdp_properties {
@@ -555,13 +565,18 @@ struct tb_xdp_properties {
 };
 
 struct tb_xdp_properties_response {
-	struct tb_xdp_header hdr;
-	uuid_t src_uuid;
-	uuid_t dst_uuid;
-	u16 offset;
-	u16 data_length;
-	u32 generation;
-	u32 data[0];
+	union {
+		struct tb_xdp_error_response err;
+		struct {
+			struct tb_xdp_header hdr;
+			uuid_t src_uuid;
+			uuid_t dst_uuid;
+			u16 offset;
+			u16 data_length;
+			u32 generation;
+			u32 data[];
+		};
+	};
 };
 
 /*
@@ -580,7 +595,10 @@ struct tb_xdp_properties_changed {
 };
 
 struct tb_xdp_properties_changed_response {
-	struct tb_xdp_header hdr;
+	union {
+		struct tb_xdp_error_response err;
+		struct tb_xdp_header hdr;
+	};
 };
 
 enum tb_xdp_error {
@@ -591,9 +609,4 @@ enum tb_xdp_error {
 	ERROR_NOT_READY,
 };
 
-struct tb_xdp_error_response {
-	struct tb_xdp_header hdr;
-	u32 error;
-};
-
 #endif
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index eff32499610f..01d6b724ca51 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -214,16 +214,12 @@ static inline void tb_xdp_fill_header(struct tb_xdp_header *hdr, u64 route,
 	memcpy(&hdr->uuid, &tb_xdp_uuid, sizeof(tb_xdp_uuid));
 }
 
-static int tb_xdp_handle_error(const struct tb_xdp_header *hdr)
+static int tb_xdp_handle_error(const struct tb_xdp_error_response *res)
 {
-	const struct tb_xdp_error_response *error;
-
-	if (hdr->type != ERROR_RESPONSE)
+	if (res->hdr.type != ERROR_RESPONSE)
 		return 0;
 
-	error = (const struct tb_xdp_error_response *)hdr;
-
-	switch (error->error) {
+	switch (res->error) {
 	case ERROR_UNKNOWN_PACKET:
 	case ERROR_UNKNOWN_DOMAIN:
 		return -EIO;
@@ -257,7 +253,7 @@ static int tb_xdp_uuid_request(struct tb_ctl *ctl, u64 route, int retry,
 	if (ret)
 		return ret;
 
-	ret = tb_xdp_handle_error(&res.hdr);
+	ret = tb_xdp_handle_error(&res.err);
 	if (ret)
 		return ret;
 
@@ -329,7 +325,7 @@ static int tb_xdp_properties_request(struct tb_ctl *ctl, u64 route,
 		if (ret)
 			goto err;
 
-		ret = tb_xdp_handle_error(&res->hdr);
+		ret = tb_xdp_handle_error(&res->err);
 		if (ret)
 			goto err;
 
@@ -462,7 +458,7 @@ static int tb_xdp_properties_changed_request(struct tb_ctl *ctl, u64 route,
 	if (ret)
 		return ret;
 
-	return tb_xdp_handle_error(&res.hdr);
+	return tb_xdp_handle_error(&res.err);
 }
 
 static int
-- 
2.30.2

