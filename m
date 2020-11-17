Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427462B5AF2
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgKQI1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgKQI1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 03:27:06 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206A8C0613CF;
        Tue, 17 Nov 2020 00:27:05 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id t18so9861155plo.0;
        Tue, 17 Nov 2020 00:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4RoQLFT/+eItTFwja6y027jS+o5vx3tn2+htvfb2XHI=;
        b=F/JGC0VADO/Zkv17DSC1GpV8jvX6fOTghRA7nki52tR9Bvi9uy666TwzjJsxx0nD4A
         EEuPltsjDVJ8otN1fS/idx+z49ZybWtexgfmTcCL6WLufsl8d1viun33dYPO22wfW7z+
         C94awmkBY0tOqczBNpMBcp9N+g0i1LJ7LxzYH0gJkI7hPUqgUYbN4UBEuQG3nzJnrXn6
         p7puBQ6ZOIWcuXtTTKmsEAEXwwhWQXvTsFtGo32CznUIhoHaeHSd7NB1Ea/3zLv3dUT4
         Vpta0jVsHA2cOtpkUb//dOV2r6keIv2kPdg7j7W4WXVp3wtYYbPlrdO6OKC/EabDOcSA
         iYmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4RoQLFT/+eItTFwja6y027jS+o5vx3tn2+htvfb2XHI=;
        b=ohw2EJEtmqtbhUSv2rY23W8LrF3hWY9AGF6UFZ1AsOPihTtDJUpd8EzDktqYOrGZZm
         D8uyqefk78bkK6YEznrVkESOo3KXkw4p3ThvHO83C/kjtBqwyms8DG3GbhJJjCNUa7rn
         dmlFCUFOR8yqj8s9No678USC8AvMo41XTybvgIrWapztJtABQUImTMDvsiz2OWEeWXSG
         Ykpdl1ZnvqUstBqinCEw0tZxsacm1PPOA62lzvN2iqGtTsQ45OjSs6Z/GSxSph+8MkXF
         lAvF4trqIWDpPzSK5oLrsmKy4vcVaAOdrrhRJ3PeYwSnulpxukf2BfXiFCYC2xavtYDl
         V1OQ==
X-Gm-Message-State: AOAM533jiniTP0ABsCIHiWnL/btnTfew6gFjihPb6gCNsuy9YM9qwrBf
        LtjNj5ErUOqWK46IQRKQHMM=
X-Google-Smtp-Source: ABdhPJzqgTFOxPVF4aRIqK+S7JI590qSI1cXqhmcFDMyexvmvVG50FTocYDPRQKCwW2vNkmhOQ20bg==
X-Received: by 2002:a17:902:9a84:b029:d6:eaef:4806 with SMTP id w4-20020a1709029a84b02900d6eaef4806mr16375125plp.82.1605601624721;
        Tue, 17 Nov 2020 00:27:04 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id c12sm2251671pjs.8.2020.11.17.00.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 00:27:03 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        xi.wang@gmail.com, luke.r.nels@gmail.com,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next 2/3] selftests/bpf: Avoid running unprivileged tests with alignment requirements
Date:   Tue, 17 Nov 2020 09:26:37 +0100
Message-Id: <20201117082638.43675-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117082638.43675-1-bjorn.topel@gmail.com>
References: <20201117082638.43675-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some architectures have strict alignment requirements. In that case,
the BPF verifier detects if a program has unaligned accesses and
rejects them. A user can pass BPF_F_ANY_ALIGNMENT to a program to
override this check. That, however, will only work when a privileged
user loads a program. A unprivileged user loading a program with this
flag will be rejected prior entering the verifier.

Hence, it does not make sense to load unprivileged programs without
strict alignment when testing the verifier. This patch avoids exactly
that.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 9be395d9dc64..2075f6a98813 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1152,9 +1152,15 @@ static void get_unpriv_disabled()
 
 static bool test_as_unpriv(struct bpf_test *test)
 {
-	return !test->prog_type ||
-	       test->prog_type == BPF_PROG_TYPE_SOCKET_FILTER ||
-	       test->prog_type == BPF_PROG_TYPE_CGROUP_SKB;
+	bool req_aligned = false;
+
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	req_aligned = test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS;
+#endif
+	return (!test->prog_type ||
+		test->prog_type == BPF_PROG_TYPE_SOCKET_FILTER ||
+		test->prog_type == BPF_PROG_TYPE_CGROUP_SKB) &&
+		!req_aligned;
 }
 
 static int do_test(bool unpriv, unsigned int from, unsigned int to)
-- 
2.27.0

