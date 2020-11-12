Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E182B12C9
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgKLX2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgKLX2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:28:12 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FDAC0613D1;
        Thu, 12 Nov 2020 15:28:11 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id i18so7352405ots.0;
        Thu, 12 Nov 2020 15:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/o7ZpPtFo1LVwWxsfIU+NA+EfMMD1Zz6ZcEYNl6gVDg=;
        b=Hob1Oah9DaeJ+GWHOoRieGI10cNlNgdRQpaAblY6ThPN6Acl1edbt99HhpS+Te0tcE
         oIbFojF2tDktWGT1fhp5OkJDwvkAIVVSmNdlmGvBIzcLGIM2WJJWYAQs9HpaM19nx1Pz
         DtEPwDkb8ITp4daLwbXrD7LvgDX42bSod3NrCrpUhXyeMOOO9570/dLBEMBVzL9Zaxhr
         pRmjAsqeWZDXv4uTr1/AsF1HvdqXM2YijrV1Iwb73uu0f6RjGCanReGFrQ618NapqsHJ
         dKkwsId7/9IX7H0/ggFlhdfuwAEJtZyHIMwkYCe7GWLSnFbta4qmKHia7pXj80uuQh3c
         7AqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/o7ZpPtFo1LVwWxsfIU+NA+EfMMD1Zz6ZcEYNl6gVDg=;
        b=SmqT8hDRbXY0mKbexAAGt9WDwalUzHrHeo8Jb7jgCK1lcLG7M1N9LgpXFy6ElRPfaB
         4NeOviAxth4PWb92dihkslJZ6dZ+Y9q76Ss8pYg6Kw827sKXxOrFaNoELBPjMx23Rl5C
         fC1U3y99/4vciSNGKAB/IBZGhKxIMaqkJb/gVWM6hKeQ5LoDaTg3cuIIHLe0EvlQQ8vr
         QMfL9HMqUAvanznBJeK9i2jQwA9/9aLJ+eLZkxSzBPlHH6T1tvXljGviRd7fC9EmNuLJ
         ncLZybry66oFm7bnrcFfSAsvivd/35vybfMiNInS/JzIB1OOF6rWO23T6L7sApCwvhsV
         E9Ow==
X-Gm-Message-State: AOAM533iO3GL7aoPEbXt4PNR1FWNAb6Q9hi7C2aajo4oTc3TcbC1Q6a+
        5l5bjmkJ2/AfYvdSuryHHFw=
X-Google-Smtp-Source: ABdhPJwp9JfZZgpdytWo6XP5Qf14k+euWXuOPxNV65w1T8QYKbmoSmFwUyy+pV81buOP9UcMZYbQRA==
X-Received: by 2002:a05:6830:1dd8:: with SMTP id a24mr1201546otj.163.1605223691420;
        Thu, 12 Nov 2020 15:28:11 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m65sm1576836otm.40.2020.11.12.15.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:28:10 -0800 (PST)
Subject: [bpf PATCH v2 5/6] bpf,
 sockmap: Handle memory acct if skb_verdict prog redirects to self
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Thu, 12 Nov 2020 15:27:58 -0800
Message-ID: <160522367856.135009.17304729578208922913.stgit@john-XPS-13-9370>
In-Reply-To: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
References: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-36-gc01b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the skb_verdict_prog redirects an skb knowingly to itself, fix your
BPF program this is not optimal and an abuse of the API please use
SK_PASS. That said there may be cases, such as socket load balancing,
where picking the socket is hashed based or otherwise picks the same
socket it was received on in some rare cases. If this happens we don't
want to confuse userspace giving them an EAGAIN error if we can avoid
it.

To avoid double accounting in these cases. At the moment even if the
skb has already been charged against the sockets rcvbuf and forward
alloc we check it again and do set_owner_r() causing it to be orphaned
and recharged. For one this is useless work, but more importantly we
can have a case where the skb could be put on the ingress queue, but
because we are under memory pressure we return EAGAIN. The trouble
here is the skb has already been accounted for so any rcvbuf checks
include the memory associated with the packet already. This rolls
up and can result in unecessary EAGAIN errors in userspace read()
calls.

Fix by doing an unlikely check and skipping checks if skb->sk == sk.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9aed5a2c7c5b..f747ee341fe8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -404,11 +404,13 @@ static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 {
 	struct sk_msg *msg;
 
-	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
-		return NULL;
+	if (likely(skb->sk != sk)) {
+		if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
+			return NULL;
 
-	if (!sk_rmem_schedule(sk, skb, skb->truesize))
-		return NULL;
+		if (!sk_rmem_schedule(sk, skb, skb->truesize))
+			return NULL;
+	}
 
 	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	if (unlikely(!msg))
@@ -455,9 +457,12 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	 * the BPF program was run initiating the redirect to the socket
 	 * we will eventually receive this data on. The data will be released
 	 * from skb_consume found in __tcp_bpf_recvmsg() after its been copied
-	 * into user buffers.
+	 * into user buffers. If we are receiving on the same sock skb->sk is
+	 * already assigned, skip memory accounting and owner transition seeing
+	 * it already set correctly.
 	 */
-	skb_set_owner_r(skb, sk);
+	if (likely(skb->sk != sk))
+		skb_set_owner_r(skb, sk);
 	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
 }
 


