Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A108C34F6CE
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbhCaCd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhCaCdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:33:05 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCDEC061574;
        Tue, 30 Mar 2021 19:33:04 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id s11-20020a056830124bb029021bb3524ebeso17611090otp.0;
        Tue, 30 Mar 2021 19:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R7RKRv5Jc3lBQtN71qE8m5rDgXTr5NP4RcQ1X/jJ5Lc=;
        b=P/aNmwDJ05dBrydNX7hSg9fEL99L/hwLfxRRbDJ727uQZVkFwlXTkvS6yy3L+tfml9
         TFV5+7OST/2oWoO7PYPQ8kz9X9Y7PxSYenFeJABl9wsJRa5NS0pL07JFWq1HT8u5HElT
         MitFJXqqhYmENIv2yp6aF8xqRe1og5qgGPZ60IeYJgI/Yq9vf6TU5T24nDkCV8dcuJTQ
         JwIAunhcMxeR0OLH76TBHwWmRSfyqEHxVg2vvM/jhuNvuxhepRAWN+Z2h8pSoaKSQkcq
         zLASnkqrELPnSBwu5I/ADbQ7+dXbsTWievdGmzPGsjaTBLKgFRtZvIuvzx/K93382fC+
         4oNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R7RKRv5Jc3lBQtN71qE8m5rDgXTr5NP4RcQ1X/jJ5Lc=;
        b=XY7+VBDrFSm5ZMj2gb/Q1ufVpVhFtQQGxz7PJBrTl0zCYkvnYaYroEBnog5+cBUE7W
         qA4uuXDCD51ZyD5oSRdESxDyuqRXSkBLgx0UnreJwL58U28ezwMXEtD5rCmwfDz5W80R
         pn35rKhT2ewaqRfppCRARA5mqLQEFrw1QET78+WTjvSqCnmr9eQg7WSRTBmZKcm/PN+6
         0qzubrG6PDql4J0PK4+ICw5gmAtLycPrgMiDikOMpgc5UaNV7/npLkf82uPeEFRSXO2+
         V8NyETFO9PUSfnH19L1i4qfkr5Rq411Xpa+I8SS5keAQKXVgDkX/oXy12cQdg8A177dl
         pqtQ==
X-Gm-Message-State: AOAM5314qgUS/JS8z4nU2FT4KFcVuas8lNw1s2g1H0bPXstQoPt6KggA
        GZ44w/XyVVgSn9VczsHl2siep4Fk9b1xxg==
X-Google-Smtp-Source: ABdhPJxCEJnNCG1i7I3PLqFSP8qYjSDaquzE9jlsE2fL72K/h7B9sMJLjRhPji+eGMlnEfzU/AKSaQ==
X-Received: by 2002:a9d:62d9:: with SMTP id z25mr801447otk.194.1617157984182;
        Tue, 30 Mar 2021 19:33:04 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:33:03 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v8 14/16] sock_map: update sock type checks for UDP
Date:   Tue, 30 Mar 2021 19:32:35 -0700
Message-Id: <20210331023237.41094-15-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Now UDP supports sockmap and redirection, we can safely update
the sock type checks for it accordingly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2915c7c8778b..3d190d22b0d8 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -535,7 +535,10 @@ static bool sk_is_udp(const struct sock *sk)
 
 static bool sock_map_redirect_allowed(const struct sock *sk)
 {
-	return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
+	if (sk_is_tcp(sk))
+		return sk->sk_state != TCP_LISTEN;
+	else
+		return sk->sk_state == TCP_ESTABLISHED;
 }
 
 static bool sock_map_sk_is_suitable(const struct sock *sk)
-- 
2.25.1

