Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3EDDDE3E
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 13:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfJTLXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 07:23:50 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35548 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbfJTLXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 07:23:50 -0400
Received: by mail-lj1-f194.google.com with SMTP id m7so10410165lji.2
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 04:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bI7fDg3piH2PEA50mu43QODUSb3zs/BzZxjL1mHMsMU=;
        b=DevZ/X0upiiR3NhcJancDyO/V58XLVA5TODsrIigL6DwdwJYybr1uXBJLt9NjCC1He
         xe437BCKrfQ8kJbBYQ/xIwVML595ff1SqouiiTLQOaxZDGrLUPlaenoLYjzL4bYHJijl
         u8sN1Kh3Ta1FFMb0uqwENfDRqNWa+HvDKOw9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bI7fDg3piH2PEA50mu43QODUSb3zs/BzZxjL1mHMsMU=;
        b=JPj5Hpaufd6HEQ89U9HF5ijoYUs/1lmcvyf/ZsfoQnLrfytPyTmbjfrENv3/Ra1ruP
         9z2VhfKljoyLSPdNZ4b/kq6HjV6cECJXrWP9uYUdcCh0WTnAkC9e1i75kFjoLqyY7FoN
         ybf1fOzK9IetLZDQWz1o5wEBsPljE2pSUnBuXdRs1ll3v5y8mmxFFiP//hMZ8vbWM7rF
         YAwETdETwJlizZOFTpEvewXWHTl1QEGFZhpPXStzdpET1KDp0+yGeuDgKH6W/z5etPYE
         8RgEQ7Ep3bdOeN98xvosHW28atIJr3aJdGEuvCFnkSpwZLRMAFve0xtj7ieHE2V6Yis6
         gy2w==
X-Gm-Message-State: APjAAAXM+P0IdfI8GYCSz4W4yTBtwekUBCi8RglqchvY58uM0p53KZcw
        xDvXZeW9C8wwoZD2GT7hFTCK7EWy03afgg==
X-Google-Smtp-Source: APXvYqyDPkoVlT/3odGDLg6saAfhUXeEKNO40Jur9V2PZPvGP7JqXGohlGLQ9cDmLcB3zNIU+uHwnA==
X-Received: by 2002:a2e:5354:: with SMTP id t20mr11547356ljd.227.1571570626932;
        Sun, 20 Oct 2019 04:23:46 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n28sm5000749lfi.58.2019.10.20.04.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 04:23:46 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2] scripts/bpf: Print an error when known types list needs updating
Date:   Sun, 20 Oct 2019 13:23:44 +0200
Message-Id: <20191020112344.19395-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't generate a broken bpf_helper_defs.h header if the helper script needs
updating because it doesn't recognize a newly added type. Instead print an
error that explains why the build is failing, clean up the partially
generated header and stop.

v1->v2:
- Switched from temporary file to .DELETE_ON_ERROR.

Fixes: 456a513bb5d4 ("scripts/bpf: Emit an #error directive known types list needs updating")
Suggested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 scripts/bpf_helpers_doc.py | 4 ++--
 tools/lib/bpf/Makefile     | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

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
index 75b538577c17..54ff80faa8df 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -286,3 +286,6 @@ tags:
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable so we can use it in if_changed and friends.
 .PHONY: $(PHONY)
+
+# Delete partially updated (corrupted) files on error
+.DELETE_ON_ERROR:
-- 
2.20.1

