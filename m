Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C914FFCE7
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237407AbiDMRiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiDMRiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:38:16 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799BC6C49D
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:35:55 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id i184so1953270pgc.2
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7mcpIyRo+K7RjaFosgLOfWGYhlObKpmwUTYzMGAPwoY=;
        b=pptQ534lZHNsAha9XEC+RnlZB19nDBLNAL/TD/Ko9/4Y06qoKQF69TgPKeLYVxKNtC
         9l9BXg2ZxfZyFWui8GUuyLBfmTJjdKXrJO0SxwBhvHcEvbAtaF+OwWEbTwMywswJuiv5
         3bYJr5z7+LBP/kyZCinBSsGtB8xmCHq6fCP1Daz/2qKTAZyXGkEgedZZ5R2mgjFa9IiT
         P9im5Rtpiig/T8aO6I1SGSQAlD6OiABdBGxW1qlchRHSsKYLH2SMEykJ/hCc7Pgni56r
         KlibuoVrvcWuv8LP8dAM/x+3VyI9J9U5EBYCkW/E53Cvg1guWfSipmxrVwPS83+gQMTt
         MRJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7mcpIyRo+K7RjaFosgLOfWGYhlObKpmwUTYzMGAPwoY=;
        b=7a6lQq+m97ks5FHpAc8/WWulDz7dRGP2SXAZoSYeOhLaOe27tQMkazuHycdWV5N2Rx
         2R+KcdwpDY017MKarcxvSXsiBXN92H6S+XNtMQ+Q1G5tJMRwd5nguJPIYB6G1mYzto2D
         ge+kqYWUDAMhSKFM82Yd/RmTbEIWejQnSrhwXdWZVeKDBDa+m1exy5gv2W0X46IWhBEr
         +udqqdSRxbRYTSvD3a0vRfpMKXtn4rtI+7q8FbAAy/fGYfVd5YEFvUzib27owCkKG0Wg
         j/O1x5WT3VCoHaXW3XwkBTbBbfjwWa0QmHzgVuwfJWKVgbSH7MYi9PAAJIzDoUfqtTfO
         HAsA==
X-Gm-Message-State: AOAM531R1RHilrm0wuxGJ41EI0ZmS8bJ9003lRECu9fp8uWahCqNyIXt
        jYw+/C3iWqOscVIFbPZF+4Vq2X/9r7g=
X-Google-Smtp-Source: ABdhPJxCzkV0CWSgFRfiXOEsekJmc64aHYpWeWcJUemwHqtjuZ087Y4r7lNBSlD27W7ysM70gC2SUQ==
X-Received: by 2002:a05:6a00:2290:b0:4fa:a99e:2e21 with SMTP id f16-20020a056a00229000b004faa99e2e21mr44053245pfe.20.1649871355008;
        Wed, 13 Apr 2022 10:35:55 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bfb5:153b:b727:ea])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6da3a1a3bsm48546402pfk.8.2022.04.13.10.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 10:35:54 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 2/2] net/sched: cls_u32: fix possible leak in u32_init_knode()
Date:   Wed, 13 Apr 2022 10:35:42 -0700
Message-Id: <20220413173542.533060-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
In-Reply-To: <20220413173542.533060-1-eric.dumazet@gmail.com>
References: <20220413173542.533060-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While investigating a related syzbot report,
I found that whenever call to tcf_exts_init()
from u32_init_knode() is failing, we end up
with an elevated refcount on ht->refcnt

To avoid that, only increase the refcount after
all possible errors have been evaluated.

Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
---
 net/sched/cls_u32.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index fcba6c43ba509a069c593d525daf2943b4079538..4d27300c287c46d11bf9d44f8c66eded9e734581 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -815,10 +815,6 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
 	new->flags = n->flags;
 	RCU_INIT_POINTER(new->ht_down, ht);
 
-	/* bump reference count as long as we hold pointer to structure */
-	if (ht)
-		ht->refcnt++;
-
 #ifdef CONFIG_CLS_U32_PERF
 	/* Statistics may be incremented by readers during update
 	 * so we must keep them in tact. When the node is later destroyed
@@ -840,6 +836,10 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
 		return NULL;
 	}
 
+	/* bump reference count as long as we hold pointer to structure */
+	if (ht)
+		ht->refcnt++;
+
 	return new;
 }
 
-- 
2.35.1.1178.g4f1659d476-goog

