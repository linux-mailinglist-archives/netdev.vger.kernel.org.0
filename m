Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC7B33355A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhCJFd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhCJFcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 00:32:47 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD3AC06174A;
        Tue,  9 Mar 2021 21:32:31 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id d20so15728634qkc.2;
        Tue, 09 Mar 2021 21:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jiBFQhb007udnKP3xSiYvQ4GEZgCLJgSEXMTlUQvTG8=;
        b=KzeNLpBGh8RO0L9Ad8dBQEg597xPaj0AEwvxXPP/Tb2+0lDeWRmn1SujNVLQHbz5+4
         KaYgq3xfu/yilsqyqSOOdGW3LKth333i/U2AbGIRdJlgpYDvjjrDdeppifnsDqxSnwuC
         CQ8rx07WzlbpDz+D54FB0xVTIJbcToUNK4/Jh4Ni3NmQPS9oL6jYDdob2pb5WKmqokQc
         uF02PuBSwAWRVv290nbPIv1a/YyGjoIRA4JY41dkHUvYfvCxV+5/BxFuqxWiZbG75T6K
         Inpaek1a21crzHHTcGTVzhVUnUwtm0/dbfc9ES0D9gclaqBh0ZSXq1oXV4dqpMYv2Jm3
         HNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jiBFQhb007udnKP3xSiYvQ4GEZgCLJgSEXMTlUQvTG8=;
        b=eKzd+LAm2UI3KP5bXZw4W5Xn5cgmLoG0q0twP7aFg34oU9Crq82JWiuACWrBxbyPun
         ymYMl+49lv5OCOcOrp/sp3aw33mw2EsjbSEFVeie8uyUnblfYEyzuTREEJU1oN92lmSM
         Hex2uHjVn+wSkhLeCYB/2TI0sqIq+an6oWb+voxM1D5ExN4zypamQ2iAkL3OPz2cytI0
         UOYUr7hPUmrgts3WWZv/yFz6zhD+OIAs/P6Qm6cXoJrYY+d2t4lm4G79WOnzkFNab4oZ
         jSyy1qZuiTKBxTqK5WvsDFnLkqCnUtNCEa609KZXicPD89+Th6oI95Lcg/2PP6NEQyia
         c3MA==
X-Gm-Message-State: AOAM5336sZz/huXD5j/HZdQwXaKF7GVqolJeD2FBxWiC3YBY9MwXDBf5
        J4HmyVD0g09zbsDD++i8ZoacxFhr0p9wxg==
X-Google-Smtp-Source: ABdhPJxANgbY8NFYDuk1Sy3Lrc1UssiQaYXJ4thtbJcoBQp2njNeUbqBVMpcwuuA68Dw+l/m4/4Qig==
X-Received: by 2002:a37:9bd1:: with SMTP id d200mr1153637qke.328.1615354350734;
        Tue, 09 Mar 2021 21:32:30 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:91f3:e7ef:7f61:a131])
        by smtp.gmail.com with ESMTPSA id g21sm12118739qkk.72.2021.03.09.21.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 21:32:30 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 01/11] skmsg: lock ingress_skb when purging
Date:   Tue,  9 Mar 2021 21:32:12 -0800
Message-Id: <20210310053222.41371-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently we purge the ingress_skb queue only when psock
refcnt goes down to 0, so locking the queue is not necessary,
but in order to be called during ->close, we have to lock it
here.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 07f54015238a..bebf84ed4e30 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -634,7 +634,7 @@ static void sk_psock_zap_ingress(struct sk_psock *psock)
 {
 	struct sk_buff *skb;
 
-	while ((skb = __skb_dequeue(&psock->ingress_skb)) != NULL) {
+	while ((skb = skb_dequeue(&psock->ingress_skb)) != NULL) {
 		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 	}
-- 
2.25.1

