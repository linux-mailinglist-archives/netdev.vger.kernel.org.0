Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A942B76C0
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 08:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgKRHRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 02:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgKRHRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 02:17:02 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE92C0613D4;
        Tue, 17 Nov 2020 23:17:02 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id b63so816755pfg.12;
        Tue, 17 Nov 2020 23:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gQiaQWe1AWIjaVTJuJBFgIAAz8j2qQ724nNHTwatFOs=;
        b=vSVKnliAxoFoUdps97fF/MjRhQ5PIHrwyawIWZd05AJfXApgPY82aNInmnvjBjmpan
         6g+i0/Qy6UGSRQM9zy54Ys6f9FmGP/ZDKsQt10DYxTrmAYZ6taCZ4pajYYSDIY1+jUwx
         Pegt0N08Y39QrbAhGCun5bB5P7uMiNcTp6oV8DGaZ+alPc1c2bNwwRn5bCZ6slXQPfOZ
         BztFvviYFyuc/xxH2DaLwDyWTiNRsmhq+jLiUlco0fyTEFyUDE0GPz3yM5AND2yAFaub
         jFOCBs9sTz8PblxAWALD5mnIDHFiPyxlPjiJTMBccppvhVs120jj5nx60ZJgNUUch1bY
         fFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQiaQWe1AWIjaVTJuJBFgIAAz8j2qQ724nNHTwatFOs=;
        b=qO3xfSo3TWnt/C5lvFTkHpJ6O8ZcBnbcZfuRCbQiPFP8t8TkovZk1WDraFpH9ecMQW
         DYtyK8Z1PDpNe8OUmmoFXVJn4ZFKmBS+I6h4WozMAQ0fZUymmGp0cNFt1Z2xgUXasF/W
         bDTVUEd6cmEmQP7XJP8eCOhP/HTLJJS93R+qAQRgGOqDhACKKvvEuSSJ5uL2JBnCci43
         da/KgUOBQupGxTJ1Cg2EB902KC1VNJJCLV84f+Myt+sZ1qPhTBFGVQCRlAc/MQEudkbZ
         HRhwFXyFWhwE4LEszbLGDCYjks3AX0pm5LvwnWMrUMb3GTJRy5NdbRnB9whNOZHRdNW1
         e9iw==
X-Gm-Message-State: AOAM533To9zW7U1x5r2TY7gxkE5ZbGC6odHLVvmxmLc1+CbXSC70TJ/G
        b1rPaxUnzkZ2I+20lKwi9c4=
X-Google-Smtp-Source: ABdhPJw2gtuOIRE7j9J06MAVlG7kUBMjmQwO7oGzFjqSilAEwDBsEPJYa2gm3i+uAcaI0ozD7n0IgA==
X-Received: by 2002:a65:684d:: with SMTP id q13mr7150124pgt.372.1605683822228;
        Tue, 17 Nov 2020 23:17:02 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id e128sm23019382pfe.154.2020.11.17.23.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 23:17:01 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        xi.wang@gmail.com, luke.r.nels@gmail.com,
        linux-riscv@lists.infradead.org, andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v2 2/3] selftests/bpf: Avoid running unprivileged tests with alignment requirements
Date:   Wed, 18 Nov 2020 08:16:39 +0100
Message-Id: <20201118071640.83773-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201118071640.83773-1-bjorn.topel@gmail.com>
References: <20201118071640.83773-1-bjorn.topel@gmail.com>
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
user loads a program. An unprivileged user loading a program with this
flag will be rejected prior entering the verifier.

Hence, it does not make sense to load unprivileged programs without
strict alignment when testing the verifier. This patch avoids exactly
that.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 9be395d9dc64..4bfe3aa2cfc4 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1152,6 +1152,19 @@ static void get_unpriv_disabled()
 
 static bool test_as_unpriv(struct bpf_test *test)
 {
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	/* Some architectures have strict alignment requirements. In
+	 * that case, the BPF verifier detects if a program has
+	 * unaligned accesses and rejects them. A user can pass
+	 * BPF_F_ANY_ALIGNMENT to a program to override this
+	 * check. That, however, will only work when a privileged user
+	 * loads a program. An unprivileged user loading a program
+	 * with this flag will be rejected prior entering the
+	 * verifier.
+	 */
+	if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
+		return false;
+#endif
 	return !test->prog_type ||
 	       test->prog_type == BPF_PROG_TYPE_SOCKET_FILTER ||
 	       test->prog_type == BPF_PROG_TYPE_CGROUP_SKB;
-- 
2.27.0

