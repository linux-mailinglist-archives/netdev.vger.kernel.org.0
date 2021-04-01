Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1259F3521F5
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 00:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhDAWA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 18:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbhDAWAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 18:00:55 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70063C0613E6;
        Thu,  1 Apr 2021 15:00:55 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id f19so3673205ion.3;
        Thu, 01 Apr 2021 15:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/Y/2bXS+x40LAJhUqAWVL3NSg8OiZMwGupWZBWnd+7I=;
        b=GpleghdkTh4XLq+t3y0to8GLnIEIpRu43mJRtHF3aZlmc9Fsmu3Akx8T2+1KuT1aJd
         zHGbLYqSusLyjPW7PZQP1cjyxWPNWOJMVjZvRl+R8hz0jANU9Vpxmn73DXOWW1ghbQ9k
         ZrmUPvF2UMGMaxcTnl8pECkkD7Y9tLH1tRH+yUaeex+YnZAQ5kGQJBh6TSwC+2NaAPwU
         3TbsxdmYtt0XNso4G+8Rtc7hi3hhaEqISpm3iicQFU8gRECmlDEeoRky2GyWHkjtg515
         2MROs3S1iq5FMpiVP8LbDavEmKfbwFFAQkBcxripIlJLAgkvwK2DWXCK9AE8qIOtDirk
         7n6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/Y/2bXS+x40LAJhUqAWVL3NSg8OiZMwGupWZBWnd+7I=;
        b=Y+NtlNq+DXurR3FlqCXoyb1vDNiAVZlonO3uaGsgtWFDtZSytHr+bEVWppEVi1eYgn
         9NU9Qx/Cr5CxC75sAl/yGhXEwAaIHUdtZJAgaY9KRZPPag2vwH5TgkhXnKsmfc8EoFr8
         4lQhO9rqiwoT7BBcfem/IOdiFluDnVclLGZaLwOTzxvljWLuKkGH5bSsw9xfYUtyC5cO
         Eb6NYsKRSFB5PkWm9YkL1kV02RoX9K6WKxTo7B80M3BmfFOrzRtWtdtnCI1wP/npbWyG
         V9UH19Qdmga31dNY4bUw5nDDkkQrT1vzcZqR1uuJlwEvUZWHpLALpnhQt2KMfYjUia7H
         0P3w==
X-Gm-Message-State: AOAM531hLAKYf3BaXj7+yiPw+SuPH/8R740xgt80uAV733B4iV3wUnhK
        eDnuwEHAHwHpdhfW+bIXuF0=
X-Google-Smtp-Source: ABdhPJzpkdM7I4dBfiaSeNQnnZj+zjtjzQXobO2w+vNethUwToag5imhLOvPR4eXSFFbWExa+bePyA==
X-Received: by 2002:a5d:960d:: with SMTP id w13mr8108720iol.126.1617314454840;
        Thu, 01 Apr 2021 15:00:54 -0700 (PDT)
Received: from [127.0.1.1] ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id q207sm3420052iod.6.2021.04.01.15.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 15:00:54 -0700 (PDT)
Subject: [PATCH bpf v2 2/2] bpf, sockmap: fix incorrect fwd_alloc accounting
From:   John Fastabend <john.fastabend@gmail.com>
To:     xiyou.wangcong@gmail.com, andrii.nakryiko@gmail.com,
        daniel@iogearbox.net, ast@fb.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lmb@cloudflare.com
