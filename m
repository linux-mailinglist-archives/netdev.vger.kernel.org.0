Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5709D6B8BBF
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 08:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCNHLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 03:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjCNHLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 03:11:00 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D6F8C82B
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 00:10:59 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so6716863pjb.0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 00:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678777858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4NV/ai0abkpRJuieKqilrOHHVH5yeZIA8VooYROx6NQ=;
        b=HSXsf0a7ZmNM96i088lmzL5k03sjDaYTQQXzhSedkdIn7hasC2dICapZDntiFNz3rL
         gTX40SVF9WLZk9uCLaL1rWUXASGSwiK/3FYuDfGc5BpEYt9aqq4RnKbcOlz4TLf9ZFkq
         6iqccuARUaTZCobQk3yYu5+iQLna97R/8ETSpNG5zbuOrgDbvo0EYOUCjWVxIz3442Ua
         uKojuT3GZLWFhMT2ZgHXXkRXOuohzXaaZdGCOm3+diRlYzJ8MIWoasnaDMXOrfj15uEY
         1ZO4wc5UlzH9X6WM+w1P2LeatobQiyJofoKLgHsMlVQdiKR5Y+wJcLYLS3kD0Yoj7EYS
         GRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678777858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4NV/ai0abkpRJuieKqilrOHHVH5yeZIA8VooYROx6NQ=;
        b=HYO8n5Lwy5pGL1TCMJc6sJR/mWsGuOS0ZvTWYqE/+qHmCKk2kZW8GRbnlxn7PdqJGr
         kuF+ol7POA/dAgjbwxvQ+BIX9UT9Z2xp5QCIAK84L0bs4xfVVNOg7yPKjMhwVStTzt5i
         Lq3OvSc8QwcdFZZsMs9rr+P1D2RTR6pOrA7fjWHFCKIjiFaTJTN2mpw4HRGosQcJs0Fl
         eBJxw0slM+aucshSSM0nLRui7ZAzPbrnYTmhc1Jb6kqNOi03wYCNb25ms5MDv8z8nF/B
         jaZTv6ILiRGLqbgllqlPuUoGQqfM6EHogts5hwbgw+t2hl1+NS0SchpOIvucxLYBJdSP
         OARw==
X-Gm-Message-State: AO0yUKWN4XjUIQNbe4lkGrXpfYR/1T8E879/hriKKqwJlV72nAvYpJ9G
        e2uZ4Xun9/mB12q00yiVp2Uja85vXX9NZ43y
X-Google-Smtp-Source: AK7set/y7llkNNNSrmQWc4gaU5d5IwPGBbdyhyXiSmZDCkG8M67twzxJPEqp+a4MkWynm0DXG8CjTQ==
X-Received: by 2002:a17:903:120b:b0:19e:786f:4cac with SMTP id l11-20020a170903120b00b0019e786f4cacmr42701678plh.53.1678777858567;
        Tue, 14 Mar 2023 00:10:58 -0700 (PDT)
Received: from localhost.localdomain ([8.218.113.75])
        by smtp.gmail.com with ESMTPSA id kl8-20020a170903074800b00189f2fdbdd0sm967179plb.234.2023.03.14.00.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 00:10:57 -0700 (PDT)
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
Subject: [PATCH iproute2 2/2] tc: m_action: fix parsing of TCA_EXT_WARN_MSG by using different enum
Date:   Tue, 14 Mar 2023 15:08:41 +0800
Message-Id: <20230314070841.1533755-1-liuhangbin@gmail.com>
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

We can't use TCA_EXT_WARN_MSG directly in tc action as it's using different
enum with filter. Let's use a new TCA_ACT_EXT_WARN_MSG for tc action
specifically.

Fixes: 6035995665b7 ("tc: add new attr TCA_EXT_WARN_MSG")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/uapi/linux/rtnetlink.h | 1 +
 tc/m_action.c                  | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 217b25b9..f598c78a 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -787,6 +787,7 @@ enum {
 	TCA_ROOT_FLAGS,
 	TCA_ROOT_COUNT,
 	TCA_ROOT_TIME_DELTA, /* in msecs */
+	TCA_ACT_EXT_WARN_MSG,
 	__TCA_ROOT_MAX,
 #define	TCA_ROOT_MAX (__TCA_ROOT_MAX - 1)
 };
diff --git a/tc/m_action.c b/tc/m_action.c
index 0400132c..f99d1170 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -586,7 +586,12 @@ int print_action(struct nlmsghdr *n, void *arg)
 
 	open_json_object(NULL);
 	tc_dump_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0, false);
-	print_ext_msg(tb);
+
+	if (tb[TCA_ACT_EXT_WARN_MSG]) {
+		print_string(PRINT_ANY, "warn", "%s", rta_getattr_str(tb[TCA_ACT_EXT_WARN_MSG]));
+		print_nl();
+	}
+
 	close_json_object();
 
 	return 0;
-- 
2.38.1

