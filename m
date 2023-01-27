Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DE567F145
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 23:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjA0Wkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 17:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjA0Wkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 17:40:41 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180A917CDC
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 14:40:40 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d3so6379427plr.10
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 14:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mi0d+CK+M9Cvpo6kBCt8Dw5Bmq3VTlMl6FYmGH90jCc=;
        b=SWi4IP4iJzGDXBWt0eLnZKja4pxNbw1GBNz6X3Ff5JYUOz6sM8/8YMzzGuQ7mKbPoP
         PjGze6exSSVRpuuWgjNhtiQB7Rw8FMdJNztT1g1ohE7W8jzXaPzoAP0kO13w+83rVnCb
         vNt+mgwdbGbaLSRT9qjJSvWE2w3cqoWN1+d9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mi0d+CK+M9Cvpo6kBCt8Dw5Bmq3VTlMl6FYmGH90jCc=;
        b=OGLSYuxVF/TgmmrBApxnyQFj2i+HXfB6Jqv8TAbs7H7fGzB9C7Opxy+hExvY02lg3Z
         nsDgStuSklDyvpc/q1qaqBuYDSFspsALRzyNy0KIuGtVJbIzVd2fkMDDZfejbrKAlmx2
         lgooUeFfqQwkfRUw/NqgWi+O5f4GIWIGYLLOyU/hMSNf6nFogoGDNEDmTrVzrdzqfSUn
         0NEnFjm4nF1V9zPGQZFeTzwtg4dY9Ai8KIpNH4pp14EsaQoqQRc57nf7QpT7PUjkie50
         BqY2TDrR710m1I5H+NNzp3bZlmVMaTRUIeJ9Ho2g9gRYKVgOElGw4mDz0vPwM+pvttJl
         h+hw==
X-Gm-Message-State: AO0yUKU8waXEGJZrru9XPcX78R297YXDWBjekgGKcjqi36I6x0zY+H6J
        uj++D7IXI2DHwPlpzgoMB24tmw==
X-Google-Smtp-Source: AK7set+q5CdJ/pPq/o3RZgrDnqZei+2XK5PIfAZ51Qfg/mMdW4DXRyQLmam7r2hfP7mQ+7Zfmua7vA==
X-Received: by 2002:a17:90a:1e:b0:22b:fb91:5719 with SMTP id 30-20020a17090a001e00b0022bfb915719mr14252488pja.3.1674859239533;
        Fri, 27 Jan 2023 14:40:39 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l24-20020a17090ac59800b0022c25153cf0sm3207170pjt.44.2023.01.27.14.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 14:40:39 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] net: sched: sch: Bounds check priority
Date:   Fri, 27 Jan 2023 14:40:37 -0800
Message-Id: <20230127224036.never.561-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1664; h=from:subject:message-id; bh=WznqTvrhU7T7Q9mp7lRgEZijP0sAnDxdFOd42SzPeos=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBj1FLlF2NTJvQnZwGxxYtNjelPsiP82tCH++9g1CN1 mGXGd46JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY9RS5QAKCRCJcvTf3G3AJrMJEA CfNHygMLN8AV7Bx/StJG002yhinvS4PXc7hKsxEqGhQiMVumnsc+9dQc7quTYRD43El3kpsU37r0FF jMdibMOxxlg0IrgaC+OrvCMZj2Lgg31K0pRLjdYbDCVrSyzgdoMlVYOZXd5/IrilnZQ/r8VJHUGgjQ 2Dy0KXxSJlZGqub1Ce2WRglWV5oyBO2igbspm1/uHEF2LQBK+wkklhjL+CnTRh/CkX51qWW5GH0rOb WaBpy46IRnvVHBQO1lGyT/Cft6JNSMdVwgsUbcgsMo/BdKiFbZtjCQ4HCShR1tJRp9BvUY8nLvO/KT NTCU7r4GD9Ovvxxo+GlvXdeOnv2FVwRqB/d4gvBpfnubVY8y8wF70aG8rBA2Ms7EPQuzsp+f74ft25 tvEwGuPc5mXRpYYDodN6ylfnKQYglZZrh3mya//01067lgs5/u3Nfd/iksrEg+RjVhUh+trQEEiDkd JatLvYKbw98tHkyzO2TYqHBERJsx6lPkiJpVk8UnM4Or7FvD0v9FMQFtSBMwRA3yelpqPG1NbWG1G9 MBALYc+yZVrujekUErIpM3B08O3qlyNnejkCbohiUQNdmNixK60P8L6iWj1KB/0SNn8vX6QmhJCee1 RsiGCxaRcss4+ZdtDufmyrSSoaeGT+hhMBHA9A+B9RzUePU+pw8v7MtHB3cg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing was explicitly bounds checking the priority index used to access
clpriop[]. WARN and bail out early if it's pathological. Seen with GCC 13:

../net/sched/sch_htb.c: In function 'htb_activate_prios':
../net/sched/sch_htb.c:437:44: warning: array subscript [0, 31] is outside array bounds of 'struct htb_prio[8]' [-Warray-bounds=]
  437 |                         if (p->inner.clprio[prio].feed.rb_node)
      |                             ~~~~~~~~~~~~~~~^~~~~~
../net/sched/sch_htb.c:131:41: note: while referencing 'clprio'
  131 |                         struct htb_prio clprio[TC_HTB_NUMPRIO];
      |                                         ^~~~~~

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/sched/sch_htb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index f46643850df8..cc28e41fb745 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -431,7 +431,10 @@ static void htb_activate_prios(struct htb_sched *q, struct htb_class *cl)
 	while (cl->cmode == HTB_MAY_BORROW && p && mask) {
 		m = mask;
 		while (m) {
-			int prio = ffz(~m);
+			unsigned int prio = ffz(~m);
+
+			if (WARN_ON_ONCE(prio > ARRAY_SIZE(p->inner.clprio)))
+				break;
 			m &= ~(1 << prio);
 
 			if (p->inner.clprio[prio].feed.rb_node)
-- 
2.34.1

