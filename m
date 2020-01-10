Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21776136B4F
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbgAJKud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:50:33 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39581 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgAJKuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:50:32 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so1343370wrt.6
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 02:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U8bTZzSa5WtPZSXKjtKZfblxBexJkqukVg2cI53b8oE=;
        b=m4otZIu8qoeeg+Bw/bDam7Wj7btwghbLpDe+jf3rXaZp8NH1x1g0i39rqPJQId6IBd
         ADRvn/MfL003Th7K4lSkxO+a2Lq2w3LEv0WHJk8+3zvc9x3/wN/rOL8ZK0kv1p8AwLUT
         55AUr+TSi1znbol7ekfnmdpVpj+A1XNi0dv/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U8bTZzSa5WtPZSXKjtKZfblxBexJkqukVg2cI53b8oE=;
        b=p/XpGOHtZaJh2gHFZCSEY8Ag5WZYPhuzmnm5nnmjrU62qFQyQMM6fHCyFO0IFavacB
         +T5VyQztavieF91peDrRYM/0FfV94yeqeHXFLtxTjoTkqtJK0UUxX+N0WdUooGK8d2CW
         b9PTmOX5+uZs6SLTVClCJEvEzEYuezVgadlb/8cAlCDha9G3DGYbqvT6UtGLAoukhFMp
         Zcufc0KgmOrYvkGkwAyTjqnYlU9mU1JfbLE2IC4+nBMDjF45pzXVjZAIDhfy5dvCVjyT
         rUbg426w+9lroU1oSGa+eLu1tEVd9v/LEZGk9Hre1ZHyErViLKsNUIFx9mgcjNruV/05
         tqcQ==
X-Gm-Message-State: APjAAAWUTKowdHyP6uv9ZukjJmcoC/mlX9CvDe7FcFC8C/xTTz0M0BqI
        joTFffSF91mYKfEaO0zpP+JaYw==
X-Google-Smtp-Source: APXvYqzNc+WTXjAzP4Yk8uU/h1J2JSIQFsd9sOsJiZTyxEQUNVLHzV/cixo54mjT9ZnNg9NsBC/Wrg==
X-Received: by 2002:adf:f3d0:: with SMTP id g16mr2966155wrp.2.1578653430727;
        Fri, 10 Jan 2020 02:50:30 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id s15sm1677500wrp.4.2020.01.10.02.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 02:50:30 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 01/11] bpf, sk_msg: Don't reset saved sock proto on restore
Date:   Fri, 10 Jan 2020 11:50:17 +0100
Message-Id: <20200110105027.257877-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110105027.257877-1-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to reset psock->sk_proto when restoring socket protocol
callbacks (sk->sk_prot). The psock is about to get detached from the sock
and eventually destroyed.

No harm done if we restore the protocol callbacks twice, while it makes
reasoning about psock state easier, that is once psock was initialized, we
can assume psock->sk_proto is set.

Also, we don't need a fallback for when socket is not using ULP.
tcp_update_ulp already does this for us.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/skmsg.h | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index ef7031f8a304..41ea1258d15e 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -359,17 +359,7 @@ static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
 	sk->sk_write_space = psock->saved_write_space;
-
-	if (psock->sk_proto) {
-		struct inet_connection_sock *icsk = inet_csk(sk);
-		bool has_ulp = !!icsk->icsk_ulp_data;
-
-		if (has_ulp)
-			tcp_update_ulp(sk, psock->sk_proto);
-		else
-			sk->sk_prot = psock->sk_proto;
-		psock->sk_proto = NULL;
-	}
+	tcp_update_ulp(sk, psock->sk_proto);
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
-- 
2.24.1

