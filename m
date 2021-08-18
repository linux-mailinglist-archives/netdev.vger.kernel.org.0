Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41FD3EFC88
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbhHRGZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238692AbhHRGYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:24:49 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02767C0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:15 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 18so1102223pfh.9
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hNEXxevdADdpiZT9yDPKRLqHYKrfWBF19uxfyZWmCGo=;
        b=EGdWOE7bxdowrmsIKSgjZSgmQoiGO+6J6ji89xZ0Q2fptOidpphd5g7qqYXeSAgP8F
         HH8T/J8n5DYlHXumOIgXQUvZBImHN7ALjddHiJ17ignvtzPpjV4Byoe7oWxlyDXQgWZD
         c2+aZ7dLhbaQbRZXx81PpkPBbEKgxoLZ5UKNk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hNEXxevdADdpiZT9yDPKRLqHYKrfWBF19uxfyZWmCGo=;
        b=XUAJro0v16rVdPTtPmbK03O1fctKxuIUfgkMXg8kJ9rGxq2VmYFpr6cMNgcVlqTtGt
         9sCDYCNljJVDDkx4UJNwIZt2H9i+mi3iujFkpXav/TkZAlCEavRdE4O8WX70Bn8/J1yT
         GIU/ZgKzweFL73e54QMZIgffRoxlcujK12KkKQYy0Yc1U4M/BIm40+Ep+bkGVn3rLOQV
         0vVQhwkCkR8F+wsVm604YL8v1+62/S2RpgT3yyN/C5/g/b6+VzIdiaRf2uKlHyNdWc4L
         sKFnuQh5oew+f6hyJDlOsWAf2IdFm1VB+MlSC1yBB/ZMH9F6GB3nATzprUStWKCFaDb4
         1b8w==
X-Gm-Message-State: AOAM532IXWBA5de5wCE+J6HUDop5MdUvIJ3+h2w8lb1kpSFLVLSvVYP/
        1xv/91A9xpCz6Iqg9UhQFo4InQ==
X-Google-Smtp-Source: ABdhPJzEZLL4+vuxKf2KA80vRRNe/aKYgSEeAOIcbSklQP4uG9CeHnUETuB9bUeNsXUisBI4mxHrBA==
X-Received: by 2002:a65:6658:: with SMTP id z24mr7321502pgv.266.1629267854650;
        Tue, 17 Aug 2021 23:24:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v9sm5393520pga.82.2021.08.17.23.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:24:12 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 55/63] HID: roccat: Use struct_group() to zero kone_mouse_event
Date:   Tue, 17 Aug 2021 23:05:25 -0700
Message-Id: <20210818060533.3569517-56-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1908; h=from:subject; bh=1pufhTOQ+Ev1TBqsKxncMFoRA1ZRswld+5UcgY3UHPc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMqezgIdICqUvusV3uxfFgc/NzjoDMPzoTPLXKQ ysx/Q+WJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjKgAKCRCJcvTf3G3AJvMhD/ 4/FvXFOoXTIkumS1QqMpAFhaJGCKF+0RDx/z48DGYo98kCwWG6ybzb+3Sly47Z+VgrSp0nI5xp/nwa 7vzRFjBAI8F/fZVbUlI8Z/Fya+aZbPEeiEK947R3H8Wbap6uVAex0YjyWhhrJ5ZvwN2gBayJJ1WAXz +0fz1YMH8bcbhmSMSRON2ZGR1UjjBuaTH+o0ighQljGy5YLUHHZ+P4xNS0whZ8d+THVIEhrrdzHdRV xQ+rSGFdrgJR7xYVHqTNDyySccjRR12fCgsnFgzx2wmvqD6usQbAtioyZ5ZCTcNXNfyyvHgd++uCyK e638UGzfpOzM5vUWRjmLl1KeEBbobuCg3sgk1AQzR2mUpn6cvbWbZbOyGlGZtTdTn7wCe/qfq120Ud zfBKERaOR0vpEYpiRESonq/qBjud3tRwJ0H/FhwsbPbp2lo15qfYimJ41SEC1abj3Da1Xu61TlMqEd S5Rzg+maFwNcx3sFBdUId31vsspRp/LAtiMPvI3MalLGcTxm9Gdf8i9hEI2yM8v6QUVUqBl/F6N1uW 0dr4/U6A89Pj+zJUWKnGqTw3EZAQEgK5Lbi/njYrrq3JeohlG7jtmoxQDLp3fMw23TORKszxjv3y76 kDqBN4o2faONCRYDcPk3N/ArWnW2NiFPXTb3nBBeYGgetTCuosxxzdiUWWLg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Add struct_group() to mark region of struct kone_mouse_event that should
be initialized to zero.

Cc: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/hid/hid-roccat-kone.c |  2 +-
 drivers/hid/hid-roccat-kone.h | 12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 1ca64481145e..ea17abc7ad52 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -857,7 +857,7 @@ static int kone_raw_event(struct hid_device *hdev, struct hid_report *report,
 		memcpy(&kone->last_mouse_event, event,
 				sizeof(struct kone_mouse_event));
 	else
-		memset(&event->tilt, 0, 5);
+		memset(&event->wipe, 0, sizeof(event->wipe));
 
 	kone_keep_values_up_to_date(kone, event);
 
diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
index 4a1a9cb76b08..65c800e3addc 100644
--- a/drivers/hid/hid-roccat-kone.h
+++ b/drivers/hid/hid-roccat-kone.h
@@ -152,11 +152,13 @@ struct kone_mouse_event {
 	uint16_t x;
 	uint16_t y;
 	uint8_t wheel; /* up = 1, down = -1 */
-	uint8_t tilt; /* right = 1, left = -1 */
-	uint8_t unknown;
-	uint8_t event;
-	uint8_t value; /* press = 0, release = 1 */
-	uint8_t macro_key; /* 0 to 8 */
+	struct_group(wipe,
+		uint8_t tilt; /* right = 1, left = -1 */
+		uint8_t unknown;
+		uint8_t event;
+		uint8_t value; /* press = 0, release = 1 */
+		uint8_t macro_key; /* 0 to 8 */
+	);
 } __attribute__ ((__packed__));
 
 enum kone_mouse_events {
-- 
2.30.2

