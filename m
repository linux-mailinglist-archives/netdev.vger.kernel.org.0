Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7989B1611D3
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 13:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgBQMPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 07:15:37 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36539 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgBQMPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 07:15:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so18211915wma.1
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 04:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6jhXRrQSXSenGIiSLZ4zcs5tlGfcqenC3FGgTWRAfM4=;
        b=SjzhWHmqMyT4n7iPeJbhmYRvNl5eybjbUJwsmYKTYjAwnidVJxa9wtGATzs6Zn5fnM
         ypjwdAD1l4DpoQs1k37Hj8ztfvPwHowm49QhPBbhY4oyNHNaBq8RH/U30KwJWHGKLeFY
         vUJpfg6qym9MfS4vGjeeCgq+9C7gojeEdVnI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6jhXRrQSXSenGIiSLZ4zcs5tlGfcqenC3FGgTWRAfM4=;
        b=c3+FxH1n1mwjsaQExKXiV8NwQcwM+z1N4+DOzy1DF3deUqfElIM1mZ5HleqcxlFqSW
         nqBtYPBmnmKUlrlsJP2Dvz9D5EIBdwTl7Z10v5lf8LsyAhRqWOQltfj2Zs1LCg+dInIP
         BveAwOOMnnMAGaMgldvftcR3WpHuNn+blEiq9CYxE/LjlAE8jkKdK+g/E8/VLJofOeKm
         o2s3hAX6oZZ3HQf9WLIwoMWHmiIYzafqQCId4yyPpv7vqDdNsiSGYVcj+C+v9SUcvail
         vSMn/7goXdOsXGDOx08SEHyW59K3AvJLgtM27S1zbrk49dC7iVTmpGRe8mXGfm/wFAae
         Mmjw==
X-Gm-Message-State: APjAAAXvJFy+tcL98r8elem1+V+jYOqLoTcgPr4zF5JRSMsPzgiXw45n
        RW7Su3+iKYkuxnRr0+Eq/eBZNQ==
X-Google-Smtp-Source: APXvYqyODJkVDyegZf4qGggGF0nf15h2Ug+//Z+Kx+mqj1nI533+qnx9OOQSKNUn/C6iQOaaHx5hSQ==
X-Received: by 2002:a1c:e3c2:: with SMTP id a185mr21902532wmh.27.1581941734178;
        Mon, 17 Feb 2020 04:15:34 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id a16sm661409wrx.87.2020.02.17.04.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 04:15:33 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next 1/3] bpf, sk_msg: Let ULP restore sk_proto and write_space callback
Date:   Mon, 17 Feb 2020 12:15:28 +0000
Message-Id: <20200217121530.754315-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217121530.754315-1-jakub@cloudflare.com>
References: <20200217121530.754315-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need a fallback for when the socket is not using ULP.
tcp_update_ulp handles this case exactly the same as we do in
sk_psock_restore_proto. Get rid of the duplicated code.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/skmsg.h | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 14d61bba0b79..8605947d6c08 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -361,16 +361,7 @@ static inline void sk_psock_restore_proto(struct sock *sk,
 	sk->sk_prot->unhash = psock->saved_unhash;
 
 	if (psock->sk_proto) {
-		struct inet_connection_sock *icsk = inet_csk(sk);
-		bool has_ulp = !!icsk->icsk_ulp_data;
-
-		if (has_ulp) {
-			tcp_update_ulp(sk, psock->sk_proto,
-				       psock->saved_write_space);
-		} else {
-			sk->sk_prot = psock->sk_proto;
-			sk->sk_write_space = psock->saved_write_space;
-		}
+		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
 		psock->sk_proto = NULL;
 	} else {
 		sk->sk_write_space = psock->saved_write_space;
-- 
2.24.1

