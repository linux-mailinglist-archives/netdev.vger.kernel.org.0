Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2942068AC
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387855AbgFWXxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbgFWXxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:53:18 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C70CC061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:18 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g12so174804pll.10
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gHNOOCaaOKCgcOHPsZ+vkVizkJqVg+rvtjue+mBjdzM=;
        b=vbGWwC4tAsCoq63jn8OoxgNQwz2F22VNEQhRyR5sGy/Qq1Hv834cjQ/2DJ/YHBCzC+
         US4bu0r7i4B2fSaEcfeWe703C/xo1nxCQkeZQSh7/3+ubQyqTfTonq2SpJibdZ/iPypz
         tA7OfWnWgWBOrKaSqUR0f4qvMdf5ZIid8Sw8A2+ET32z7IPYqllSAsycpUSTU7A0MGs0
         mBgBVGF0IL2bhsD3GLEjUVyYwf8z6R/UO+/1Grq1I9///df3iETGVtkRrSbaVSAGu8v3
         MsBJvWTQADDvlaotW2aRa0Q/biUgsC1Wk+KTXgTn+pEJHnMQ5dPZg5CgwUjBz3ZPj5Ag
         rdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gHNOOCaaOKCgcOHPsZ+vkVizkJqVg+rvtjue+mBjdzM=;
        b=Si+/hFfoZUqTILVnNLXKp+4difUxteuuTY9HeXJJllSA/8e/FmKviG2IRlApazczuY
         RkV3UJYyiLzvT3AKheTKb/WoBWec/an5u8lbCdELh1pAeZlJNgVLj3PsfMmixIeTAMAx
         fWKia3QEsoC+1kBrzSqHJHH0RutOtJlBThewnHdSAfdsAQ8cZK7tRO7TrkDxDSJrUgxl
         2n0tHpFCx/QbfzBLn+IMe9vnb84tvCo53Ro1wD/PKG26jAGo8QJq/k25HyTHX8cJaN8k
         3rQkVL1OUKIgMGL6XcP1Pd9AdHpEPUGGL3WnfEdKlu7tzSgLI/70j3fQbZPaO6LvfeWJ
         OaRQ==
X-Gm-Message-State: AOAM532f8OnMje8l3dhigzUKfRt9UXKykwuTsVfm+XWOHOAm0W+VOStV
        J66224slRRPLge41xsPeYR1IaRfCDJU=
X-Google-Smtp-Source: ABdhPJyXv88jxw0mDGUFQmVVvdZPGIMiuyfBmQqRvkbWCVZ9xaHCM9DpkZbCTkzDzllW8rbzHYpGlA==
X-Received: by 2002:a17:902:70ca:: with SMTP id l10mr23992709plt.31.1592956397050;
        Tue, 23 Jun 2020 16:53:17 -0700 (PDT)
Received: from hermes.corp.microsoft.com (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 23sm18096521pfy.199.2020.06.23.16.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 16:53:16 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 1/5] bpf: replace slave with sub
Date:   Tue, 23 Jun 2020 16:53:03 -0700
Message-Id: <20200623235307.9216-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623235307.9216-1-stephen@networkplumber.org>
References: <20200623235307.9216-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The term sub interface is more appropriate for bpf devices.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 lib/bpf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index c7d45077c14e..9271e169a992 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -666,7 +666,7 @@ static int bpf_gen_master(const char *base, const char *name)
 	return bpf_gen_global(bpf_sub_dir);
 }
 
-static int bpf_slave_via_bind_mnt(const char *full_name,
+static int bpf_sub_via_bind_mnt(const char *full_name,
 				  const char *full_link)
 {
 	int ret;
@@ -689,7 +689,7 @@ static int bpf_slave_via_bind_mnt(const char *full_name,
 	return ret;
 }
 
-static int bpf_gen_slave(const char *base, const char *name,
+static int bpf_gen_sub(const char *base, const char *name,
 			 const char *link)
 {
 	char bpf_lnk_dir[PATH_MAX + NAME_MAX + 1];
@@ -709,7 +709,7 @@ static int bpf_gen_slave(const char *base, const char *name,
 				return ret;
 			}
 
-			return bpf_slave_via_bind_mnt(bpf_sub_dir,
+			return bpf_sub_via_bind_mnt(bpf_sub_dir,
 						      bpf_lnk_dir);
 		}
 
@@ -733,7 +733,7 @@ static int bpf_gen_hierarchy(const char *base)
 
 	ret = bpf_gen_master(base, bpf_prog_to_subdir(__bpf_types[0]));
 	for (i = 1; i < ARRAY_SIZE(__bpf_types) && !ret; i++)
-		ret = bpf_gen_slave(base,
+		ret = bpf_gen_sub(base,
 				    bpf_prog_to_subdir(__bpf_types[i]),
 				    bpf_prog_to_subdir(__bpf_types[0]));
 	return ret;
-- 
2.26.2

