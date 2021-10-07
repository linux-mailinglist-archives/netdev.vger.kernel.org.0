Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876E5425C76
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240282AbhJGTqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbhJGTqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:46:42 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCA3C061760
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:44:48 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u18so22492303wrg.5
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/pVhz86FSTTFW5G/3UZ8fgPu9sNgS9qC6uAiUwu1Bs=;
        b=N3FMSfRGEZaVFYcunLUpqIr1jNY+xn3riqAl6MKYCg2ExUvIEv82dQoFgKewjcBQo7
         WN5Ey5Gu73iaS+R8RPyO0AYz2YCRI8lER43Mj8FyWRF7cZ4MXwy27pRgNTyMwe9Y+xRH
         CuHzRDOMggaPUy5Y4aZlUeK4k74DAjaIuhqzuyDAudPcxYMop9fbPaOiGOTXP0fm3tqQ
         rXmmv4xPW9gYc/4e4Z5AU29xHG7TaYiy6osGHwLSy3iw/WFUmb4YIlGODOcg93tBH3jf
         d5zrDo3Bd0E8f/kEDS9UduXDApIPEFvugNCewoRlz7ZY7iG3OGyE75Nbpxj55xWiPhKf
         B/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/pVhz86FSTTFW5G/3UZ8fgPu9sNgS9qC6uAiUwu1Bs=;
        b=wCXavYmSeMBK7QiLY/9QCnuj8aLXZAC4S54CM3/ZaYhJDFGyRlBKo4rHyE8q0C5TEa
         AM+TvS2inRe23E0VhlSrRUzBs0puQqsqb21VJBurH28n3tvf4gpvFT4VKp4G4iWnL9o4
         C3Yn7Z0UhVc+AhCz46+dxwb2ABG9YXUUPBdRIQaARiXzrNw425+yKrkrxl8GDJYZvLrT
         6wWxMplSIU+fI6Vhf8HevjZGDWFlCaDt8m0pGlqLcZWgAD3pwQHafGOWEwy72thcnMBb
         2W9pl+GGZGiGIwkvDqmp1Pzz2J72ZOHsDLPW0aE2wrNNooWvz+zpmck6vvfEW8Xmif6p
         pbzg==
X-Gm-Message-State: AOAM531VZnpsuvsfL07AzrYE3P4pacTWmiKCnHhYoxMEeB9lWW6QOM0B
        B9N7mIqp33Cc/6iZmw9dml1FoQ==
X-Google-Smtp-Source: ABdhPJysLUfjwtBjYXSAr+0yizovtIpaiBzDhaB3FESJQsex7ZLvoMC5nKoDAL+rqlzY82+5Q4skoA==
X-Received: by 2002:adf:eb47:: with SMTP id u7mr7859201wrn.333.1633635887163;
        Thu, 07 Oct 2021 12:44:47 -0700 (PDT)
Received: from localhost.localdomain ([149.86.87.165])
        by smtp.gmail.com with ESMTPSA id u2sm259747wrr.35.2021.10.07.12.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:44:46 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v4 01/12] libbpf: skip re-installing headers file if source is older than target
Date:   Thu,  7 Oct 2021 20:44:27 +0100
Message-Id: <20211007194438.34443-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007194438.34443-1-quentin@isovalent.com>
References: <20211007194438.34443-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "install_headers" target in libbpf's Makefile would unconditionally
export all API headers to the target directory. When those headers are
installed to compile another application, this means that make always
finds newer dependencies for the source files relying on those headers,
and deduces that the targets should be rebuilt.

Avoid that by making "install_headers" depend on the source header
files, and (re-)install them only when necessary.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/lib/bpf/Makefile | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 41e4f78dbad5..a92d3b9692a8 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -241,15 +241,23 @@ install_lib: all_cmd
 		$(call do_install_mkdir,$(libdir_SQ)); \
 		cp -fpR $(LIB_FILE) $(DESTDIR)$(libdir_SQ)
 
-INSTALL_HEADERS = bpf.h libbpf.h btf.h libbpf_common.h libbpf_legacy.h xsk.h \
-		  bpf_helpers.h $(BPF_GENERATED) bpf_tracing.h		     \
-		  bpf_endian.h bpf_core_read.h skel_internal.h		     \
-		  libbpf_version.h
+SRC_HDRS := bpf.h libbpf.h btf.h libbpf_common.h libbpf_legacy.h xsk.h	       \
+	    bpf_helpers.h bpf_tracing.h bpf_endian.h bpf_core_read.h	       \
+	    skel_internal.h libbpf_version.h
+GEN_HDRS := $(BPF_GENERATED)
+INSTALL_SRC_HDRS := $(addprefix $(DESTDIR)$(prefix)/include/bpf/,$(SRC_HDRS))
+INSTALL_GEN_HDRS := $(addprefix $(DESTDIR)$(prefix)/include/bpf/, \
+				$(notdir $(GEN_HDRS)))
+$(INSTALL_SRC_HDRS): $(DESTDIR)$(prefix)/include/bpf/%.h: %.h
+	$(call QUIET_INSTALL, $@) \
+		$(call do_install,$<,$(prefix)/include/bpf,644)
+$(INSTALL_GEN_HDRS): $(DESTDIR)$(prefix)/include/bpf/%.h: $(OUTPUT)%.h
+	$(call QUIET_INSTALL, $@) \
+		$(call do_install,$<,$(prefix)/include/bpf,644)
 
-install_headers: $(BPF_GENERATED)
-	$(call QUIET_INSTALL, headers)					     \
-		$(foreach hdr,$(INSTALL_HEADERS),			     \
-			$(call do_install,$(hdr),$(prefix)/include/bpf,644);)
+INSTALL_HEADERS := $(INSTALL_SRC_HDRS) $(INSTALL_GEN_HDRS)
+
+install_headers: $(BPF_GENERATED) $(INSTALL_HEADERS)
 
 install_pkgconfig: $(PC_FILE)
 	$(call QUIET_INSTALL, $(PC_FILE)) \
-- 
2.30.2

