Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7082420A8A3
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407716AbgFYXNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407700AbgFYXNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:13:13 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC678C08C5C1;
        Thu, 25 Jun 2020 16:13:12 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id z2so6953903ilq.0;
        Thu, 25 Jun 2020 16:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=UlKzt5nRZLioHdCv3xpUOKjebaw4JUUCMMsmEh0wQCk=;
        b=bqreES/ugvZwco+Gs2GPFWiqG7p+E4m79153g+MXI5LHoHXkHvgWqrxvvI7F/in11p
         qXCfuIDsH28sigiDn909/SZrllUJC6G82Zlf3pVMPK+ZUHaXewtEV6NwqOcyxES0pJhc
         MrgU5wZGG9bUDEfngS9Gb2NlvWZSMfs9/IR2olan11Bi8mnC/MaT08oGX3wDAsVM+jQA
         kv858w+BcVrgj3mq7+HkeHAxv1JMJJsBFf8n4z70c45N3a07q6BjTmP3QdpK89AV+UhD
         BW2R8XynD0ldErBjPoQ2ltLiGPuqf86j1t15Pvw5Ps/EE+hm5pPrcVd51smS/L3hX41y
         Zzyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UlKzt5nRZLioHdCv3xpUOKjebaw4JUUCMMsmEh0wQCk=;
        b=ouN+u2afd4cs8mZJN398XcBfXdR/nXQIG7JCEt0pT38qMMNsErS+/V1PEQqNNDMXoA
         mL8Mr48m8QHD/fy9pXte5zR951Ayb+Awp8YduW5DUzAUIuEeph81yNSBa3yGAb8MqhEe
         5iSwapnjcKYjIa48eo9TVJ/vWzwXZBFCQHyKwzae8e2TogXMgD5ysfH8dz09uojRKcrz
         g+beCmhDk3ENkDARoDnjX3Ds1OeRTfZd742RSW/yRLTzRWQ/KIJHm7jChKmzxSiOl97U
         5tY8RArO+JgSMoclDc+X7xq9hcl+OBLWloGaMtBdiHxQf34iofxZl6O4YlB8KRUkIqGd
         JKoA==
X-Gm-Message-State: AOAM533XEft8FnK3pbEbZpgz9LjGRNACz1dcBqHV8JX5GkFfRc0+jWmt
        xHHA8mBHdG2qSQPutF+Ybms=
X-Google-Smtp-Source: ABdhPJzKjvYzwAMjNA+DWze8GEhPLX6UGfsD3gB/l9B0B8bRvMam2zzeL8AqiNlg5J6BGwE4JSKoHg==
X-Received: by 2002:a92:2a06:: with SMTP id r6mr304935ile.121.1593126792184;
        Thu, 25 Jun 2020 16:13:12 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b8sm14386638ior.35.2020.06.25.16.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 16:13:11 -0700 (PDT)
Subject: [bpf PATCH v2 1/3] bpf,
 sockmap: RCU splat with redirect and strparser error or TLS
From:   John Fastabend <john.fastabend@gmail.com>
To:     kafai@fb.com, jakub@cloudflare.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 25 Jun 2020 16:12:59 -0700
Message-ID: <159312677907.18340.11064813152758406626.stgit@john-XPS-13-9370>
In-Reply-To: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370>
References: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two paths to generate the below RCU splat the first and
most obvious is the result of the BPF verdict program issuing a
redirect on a TLS socket (This is the splat shown below). Unlike
the non-TLS case the caller of the *strp_read() hooks does not
wrap the call in a rcu_read_lock/unlock. Then if the BPF program
issues a redirect action we hit the RCU splat.

However, in the non-TLS socket case the splat appears to be
relatively rare, because the skmsg caller into the strp_data_ready()
is wrapped in a rcu_read_lock/unlock. Shown here,

 static void sk_psock_strp_data_ready(struct sock *sk)
 {
	struct sk_psock *psock;

	rcu_read_lock();
	psock = sk_psock(sk);
	if (likely(psock)) {
		if (tls_sw_has_ctx_rx(sk)) {
			psock->parser.saved_data_ready(sk);
		} else {
			write_lock_bh(&sk->sk_callback_lock);
			strp_data_ready(&psock->parser.strp);
			write_unlock_bh(&sk->sk_callback_lock);
		}
	}
	rcu_read_unlock();
 }

