Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C650119CEFE
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 05:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390390AbgDCD7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 23:59:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35952 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388951AbgDCD7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 23:59:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id c23so2891374pgj.3
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 20:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1AL2WwMB5oCGPA1dRaR0rUrfUG8Re9VpielHeMMBHPw=;
        b=O8nqgsG15U0TtkBkWlSHgRgf+zmGBOW++0mnT5aa8EQcjSnpf8F+HAClxfdwTHCxAE
         iTgQLoGs7To9XDfZoto2KnxeI7EcBvzkCKn8d4minNMN+W8MgSkkT9XQ9phiFHScyqKj
         GSymMkz78pDGTKP0GQkIEoCmoRVVP1EsyDeaV7pDVUt/RHJrfJtt6gYSaICpeM8QwNne
         uaCWE8kv8uFe/fowVsLNEaIZApEy+R5MA+NG16fkas0BLlrThzP5ZOSJp6nDQ6wCTI95
         qX4Uhc0hZDkhGlbqV3NpiZwtD3Ik75qJIdDJn5OOAUhzwnNT2arym6GpKjE1gvzQ0uIv
         8J5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1AL2WwMB5oCGPA1dRaR0rUrfUG8Re9VpielHeMMBHPw=;
        b=EsJBB7FebVfrYQDaofhePqufsbk/7tPyVHAPbyw9LFDfBE3PCV/7nFN/8f1ngJaqzL
         HlYkjBBgFxobQxUWTwPsr3WuGRvQlsUMGH/m5P3nhUk78WRJSnxKcT2s/JxwyVelawBK
         Va9nkSIGLeBXUDl2Q6JEm72uufscitYsNuKNhHuzl/pDC1bABAuR5J4DU6auaxdiWf7A
         1i75eaJ4VE1Yo07K0Qh7qu3AyDfZX6PBoQMbiVqSxhdnVu5YojoIUrkKmvvjJ0I3qmWz
         8Ss726dD0ijdcqyBEozx8Vu4hc538mJ8+ltN94vEia3bdsvpwf+b5hVxXuLQ3XKDQHRG
         GarA==
X-Gm-Message-State: AGi0PubFoZ5ptebVfAlymKMeRPz0idr40rToJ7WgKFLUY7NgmMWNWJtg
        0+SLrjeXQlH7050FVXcsetfCw8aok0c=
X-Google-Smtp-Source: APiQypI1QbGhYN9fI37M1P8Uvk55adX/8Rta6m4JGKo/EGYD1S7IcQhE5Fs7sFUFHZzItwnIgr9Ylw==
X-Received: by 2002:aa7:96ae:: with SMTP id g14mr6293016pfk.216.1585886356320;
        Thu, 02 Apr 2020 20:59:16 -0700 (PDT)
Received: from tw-172-25-31-169.office.twttr.net ([8.25.197.25])
        by smtp.gmail.com with ESMTPSA id 1sm4767136pjo.10.2020.04.02.20.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 20:59:15 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+8325e509a1bf83ec741d@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [Patch net] net_sched: fix a missing refcnt in tcindex_init()
Date:   Thu,  2 Apr 2020 20:58:51 -0700
Message-Id: <20200403035851.31647-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The initial refcnt of struct tcindex_data should be 1,
it is clear that I forgot to set it to 1 in tcindex_init().
This leads to a dec-after-zero warning.

Reported-by: syzbot+8325e509a1bf83ec741d@syzkaller.appspotmail.com
Fixes: 304e024216a8 ("net_sched: add a temporary refcnt for struct tcindex_data")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_tcindex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 065345832a69..61e95029c18f 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -151,6 +151,7 @@ static int tcindex_init(struct tcf_proto *tp)
 	p->mask = 0xffff;
 	p->hash = DEFAULT_HASH_SIZE;
 	p->fall_through = 1;
+	refcount_set(&p->refcnt, 1); /* Paired with tcindex_destroy_work() */
 
 	rcu_assign_pointer(tp->root, p);
 	return 0;
-- 
2.21.1

