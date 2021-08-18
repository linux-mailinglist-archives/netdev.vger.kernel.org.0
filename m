Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A5A3EFAE7
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbhHRGHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238267AbhHRGGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:06:35 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D477DC061230
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:05:55 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id w6so1114568plg.9
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AvplAjAyy7Xo+ijXhvo31OZi4yHKm9FY1a+n2JGpi4g=;
        b=NeXzORZmOiduwjDAC0+j3ijPK837yd7AOHICtcf8M5fH8xvkQaB+Uf/aJua6kMoa7W
         1vXTWMRBK40BOeZtiWp1NgAe4zigCd52vkBHJFcstCUi0JREIRyq+cWP2cxIfpt3Py5d
         YQECpl2DUZNSwXCNLd5C5w9uHmFHklnzQCqEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AvplAjAyy7Xo+ijXhvo31OZi4yHKm9FY1a+n2JGpi4g=;
        b=XyD0Ore+SyEmgWNdIC9j2erY/4zQmxbPDh96PwG3BuLEM5T2F35ciNr246WxAKNQu7
         +cf9S59IhwTui9gBO/Gdwo4d/XkQH+hlD/jsNB9m7LyQvAjbVrRHT9eKVPpzjKDTj6BS
         Wz/ZyEaJB9z1AQcD88y0ma8Jhp3/juBhpR2Cgqqi7oAupPxyc+ezJjA4tjGK2TxnZMhn
         vFnmbYN6y/IANL92oC9Y/ORCw4s0Qtp2/gMitDfxOOjom4r+8gJi1aM/WnEH8ZukFZkF
         Do5a77ixP0ccIT3A6+B6UhFKumikKih4FI/1iVF+OYHntU5PVYbJSkxiT3uAIgB/JKBA
         Dhgw==
X-Gm-Message-State: AOAM532d7MxHSh5NfScS31kINXD+4uGEa8DiG+YBkH6Triw3jksQkiA4
        hluSvTOwPP35jeQpWnUl60ncJA==
X-Google-Smtp-Source: ABdhPJxY62Rs0zD7LqgByaLcYUzxicRfdtBpOOnXndlcdy7gi8jpEy7wbHdOuHGHf2lbmjFtmXZneg==
X-Received: by 2002:a17:902:e84f:b0:12d:c616:a402 with SMTP id t15-20020a170902e84f00b0012dc616a402mr5833254plg.77.1629266755373;
        Tue, 17 Aug 2021 23:05:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y67sm4550662pfg.218.2021.08.17.23.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:05:53 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Alison Schofield <alison.schofield@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        linux-cxl@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 06/63] cxl/core: Replace unions with struct_group()
