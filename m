Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737A86B8B95
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjCNG64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCNG6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:58:52 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4865765457
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:58:51 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k2so7695195pll.8
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678777130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rpsCt7dTcK8K9Djze8VmfX/PXwfwibnuykrlNvnzQ74=;
        b=JbtLbiz2AyJsuNP/DSaXyAsS2CuMx8e3uYlOe0YVjJJBrsqjF3eW/ro+t83U5jNjRJ
         wruFpB+lHQr5H4Ey6Q8djxzZPh2ZKtMSMj3S5HN1fi9N2Lzlco0P8Pa20+az8qRrALii
         im31PJAHDSQDYbPo//sgdv7+p7v/3oQPr9/VuZWVfsipZov2kDsRyHs9KP8wv1CXF44J
         1ISb9PYbF5q0OYRriD6JROvc8bqqg7PlHpPf44qwn/CbQN9X4pLvRQESJd6+PWG8XGku
         aBx5wWk/lrpLfG3W5P0ps8rc01lcoR8KsObdPQ32MLIPsJVRjwx5MEM9i2Xuy/lEST5V
         X0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678777130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rpsCt7dTcK8K9Djze8VmfX/PXwfwibnuykrlNvnzQ74=;
        b=Xve1VdRUgoGxK9YGf8/8fARBLPGMzk/CKqppXd4fsGL9LpxC+LH0nTPmoOmtxqhq3T
         ABwV4BQII3/6n8cbcO62KJ3ZCrjc+E2SmPSeYM95ZI4HuQioJeM5fVQrYLB85MJB6PKN
         KB8mJbDhT8jKG5LWxddQ6SYMrCQyNVP0f3YebpWMpkHcRBoTMgilRgVA/cGDwyBOq4qV
         TtaToHVn4J1T5dVo/rADOG0qaNyZhGFHhcRcTyb8eFCJPMVLaJ5g2f8k2RS9jdQrAU2/
         leOSA8qAl+T0y0btcdbnBPMUU1xdKVDROwmutr8dHx7YssGXcORilb8SPxKqRm8zWtWQ
         Rvhw==
X-Gm-Message-State: AO0yUKUqL0mMxXiIvV6rpzhYrX4LQjABDIi5LEJiM+kqVVyFaUQ082+L
        wmpKZEQlajraRcb5ro/q9b76R1WWVAaemRXv
X-Google-Smtp-Source: AK7set/SgFNZamQxPBMlEP+6z8TbCksnuQONeM09dnJbMk4TMA0dEkL8qCnJX4PhsiFP6as2yGBFxA==
X-Received: by 2002:a05:6a20:8e09:b0:d4:7339:d120 with SMTP id y9-20020a056a208e0900b000d47339d120mr6609872pzj.54.1678777130405;
        Mon, 13 Mar 2023 23:58:50 -0700 (PDT)
Received: from localhost.localdomain ([8.218.113.75])
        by smtp.gmail.com with ESMTPSA id j20-20020a62b614000000b005dae7d1b61asm808291pff.154.2023.03.13.23.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 23:58:49 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/2] net/sched: act_api: add specific EXT_WARN_MSG for tc action
Date:   Tue, 14 Mar 2023 14:58:02 +0800
Message-Id: <20230314065802.1532741-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230314065802.1532741-1-liuhangbin@gmail.com>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
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

In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG to
report tc extact message") I didn't notice the tc action use different
enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action.
Let's add a TCA_ACT_EXT_WARN_MSG for tc action specifically and put this
param before going to the TCA_ACT_TAB nest.

Fixes: 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG to report tc extact message")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/uapi/linux/rtnetlink.h | 1 +
 net/sched/act_api.c            | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 25a0af57dd5e..5ad3448a1fa7 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -789,6 +789,7 @@ enum {
 	TCA_ROOT_FLAGS,
 	TCA_ROOT_COUNT,
 	TCA_ROOT_TIME_DELTA, /* in msecs */
+	TCA_ACT_EXT_WARN_MSG,
 	__TCA_ROOT_MAX,
 #define	TCA_ROOT_MAX (__TCA_ROOT_MAX - 1)
 };
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index fce522886099..f960cb534ca0 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1589,6 +1589,10 @@ static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 	t->tca__pad1 = 0;
 	t->tca__pad2 = 0;
 
+	if (extack && extack->_msg &&
+	    nla_put_string(skb, TCA_ACT_EXT_WARN_MSG, extack->_msg))
+		goto out_nlmsg_trim;
+
 	nest = nla_nest_start_noflag(skb, TCA_ACT_TAB);
 	if (!nest)
 		goto out_nlmsg_trim;
@@ -1598,10 +1602,6 @@ static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 
 	nla_nest_end(skb, nest);
 
-	if (extack && extack->_msg &&
-	    nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
-		goto out_nlmsg_trim;
-
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 
 	return skb->len;
-- 
2.38.1

