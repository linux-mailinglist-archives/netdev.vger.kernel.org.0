Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D0A34BB75
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 08:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhC1Gqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 02:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhC1Gq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 02:46:27 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10655C061762;
        Sat, 27 Mar 2021 23:46:23 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so4418626pjv.1;
        Sat, 27 Mar 2021 23:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=10OJ48eehjog/V+dgb4pb/cyuAgqbRzv3VcZL+8CiaM=;
        b=S+t860HWTnpQEylyH0mOnS2RDEF5zNSW/PrN4cjFO3jF+iblqwcj535a5Z24UPxlEl
         TIO2oKBNhhDD+0MYAH6CFgePjhIJaAGsfEed+TMjsFdIwaIeJthZTeGGITl2L+22hQf1
         JYnow6kYancYfLIuQn5JWW9V3j7gvD1Hb+yeJcwNazlLJs0jOQGj4Yq3gbkQ/1k5JpF2
         8KiIuVw1E8SJrc/Uhfm1EOXF7eLgPuWeMjf34uCSLDHzbr2KB+9LR2tYf3Tqs748tGsR
         6tKZ1m9i+gGHNKJQ/YmPIolPK7zYqoGNLo4KlduhruPQRE9jVLcT9CHgqnU3F4gUcNVO
         G8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=10OJ48eehjog/V+dgb4pb/cyuAgqbRzv3VcZL+8CiaM=;
        b=Uyjhth6zgUDwdOn5f1KzmpsyWV7xS6KdjpJcByL44Cu2VTfxGRaWiq1kz3w1dS92OQ
         az0BIRgCaowk7CJsZ2PZ2qNrISxF3/fGXk460U24xUEf5FWA5RwP22d8PQRHfvLfosTX
         /XzNJc6uvCaR9/gwZkFWqEtfko+xvaPB4N+c5nKnh7JxLNR8/RD356fzSAz3A/2iVT81
         Xuy0PlMvRQjFjWrnEqd+XaxR0SxMoPXTIY+nKe/d5iIYtr1Tl8S30wARzR6CsF4VjgAJ
         ZmkoPOqyXbl/qmAtzz+7QvntvNCz8wNqBNyThMgzVsvLIXV+9hJGcHoaGA/CuM2PgaZN
         XnHw==
X-Gm-Message-State: AOAM531nw2cCBRGo2s1mNKgqkKRZ5gygD69qHwX70bmv32oU2Rc69OmS
        6WJpZKd9LwSF4jGkRMGtBO+sAKrRUMjG6A==
X-Google-Smtp-Source: ABdhPJzJm7c6XhCdJT2mO2+FtlsP7dJO9X0TvYIoERktwpCz30OOtYmEbuwQyxX90VHVhYVuEtdXKA==
X-Received: by 2002:a17:90b:4c0a:: with SMTP id na10mr22135875pjb.227.1616913976127;
        Sat, 27 Mar 2021 23:46:16 -0700 (PDT)
Received: from localhost ([112.79.247.28])
        by smtp.gmail.com with ESMTPSA id y194sm13614598pfb.21.2021.03.27.23.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 23:46:15 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] net: sched: extend lifetime of new action in replace mode
Date:   Sun, 28 Mar 2021 12:15:55 +0530
Message-Id: <20210328064555.93365-1-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating an action in replace mode, in tcf_action_add, the refcount
of existing actions is rightly raised during tcf_idr_check_alloc call,
but for new actions a dummy placeholder entry is created. This is then
replaced with the actual action during tcf_idr_insert_many, but between
this and the tcf_action_put_many call made in replace mode, we don't
hold a reference to the newly created action while it has been
published. This means that it can disappear under our feet, and that
newly created actions are destroyed right after their creation as their
refcount drops to 0 in replace mode.

This leads to commands like tc action replace reporting success in
creation of the action and just removing them right after adding the
action, leading to confusion in userspace.

Fix this by raising the refcount of a newly created action and then
pairing that increment with a tcf_action_put call to release the
reference held during insertion. This is only needed in replace mode.
We use a relaxed store as insert will ensure its visibility.

Fixes: cae422f379f3 ("net: sched: use reference counting action init")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/net/act_api.h | 1 +
 net/sched/act_api.c   | 5 ++++-
 net/sched/cls_api.c   | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 2bf3092ae7ec..8b375b46cc04 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -181,6 +181,7 @@ int tcf_register_action(struct tc_action_ops *a, struct pernet_operations *ops);
 int tcf_unregister_action(struct tc_action_ops *a,
 			  struct pernet_operations *ops);
 int tcf_action_destroy(struct tc_action *actions[], int bind);
+void tcf_action_put_many(struct tc_action *actions[]);
 int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 		    int nr_actions, struct tcf_result *res);
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index b919826939e0..7e26c18cdb15 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -778,7 +778,7 @@ static int tcf_action_put(struct tc_action *p)
 }
 
 /* Put all actions in this array, skip those NULL's. */
-static void tcf_action_put_many(struct tc_action *actions[])
+void tcf_action_put_many(struct tc_action *actions[])
 {
 	int i;
 
@@ -1042,6 +1042,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (err != ACT_P_CREATED)
 		module_put(a_o->owner);
 
+	if (err == ACT_P_CREATED && ovr)
+		refcount_set(&a->tcfa_refcnt, 2);
+
 	return a;
 
 err_out:
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d3db70865d66..666077c23147 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3074,6 +3074,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 			exts->nr_actions = err;
 		}
 	}
+
+	if (ovr)
+		tcf_action_put_many(exts->actions);
 #else
 	if ((exts->action && tb[exts->action]) ||
 	    (exts->police && tb[exts->police])) {
-- 
2.30.2

