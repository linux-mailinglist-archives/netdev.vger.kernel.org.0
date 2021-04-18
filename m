Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31F036376F
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 22:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhDRUDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 16:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhDRUDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 16:03:30 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A61C06174A;
        Sun, 18 Apr 2021 13:03:00 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id j3so15949344qvs.1;
        Sun, 18 Apr 2021 13:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/3T7y9WNnZVrw+KXlkUiPbUTLLcEjroke08FHYAv/2Q=;
        b=fEfzrkvJxLN/+ywdBMUTM28GEelq9i51jLIV6NA/MatzkDTpIb1Tban3sf7blmc3QI
         Vg5vkgGAKI/VamhwHjfNw3LmLXBP6eeyFU7i7l61WeH5taZsvBhck6+WIZtt01/Hw9ss
         TTozIlu45xswP/8OQSTCGNvy8eN/2WtqWmhATnlmYrSk19Sistnz6zVvpExKtnNCHdJv
         8iGf5H4W6Ljp0EvBispPoF7fDtESEfS98Hoc/tb5oicO/EzPZTUEf1mc6dMilPqHpAHl
         Nho0FS4AHdBrKTvcVBoaVysBrTDcR7OOxdShziAkNrLZ1cR9FXS2EKs53QD07mLO6Ivd
         42sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/3T7y9WNnZVrw+KXlkUiPbUTLLcEjroke08FHYAv/2Q=;
        b=PrOR87+VHFAd9AI/899X+OjyFR1CJcpecjJsbAbBd9QX3t2zc4WbLY3yoOmUHEZUX+
         IqvnRSvx1i46WYOGAy8mzRMa2VvYSFAAkcKJkzIFcJW2pSq6z+0BdcqHbmhDh4UM7usO
         xYF2lom1bT/SXoQxQWWGf+X1QZdUu9dzBjD7H7V4MIrlZQYe5oePRD165E5Hp32KNTx/
         Twsmj3rF+lQThlVcxMot6RvNftSAuOrAppqltGXMXgJyMlTS/RMZ9mLIu1O3y9Q5m2YY
         17mnpF4VhfZrVmPDgg0qNrMg7sp9XUkszaqNXZxftF8uK1XSR1sBGwH3+JQh4yiQSXLB
         Wu/g==
X-Gm-Message-State: AOAM531AYvIRoT0rE1tYBndTqjHiB/Uo+jSiEUgGbQJb5eNPR1cXDAEu
        zV4psSNveRHJECQfH4m/nHgiuLeB72GS7922
X-Google-Smtp-Source: ABdhPJxY2IRQnVgLX3ZvtaGGsNI8JjroZqIaO1kZAWHrSy3chZh+nmOpIH9BtjlI1N4zshC7HCNKxg==
X-Received: by 2002:a0c:f1cc:: with SMTP id u12mr18344532qvl.20.1618776178684;
        Sun, 18 Apr 2021 13:02:58 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id x18sm7906225qtj.58.2021.04.18.13.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 13:02:58 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH] bpf: fix errno code for unsupported batch ops
Date:   Sun, 18 Apr 2021 17:02:49 -0300
Message-Id: <20210418200249.174835-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENOTSUPP is not a valid userland errno[1], which is annoying for
userland applications that implement a fallback to iterative, report
errors via 'strerror()' or both.

The batched ops return this errno whenever an operation
is not implemented for kernels that implement batched ops.

In older kernels, pre batched ops, it returns EINVAL as the arguments
are not supported in the syscall.

[1] https://lore.kernel.org/netdev/20200511165319.2251678-1-kuba@kernel.org/

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index fd495190115e..88fe19c0aeb1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3961,7 +3961,7 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 #define BPF_DO_BATCH(fn)			\
 	do {					\
 		if (!fn) {			\
-			err = -ENOTSUPP;	\
+			err = -EOPNOTSUPP;	\
 			goto err_put;		\
 		}				\
 		err = fn(map, attr, uattr);	\
-- 
2.25.1

