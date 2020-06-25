Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB3520A8A9
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407733AbgFYXNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407728AbgFYXNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:13:33 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7733FC08C5C1;
        Thu, 25 Jun 2020 16:13:33 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id z2so6954520ilq.0;
        Thu, 25 Jun 2020 16:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=UV6Xho6hdH+B9DsLIh3uK5fB2updmvEdVyqUrHCfo9Q=;
        b=aES8Zo+aiBUNbbE9oTVGkjEKaNaSHxTNp1xl+sYD/Drcgg+maPKs6U6pDq9tXPxZHv
         Vn3XW22AxULjqpifkA4uKvM9Kz4lxkcEhBP0ut35INldOlmCSlGFEUT8IsLRUO8tB2dq
         WleY7W9WtzMgnUA0gZ8B10ZCNPeD/kISRvuNoxecfj1BZGgO8bMkGncG5KeJKoteCQ9v
         Dgkgd7Ax69SCAfD1IfJdBAb6VAy1wFHYnIUN0UW7ZK3lqngqUtos/43s3j6diOsNfS/p
         jbbpV9fxYJqU/KluuxOPj8ok9yN0eUiOTcG/lQ2Uv9Yc6RGBcA8EP3Zcxkk06FKoD/QL
         qg2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UV6Xho6hdH+B9DsLIh3uK5fB2updmvEdVyqUrHCfo9Q=;
        b=NhNQYqr4RUgYENXqudT5mHHVlIVMUT9LnmKG9B/Cg5lOArtYGLUJk5/nHO/Ajxoa5F
         n0TnR+VTwmBX3C8fbLB8hrhkalNtozAC5LNrUHmHDLB31YuCwd95NRBk2fEX+H1GfWDH
         sQVuBt7sZMDjkDN48Dyq31oU9aLkhyLUt0xoXq+I/Bc2lkhEjyzl+ooUMJ+km/fb6oPP
         KPjXTEoabwvQkqcGp4y5+vTtWfaeBmX4dYtA1ywzJVa2fOyswNfC+q9iR7rEq4g0Y5I3
         y0iXCSDDGHEP5jTcXL/eQBSQ4wsDVvwh9X/xpRFbJ+lpI00CJUIdgWviVLBgREa4UQRi
         kR3g==
X-Gm-Message-State: AOAM531RF1sT+mqOQ25U40fPkOS0TOLuSebmNoxeAWFdABJZXjSFn0b6
        +pH+JVwxAPbIOIxCFTQIS8A=
X-Google-Smtp-Source: ABdhPJy0VSd00WyY3jQ2MRNvi0OMbwFZMHLqscmP5pNpwmoWmSpLB9Z4uBc4a+Sp9BVSedsfjrauUg==
X-Received: by 2002:a92:bb84:: with SMTP id x4mr317514ilk.177.1593126812831;
        Thu, 25 Jun 2020 16:13:32 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y23sm14251528ior.38.2020.06.25.16.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 16:13:32 -0700 (PDT)
Subject: [bpf PATCH v2 2/3] bpf,
 sockmap: RCU dereferenced psock may be used outside RCU block
From:   John Fastabend <john.fastabend@gmail.com>
To:     kafai@fb.com, jakub@cloudflare.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 25 Jun 2020 16:13:18 -0700
Message-ID: <159312679888.18340.15248924071966273998.stgit@john-XPS-13-9370>
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

If an ingress verdict program specifies message sizes greater than
skb->len and there is an ENOMEM error due to memory pressure we
may call the rcv_msg handler outside the strp_data_ready() caller
context. This is because on an ENOMEM error the strparser will
retry from a workqueue. The caller currently protects the use of
psock by calling the strp_data_ready() inside a rcu_read_lock/unlock
block.

But, in above workqueue error case the psock is accessed outside
the read_lock/unlock block of the caller. So instead of using
psock directly we must do a look up against the sk again to
ensure the psock is available.

There is an an ugly piece here where we must handle
the case where we paused the strp and removed the psock. On
psock removal we first pause the strparser and then remove
the psock. If the strparser is paused while an skb is
scheduled on the workqueue the skb will be dropped on the
flow and kfree_skb() is called. If the workqueue manages
to get called before we pause the strparser but runs the rcvmsg
callback after the psock is removed we will hit the unlikely
case where we run the sockmap rcvmsg handler but do not have
a psock. For now we will follow strparser logic and drop the
skb on the floor with skb_kfree(). This is ugly because the
data is dropped. To date this has not caused problems in practice
because either the application controlling the sockmap is
coordinating with the datapath so that skbs are "flushed"
before removal or we simply wait for the sock to be closed before
removing it.

This patch fixes the describe RCU bug and dropping the skb doesn't
make things worse. Future patches will improve this by allowing
the normal case where skbs are not merged to skip the strparser
altogether. In practice many (most?) use cases have no need to
merge skbs so its both a code complexity hit as seen above and
a performance issue. For example, in the Cilium case we always
set the strparser up to return sbks 1:1 without any merging and
have avoided above issues.

Fixes: e91de6afa81c1 ("bpf: Fix running sk_skb program types with ktls")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index c41ab6906b21..6a32a1fd34f8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -781,11 +781,18 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 
 static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 {
-	struct sk_psock *psock = sk_psock_from_strp(strp);
+	struct sk_psock *psock;
 	struct bpf_prog *prog;
 	int ret = __SK_DROP;
+	struct sock *sk;
 
 	rcu_read_lock();
+	sk = strp->sk;
+	psock = sk_psock(sk);
+	if (unlikely(!psock)) {
+		kfree_skb(skb);
+		goto out;
+	}
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
 		skb_orphan(skb);
@@ -794,6 +801,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
+out:
 	rcu_read_unlock();
 }
 

