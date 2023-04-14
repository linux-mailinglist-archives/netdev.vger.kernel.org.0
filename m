Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8046E2BD1
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjDNVng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDNVnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:43:35 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B9112E
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 14:43:34 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-187b51ed66fso3343971fac.6
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 14:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681508614; x=1684100614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kaVB6FqzkIVQTjXyQ1bdGlBUjLvgKvOTfzN1BdC6zv4=;
        b=IoOcoQK8mAv82hpz96jsD/eLEAG0COMFPaylIzJJEUicwN1pXp0E2jv07fXUMrt8d4
         FfGtpYEHTZR0dRnqTO5HhHGmYoK979v7HAORwEL2Con19f55I8jDVXNAk+lWgd8DnHl4
         yA3cnC3hrTi3K1UB0uK2vVkI7vypt46hV44WiA4JhVkEbfeoIilkYkKJ+wZugiyfQvpZ
         iDdeZ9FEGhYorEy7GsFNxh+MdFAqSiFvbVb4JRwybfvyJ9wBz+t9u2hRqcZqeaTxyHqx
         ns8zhGxOOvO1mrDOq0k2E8+hS69fuIpVpd1npEjqjzKMktZM/ymjYvKFnLTl2qUK6APw
         pLPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681508614; x=1684100614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kaVB6FqzkIVQTjXyQ1bdGlBUjLvgKvOTfzN1BdC6zv4=;
        b=Rvkz3ia1akjsGFmVhAKAQDSId/TidMMUSZyT0oagbxg/SkFFEdmkwhoGEtRCloDMnP
         30qb5x+s4fsio0RGqvLkT4nlKo5n/d8gf1Iy5P4NfOyj7mKo5b6TrsxSQBI+Pdwzcd0V
         97O/xwACjg/IOvJYl4WeLl+ZKfSP8YJA5UCVrAwu1El3tyrr8uikO/guB0BlhukpEbgd
         VS5Q0ynvHjeloeF4UYNv7nEslF8RreDKhGOz2H1eh6TEAs8N5SiKsj7LkJGa473K+Huq
         YTIrnd44nyCBA5sgdH+3nAmxpG8yv8VWtm07tfQBI465gWRfjke0pIVGHiis9WzbsUqo
         GiUQ==
X-Gm-Message-State: AAQBX9eXtZt1+a9g4AHspuD8Vc3IZFl7h9DNSDXHt4Q1uz4fNLYs3RjD
        h0k+rCI1gyVs10s8miNtmbFiM1JaxCamh5RAKs4=
X-Google-Smtp-Source: AKy350Yx0j+qpoggbj1jeHEzt2srHN9bdofQnttjBndmzWLhLFyTWId+Yz8Mfws+fX/SUJ/ZXKiDpQ==
X-Received: by 2002:a05:6870:8290:b0:184:4016:a08a with SMTP id q16-20020a056870829000b001844016a08amr3443354oae.10.1681508613834;
        Fri, 14 Apr 2023 14:43:33 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:bb6:61a2:bf8b:4710])
        by smtp.gmail.com with ESMTPSA id yo29-20020a05687c019d00b0017e0c13b29asm2212463oab.36.2023.04.14.14.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 14:43:33 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, marcelo.leitner@gmail.com, paulb@nvidia.com,
        simon.horman@corigine.com, Pedro Tammela <pctammela@mojatatu.com>,
        Palash Oswal <oswalpalash@gmail.com>
Subject: [PATCH net-next] net/sched: clear actions pointer in miss cookie init fail
Date:   Fri, 14 Apr 2023 18:43:17 -0300
Message-Id: <20230414214317.227128-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Palash reports a UAF when using a modified version of syzkaller[1].

When 'tcf_exts_miss_cookie_base_alloc()' fails in 'tcf_exts_init_ex()'
a call to 'tcf_exts_destroy()' is made to free up the tcf_exts
resources.
In flower, a call to '__fl_put()' when 'tcf_exts_init_ex()' fails is made;
Then calling 'tcf_exts_destroy()', which triggers an UAF since the
already freed tcf_exts action pointer is lingering in the struct.

Before the offending patch, this was not an issue since there was no
case where the tcf_exts action pointer could linger. Therefore, restore
the old semantic by clearing the action pointer in case of a failure to
initialize the miss_cookie.

[1] https://github.com/cmu-pasta/linux-kernel-enriched-corpus

Cc: paulb@nvidia.com
Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc action")
Reported-by: Palash Oswal <oswalpalash@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2a6b6be0811b..84bad268e328 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3235,6 +3235,7 @@ int tcf_exts_init_ex(struct tcf_exts *exts, struct net *net, int action,
 
 err_miss_alloc:
 	tcf_exts_destroy(exts);
+	exts->actions = NULL;
 	return err;
 }
 EXPORT_SYMBOL(tcf_exts_init_ex);
-- 
2.34.1

