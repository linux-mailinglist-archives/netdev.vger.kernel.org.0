Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423FA477605
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238573AbhLPPdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbhLPPdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 10:33:40 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B809C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 07:33:40 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v11so44859538wrw.10
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 07:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=mFXPjXF50Kbv9CJ6JXYL2JCXnW2EqBrfYgA7AN5AeBE=;
        b=EQcy8Szrp21l7daE0SjVhaonsoryHPQDbua3yQX9r2IzaKRCjyjLc/V0xEu4ndsFvN
         LpSA4xwyAciE7FSrGcjl9nLYziBQ9wrUGWtygnIIQIlbSe/VvCJHJo+g+d01Zeeoky0H
         JvBOCtVkaSenG9aAIvA8gYOMUFizH2HVj5ZW7EIkNGOtC/uHpRP7PkIA4f9tyGS29wCh
         u06kptuChnABA450nd80F19H7fu8qaZb0uTpbf9ZgNRU4HtOIMg2qnNDemQcSl3XOXs2
         Sqr9CcGSIKBUjfhturG6wervZyROX8SQ2VCmZdLrTaWfhztMEt3Uq2Kk2c5CyIX5uNWd
         d8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=mFXPjXF50Kbv9CJ6JXYL2JCXnW2EqBrfYgA7AN5AeBE=;
        b=jC3xPqh5bT7xGfD3VHYEK9gltmunamKdo0qZiFQWo+R+bNxTyWs9v+XdxQ9ByeM3Mf
         glBaP3fBZYkoQe06mKkTlLf/fMyuruhpXOxlBocUTojRDUveDIPRuOOzEbt0oikonbys
         Oobg69hFaXPvRUXycKY+V88eItP1EpZ877XO1Ng8M3rwFeToexS/hKnP5Msl7ZR4Ieyq
         aSGlRNxVWieqGTglYz+BdAWw9gQmQDDpizsJRvspFWLd8Hzfe/pj90N6ZLsYoxdHsTLT
         6NmTWGwuuqZGfVkqhYZeWmeV7YQ7YRrfbD70yvvof57y/ua5WtgKbXKcUjIv34CiCpgp
         7bkQ==
X-Gm-Message-State: AOAM533Nw8hqMFrCjc5JPDn7bgzoz2aJIiZx++HZI9TPJivT1EsHUzoK
        uql5/K6fWEJgiYYgxbA4k9FrrJFpFEL7
X-Google-Smtp-Source: ABdhPJzFXPvzlOeq8sdYtlAwtNLJPtqS1k9mFvK5FPZojU7Zi2YiB98vVkF7qC2p9m0zKlLxQDG2nQ==
X-Received: by 2002:adf:ee0d:: with SMTP id y13mr544551wrn.427.1639668818831;
        Thu, 16 Dec 2021 07:33:38 -0800 (PST)
Received: from Mem (2a01cb088160fc00945483c765112a48.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:9454:83c7:6511:2a48])
        by smtp.gmail.com with ESMTPSA id l9sm6136335wrs.101.2021.12.16.07.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 07:33:38 -0800 (PST)
Date:   Thu, 16 Dec 2021 16:33:36 +0100
From:   Paul Chaignon <paul@isovalent.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2] lib/bpf: fix verbose flag when using libbpf
Message-ID: <20211216153336.GA30454@Mem>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 6d61a2b55799 ("lib: add libbpf support"), passing the
verbose flag to tc filter doesn't dump the verifier logs anymore in case
of successful loading.

This commit fixes it by setting the log_level attribute before loading.
To that end, we need to call bpf_object__load_xattr directly instead of
relying on bpf_object__load.

Fixes: 6d61a2b55799 ("lib: add libbpf support")
Signed-off-by: Paul Chaignon <paul@isovalent.com>
---
 lib/bpf_libbpf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index dbec2cb5..b992a62c 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -246,6 +246,7 @@ static int handle_legacy_maps(struct bpf_object *obj)
 
 static int load_bpf_object(struct bpf_cfg_in *cfg)
 {
+	struct bpf_object_load_attr attr = {};
 	struct bpf_program *p, *prog = NULL;
 	struct bpf_object *obj;
 	char root_path[PATH_MAX];
@@ -302,7 +303,11 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
 	if (ret)
 		goto unload_obj;
 
-	ret = bpf_object__load(obj);
+	attr.obj = obj;
+	if (cfg->verbose) {
+		attr.log_level = 2;
+	}
+	ret = bpf_object__load_xattr(&attr);
 	if (ret)
 		goto unload_obj;
 
-- 
2.25.1

