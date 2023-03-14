Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF44C6BA0AA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjCNUZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCNUZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:25:05 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA3E2A6F8
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:25:03 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id o4-20020a9d6d04000000b00694127788f4so9094004otp.6
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678825502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9/4Vb9Ag+cfw7q3a8zKAHcNDFnmlytJGB3KfyaKeoPQ=;
        b=dBqi/7KNlObmSN9IUyXSUOSp9cggZRN2OZZSd7lnjK9UIJe2Xn2qvRVFte6HHTAkSh
         tnwfGBA8z66KzdHJ/FO3FX0CmbwEeZwGyh1D7fIebmSYAkrHARn94X2cWm7wKZOi9GWW
         CziLGFB8AbJ+PPJCmamjh+RBVe0euv39zUn3PVm7TxC5zCfA/HKG7DrAswpffslQLLIz
         C7lXTqnHTXZbJWXlxCaEqV8Vm0Z3aAlcOMuHmyQjxhmRs4BjiI7TR7UD8CBokqYIFblq
         BKG15/T2bzPofzTBG7g59msji8lAI+Y1ZviP7SVXdDye7FxQHVM6tkFAOiPKgfTMvfFO
         ZVjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678825502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9/4Vb9Ag+cfw7q3a8zKAHcNDFnmlytJGB3KfyaKeoPQ=;
        b=Oz/I1i8Ao5ZR6ZYUYz0FxkuDinAd3Sc19EHf3fmHQWTz3McNAjq6l4pTO0AxrLJ+An
         PCugEqzc8VxcmxnBqr7nVaw07Sr8Q5EARnUhv+81AVcun23NqZSQzelT9tlWFYHk5lF3
         prxHrkktWr6yP6Lu4sqCjg6XYR9XqUrVIs/daCsFgHD0Y7DbbXXwolRybH3F81QPhLu4
         MurP1UC98cvCRWSNFMbMMXsh5ump7cinzk3kRRBkTo0oJehkdlq+SO17D8KUC6zT4sCF
         mwG3DVxM3n12jBRF2cElxrIF4ZWRJQkBwMG7Efotsxmb83gvpaY/gaLoBKt0mW7u/i47
         9cAQ==
X-Gm-Message-State: AO0yUKUFzDuXnE7eRByHhMjw6T96MdyXFyQE2oAHg/mMi6QaF4TaOO3p
        LHr4YA/d73py9eci0e+1ON4HxjuuStEe6in+qQM=
X-Google-Smtp-Source: AK7set+zU4BV6VUQEFo6cPIa/SPwMkr1L85E1458ROPVs7u9uvsZ8OIz18eKDMfW4EUVnGspHdcuvA==
X-Received: by 2002:a05:6830:1614:b0:68d:50ac:b261 with SMTP id g20-20020a056830161400b0068d50acb261mr17597420otr.1.1678825502588;
        Tue, 14 Mar 2023 13:25:02 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:95f9:b8d9:4b9:5297])
        by smtp.gmail.com with ESMTPSA id 103-20020a9d0870000000b00690e783b729sm1509278oty.52.2023.03.14.13.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:25:02 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 2/4] net/sched: act_pedit: check static offsets a priori
Date:   Tue, 14 Mar 2023 17:24:46 -0300
Message-Id: <20230314202448.603841-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314202448.603841-1-pctammela@mojatatu.com>
References: <20230314202448.603841-1-pctammela@mojatatu.com>
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

Static key offsets should always be on 32 bit boundaries. Validate them on
create/update time for static offsets and move the datapath validation
for runtime offsets only.

iproute2 already errors out if a given offset and data size cannot be packed
to a 32 bit boundary. This change will make sure users which create/update pedit
instances directly via netlink also error out, instead of finding out
when packets are traversing.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index be9e7e565551..e6725e329ec1 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -249,6 +249,12 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
 		u32 cur = nparms->tcfp_keys[i].off;
 
+		if (cur % 4) {
+			NL_SET_ERR_MSG_MOD(extack, "Pedit offsets must be on 32bit boundaries");
+			ret = -EINVAL;
+			goto put_chain;
+		}
+
 		/* sanitize the shift value for any later use */
 		nparms->tcfp_keys[i].shift = min_t(size_t,
 						   BITS_PER_TYPE(int) - 1,
@@ -407,12 +413,12 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 					       sizeof(_d), &_d);
 			if (!d)
 				goto bad;
-			offset += (*d & tkey->offmask) >> tkey->shift;
-		}
 
-		if (offset % 4) {
-			pr_info("tc action pedit offset must be on 32 bit boundaries\n");
-			goto bad;
+			offset += (*d & tkey->offmask) >> tkey->shift;
+			if (offset % 4) {
+				pr_info("tc action pedit offset must be on 32 bit boundaries\n");
+				goto bad;
+			}
 		}
 
 		if (!offset_valid(skb, hoffset + offset)) {
-- 
2.34.1

