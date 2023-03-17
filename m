Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1036BF1BE
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 20:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjCQTfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 15:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjCQTfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 15:35:45 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF206424A
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 12:35:44 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id bo10so4576659oib.11
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 12:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679081743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+SNu8Q+7VfRVAV9Il+C75cJFiDFNnI2YO4XmYRZYP2k=;
        b=JUfshmnozgBPTRftEqOxl7n2clsuDcj6J0fyA2RE+ztguq7yOcoeY21bOwZwEAQHPH
         qxV0ELXc2yqM+epCwWbiQY3aHCM5Ko1cxF8sypBSvfQ0YowXGdDBbM1p3T/I6THaMool
         IwkfVvRLS8sul5VdINBuhO7F2bTGsEBGXo/YSo7bjVK1xY8gpi0G8UEF5VC2K3rCoPU8
         3pYCKg+1HdSa+AUXNF//OXLSXKUd78/EQxHd1tonDVQmG1AArr6i+bpCRMOLLrwUTdtT
         YUtNUypJ5kwz2prKtdn0YifDaOitaifg7A8fiiq+MipwOzYVX6upVt8KYFfBpZjnfUWZ
         5FjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679081743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+SNu8Q+7VfRVAV9Il+C75cJFiDFNnI2YO4XmYRZYP2k=;
        b=XHSwD4A1JDaEG0gWTiDCiEsbtPkzd6fJwakCTJKsAX6A8OfBsbMIBliXLaiiPFO9Ic
         TTSkfWon3QNxWEbZ69mSZNqy2rDe8cUbYOmAXDSdFYzYAwzbMU2UJ4ITa808kM5QxvLA
         rsV3EGQbiCrKVleI0Y+KZf2vkNjcMGnbd5F/kr/FmIRvCS//FmYD/cEcKigy/MuG/qbR
         ocHYgPKcu0YUc4Q/ev0Pii22KeP2vQ5nEGDKSFsNpQALWLBfB48iIsyN8UrizeVPRCQO
         ggn2v9kHH24mmIhmiwrrVZQ7r000GeU3Nx4MlYT1Ey6qpTz+drlaWAuSCUIoObsumw51
         gObg==
X-Gm-Message-State: AO0yUKWEL7ttQUz5FF1kJbc1vc7UPsjgv5L2liEbW84TL61dk6aE4obA
        3G6AtVc5tSpQ8oVLJSOAFkYYrt9nldcRB1rwupc=
X-Google-Smtp-Source: AK7set/e75gE97XO/bISaT32WnVhT+YxlGVLWntOZwr9fG2tb847EExaCO0jnjGJHxzjPJta+UPSPg==
X-Received: by 2002:a05:6808:1a28:b0:386:ca6a:7563 with SMTP id bk40-20020a0568081a2800b00386ca6a7563mr2908990oib.50.1679081743276;
        Fri, 17 Mar 2023 12:35:43 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:10c1:4b9b:b369:bda2])
        by smtp.gmail.com with ESMTPSA id bk38-20020a0568081a2600b0037832f60518sm1196976oib.14.2023.03.17.12.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 12:35:42 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCH net-next v2] net/sched: act_api: use the correct TCA_ACT attributes in dump
Date:   Fri, 17 Mar 2023 16:35:19 -0300
Message-Id: <20230317193519.1140649-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

3 places in the act api code are using 'TCA_' definitions where they should be using
'TCA_ACT_', which is confusing for the reader, although functionaly wise they are equivalent.

Cc: Hangbin Liu <haliu@redhat.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 34c508675041..2acbb43125ce 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -453,7 +453,7 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 		+ nla_total_size_64bit(sizeof(u64))
 		/* TCA_STATS_QUEUE */
 		+ nla_total_size_64bit(sizeof(struct gnet_stats_queue))
-		+ nla_total_size(0) /* TCA_OPTIONS nested */
+		+ nla_total_size(0) /* TCA_ACT_OPTIONS nested */
 		+ nla_total_size(sizeof(struct tcf_t)); /* TCA_GACT_TM */
 }
 
@@ -480,7 +480,7 @@ tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a, bool from_act)
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tc_cookie *cookie;
 
-	if (nla_put_string(skb, TCA_KIND, a->ops->kind))
+	if (nla_put_string(skb, TCA_ACT_KIND, a->ops->kind))
 		goto nla_put_failure;
 	if (tcf_action_copy_stats(skb, a, 0))
 		goto nla_put_failure;
@@ -598,7 +598,7 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	nest = nla_nest_start_noflag(skb, 0);
 	if (nest == NULL)
 		goto nla_put_failure;
-	if (nla_put_string(skb, TCA_KIND, ops->kind))
+	if (nla_put_string(skb, TCA_ACT_KIND, ops->kind))
 		goto nla_put_failure;
 
 	ret = 0;
@@ -1189,7 +1189,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
 		goto nla_put_failure;
 
-	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
+	nest = nla_nest_start_noflag(skb, TCA_ACT_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 	err = tcf_action_dump_old(skb, a, bind, ref);
-- 
2.34.1

