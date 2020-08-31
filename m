Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95499257ECD
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgHaQbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHaQbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:31:35 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D506C061573;
        Mon, 31 Aug 2020 09:31:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k13so3269574plk.13;
        Mon, 31 Aug 2020 09:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mWbYzygrl5L+yAeSGJzwnWQOlRihnkNDYqJe/AMRuTY=;
        b=BmpYpM9+py7v0UcILGsXWlB1pYEusrDMf7NkuPgstGRFpSzVqr9UmApyqNyrJm13IR
         TJQkq+fbLsw3xrDof49posClFQIU/Nj9XCUtbKIxys5Q+49/X4uoZg3Id1ku4VzYm++c
         oM5+H/0ovmXd1jxqj1vppFB0lsa379MerMRgtZXeqgbO/2cBlLwWoIxyBrUgq5x73YdQ
         dALBE5m+euw8AvRhWVIhN2BrO3mHCAiKKOWYUfmOs6WYWjqy6L59Dae8Chsuq+svPWPa
         YYKmNeB8nYh8MwZg3g63EJmiOtq0eNjGYBN44O+7SYLjIDz/MwCDRw7HuxRQBoeNmhuL
         twlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mWbYzygrl5L+yAeSGJzwnWQOlRihnkNDYqJe/AMRuTY=;
        b=EspNVH+LXnymBx1bGgoV5yZD4D41hAXYTtZuqhNnJNYRa1tf5eKKwQbiSAx3HjDLGF
         bJhYePlgaaLbrOBHHZ7Qp7PO0gENgy7XPST+okRH/s+MnervT6MSge+tWCvTkZY4c91V
         llPlJPt8fSL8dTHp2J1YQCwz4i6PW3xTxbCK+/6NEtBiF0nJli9Cz09cRaZcbUP8Ed3v
         rOJ5S0l6NFd/RJFtH4shiE4fBZDKb48Va+uceJjGCbJJKsD9grgFntTXSizdVjHqK2/H
         zgf+ky2jn01Dy/VaWTG10m8Qpcqwn3x8yvyMp0KC0Ia5snBZFnczuIcqWi3Cj3pCKClI
         CqDA==
X-Gm-Message-State: AOAM533Ckcl8ufEIVpGAAwAD1uNUQuKf6zwz6TwcBy+UVbj2oLpSbRZi
        cxCZcApW2HLNZ50oySYoq1A=
X-Google-Smtp-Source: ABdhPJxikv1GuVMZAKMkZh0bPjOCWOpEHSST57O59d86Qfzc7IsaYefjnS/THjuiJSkxb+8ROlu1aA==
X-Received: by 2002:a17:90b:18e:: with SMTP id t14mr171647pjs.69.1598891494907;
        Mon, 31 Aug 2020 09:31:34 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id v22sm8547627pfe.75.2020.08.31.09.31.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Aug 2020 09:31:34 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, bjorn.topel@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next] bpf: Fix build without BPF_LSM.
Date:   Mon, 31 Aug 2020 09:31:32 -0700
Message-Id: <20200831163132.66521-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

resolve_btfids doesn't like empty set. Add unused ID when BPF_LSM is off.

Reported-by: Björn Töpel <bjorn.topel@gmail.com>
Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3ebfdb7bd427..b4c22b5ce5a2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11008,6 +11008,8 @@ BTF_SET_START(btf_sleepable_lsm_hooks)
 #ifdef CONFIG_BPF_LSM
 BTF_ID(func, bpf_lsm_file_mprotect)
 BTF_ID(func, bpf_lsm_bprm_committed_creds)
+#else
+BTF_ID_UNUSED
 #endif
 BTF_SET_END(btf_sleepable_lsm_hooks)
 
-- 
2.23.0

