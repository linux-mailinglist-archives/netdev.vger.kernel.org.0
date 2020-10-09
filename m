Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD26228816B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 06:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgJIEoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 00:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJIEoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 00:44:04 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9778FC0613D2;
        Thu,  8 Oct 2020 21:44:04 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q9so8823443iow.6;
        Thu, 08 Oct 2020 21:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=lLa3hBZMn4NHFo7xwpT+WHTGtW+n4KL1Gv/kNX990nc=;
        b=r5YKGZkdIz4ByXXD71ugubSnprRvd4//oV9EGwOfL5/J+ibnL51987JpWaj6vfOeDS
         Fbux2X9qw6sqVqBM8//8WZqXFyofZW9aUKmGcgaFcD1bayRoQvFKSvA6hVgDjOU3y3j8
         y9GOLmeNSb9FsGNSbh/TrBdhXzwkVu0vx9MDU1vf4RfbGAQeRbC3edDZuU5Wll5n1L6w
         eTircLqwwhoCXGcsAsR2vUWFwpeNguSx8jtmnCLz8wqGhq5FacS91uxrPETRl2cBj4mI
         RXA/+pNWPLA5Gw98cno93UxtlNkivr3x/TjfAVTGqkvn70ar7SD9KqXwAupBIOU5MWVM
         DN9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lLa3hBZMn4NHFo7xwpT+WHTGtW+n4KL1Gv/kNX990nc=;
        b=smSBAMTI3n+/4P+1hvYO+oKuaj2jmDFFGu9aJhJQyPbI2/tsg5EQk/MMgJsW/SEejY
         oNCQchlAo9GXOk2ZVyk8PLw1TdYdBkalee2psudCkH0u9sKj3fulCxzpQGwgHu7ZcTMa
         JI322Rl5W1jAu5OZN5X8V6jeGaO37zf0cjj2mmNk5GqOirDVY/tESXWj9Q4KyXCAiXbR
         DhZ/XFhd7b6q1XQdcRPgp0iqjCg229TklFz/7HEuzdNU6/lTOhR+BqUwA3gFT8424pyW
         EHzH7w26H+xZnYvg1N6u4cU9cP2RKdF7m/5UeAurbUWID2lrmR/NucdGYFxnKZW+kxEY
         tLdg==
X-Gm-Message-State: AOAM532S9xWhHjIeqeUWe6r23sBTQpLG0RFWIXzXyg2xIZCVyr1jpEHz
        m7NWfX4tbP3aLKYezqPBQRQcei7jR2bUHA==
X-Google-Smtp-Source: ABdhPJy8+WXvEQnuhXqMI6RuLjkYA/aYoBRPhvQF34tnnYDLuR3+Ewjn0pWnmvp96y695tvcp4Fytw==
X-Received: by 2002:a6b:4e0b:: with SMTP id c11mr8237298iob.68.1602218643966;
        Thu, 08 Oct 2020 21:44:03 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h14sm3673200ilc.38.2020.10.08.21.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 21:44:03 -0700 (PDT)
Subject: [bpf-next PATCH 1/6] bpf,
 sockmap: skb verdict SK_PASS to self already checked rmem limits
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Thu, 08 Oct 2020 21:43:51 -0700
Message-ID: <160221863101.12042.14367865435124784102.stgit@john-Precision-5820-Tower>
In-Reply-To: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
References: <160221803938.12042.6218664623397526197.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For sk_skb case where skb_verdict program returns SK_PASS to continue to
pass packet up the stack, the memory limits were already checked before
enqueuing in skb_queue_tail from TCP side. So, lets remove the extra checks
here. The theory is if the TCP stack believes we have memory to receive
the packet then lets trust the stack and not double check the limits.

In fact the accounting here can cause a drop if sk_rmem_alloc has increased
after the stack accepted this packet, but before the duplicate check here.
And worse if this happens because TCP stack already believes the data has
been received there is no retransmit.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 4b5f7c8fecd1..040ae1d75b65 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -771,6 +771,7 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static void sk_psock_verdict_apply(struct sk_psock *psock,
 				   struct sk_buff *skb, int verdict)
 {
+	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
 
 	switch (verdict) {
@@ -780,16 +781,12 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 		    !sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 			goto out_free;
 		}
-		if (atomic_read(&sk_other->sk_rmem_alloc) <=
-		    sk_other->sk_rcvbuf) {
-			struct tcp_skb_cb *tcp = TCP_SKB_CB(skb);
 
-			tcp->bpf.flags |= BPF_F_INGRESS;
-			skb_queue_tail(&psock->ingress_skb, skb);
-			schedule_work(&psock->work);
-			break;
-		}
-		goto out_free;
+		tcp = TCP_SKB_CB(skb);
+		tcp->bpf.flags |= BPF_F_INGRESS;
+		skb_queue_tail(&psock->ingress_skb, skb);
+		schedule_work(&psock->work);
+		break;
 	case __SK_REDIRECT:
 		sk_psock_skb_redirect(skb);
 		break;

