Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A691E69221A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjBJP0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbjBJP0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:26:12 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079287164D
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:26:08 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id w15-20020a25850f000000b008fcfd8e695eso369290ybk.3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rq33iBOXvNepxozD3MQ/pcMnHlfS1xVbd4zx1+sCyd0=;
        b=hXD7TvpOvpwCMa2gKavu5w5AsZdb4R0AWBQchR65kb9IIfLEe6nsYMvgxOsdYcb1B0
         t240sCW0437ijNSiutHy0qKAFkVI1GWe839KjJaKQSKDs3l6ZoyeQMyU+KJNJZsS2hYR
         ASZEPurKIfQ9N09QKVJWxJrZa90Y0YdM+/fus7F2QLqp6Z9zaf/liDZ2DZfijw2idtGo
         nkGaHDuy2x2mt1hb1BvdOMNayehj17her+Q1Qe6VUwoLkNzF7vlK7dM9uUwMvbned98U
         wLauxLa0bvfO+7JEbzI9fq9lr7Gip4P18QASIiGlFvyQVY6HtHXntGDvBfbHFYboCG6A
         mcPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rq33iBOXvNepxozD3MQ/pcMnHlfS1xVbd4zx1+sCyd0=;
        b=Eebihq2lnrlmKNPtID0d2FuR7FvjHae39YixuMd7yESviQqomobFK/GgoHjICDxCZk
         Wu/9VX+bzGyLAlGEurVdvZ4JcrBprGICJ/TKbVjEcd+o25rV2Im/2DJge4Jnm2rxBdZr
         DigFDZarWqc85ZW7gqbCUE5GNz2lG1/JIzJrtRmudZlFel+qxJTb8rw0DuiWa6A+CxDy
         cDpDzm6bvnoRbhfTP0hm3YpKyl1KBvB7/VearXgHS2bt4Bn69eWPynGB+YDS707PqXAk
         +n550lrMaeD2VRBPK0wm2uzdizJGg8hWGgcQMFvFs8OcVr5eNakQsjeQ3bHvCugbkJ96
         UTWw==
X-Gm-Message-State: AO0yUKVoMIJ1+Ey102Lvq8ne+zo1XOrUzcObIOETyEhw7RoM95xv8ybq
        sI2pa3/D0Gn/xL5pTq6DBCnoMkf0Lshgew==
X-Google-Smtp-Source: AK7set9SA5DjhhPku44bRxXi1XUi1tquL6bBm3e/IbeFbyOvlxc3V+esi6I5jkcZSygotFE8r6dUAGYv6if3/w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:287:b0:52a:9eac:92b with SMTP id
 bf7-20020a05690c028700b0052a9eac092bmr33ywb.4.1676042767057; Fri, 10 Feb 2023
 07:26:07 -0800 (PST)
Date:   Fri, 10 Feb 2023 15:26:05 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210152605.1852743-1-edumazet@google.com>
Subject: [PATCH net-next] net/sched: fix error recovery in qdisc_create()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>,
        syzbot+d44d88f1d11e6ca8576b@syzkaller.appspotmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If TCA_STAB attribute is malformed, qdisc_get_stab() returns
an error, and we end up calling ops->destroy() while ops->init()
has not been called yet.

While we are at it, call qdisc_put_stab() after ops->destroy().

Fixes: 1f62879e3632 ("net/sched: make stab available before ops->init() call")
Reported-by: syzbot+d44d88f1d11e6ca8576b@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
---
 net/sched/sch_api.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index e9780631b5b58202068e20c42ccf1197eac2194c..aba789c30a2eb50d339b8a888495b794825e1775 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1286,7 +1286,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 		stab = qdisc_get_stab(tca[TCA_STAB], extack);
 		if (IS_ERR(stab)) {
 			err = PTR_ERR(stab);
-			goto err_out4;
+			goto err_out3;
 		}
 		rcu_assign_pointer(sch->stab, stab);
 	}
@@ -1294,14 +1294,14 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 	if (ops->init) {
 		err = ops->init(sch, tca[TCA_OPTIONS], extack);
 		if (err != 0)
-			goto err_out5;
+			goto err_out4;
 	}
 
 	if (tca[TCA_RATE]) {
 		err = -EOPNOTSUPP;
 		if (sch->flags & TCQ_F_MQROOT) {
 			NL_SET_ERR_MSG(extack, "Cannot attach rate estimator to a multi-queue root qdisc");
-			goto err_out5;
+			goto err_out4;
 		}
 
 		err = gen_new_estimator(&sch->bstats,
@@ -1312,7 +1312,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 					tca[TCA_RATE]);
 		if (err) {
 			NL_SET_ERR_MSG(extack, "Failed to generate new estimator");
-			goto err_out5;
+			goto err_out4;
 		}
 	}
 
@@ -1321,12 +1321,13 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 
 	return sch;
 
-err_out5:
-	qdisc_put_stab(rtnl_dereference(sch->stab));
 err_out4:
-	/* ops->init() failed, we call ->destroy() like qdisc_create_dflt() */
+	/* Even if ops->init() failed, we call ops->destroy()
+	 * like qdisc_create_dflt().
+	 */
 	if (ops->destroy)
 		ops->destroy(sch);
+	qdisc_put_stab(rtnl_dereference(sch->stab));
 err_out3:
 	netdev_put(dev, &sch->dev_tracker);
 	qdisc_free(sch);
-- 
2.39.1.581.gbfd45094c4-goog

