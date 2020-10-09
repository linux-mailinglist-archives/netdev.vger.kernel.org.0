Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A3E288171
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 06:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgJIEo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 00:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJIEo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 00:44:59 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C74C0613D2;
        Thu,  8 Oct 2020 21:44:59 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id o18so8063933ill.2;
        Thu, 08 Oct 2020 21:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=QPiMN4Qec74wfDW6vodMRH/5EyDyOHe+QRu0XZ+jXD4=;
        b=slmms/52+r/mRLHlyLeV/N2DoLC/6H7EES0GahtqrTzgx7oWIZEHUEgVMye8eMINHN
         sQ/6F3FCtOn0g1STloUfs/Av6XOvqEjhPvTojYitUk25/rpKSwAZIgYLpsScHeIqR+OA
         sjQmx5NjtXKSSsTxsJHr0rpWRxedG4iH9HrRlnboROEtWxv3kEf3TfHxNVIFA8cIr0En
         2rfbT4tA6LMHFdG18gq4pV5TD+FEyOP7lHckaT4YffDiLVPEBifPDxW/QPLVeHIId+JZ
         +ubw843Ln7hOUyW1W0cjmMEAf26BldHP0uK8hgNGvGd/k7PDhc34Qg3s9wMrvaGAf8f+
         Vr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QPiMN4Qec74wfDW6vodMRH/5EyDyOHe+QRu0XZ+jXD4=;
        b=AI4X8zLGee8axtfx9t/jLDfm3UohRZRAeaThbFKHRr9ODTg9K7aGpZG8V+U5JrQuOJ
         vG7xrk819h/PqOPFY3aYyVOp/mdOrB92AV1UsdaSvDkqtwGzqewNhJHCTBxRBD46MS8D
         kOj7W7447c3rF7vngvE5T9/L5EXIPTa27m9z02u7cNw/1cyZkoUOK9cQ8Hmwkxj6hgJf
         woJHdVzzAN70OYX7wfL4XFdCKU1aSl/MMrvIPTjmIej0Zu941phS6Uc9QRFtyQBkvQKz
         ZIiAU9Vlu6DhC6T9Tpo4jX5mPAGvqCGZ5kA9EqTcKgkFPrf8BgGQNfsvg84KJEp6Ojsz
         7/zw==
X-Gm-Message-State: AOAM530rqdsXlYB+k94DXqoLLzOJCIEki0JI1c0JFUePvLMOM7FJ1km6
        1R+m/Sch2RVdBmZ/iFdASeoKwWdVKAVLPg==
X-Google-Smtp-Source: ABdhPJwQE5BjrzF34YMbTYF5568FcjkEfFSMBaBbQZ6HQ8zwRsfKPBMZlrp7RhKp9ARfnJ1gGXlsbQ==
X-Received: by 2002:a92:91d2:: with SMTP id e79mr8891124ill.17.1602218698517;
        Thu, 08 Oct 2020 21:44:58 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v18sm3679066ilj.12.2020.10.08.21.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 21:44:57 -0700 (PDT)
Subject: [bpf-next PATCH 4/6] bpf,
 sockmap: remove dropped data on errors in redirect case
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Thu, 08 Oct 2020 21:44:45 -0700
Message-ID: <160221868511.12042.12285689875540180401.stgit@john-Precision-5820-Tower>
In-Reply-To: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
References: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the sk_skb redirect case we didn't handle the case where we overrun
the sk_rmem_alloc entry on ingress redirect or sk_wmem_alloc on egress.
Because we didn't have anything implemented we simply dropped the skb.
This meant data could be dropped if socket memory accounting was in
place.

This fixes the above dropped data case by moving the memory checks
later in the code where we actually do the send or recv. This pushes
those checks into the workqueue and allows us to return an EAGAIN error
which in turn allows us to try again later from the workqueue.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index b60768951de2..0bc8679e8033 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -433,10 +433,12 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 			       u32 off, u32 len, bool ingress)
 {
-	if (ingress)
-		return sk_psock_skb_ingress(psock, skb);
-	else
+	if (!ingress) {
+		if (!sock_writeable(psock->sk))
+			return -EAGAIN;
 		return skb_send_sock_locked(psock->sk, skb, off, len);
+	}
+	return sk_psock_skb_ingress(psock, skb);
 }
 
 static void sk_psock_backlog(struct work_struct *work)
@@ -712,11 +714,18 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	bool ingress;
 
 	sk_other = tcp_skb_bpf_redirect_fetch(skb);
+	/* This error is a buggy BPF program, it returned a redirect
+	 * return code, but then didn't set a redirect interface.
+	 */
 	if (unlikely(!sk_other)) {
 		kfree_skb(skb);
 		return;
 	}
 	psock_other = sk_psock(sk_other);
+	/* This error indicates the socket is being torn down or had another
+	 * error that caused the pipe to break. We can't send a packet on
+	 * a socket that is in this state so we drop the skb.
+	 */
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
 	    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
 		kfree_skb(skb);
@@ -724,15 +733,8 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	}
 
 	ingress = tcp_skb_bpf_ingress(skb);
-	if ((!ingress && sock_writeable(sk_other)) ||
-	    (ingress &&
-	     atomic_read(&sk_other->sk_rmem_alloc) <=
-	     sk_other->sk_rcvbuf)) {
-		skb_queue_tail(&psock_other->ingress_skb, skb);
-		schedule_work(&psock_other->work);
-	} else {
-		kfree_skb(skb);
-	}
+	skb_queue_tail(&psock_other->ingress_skb, skb);
+	schedule_work(&psock_other->work);
 }
 
 static void sk_psock_tls_verdict_apply(struct sk_buff *skb, int verdict)

