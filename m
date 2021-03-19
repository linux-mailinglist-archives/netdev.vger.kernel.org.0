Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AE6341434
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhCSE3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbhCSE32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 00:29:28 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD72C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 21:29:28 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id v17so4737316iot.6
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 21:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y0jgz//zVEbNql9HK61bKjTuk8XcYuXVt9tdgPActZw=;
        b=BOWuRozLgqzrcjQClsoI5cN9tLYe2V9Zs90rup1kKI4tRLIN8S2j4AVpgIWlpCK/p8
         tPTTyQGQMshP+KNH5lEbUvETtHeqaTS5ptHrfxY4FuAXSHLA2tIUj/9MxNdmv+VQkFeI
         qqULh1NeITSaTzb2dtUa66bbSaTv+EdIivhV6KlNlmEvgvVSnppGW70jCxuspiV/jnkf
         nM6v0GKM1xNE0qc9UFHgKiF3C9zxEl+kw9KbAEhHlcSVe7MK484LmztO6XXPGTenPS+c
         Klkt4VNqCaV4VzVwWg+D3fXIpqGpKRQGnUryVIb5m1JmaReL1Q6S37ogP4e+O0Z2E59d
         Duow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y0jgz//zVEbNql9HK61bKjTuk8XcYuXVt9tdgPActZw=;
        b=hljBqbwrkk1mVf5NsUGeehpztfDy6yfOCda4mOLDMjCEFhEq1n15LWoh70aoP8DhOa
         JpzryHBS4yOgOs08OFH6BbHllMWJW9cesz2pl+hWaRiNoCcYIRKmhnJEi02QzVAd42Nz
         8c4NA+T35OuwdZn3rwshuVSOZNOocUDf5rEnYzosxhAoRi3tQzh6Z3I39lcMzctLPbOn
         QXOj1LggRFVTtNTH/XFqWbH8n6UbotFFj5Zv5KUEEM2+p/SnSUYynYll/vrw0atMKemF
         u3zi+FxDX8v13TtpIIyLGVqUcnSt7qXPsnHYoZTRmphe477mNnOZ1eJxYFISG3Be9uH2
         0Jgg==
X-Gm-Message-State: AOAM530DFcQ3xlhOwVato9+gTFVSNvamdwtKPJP9f1RFsNJe0hV8TI2r
        nKNYOz2WtitNN4DwYCkJ7Ns41Q==
X-Google-Smtp-Source: ABdhPJz8D0WGg+5ZfW92LAh5T8KXHx1EVU8sInlUIMJsc7UO0riHqGFUAfP6K/DBRAT8jSX3qUNA7g==
X-Received: by 2002:a5d:9610:: with SMTP id w16mr1433166iol.167.1616128167997;
        Thu, 18 Mar 2021 21:29:27 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k3sm1985940ioj.35.2021.03.18.21.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 21:29:27 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] net: ipa: fix init header command validation
Date:   Thu, 18 Mar 2021 23:29:20 -0500
Message-Id: <20210319042923.1584593-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210319042923.1584593-1-elder@linaro.org>
References: <20210319042923.1584593-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use ipa_cmd_header_valid() to ensure certain values we will
program into hardware are within range, well in advance of when we
actually program them.  This way we avoid having to check for errors
when we actually program the hardware.

Unfortunately the dev_err() call for a bad offset value does not
supply the arguments to match the format specifiers properly.
Fix this.

There was also supposed to be a check to ensure the size to be
programmed fits in the field that holds it.  Add this missing check.

Rearrange the way we ensure the header table fits in overall IPA
memory range.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c | 49 +++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 35e35852c25c5..b40f031a905a7 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -175,21 +175,23 @@ bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
 			    : field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
 	if (mem->offset > offset_max ||
 	    ipa->mem_offset > offset_max - mem->offset) {
-		dev_err(dev, "IPv%c %s%s table region offset too large "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      ipv6 ? '6' : '4', hashed ? "hashed " : "",
-			      route ? "route" : "filter",
-			      ipa->mem_offset, mem->offset, offset_max);
+		dev_err(dev, "IPv%c %s%s table region offset too large\n",
+			ipv6 ? '6' : '4', hashed ? "hashed " : "",
+			route ? "route" : "filter");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			ipa->mem_offset, mem->offset, offset_max);
+
 		return false;
 	}
 
 	if (mem->offset > ipa->mem_size ||
 	    mem->size > ipa->mem_size - mem->offset) {
-		dev_err(dev, "IPv%c %s%s table region out of range "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      ipv6 ? '6' : '4', hashed ? "hashed " : "",
-			      route ? "route" : "filter",
-			      mem->offset, mem->size, ipa->mem_size);
+		dev_err(dev, "IPv%c %s%s table region out of range\n",
+			ipv6 ? '6' : '4', hashed ? "hashed " : "",
+			route ? "route" : "filter");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			mem->offset, mem->size, ipa->mem_size);
+
 		return false;
 	}
 
@@ -205,22 +207,35 @@ static bool ipa_cmd_header_valid(struct ipa *ipa)
 	u32 size_max;
 	u32 size;
 
+	/* In ipa_cmd_hdr_init_local_add() we record the offset and size
+	 * of the header table memory area.  Make sure the offset and size
+	 * fit in the fields that need to hold them, and that the entire
+	 * range is within the overall IPA memory range.
+	 */
 	offset_max = field_max(HDR_INIT_LOCAL_FLAGS_HDR_ADDR_FMASK);
 	if (mem->offset > offset_max ||
 	    ipa->mem_offset > offset_max - mem->offset) {
-		dev_err(dev, "header table region offset too large "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      ipa->mem_offset + mem->offset, offset_max);
+		dev_err(dev, "header table region offset too large\n");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			ipa->mem_offset, mem->offset, offset_max);
+
 		return false;
 	}
 
 	size_max = field_max(HDR_INIT_LOCAL_FLAGS_TABLE_SIZE_FMASK);
 	size = ipa->mem[IPA_MEM_MODEM_HEADER].size;
 	size += ipa->mem[IPA_MEM_AP_HEADER].size;
-	if (mem->offset > ipa->mem_size || size > ipa->mem_size - mem->offset) {
-		dev_err(dev, "header table region out of range "
-			      "(0x%04x + 0x%04x > 0x%04x)\n",
-			      mem->offset, size, ipa->mem_size);
+	if (size > size_max) {
+		dev_err(dev, "header table region too large\n");
+		dev_err(dev, "    (0x%04x > 0x%04x)\n", size, size_max);
+
+		return false;
+	}
+	if (size > ipa->mem_size || mem->offset > ipa->mem_size - size) {
+		dev_err(dev, "header table region out of range\n");
+		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
+			mem->offset, size, ipa->mem_size);
+
 		return false;
 	}
 
-- 
2.27.0

