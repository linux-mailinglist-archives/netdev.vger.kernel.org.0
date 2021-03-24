Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C533F348351
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbhCXU74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbhCXU7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:59:44 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4863C06174A;
        Wed, 24 Mar 2021 13:59:43 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id t6so252771ilp.11;
        Wed, 24 Mar 2021 13:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=wOysoelzRnYOrkG2Z14SpjF49EYeBD1nfmQf5XQ3/pk=;
        b=D38CFzdvkf2jD2Wj8p9HCX8TUbjmJsfpzJav58tCzaw+0whYqenB608OP4gJmVUHIk
         86Repd58CqRSIpPohD4XGB0sUPL6pRf6t3VKa1F59vfJMcqLs8Glt8fBzVlcN2vxWmPY
         y86pRHLVd2C+7VcUO9ynh9Xoq0tLfGr1CvRw/CVkpWN/six2hVZrrHjuj6GzPL1i8BzM
         4i3B911bTmAmccNt3VDRbLFsj0MYrzc3jGZ2SS4tT3lac5xOa1CNNto83l3bEM1Qwcvu
         FUwQS5nPO0TknmwQlluLVLCN2vTEn295Ua2RZnDGbUutlY4JINVRS2VMDyee1of4gthU
         Uc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=wOysoelzRnYOrkG2Z14SpjF49EYeBD1nfmQf5XQ3/pk=;
        b=Xerxa7kXbCo6+CLCwfGOIc6+fSRvtxyKbTRvj9DoLmSmMox2beg4gz3VtJoMfcsKkI
         S+hn6H1c/IK0KhB61YUm5u8SopU3LZTq0+JEIg65tjgwSD4aBwZ1LQdQtLd+CiKCx6TW
         wcX6C+y13RVSgXxYENBxvgjk6pH3VhW5a8ItLi2U/h+j/1U4kNQ/HiZz5omrJzhdfta+
         57f4M+x7C97IVyyLG3B2Pvip3aYpl2nfPHViZC0meQhullW+Jm/iEUnSFjpMVs1zWmZ1
         oJns/QAYJvAoHmJX/+0kLwGi1Zbj5VnZHkCCo5Tswuf0BKgioDCxgbtJSU2jO7IfMXzA
         zVqA==
X-Gm-Message-State: AOAM530qvfdjkj5OQIPN0wSybQiI/8nfSmWeu7baZ7GVZipVyGyRTMoJ
        6C9u7ybrfs5Z9PHY8RIiSas=
X-Google-Smtp-Source: ABdhPJxunpBISIifFPuab4Mg/GPMoxrcKWPdMAgQFoEi64HcjCUlfzDCfXn5kYEf2FICI5manF7e0w==
X-Received: by 2002:a92:cda8:: with SMTP id g8mr4047858ild.286.1616619583331;
        Wed, 24 Mar 2021 13:59:43 -0700 (PDT)
Received: from [127.0.1.1] ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id s5sm1601304ild.13.2021.03.24.13.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 13:59:43 -0700 (PDT)
Subject: [bpf PATCH 1/2] bpf, sockmap: fix sk->prot unhash op reset
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, andrii@kernel.org, daniel@iogearbox.net,
        ast@fb.com
Cc:     xiyou.wangcong@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lmb@cloudflare.com
Date:   Wed, 24 Mar 2021 13:59:29 -0700
Message-ID: <161661956953.28508.2297266338306692603.stgit@john-Precision-5820-Tower>
In-Reply-To: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
References: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
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

To fix handle similar to write_space and rewrite it in the TLS update
hook. This way the TLS enabled socket will point to the saved unhash()
handler.

Fixes: 4da6a196f93b1 ("bpf: Sockmap/tls, during free we may call tcp_bpf_unhash() in loop")
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |    1 -
 net/tls/tls_main.c    |    6 ++++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 8edbbf5f2f93..f6009fe9c9ac 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -349,7 +349,6 @@ static inline void sk_psock_update_proto(struct sock *sk,
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
-	sk->sk_prot->unhash = psock->saved_unhash;
 	if (inet_csk_has_ulp(sk)) {
 		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
 	} else {
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 47b7c5334c34..ecb5634b4c4a 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -754,6 +754,12 @@ static void tls_update(struct sock *sk, struct proto *p,
 
 	ctx = tls_get_ctx(sk);
 	if (likely(ctx)) {
+		/* TLS does not have an unhash proto in SW cases, but we need
+		 * to ensure we stop using the sock_map unhash routine because
+		 * the associated psock is being removed. So use the original
+		 * unhash handler.
+		 */
+		WRITE_ONCE(sk->sk_prot->unhash, p->unhash);
 		ctx->sk_write_space = write_space;
 		ctx->sk_proto = p;
 	} else {

