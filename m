Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB116BC4CC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjCPDif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCPDid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:38:33 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6536231E
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:38:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so3990434pjv.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678937909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZMiueAnQpy5LMepXCxRm56tvqfR5E+OiRXBDtmO6zrQ=;
        b=DvyX/5sSjEEfISkfT2u7PKAoZ4XDvdmwufVijgVfzPdmH/M2CtUuSQUaCHGrr+iwRw
         QznK0921cnb23oSXOAe26PKi2EeMZfkQYf65Iz2+wzwZe7lqu3uV0lISO0i2fpVk31Hh
         KOHCEBwoK2Zqmkqm2dMfLC+GSKBDIqN6q9o33yKQRh+H63riX6VnyiUFikRpj2zc6m6v
         8rzvZyU1k7IjrRPN0fXJ5+tuOQ4xDnhMjXW/tDg/In0HW9Wzf3fOw1Ykx6G7XW0uQUFe
         E6fsPL1HeGjpvi3gqrJsxN7881yE4BnJhRUCFGteLIIAIr3hQzobsRajVdodD0Is+Bt7
         qW+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678937909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZMiueAnQpy5LMepXCxRm56tvqfR5E+OiRXBDtmO6zrQ=;
        b=GVhwq5WRDsEgsIWuFJcEsZjOEhTOTmFCMV3GwwKQ4bUam/Lr6oAD1kQ1IWHdAxobYn
         n+O9rS+DDmc/+hHsOWSgaM52ugf8KWqE3t6hbLKPcj5sYSMh2nVpwihlpvuq1P+rTUiw
         mT2bBg2yvXcWopgWF9nDBGuEC3TC2Su0NOwb73RCXa86Fg804AaJTiGthhOhpF7QJQfJ
         R8+dx9d+MpAujhNSwr6OJbP7dbIt/1lVLYoAH0ySy/CP1i5gvANWKkb7TGB/xKcYtVG7
         YeN3RlB8MkNLCZacDfWJLwUmNwmJH3PPIcJfZ5EDgsBJcuoML8q3IBW6Ka8Ag0Qtw6+g
         9bzQ==
X-Gm-Message-State: AO0yUKUIS1i6c0cD+vWRu9OCNLfRSyJDFxn1AVHbnjwHhK2UmVegkZqn
        fJlGJ4VNrcscj1Ko8nWi4TtCpUPVypiucMnc
X-Google-Smtp-Source: AK7set9OKAkrwYzMiEsNRXwioIPGzNzlrvhWB3FaVZy9RLUvqcJsVQX/Ugxr3rjKFNGbPNU+gzr2/g==
X-Received: by 2002:a05:6a20:734e:b0:cc:9010:9ed with SMTP id v14-20020a056a20734e00b000cc901009edmr2676544pzc.31.1678937909144;
        Wed, 15 Mar 2023 20:38:29 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u23-20020aa78497000000b005a8b4dcd213sm4250009pfn.78.2023.03.15.20.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:38:28 -0700 (PDT)
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
Subject: [PATCHv2 net 2/2] net/sched: act_api: add specific EXT_WARN_MSG for tc action
Date:   Thu, 16 Mar 2023 11:37:53 +0800
Message-Id: <20230316033753.2320557-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230316033753.2320557-1-liuhangbin@gmail.com>
References: <20230316033753.2320557-1-liuhangbin@gmail.com>
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

In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG
to report tc extact message") I didn't notice the tc action use different
enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action.
Let's add a TCA_ROOT_EXT_WARN_MSG for tc action specifically and put this
param before going to the TCA_ACT_TAB nest.

Fixes: 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG to report tc extact message")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: rename TCA_ACT_EXT_WARN_MSG to TCA_ROOT_EXT_WARN_MSG
---
 include/uapi/linux/rtnetlink.h | 1 +
 net/sched/act_api.c            | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 25a0af57dd5e..51c13cf9c5ae 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -789,6 +789,7 @@ enum {
 	TCA_ROOT_FLAGS,
 	TCA_ROOT_COUNT,
 	TCA_ROOT_TIME_DELTA, /* in msecs */
+	TCA_ROOT_EXT_WARN_MSG,
 	__TCA_ROOT_MAX,
 #define	TCA_ROOT_MAX (__TCA_ROOT_MAX - 1)
 };
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index fce522886099..296fc1afedd8 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1589,6 +1589,10 @@ static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 	t->tca__pad1 = 0;
 	t->tca__pad2 = 0;
 
+	if (extack && extack->_msg &&
+	    nla_put_string(skb, TCA_ROOT_EXT_WARN_MSG, extack->_msg))
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