If the above was the only way to run the verdict program we
would be safe. But, there is a case where the strparser may throw an
ENOMEM error while parsing the skb. This is a result of a failed
skb_clone, or alloc_skb_for_msg while building a new merged skb when
the msg length needed spans multiple skbs. This will in turn put the
skb on the strp_wrk workqueue in the strparser code. The skb will
later be dequeued and verdict programs run, but now from a
different context without the rcu_read_lock()/unlock() critical
section in sk_psock_strp_data_ready() shown above. In practice
I have not seen this yet, because as far as I know most users of the
verdict programs are also only working on single skbs. In this case no
merge happens which could trigger the above ENOMEM errors. In addition
the system would need to be under memory pressure. For example, we
can't hit the above case in selftests because we missed having tests
to merge skbs. (Added in later patch)

To fix the below splat extend the rcu_read_lock/unnlock block to
include the call to sk_psock_tls_verdict_apply(). This will fix both
TLS redirect case and non-TLS redirect+error case. Also remove
psock from the sk_psock_tls_verdict_apply() function signature its
not used there.

[ 1095.937597] WARNING: suspicious RCU usage
[ 1095.940964] 5.7.0-rc7-02911-g463bac5f1ca79 #1 Tainted: G        W
[ 1095.944363] -----------------------------
[ 1095.947384] include/linux/skmsg.h:284 suspicious rcu_dereference_check() usage!
[ 1095.950866]
[ 1095.950866] other info that might help us debug this:
[ 1095.950866]
[ 1095.957146]
[ 1095.957146] rcu_scheduler_active = 2, debug_locks = 1
[ 1095.961482] 1 lock held by test_sockmap/15970:
[ 1095.964501]  #0: ffff9ea6b25de660 (sk_lock-AF_INET){+.+.}-{0:0}, at: tls_sw_recvmsg+0x13a/0x840 [tls]
[ 1095.968568]
[ 1095.968568] stack backtrace:
[ 1095.975001] CPU: 1 PID: 15970 Comm: test_sockmap Tainted: G        W         5.7.0-rc7-02911-g463bac5f1ca79 #1
[ 1095.977883] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[ 1095.980519] Call Trace:
[ 1095.982191]  dump_stack+0x8f/0xd0
[ 1095.984040]  sk_psock_skb_redirect+0xa6/0xf0
[ 1095.986073]  sk_psock_tls_strp_read+0x1d8/0x250
[ 1095.988095]  tls_sw_recvmsg+0x714/0x840 [tls]

v2: Improve commit message to identify non-TLS redirect plus error case
    condition as well as more common TLS case. In the process I decided
    doing the rcu_read_unlock followed by the lock/unlock inside branches
    was unnecessarily complex. We can just extend the current rcu block
    and get the same effeective without the shuffling and branching.
    Thanks Martin!

Fixes: e91de6afa81c1 ("bpf: Fix running sk_skb program types with ktls")
Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 351afbf6bfba..c41ab6906b21 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -683,7 +683,7 @@ static struct sk_psock *sk_psock_from_strp(struct strparser *strp)
 	return container_of(parser, struct sk_psock, parser);
 }
 
-static void sk_psock_skb_redirect(struct sk_psock *psock, struct sk_buff *skb)
+static void sk_psock_skb_redirect(struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
@@ -715,12 +715,11 @@ static void sk_psock_skb_redirect(struct sk_psock *psock, struct sk_buff *skb)
 	}
 }
 
-static void sk_psock_tls_verdict_apply(struct sk_psock *psock,
-				       struct sk_buff *skb, int verdict)
+static void sk_psock_tls_verdict_apply(struct sk_buff *skb, int verdict)
 {
 	switch (verdict) {
 	case __SK_REDIRECT:
-		sk_psock_skb_redirect(psock, skb);
+		sk_psock_skb_redirect(skb);
 		break;
 	case __SK_PASS:
 	case __SK_DROP:
@@ -741,8 +740,8 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
 	}
+	sk_psock_tls_verdict_apply(skb, ret);
 	rcu_read_unlock();
-	sk_psock_tls_verdict_apply(psock, skb, ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
@@ -770,7 +769,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 		}
 		goto out_free;
 	case __SK_REDIRECT:
-		sk_psock_skb_redirect(psock, skb);
+		sk_psock_skb_redirect(skb);
 		break;
 	case __SK_DROP:
 		/* fall-through */
@@ -794,8 +793,8 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
 	}
-	rcu_read_unlock();
 	sk_psock_verdict_apply(psock, skb, ret);
+	rcu_read_unlock();
 }
 
 static int sk_psock_strp_read_done(struct strparser *strp, int err)

