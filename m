Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0792B5451
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgKPW2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbgKPW2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 17:28:40 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0100C0613CF;
        Mon, 16 Nov 2020 14:28:40 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id c80so20535248oib.2;
        Mon, 16 Nov 2020 14:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=q+bd+cUjjSfkR1FQPl/zR8A8bFzyViDmXWLlsRkGbGs=;
        b=RSIwQmz5qzYWep66OFswdDRF+PMc0FkXPJiK8NCcWJqrpcZahgHDKA7UycPIA7IxbP
         5Bns8KKbS4x7BgoC5v8oy0Km/gRTFNI52p/DaeAref5MUfBg7jhRTFAhnj3YCQ4uchyI
         9fB/4jZpL8Y8LxgovARdP9mZ9J1UYkZtDRae5l/RS4lPH7WJJxs3G69r04+qh1ZIY/Xc
         VVl/PAgKV5vnvTQwHN4ZzkfL/DA7s0Wn5XHjqurRbgfkcnhoBwP3C5d4gSi0pVLincxj
         I30T9iPwRiQBiqNGx/pmbJ7SwGt0msNA3m+Ll0/p3EeObewkSWPMDg2/n5HSWbArL9CZ
         Zyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=q+bd+cUjjSfkR1FQPl/zR8A8bFzyViDmXWLlsRkGbGs=;
        b=j6h2UQ7L/j5TmDGHjZ0MVZBt85Lo9TuUHWb5wiUH26G3wyxSjWsO+aMgD5iygcWWx5
         cV0vqpiUJ90splitrs+M8BgsnTg8xSNs/UP7PzWojLicYtSzhSzJDBqwIP4AP+zvvOb5
         AJgDX2aYeWde67h5DY5lokO+sjBxqqss9uFh8ekhHL6c0jw42yVNjHJv+W70DY98c6tP
         DPQhXRUtfwVoE5zIUE7PmfchdfNSA3bhXS8PiN9fRc0GbklF/PFbX/ac8xmlzixLCtiv
         5LYNQq4kOZk9lIKinw8RtonCw2eKNc4yc66zDnWxBwCvjS/FtFIMvljPCLITEEZqJ+LX
         8Tiw==
X-Gm-Message-State: AOAM530FMEDN6q3nsbAWjjeLK9plQT3+iGTGYgZHCCyubHxDDgrDmtpk
        fSheyFTjQnEd8czyondsEX5Qv3VumPK9Hg==
X-Google-Smtp-Source: ABdhPJxwWWyk+mIWcAW2pSC9zdUzwazc5azWHjsQJzNy95zwVpS65oRUtWVp26jcWWeJNYFjVNivZg==
X-Received: by 2002:aca:54c5:: with SMTP id i188mr565217oib.113.1605565719934;
        Mon, 16 Nov 2020 14:28:39 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j21sm5308540otq.18.2020.11.16.14.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 14:28:39 -0800 (PST)
Subject: [bpf PATCH v3 3/6] bpf, sockmap: Use truesize with sk_rmem_schedule()
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, ast@kernel.org, daniel@iogearbox.net
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 16 Nov 2020 14:28:26 -0800
Message-ID: <160556570616.73229.17003722112077507863.stgit@john-XPS-13-9370>
In-Reply-To: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
References: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
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
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
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


