Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DB82B5463
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbgKPW3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730174AbgKPW3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 17:29:43 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74906C0613D2;
        Mon, 16 Nov 2020 14:29:43 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id q206so20462967oif.13;
        Mon, 16 Nov 2020 14:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=el2fYd8ySBa3+ZWXicXA9IRpxKlp+zaCI41Z/ZlGF/8=;
        b=eb1D7T4xM76sGfv40jZcqpoRXtuhCkeuThZ+CVXQaYkXUhMUB3qWpmajJR7KN3UrQm
         W4i3euO6Rrisvhkx7PFt9TbF1oYZ+nBbvux2JDNOCnCZR3lS7L4riN5cfwuDw2rKuJvX
         Vhx1xc7570EwX5zJ9l0fN3yhYRU7bMTb52TKUcgBrl3SfJcyOt2XKhML9DVzy73u69sS
         AZ8iNLn1yHqRfdK4s13X0abVRmfF19ZoWHTEsAv/L7JpHRyMrrAXVWaaCaRJiAd18oFT
         vfCxRwB4/uBnhzDJCnt6iFuO7fxPTBWJoy+TosXeMwExAZDTTeRgGfja9LlHK2Ncuze9
         D/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=el2fYd8ySBa3+ZWXicXA9IRpxKlp+zaCI41Z/ZlGF/8=;
        b=au93biyizZoBc8yK7sHWd59ZZ9wt6tW8MpHlq4juJyxlsFd8vCevcZgxD6TLW0aC68
         gAbuWFvtBURKbBq43v3+CMzNH3176RVIZAB674eN8aW+W9dkeKDSGWyb6OAYlUx1Axqq
         w2b6ZRQfw6v0isQQTaYNyyyTmohG8PfVtyDxYP+95jG1URVaFjTvITLJu2+RSAAu5DoG
         r3OKcf9rlVXdMJ5hOb5P5AX47nt5H5VaosY3KHDbq35CsQRsJ0130EvsOcGssUGBsbxO
         NOl7CVKu5iSeasppX+9ximytqcIjF2rdJ8lY0UMzQQfk9GdUyxbWCInP1gshpW6KNIR9
         ncDQ==
X-Gm-Message-State: AOAM530YHSMCPBiB4ho2VzOfBt5fScPuX6Q7zviAvyhecwqyXiJc1KPS
        0CxRXsWEjCuTJL31lvuPClIAajpY66ufHA==
X-Google-Smtp-Source: ABdhPJyNHGfQTOvUJuJt1sTZp9GqGv7Mm4QAjPRw6oJxAKQ9jrKr+OcVXm1VmBk0IJuIKgGGhX1kmg==
X-Received: by 2002:aca:ac91:: with SMTP id v139mr539441oie.95.1605565782644;
        Mon, 16 Nov 2020 14:29:42 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o63sm5308469ooa.10.2020.11.16.14.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 14:29:41 -0800 (PST)
Subject: [bpf PATCH v3 6/6] bpf,
 sockmap: Avoid failures from skb_to_sgvec when skb has frag_list
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, ast@kernel.org, daniel@iogearbox.net
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 16 Nov 2020 14:29:28 -0800
Message-ID: <160556576837.73229.14800682790808797635.stgit@john-XPS-13-9370>
In-Reply-To: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
References: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-36-gc01b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When skb has a frag_list its possible for skb_to_sgvec() to fail. This
happens when the scatterlist has fewer elements to store pages than would
be needed for the initial skb plus any of its frags.

This case appears rare, but is possible when running an RX parser/verdict
programs exposed to the internet. Currently, when this happens we throw
an error, break the pipe, and kfree the msg. This effectively breaks the
application or forces it to do a retry.

Lets catch this case and handle it by doing an skb_linearize() on any
skb we receive with frags. At this point skb_to_sgvec should not fail
because the failing conditions would require frags to be in place.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 514bc9f6f8ae..25cdbb20f3a0 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -423,9 +423,16 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 					struct sock *sk,
 					struct sk_msg *msg)
 {
-	int num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
-	int copied;
+	int num_sge, copied;
 
+	/* skb linearize may fail with ENOMEM, but lets simply try again
+	 * later if this happens. Under memory pressure we don't want to
+	 * drop the skb. We need to linearize the skb so that the mapping
+	 * in skb_to_sgvec can not error.
+	 */
+	if (skb_linearize(skb))
+		return -EAGAIN;
+	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
 	if (unlikely(num_sge < 0)) {
 		kfree(msg);
 		return num_sge;


