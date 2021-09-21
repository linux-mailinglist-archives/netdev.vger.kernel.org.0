Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C25412E7D
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 08:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhIUGG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 02:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbhIUGG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 02:06:26 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A5CC061574;
        Mon, 20 Sep 2021 23:04:58 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id z14-20020a17090a8b8e00b0019cc29ceef1so1203252pjn.1;
        Mon, 20 Sep 2021 23:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=0hrfuautjSsu8HUc15tPzwvjHVHf8IlFa6RtMmxHcxg=;
        b=B87f0IjTgIWrI7BwdLPIHCMDroen2ZoCFphLEUY+X/fWIeTS37v17v43kHEM4amJ2h
         Z0AMLODiBWJYvZ6S9//TwLJYtIfRBAEfUbIs5VQos46Pepmxltg6Bom1EfLO2zuIXAoz
         3nvNiKFNYhX/F7jL/hciS0TvwTZbfNGCmxe5Nmg+gS+xNj8OhkNtrR7stHlBy/aOkhol
         Z+vL5jKk4Rg3IdKDIsfRKu0JmJGoOzMBnhlhDT3Ox6E/Lxy1tP8Ys58fGu0f0BtkSt2T
         BQTSHtNOCDSSIMOHCnmMqf3iTyd3HJfx9CUnXAOP9VyUel9P/WPh/IGlxVRzJkY6dPKf
         q6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0hrfuautjSsu8HUc15tPzwvjHVHf8IlFa6RtMmxHcxg=;
        b=Mf/PUGQe6wkibqt06j3hBDDl8KSxtAPc8J54hKcYNF8RH7n1pv1OYdvX69/MTRJj71
         pJAOkAE58j9Uh+uzLtWjY7FLAbeH9YfplOE5JJjhyWh88iiElTgz0KN8j+oDtLksH6Ip
         oq6Kb99v6uX8gOgn8Ux8z1vmW0n5XqSr09pgLgt11KZmtnHX7gy1/sn0zMugFUvqmFnB
         /tLd7CpprCWd5rIbIjCkij7tstfQAjKjMgbJNucUuSGozlXZBZSV7aSWqTfFDP8DbxYy
         JxC5xFRCnz72m1p+GUMTrQM5tJKera61EM9N08Ca/BQGyhhZv004T+aZ9O3bdwiEDoRW
         Dr3Q==
X-Gm-Message-State: AOAM5315WCVBBekpqm3PrEhK5zKrDmpN/A7poi5AjiUKSjYZ4+97TOMi
        8KiyrKBR3V1VK4CxrnDxK1U=
X-Google-Smtp-Source: ABdhPJywZ1P6K5VK1vI4W8ivYf1n1wIa89I/qc3dh/evhIm5dgAPcFTveEqrUztxAH0Xv2JFjHbfsw==
X-Received: by 2002:a17:902:f703:b029:12c:982:c9ae with SMTP id h3-20020a170902f703b029012c0982c9aemr26103779plo.20.1632204298152;
        Mon, 20 Sep 2021 23:04:58 -0700 (PDT)
Received: from u18.mshome.net ([167.220.238.132])
        by smtp.gmail.com with ESMTPSA id x8sm15725900pfm.8.2021.09.20.23.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 23:04:57 -0700 (PDT)
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
Subject: [PATCH] libbpf: Use sysconf to simplify libbpf_num_possible_cpus
Date:   Tue, 21 Sep 2021 11:34:34 +0530
Message-Id: <20210921060434.26732-1-falakreyaz@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify libbpf_num_possible_cpus by using sysconf(_SC_NPROCESSORS_CONF)
instead of parsing a file.
This patch is a part of libbpf-1.0 milestone.

Reference: https://github.com/libbpf/libbpf/issue/383

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 tools/lib/bpf/libbpf.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index da65a1666a5e..1d730b08ee44 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10765,25 +10765,15 @@ int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
 
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
+	/* sysconf sets errno; no need to use libbpf_err */
 
 	WRITE_ONCE(cpus, tmp_cpus);
 	return tmp_cpus;
-- 
2.17.1

