Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25FA58C212
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 05:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiHHDbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 23:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbiHHDb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 23:31:28 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB23B101C4;
        Sun,  7 Aug 2022 20:31:27 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-10ea7d8fbf7so9236486fac.7;
        Sun, 07 Aug 2022 20:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r5rwo4MClopVYNBDSVFISgAhr1YiHSTdz7IJx7vtnx8=;
        b=OF4kIqELYjTV9D6nl6RxP86+WuBujC0QDALDIBECVbVfx3FIvb9pnZdqDSfazRSq23
         bD2b36Z4Q4r+DG7DmqRhq7sPd1IzfyHULWfZinNbC8RQIkeXYpbNHHSZ6jVG8R+YgHji
         5Ccm/Ij7g5H9Z2ZfuQqGSTVNz7O2dthP74U70YlniGfyFSkcZObT65uNPdgVHW3dv2pr
         XU6kqQ/uO+kNu8OOmls2TeR0/iiBz/clHrYfnQHW+/XRCobgzGlegkRffN5npluWDRin
         vpqq72mPR4u66n4dI5XH6xEG1m4PksSuCgW7cAEtxtpJrKKrfPcpt3bYQEqG77myuEeX
         7rHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r5rwo4MClopVYNBDSVFISgAhr1YiHSTdz7IJx7vtnx8=;
        b=62V9sTtaMprh38JI6P9FN4PYJ7EycQerrO1aNLXFzhxkAqhR5S3lXfxpLc+vdY7qse
         GQDRkoBkgK7k5KRFly3ukq+gPjERGAddXj5CwkDEjCPpU/ZRN8XC2LWhKBKK9hGDLxw9
         8ct85qEfv1PTy6iMbNsVzlKkNjdnKgqOB06XL8Bj4NJWa3muvXBIKOZeUV6+U2OIBDxA
         p0Zo3DBzPodcfuMjldcOdHJFAMB5sDIQRmmc6xry4R5xUvGvDKm0rgRN+5Zuw3uXunWz
         2U0U0kEK+p9a9vYsjCwPjY54BUCze0hxYRfG/jd92FLLAlgYGlWrpKM0pMK8cCtVySLP
         nRJQ==
X-Gm-Message-State: ACgBeo2cdka7y/2G7neIh2aFzKoISlq+MuuUEOuQZWco8ogIzaonGQxt
        U8dGzNjH0UQFFB+tgr1OhPY6BX9jeSY=
X-Google-Smtp-Source: AA6agR60FfYgrHi8iqWqRx/xXe+UguwRI2xOB7tnlrFr68B7Pyd9xBPIjJWL07Mh6BuzPLvzWw4uqQ==
X-Received: by 2002:a05:6871:1d6:b0:10e:6a7f:cc3b with SMTP id q22-20020a05687101d600b0010e6a7fcc3bmr10688426oad.210.1659929486997;
        Sun, 07 Aug 2022 20:31:26 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:ad03:d88f:99fe:9487])
        by smtp.gmail.com with ESMTPSA id k39-20020a4a94aa000000b00425806a20f5sm1945138ooi.3.2022.08.07.20.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 20:31:26 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch net v2 4/4] tcp: handle pure FIN case correctly
Date:   Sun,  7 Aug 2022 20:31:06 -0700
Message-Id: <20220808033106.130263-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220808033106.130263-1-xiyou.wangcong@gmail.com>
References: <20220808033106.130263-1-xiyou.wangcong@gmail.com>
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

From: Cong Wang <cong.wang@bytedance.com>

When skb->len==0, the recv_actor() returns 0 too, but we also use 0
for error conditions. This patch amends this by propagating the errors
to tcp_read_skb() so that we can distinguish skb->len==0 case from
error cases.

Fixes: 04919bed948d ("tcp: Introduce tcp_read_skb()")
Reported-by: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 5 +++--
 net/ipv4/tcp.c   | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 81627892bdd4..f0fa915cfe16 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1193,8 +1193,9 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 	}
-	if (sk_psock_verdict_apply(psock, skb, ret) < 0)
-		len = 0;
+	ret = sk_psock_verdict_apply(psock, skb, ret);
+	if (ret < 0)
+		len = ret;
 out:
 	rcu_read_unlock();
 	return len;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5212a7512269..5e99ecf5515f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1766,7 +1766,7 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		__skb_unlink(skb, &sk->sk_receive_queue);
 		WARN_ON(!skb_set_owner_sk_safe(skb, sk));
 		copied = recv_actor(sk, skb);
-		if (copied > 0) {
+		if (copied >= 0) {
 			seq += copied;
 			if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
 				++seq;
-- 
2.34.1

