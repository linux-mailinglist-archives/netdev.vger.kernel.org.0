Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD9321BB4B
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgGJQtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgGJQtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 12:49:21 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC0CC08C5DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 09:49:21 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id s9so7194905ljm.11
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 09:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=stP8RfJLl8cG/oPOPdwN00kP/pwqU2VwqrwUA/Kdmis=;
        b=hl6nU0Ky2Jgpy4NZsVpiNcTRYGjTZyalyHcbe5G5uYHg9F5NRIBKXP3YNDqo/f9/iH
         2g/mEUwHs9qrKBBVMims/AhkEU76oMoN8WW8MCZq56tE/ljj4UQUfBN+rkafSN6LWgHc
         x/wUeUIpe+s8pXUcwREZzg+2KQemIh47yoBes=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=stP8RfJLl8cG/oPOPdwN00kP/pwqU2VwqrwUA/Kdmis=;
        b=WW5ASwZDZkT4Ljohra3+Q8UWRlmr9HNt1I1tmKs8COeRL7srhagkK6UAu3R7l6QYZ6
         uXeIOTd90QqE5XJOAoetHS3LXwBmIdGvCJN7KKVOtFIWYDRaYLVAoKwPsKLfzN08NoQf
         Vzv4FjT34hQe6ZHoIW/JlZFU0YcdgnxRR1LnfeRJNKjBBfL+UKKj8321MdQKLnzKHID2
         i4KjgXbgGTqvvGmxawHSFZQxtnHAWLFzDZc02/yJQHa5wryy3H6mk/A74j5mV2r4lOkl
         eRewbEXGRreTaoCrXxLaw4aj4JQrD6a+l3Qc5755H7k4ojp7ad3ADFs3furQhSYajeIx
         N6FQ==
X-Gm-Message-State: AOAM531jOeugrxYL/56IalXzE3C6OZcFHroTH65svt2kwMH4H8VVgPMY
        4xUjSFIIkuHcoCPmetSYWdRUSA==
X-Google-Smtp-Source: ABdhPJxtvPVv4i4Y1/NQcXgsz0lgc/78NlbWnPvs/4nqUFBoyIPpMzzePJNpgsL1o4H80OEI+UPLSA==
X-Received: by 2002:a2e:81d7:: with SMTP id s23mr38689254ljg.398.1594399759733;
        Fri, 10 Jul 2020 09:49:19 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id p14sm2344467lfh.32.2020.07.10.09.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 09:49:19 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf] selftests/bpf: Set attach type for CGROUP_SOCKOPT verifier test
Date:   Fri, 10 Jul 2020 18:49:17 +0200
Message-Id: <20200710164917.423125-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_PROG_TYPE_CGROUP_SOCKOPT requires expected_attach_type to be set on
prog load. Set it in the verifier test that checks if calling
bpf_perf_event_output() from CGROUP_SOCKOPT is allowed so that the runner
does skip it.

Cc: Stanislav Fomichev <sdf@google.com>
Fixes: 0456ea170cd6 ("bpf: Enable more helpers for BPF_PROG_TYPE_CGROUP_{DEVICE,SYSCTL,SOCKOPT}")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/verifier/event_output.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/verifier/event_output.c b/tools/testing/selftests/bpf/verifier/event_output.c
index 99f8f582c02b..c5e805980409 100644
--- a/tools/testing/selftests/bpf/verifier/event_output.c
+++ b/tools/testing/selftests/bpf/verifier/event_output.c
@@ -112,6 +112,7 @@
 	"perfevent for cgroup sockopt",
 	.insns =  { __PERF_EVENT_INSNS__ },
 	.prog_type = BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
 	.fixup_map_event_output = { 4 },
 	.result = ACCEPT,
 	.retval = 1,
-- 
2.25.4

