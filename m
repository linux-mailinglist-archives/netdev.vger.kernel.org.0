Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D6D417D77
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344773AbhIXWHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344595AbhIXWHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:07:00 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A48C061571;
        Fri, 24 Sep 2021 15:05:26 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id 138so29405468qko.10;
        Fri, 24 Sep 2021 15:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Its/Gyc2Kb4yZVwCQrfT/u79ExJ0kh4zkvYOSK5lAA=;
        b=mc1X2VLQeh1eGsSRKDL9XjlSFnWHqglrqo/gmlNEwrmntjBq5HbUk7ACSheufZl0/m
         ApjD82WwtBCCCrz+Thc2Nf2Ivtg5LUDYRN8dksv8I8/tTLk8re/yUQyx6u266B0Izync
         23IHH9xeBT0n3NXVMTN/woL2o1dlhtPBSey0iphU3Xch+unfbNuF3wvjGO0ajjgXRhM4
         YuybKsrWiU8cxV5+zB5YPAxTxmUWZIdm2cfwB/gtqqwbR7+5WmY5GRMGc4rXGE57wGKi
         /cdfBfp/QznI4SyegxipfQU1rARS0k0vh9SOwuyftOz71KvJ9878RKuOfpIW4UFBU5Qr
         /tNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Its/Gyc2Kb4yZVwCQrfT/u79ExJ0kh4zkvYOSK5lAA=;
        b=2Kab3TUGvSNJccbPQfS4GFmGqtGQ04d3TJ8aVAyaVFAhHaz2izZyjZlZYB+0NK7Ysz
         vU4rAzNSJbGxoAJ26I8MC5Rd3flVN88Y3IiCd/t+Zyhsqv4NVeVP8yAE/EQAD0RdYxMo
         Iy8h5qTYLyim1g8J7y/UDDPAx2PRRv0wGlCWGBRvxlywItuLIMh/mdnsHu/Q/8B4d3jM
         Or5Rtk2ie6jDLbH0DtAhOpBFsqKK/9R9aFobviKU3LCv1XabBDv4RUTovnHCT9fdtkJA
         bcUnnggH9ecR3ceYkaHfirdt5PBzkd8mTpSAwGJciKov/8asreOJA138LedLmbSpvH6S
         TPAA==
X-Gm-Message-State: AOAM533KllLFfLSFPLMOFbJ8GSn9UNtqV43tNFm/Ch6ufD99VoaKx+fF
        LWmlDzTLqaG8R5/Q/Ty1yCcELlnq+q4=
X-Google-Smtp-Source: ABdhPJyrnz/+AF6JmH7VyISYC0jQkfOWgSx94yIFPxNiLDq1jR21VoLJPDp+WlcUI8VtjBEtOdphVQ==
X-Received: by 2002:a37:b0c6:: with SMTP id z189mr13169831qke.344.1632521125943;
        Fri, 24 Sep 2021 15:05:25 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c4dc:647c:f35b:bfc4])
        by smtp.gmail.com with ESMTPSA id h2sm7895683qkf.106.2021.09.24.15.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 15:05:25 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf 1/3] skmsg: introduce sk_psock_get_checked()
Date:   Fri, 24 Sep 2021 15:05:05 -0700
Message-Id: <20210924220507.24543-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924220507.24543-1-xiyou.wangcong@gmail.com>
References: <20210924220507.24543-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Although we have sk_psock_get(), it assumes the psock
retrieved from sk_user_data is for sockmap, this is not
sufficient if we call it outside of sockmap, for example,
reuseport_array.

Fortunately sock_map_psock_get_checked() is more strict
and checks for sock_map_close before using psock. So we can
refactor it and rename it to sk_psock_get_checked(), which
can be safely called outside of sockmap.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 20 ++++++++++++++++++++
 net/core/sock_map.c   | 22 +---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 14ab0c0bc924..d47097f2c8c0 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -452,6 +452,26 @@ static inline struct sk_psock *sk_psock_get(struct sock *sk)
 	return psock;
 }
 
+static inline struct sk_psock *sk_psock_get_checked(struct sock *sk)
+{
+	struct sk_psock *psock;
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (psock) {
+		if (sk->sk_prot->close != sock_map_close) {
+			psock = ERR_PTR(-EBUSY);
+			goto out;
+		}
+
+		if (!refcount_inc_not_zero(&psock->refcnt))
+			psock = ERR_PTR(-EBUSY);
+	}
+out:
+	rcu_read_unlock();
+	return psock;
+}
+
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock);
 
 static inline void sk_psock_put(struct sock *sk, struct sk_psock *psock)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index e252b8ec2b85..6612bb0b95b5 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -191,26 +191,6 @@ static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
 	return sk->sk_prot->psock_update_sk_prot(sk, psock, false);
 }
 
-static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
-{
-	struct sk_psock *psock;
-
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (psock) {
-		if (sk->sk_prot->close != sock_map_close) {
-			psock = ERR_PTR(-EBUSY);
-			goto out;
-		}
-
-		if (!refcount_inc_not_zero(&psock->refcnt))
-			psock = ERR_PTR(-EBUSY);
-	}
-out:
-	rcu_read_unlock();
-	return psock;
-}
-
 static int sock_map_link(struct bpf_map *map, struct sock *sk)
 {
 	struct sk_psock_progs *progs = sock_map_progs(map);
@@ -255,7 +235,7 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 		}
 	}
 
-	psock = sock_map_psock_get_checked(sk);
+	psock = sk_psock_get_checked(sk);
 	if (IS_ERR(psock)) {
 		ret = PTR_ERR(psock);
 		goto out_progs;
-- 
2.30.2

