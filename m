Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37021362D45
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbhDQDeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbhDQDdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:49 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFDFC061761;
        Fri, 16 Apr 2021 20:32:33 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id b17so20457004pgh.7;
        Fri, 16 Apr 2021 20:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uzQAZWsX9E5409TYCGMlnvV9BYjzTAVLAHg7HgwrNw4=;
        b=AG8aTiLeZJ51iNLRHWvZCVtZbWcO2FLHwD1BUiOy4YLbs2wv1dOFRi8LfElp+MJC1t
         V1pRuGpZoS8w9tHIGLge2eGk9QIrhjYi81S1IMWfW3srcuINWzZxuRyrfWtXjLAvoXTi
         KPY3F6nC5Sg70kPjSWQYfHhBvTG9+cDFyhZ/rCybtWDKazD8F7K2YbwULcZ3iLsgmXVG
         Pw0PVRELOhlOgJwLzmSYKhelo79jfOXiAAXWQjrqUjfgf4u3QkbBKHJhZb9noeahtuvD
         h2CqnAf7MXSYN9lvNJm5INT8S6W9zFrk1tunsI+KuQsKr+W3DClSRjGnDbfJO7GTO0nR
         DtFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uzQAZWsX9E5409TYCGMlnvV9BYjzTAVLAHg7HgwrNw4=;
        b=J4bDuW6ktFFaPErSbbqU+SSS5IyiTylGxywDYIruF0gz+P8AAfShx4D49sEdLf7HAi
         KkvRsmIUAQyHe+sU2bUtOvxfsELIrxS67yZT3SC1Y+GJUrmMP3fYxxHnQVRnkX6x2VHz
         b9UT0JZNsDpKu02iWBG3YVN7hPm1CxmbVo0S+wMkgGQJrJF0srFe1fsBfOQJ2NlGO3vp
         z0foaB1qX9PBGjS4oQfpWorvixPkjMauoNfwjcW9KJV7FyKyPmmk490Tynz2XrNIqIs6
         hFPzEq6Ruy4hD5ClpaIzgK7Y/br4OhLwsYtfqw2RDVlRV7xa1a1mQjFEyodWqZh9uEJ6
         o0Rw==
X-Gm-Message-State: AOAM533wu+VIcXXr6M6+ELGjPP9CkPAX7wdKrEmZx7F0ooc3ro0QiIVG
        jOpN81lN4jEIhBnnJY/fcGw=
X-Google-Smtp-Source: ABdhPJyX2v1+KXeD5uVBVbDSwlhOLm98D0TamBBJE9Tvo2HHFGpMvEHqbukxKm3YNU8V5Mo/6bHk6Q==
X-Received: by 2002:a63:151e:: with SMTP id v30mr1812919pgl.366.1618630352489;
        Fri, 16 Apr 2021 20:32:32 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:31 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 04/15] libbpf: Support for syscall program type
Date:   Fri, 16 Apr 2021 20:32:13 -0700
Message-Id: <20210417033224.8063-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
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

