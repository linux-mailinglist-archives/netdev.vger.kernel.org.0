Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C326D642E76
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiLERQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLERQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:16:02 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230C01B9DB
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:16:01 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id s30-20020a056830439e00b0067052c70922so856557otv.11
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 09:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fmE6o7d7fvntn++wwu1tqKlh3U35UkULWAbCQ1sRGz0=;
        b=dEUZHrXSHooYu+Wk3FtBLDknPV0WjdWj4uVFn+7gicHtkqsaNN7LDW2jlC9V6BUHjk
         K2ToqWNEa3MHQxmC98e+yza/G9sfznBu666ENCpdbGIu5hiVUlt6EdC0qBR57P/uXqMU
         0XUs4K2VeeOnNPn5JdUWdyk1rBSLZb+5vLbv/p8uHNOt2xWUAUJ1tUa5eH7GG1FnB5og
         9Y7YbMz2l61tM1/nbF80g25CMQkymwAMydReyZJKsiKBu4e76nTCBTnLnDXL6gm2NY+d
         fEabwZzL9vOznRak7U97KFFJPuRtUiIBFNqeIvG3v6BWSslKCud9kNuUV0gNnXcb/B8A
         VADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fmE6o7d7fvntn++wwu1tqKlh3U35UkULWAbCQ1sRGz0=;
        b=MId54AKzPb/Wi5sgadXYvAikimabHCOIrQoJBVfdUWTLA5WSgCWq17wguUdKIiM/GV
         HnBJsSVWV87BKRUTzXlxjLs4LlFgTmbSIsDIMl/aF8CFOmDL+cxv/O0KLMlgvxfwUeP0
         PQr8V8Etnub6tkxoCi+ajOdVUKv3pprhJAuxEYvTqGCYwvKB2Df/xk/z77r8mJ3MdmTE
         ImEuTHErc5C3pfISIhVCPShTfqmQDsPSRWg7p0bEluqP+w0unLH0/4P38Nb1H7yJ/ctI
         crHWFdH7FGbY2fYDmun8Fef9A5dXP760Det8JwJQCfbPUu2kkIHScxlvjyj0K3bYYPoc
         AqVQ==
X-Gm-Message-State: ANoB5pn+cdzvv1YD14CbAefy6TLT+Mmv/vBbA9pcG6lhOduH+bIdXfGX
        sHO3lGfxMsNHzh6ivYC1Sx31zSu9KGibEaFhydQ=
X-Google-Smtp-Source: AA0mqf49nyBn/oQoYEX/cLBkj4hBDxUXrBD19YqNny/ghU2DQXPcJ3y3mEqjVbrlXuLayVyAMD9b3g==
X-Received: by 2002:a05:6830:1604:b0:66c:52cd:cc31 with SMTP id g4-20020a056830160400b0066c52cdcc31mr42451435otr.88.1670260560364;
        Mon, 05 Dec 2022 09:16:00 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:56de:4ea4:df4e:f7cc])
        by smtp.gmail.com with ESMTPSA id l17-20020a056871069100b0013d6d924995sm9429225oao.19.2022.12.05.09.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 09:15:59 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net-next v3 1/4] net/sched: move struct action_ops definition out of ifdef
Date:   Mon,  5 Dec 2022 14:15:17 -0300
Message-Id: <20221205171520.1731689-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205171520.1731689-1-pctammela@mojatatu.com>
References: <20221205171520.1731689-1-pctammela@mojatatu.com>
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

The type definition should be visible even in configurations not using
CONFIG_NET_CLS_ACT.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
---
 include/net/act_api.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index c94ea1a306e0..2a6f443f0ef6 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -101,11 +101,6 @@ static inline enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-#ifdef CONFIG_NET_CLS_ACT
-
-#define ACT_P_CREATED 1
-#define ACT_P_DELETED 1
-
 typedef void (*tc_action_priv_destructor)(void *priv);
 
 struct tc_action_ops {
@@ -140,6 +135,11 @@ struct tc_action_ops {
 				     struct netlink_ext_ack *extack);
 };
 
+#ifdef CONFIG_NET_CLS_ACT
+
+#define ACT_P_CREATED 1
+#define ACT_P_DELETED 1
+
 struct tc_action_net {
 	struct tcf_idrinfo *idrinfo;
 	const struct tc_action_ops *ops;
-- 
2.34.1

