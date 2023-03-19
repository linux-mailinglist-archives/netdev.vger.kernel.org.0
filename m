Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA196C046F
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjCSTig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCSTi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:38:29 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA8C6EAC
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:27 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j2so8532893wrh.9
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679254705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6BVGpxdql44gS2WLVUDyHPvm/nXsusxFRbvvN5WJp24=;
        b=nBhfBInPHRzumJEwoI9z6FlkzLx7ojKaS6YSMUC1C0uls3m8sXVEGzeYzQem+jMKFi
         XsW1uQL2nX2WaszqslwnTFkuOzYDUbemz6tJKbqpacZl1OIXH4NZY5bsFTIc+//ENxLk
         UJr2tcLOsyItu+N9sM7KPJweKo/DkNcB+XDXAAWqy8L03ZCCDeIMarAhcoME4OGW+G23
         +KL8LPNcCGQiPDr77LbZmzkvO8DmOpQ1yGl5UsufhTvusJahbeZJj03wmheXChLJ7Sm+
         0ksdgXrV0nYJxVzHYZoJqQVeJbpv9frASq58pSkvobqHnvD8cvGTPJef2yoYlwvquUie
         7O+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679254705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6BVGpxdql44gS2WLVUDyHPvm/nXsusxFRbvvN5WJp24=;
        b=j4GFpGW0QI1EfZVvtlpT2xGVBp6fbxE+hRZDszX2xlJ2NM0hhdWxnaj5P+UZQQ/H67
         nO+3GVuYqZv615x3493Hdp3ya4tJzYFnzHQaAQL2al0uOURy65w26m2adTIczsgbTAo8
         YsPK7rGNsJN8R5uuptCI97b7rx9CK88TG1aMT6b7kMsJaU3+gMJussfl4z7XAWJn2oxR
         ucSLWnaL7tXXwTIIt4GtDUp1WfQTbm2I7Y0FjjZoiaRYopOx9W+QD9p1b90stIGuNk24
         +kiBbpBneXCZRX3hIh4nzqqzp55SU9uHjUiJQm9W2Bm1TOuCUf1ANazlqBCQ35Nb5iho
         Avug==
X-Gm-Message-State: AO0yUKU+CnX8/V/ALVwk6hdbInoRsevwu6dcP/EnTS7PWzQkIQviD7j7
        TQKEG4KtZTBWIPafhzA7j/EfVhyJntsPog==
X-Google-Smtp-Source: AK7set/xnWbPh6l14D97o8P6vUpCG8nEzFGgtS/Bq2+IkEKoJYXYJspf0lLQZGjXbA7XVkeQ52LJzw==
X-Received: by 2002:adf:fc52:0:b0:2cf:ed48:2ea7 with SMTP id e18-20020adffc52000000b002cfed482ea7mr11066479wrs.4.1679254705295;
        Sun, 19 Mar 2023 12:38:25 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d5-20020adfef85000000b002cfed482e9asm7204190wro.61.2023.03.19.12.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:38:24 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 1/6] tools: ynl: Fix genlmsg header encoding formats
Date:   Sun, 19 Mar 2023 19:37:58 +0000
Message-Id: <20230319193803.97453-2-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230319193803.97453-1-donald.hunter@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pack strings use 'b' signed char for cmd and version but struct
genlmsghdr defines them as unsigned char. Use 'B' instead.

Fixes: 4e4480e89c47 ("tools: ynl: move the cli and netlink code around")
Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/lib/ynl.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 90764a83c646..32536e1f9064 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -200,7 +200,7 @@ def _genl_msg(nl_type, nl_flags, genl_cmd, genl_version, seq=None):
     if seq is None:
         seq = random.randint(1, 1024)
     nlmsg = struct.pack("HHII", nl_type, nl_flags, seq, 0)
-    genlmsg = struct.pack("bbH", genl_cmd, genl_version, 0)
+    genlmsg = struct.pack("BBH", genl_cmd, genl_version, 0)
     return nlmsg + genlmsg
 
 
@@ -264,7 +264,7 @@ class GenlMsg:
         self.hdr = nl_msg.raw[0:4]
         self.raw = nl_msg.raw[4:]
 
-        self.genl_cmd, self.genl_version, _ = struct.unpack("bbH", self.hdr)
+        self.genl_cmd, self.genl_version, _ = struct.unpack("BBH", self.hdr)
 
         self.raw_attrs = NlAttrs(self.raw)
 
@@ -358,7 +358,7 @@ class YnlFamily(SpecFamily):
                 raw >>= 1
                 i += 1
         else:
-            value = enum['entries'][raw - i]
+            value = enum.entries_by_val[raw - i].name
         rsp[attr_spec['name']] = value
 
     def _decode(self, attrs, space):
-- 
2.39.0

