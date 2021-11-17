Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A9A4546BD
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 13:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbhKQNAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 08:00:14 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:34570 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbhKQNAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 08:00:11 -0500
Received: by mail-lf1-f54.google.com with SMTP id n12so8074431lfe.1;
        Wed, 17 Nov 2021 04:57:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WNED2KobFnUBqI6hLcfqACMewJnIN8TxuO4SjWI5JVY=;
        b=C+j/LOWjMRQocC0tcCIwxMeunN+uVendBjKmU+TtLK87+8E0V8WjNnZ0DwRPCfKUEN
         bv+mfSGp2cWZNCiaUjlAQu6Cqg47ExyjUbPIQ5r5GABFP3TxU2mOhO0VXhXxgkxLrWzz
         8ZLDZa3qeHd+doz6B+xccV0F+UNguGlT30jwEQSLp07bLOM6WXUtCudOEY4F5FqY5/ob
         332ghfOQjQRSwtFRVL0JPQVrXmxEiZMTNBICkaD1nNrKuXY9T0R6Dx3JgeVpSDV1Jlp0
         W3LmpKrI2DkL0ZnJtm7T6ysOD6SOVM/wESxt+XbSRO0DxgS2eCD94EACqhJtxbLn3hgL
         hzZw==
X-Gm-Message-State: AOAM5328hi6y/oEq9rAPWPfqy0DwotzaWOkISghf8/51NI+phWUj0Lx6
        BKwLmhr+EmASICzI5mf88uk=
X-Google-Smtp-Source: ABdhPJwr8kM4BgxDnbXGiC8XOs55Pof7lOLuaa3wtO+lz8b4q0U5WyqdSFLdYMsc0M4cXtwa3Bs1YA==
X-Received: by 2002:ac2:42cc:: with SMTP id n12mr14691744lfl.31.1637153831655;
        Wed, 17 Nov 2021 04:57:11 -0800 (PST)
Received: from kladdkakan.. ([185.213.154.234])
        by smtp.gmail.com with ESMTPSA id n15sm2129109ljm.32.2021.11.17.04.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 04:57:10 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH bpf] bpf, x86: Fix "no previous prototype" warning
Date:   Wed, 17 Nov 2021 13:57:08 +0100
Message-Id: <20211117125708.769168-1-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The arch_prepare_bpf_dispatcher function does not have a prototype,
and yields the following warning when W=1 is enabled for the kernel
build.

  >> arch/x86/net/bpf_jit_comp.c:2188:5: warning: no previous \
  prototype for 'arch_prepare_bpf_dispatcher' [-Wmissing-prototypes]
        2188 | int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, \
	int num_funcs)
             |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Remove the warning by adding a function declaration to
include/linux/bpf.h.

Fixes: 75ccbef6369e ("bpf: Introduce BPF dispatcher")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 include/linux/bpf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e7a163a3146b..84ff6ef49462 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -732,6 +732,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
+int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
 	.func = &_name##_func,					\

base-commit: 3751c3d34cd5a750c86d1c8eaf217d8faf7f9325
-- 
2.32.0

