Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF5C3D4E6
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406809AbfFKSDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:03:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37862 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406724AbfFKSDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:03:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id 22so3901364wmg.2
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 11:03:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HO84jvMVEYNGHABc8xmWdmtfOgm2IQ+qKomGj9o0pxQ=;
        b=Qj8ULrPVhKLeUYfVi87Giw5E5ed1psz5YDLXNs2NuKSIMlyil+xtKVNgsCf2LaHdS4
         KqBdL3jxa+bZvxfTTS5hU5UbKUemNFoG/UGq1RTXQVJRx3UMrzV/ihaphU4tTKnAI/KT
         Ms3nEP9jm0rIuQ1CaHcpUdN+7NdT5L0szdVKvc3a+AREnQK4vbIARnkX4Vwg8WpTHHoq
         LwFWdhvtOuhCnHU1ojc6CRHBXQkpGfnvgIqjgfvUYUQXL6pW0HKG1vD94ZpaHTA6NhUj
         2Iwiv2ydlZsUJrOFa08WkfA9aTMYi5dh+knbBq1R2q7aBHnT3Ag4WadmJ5spxRRZLF9d
         hExg==
X-Gm-Message-State: APjAAAVar0j+S9fXYOZDGgnGW/NeBtdSN9zRGZfZszrE/FprL4zG+1UT
        d+gDpemBPUwG07pDL6e0dcvJGfA+8CU=
X-Google-Smtp-Source: APXvYqxD8DhBaMfxcU2xJtj1pTaXhFyfX/RUI+38ou15PE4+QR0qjQIHR5LwU4cBYWhz1e9EVO7LnA==
X-Received: by 2002:a1c:f20c:: with SMTP id s12mr20011241wmc.151.1560276212114;
        Tue, 11 Jun 2019 11:03:32 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id t140sm1199037wmt.0.2019.06.11.11.03.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 11:03:31 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2] testsuite: don't clobber /tmp
Date:   Tue, 11 Jun 2019 20:03:26 +0200
Message-Id: <20190611180326.30597-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even if not running the testsuite, every build will leave
a stale tc_testkenv.* file in the system temp directory.
Conditionally create the temp file only if we're running the testsuite.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 testsuite/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/testsuite/Makefile b/testsuite/Makefile
index 7f247bbc..5353244b 100644
--- a/testsuite/Makefile
+++ b/testsuite/Makefile
@@ -14,7 +14,9 @@ TESTS_DIR := $(dir $(TESTS))
 
 IPVERS := $(filter-out iproute2/Makefile,$(wildcard iproute2/*))
 
-KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
+ifeq ($(MAKECMDGOALS),alltests)
+	KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
+endif
 ifneq (,$(wildcard /proc/config.gz))
 	KCPATH := /proc/config.gz
 else
@@ -94,3 +96,4 @@ endif
 		rm "$$TMP_ERR" "$$TMP_OUT"; \
 		sudo dmesg > $(RESULTS_DIR)/$@.$$o.dmesg; \
 	done
+	@$(RM) $(KENVFN)
-- 
2.21.0

