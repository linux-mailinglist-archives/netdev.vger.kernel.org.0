Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0842B5459
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgKPW3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgKPW3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 17:29:23 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A327C0613CF;
        Mon, 16 Nov 2020 14:29:23 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id k19so11878094oic.12;
        Mon, 16 Nov 2020 14:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=wz0IJ/hlMcfL+ARf40dglrvKGm0TqnMJcE8E8aIInjk=;
        b=EtB0W5/AjEzM//nTSHunLzogOf83F88aMH7RG1i4TamCBAY2986NN9zbCfsTHv5RRI
         gKoOGXG+tOIr77aPTs/VicUljIJdNPPCAtAiWqSvMhHTI+nSpJ/LKC3G9wsdezx4O3v9
         hVNE/2Tzi/llHqRHr5zEe/sV9wvhXuLWq+ye+R7fOGPHS/dNmbYHA/fHV7Pu/NNyjmhP
         uel6pVymrO2bgkZh05JS6svmDCrMlVVrHhdbkk6d3Puz+3SZsiYA1biX0jcwU7qn9kEL
         AMjqWI6ev5qDs/VS4L8FnM8cQT4J86X9U05mKTdUpbVLiL0sK6uSq02qIzgSvZ4OVrb2
         MnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=wz0IJ/hlMcfL+ARf40dglrvKGm0TqnMJcE8E8aIInjk=;
        b=eUhh2zSSBblzST/RPz23/WVRPb6u8Dpqsh1xmy2sWSjEy6EH2EFUKeQCh6dVK6W3P7
         5UdqoUGvxyMu1jP3+Lzl2X1NDMW1HJI6CJCC5ZtRDUjm0g9FQjL9yYDRNY+2DYGip67M
         Q5UY2VGRnUVcsDur9OTgP70ofws99memQEYE4KP8X1Z8VXnRLpExIOXNZrS8SB/5qq/t
         qTE5C/KYD0FDFnDhS4V/mnYrBiJFgWoItBRHCLQg6tEMpA+O4wYoa9NF9V1NcrrLO19C
         MVz+lDWL9a7Ao3A1id2VPvzNj3vE7i2l97+y17SvQcoxL4WW0gEkyQYIr9mcrDjXF7jl
         ZizQ==
X-Gm-Message-State: AOAM531I5s8hVFwrp3E3S3DLfGGJnLI9OguEe7FR+O6ZWKA4aa9mvLfI
        BhJZ0V39qYnYCPCiQ+uTl4zhYMZCw4Bcrw==
X-Google-Smtp-Source: ABdhPJxONS2U765bzX7oLx2jORWygnzCVebNGLXvmvjq14UCLmSS0mobW8L8doT7SrGD2+GRp0gi3A==
X-Received: by 2002:a05:6808:494:: with SMTP id z20mr581408oid.10.1605565762485;
        Mon, 16 Nov 2020 14:29:22 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o135sm5229313ooo.38.2020.11.16.14.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 14:29:21 -0800 (PST)
Subject: [bpf PATCH v3 5/6] bpf,
 sockmap: Handle memory acct if skb_verdict prog redirects to self
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, ast@kernel.org, daniel@iogearbox.net
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 16 Nov 2020 14:29:08 -0800
Message-ID: <160556574804.73229.11328201020039674147.stgit@john-XPS-13-9370>
In-Reply-To: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
References: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
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
 net/core/skmsg.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9aed5a2c7c5b..514bc9f6f8ae 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -442,11 +442,19 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 	return copied;
 }
 
+static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb);
+
 static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 {
 	struct sock *sk = psock->sk;
 	struct sk_msg *msg;
 
+	/* If we are receiving on the same sock skb->sk is already assigned,
+	 * skip memory accounting and owner transition seeing it already set
+	 * correctly.
+	 */
+	if (unlikely(skb->sk == sk))
+		return sk_psock_skb_ingress_self(psock, skb);
 	msg = sk_psock_create_ingress_msg(sk, skb);
 	if (!msg)
 		return -EAGAIN;


