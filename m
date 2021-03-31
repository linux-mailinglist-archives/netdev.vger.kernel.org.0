Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD91E34F6C5
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhCaCdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbhCaCcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:32:55 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047EEC061574;
        Tue, 30 Mar 2021 19:32:55 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso17576840otq.3;
        Tue, 30 Mar 2021 19:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6NSVMjZHKmhObvQ+/EbKaviQbdzEnvypy6KLGhx7zcA=;
        b=SDJVCpcbKLmrESZEdDuPahoBu3BihPt2aFX+sEnBgqPpTLhA1VobQ5DXeD2hVk6N4K
         gCj9g9lhgIY5cbxZXOp186lo+HlXkiY+eU2l2yKp9q/7R+ytTvZToc4j314E65OAUzS1
         U1r3E8VJqwRa2jJEZ1yNxXpR+EFZ+s/0FKiGwtZoVPCdZNqKW2xv3XzKweBxH7lVvM7N
         ihv9dechoSG1oY/mtmDkIbNFFq6Db0+KdogfKAWr2KHQ9Q3042xDwgpKnJsTGxdGTaX7
         B1+8w/CiDjFXmW91YtjbZJPgCBh8XUrlIbxFWwKYiJEi+EvSZ2qUl4y5wGApxuflrfbX
         bwZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6NSVMjZHKmhObvQ+/EbKaviQbdzEnvypy6KLGhx7zcA=;
        b=EoFpHzEYkF1Blnp/+TxDex+72PdXwj0d0HLG5U8zLp/moQiquFPyRtQp3qwtABWHrL
         xLYXr+JYPZYe5k/Xi9EK7Zi1Hi6+nZ+f4QUSKsLc5+aIkjBuNMKbEbw/1ngqkDOL1ahc
         1vELNrKTrCeX5k9FmpREiLSJB4GUjBHMWnyM7Marmr52b6WX+3+xzaAPnxyUtwKl3gxl
         N3S2LalMO1rxMhEsAj5XmCNLP5ZI+LKwvxvnA6MLc9hrhfpE3TxDpi+jFnJ0SY6Plo5Z
         a7+cFg3H7wrWcQJZtPZMMTyOzNEWvwt7EsrcaULtPhEbTieUg46BcE8j9NLALPtnM73G
         neOw==
X-Gm-Message-State: AOAM5301geddFDSIFtjVAdJaFZ3qxB2V4pi2uWJPuu3HwTlMdiqV9tLb
        1nacjH4T1Hrgm+CbaXhlTMUs1W2UsEexZw==
X-Google-Smtp-Source: ABdhPJzeV/3sReNFHsfyt2/J2XCMEGvutIh11u3PlkjjcNITAfGkKUpwkAWssBxdNEzPZxWz9yNC/g==
X-Received: by 2002:a9d:3e10:: with SMTP id a16mr763475otd.261.1617157974342;
        Tue, 30 Mar 2021 19:32:54 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:32:54 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v8 06/16] skmsg: use GFP_KERNEL in sk_psock_create_ingress_msg()
Date:   Tue, 30 Mar 2021 19:32:27 -0700
Message-Id: <20210331023237.41094-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This function is only called in process context.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index d43d43905d2c..656eceab73bc 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -410,7 +410,7 @@ static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 	if (!sk_rmem_schedule(sk, skb, skb->truesize))
 		return NULL;
 
-	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
+	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_KERNEL);
 	if (unlikely(!msg))
 		return NULL;
 
-- 
2.25.1

