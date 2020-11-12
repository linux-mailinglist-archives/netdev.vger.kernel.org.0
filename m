Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE34D2B12C3
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgKLX1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgKLX1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:27:36 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A22C0613D1;
        Thu, 12 Nov 2020 15:27:32 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id c80so8413060oib.2;
        Thu, 12 Nov 2020 15:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Mwy/q1OsCumX7Ymcr0qph52W094rvZ6gjyVjTWBlDuM=;
        b=I3hKM3GvVphY9rSSPWasliXATFDnTk5WZQOB6SOLuHseKnem4FAL+KE/HQz5knf8LX
         5XBhQJeOEYnlyNZ7sNgmc2rurdjKeIJfNRNVbMk79To+CuC78TSHnckkkPjJ3yyaj5NA
         m2+EIbCUOXPYP+pJqgnYV6vyqd9xvGDojAPt/Ndkl4dlehkwIE8V65Jgdz+xRlijjiio
         0QALxACcnoWxUHSzPH+NPlmt54I0Wh52Ku7nBWSCBcyPaVr9bR0CCCCyXIL2vM4ygX51
         oddJylPrPTOhmkFp3hHZbTCjGtvjYuh9V/gRZX37LkInyoTiy+1FjFkIlui3bLYOkFfw
         aRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Mwy/q1OsCumX7Ymcr0qph52W094rvZ6gjyVjTWBlDuM=;
        b=i47zlheXMrmOeRSdirlzn+3ToCGQZfnT3skqvvclEZQbOIMcPZh1SjaAyhb6Sy+5LZ
         H4B0OeGw0HnLM2IydnnOW2psMJ7EDm+RXs+hD2VFRgUtDDfp7/3AnzybhXSkBTBPESBb
         /3OET4nuNYcxayX2iG+OBHfI2bYODDzKedUGS5tvevoCn1knSciMroPD5CXga5GYAj0J
         aDYbWK+hIMfhu9tiwan2n7aVFT0vTz/wzdYL0mKUzLunrEQYMNafMXmA/yIZZhGIWzoi
         OfL9zJogbwejfD+oB7PYwRrESjoSBHGFa8lJwYwmAKdjU1/NuYy4fzbUzlEgsxgv/EvH
         sybQ==
X-Gm-Message-State: AOAM532UYQJBNaK+wdS4av46sMHUGQYySLQmkNZY+nvS8Na22a31CvSy
        4E8spj6vkV1k9eZmsyCcKeI=
X-Google-Smtp-Source: ABdhPJyRXSD9z8Z3j8WQbTMTV24DWLlNTEPLvgSnCNvP2pH+grTFWj86zk7R0axKRwzgT3c43/D5rg==
X-Received: by 2002:a05:6808:d9:: with SMTP id t25mr144563oic.102.1605223652009;
        Thu, 12 Nov 2020 15:27:32 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u5sm1628057oop.8.2020.11.12.15.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:27:31 -0800 (PST)
Subject: [bpf PATCH v2 3/6] bpf, sockmap: Use truesize with sk_rmem_schedule()
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Thu, 12 Nov 2020 15:27:20 -0800
Message-ID: <160522364023.135009.13166901167357981092.stgit@john-XPS-13-9370>
In-Reply-To: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
References: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-36-gc01b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use skb->size with sk_rmem_scheduled() which is not correct. Instead
use truesize to align with socket and tcp stack usage of sk_rmem_schedule.

Suggested-by: Daniel Borkman <daniel@iogearbox.net>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index fe44280c033e..d09426ce4af3 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -411,7 +411,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	if (unlikely(!msg))
 		return -EAGAIN;
-	if (!sk_rmem_schedule(sk, skb, skb->len)) {
+	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
 		kfree(msg);
 		return -EAGAIN;
 	}


