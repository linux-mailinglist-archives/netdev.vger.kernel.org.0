Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9DB3521F3
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 00:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbhDAWAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 18:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbhDAWAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 18:00:34 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D438C0613E6;
        Thu,  1 Apr 2021 15:00:34 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id z9so3315595ilb.4;
        Thu, 01 Apr 2021 15:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=gEN6WS0MVlUI3EFzvJqSIyxZRdWSPD1ycyVcmAgZq5g=;
        b=U3p7VneSWyIgTrEaBSXgJT2E2sDXQko1jtYLlLTy68baNI2UNG0hmKuJZEQ2sAbIKR
         x7hWHoPUf0EbLUB3MNGktDV8gBTG4UqviU4kNTiyMLJ7WvHlHX5BTWJ3rVpmlEHCd48j
         Bw0T6alSC5kiwidnncB29zx04f5ob0WZiruygQ16kVLTWH2CB3f5xdUEfsinX1QTS6ZO
         PAxwLj//0NVeXv9OzI1cnqZapvQDPRz0bMQmlHW6oKJtgppf8Fpmfx1gkXlpF0/q1WeF
         jbE54W/n8SnOsEFBRNV7kgoBzNnA/5ZNRwN3o/axVOhz4gEsHipErpi5a3NIdtrM+SqM
         RklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gEN6WS0MVlUI3EFzvJqSIyxZRdWSPD1ycyVcmAgZq5g=;
        b=fCY+hBmv6qgMuDH6r4iQkv58iXvfWNA1t8V5AERjJHvHTHU4WaHxhQ2kyRBc2nuKvj
         PNog6RgHj157Mz+rlUFqdClhPajBNLSgZ/VilDx/i/ZdSbWS+EEX2BzRASxCqgQPZYhN
         Cbf1hIdEJU+nN8XcRX+9wvxhb90WS8iaQZCjb/DgDmnK2CqvuoeGkigzYRUM8eG+Qr5Y
         Ss5spKVM9WnQxgTSE8YQx6gCTZDWo6hjnAcrhx+MasHUrLr76wlf0jCS08mZoYvhgAWY
         rV4wgtjaIi9d25e/cSZYL0S6J1wT+qODUXffxBwNgly3AJRfM0NZOgqMl6n7bhAhXxjU
         TDMQ==
X-Gm-Message-State: AOAM532atVDw7cElQlA8WCbVHJxr92scxvfG071YFgjLh7w0jxzKlnAd
        YyuH6hMhchT3dDVkzPYlWVpkHviWHAo=
X-Google-Smtp-Source: ABdhPJxavFh6mkdP0U/9ZlRlUDKe3NWMabSV7/qi2zRzeby/ftKNKpctMPATMurOSmN2R6wkpie+qA==
X-Received: by 2002:a92:b74e:: with SMTP id c14mr8687175ilm.275.1617314433694;
        Thu, 01 Apr 2021 15:00:33 -0700 (PDT)
Received: from [127.0.1.1] ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id i6sm3123100ilr.61.2021.04.01.15.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 15:00:33 -0700 (PDT)
Subject: [PATCH bpf v2 1/2] bpf, sockmap: fix sk->prot unhash op reset
From:   John Fastabend <john.fastabend@gmail.com>
To:     xiyou.wangcong@gmail.com, andrii.nakryiko@gmail.com,
        daniel@iogearbox.net, ast@fb.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lmb@cloudflare.com
Date:   Thu, 01 Apr 2021 15:00:19 -0700
Message-ID: <161731441904.68884.15593917809745631972.stgit@john-XPS-13-9370>
In-Reply-To: <161731427139.68884.1934993103507544474.stgit@john-XPS-13-9370>
References: <161731427139.68884.1934993103507544474.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-85-g6af9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In '4da6a196f93b1' we fixed a potential unhash loop caused when
a TLS socket in a sockmap was removed from the sockmap. This
happened because the unhash operation on the TLS ctx continued
to point at the sockmap implementation of unhash even though the
psock has already been removed. The sockmap unhash handler when a
psock is removed does the following,

 void sock_map_unhash(struct sock *sk)
 {
	void (*saved_unhash)(struct sock *sk);
	struct sk_psock *psock;

	rcu_read_lock();
	psock = sk_psock(sk);
	if (unlikely(!psock)) {
		rcu_read_unlock();
		if (sk->sk_prot->unhash)
			sk->sk_prot->unhash(sk);
		return;
	}
        [...]
 }

The unlikely() case is there to handle the case where psock is detached
but the proto ops have not been updated yet. But, in the above case
with TLS and removed psock we never fixed sk_prot->unhash() and unhash()
points back to sock_map_unhash resulting in a loop. To fix this we added
this bit of code,

 static inline void sk_psock_restore_proto(struct sock *sk,
                                          struct sk_psock *psock)
 {
       sk->sk_prot->unhash = psock->saved_unhash;

This will set the sk_prot->unhash back to its saved value. This is the
correct callback for a TLS socket that has been removed from the sock_map.
Unfortunately, this also overwrites the unhash pointer for all psocks.
We effectively break sockmap unhash handling for any future socks.
Omitting the unhash operation will leave stale entries in the map if
a socket transition through unhash, but does not do close() op.

To fix set unhash correctly before calling into tls_update. This way the
TLS enabled socket will point to the saved unhash() handler.

Fixes: 4da6a196f93b1 ("bpf: Sockmap/tls, during free we may call tcp_bpf_unhash() in loop")
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 8edbbf5f2f93..822c048934e3 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -349,8 +349,13 @@ static inline void sk_psock_update_proto(struct sock *sk,
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
-	sk->sk_prot->unhash = psock->saved_unhash;
 	if (inet_csk_has_ulp(sk)) {
+		/* TLS does not have an unhash proto in SW cases, but we need
+		 * to ensure we stop using the sock_map unhash routine because
+		 * the associated psock is being removed. So use the original
+		 * unhash handler.
+		 */
+		WRITE_ONCE(sk->sk_prot->unhash, psock->saved_unhash);
 		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
 	} else {
 		sk->sk_write_space = psock->saved_write_space;


