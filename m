Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC5E3F379F
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241072AbhHUAVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241013AbhHUAVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:41 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B372C061764;
        Fri, 20 Aug 2021 17:20:50 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x16so10015329pfh.2;
        Fri, 20 Aug 2021 17:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AXLMupxhaD++xArzk1nuaq7EWPa+ldn/upOYU4A2DF8=;
        b=ZiRBo7dUi+vU7LLVrGh4co0G9U+KRmNPM3pYl2c+ygXKySqG6/FP3dH1gNFI1SEPM+
         CZ8LMfj9zHd0953GKB+zNWKVhIKSpQeevJY6lRImhw82HtNElzs6ReZalzkC/HUHGq6v
         jPDVPsynOESddFbfGitvdq7L+8Z5UNecpYXAs5GQWtTU8Q3L+7t58hhll8SWAE+WuJMX
         dYAzQrSQi1MDV6rDbAh37MGGQnr+0cwLKRw136jYKMP0ShuBEfbxiikBUXSzKZSh/kov
         TU5pqQiI+UocVk7jak9j3PkFkY7dCLwQpf/g9cABA8dQAepSAb6zMATArlJV4d9rpaUG
         mQUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AXLMupxhaD++xArzk1nuaq7EWPa+ldn/upOYU4A2DF8=;
        b=P2fwyvdbnReQOyusC5dz/S9ciOONF1Js5z+6cGwxHmt/N7jIB5rWG+2G4UYBBG3Os2
         ZKqg0prIraygVHx52W1cI4gIdzgp519YGuArKyGl4OhIJu8NSnKOV0iIw8oqZVqMT+f9
         Rt9zto13zGoLnVIuHWO1QRnOxU+lbb+OBqQIBOuoI++MyCV30Sn4Nio5y/sKMLSG5pOH
         fFTZnGaX9PtT3KRrQW4vIxsZZo6VadKpd/eBCD4mzdHMWHLix/5ZhIULr/QacnyTLq8x
         mOaPjgRzaTvxLsriUISmlmmAmRg5TfAuuWCFb2rE4QYP6bpobvLMi3yQgyotcYVRn9GQ
         t17A==
X-Gm-Message-State: AOAM5329DVCMrfqh4Y19Lsbq0BiCgKEEQRGFJ1s/6pnA0gwvQt0wjDI/
        xZcceUh22Jv/rtNyjSnvvf87VJEw3dQ=
X-Google-Smtp-Source: ABdhPJzaW6x+vrZ/hdnZwDY7I9BqfUpUAK7Q5nTy6d0l80N1RNQAlj3U9NJH7W9whi+7AK+65PyxgA==
X-Received: by 2002:a63:1542:: with SMTP id 2mr20845308pgv.102.1629505249980;
        Fri, 20 Aug 2021 17:20:49 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id u17sm7955274pfh.184.2021.08.20.17.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:49 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 12/22] samples: bpf: add vmlinux.h generation support
Date:   Sat, 21 Aug 2021 05:50:00 +0530
Message-Id: <20210821002010.845777-13-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also, take this opportunity to depend on in-tree bpftool, so that we can
use static linking support in subsequent commits for XDP samples BPF
helper object.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 036998d11ded..ff1932e16bc5 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -276,6 +276,11 @@ $(LIBBPF): FORCE
 	$(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
 		LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(BPF_SAMPLES_PATH)/../../ O=
 
+BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
+BPFTOOL := $(BPFTOOLDIR)/bpftool
+$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)
+	    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../
+
 $(obj)/syscall_nrs.h:	$(obj)/syscall_nrs.s FORCE
 	$(call filechk,offsets,__SYSCALL_NRS_H__)
 
@@ -313,6 +318,26 @@ $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 
 -include $(BPF_SAMPLES_PATH)/Makefile.target
 
+VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
+		     ../../../../vmlinux				\
+		     /sys/kernel/btf/vmlinux				\
+		     /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+
+ifeq ($(VMLINUX_BTF),)
+$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
+endif
+
+$(obj)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL)
+ifeq ($(VMLINUX_H),)
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+else
+	$(Q)cp "$(VMLINUX_H)" $@
+endif
+
+clean-files += vmlinux.h
+
 # asm/sysreg.h - inline assembly used by it is incompatible with llvm.
 # But, there is no easy way to fix it, so just exclude it since it is
 # useless for BPF samples.
-- 
2.33.0

