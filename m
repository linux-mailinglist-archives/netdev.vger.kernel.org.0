Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAE66A20EC
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 18:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjBXR4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 12:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBXR4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 12:56:11 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC951815F
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 09:56:10 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id h6-20020a9d7986000000b0068bd8c1e836so84314otm.3
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 09:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rzGt3ohTkmhBv8LAruEt+vWwCsSIIRCgS3hz/m4lLjE=;
        b=X/Or8MqtVj+6dzo7flSfWh3Ev0KEhyaIc0F7DBZmYYm5TDQNrgLczjGGQzAg4Ze2o0
         6VEI3TKY85C0IkTFIPA9owNnvTU5v764eC7KgpVVXP+ZnKT5kr/L2J08mnZiejbHndHd
         4yTdbbkYEH5D2ElWpgzEMl5cpz7UIBb9dyhiwUVsNrds6UAr4NIJlhLc2jSvLf1GW9oi
         ubOPlHsTq7zRyoJ+HO9RnUsAKY4QHtT4TTmQStlQOdbayLTw2vKlY5de4qA3g9NePo72
         E7y4x7cENPlhIhrS2VKgoIKnMZXba/034vou5Dn6nH5tUDbVbCFsDpPk33mLWXGooCTY
         bkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rzGt3ohTkmhBv8LAruEt+vWwCsSIIRCgS3hz/m4lLjE=;
        b=n7LseedN7QqDfj3CQAXU4vkTE22p/lDx74NB1L1fusYh6WqJXdsjJ3rZViaT8GHvnA
         kKW90X6kQ0q/MIEi29BWD/ZaSHxarn+kYM4l7cUnJ3OtwVelBqBjxb+HJOlFo32p1IFR
         JWpec6cu80JR/jLdpVqcvt7eE1KfyrLKuuhJcBo+nnKtwNgykrdhtZ/yDTUq9vB5WLJ6
         dCdVtlncsz05LWItfHyeoVRsR9p0qVvD2Pb/l2Uyw3/MV+XSo4380aemO1EZCNhie5X1
         MdI3j0Vxo/0U3mR4hiLZ7kHDFe3qNetSzhigcM/5WS38YrgC4vVw0RJepQi2ePCLyWSM
         UQkA==
X-Gm-Message-State: AO0yUKV/jids57na/2m2mcUQxof9RmsS131pOEKReq2lGvp5J/juQnJ2
        xahSMHgK9Q+lngnOmCDRjQyC38iGP2BRfZaH
X-Google-Smtp-Source: AK7set+vQqdITEwTOalRt9cREn5fHVjk6poHxhb4eRhJ7XJSEpUpRhou4RYW04BGlJ1I5n1nutX4aQ==
X-Received: by 2002:a05:6830:3484:b0:68b:d9d3:d8f with SMTP id c4-20020a056830348400b0068bd9d30d8fmr5133647otu.3.1677261369667;
        Fri, 24 Feb 2023 09:56:09 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:aecd:86a3:8e0c:a9df])
        by smtp.gmail.com with ESMTPSA id m21-20020a9d4c95000000b00690e990e61asm3296778otf.14.2023.02.24.09.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:56:09 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, liuhangbin@gmail.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH] net/sched: act_api: move TCA_EXT_WARN_MSG to the correct hierarchy
Date:   Fri, 24 Feb 2023 14:56:01 -0300
Message-Id: <20230224175601.180102-1-pctammela@mojatatu.com>
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

TCA_EXT_WARN_MSG is currently sitting outside of the expected hierarchy
for the tc actions code. It should sit within TCA_ACT_TAB.

Fixes: 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG to report tc extact message")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index fce522886099..34c508675041 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1596,12 +1596,12 @@ static int tca_get_fill(struct sk_buff *skb, struct tc_action *actions[],
 	if (tcf_action_dump(skb, actions, bind, ref, false) < 0)
 		goto out_nlmsg_trim;
 
-	nla_nest_end(skb, nest);
-
 	if (extack && extack->_msg &&
 	    nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
 		goto out_nlmsg_trim;
 
+	nla_nest_end(skb, nest);
+
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 
 	return skb->len;
-- 
2.34.1

