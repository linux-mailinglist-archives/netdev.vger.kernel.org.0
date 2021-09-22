Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C4D41425E
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhIVHMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbhIVHMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:12:46 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F160C061574;
        Wed, 22 Sep 2021 00:11:16 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id a7so1168919plm.1;
        Wed, 22 Sep 2021 00:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=fqJ4jD5mx43TaWCX1BAu8izvsG0/WJf0Cf7cwh5yNDA=;
        b=OrPsNie/7vrJWG3sX0VWBvLZsHm34fXEpVcw3m41m+7XwhFaDkEXwlCPQcJKIJMJMH
         5RXsNa0bUU/p1BHQYgMCtg1khBkBBMpy8RDV8o9J82NP8BNDLnJOYCwmGU33VybSLT+x
         IaDtG9KQCEiSJpTjPeY6LCRGvPoeUGi93hVu3hIDprLIrGoMhSC/AdPo9VZEd5ZXbSCl
         Pw2WzcOPNT5dlsHE9xzBvx7/8/qyWaQB58nwjKNVAU/rTWEyZ+nbbR1O9ADSzOBqggG+
         R3+JWfcNgvys6L9mEzvzbDG511PpXV8QwXa0v7Biz8TWFcaqgOYig3J8IUSlB5oBlip/
         wJyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fqJ4jD5mx43TaWCX1BAu8izvsG0/WJf0Cf7cwh5yNDA=;
        b=7fIJ7xLFrmFwGXmD58PPKIF9jAQHcm1lyK5xeuv+KLaeero8alwQq+JVMxJoSHkFNl
         QFlRPvoYvHnrtYATTDoMmj1URRjoFwzhlldoaosvZ1SnB7ZQH2fnGNOpTuV7Zrx+ov/0
         gPdCXkiEO/vTtrit26lsHIA+D50W4jBYkP2YbEmQMaxUsJzT6QfJF1C02i3VUHHE2HHY
         nd6+taJpYfEzXBI+Qt4QvnUpltncicIr92OeOiz2rSuYQILjGLt4cFgzX5ITTTkLcEzC
         KR7qcL0hIPRilmCXn8o5hhq3JguT/h3q7QVZa6KEQ3ihXNUoIQCgIVHa9kYib7EIcKlX
         fEZg==
X-Gm-Message-State: AOAM531nESjmi8VoBbhBOknsF4jPlcyZQl6s1j0IOpvYS2gOK3NzEzY6
        TweNQQFXzNhSWxbeGJwcKLg=
X-Google-Smtp-Source: ABdhPJx3TcRLNegmOyiuTZhauFgE1xz+jJkrnv7g2JCh3p9OyG+Knr4sL0vwzkgfMvBBkYfcUbSg3Q==
X-Received: by 2002:a17:90a:1990:: with SMTP id 16mr9620620pji.11.1632294676110;
        Wed, 22 Sep 2021 00:11:16 -0700 (PDT)
Received: from u18.mshome.net ([167.220.238.132])
        by smtp.gmail.com with ESMTPSA id o16sm1497554pgv.29.2021.09.22.00.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 00:11:15 -0700 (PDT)
From:   Muhammad Falak R Wani <falakreyaz@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH v2 bpf-next] libbpf: Use sysconf to simplify libbpf_num_possible_cpus
Date:   Wed, 22 Sep 2021 12:37:48 +0530
Message-Id: <20210922070748.21614-1-falakreyaz@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify libbpf_num_possible_cpus by using sysconf(_SC_NPROCESSORS_CONF)
instead of parsing a file.
This patch is a part ([0]) of libbpf-1.0 milestone.

[0] Closes: https://github.com/libbpf/libbpf/issues/383

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 tools/lib/bpf/libbpf.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ef5db34bf913..f1c0abe5b58d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10898,25 +10898,16 @@ int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
 
 int libbpf_num_possible_cpus(void)
 {
-	static const char *fcpu = "/sys/devices/system/cpu/possible";
 	static int cpus;
-	int err, n, i, tmp_cpus;
-	bool *mask;
+	int tmp_cpus;
 
 	tmp_cpus = READ_ONCE(cpus);
 	if (tmp_cpus > 0)
 		return tmp_cpus;
 
-	err = parse_cpu_mask_file(fcpu, &mask, &n);
-	if (err)
-		return libbpf_err(err);
-
-	tmp_cpus = 0;
-	for (i = 0; i < n; i++) {
-		if (mask[i])
-			tmp_cpus++;
-	}
-	free(mask);
+	tmp_cpus = sysconf(_SC_NPROCESSORS_CONF);
+	if (tmp_cpus < 1)
+		return libbpf_err(-EINVAL);
 
 	WRITE_ONCE(cpus, tmp_cpus);
 	return tmp_cpus;
-- 
2.17.1

