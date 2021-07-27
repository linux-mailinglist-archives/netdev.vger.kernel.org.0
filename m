Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FBC3D801C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhG0VAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbhG0U7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:08 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6820BC06179C
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:08 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so1035715pjh.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ce1JaJ2iLqZ1ByPIR9vq7JUGIWw9MUEqupb8ASz/48w=;
        b=oFZ38ngC4x0EhFhmHE+6qfFOYlT/SRKUjL4MPMQTyFaF3s8fWo/JmjxWIaNX2p9bbt
         qzdODRjS63nCZWqXoq8D46zA/h8aG7csZue0TYDQDcVJ/Tm9e8VNeG3PnQgl4tWZQ+8c
         dISuWbNSuDBTOb5SssPxgXBD5DtFD1/ugFU8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ce1JaJ2iLqZ1ByPIR9vq7JUGIWw9MUEqupb8ASz/48w=;
        b=gqpdVUwhOSZCehJqGAqise84wWiPJmenDdBBO+NbXkkPr2EnFePbyC0Z/sSs8eefYa
         BO2z0kSSAUyFjRrqZVT1GaG6H+ScfNjnOPmDS62WtaJcTt5KoH3gOvAz6W9JsXjMtb+J
         p7z9+9dMRy5KqpS0VpkYetIax+ErOodbD9Qqo+nWJlYEciiIJPrMxO7K3gpCTL2Vio9k
         DJoZwaIGL8YZuOqwPsy9guqykzFn/6txBPSNZ5rHOlihAz5CLzfdkV2knbJnD3o9Uv/E
         9cQQC7bsD6thChNx60HpftdjTQgqoZ6iaJ5VOJlsYJ0FVBe3saaG+vW1g5q2pcHYBbeI
         QCwg==
X-Gm-Message-State: AOAM532GLm6ywTO7kHeu/80tvNegyxOgxxHdxpBaJS79yt626/7Mse58
        pxJXSlE6ltO32uOsUcoMfZz/qw==
X-Google-Smtp-Source: ABdhPJxLx3UKt1g0knEKNGPxeEHzWNplXw12NU8/pyauXMt+ycvKwDQPddmlym/wJmVWHmTZkImhYQ==
X-Received: by 2002:a65:5684:: with SMTP id v4mr25470763pgs.388.1627419548007;
        Tue, 27 Jul 2021 13:59:08 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f4sm5114783pgi.68.2021.07.27.13.59.03
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
Subject: [PATCH 07/64] staging: rtl8192e: Use struct_group() for memcpy() region
Date:   Tue, 27 Jul 2021 13:57:58 -0700
Message-Id: <20210727205855.411487-8-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4368; h=from:subject; bh=whsZXL1+VyeGGVCEni/WVzZTdGJot/iTzZPaNe8UUr4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOBTnFFuq2+zkjlQr57HB6KOpEDyaB2ijAbcALO MKTd4mmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzgQAKCRCJcvTf3G3AJqgfEA CpVSQGeMGU5eUl64arg0mbKqIDJKPLDrfc3TEtQwzpULtWAtStxgtXWkqjgD3gLSOMuwG3ih74xg0+ hTraIVtKZb1lrnvbvn3GZRfBp0n2qpK2QBFNx2/+F5nXotHQOKPORNJRAJydSL2viaQ7OEoyIpM2Me D8nL5yC8ZGHK0A4lVP55GAkIj7LrR+BeEpWkybNkHdiFl+rs+n4d4Y5K5W5VNlMcjt7QuPReCHC+Qv WWBBoNfTHJEW2CoFe5zCDER42ROLFDvt+sDPfKsVQI9Z1vlUsnpX5iYDzQzaEdNq+qiG5STf7DfJpl 7boSirsHUslj5fLDMwcf6eJddWbh6fTv3G3t/wGWDeNMTPM9I87kUfIxdOVlVxwZJTtQzRkVKiO6cj QPIENJ4Jr0y7lIw5VC2PrLb1k1OrOLVMITkShgU/vOEYCHwsAbSV5+hZl++Mr/JP53hPfwiDGK6fkO h4jnthinSH7U1p3zBAyyW/U4j8y0rc+SLpCnVJzA8pK+h/cwKcNF3miP5pu2wcEnonqvq0pO27EukH en9phkwP2ZomfnVI6QII0zHonJUw0qciBinwVIIvS0xAoNPj7fCpwMkcIuj4N/wj+xN3kwpZ7ix0Dv AmxT/glSjzUIz5WJPhvBRwvRJLLJLoIbc44SjjMc/R2fFjtCYNoSHk1KJRtw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() around members addr1, addr2, and addr3 in struct
rtllib_hdr_4addr, and members qui, qui_type, qui_subtype, version,
and ac_info in struct rtllib_qos_information_element, so they can be
referenced together. This will allow memcpy() and sizeof() to more easily
reason about sizes, improve readability, and avoid future warnings about
writing beyond the end of addr1 and qui.

