Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22A2274FAF
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 05:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgIWD4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 23:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIWD4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 23:56:41 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7B0C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 20:56:41 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k8so14240780pfk.2
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 20:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l12dbepqbKiDY+MFHOh/wOOLxiRtbCljyP9tOGB/Hnw=;
        b=r+xsytWReMgff1g20eKd8Xv9qNQXZodmjIspGXhuolhTw9qMQtXNc6pMCzHpuj1ncR
         sWryaLRnbIKAxD22rXEnPCPTPj5wCyTI9uO11DGxQM4ktHSCBl5z4EECkLDBt1JeXk8t
         DwrWBWI4nc02ztGyJSTxSRfeagYYQCmdCfrSy5PVCRSSNCrSeuE9XDdTKUoWySqB+4ni
         mLPkKEqgKGW1qMuuWcuSb7YpIFjAKfi7sleruuN/d65Mh6nIM3x4Ty3Re3QXG7Ors1Y3
         992+Yx+EeCMdOjH3t/Ci6pnskjIF61guOWAuWnb53eBa61vJEg1fMlVWiOsZtuVGq/Yo
         g5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l12dbepqbKiDY+MFHOh/wOOLxiRtbCljyP9tOGB/Hnw=;
        b=a+BbEoNigUzW4fUzY/3xKR6+8JNZXLa8sCZKVrH6kTowJ1qZyr9fZ3dkH1HLfitHLp
         PLGVAec5FlOEtdDFD96C8TLBNp4h2Sol7vpGFH/3LvXGf+kNKIR9KMQrvacE/yDUNBq1
         bNADwZp/FwDzx0fMV6azOrx6PhsWvJ0ESlLFgCmGQLDiZfoMPohS35BswZJncS/bknoB
         w31Dg+87qpYloWNXJqQVmRHWJh7RZ0OkBP5IzlFY4qJ/5NEW1V/STB4el3MLZGChYRvs
         SGQhD5llJBCt7vYeI3R5ZGSGd2PSAE7fnUNNpyNevRRVRHLN08KivWJr3M06TQ/1dFjZ
         eJAg==
X-Gm-Message-State: AOAM531oeDcw5JcC5rCD0EzTftVcP5zfe86Ij9J19FCIevUFKR4VHqPI
        BJkC/xoqhQFDmsK38cWqyCj+ymve46t/Vw==
X-Google-Smtp-Source: ABdhPJxe2P8kuQCteLumYP5uzPC2TD6n7fj2+3CasMZmryYApguthcmZGEkT8Ti6f4GIaPkHkEJhqQ==
X-Received: by 2002:a63:e94a:: with SMTP id q10mr6130930pgj.189.1600833400606;
        Tue, 22 Sep 2020 20:56:40 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:65a0:ab60::46])
        by smtp.gmail.com with ESMTPSA id v6sm16729045pfi.38.2020.09.22.20.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 20:56:39 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+2287853d392e4b42374a@syzkaller.appspotmail.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net 2/2] net_sched: commit action insertions together
Date:   Tue, 22 Sep 2020 20:56:24 -0700
Message-Id: <20200923035624.7307-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923035624.7307-1-xiyou.wangcong@gmail.com>
References: <20200923035624.7307-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is able to trigger a failure case inside the loop in
tcf_action_init(), and when this happens we clean up with
tcf_action_destroy(). But, as these actions are already inserted
into the global IDR, other parallel process could free them
before tcf_action_destroy(), then we will trigger a use-after-free.

Fix this by deferring the insertions even later, after the loop,
and committing all the insertions in a separate loop, so we will
never fail in the middle of the insertions any more.

One side effect is that the window between alloction and final
insertion becomes larger, now it is more likely that the loop in
tcf_del_walker() sees the placeholder -EBUSY pointer. So we have
to check for error pointer in tcf_del_walker().

Reported-and-tested-by: syzbot+2287853d392e4b42374a@syzkaller.appspotmail.com
Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/act_api.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 0030f00234ee..104b47f5184f 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -307,6 +307,8 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 
 	mutex_lock(&idrinfo->lock);
 	idr_for_each_entry_ul(idr, p, tmp, id) {
+		if (IS_ERR(p))
+			continue;
 		ret = tcf_idr_release_unsafe(p);
 		if (ret == ACT_P_DELETED) {
 			module_put(ops->owner);
@@ -891,14 +893,24 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
 };
 
-static void tcf_idr_insert(struct tc_action *a)
+static void tcf_idr_insert_many(struct tc_action *actions[])
 {
-	struct tcf_idrinfo *idrinfo = a->idrinfo;
+	int i;
 
-	mutex_lock(&idrinfo->lock);
-	/* Replace ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc */
-	WARN_ON(!IS_ERR(idr_replace(&idrinfo->action_idr, a, a->tcfa_index)));
-	mutex_unlock(&idrinfo->lock);
+	for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
+		struct tc_action *a = actions[i];
+		struct tcf_idrinfo *idrinfo;
+
+		if (!a)
+			continue;
+		idrinfo = a->idrinfo;
+		mutex_lock(&idrinfo->lock);
+		/* Replace ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc if
+		 * it is just created, otherwise this is just a nop.
+		 */
+		idr_replace(&idrinfo->action_idr, a, a->tcfa_index);
+		mutex_unlock(&idrinfo->lock);
+	}
 }
 
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
@@ -995,9 +1007,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (err == ACT_P_CREATED)
-		tcf_idr_insert(a);
-
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
 
@@ -1053,6 +1062,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		actions[i - 1] = act;
 	}
 
+	/* We have to commit them all together, because if any error happened in
+	 * between, we could not handle the failure gracefully.
+	 */
+	tcf_idr_insert_many(actions);
+
 	*attr_size = tcf_action_full_attrs_size(sz);
 	return i - 1;
 
-- 
2.28.0

