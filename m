Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651266BF24B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCQUTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjCQUTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:19:44 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888A213511;
        Fri, 17 Mar 2023 13:19:41 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id ix20so6516794plb.3;
        Fri, 17 Mar 2023 13:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679084381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ixtplnJ1knk+7+mvFxZ3DGrp1i26A6gmObViNwYENi0=;
        b=OnaUNDIoPkA27oKj0zLHLo7oUXb0LQu0ub1mpJi4fa/uSN+DHkf8umcTnFtw3phnwo
         6CtlANkPHEjCVnAdEpt775L0k3apMEjICaYKFPZGMkRi4c98kLoWqfgYfQvL2bEjR0I6
         SzvkmzoQ2bJmmRFWxTq2doQp1uB66aJ2Ww5awFb9t8Jx48twTD36PCtY5buqNitlLfZB
         l04FDgI56jt86igLrqeVGwoh9e29qfXF+0x7BUHlcNxpBygjCO41GoZ/6qqPvLiV9mZW
         WGIzLZEH+ikdnbD9Xx3Ggpc5Q9zApx6g8Sy1OxtVqXitOlE4IPeIUizNXpE94F1qTqx/
         fJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679084381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ixtplnJ1knk+7+mvFxZ3DGrp1i26A6gmObViNwYENi0=;
        b=Qx774ywx/c2dFXJCGA+asCXTBdK7Jos3sIIWkzSECTrcvIXkmhuFpCAUfs35FhadPZ
         qbPXtBiSSAyUx1yd9vtanIlthH94MFK3KpkycHnmFbUt9zUSYoOLW0Tw2XTugVquxUPk
         AEXp7r20Sgnvme0oJ9k+2US1j50FLfNM9WImbyk8P7Rdrb8DzlG66B4Q01ADxVNmUJzM
         VOW7ZuImyWGzZwSMJZLbre8WKN8t163B83vKwDmql9ABXrkQ25kMEhp2jqHLX9832+xe
         +EnvsKijrbR2pWdbn7WWGIm4Bkrnqe/oFKwfecNE5qPKPTaBtBIiHqpzXBJUmgEwbMF1
         WrCA==
X-Gm-Message-State: AO0yUKVc708Urzt3Zp/N1yo7mvWUuvtj/X5xgxRzYUKyD/aA4DmUOchO
        SJCmt0neUcRJxPFkxbe0omQ=
X-Google-Smtp-Source: AK7set/H1xf3NCZFp/2Gw5oKu6Gw+bapcdqigIrfbCgPchvYGpAjvd1rsBY81Y4VgwGeS/vn5N0FFw==
X-Received: by 2002:a17:902:e38b:b0:19f:3b86:4715 with SMTP id g11-20020a170902e38b00b0019f3b864715mr6861037ple.8.1679084380795;
        Fri, 17 Mar 2023 13:19:40 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:2bcf])
        by smtp.gmail.com with ESMTPSA id l9-20020a170902d34900b001a064282b11sm1927976plk.151.2023.03.17.13.19.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 17 Mar 2023 13:19:40 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: Add test for bpf_ksym_exists().
Date:   Fri, 17 Mar 2023 13:19:20 -0700
Message-Id: <20230317201920.62030-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230317201920.62030-1-alexei.starovoitov@gmail.com>
References: <20230317201920.62030-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add load and run time test for bpf_ksym_exists() and check that the verifier
performs dead code elimination for non-existing kfunc.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/progs/task_kfunc_success.c  | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/task_kfunc_success.c b/tools/testing/selftests/bpf/progs/task_kfunc_success.c
index 4f61596b0242..cfa7f12b84e8 100644
--- a/tools/testing/selftests/bpf/progs/task_kfunc_success.c
+++ b/tools/testing/selftests/bpf/progs/task_kfunc_success.c
@@ -17,6 +17,10 @@ int err, pid;
  *         TP_PROTO(struct task_struct *p, u64 clone_flags)
  */
 
+struct task_struct *bpf_task_acquire(struct task_struct *p) __ksym __weak;
+void invalid_kfunc(void) __ksym __weak;
+void bpf_testmod_test_mod_kfunc(int i) __ksym __weak;
+
 static bool is_test_kfunc_task(void)
 {
 	int cur_pid = bpf_get_current_pid_tgid() >> 32;
@@ -26,7 +30,21 @@ static bool is_test_kfunc_task(void)
 
 static int test_acquire_release(struct task_struct *task)
 {
-	struct task_struct *acquired;
+	struct task_struct *acquired = NULL;
+
+	if (!bpf_ksym_exists(bpf_task_acquire)) {
+		err = 3;
+		return 0;
+	}
+	if (!bpf_ksym_exists(bpf_testmod_test_mod_kfunc)) {
+		err = 4;
+		return 0;
+	}
+	if (bpf_ksym_exists(invalid_kfunc)) {
+		/* the verifier's dead code elimination should remove this */
+		err = 5;
+		asm volatile ("goto -1"); /* for (;;); */
+	}
 
 	acquired = bpf_task_acquire(task);
 	bpf_task_release(acquired);
-- 
2.34.1

