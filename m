Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AC4578AE0
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbiGRTai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235948AbiGRT3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:29:15 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928CF2F67A;
        Mon, 18 Jul 2022 12:29:06 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id b21so6415857qte.12;
        Mon, 18 Jul 2022 12:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Y6DPpRFLDofGUL30b8+74GM4qwE4L2Zyq6sG1ZF6ebc=;
        b=dJrCdDdqoGBgCDi7uWoyd5h17sRa80Fs9GLm+P5DflfdZGuXJIVujeqX7lMRY06I8S
         t67bwzKyDstdRzhhUJT0vfUUmKANMlnUrNgw70sKglBzGUmW7C376hy4i3UQnjZifkek
         /9+PVCJu47AzGcSDT0BMA8vnweK45F4w3DfYiIC12NYsnjiEIPVVk5+271whtyjRYaNN
         N9ewHE3z8dFgGz8xroMMjlLM9s5XJQjkXW67JbGA6OgtOLqZ6+prLIpP2wjU2YHGx838
         2Rnf2t9y4v4gfPTyeAgE+qUm/m8zeflm6dFi7d626bdAey5662yUyGEU3mpx0x/jNXL7
         +mkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y6DPpRFLDofGUL30b8+74GM4qwE4L2Zyq6sG1ZF6ebc=;
        b=wP3GvDwFVRs9H7qvilG90HR6AhLNHDEI3Ycr/eTJnlFFRodczLlKLQEUG10y6tH+I0
         DJEiWk6pHoWhVVU0SwmnMnufq+CNxOP5qMA8WsvSbDrZDmQeBJTM7P7EKy+PKFD53Fv6
         tFha0hoP6UpOCJB2ZE3aVkOuA8e8zJ0rIwt8t53t3ZPjAjsreiFjUiMmvv21bz9kTsnq
         xliJ1ISaCQWGvb4d7BE+yiiuVA+0P6OhudhRnwO7/rJa10YS13aopyQJE5lP4HiXIdNU
         rgmZu1vtoFXPTLPStQCJceeGK5mrqSxGFYEBsXpDO5fi6jwfd7cO5HYcv+UoDoevWeM3
         If5g==
X-Gm-Message-State: AJIora8psmcXV9HAwuiLH0yCdAn75ZXcyaPfj8SShXWg0JVMJpEIV5QI
        LjsManDY5d9RlMCl2NxspXCk8rKoATnkwQ==
X-Google-Smtp-Source: AGRyM1syCvkoM65NB7O+4/9AZzHgi6k/66P3Xg8nH/ToRSp+ANBXlBuAKKOv4tS6vWWn7KIVfqErdQ==
X-Received: by 2002:a05:622a:1211:b0:31e:ba39:41e8 with SMTP id y17-20020a05622a121100b0031eba3941e8mr22777530qtx.189.1658172545549;
        Mon, 18 Jul 2022 12:29:05 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:1230:ab01:d009:465a:5ab1])
        by smtp.gmail.com with ESMTPSA id dm1-20020a05620a1d4100b006b5c87e9eb1sm11659333qkb.102.2022.07.18.12.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:29:05 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Klimov <aklimov@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Segall <bsegall@google.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ingo Molnar <mingo@redhat.com>,
        Isabella Basso <isabbasso@riseup.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>, Miroslav Benes <mbenes@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        Yury Norov <yury.norov@gmail.com>, linux-mm@kvack.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 16/16] lib: create CONFIG_DEBUG_BITMAP parameter
Date:   Mon, 18 Jul 2022 12:28:44 -0700
Message-Id: <20220718192844.1805158-17-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220718192844.1805158-1-yury.norov@gmail.com>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
MIME-Version: 1.0
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

Create CONFIG_DEBUG_BITMAP parameter to let people use
new option. Default is N.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/Kconfig.debug | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2e24db4bff19..cde1b5b7bb9d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -533,6 +533,13 @@ config DEBUG_FORCE_WEAK_PER_CPU
 
 endmenu # "Compiler options"
 
+config DEBUG_BITMAP
+	bool "Debug bitmaps"
+	help
+	  Say Y here if you want to check bitmap functions parameters at
+	  the runtime. Enable CONFIG_DEBUG_BITMAP only for debugging because
+	  it may affect performance.
+
 menu "Generic Kernel Debugging Instruments"
 
 config MAGIC_SYSRQ
-- 
2.34.1