Date:   Thu, 01 Apr 2021 15:00:40 -0700
Message-ID: <161731444013.68884.4021114312848535993.stgit@john-XPS-13-9370>
In-Reply-To: <161731427139.68884.1934993103507544474.stgit@john-XPS-13-9370>
References: <161731427139.68884.1934993103507544474.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-85-g6af9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Incorrect accounting fwd_alloc can result in a warning when the socket
is torn down,

 [18455.319240] WARNING: CPU: 0 PID: 24075 at net/core/stream.c:208 sk_stream_kill_queues+0x21f/0x230
 [...]
 [18455.319543] Call Trace:
 [18455.319556]  inet_csk_destroy_sock+0xba/0x1f0
 [18455.319577]  tcp_rcv_state_process+0x1b4e/0x2380
 [18455.319593]  ? lock_downgrade+0x3a0/0x3a0
 [18455.319617]  ? tcp_finish_connect+0x1e0/0x1e0
 [18455.319631]  ? sk_reset_timer+0x15/0x70
 [18455.319646]  ? tcp_schedule_loss_probe+0x1b2/0x240
 [18455.319663]  ? lock_release+0xb2/0x3f0
 [18455.319676]  ? __release_sock+0x8a/0x1b0
 [18455.319690]  ? lock_downgrade+0x3a0/0x3a0
 [18455.319704]  ? lock_release+0x3f0/0x3f0
 [18455.319717]  ? __tcp_close+0x2c6/0x790
 [18455.319736]  ? tcp_v4_do_rcv+0x168/0x370
 [18455.319750]  tcp_v4_do_rcv+0x168/0x370
 [18455.319767]  __release_sock+0xbc/0x1b0
 [18455.319785]  __tcp_close+0x2ee/0x790
 [18455.319805]  tcp_close+0x20/0x80

This currently happens because on redirect case we do skb_set_owner_r()
with the original sock. This increments the fwd_alloc memory accounting
on the original sock. Then on redirect we may push this into the queue
of the psock we are redirecting to. When the skb is flushed from the
queue we give the memory back to the original sock. The problem is if
the original sock is destroyed/closed with skbs on another psocks queue
then the original sock will not have a way to reclaim the memory before
being destroyed. Then above warning will be thrown

  sockA                          sockB

  sk_psock_strp_read()
   sk_psock_verdict_apply()
     -- SK_REDIRECT --
     sk_psock_skb_redirect()
                                skb_queue_tail(psock_other->ingress_skb..)

  sk_close()
   sock_map_unref()
     sk_psock_put()
       sk_psock_drop()
         sk_psock_zap_ingress()

At this point we have torn down our own psock, but have the outstanding
skb in psock_other. Note that SK_PASS doesn't have this problem because
the sk_psock_drop() logic releases the skb, its still associated with
our psock.

To resolve lets only account for sockets on the ingress queue that are
still associated with the current socket. On the redirect case we will
check memory limits per 6fa9201a89898, but will omit fwd_alloc accounting
until skb is actually enqueued. When the skb is sent via skb_send_sock_locked
or received with sk_psock_skb_ingress memory will be claimed on psock_other.

Reported-by: Andrii Nakryiko <andrii@kernel.org>
Fixes: 6fa9201a89898 ("bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 1261512d6807..5def3a2e85be 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -488,6 +488,7 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
 	if (unlikely(!msg))
 		return -EAGAIN;
 	sk_msg_init(msg);
+	skb_set_owner_r(skb, sk);
 	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
 }
 
@@ -790,7 +791,6 @@ static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int
 {
 	switch (verdict) {
 	case __SK_REDIRECT:
-		skb_set_owner_r(skb, sk);
 		sk_psock_skb_redirect(skb);
 		break;
 	case __SK_PASS:
@@ -808,10 +808,6 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 	rcu_read_lock();
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		/* We skip full set_owner_r here because if we do a SK_PASS
-		 * or SK_DROP we can skip skb memory accounting and use the
-		 * TLS context.
-		 */
 		skb->sk = psock->sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
@@ -880,12 +876,13 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		kfree_skb(skb);
 		goto out;
 	}
-	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
+		skb->sk = sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		skb->sk = NULL;
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:
@@ -956,12 +953,13 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 		kfree_skb(skb);
 		goto out;
 	}
-	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
+		skb->sk = sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		skb->sk = NULL;
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
 out:


