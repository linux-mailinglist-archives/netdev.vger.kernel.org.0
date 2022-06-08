Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76E554385E
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245091AbiFHQFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245061AbiFHQEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:04:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383A227CCE1
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:04:50 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q18so17999027pln.12
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Erpi5T5vsmcmL5HzySima+v0cDynsgqf2csS6PQALjs=;
        b=Unqkl6bfVR5eWUmXek9FUuaQgAF/5XOU6ElF57/IR66+xEHZ9WEQaWHSjWWRIrBlMX
         X3hE16eJL8WByXD8MGw1jWJG0g0dgoyMvKb1ichJz7VLiK0ZCsGnwKAK/7MSskRdZtA7
         Q4KB52xdx1sx0FI0m2VrLpfqzmFZW/noSl7dHYdx5AC2nHNEgOjBzZAAsLUtjjB4kZ2N
         dF8VDLVDn8CHVauoRuJ3AuMS+ES8jU/HKJnwq3j9qVivRhNwgm7aQlTTihIQOHI8XeoU
         E1MS3UnKR5m80/EolTQ2p5bTBlAw9QmXEQweVi4UzKQ2bVtNF6tYSCK8UnqUw/1XakeO
         1MTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Erpi5T5vsmcmL5HzySima+v0cDynsgqf2csS6PQALjs=;
        b=f1UBzbY1lwba2Yz322GMdy8OVmpuG3v7YjeHsFRt2eNyEYGzge/oFx4jUe0d8LoCr4
         GT5hYSFxNqVmNcbyIb+6rc3QNLI7WR6aFYxT+5cWdd/qMYwQC7216tydHX3IAUPbj55X
         NBbSuNSSSWvYtEQ5DB3bmH5+1C/GfzOKCJ/LRi3on/kYFkGVt9L+mKxUQHiS1SKuCaow
         FDux9F2nfww2ttVxUi+o3k4XnJ0r571Ce/90VzeepxTQHHAwI5vV3q8L/olasy1OhJjw
         5TJNtj1vGJIQ8eB0QaCJVgk+nn0YePLhH8S5z3AJjERIrMTafaDWBo/waubPIs0mRrrc
         5bSA==
X-Gm-Message-State: AOAM533cbC686igEIcvZ8Ei4gPPL6rlv7RI4IMpNybTpRUymvrG1+9VG
        1TXcAVa8D3ioqqX+koF2MV6wMkxSlWw=
X-Google-Smtp-Source: ABdhPJzLD033NN618dcWkMwMpWVtwSjyHXBlQ78lOtmGW7KP4FD/+BzKhH6Okti5sZEpty4ko/MnHw==
X-Received: by 2002:a17:902:b689:b0:167:8b69:d1a7 with SMTP id c9-20020a170902b68900b001678b69d1a7mr11786758pls.156.1654704289732;
        Wed, 08 Jun 2022 09:04:49 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id ju10-20020a17090b20ca00b001df264610c4sm18622019pjb.0.2022.06.08.09.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:04:49 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 6/8] net: use DEBUG_NET_WARN_ON_ONCE() in skb_release_head_state()
Date:   Wed,  8 Jun 2022 09:04:36 -0700
Message-Id: <20220608160438.1342569-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608160438.1342569-1-eric.dumazet@gmail.com>
References: <20220608160438.1342569-1-eric.dumazet@gmail.com>
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

