Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608424C5BED
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 15:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiB0O0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 09:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiB0O0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 09:26:43 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086FA4C413;
        Sun, 27 Feb 2022 06:26:07 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id u17-20020a056830231100b005ad13358af9so7544060ote.11;
        Sun, 27 Feb 2022 06:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XtcOHCEyJg+y9GSQcQnw2XHKSHRKVnl7usNqIe8wesI=;
        b=A5uotjcEKr2/S6NGCQgbuWkRpbgoqEnBTEDF7245x+TXI/rroZ+Ey4yvkr83kB4drX
         MHFXY2HD63260mSN4Te8hvwFaVvS0z4dHJcBebIbP0Td5oHaqc7VEVp+fmsM+4kBPtal
         Omjboiw+2mVCtfuaKYv6qtwl8M0ms14iRTaINWIqsE+wqog7UepgmmeS27CGLRmt08E5
         ZIvZB9EM89ZLh496KgegN4pZk9t72zlzfiOTrTkTNdvdSrVBsqU0kXfhk6JliN92zyYD
         cuhRNNhjSnzspizDchphCI86q8eu4dkNRCHb/Tldqv6KH8Q9X6N53pomSvpdI4dT7O4D
         2M8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XtcOHCEyJg+y9GSQcQnw2XHKSHRKVnl7usNqIe8wesI=;
        b=ssimIQWZ0jGOrb8a7mpPaix9wGafjcH2bQDUnAG7B73AM7yQP+aw2s/xe9ndJDrTPP
         GbjQ5vmQy4la1H/3nWOf1j7gfBFHkidfFCevyus7B74zLAGw5myMiKvU0KVPXgkr8KFR
         AevAYW+z2RgCSsv0nIJB7EDZIvdAxkgDg8D75NYxLGo9zY6BdgScHn7/Ou2osw5pmj8C
         wmevxpUwvn0DJPwppV8VfKJox3w8uompqfGgSng7WTpk36dyFd87PIQCm20oXfyb2wle
         uTogUO6E/EpnadlCMg8YqE2niMICPmZMd0Ihnwb2YMhqUpTCMgtk1QR5zfJamMGvhmEx
         UqRw==
X-Gm-Message-State: AOAM532hdEuiiE06bHROme+p6AOntj6c4dCaH+mwLDYblGd6yrU4FagX
        awVSPQhOcOWuiDVkXX0pEvM4DweAzLc=
X-Google-Smtp-Source: ABdhPJyXQDuVMAdoEmo0YW5OeNoWV1e08mmG/QK2EDl7ZbmN/SSoYiqrBvGSmM1+dVHYN6ke0/xZNA==
X-Received: by 2002:a05:6830:13d8:b0:5af:6e79:560c with SMTP id e24-20020a05683013d800b005af6e79560cmr6957795otq.188.1645971965893;
        Sun, 27 Feb 2022 06:26:05 -0800 (PST)
Received: from james-x399.localdomain (97-118-243-247.hlrn.qwest.net. [97.118.243.247])
        by smtp.gmail.com with ESMTPSA id 23-20020a9d0b97000000b005ad33994e93sm3791561oth.31.2022.02.27.06.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 06:26:05 -0800 (PST)
From:   James Hilliard <james.hilliard1@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Hilliard <james.hilliard1@gmail.com>
Subject: [PATCH 1/1] libbpf: ensure F_DUPFD_CLOEXEC is defined
Date:   Sun, 27 Feb 2022 07:25:51 -0700
Message-Id: <20220227142551.2349805-1-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This definition seems to be missing from some older toolchains.

Note that the fcntl.h in libbpf_internal.h is not a kernel header
but rather a toolchain libc header.

Fixes:
libbpf_internal.h:521:18: error: 'F_DUPFD_CLOEXEC' undeclared (first use in this function); did you mean 'FD_CLOEXEC'?
   fd = fcntl(fd, F_DUPFD_CLOEXEC, 3);
                  ^~~~~~~~~~~~~~~
                  FD_CLOEXEC

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
 tools/lib/bpf/libbpf_internal.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 4fda8bdf0a0d..d2a86b5a457a 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -31,6 +31,10 @@
 #define EM_BPF 247
 #endif
 
+#ifndef F_DUPFD_CLOEXEC
+#define F_DUPFD_CLOEXEC 1030
+#endif
+
 #ifndef R_BPF_64_64
 #define R_BPF_64_64 1
 #endif
-- 
2.25.1

