Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42E6DA8E2
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 11:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404674AbfJQJoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 05:44:21 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41010 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbfJQJoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 05:44:21 -0400
Received: by mail-lf1-f65.google.com with SMTP id r2so1337794lfn.8
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 02:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gjRLh3ZcHVbp8CVYzPr5W3pE+xU7QVAz8dPx2MfpQLA=;
        b=WNSOU3TA99ip8tshnEjHz2ZPUgB9sJwDX90ocoyj8ueZfUfavv3urILdXBdX2IlLsk
         /lLcCEz9vZX2W0lBFQueDHLzaGE1oADcgXEcUbk1Dn0DXEaP+5pAd12bJINYMvYarKpc
         i6CGG3sAN5y6NoSgMDn19gwmuKKQTSO9NDdL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gjRLh3ZcHVbp8CVYzPr5W3pE+xU7QVAz8dPx2MfpQLA=;
        b=UoklSzGtC3tuiJYtDrVX0ppqCPHmuXSp5R7KC4iEBZ6q4MXkfxiyDYUhC7+a297r80
         uxtvAISUOjAz1/L92/ygPDrvRiWrioeaTMiyy4Dv2vrCVahOaod8OL613Y2mk55su8nL
         uE3WBnElU/oqTh1CMirJeMPLjFTWbGEg4+SKSumkH0qmczwH7II7uZc0DZV+FDx4yX0n
         mivBlRwmn/CxuTDoiRaNJ70pKbG9y/CMg5E6h3d5sD0uy8GrsN2S2d5+FlU5PfQPD+c2
         qfq5fdwG6Tge3TAYApt6LnbP6AW0bQFbVY2p8stVVtt8jmHbbWv3an1qHphBsKhabOoI
         NoFg==
X-Gm-Message-State: APjAAAX4PwQ5nhzPqFenfjzfXf4NppvvpzdIehxw7tY+UrBPnvSuQeYG
        Fz58svlt/d6mhrpHQcV0QjFEGQ==
X-Google-Smtp-Source: APXvYqyhs15euRvXnpel0la1SCD2VD/Py1HLu2uTVDba4Arg/jNVmKOthPwqGvlha8JObrOd8Sra5g==
X-Received: by 2002:ac2:410e:: with SMTP id b14mr1652775lfi.110.1571305458093;
        Thu, 17 Oct 2019 02:44:18 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id s27sm687616lfc.43.2019.10.17.02.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 02:44:17 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next] scripts/bpf: Print an error when known types list needs updating
Date:   Thu, 17 Oct 2019 11:44:16 +0200
Message-Id: <20191017094416.7688-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't generate a broken bpf_helper_defs.h header if the helper script needs
updating because it doesn't recognize a newly added type. Instead print an
error that explains why the build is failing and stop.

Fixes: 456a513bb5d4 ("scripts/bpf: Emit an #error directive known types list needs updating")
Suggested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 scripts/bpf_helpers_doc.py | 4 ++--
 tools/lib/bpf/Makefile     | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 08300bc024da..7548569e8076 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -488,8 +488,8 @@ class PrinterHelpers(Printer):
             return t
         if t in self.mapped_types:
             return self.mapped_types[t]
-        print("")
-        print("#error \"Unrecognized type '%s', please add it to known types!\"" % t)
+        print("Unrecognized type '%s', please add it to known types!" % t,
+              file=sys.stderr)
         sys.exit(1)
 
     seen_helpers = set()
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 75b538577c17..26c202261c5f 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -169,7 +169,8 @@ $(BPF_IN): force elfdep bpfdep bpf_helper_defs.h
 
 bpf_helper_defs.h: $(srctree)/include/uapi/linux/bpf.h
 	$(Q)$(srctree)/scripts/bpf_helpers_doc.py --header 		\
-		--file $(srctree)/include/uapi/linux/bpf.h > bpf_helper_defs.h
+		--file $(srctree)/include/uapi/linux/bpf.h > $@.tmp
+	@mv $@.tmp $@
 
 $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 
-- 
2.20.1