Date:   Tue, 17 Aug 2021 23:04:36 -0700
Message-Id: <20210818060533.3569517-7-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2984; h=from:subject; bh=gH2l7MUrimYDJJHL5/kGu3UEiSd7agDYsUtnIqIDLGg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMfFeE+SAeXV7TlGs5W5Dan0qJQ1dt63HKDzfHG juo8T9CJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjHwAKCRCJcvTf3G3AJlH/EA CnsBzSF5pyrctJZ6ieH+8X8zUFVzCAy3+BR6FX4EgEQJkJRkPWwnEynE2qGmzAQmsEHsp55I/GrJX4 JR1eEWAvgU7ZjlCsPIcv1hCYd1m27MgsvOjeZZPQo8r02lm4PTiaybJvP6THoSxUoZ7x7i+BLdqnLN CJ2Tai+1QWBg/z5BfgXsolu04ACMdQY4zZdNixxfxbVmz8EfwVyWUFyP3k0U0O43Mhc0n+Pi9sfLdY gqM7Y/4yJ/qOqjNqkAP2FR+u7pDMCwF5q6mugy3ReHQbJ3WUCsx/h6iW6XpvzpLtDmU4PnwCizNbDJ 65jHpkXZBwccb2yWZL3xbfcqAc4M9w9cYxNpLdtt8NZ+rde81+4KjY3RjmaYJ6kbOdG2jTQ2uB7QBR 8IB6Vp3VcelKvfe2D6gT91BL8IxzqodAw+yqwCP18Gg1nRBdVdzBLvr5+AFn9w0jjp98MtTKa6P7ii gkZ2UwvygAIG4rcijtB/7meDfJT0C/h40i2avmZ5bb1UndNmOtfoixIiUnumnomu9UUwzxEUdhNb57 KS5dfN7XmkBAwIOqhTGzOAtYHWmH1VyhVLJnBQ2VfGR39r5zOPfmnkT1aic2J3QdRCTgo2AZbLBI6F DcMPWmOtMJYmAJpqZMcje5nPsclSh7Hq7uJSZSzWOq0scZlLODKdzRVPuALg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the newly introduced struct_group_typed() macro to clean up the
declaration of struct cxl_regs.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/lkml/1d9a2e6df2a9a35b2cdd50a9a68cac5991e7e5f0.camel@intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/cxl/cxl.h | 61 ++++++++++++++---------------------------------
 1 file changed, 18 insertions(+), 43 deletions(-)

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 53927f9fa77e..9db0c402c9ce 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -75,52 +75,27 @@ static inline int cxl_hdm_decoder_count(u32 cap_hdr)
 #define CXLDEV_MBOX_BG_CMD_STATUS_OFFSET 0x18
 #define CXLDEV_MBOX_PAYLOAD_OFFSET 0x20
 
-#define CXL_COMPONENT_REGS() \
-	void __iomem *hdm_decoder
-
-#define CXL_DEVICE_REGS() \
-	void __iomem *status; \
-	void __iomem *mbox; \
-	void __iomem *memdev
-
-/* See note for 'struct cxl_regs' for the rationale of this organization */
-/*
- * CXL_COMPONENT_REGS - Common set of CXL Component register block base pointers
- * @hdm_decoder: CXL 2.0 8.2.5.12 CXL HDM Decoder Capability Structure
- */
-struct cxl_component_regs {
-	CXL_COMPONENT_REGS();
-};
-
-/* See note for 'struct cxl_regs' for the rationale of this organization */
-/*
- * CXL_DEVICE_REGS - Common set of CXL Device register block base pointers
- * @status: CXL 2.0 8.2.8.3 Device Status Registers
- * @mbox: CXL 2.0 8.2.8.4 Mailbox Registers
- * @memdev: CXL 2.0 8.2.8.5 Memory Device Registers
- */
-struct cxl_device_regs {
-	CXL_DEVICE_REGS();
-};
-
 /*
- * Note, the anonymous union organization allows for per
- * register-block-type helper routines, without requiring block-type
- * agnostic code to include the prefix.
+ * Using struct_group() allows for per register-block-type helper routines,
+ * without requiring block-type agnostic code to include the prefix.
  */
 struct cxl_regs {
-	union {
-		struct {
-			CXL_COMPONENT_REGS();
-		};
-		struct cxl_component_regs component;
-	};
-	union {
-		struct {
-			CXL_DEVICE_REGS();
-		};
-		struct cxl_device_regs device_regs;
-	};
+	/*
+	 * Common set of CXL Component register block base pointers
+	 * @hdm_decoder: CXL 2.0 8.2.5.12 CXL HDM Decoder Capability Structure
+	 */
+	struct_group_tagged(cxl_component_regs, component,
+		void __iomem *hdm_decoder;
+	);
+	/*
+	 * Common set of CXL Device register block base pointers
+	 * @status: CXL 2.0 8.2.8.3 Device Status Registers
+	 * @mbox: CXL 2.0 8.2.8.4 Mailbox Registers
+	 * @memdev: CXL 2.0 8.2.8.5 Memory Device Registers
+	 */
+	struct_group_tagged(cxl_device_regs, device_regs,
+		void __iomem *status, *mbox, *memdev;
+	);
 };
 
 struct cxl_reg_map {
-- 
2.30.2

