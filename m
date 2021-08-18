Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177BC3EFC85
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240443AbhHRGZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238818AbhHRGYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:24:51 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0B9C0612A6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:16 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id o2so1186295pgr.9
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k/wMqZhYPv/ednyUtGVLuOyBDdwE/DxTOa1GSHOTwQw=;
        b=h1vqsKCq3LguZasBrpDaxLMbE54XIdT056wn+53xSVHzW2Ewxb/OwMHrme5OgTt4Jz
         Rn6+Nw/UlSdQJuXyyuSYWqcsqPV0JLgcmYGV56fwQSHpm2I+9h+ZIKfx2co1C0VimpZf
         7dKUtyu84DuqlRQ87BuDsdzr8aHRxeo0v95wg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k/wMqZhYPv/ednyUtGVLuOyBDdwE/DxTOa1GSHOTwQw=;
        b=kIRIMdcz1HRrPwyWaSGviOJFyxkzPPDh47n9qVOtppON31H6iS9flZ2FEqPrm98Axd
         m0QVVfLjVHeu+o4xAOs9D+LYzmFVJsAJEKrS5xtJq1ocn8lUebBAkP0uGwCVRHeLs/DE
         bP0ThaL4mPRAMgHWt37UOuZd9x7ZH1TgnQnTAGG1CjD+tMLOCCGVdfbtRrergVMYifW4
         USHheQr+gXtSQWpsgPspjHxInySb0Sv8RKxgNodBdVz2YLMhuZrWilnNiAD5PS3zIe16
         eN9Ybl7paVjIxvbsnRSkvGxgEFKU7fz8EN0bhh8/7wBUcz8HSxeHLyMLq6ybzkwfQiGy
         SGwA==
X-Gm-Message-State: AOAM530l2HZKoUGI4qXqeBhE1b/MTzwH/AfiIZCI2rjo7oTkT8+Q5XaU
        cjn616Ih2qV94yU2gFTSLxN7Kw==
X-Google-Smtp-Source: ABdhPJwamERI+b3fB1OT2OBb/Oo32Bs69oRVEvsPMoSjLvciwc2SdyfJNwL8U1PKVMBNffysj5z0og==
X-Received: by 2002:a62:1a03:0:b029:3e0:30aa:5172 with SMTP id a3-20020a621a030000b02903e030aa5172mr7615458pfa.69.1629267856113;
        Tue, 17 Aug 2021 23:24:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p17sm3873060pjg.54.2021.08.17.23.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:24:14 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, Jiri Kosina <jikos@kernel.org>,
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
Subject: [PATCH v2 22/63] HID: cp2112: Use struct_group() for memcpy() region
Date:   Tue, 17 Aug 2021 23:04:52 -0700
Message-Id: <20210818060533.3569517-23-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2247; h=from:subject; bh=/f7Uu4v/C7D/CabqYQdkLwI9T63RoTYSlGbQfk4by30=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMi/T6L3PaIJG69XO7seVV8nfPKvnO/RnRfY1YP eqF5TIqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjIgAKCRCJcvTf3G3AJiqND/ 4o9z0rLLj4NSz3P+N5dEODqZN+0JFe68SJEpcnI/yqBAJ991CZgBW3P4hegMy7LP416vg4a8VXWuZf PdkwM1HtKI3bOIJmJ/oXuHc0Cd8E1/i9IdhWeZkwnk4ATdl52t6KiufRupzJ474wQ6gIOIfDj0KQ0R kyIFkhVeoA2Kr7NRe3qo9ChOoz9iHtgIp5yRu2OL9iopUm7HJMVli+T8Rkjfs1WdXgucAW17dFCaQf jscROMyLQGnCUMePS1yvQgUiFCFi1PlQtlLu+P7JTZudtLxFONjQCqvINDVVTB7e+TdY6/uBtgZzeK irTF7jSjV82n7MLfw4dCwSr5O2rrLJUaRZRfu6EiE2apChq5mvhSkWogW11l43Du1tv0vSY8wCE7XA sqKXkssO6OXrNOfPC9zrrUYQOnTwssqdo4orsoUV57XBYhxldJWv/VtIL/gNK2X1AMSQ2l2j8jVWtm /ZmkiVPYHo1cAbq84GdiW7UhznMM4bt9KCq8jxr7jM/YO6AI8nO2vNY/g02E3s1LVpfe2iqQHiaXcU HzwXGWuEQSSIRd009WPzQD3vPRqgiHua6vhSwtjUVgJ7mB06uFmWn0gFEj2FoGkgl1YLXKQ9crqUgL wCJdGavuSKwTapzMz2igVrV/qHEivZbe8115YGPQPbagYEoCWw+9D4gRcRag==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct cp2112_string_report around members report,
length, type, and string, so they can be referenced together. This will
allow memcpy() and sizeof() to more easily reason about sizes, improve
readability, and avoid future warnings about writing beyond the end of
report.

"pahole" shows no size nor member offset changes to struct
cp2112_string_report.  "objdump -d" shows no meaningful object
code changes (i.e. only source line number induced differences.)

Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/hid/hid-cp2112.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 477baa30889c..ece147d1a278 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -129,10 +129,12 @@ struct cp2112_xfer_status_report {
 
 struct cp2112_string_report {
 	u8 dummy;		/* force .string to be aligned */
-	u8 report;		/* CP2112_*_STRING */
-	u8 length;		/* length in bytes of everyting after .report */
-	u8 type;		/* USB_DT_STRING */
-	wchar_t string[30];	/* UTF16_LITTLE_ENDIAN string */
+	struct_group_attr(contents, __packed,
+		u8 report;		/* CP2112_*_STRING */
+		u8 length;		/* length in bytes of everything after .report */
+		u8 type;		/* USB_DT_STRING */
+		wchar_t string[30];	/* UTF16_LITTLE_ENDIAN string */
+	);
 } __packed;
 
 /* Number of times to request transfer status before giving up waiting for a
@@ -986,8 +988,8 @@ static ssize_t pstr_show(struct device *kdev,
 	u8 length;
 	int ret;
 
-	ret = cp2112_hid_get(hdev, attr->report, &report.report,
-			     sizeof(report) - 1, HID_FEATURE_REPORT);
+	ret = cp2112_hid_get(hdev, attr->report, (u8 *)&report.contents,
+			     sizeof(report.contents), HID_FEATURE_REPORT);
 	if (ret < 3) {
 		hid_err(hdev, "error reading %s string: %d\n", kattr->attr.name,
 			ret);
-- 
2.30.2

