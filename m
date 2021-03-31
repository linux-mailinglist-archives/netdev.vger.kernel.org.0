Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7217A34F6B7
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhCaCdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbhCaCcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:32:48 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A74BC061574;
        Tue, 30 Mar 2021 19:32:48 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so17565976oto.2;
        Tue, 30 Mar 2021 19:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=azpBQutchzCr3FplNtXl63QhozAq1NlwxEgz2eiaadY=;
        b=kBf+h/AIoHx4fu2MmfkD8h9J7SyGsjPU91DNETj5SIfIoZuWXzrJZIJ1ADtcznpiKU
         CVBW/3kk96E8J5tLiy+2U9Om7SRIOG9Vkf6OAdu04sG8MsA+FKiATqPxqWyo8+Y+k6E5
         hNPcI+mE8zCvu+i+ZpXs+6IDBcpMvo5wj60/rk3GXIvNmVhXvpGh7LsJByVhlunrBBgG
         d/XDGQ/HVL01L//OAGW5e1S7td7gNa+9Lu1CNUZ/IWUFr6sPQ3+/EMA4/gfzllTN+pzB
         MaiaUQfr0XaS/CNpals9J0rmlel780PRegvEHdle3FmH7VIeZd1AK/rWVI98e+qquVTP
         ZJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=azpBQutchzCr3FplNtXl63QhozAq1NlwxEgz2eiaadY=;
        b=ZvciV3JBdZrQZQ3BiEJdc9mlFfoWdJdNuiKJayI//5oETZ2iJozka0l0orKFik2s8j
         m8vPjTZl8QPAKsNr3wX9AwTRDkM5m0q2or2Af0t95mLbb+TWDZFP30K/1xeYL1MTkQve
         wkdc8AQqVWSOKtG/hnNMsfqlVCSz8AMtH7MS/nWBNyRf0/vRA4+fGx+bzldma6ZaoBbT
         xoi4tohqZU1AOsYlaOVcAKMvSaRQLSqGjrgEVStYJ7F8qBXMhsAKGrbqELWjuPM9vA0X
         +83C9WW3MoHXp/IpGXhcZo2t9RSX4Dr+tZwHEJLujrRUc9Sh6Ewfoa222u1+7kVkIh/l
         2Hqg==
X-Gm-Message-State: AOAM532rD2+v2r+VZ+JGYb0rOwg78vbjjnNEIktGjeyfkyqFSWMDw7d2
        ma5jQIoSsBpdTgRqx14J3JFaa/+2vG4awQ==
X-Google-Smtp-Source: ABdhPJzqxSB1fVkP2cdWPSaMqufh6YautgKdaLuKmrhlD5JuCXXZEgKRCQnOZkYk6HZ4UAkQYE4uFA==
X-Received: by 2002:a05:6830:343:: with SMTP id h3mr729857ote.201.1617157967944;
        Tue, 30 Mar 2021 19:32:47 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:32:47 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v8 01/16] skmsg: lock ingress_skb when purging
Date:   Tue, 30 Mar 2021 19:32:22 -0700
Message-Id: <20210331023237.41094-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
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
Cc: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
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

