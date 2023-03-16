Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61526BC4CB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjCPDi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjCPDi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:38:27 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE4E67004
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:38:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id a2so387747plm.4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678937904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zw+8WyoA7Q9L8lkiC93t2YOeIl7ECdg3SRa0159aYqM=;
        b=IRsPdypc+yNvBQOzl+wDTOMQJmp1BaefLuPmr1+XtToyMPDKlJ31XR7Rkf2Qvm50LI
         dwbXSubY+N9Vc+8CUSzIn37ApS8VGEwpeJhAYj6ht8bzHcKmFmgvZOx3a0TVl/3d0lXV
         SY9aCXUr+6QN1tuI4Xz9+FFUBhhMj3ivwgdKgY0tnNcs0o7BA9EtQZjFgpNxK+i0Hz4u
         URZCYLLP/zp7RiqAZjzHbxF/7FpmwRfrmcc/E+udS2sPGJPJy9p7SyEabMFR/nYzvR0z
         DOqfFHaEGXBee7jMAVbZG0TuOn/dyDn5wH2xkVUGMJACPKII+0WdvJFOTYX3x3hzfwTO
         Z8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678937904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zw+8WyoA7Q9L8lkiC93t2YOeIl7ECdg3SRa0159aYqM=;
        b=EcqMP4iTevdh8i2wYHz34lRFu7be9McsbWggofUHmLAtkyvcoHuh7pX9s1ojo8vB1Q
         tb7b0w/ETp22w5ZK7obtVlZBTmX6vpqrMt5W1uoaelMejyEVWo5bmwirwq9Jgk0z28z5
         JxDvnLXrBjJmj3u9Czxui0yDS/TskMK6IIQvCu6ECUIWJbBAAVPhJKUycfSPTTJbX88Q
         fsjOdagvhxr/M5vMxzZcL8ApYrMFAxVJWp9cANFNMhg6QaKcVBgWbhZF2K/pMc4Q11+4
         MyvVs5GGxgGa9G/XdYp6BcY8kawdQp8+5NAVjJLmIfnKj/S+RwfmSSjLs9bxsTLHoiY3
         J2Aw==
X-Gm-Message-State: AO0yUKVtGgBd1KS8fJXKJMGrbKhbP5R+VBda410Ztb3+9CTIesjGZcN7
        FVYlv810rdW5LcuFZAmSXIcu4TkaPDgYejtz
X-Google-Smtp-Source: AK7set+9GiU9n3a/HA5B2Tpbp7pS5DTUidhKkly+bRdvYr9oFEF46sKmEVGOIqokpTtLphL0QRNpsg==
X-Received: by 2002:a05:6a20:8e06:b0:d6:8c70:85ce with SMTP id y6-20020a056a208e0600b000d68c7085cemr2307372pzj.54.1678937903924;
        Wed, 15 Mar 2023 20:38:23 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u23-20020aa78497000000b005a8b4dcd213sm4250009pfn.78.2023.03.15.20.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:38:23 -0700 (PDT)
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
Subject: [PATCHv2 net 1/2] Revert "net/sched: act_api: move TCA_EXT_WARN_MSG to the correct hierarchy"
Date:   Thu, 16 Mar 2023 11:37:52 +0800
Message-Id: <20230316033753.2320557-2-liuhangbin@gmail.com>
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

This reverts commit 923b2e30dc9cd05931da0f64e2e23d040865c035.

This is not a correct fix as TCA_EXT_WARN_MSG is not a hierarchy to
TCA_ACT_TAB. I didn't notice the TC actions use different enum when adding
TCA_EXT_WARN_MSG. To fix the difference I will add a new WARN enum in
TCA_ROOT_MAX as Jamal suggested.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/sched/act_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 34c508675041..fce522886099 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1596,12 +1596,12 @@ static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 	if (tcf_action_dump(skb, actions, bind, ref, false) < 0)
 		goto out_nlmsg_trim;
 
+	nla_nest_end(skb, nest);
+
 	if (extack && extack->_msg &&
 	    nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
 		goto out_nlmsg_trim;
 
-	nla_nest_end(skb, nest);
-
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 
 	return skb->len;
-- 
2.38.1

