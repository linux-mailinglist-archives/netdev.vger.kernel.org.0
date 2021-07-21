Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905343D0D90
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239858AbhGUKpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238727AbhGUJea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 05:34:30 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010C2C0613DE
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 03:13:30 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id u8-20020a7bcb080000b02901e44e9caa2aso658538wmj.4
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 03:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=UXF+EfXU6wa5qR+0ALWX60hOpfEu/bQ6AbqNAj9mAaM=;
        b=If4lpaTaX5ZnbTxqWFKiRfdv448LvTnNTcxmQzd1AXekaqSyU2xlu0izJe0k+g+ZSb
         1c9SXI0jbdBmVpVWLq96e8mQ0LGFRRFjBBAnu+D65DN3zLmpKhWMPA05TyYY3fdQwMEQ
         Q4SC8BVp1ghMSLWvMrCmBujIL9Kh/r1DHp14Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=UXF+EfXU6wa5qR+0ALWX60hOpfEu/bQ6AbqNAj9mAaM=;
        b=HCAMKi3udkNugx7Yejc0Hnok01lEma0utI2fBuabhIobXywlLzcxyLvWBn85XhxAtK
         iMEUCpqAI+uZEkyB844LVxufjNfL4ginvvwHFOP9BdJr90HL13KTt+Xoa49htEvGmpMC
         HX9kHGmBpuYDayMuciEI5mI/CT3CtWoQVPVQGTWLkONs4ZpaH/q8ovCt+axyUiRhw7nw
         GbDwC4hRAtRPe/ZQrij3XTyxJntq7KM10Mi+scFy5wLA4KgxXZcDi4bWlzmYK9Pwub9o
         OyA8jVIbz5h2FDC9faqoC8rzu5DkVs++fUeaL9h7DqvozFWyLTwaP8Bal9Ue/g9uo13C
         QSig==
X-Gm-Message-State: AOAM531D8l6I7nMW14r2CUu/MQ2RQetYSCggKJhqXLO4VyBdMcxeGJpv
        mjEYdEgeA2reL0vjLPZ3H1BA6A==
X-Google-Smtp-Source: ABdhPJwdZGw8iLQs8GwoP4xYIObZoS2R8J1VK8LT6XNX/Rts5SiADaSp0vU8tYOWY+bGxs/9beATFg==
X-Received: by 2002:a1c:63d6:: with SMTP id x205mr37587151wmb.42.1626862408413;
        Wed, 21 Jul 2021 03:13:28 -0700 (PDT)
Received: from cloudflare.com (79.191.183.149.ipv4.supernova.orange.pl. [79.191.183.149])
        by smtp.gmail.com with ESMTPSA id a8sm26530054wrt.61.2021.07.21.03.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 03:13:27 -0700 (PDT)
References: <20210719214834.125484-1-john.fastabend@gmail.com>
 <20210719214834.125484-3-john.fastabend@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, xiyou.wangcong@gmail.com,
        alexei.starovoitov@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf 2/3] bpf, sockmap: on cleanup we additionally need
 to remove cached skb
