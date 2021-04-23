Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD62F3689C6
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbhDWA1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240003AbhDWA1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98338C061574;
        Thu, 22 Apr 2021 17:26:54 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u15so15836481plf.10;
        Thu, 22 Apr 2021 17:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uzQAZWsX9E5409TYCGMlnvV9BYjzTAVLAHg7HgwrNw4=;
        b=qm5ePVCR3qL+AiVND9CQCdnkdk3+8hSO1fx6W2bjORnnRVAbJXvoPkEkZiFoW/Ad4Z
         uHNsfyiCQkvYytE5fVtmXuonsNzxcMjr5U+ttd9FzM/4xYDTOgnzzNGSo9jBfLlUCMKV
         vKU0quQW1uPSUsMyCRpbtxQ5+TMtAz22tJN4meU1BpAD+azMSXxyvydnXoCxvYLRaPee
         EDV5l0fyGdDWxmRr+nSQIM9vb34bX+wkV3DcguhV9WXtfXLvVyfJBel4lWpm1UwZv3Er
         Dc/raVcXD3/aDda78hyy/QFMZWT0evOoXJ2i7miJNF2MELzLJOEQqG7xmE36iCVx3niq
         62BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uzQAZWsX9E5409TYCGMlnvV9BYjzTAVLAHg7HgwrNw4=;
        b=j+8uOZoXSFNbHK7j6ryT3rlVTt71WSrXc8Q29UUuPDmQfXTB3DphabViq9gLhp/XUk
         VLmS7qGsxhFrQj2xiuEYztmypfVlRG8JAclo13PZ6VllzD0h+88qX0XC4RQkTX5u8Jqa
         YPYLxDi6J8JXQUKqXwtE/BWdaRzWKggfRlgRquDhOer6wZu6LNypY9o8Zf994COgqUR6
         FVLc7j/KDioYOtKUCc7cSL0jh65YUQT6B7Wt1DRPWslZYybwt9+ijSFMKZAJM5wrflO9
         e1cBSxu1ynWaJyvLYzuTCVR/Hx3J8mmVZ7WQv6ZFZjKGQF1HsU2YVOZf1EnhsWnLzeQP
         xpOQ==
X-Gm-Message-State: AOAM530WYYYUxFMopYAccWzZnHdio6miVNuzNOj4fqdjFzdsIN/dTosx
        m4foW0k6OuDJPCC2RGZxQBY=
X-Google-Smtp-Source: ABdhPJwNFRU9yTuJEntSrA2XrM6a7Medt1xwfwsfkzxhLEgU8I7qgYSEJLhdDRscMdBwyBhwpvlG0g==
X-Received: by 2002:a17:90a:6b4f:: with SMTP id x15mr2750523pjl.227.1619137614248;
        Thu, 22 Apr 2021 17:26:54 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.26.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:26:53 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 04/16] libbpf: Support for syscall program type
Date:   Thu, 22 Apr 2021 17:26:34 -0700
Message-Id: <20210423002646.35043-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Trivial support for syscall program type.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/libbpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9cc2d45b0080..254a0c9aa6cf 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8899,6 +8899,7 @@ static const struct bpf_sec_def section_defs[] = {
 	BPF_PROG_SEC("struct_ops",		BPF_PROG_TYPE_STRUCT_OPS),
 	BPF_EAPROG_SEC("sk_lookup/",		BPF_PROG_TYPE_SK_LOOKUP,
 						BPF_SK_LOOKUP),
+	BPF_PROG_SEC("syscall",			BPF_PROG_TYPE_SYSCALL),
 };
 
 #undef BPF_PROG_SEC_IMPL
-- 
2.30.2

