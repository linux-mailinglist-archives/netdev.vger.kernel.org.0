Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7285F14A498
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgA0NLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:11:03 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41845 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgA0NLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:11:02 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so10592600ljc.8
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oGEzFFujPwWuIw3gQtLufJeQphlCGYv9Oxfo+ByH1nw=;
        b=Yv7D6EvZiQty/obe4fvkmNfyKdZOYrQX2e1LGFuf/X7lFW11e2o+WEw5rJ9tGcxhbg
         6CwUkSuJEcGjQPRRwtxxhnpdIu722wI4Cze07jk7g6w0wMYBw/+Ni2mAggN/wXZvcyRG
         zWIiY09RVZ2Cue8IhnBfJt3NcySwj+Zb2gRfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oGEzFFujPwWuIw3gQtLufJeQphlCGYv9Oxfo+ByH1nw=;
        b=Z7c/CWUep7oBGU8+21qrbzqlY4JH1HnCJoYMgtUzL+A8n7bd7O4Y2abZWx6tGSLjZX
         f89VRRNbx/iPj0BdnBxEKLQosulNVAVfgYduygurve8zJgLY6nnGMbRKH3abf3DWwvwq
         ywPOQ375ZYekROfbNHd9kXBaSXZ8H+uJ+Bfj8U4LhDmmJXhIOXFMfJ8PuMa89423Y2YQ
         ngPUHKA8fTVQFK/qQfPjxqpUQ8JJYttCTaia7niq///QCwbOBExqAPaC2+qNP6f15LIr
         A5eMbbDWFRp65/0uEemsdLsNk5h6G6/WDTFOqeRig4rEYvCsoZ5tqDWUi+ZjYT1xJmTz
         5ZVQ==
X-Gm-Message-State: APjAAAWF+ddLOxnhkyQLurRSG3kAESjpbXjSCK3KxKJPZHYXdiaq68fr
        dDjC0huXbfmJeOn5ll2gtoSkLg==
X-Google-Smtp-Source: APXvYqy+oAUebTRtGco+zIxlpQsLiGdUmPPnP8sGWlLjV9waufhtiP7pk9VqIuB4z/F/GAe/3ZnPww==
X-Received: by 2002:a2e:b80e:: with SMTP id u14mr10529928ljo.17.1580130660463;
        Mon, 27 Jan 2020 05:11:00 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id t1sm8214248lji.98.2020.01.27.05.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:11:00 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v6 01/12] bpf, sk_msg: Don't clear saved sock proto on restore
Date:   Mon, 27 Jan 2020 14:10:46 +0100
Message-Id: <20200127131057.150941-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127131057.150941-1-jakub@cloudflare.com>
References: <20200127131057.150941-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to clear psock->sk_proto when restoring socket protocol
callbacks in sk->sk_prot. The psock is about to get detached from the sock
and eventually destroyed. At worst we will restore the protocol callbacks
and the write callback twice.

This makes reasoning about psock state easier. Once psock is initialized,
we can count on psock->sk_proto always being set.

Also, we don't need a fallback for when socket is not using ULP.
tcp_update_ulp already does this for us.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/skmsg.h | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 14d61bba0b79..6311838e7df8 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -358,23 +358,7 @@ static inline void sk_psock_update_proto(struct sock *sk,
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
-	sk->sk_prot->unhash = psock->saved_unhash;
-
-	if (psock->sk_proto) {
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
-		psock->sk_proto = NULL;
-	} else {
-		sk->sk_write_space = psock->saved_write_space;
-	}
+	tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
-- 
2.24.1

