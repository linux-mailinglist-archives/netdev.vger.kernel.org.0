Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D2E5EC846
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiI0PkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbiI0Pjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:39:36 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977407172B
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:37:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so10471746pjl.0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=ykCQj/F1ypqbvqexiYMjYhFxNcu6uF4BGSAsLrFhFos=;
        b=AoTNrZ6i/DA3ZJMwyJ1E0YeMp99pdWHG1nuqWQZsW7ASfoRYoBHZhy4+sypx3iJ914
         aD6tisqFBf3zyz/vv99eurUL8/9mD4qSULoVzrrnjSA/ae4Vz7KBUZCVx8ROOTsi8K8E
         foooo0cNNM4fUY5TRC6JrjK2osBxddtlVAkt8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ykCQj/F1ypqbvqexiYMjYhFxNcu6uF4BGSAsLrFhFos=;
        b=FWmKeGahsH3iGDcSxcImt5WmvkAaFlSQ4B9+OvZXnny+Nu2OFReMX9oG2gKHBEP98h
         JvOOhCgnsQUCb8OTmID13apuFvri+O/uGUR1xMliq8K7HKYh0DfSbHYO+8FBMosTB/4y
         ObLBeQ1WxNncF6/br62lp5pFVkPsCpcT4X//fuB7AMHcprragU0dOdDaz5MmyNsVqmgX
         5gu83uzOrdx75CSANUmAaxlR1bKttZHEBOLtjAPSDijEzX7kKnEApKYKClt/5TB67Z31
         SxNsuIwoYw7qMZlAY84QQw7QYVBO6dM7lHF4MFPMA2AsBxbHhxLWjS9LPbR52CdglmkO
         5j6w==
X-Gm-Message-State: ACrzQf1MGMFegGPpRfVIEcxPTRhKmQdIksH/WSPEOnRsfPzA7TkoJqME
        IuvSqk53yI90l6McF784tdY6jA==
X-Google-Smtp-Source: AMsMyM4naSQ2tfT6ukvZrllCFAbhDgh/m5kkTJyLRd93cbWNuZl123In5MUJoO5CqKmQlmhLuDEW9Q==
X-Received: by 2002:a17:90b:2785:b0:203:6279:f03a with SMTP id pw5-20020a17090b278500b002036279f03amr5267591pjb.36.1664293031076;
        Tue, 27 Sep 2022 08:37:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i7-20020a170902c94700b001754064ac31sm1720685pla.280.2022.09.27.08.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 08:37:10 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] net: sched: cls_u32: Avoid memcpy() false-positive warning
Date:   Tue, 27 Sep 2022 08:37:01 -0700
Message-Id: <20220927153700.3071688-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1780; h=from:subject; bh=a5kfZGJ20b02uPWXgL+F0pZhrLA3yDR5ugsapwWzdVQ=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjMxibiOsVeOwkPIgAZeyeGKuoXXag6IdhCVwdK/mY wPyLQjGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYzMYmwAKCRCJcvTf3G3AJriyEA CPC7YSelum/IEpcDi7K97nEgWYsr8mtNQH1474+2H4xJLyhNW3HAMl1vTyCeMjvYmOD1aYN0xQ5teM LmKF6oPT44UK0btmPpAVOqyGNOV3/R8NvRRcCt3I/qv3AsQP6Ly3Ah4jaCYlNE5DYQsG+coJVVmJB7 535LwZTqcC9rI4xRNGfLr8af/UnLd9FGt2KbBnZ4NK5hiTgDET1qGYwK+EmgBpRtJZgN+SeagpND1b EdSXKgo7Zouz8Sh7xgWTYmHvOPDAbC3nb+oUmd+tg3rw9i2Cztj3UVHhxf8jQFJ1PNSi8Szmw5Edh/ DWl13x831rcqnPaIuaT8Abt4L+ypjwZZ6flOQxYCXGR5uIwLZBlpH65AMJJgRsZSsUJDrZd62N5V2w S39qNbLuiohGb+gBSPI/UpLSN5z1HeVvMkK+CfXq9Y7/R5xGKstH/COHXZDSoWjHNwYWV3xNeDWLCx 2JeNqT5Nfh7dI7MK6/RowSVlm4wFzOV+8sGJHeYY55Hebx8Ss4SGDx0VPWHJEVg9dEvIFJ/yARARp4 WEPBLJ2t2ncEXWLliNDmYK1gx6DaajGEZjW/c65rTBOUXqMA/r/6XPr38JGNyvHOiMyMfMQg+b2rE6 KknkWeeGmjYq1ZOABLLYpRno65rTj6e23knzZGqxvCR7zLXEsNl3ci2t24ZA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To work around a misbehavior of the compiler's ability to see into
composite flexible array structs (as detailed in the coming memcpy()
hardening series[1]), use unsafe_memcpy(), as the sizing,
bounds-checking, and allocation are all very tightly coupled here.
This silences the false-positive reported by syzbot:

  memcpy: detected field-spanning write (size 80) of single field "&n->sel" at net/sched/cls_u32.c:1043 (size 16)

[1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Reported-by: syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/000000000000a96c0b05e97f0444@google.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/sched/cls_u32.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4d27300c287c..5f33472aad36 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1040,7 +1040,11 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 	}
 #endif
 
-	memcpy(&n->sel, s, sel_size);
+	unsafe_memcpy(&n->sel, s, sel_size,
+		      /* A composite flex-array structure destination,
+		       * which was correctly sized with struct_size(),
+		       * bounds-checked against nla_len(), and allocated
+		       * above. */);
 	RCU_INIT_POINTER(n->ht_up, ht);
 	n->handle = handle;
 	n->fshift = s->hmask ? ffs(ntohl(s->hmask)) - 1 : 0;
-- 
2.34.1

