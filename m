Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD9D1E8BBB
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgE2XGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgE2XGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:06:54 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3A2C03E969;
        Fri, 29 May 2020 16:06:54 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id h95so1178402pje.4;
        Fri, 29 May 2020 16:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=iQ1lRxlZ9KNjv16emKtDeGuGiS7CUMwKq9co9/Ovmo4=;
        b=pLiRAnFfkFbZ/shVTggEYyxAllMc/r5weRtLhD50sRufttvmO0nkt2nRqo8MpVSXIK
         0swZcecoMvkXAXdYAf8yCSxO9/IAn5PKTnPh5DCEjF8bKZbzJY8QEtI4xyboOOyO/3kX
         bSjzpDUvCQOqCARxPJ6BPQyoxS8AmU7Ef6P8uFEETMLD0cxFs6M93K9iRTLfVY7VrS8N
         9X9oSeJwnXPOja7/1V1Xs2DjndWB0B/rMRe/yjimiWQlDQAF7/neejXVLwE2AIRDxjFz
         B+5b7JfIQ21DSStKg7vtWGppeMMLlZYEQkxraEWpXLLuWIZ08yC7JnHAmwyL7kUGGVaH
         ajTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=iQ1lRxlZ9KNjv16emKtDeGuGiS7CUMwKq9co9/Ovmo4=;
        b=nWzpA9A5dY5aRFCWoOBoJsrhwQu936QEd5PrujqV3Hj3M//Nv8nEo0hkrLhvVvyDCp
         EtnfXrV1nf814uDRLBf7fmoCqmDjh6DubuthGErV1/AGjiZg+g1Km6cCoO78yINVozP0
         D8xASkvOFN7InZ+oy+o0EyhzofL5ee3SW9QE7jgqer0JG42PFnYYJa0g5GHszCpxc4jo
         dJM/ub3W8k2aCx0Y2qgdeYrCYdylD3xndzpNkizcQmI1JZ8P4k8IYAriqoKXAi1b4rkZ
         rtJExtuOwDDeM76PgyJDx2/gGGJj1BxvEMtrdPNW6vzk0dmRlc+HorVBEDTg33Ll5duy
         Pf5Q==
X-Gm-Message-State: AOAM531JEkoPTiS/J2mNxqERCyYackUXV/luiZm39aAVYgCEYxCl7/dS
        MryVaS8pIVjT223z2tt37sbYCu0rWHs=
X-Google-Smtp-Source: ABdhPJxjZZBAH5P2jNaw6nQwLSxNUxfUQHo5Lan85zQ2f0a50AWgK82WFfgu74UeW6f9wxpeGaNl1g==
X-Received: by 2002:a17:90b:3d4:: with SMTP id go20mr12620996pjb.208.1590793613318;
        Fri, 29 May 2020 16:06:53 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id gz19sm410829pjb.33.2020.05.29.16.06.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 May 2020 16:06:52 -0700 (PDT)
Subject: [bpf-next PATCH 1/3] bpf: refactor sockmap redirect code so its
 easy to reuse
From:   John Fastabend <john.fastabend@gmail.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Fri, 29 May 2020 16:06:41 -0700
Message-ID: <159079360110.5745.7024009076049029819.stgit@john-Precision-5820-Tower>
In-Reply-To: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
References: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will need this block of code called from tls context shortly
lets refactor the redirect logic so its easy to use. This also
cleans up the switch stmt so we have fewer fallthrough cases.

No logic changes are intended.

Fixes: d829e9c4112b5 ("tls: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   55 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index c479372..9d72f71 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -682,13 +682,43 @@ static struct sk_psock *sk_psock_from_strp(struct strparser *strp)
 	return container_of(parser, struct sk_psock, parser);
 }
 
-static void sk_psock_verdict_apply(struct sk_psock *psock,
-				   struct sk_buff *skb, int verdict)
+static void sk_psock_skb_redirect(struct sk_psock *psock, struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
 	bool ingress;
 
+	sk_other = tcp_skb_bpf_redirect_fetch(skb);
+	if (unlikely(!sk_other)) {
+		kfree_skb(skb);
+		return;
+	}
+	psock_other = sk_psock(sk_other);
+	if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
+	    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
+		kfree_skb(skb);
+		return;
+	}
+
+	ingress = tcp_skb_bpf_ingress(skb);
+	if ((!ingress && sock_writeable(sk_other)) ||
+	    (ingress &&
+	     atomic_read(&sk_other->sk_rmem_alloc) <=
+	     sk_other->sk_rcvbuf)) {
+		if (!ingress)
+			skb_set_owner_w(skb, sk_other);
+		skb_queue_tail(&psock_other->ingress_skb, skb);
+		schedule_work(&psock_other->work);
+	} else {
+		kfree_skb(skb);
+	}
+}
+
+static void sk_psock_verdict_apply(struct sk_psock *psock,
+				   struct sk_buff *skb, int verdict)
+{
+	struct sock *sk_other;
+
 	switch (verdict) {
 	case __SK_PASS:
 		sk_other = psock->sk;
@@ -707,25 +737,8 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 		}
 		goto out_free;
 	case __SK_REDIRECT:
-		sk_other = tcp_skb_bpf_redirect_fetch(skb);
-		if (unlikely(!sk_other))
-			goto out_free;
-		psock_other = sk_psock(sk_other);
-		if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
-		    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED))
-			goto out_free;
-		ingress = tcp_skb_bpf_ingress(skb);
-		if ((!ingress && sock_writeable(sk_other)) ||
-		    (ingress &&
-		     atomic_read(&sk_other->sk_rmem_alloc) <=
-		     sk_other->sk_rcvbuf)) {
-			if (!ingress)
-				skb_set_owner_w(skb, sk_other);
-			skb_queue_tail(&psock_other->ingress_skb, skb);
-			schedule_work(&psock_other->work);
-			break;
-		}
-		/* fall-through */
+		sk_psock_skb_redirect(psock, skb);
+		break;
 	case __SK_DROP:
 		/* fall-through */
 	default:

