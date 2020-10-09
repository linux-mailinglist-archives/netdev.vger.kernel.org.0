Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E813289141
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbgJISiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728317AbgJISha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:37:30 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A1DC0613D2;
        Fri,  9 Oct 2020 11:37:30 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d20so11067093iop.10;
        Fri, 09 Oct 2020 11:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=oNzlQC5it3x5TSZGgWLYGOv3a8456QwfczoKer9B8Qc=;
        b=dgu/Llcnqs4JikzOcPC+3aoY51HDj6veFBsvDvC846VtxxdkStm+SHg1x+KtrLRVne
         IxPM3jkseNgow34zp3r5d0SosEUfk5AjsbiQHXFk6+Yt3bTA/5WRS5hAPXClFJhTf+1h
         bkCFNtSLdCMdlw647l7rdEfhDVBhpAVe1aHP853Lpya7qqU2yqGCz6hkq5GEt2VRAO05
         Tppqx+D7+dXScLlGZiVaMKX+/XQee6x+qn+bgEs5YXQAB2EI8L4vFZrhTLSzE5mg51Uy
         u8tTLflP8ZA/U7TBkxkVFMFBItmQMZsYFYj3D0JbS0f/JVHTbQ+pl5nyiBWDZHBmvPf9
         ZCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oNzlQC5it3x5TSZGgWLYGOv3a8456QwfczoKer9B8Qc=;
        b=eYlE0ovKpZhVVgWT+rAoCHfud2n9YqATV7MdKYnOlDCtrMpxTMIVLQoziPwrlDZzUk
         MihFUmtWiSSb54d6WOb24d2koQVfyqN0mmxscQ3JljE3smC8h79HmESDAgOSxRhr8eYx
         r88jFCKZnyRKPS36X9BC/SfQNXLyMf/SKlYbTjpFqpe/mnSJtzV25xzZWq6+plhxVpaF
         k6GSa1StpFZKcpV3jI70+BrD5wuabu/zZVCGl+rhwvbxYurxxJHoerwSUnE76rxIrL4l
         LAUNGjE1dDO8V26U4gRo7grcQZXi9slvyawQFOTBwxo62imNIg0fu4b7KYVR39ioA20G
         bxTQ==
X-Gm-Message-State: AOAM533jre3TUGMHP5wPOsUAVSZVNUCj04u7Gnm067nB6znCfOPwzDxe
        IUaMC9cegTGrCQQwb3GVceg=
X-Google-Smtp-Source: ABdhPJzdDNLuYVqiKCJGiWg5Pp9DfIywe8CaJbS1/+N4Cq4VjWHZW7OfmuaWjkFDy+EJuGZ9nAHvNQ==
X-Received: by 2002:a02:6045:: with SMTP id d5mr9767026jaf.144.1602268649537;
        Fri, 09 Oct 2020 11:37:29 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m2sm3875844ion.44.2020.10.09.11.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:37:28 -0700 (PDT)
Subject: [bpf-next PATCH v3 4/6] bpf,
 sockmap: remove dropped data on errors in redirect case
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 11:37:17 -0700
Message-ID: <160226863689.5692.13861422742592309285.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
References: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
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
 net/core/skmsg.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 7389d5d7e7f8..880b84baab5e 100644
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
@@ -709,30 +711,28 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
-	bool ingress;
 
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
 		return;
 	}
 
-	ingress = tcp_skb_bpf_ingress(skb);
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

