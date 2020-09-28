Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6736F27B47F
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 20:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgI1SbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 14:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgI1SbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 14:31:18 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF158C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 11:31:18 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k8so1849218pfk.2
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 11:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r3igR5FS7GPjO75PJm/VUDjHivrJMWVOtvekiljL88U=;
        b=Chhh76DobIx9RZAiT5K1eZDwNERB5zo6RXBFgAUQYbDGHPxvleiR5XjMzalDjkyqZS
         1aIc5pIyJwoTHfQt8TuNePwDFDg9H5G6gbFEdnbq0EX4SPhwjqQ8LkgZC3asKRdktPho
         ecQDdIzq/NRVlyCS7cVT2+Tuo7vDqCHvu6CHseiTlLaAFLmgNZaak7mOSXgY85IFEQrg
         2FsWWR6O/KDYEnw5Ms2EVSKdwaggt7U2EfKqfo2o4zARuc3UPzTXNgD3JFoVMGNkHGET
         EthxEESJaSrLZ94n5vuMS2rjgUXT3/LheFJkarE2X+V/SodW+ExOGk0Gv5EEqZpSefOp
         7nPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r3igR5FS7GPjO75PJm/VUDjHivrJMWVOtvekiljL88U=;
        b=rr8vVHxYJzoSpoGYo3E2jdRgHfF7G7IMfHIajZviYYIpsMZJcyvkBLKfQ7QzRScPOs
         hzbQdNEJQZBJQ2XxBn4VWmHVNnp/Z8q4BcULlpe8H+AMd7XPia8iEo6wnDMkzNhkPhHX
         q1bn914L02Klf7s/EJa5eWqdDZrI+VdoUeN0jFpsl8YGnbi/lOIcNRNRvMD/ZAyHiF2a
         q1gUcM1UHwUdH7aLoHLMYdJH04jL7VX0sPGNp294VtNNalWn4WujmQ3327ryt60AV39F
         wmthjsrPV435THELJq8gW9Pregsxi/LpFxH9Jsp71TffF+RJGZHDF2ZlvL/rjh7EV4Rn
         /Nxg==
X-Gm-Message-State: AOAM532ofYbgq2xjv0iGnZ8LU7CFnOg58n1zj30u1Py62zTW5qwXzV5N
        iZi4tavnpw+KjN7RyrvRmOyAwPt/bH191w==
X-Google-Smtp-Source: ABdhPJxlZ5E3U72WvNXJ2F4C/DjJV4XlKHpozT5d1np600R17weF1e61bmqOKEl+7ngSzXSCkV38Xg==
X-Received: by 2002:aa7:9204:0:b029:14b:f92e:f57 with SMTP id 4-20020aa792040000b029014bf92e0f57mr496003pfo.16.1601317877325;
        Mon, 28 Sep 2020 11:31:17 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:65a0:ab60::46])
        by smtp.gmail.com with ESMTPSA id s22sm2565934pfd.90.2020.09.28.11.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 11:31:16 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: remove a redundant goto chain check
Date:   Mon, 28 Sep 2020 11:31:03 -0700
Message-Id: <20200928183103.28442-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All TC actions call tcf_action_check_ctrlact() to validate
goto chain, so this check in tcf_action_init_1() is actually
redundant. Remove it to save troubles of leaking memory.

Fixes: e49d8c22f126 ("net_sched: defer tcf_idr_insert() in tcf_action_init_1()")
Reported-by: Vlad Buslov <vladbu@mellanox.com>
Suggested-by: Davide Caratti <dcaratti@redhat.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/act_api.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 104b47f5184f..5612b336e18e 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -722,13 +722,6 @@ int tcf_action_destroy(struct tc_action *actions[], int bind)
 	return ret;
 }
 
-static int tcf_action_destroy_1(struct tc_action *a, int bind)
-{
-	struct tc_action *actions[] = { a, NULL };
-
-	return tcf_action_destroy(actions, bind);
-}
-
 static int tcf_action_put(struct tc_action *p)
 {
 	return __tcf_action_put(p, false);
@@ -1000,13 +993,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (err < 0)
 		goto err_mod;
 
-	if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
-	    !rcu_access_pointer(a->goto_chain)) {
-		tcf_action_destroy_1(a, bind);
-		NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
-		return ERR_PTR(-EINVAL);
-	}
-
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
 
-- 
2.28.0

