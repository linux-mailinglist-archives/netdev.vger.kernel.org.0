Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B6A435941
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhJUDrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbhJUDrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:47:40 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D83C06161C;
        Wed, 20 Oct 2021 20:45:24 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id n8-20020a17090a2bc800b00196286963b9so2104931pje.3;
        Wed, 20 Oct 2021 20:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=28QPdPbMM0S7NoiSQs1dCJ5bnkQ4h4CQgKgI92E1QJM=;
        b=qOz60AwTnCiKiUWe4HE41jrZ+BKODIChNBbP9NvsAV5cyHgsYNeZ+IfsChK6Do8ElD
         aJQEumMUjDSqyb/VMuMPAGxAsDORyieDVTA2f1x4Cpi8yvzQwAceSSXQYGOpV3LZObsk
         yDVtGeRN/boWfT5viVGTXpHOJo60nDwzDo/qD5timMFe1mm696m+TC2XRzcW3+7aHU4e
         VGqj+5fl9K8WcRyoL+0IdtJu8U1uKxMUoAwn7rc7k/L4FwB2Lmxb64g51H2Xr2BLMbF0
         WHxfe8my6XLrEDSCgP0IMBusVbEY1qR1jOd29A3HgzMtaszsKT1vbLlUd7d6rV+8EK41
         lUUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=28QPdPbMM0S7NoiSQs1dCJ5bnkQ4h4CQgKgI92E1QJM=;
        b=GXCrgBEoLtytDMaew5ipf3pujJOKZ+JvmgJF62t40wMOrKB0mUPYY57h2kXKNvzJM0
         k4X/p1ajI85M5OO/jsPt5K6hG5VgwXiF1WYdGugpdwes+Ol3w29iuFWcDVcpJhZcVUXY
         6gtuWEXkNiQihzeblGzpuF74TSyLWK5CdcTjXb7zyciK/GAJdQv3cSe8vOM//w4QyUMC
         tSOiEwKaTQSgW4dYccIyQ4wYnMTycVmlC8+2eGWl1MhiTwxAitslZgCUuICjgxZRRHvc
         u95zWKazL9aRpNFZO4QSMYxqajMZV22oLu9zoVe+Ko6uUtaT9lMLOpTFYMb/MDd5ZR68
         zrQQ==
X-Gm-Message-State: AOAM530B/4uq63R9jQTWLWlSr44llvm4TGp6FceS/E2A6Lcr1u41IfM9
        ISuBXfGpaBp5mcze6NU7nYA=
X-Google-Smtp-Source: ABdhPJwWBsB448ybVlkRj/zgX0cJ3bKycqnAj+2th0i2ArJsDGTY3F0BqghbcV/C/ZJwOtE6AUjtWw==
X-Received: by 2002:a17:902:f703:b029:12c:982:c9ae with SMTP id h3-20020a170902f703b029012c0982c9aemr3018202plo.20.1634787924373;
        Wed, 20 Oct 2021 20:45:24 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id bp19sm3651077pjb.46.2021.10.20.20.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:45:24 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     keescook@chromium.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
        pmladek@suse.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v5 01/15] fs/exec: make __set_task_comm always set a nul ternimated string
Date:   Thu, 21 Oct 2021 03:45:08 +0000
Message-Id: <20211021034516.4400-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034516.4400-1-laoar.shao@gmail.com>
References: <20211021034516.4400-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the string set to task comm is always nul ternimated.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index a098c133d8d7..404156b5b314 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1224,7 +1224,7 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+	strscpy_pad(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
 	perf_event_comm(tsk, exec);
 }
-- 
2.17.1

