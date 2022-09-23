Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6AF5E71B1
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiIWCBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiIWCBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:01:07 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D582CE62EB;
        Thu, 22 Sep 2022 19:01:02 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 207so10913377pgc.7;
        Thu, 22 Sep 2022 19:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=bB9Tyz2MGei/rxt2bSHk0QAaaZwHT52srHDPcahTgFE=;
        b=g6Ko2HQJlKOW9u/0K7tR1qSeenReSxha99ver8JK4vZIauL7NTk1136eIxYpTsW6jk
         qyWWTyPHYqZWA3Yoqh7HulLJzZiyQkyXxNZMDl0zyA6iNxImQ5IkuzlVx0UGgJG8u+Ph
         5UZlJ35XKZrkDaEfYSnrAYF95ClMxY/XwbeWsXw7rOgf+CV6OQZCwxoVfKOgv379pd4p
         ecEITttOiMKlszLbMqEjStDEGPDLxJl0UCCDKrJIapR1pkGuSrApBIHnhlrnaynWt3sB
         Q0DQktZL+PhRtPE2cIr9Gg/BGtuNK11xodsj2zob6y6XJXEV4+NOtj733FNh6TLJqkgB
         Sxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=bB9Tyz2MGei/rxt2bSHk0QAaaZwHT52srHDPcahTgFE=;
        b=Mcso2e2izflnjxH8PM3B/P2Pxd43S7zGxDXaoMN/X/LK7l9a4QsEn+sdztDusTlNO0
         NkjX82bI9FNHI7LY3JZHqbKzVBEZTYWDrujC6d8w7HDdYJcU0mLv0o9tPiXFGnN5Fw7a
         OHIvjH4FVJaegUkEt2JlVIUTXWgG+kWlQOYYQ6yK0qiR4gKr0bOdUXAZFzCrfRsh6JIF
         kDdFDSUKhTZo0/0tV43gwVvUWHEGQAz5Uwi7cX+1OKBaq++hmPAIc5Yx36Q0khnwk9LO
         aD17PsWCDTJFIQVf8KFmw3XegYQSi97s8phQGL9nxSNKq32tqh+BYO5edDRRvxLA16bX
         C78g==
X-Gm-Message-State: ACrzQf2nznHTowe/0TYHSEyuBIUbiaO0EIYLU41Lqor9ol8BlQrSCD3L
        KSqRfruupBbZkAvOl3r8QlY=
X-Google-Smtp-Source: AMsMyM6Ov/1W/Nv1auvdPleBF9koIwzyaeFUPtW8rn4zx6dMyGlJsRGYF1TFIL2wAr8G5JkoK1CghQ==
X-Received: by 2002:a62:4e4c:0:b0:53e:22b6:6869 with SMTP id c73-20020a624e4c000000b0053e22b66869mr6462669pfb.29.1663898462325;
        Thu, 22 Sep 2022 19:01:02 -0700 (PDT)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090a5d0300b001fbb6d73da5sm445577pji.21.2022.09.22.19.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 19:01:01 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, paulb@mellanox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH net v2] net: sched: act_ct: fix possible refcount leak in tcf_ct_init()
Date:   Fri, 23 Sep 2022 10:00:46 +0800
Message-Id: <20220923020046.8021-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
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

nf_ct_put need to be called to put the refcount got by tcf_ct_fill_params
to avoid possible refcount leak when tcf_ct_flow_table_get fails.

Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

v2: use a new label to put the refcount.

 net/sched/act_ct.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index d55afb8d14be..5950974ae8f6 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1394,7 +1394,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	err = tcf_ct_flow_table_get(net, params);
 	if (err)
-		goto cleanup;
+		goto cleanup_params;
 
 	spin_lock_bh(&c->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -1409,6 +1409,9 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	return res;
 
+cleanup_params:
+	if (params->tmpl)
+		nf_ct_put(params->tmpl);
 cleanup:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-- 
2.34.1

