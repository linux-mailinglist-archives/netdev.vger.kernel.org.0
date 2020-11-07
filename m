Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868072AA7B9
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgKGTjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGTjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:39:07 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4F3C0613CF;
        Sat,  7 Nov 2020 11:39:06 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id k3so4646611otp.12;
        Sat, 07 Nov 2020 11:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=7SSO8P7QNjSDnyLJqh8IxVjW+CSfAgn4F8/JaQHnAL4=;
        b=bn7rWu//83wK0urzZf+yCJenGPDafaWYhy1Y8Mvdb+CQWTzGTyKrvDJ0ItkalDxfDO
         9LLF4MAveDC2iL8iYvrqCyjPJlYDALMh+QzvOr+HjFKjjAqFmpCxqo7fQdx+zBqRDXPr
         N7XV4NucpbCKfXtkkR3Lz6M3ugSDTHMfsr16Cys2ka8jJfa/72CTLPh+4BN2UuioZe5o
         g0hdXHGH8FCQ3ojjHo8DLYJ+II3A/leT/VXe54Vg4A7aNGiCVbv3ruYdVtvvP1Tm6T0W
         zU7OFJTAa9RIB1RPKdDBBXze/CHuPvy84RA3IdRreViePbELGFmhIBcKDgfT/PSbTzmu
         thNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7SSO8P7QNjSDnyLJqh8IxVjW+CSfAgn4F8/JaQHnAL4=;
        b=NqhV/ztanwC1POrll4MrzUYyBDj8MkMIRXPT9Wgq/KCVzXdUium3nEWYmSofXu74gs
         +F8OUC1w/Srm98jhHS0NfjPB3uV+iMn1gKW6V/uQEM8vkaHMU+FYGLtgcqal6HrA4jno
         IUUHydD2NaMU+vmqWIx8p82iXiUg54ue4gwbxtXpfAkT5uh1F9PBPgZe0fAvz8+PLfRX
         UDcaA/QgKRvF2FiBmoZ4FwvnTuTMi4F7yKEMqTPvJ2IJtELI5/wECBvtiItL0DQwK661
         pdSoGI9po4QNw6n0wWX/fa7cgduZrFQXCyz/WUGyOO0aBoxLodnRvVU8kLOZCCEEEGBz
         C3bw==
X-Gm-Message-State: AOAM533uzKPY7qSiMLY0mDXTtLzZ4/WA3xa2VORf/dlfcdHPs02NyEzZ
        W3PKjUuT+Ox1yIGERN8NPG4=
X-Google-Smtp-Source: ABdhPJyK7FIQDOg6PuDArIPCEmh0BvsvMgx6X48ITd/6wo8Xeap9PlK3A/JIpyO5BviKjOghbBATuw==
X-Received: by 2002:a9d:4c18:: with SMTP id l24mr5034347otf.291.1604777946315;
        Sat, 07 Nov 2020 11:39:06 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k15sm1206555oor.11.2020.11.07.11.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 11:39:05 -0800 (PST)
Subject: [bpf PATCH 4/5] bpf,
 sockmap: Handle memory acct if skb_verdict prog redirects to self
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Sat, 07 Nov 2020 11:38:54 -0800
Message-ID: <160477793403.608263.17626285322866020367.stgit@john-XPS-13-9370>
In-Reply-To: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
References: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
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
index 580252e532da..59c36a672256 100644
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
 
-	if (!sk_rmem_schedule(sk, skb, skb->len))
-		return NULL;
+		if (!sk_rmem_schedule(sk, skb, skb->len))
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
 


