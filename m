Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F397207E23
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389890AbgFXVJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388453AbgFXVJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 17:09:40 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B130FC061573;
        Wed, 24 Jun 2020 14:09:38 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t85so3429661ili.5;
        Wed, 24 Jun 2020 14:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=pqgylyU+VUPw1La4UxD0t1MKLnxjx0FLmPqNPx+sCDc=;
        b=Jl9+R/tUDqNgNGYYm2PnE0WpTIw0IK81XTDjqg/aLE9yedWA0bxZ9UMiQT7TiQrzZ/
         I0tJhwH3fkYw2OorB1MKXPo1i+/hgJxYv020+3NG0IGmYJNkw84sWakzME+gS3HcJ7vM
         yFVX0JXLv+L+aTfn+HVnE7y03EWWELi3qPHjmRrUPPKSI4jalegNQZCBIbd9YfeZLhGd
         t1LZBQ4HPHvGXQJDzdAwbIXfuNFLWgqUlqvR8GLX7gaq/Ypj76dFmyhy9tQvZoRlofI8
         T16GzTYzktl+TRCw9V4tfweB15UD/9VmOab0423env0dKcwPx3KLe0PeF+PHzK8r6gTf
         ULhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=pqgylyU+VUPw1La4UxD0t1MKLnxjx0FLmPqNPx+sCDc=;
        b=bOwy+jDzh3Nz3JA5f2bsa/kA8w3Ig/+iULOFevZ09jeNrq2dDUbtbNv2GF31hX7Lys
         IdBCAEkFYF6KSfOKkqNoaIjYW8uvXzM5jCETnuVLU6fM8bK9wiG//Blk7oPxIijQRbbU
         j67HUByp+K4oMyuSgA5fO11NNNMcr7JuENYf66ntBFur85kAaZrnWWKxh8eiE/K7Urfr
         8pjMr0e9/orsxdKWa+oVhP27r2BshsBi3ZYS64T0z0JOIZstmLtIhaUZhgcV4wgAz841
         LO0f7K5KlobyzZBoJjo9w3/xtaHJxKN9MCjaWNCC9URpF7CzvJw1sUu1vHW6WHVZqYNp
         KXEw==
X-Gm-Message-State: AOAM532w5xo8XXJxMvwb8OXfvXrnJDdDZJ3y25ZMaL/bLriiEk25m5rc
        KpBfle+aKyx9dLNI8HP10zScY7cGSa0=
X-Google-Smtp-Source: ABdhPJxBKnkl0vtCafZpke3FaogqZ84r6wW+zn19oveXEz1qp/u5xUGG2M70EO1JbXRyQXcycsv+Ww==
X-Received: by 2002:a05:6e02:10d4:: with SMTP id s20mr2502458ilj.203.1593032978042;
        Wed, 24 Jun 2020 14:09:38 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k1sm6305402ilr.35.2020.06.24.14.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 14:09:37 -0700 (PDT)
Subject: [bpf PATCH] bpf, sockmap: RCU splat with TLS redirect and strparser
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Wed, 24 Jun 2020 14:09:23 -0700
Message-ID: <159303296342.360.5487181450879978407.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Redirect on non-TLS sockmap side has RCU lock held from sockmap code
path but when called from TLS this is no longer true. The RCU section
is needed because we use rcu dereference to fetch the psock of the
socket we are redirecting to.

To fix the below splat wrap the redirect usage in rcu_read_lock,
rcu_read_unlock.

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

Fixes: e91de6afa81c1 ("bpf: Fix running sk_skb program types with ktls")
Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 351afbf6bfba..070553fa3900 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -694,9 +694,11 @@ static void sk_psock_skb_redirect(struct sk_psock *psock, struct sk_buff *skb)
 		kfree_skb(skb);
 		return;
 	}
+	rcu_read_lock();
 	psock_other = sk_psock(sk_other);
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
 	    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
+		rcu_read_unlock();
 		kfree_skb(skb);
 		return;
 	}
@@ -713,6 +715,7 @@ static void sk_psock_skb_redirect(struct sk_psock *psock, struct sk_buff *skb)
 	} else {
 		kfree_skb(skb);
 	}
+	rcu_read_unlock();
 }
 
 static void sk_psock_tls_verdict_apply(struct sk_psock *psock,

