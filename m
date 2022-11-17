Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C770A62D17F
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 04:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbiKQDQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 22:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKQDQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 22:16:06 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FB763B97
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:16:04 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id jr19so377573qtb.7
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S1ptF9mncQNJ+YzPoHhaIMd3nHddn4TGB/DoUobLdZU=;
        b=GcfN8q0cdS6ovJPkcYbDaqLvjp2zegbXELs5S4CRJutF7b+qeUEjdTBvXgBMq/OP0O
         5F0oDVaz0IMlsc3dJM130Zm51BsN/20FkgL5+YveFNxpF5QeQZUfW2actFnGJSzQOl7k
         9FJPLPu3eSIQwGzgteA3hAdyBxrFV0KXV9dzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S1ptF9mncQNJ+YzPoHhaIMd3nHddn4TGB/DoUobLdZU=;
        b=WjKa45+u9tBNcYTxpiODq/rsP6J18h7XBP0z/mXZxzvmJHxN/IKaRWYIGY2b7Vsb8O
         ZTREhF0xlLiODNBYxa6fmXREhYLXyXaX3WOck2OqRjthlUzp9TqwVfw41NZp7j2bK0AR
         6BvsBzYhZlDb9sxe95OkR4rRDjNhzf5dOWztibvs9Ukn2VuFb3iNsmqiY6gvjxaI2wnc
         yzReqNOhIO7HJZaO09uK2fwm3D11R1HWho4YKPuxSoMA4hMeGe4jS/xo9sq7PZ76/DIj
         iV2NZGdW9qqm/WSLRlDEdNA6Lc+UoBZg81L/QTZzPeJ9ekvDpCfeX2MS0RURn9eMGTiE
         mW2w==
X-Gm-Message-State: ANoB5pkDx6+3yQH4nKK34e82iD+xr4gwICELfsB9BbvDpaNqKIjhFhI3
        cLovFOqW+9IvPH5zClut2mq5Lg==
X-Google-Smtp-Source: AA0mqf6wIKIMbSXoQzryo0edy3a17i21tuwAle5TzhjMCIbXHB1V2gGJhQuKdO3B3/Yxj47fWCqMTA==
X-Received: by 2002:a05:622a:401b:b0:3a5:2c7c:c915 with SMTP id cf27-20020a05622a401b00b003a52c7cc915mr722597qtb.499.1668654963515;
        Wed, 16 Nov 2022 19:16:03 -0800 (PST)
Received: from joelboxx.c.googlers.com.com (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id k19-20020a05620a415300b006cdd0939ffbsm11398318qko.86.2022.11.16.19.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 19:16:03 -0800 (PST)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, paulmck@kernel.org, fweisbec@gmail.com
Subject: [PATCH rcu/dev 1/3] net: Use call_rcu_flush() for qdisc_free_cb
Date:   Thu, 17 Nov 2022 03:15:48 +0000
Message-Id: <20221117031551.1142289-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a networking test on ChromeOS, we find that using the new CONFIG_RCU_LAZY
causes a networking test to fail in the teardown phase.

The failure happens during: ip netns del <name>

Using ftrace, I found the callbacks it was queuing which this series fixes. Use
call_rcu_flush() to revert to the old behavior. With that, the test passes.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 net/sched/sch_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a9aadc4e6858..63fbf640d3b2 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1067,7 +1067,7 @@ static void qdisc_destroy(struct Qdisc *qdisc)
 
 	trace_qdisc_destroy(qdisc);
 
-	call_rcu(&qdisc->rcu, qdisc_free_cb);
+	call_rcu_flush(&qdisc->rcu, qdisc_free_cb);
 }
 
 void qdisc_put(struct Qdisc *qdisc)
-- 
2.38.1.584.g0f3c55d4c2-goog

