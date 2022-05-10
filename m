Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAEE520C7D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbiEJEB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 00:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiEJEBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 00:01:54 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8588A2AACF1
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:57:54 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s16so3540662pgs.3
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0bseCsCgH8tvgn5RskGxEkKOuDX9KLq4aKs1hGam7p0=;
        b=N/NO5zL85HjNbsr9wIRtxT0u6NJNWEUg1aQd/LQ3OaiBCKm8iPG5u5cT9gX7r/LLnv
         ga9rEPEhnaYH/7lunaaeKbf8lTTmTjXchOG944VEjS9vZ9QuKKA80GZXSzJnN+F/LzqW
         TjI7W2Kenr7Cyt/IX4nTKKd5RsuoIGzJsY8KrsdbfyY9LYMJOZqaC8R79wtl/h3D36Jc
         KC9JPPmUr8FMorgDkiUa5Nkh/nmG5m7AwwTH9jIhQ39mRczjWMkRrzKb6+bOjoRCWZvR
         ++a+2KdCV/nwoKaJKxD4NmcKWzmletq2w1AaSMxhh0iFGQ6qOYzkMbIoN7Rr80BgsVQn
         RZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0bseCsCgH8tvgn5RskGxEkKOuDX9KLq4aKs1hGam7p0=;
        b=KYqvXkEFaoVKOf05xejAztnXimFyet17oYoqQAb9qStki15V7jWNNlKIG9db2XfABB
         rveJL6AJ0NxA8D68oHrgRsIbTYLioCV5Pd4ZcUaKN43OLjd11k3sY0vMT+dB6vluxaL5
         mpwC6FPFjXO5nrD8Iw0Z755Q5OgjDIp5Vu+VfQLTYULL/WONK+i+BMNKGX0/vgGmUqeG
         U0YH2b2nekP9nd0PUmzjgNBrumCZ92deonnR7NrrHPAMKvpkMJVrJjBgfzLjU+zY/iwH
         ltvbAclbCZu2TfkDFSzU+bFT7ZvygE7K2yKXUB79yKtnY+c6F0lsG+9doXdgm5WC+Ig1
         PWJQ==
X-Gm-Message-State: AOAM532FxmddZs5D/C1NpfATybep4/6WyC9Nyt/mH5Hy8R6Q6IvM5aI8
        Ilvp03jph7T8g3owPmSGZZ8=
X-Google-Smtp-Source: ABdhPJzNceyiDZIq7Cm7kkShXXhwJa3bF2AOdTklGkJ/uWNooRHGVIp44aEzzJouydJAG4V8Z4bEDw==
X-Received: by 2002:a63:4f1e:0:b0:3a6:68b7:cedc with SMTP id d30-20020a634f1e000000b003a668b7cedcmr15349700pgb.29.1652155074014;
        Mon, 09 May 2022 20:57:54 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090ad3cc00b001d81a30c437sm568193pjw.50.2022.05.09.20.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:57:53 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 5/5] net: add more debug info in skb_checksum_help()
Date:   Mon,  9 May 2022 20:57:41 -0700
Message-Id: <20220510035741.2807829-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510035741.2807829-1-eric.dumazet@gmail.com>
References: <20220510035741.2807829-1-eric.dumazet@gmail.com>
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

This is a followup of previous patch.

Dumping the stack trace is a good start, but printing
basic skb information is probably better.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e12f8310dd86b312092c5d8fd50fa2ab60fce310..d3221ea4aab3bfded1d3d9e2b0d861afc1c2eed6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3266,15 +3266,17 @@ int skb_checksum_help(struct sk_buff *skb)
 
 	offset = skb_checksum_start_offset(skb);
 	ret = -EINVAL;
-	if (WARN_ON_ONCE(offset >= skb_headlen(skb)))
+	if (WARN_ON_ONCE(offset >= skb_headlen(skb))) {
+		DO_ONCE_LITE(skb_dump, KERN_ERR, skb, false);
 		goto out;
-
+	}
 	csum = skb_checksum(skb, offset, skb->len - offset, 0);
 
 	offset += skb->csum_offset;
-	if (WARN_ON_ONCE(offset + sizeof(__sum16) > skb_headlen(skb)))
+	if (WARN_ON_ONCE(offset + sizeof(__sum16) > skb_headlen(skb))) {
+		DO_ONCE_LITE(skb_dump, KERN_ERR, skb, false);
 		goto out;
-
+	}
 	ret = skb_ensure_writable(skb, offset + sizeof(__sum16));
 	if (ret)
 		goto out;
-- 
2.36.0.512.ge40c2bad7a-goog

