Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B56146D71
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAWPzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:55:39 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54159 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgAWPzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:55:38 -0500
Received: by mail-wm1-f66.google.com with SMTP id m24so3097426wmc.3
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 07:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1WPgC+WzLyR0JTgO+VoeJbEDZ15TC0NlN7bHnmyGW2I=;
        b=sAHPVyqYzEvMha6fJROM+PxTgNcCuPo0cqK6Hmrx/LtDCX9xkACEVFpq3smba2rVdX
         241+QsoWj3jHFOjTX9ZOnh2/rjweZ1pugbdNMtq5P0MHHbKs8cOZTxUgwbwXY2oEE0Jj
         4aKna+SWlPYXVm8IQgZ9KUW3wS9mmOaCGtb5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1WPgC+WzLyR0JTgO+VoeJbEDZ15TC0NlN7bHnmyGW2I=;
        b=n9530rcM2F4bCEI9teqyXzPJKU9ipsoSkKiBL2V4MWEmpRvpDVQTBHNV6A7tGp/m88
         7ZeCUETPORq3Z7f8lJ7qrjkVgdxmYmLV8Z3cUrN/fPf5WaudaUGG3W2ojNtpC+j4UFLe
         usJZPBtcTfUsq3cKRkkzi9vjJN6H0yH61i9edHEuPfMe8a3fv3k6w8ew++5Nx7N1wB6S
         lF0k8p1qsFrKjHSSXfgwiN+osc5gf8YtNjfUuZecBkN14SBbA8mFYNZxYYHXEoH1CXgQ
         K1LUG44U0JV2Dw7x1jWyTsehjZ/hHtVyh9/x97spqGtpF2MpQcj9qaFiW+L0P10xhoI6
         vsiA==
X-Gm-Message-State: APjAAAVjd5ik3knw3vUGgr2D0l+fvY1VXegkSj+3ZhV+Zy7cMwaCYKGp
        ery3q7jTOFBBTfvDkVMn04a0Pw==
X-Google-Smtp-Source: APXvYqxusyD9UZ0NtSJm5Rb2TIUtnZRoVYn3HHN6hF8Fj42CoPuNw7X83sITQRWfWc/8VVkI5MGWbw==
X-Received: by 2002:a1c:5401:: with SMTP id i1mr4616036wmb.99.1579794936814;
        Thu, 23 Jan 2020 07:55:36 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id o2sm2554270wmh.46.2020.01.23.07.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 07:55:36 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 01/12] bpf, sk_msg: Don't clear saved sock proto on restore
Date:   Thu, 23 Jan 2020 16:55:23 +0100
Message-Id: <20200123155534.114313-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123155534.114313-1-jakub@cloudflare.com>
References: <20200123155534.114313-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to clear psock->sk_proto when restoring socket protocol
callbacks in sk->sk_prot. The psock is about to get detached from the sock
and eventually destroyed. At worst we will restore the protocol callbacks
twice.

This makes reasoning about psock state easier. Once psock is initialized,
we can count on psock->sk_proto always being set.

Also, we don't need a fallback for when socket is not using ULP.
tcp_update_ulp already does this for us.

Acked-by: John Fastabend <john.fastabend@gmail.com>
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

