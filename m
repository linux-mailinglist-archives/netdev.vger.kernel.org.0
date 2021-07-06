Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877E53BDB71
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 18:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhGFQek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 12:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhGFQeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 12:34:36 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EDBC061574;
        Tue,  6 Jul 2021 09:31:58 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g22so21912262pgl.7;
        Tue, 06 Jul 2021 09:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UnYYMxswpqXM+KQP7uAH2N/4AI0cHpLeFX2DLye7kKI=;
        b=i1HFNdlPloI5NUyFVYC4SHN5HeSKlh+oTx74ZdP3yU0dJ90O1YIe46SYxW25EapNk8
         my3v0/pXWNXeEEkP/XbtFx7Rg8q0Q6WxFyexMyIA8efHZgoITT9Fwh+URH5w3iuu0hkY
         fvwufcwvLA8bXzOmY+DpGkHoAJyBiKNR7k4tlqkgw7LDARgYdGxsIjGIRus1MGSkHeFy
         fNT+15FGTd1vB+rTtL+YJYGWtoIdSp3ZjIyvZBM0hd6pJAjNAgvKQB97Hs8se6KxIkQr
         0TtKDr/l73gtprYEHCn3mPJZXMW24co+QgkrEedmzhgdez2GS0ACxbAjxlZ/kFSF9hhi
         s08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UnYYMxswpqXM+KQP7uAH2N/4AI0cHpLeFX2DLye7kKI=;
        b=Obs85gXqssn63piNVUWZ9lOl3SR5o/6yfsd84HjqFC/F91UqN8Dm5KxOyg8/By/z7u
         dzO1JV5N5qmsePcDtinCgzJk/3G2cnXr+lVZfytaD6f9ker4nyJJjnJxTTQi5zx/fU+S
         hpXzIPrs9l/svCEAW8oKTRaheC2lVrzmriz9OJ31xe41kuWY+zfi9Q/KM7jKrh346JgC
         gD2fC/SbuZuAY7RKmYU5CU4+uE9lcFbKmxEvcENTqj7sNuTKLW8B60hCIup8q3eHE7n5
         4LrMd5U4DUexxvj2+sfAZVDYd59F1dTnsVrX3G8o9vERANm/OLg7YMmZ5jKK5DJxvwTp
         wrsA==
X-Gm-Message-State: AOAM532xfcScu2pEqjZMId179yWBR75MPiKA1kpN9V3viqULON6XfzhT
        93HIESVev2pe+tot/hxcmHg=
X-Google-Smtp-Source: ABdhPJzLMUdY2BhrQYVjcrZ4nH1mTK/tcJH/B6AUZOJQ6Uip7TkUEorkd8wgxfuLYynAzFakJ/sIhw==
X-Received: by 2002:a65:57cb:: with SMTP id q11mr21613462pgr.430.1625589117531;
        Tue, 06 Jul 2021 09:31:57 -0700 (PDT)
Received: from localhost.localdomain (51.sub-174-204-201.myvzw.com. [174.204.201.51])
        by smtp.gmail.com with ESMTPSA id b4sm14942570pji.52.2021.07.06.09.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 09:31:57 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        xiyou.wangcong@gmail.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf v3 1/2] bpf, sockmap: fix potential memory leak on unlikely error case
Date:   Tue,  6 Jul 2021 09:31:49 -0700
Message-Id: <20210706163150.112591-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210706163150.112591-1-john.fastabend@gmail.com>
References: <20210706163150.112591-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If skb_linearize is needed and fails we could leak a msg on the error
handling. To fix ensure we kfree the msg block before returning error.
Found during code review.

Fixes: 4363023d2668e ("bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9b6160a191f8..1a9059e5b3b3 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -508,10 +508,8 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 	if (skb_linearize(skb))
 		return -EAGAIN;
 	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
-	if (unlikely(num_sge < 0)) {
-		kfree(msg);
+	if (unlikely(num_sge < 0))
 		return num_sge;
-	}
 
 	copied = skb->len;
 	msg->sg.start = 0;
@@ -530,6 +528,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 {
 	struct sock *sk = psock->sk;
 	struct sk_msg *msg;
+	int err;
 
 	/* If we are receiving on the same sock skb->sk is already assigned,
 	 * skip memory accounting and owner transition seeing it already set
@@ -548,7 +547,10 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	 * into user buffers.
 	 */
 	skb_set_owner_r(skb, sk);
-	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	err = sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	if (err < 0)
+		kfree(msg);
+	return err;
 }
 
 /* Puts an skb on the ingress queue of the socket already assigned to the
-- 
2.25.1

