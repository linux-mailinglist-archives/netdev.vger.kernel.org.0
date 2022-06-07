Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE7C54049D
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345501AbiFGRSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345498AbiFGRRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:17:53 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F8571D95
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:17:51 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n18so15362290plg.5
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Erpi5T5vsmcmL5HzySima+v0cDynsgqf2csS6PQALjs=;
        b=T1hty5uA8ZBjyQJ6ic8Ku3+Upd4Ys1KwcnKDkE22qrsAZOBcaFJb9L1JhYwPSV81oZ
         pbvH+ZW67oiG0MBzyy7OPL8mmYTKanfuGqAme76HvRYNtkg6JXhFuXG1nb8cL00R0kge
         hErd1G1QPrnHVmu/G+0wcLY6mGLJFGoZgmo2Wy6QdBnOteLMjQyh7iNLFmA59wJROzbI
         oQ/xAsGWQWmN4sJ3EM0B7uA+aI0zuSgCUm6Gwg5xeOb/fQnYejlqplBRak/aLVFbD+nJ
         o1yXTL7tcc+6Qj8GRkiwyiLWfSKrZ/UJ7ZRS0KVr0Wcfnmrt723E0MGrUNHm6lrFFcUj
         s4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Erpi5T5vsmcmL5HzySima+v0cDynsgqf2csS6PQALjs=;
        b=6YyPs1kbXWwt51SWfwaT4nFoco1l90Fc+fTo4iyYQRbO73UsmMJ7Sw4hs5UfyLpKkN
         TBlEFNlWlBOG7qcWXYfd6YI+aYfivvTmzKdtEVi8GN7pLWNA3A8+yqwa/asaRWta42Uk
         6WhESScwuuma5LKIW4r4Cp93rxuW1Vzf3CtEs+5MHkR15ZZcy2kJ1Cg5xYnDLs0UaYpm
         iDt0kZsu084K8ejOgGa0yBa6AfIa1v4U2JpOWEZf+U9g13qW+4YM+k1CQCs94mqsp/T2
         DbVF7KcN+MUXOio/+pqkEpJ4+LoaPgMndoQ7vX4D1G4s5TAxmbcm2oe8+ESpvt1ROK6W
         j0FA==
X-Gm-Message-State: AOAM530JQ15qFyBCdsxz31ZQ04tfMoWz6JufOqyEZn/PStMEpWFjzH1w
        rVTWx+t2kmInTw8mBDG2Psf8Y+EI9nY=
X-Google-Smtp-Source: ABdhPJzRK+Fuo4oTO1XWnSJ1cFy++YQZk8RbROTatF44l73AsMXweoEkvZPNwVojgd8sULEZ41GSvg==
X-Received: by 2002:a17:90b:180b:b0:1e3:2871:6be3 with SMTP id lw11-20020a17090b180b00b001e328716be3mr32700414pjb.85.1654622271036;
        Tue, 07 Jun 2022 10:17:51 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id d4-20020a621d04000000b0051b930b7bbesm13001616pfd.135.2022.06.07.10.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 10:17:50 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 6/8] net: use DEBUG_NET_WARN_ON_ONCE() in skb_release_head_state()
Date:   Tue,  7 Jun 2022 10:17:30 -0700
Message-Id: <20220607171732.21191-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220607171732.21191-1-eric.dumazet@gmail.com>
References: <20220607171732.21191-1-eric.dumazet@gmail.com>
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

Remove this check from fast path unless CONFIG_DEBUG_NET=y

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b661040c100efbb59aea58ed31247f820292bd64..cf83d9b8f41dc28ae11391f2651e5abee3dcde8f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -728,7 +728,7 @@ void skb_release_head_state(struct sk_buff *skb)
 {
 	skb_dst_drop(skb);
 	if (skb->destructor) {
-		WARN_ON(in_hardirq());
+		DEBUG_NET_WARN_ON_ONCE(in_hardirq());
 		skb->destructor(skb);
 	}
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-- 
2.36.1.255.ge46751e96f-goog