In-reply-to: <20210719214834.125484-3-john.fastabend@gmail.com>
Date:   Wed, 21 Jul 2021 12:13:26 +0200
Message-ID: <87tukoq8jd.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 11:48 PM CEST, John Fastabend wrote:
> Its possible if a socket is closed and the receive thread is under memory
> pressure it may have cached a skb. We need to ensure these skbs are
> free'd along with the normal ingress_skb queue.
>
> Before 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()") tear
> down and backlog processing both had sock_lock for the common case of
> socket close or unhash. So it was not possible to have both running in
> parrallel so all we would need is the kfree in those kernels.
>
> But, latest kernels include the commit 799aa7f98d5e and this requires a
> bit more work. Without the ingress_lock guarding reading/writing the
> state->skb case its possible the tear down could run before the state
> update causing it to leak memory or worse when the backlog reads the state
> it could potentially run interleaved with the tear down and we might end up
> free'ing the state->skb from tear down side but already have the reference
> from backlog side. To resolve such races we wrap accesses in ingress_lock
> on both sides serializing tear down and backlog case. In both cases this
> only happens after an EAGAIN error case so having an extra lock in place
> is likely fine. The normal path will skip the locks.
>
> Note, we check state->skb before grabbing lock. This works because
> we can only enqueue with the mutex we hold already. Avoiding a race
> on adding state->skb after the check. And if tear down path is running
> that is also fine if the tear down path then removes state->skb we
> will simply set skb=NULL and the subsequent goto is skipped. This
> slight complication avoids locking in normal case.
>
> With this fix we no longer see this warning splat from tcp side on
> socket close when we hit the above case with redirect to ingress self.
>
> [224913.935822] WARNING: CPU: 3 PID: 32100 at net/core/stream.c:208 sk_stream_kill_queues+0x212/0x220
> [224913.935841] Modules linked in: fuse overlay bpf_preload x86_pkg_temp_thermal intel_uncore wmi_bmof squashfs sch_fq_codel efivarfs ip_tables x_tables uas xhci_pci ixgbe mdio xfrm_algo xhci_hcd wmi
> [224913.935897] CPU: 3 PID: 32100 Comm: fgs-bench Tainted: G          I       5.14.0-rc1alu+ #181
> [224913.935908] Hardware name: Dell Inc. Precision 5820 Tower/002KVM, BIOS 1.9.2 01/24/2019
> [224913.935914] RIP: 0010:sk_stream_kill_queues+0x212/0x220
> [224913.935923] Code: 8b 83 20 02 00 00 85 c0 75 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 89 df e8 2b 11 fe ff eb c3 0f 0b e9 7c ff ff ff 0f 0b eb ce <0f> 0b 5b 5d 41 5c 41 5d 41 5e 41 5f c3 90 0f 1f 44 00 00 41 57 41
> [224913.935932] RSP: 0018:ffff88816271fd38 EFLAGS: 00010206
> [224913.935941] RAX: 0000000000000ae8 RBX: ffff88815acd5240 RCX: dffffc0000000000
> [224913.935948] RDX: 0000000000000003 RSI: 0000000000000ae8 RDI: ffff88815acd5460
> [224913.935954] RBP: ffff88815acd5460 R08: ffffffff955c0ae8 R09: fffffbfff2e6f543
> [224913.935961] R10: ffffffff9737aa17 R11: fffffbfff2e6f542 R12: ffff88815acd5390
> [224913.935967] R13: ffff88815acd5480 R14: ffffffff98d0c080 R15: ffffffff96267500
> [224913.935974] FS:  00007f86e6bd1700(0000) GS:ffff888451cc0000(0000) knlGS:0000000000000000
> [224913.935981] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [224913.935988] CR2: 000000c0008eb000 CR3: 00000001020e0005 CR4: 00000000003706e0
> [224913.935994] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [224913.936000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [224913.936007] Call Trace:
> [224913.936016]  inet_csk_destroy_sock+0xba/0x1f0
> [224913.936033]  __tcp_close+0x620/0x790
> [224913.936047]  tcp_close+0x20/0x80
> [224913.936056]  inet_release+0x8f/0xf0
> [224913.936070]  __sock_release+0x72/0x120
> [224913.936083]  sock_close+0x14/0x20
>
> Reported-by: Jussi Maki <joamaki@gmail.com>
> Fixes: a136678c0bdbb ("bpf: sk_msg, zap ingress queue on psock down")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

This looks fine to me.

I've played around with the idea of wrapping read & write access to
psock->work_state in helpers with set/steal semantics. Building on an
example from net/core/fib_rules.c where nla_get_kuid_range() returns a
(u32, u32) pair. But I'm not sure if what I ended up with is actually
nicer. Leaving it for your consideration, if you want to use any of it.

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 96f319099744..ed067986a7b5 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -71,12 +71,16 @@ struct sk_psock_link {
 	void				*link_raw;
 };
 
-struct sk_psock_work_state {
-	struct sk_buff			*skb;
+struct sk_psock_skb_slice {
 	u32				len;
 	u32				off;
 };
 
+struct sk_psock_work_state {
+	struct sk_buff			*skb;
+	struct sk_psock_skb_slice	slice;
+};
+
 struct sk_psock {
 	struct sock			*sk;
 	struct sock			*sk_redir;
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 15d71288e741..da0542074c24 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -590,40 +590,82 @@ static void sock_drop(struct sock *sk, struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
+static void __sk_psock_skb_state_set(struct sk_psock *psock,
+				     struct sk_buff *skb,
+				     const struct sk_psock_skb_slice *slice)
+{
+	struct sk_psock_work_state *state = &psock->work_state;
+
+	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
+		state->skb = skb;
+		state->slice = *slice;
+	} else {
+		sock_drop(psock->sk, skb);
+	}
+}
+
+static void sk_psock_skb_state_set(struct sk_psock *psock,
+				   struct sk_buff *skb,
+				   const struct sk_psock_skb_slice *slice)
+{
+	spin_lock_bh(&psock->ingress_lock);
+	__sk_psock_skb_state_set(psock, skb, slice);
+	spin_unlock_bh(&psock->ingress_lock);
+}
+
+static struct sk_psock_skb_slice __sk_psock_skb_state_steal(struct sk_psock *psock,
+							    struct sk_buff **pskb)
+{
+	struct sk_psock_work_state *state = &psock->work_state;
+
+	*pskb = state->skb;
+	state->skb = NULL;
+
+	return state->slice;
+}
+
+static struct sk_psock_skb_slice sk_psock_skb_state_steal(struct sk_psock *psock,
+							  struct sk_buff **pskb)
+{
+	struct sk_psock_skb_slice ret;
+
+	spin_lock_bh(&psock->ingress_lock);
+	ret = __sk_psock_skb_state_steal(psock, pskb);
+	spin_unlock_bh(&psock->ingress_lock);
+
+	return ret;
+}
+
 static void sk_psock_backlog(struct work_struct *work)
 {
 	struct sk_psock *psock = container_of(work, struct sk_psock, work);
 	struct sk_psock_work_state *state = &psock->work_state;
-	struct sk_buff *skb;
+	struct sk_psock_skb_slice slice = {};
+	struct sk_buff *skb = NULL;
 	bool ingress;
-	u32 len, off;
 	int ret;
 
 	mutex_lock(&psock->work_mutex);
 	if (state->skb) {
-		skb = state->skb;
-		len = state->len;
-		off = state->off;
-		state->skb = NULL;
+		slice = sk_psock_skb_state_steal(psock, &skb);
 		goto start;
 	}
 
 	while ((skb = skb_dequeue(&psock->ingress_skb))) {
-		len = skb->len;
-		off = 0;
+		slice.len = skb->len;
+		slice.off = 0;
 start:
 		ingress = skb_bpf_ingress(skb);
 		skb_bpf_redirect_clear(skb);
 		do {
 			ret = -EIO;
 			if (!sock_flag(psock->sk, SOCK_DEAD))
-				ret = sk_psock_handle_skb(psock, skb, off,
-							  len, ingress);
+				ret = sk_psock_handle_skb(psock, skb, slice.off,
+							  slice.len, ingress);
 			if (ret <= 0) {
 				if (ret == -EAGAIN) {
-					state->skb = skb;
-					state->len = len;
-					state->off = off;
+					sk_psock_skb_state_set(psock, skb,
+							       &slice);
 					goto end;
 				}
 				/* Hard errors break pipe and stop xmit. */
@@ -632,9 +674,9 @@ static void sk_psock_backlog(struct work_struct *work)
 				sock_drop(psock->sk, skb);
 				goto end;
 			}
-			off += ret;
-			len -= ret;
-		} while (len);
+			slice.off += ret;
+			slice.len -= ret;
+		} while (slice.len);
 
 		if (!ingress)
 			kfree_skb(skb);
@@ -723,6 +765,12 @@ static void __sk_psock_zap_ingress(struct sk_psock *psock)
 		sock_drop(psock->sk, skb);
 	}
 	__sk_psock_purge_ingress_msg(psock);
+
+	/* We steal the skb here to ensure that calls to sk_psock_backlog
+	 * do not pick up the free'd skb.
+	 */
+	__sk_psock_skb_state_steal(psock, &skb);
+	kfree_skb(skb);
 }
 
 static void sk_psock_link_destroy(struct sk_psock *psock)
