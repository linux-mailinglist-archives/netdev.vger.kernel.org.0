Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B0628817D
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 06:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbgJIEpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 00:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729225AbgJIEpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 00:45:36 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D19C0613D2;
        Thu,  8 Oct 2020 21:45:36 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id b2so8063037ilr.1;
        Thu, 08 Oct 2020 21:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=y0Gm00JncLWpHRIGNKTr/1wc9EHa/ABXzDq9+KJHsr8=;
        b=MdSrj+nB4XfFW+yhZ7RX1aJv991/4ayNzJ6G/5pVOrxUhY+zmdDV3g9T2+yA/v9ADq
         jNlzbl5dY7ocEVgTEzJq+cb+oj4vHH6Ollp0IXUbHlDI55B1R6iCFdrrsrCrOHEHWTPv
         E2rd1BvGugRszUQNPaX0N+zR/yrHmUT0g0x36OE+Mw6kGr12ITvg3sAK/mNNvLaJo75s
         xJ8xDpUK7zpO+0WyA+wyzkbTiCQyLOfUcazkHZmJYCucJHwl+eBed4wY/i2L48mo/stV
         aT+MAEI6X5QBOuGPE1GeLp/U3U3PDb9X8E03xuquREHmpn4fe/W7Sfv4DjNXPWrJtOop
         3j/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=y0Gm00JncLWpHRIGNKTr/1wc9EHa/ABXzDq9+KJHsr8=;
        b=qpG3Ih+nko8yvqjqFT5asAgfqA9uf8mTGrOi8/1gex9HXSb5zicj4mz66gomND8E/e
         gXG4lqHfE+hCNIsX4ZipIq8l+acGobRFkIfa0NKrz5BgfXRc81x66pWayk/1AkwgqMxE
         //DwdlPdoUJc373cPP2Alfo1qmyze9kXA4TQ+z6UTHWufRtbb5hfEyI3jQCeam+qO5iP
         2JRbTLxaugPzfbPU9QvDnwzmIX4Hng6czldT/Wu2zkuruOPIUgEQdGW4fqw4xoCjKazL
         oMTf6efMi9wrIe1CVJgeUojGsXBmqLgJSZeH1KwgQUzztBBPwq1v2o8/IoPlPeFNyQWx
         kMJA==
X-Gm-Message-State: AOAM5309ixs9eRl8WCgpyXxbaxTHbCSnSXFsQiNPbAb3FIG+TMEqWLqL
        p1OM0M3nt6ewQAL16YHRzVmM5QlekK10BA==
X-Google-Smtp-Source: ABdhPJxShpETNkieD2iC2XPRmah77Yl1wtiWqHnLQVFPAxmF84SOhawMU/kg6s+p7uQQ54VreL8Qew==
X-Received: by 2002:a92:608:: with SMTP id x8mr9711927ilg.79.1602218735728;
        Thu, 08 Oct 2020 21:45:35 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z20sm3072059ior.2.2020.10.08.21.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 21:45:35 -0700 (PDT)
Subject: [bpf-next PATCH 6/6] bpf,
 sockmap: Add memory accounting so skbs on ingress lists are visible
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Thu, 08 Oct 2020 21:45:22 -0700
Message-ID: <160221872234.12042.16278651489592613107.stgit@john-Precision-5820-Tower>
In-Reply-To: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
References: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move skb->sk assignment out of sk_psock_bpf_run() and into individual
callers. Then we can use proper skb_set_owner_r() call to assign a
sk to a skb. This improves things by also charging the truesize against
the sockets sk_rmem_alloc counter. With this done we get some accounting
in place to ensure the memory associated with skbs on the workqueue are
still being accounted for somewhere. Finally, by using skb_set_owner_r
the destructor is setup so we can just let the normal skb_kfree logic
recover the memory. Combined with previous patch dropping skb_orphan()
we now can recover from memory pressure and maintain accounting.

Note, we will charge the skbs against their originating socket even
if being redirected into another socket. Once the skb completes the
redirect op the kfree_skb will give the memory back. This is important
because if we charged the socket we are redirecting to (like it was
done before this series) the sock_writeable() test could fail because
of the skb trying to be sent is already charged against the socket.

Also TLS case is special. Here we wait until we have decided not to
simply PASS the packet up the stack. In the case where we PASS the
packet up the stack we already have an skb which is accounted for on
the TLS socket context.

For the parser case we continue to just set/clear skb->sk this is
because the skb being used here may be combined with other skbs or
turned into multiple skbs depending on the parser logic. For example
the parser could request a payload length greater than skb->len so
that the strparser needs to collect multiple skbs. At any rate
the final result will be handled in the strparser recv callback.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ef68749c9104..cc33ee74d0f6 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -684,20 +684,8 @@ EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
 static int sk_psock_bpf_run(struct sk_psock *psock, struct bpf_prog *prog,
 			    struct sk_buff *skb)
 {
-	int ret;
-
-	/* strparser clones the skb before handing it to a upper layer,
-	 * meaning we have the same data, but sk is NULL. We do want an
-	 * sk pointer though when we run the BPF program. So we set it
-	 * here and then NULL it to ensure we don't trigger a BUG_ON()
-	 * in skb/sk operations later if kfree_skb is called with a
-	 * valid skb->sk pointer and no destructor assigned.
-	 */
-	skb->sk = psock->sk;
 	bpf_compute_data_end_sk_skb(skb);
-	ret = bpf_prog_run_pin_on_cpu(prog, skb);
-	skb->sk = NULL;
-	return ret;
+	return bpf_prog_run_pin_on_cpu(prog, skb);
 }
 
 static struct sk_psock *sk_psock_from_strp(struct strparser *strp)
@@ -738,10 +726,11 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	schedule_work(&psock_other->work);
 }
 
-static void sk_psock_tls_verdict_apply(struct sk_buff *skb, int verdict)
+static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int verdict)
 {
 	switch (verdict) {
 	case __SK_REDIRECT:
+		skb_set_owner_r(skb, sk);
 		sk_psock_skb_redirect(skb);
 		break;
 	case __SK_PASS:
@@ -759,11 +748,17 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 	rcu_read_lock();
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
+		/* We skip full set_owner_r here because if we do a SK_PASS
+		 * or SK_DROP we can skip skb memory accounting and use the
+		 * TLS context.
+		 */
+		skb->sk = psock->sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		skb->sk = NULL;
 	}
-	sk_psock_tls_verdict_apply(skb, ret);
+	sk_psock_tls_verdict_apply(skb, psock->sk, ret);
 	rcu_read_unlock();
 	return ret;
 }
@@ -825,6 +820,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		kfree_skb(skb);
 		goto out;
 	}
+	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
 		tcp_skb_bpf_redirect_clear(skb);
@@ -849,8 +845,11 @@ static int sk_psock_strp_parse(struct strparser *strp, struct sk_buff *skb)
 
 	rcu_read_lock();
 	prog = READ_ONCE(psock->progs.skb_parser);
-	if (likely(prog))
+	if (likely(prog)) {
+		skb->sk = psock->sk;
 		ret = sk_psock_bpf_run(psock, prog, skb);
+		skb->sk = NULL;
+	}
 	rcu_read_unlock();
 	return ret;
 }