"pahole" shows no size nor member offset changes to struct
rtllib_hdr_4addr nor struct rtllib_qos_information_element. "objdump -d"
shows no meaningful object code changes (i.e. only source line number
induced differences and optimizations).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/rtl8192e/rtllib.h            | 20 ++++++++++++--------
 drivers/staging/rtl8192e/rtllib_crypt_ccmp.c |  3 ++-
 drivers/staging/rtl8192e/rtllib_rx.c         |  8 ++++----
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index c6f8b772335c..547579070a82 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -759,9 +759,11 @@ struct rtllib_hdr_3addr {
 struct rtllib_hdr_4addr {
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
@@ -921,11 +923,13 @@ union frameqos {
 struct rtllib_qos_information_element {
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
 
 struct rtllib_qos_ac_parameter {
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
index b60e2a109ce4..66b3a13fced7 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
@@ -133,7 +133,8 @@ static int ccmp_init_iv_and_aad(struct rtllib_hdr_4addr *hdr,
 	pos = (u8 *) hdr;
 	aad[0] = pos[0] & 0x8f;
 	aad[1] = pos[1] & 0xc7;
-	memcpy(aad + 2, hdr->addr1, 3 * ETH_ALEN);
+	BUILD_BUG_ON(sizeof(hdr->addrs) != (3 * ETH_ALEN));
+	memcpy(aad + 2, &hdr->addrs, 3 * ETH_ALEN);
 	pos = (u8 *) &hdr->seq_ctl;
 	aad[20] = pos[0] & 0x0f;
 	aad[21] = 0; /* all bits masked */
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index c2209c033838..9c4b686d2756 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -1576,13 +1576,13 @@ static int rtllib_read_qos_param_element(struct rtllib_qos_parameter_info
 							*info_element)
 {
 	int ret = 0;
-	u16 size = sizeof(struct rtllib_qos_parameter_info) - 2;
+	u16 size = sizeof(element_param->info_element.data);
 
 	if ((info_element == NULL) || (element_param == NULL))
 		return -1;
 
 	if (info_element->id == QOS_ELEMENT_ID && info_element->len == size) {
-		memcpy(element_param->info_element.qui, info_element->data,
+		memcpy(&element_param->info_element.data, info_element->data,
 		       info_element->len);
 		element_param->info_element.elementID = info_element->id;
 		element_param->info_element.length = info_element->len;
@@ -1601,7 +1601,7 @@ static int rtllib_read_qos_info_element(struct rtllib_qos_information_element
 							*info_element)
 {
 	int ret = 0;
-	u16 size = sizeof(struct rtllib_qos_information_element) - 2;
+	u16 size = sizeof(element_info->data);
 
 	if (element_info == NULL)
 		return -1;
@@ -1610,7 +1610,7 @@ static int rtllib_read_qos_info_element(struct rtllib_qos_information_element
 
 	if ((info_element->id == QOS_ELEMENT_ID) &&
 	    (info_element->len == size)) {
-		memcpy(element_info->qui, info_element->data,
+		memcpy(&element_info->data, info_element->data,
 		       info_element->len);
 		element_info->elementID = info_element->id;
 		element_info->length = info_element->len;
-- 
2.30.2

