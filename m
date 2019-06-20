Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC9D4D0F5
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 16:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732049AbfFTOxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 10:53:00 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46986 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfFTOw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 10:52:58 -0400
Received: by mail-qk1-f193.google.com with SMTP id x18so2055817qkn.13
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 07:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=5oMdsQsw1n7pkd5dZK0BAR68goU9Cphs7Z7vjhmXNXA=;
        b=if6+rXaoBnz+H02oYwem3HWXB48VPwWoSvmotiKQcqueZkz88R/UOJrQJGPnqSxWh0
         X3WWxz+KMriBFBvZG0/EZYb9KDDdGilbulSCa5O193BQx6OEd9S4APxsT3UV78tLkx6n
         9WXhfxiDzSEcl6WRrOWKy533PY7TkmIDzQcBW47lcU6tBxY6A/Leti2v2Qxk0TsMDGA6
         1hqoNBZw/ZyMe154WWMQCmMz6g4Lj58hgSdmjM6+cwvRNW3fbMoFd6qdZ0iPJMu4of9V
         y7ZbI0HRLfHcm8QOkYoc0KpKXqUbujLWeiBtQ02Z71c6zN+vOkispdwvmTBl0TJGOVHZ
         H8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5oMdsQsw1n7pkd5dZK0BAR68goU9Cphs7Z7vjhmXNXA=;
        b=pOSsilWEKrNPorhhynqXEGR7evyKUuWeih3Nt4XbbbvrKdDWYfv8ZFhKbQQnYO/Gi8
         iWalrc2uoH+HKZs6rB/pd/tmwDoREfxzn95H9wTmpPQZMJ9jSbJSAltlDBRIlttsmAhg
         p689VjREL++LJkU5zBCjv0srKvEZgoHll5OUKH2U1ktlFFP3Bc9u0sZ+p5izQnBx9rd+
         hCK1YGtRxCo33o+UJM9hGW7hTD36lyhbxXw8gtcGDwbj0YLXrvElEXGQgij9bAVZEDwq
         uhN/KkR0OP8AO3uRJFtbWQOUgKQGNOnnRJyLjdq1SkvnaRQRM8LOpJoiMy8kF1kItcIs
         adkw==
X-Gm-Message-State: APjAAAUO46uiXRZdnA3kTJANVGC1jZNXq/z5DN9/uCCAMZt8EvWzjmcX
        wI99X2oxXF6GXPeRBbc8++4yXQ==
X-Google-Smtp-Source: APXvYqyLJk0+3HOrUCnuJqkk0jfG4hnZ4d747OQBhmE1HQEm9E2OZkcZvXeiDoYq6X0FOJ8JYq4oTw==
X-Received: by 2002:ae9:eb96:: with SMTP id b144mr25466663qkg.321.1561042377583;
        Thu, 20 Jun 2019 07:52:57 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f9sm10553867qtl.75.2019.06.20.07.52.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 07:52:57 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH -next] inet: fix compilation warnings in fqdir_pre_exit()
Date:   Thu, 20 Jun 2019 10:52:40 -0400
Message-Id: <1561042360-20480-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The linux-next commit "inet: fix various use-after-free in defrags
units" [1] introduced compilation warnings,

./include/net/inet_frag.h:117:1: warning: 'inline' is not at beginning
of declaration [-Wold-style-declaration]
 static void inline fqdir_pre_exit(struct fqdir *fqdir)
 ^~~~~~
In file included from ./include/net/netns/ipv4.h:10,
                 from ./include/net/net_namespace.h:20,
                 from ./include/linux/netdevice.h:38,
                 from ./include/linux/icmpv6.h:13,
                 from ./include/linux/ipv6.h:86,
                 from ./include/net/ipv6.h:12,
                 from ./include/rdma/ib_verbs.h:51,
                 from ./include/linux/mlx5/device.h:37,
                 from ./include/linux/mlx5/driver.h:51,
                 from
drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:37:

[1] https://lore.kernel.org/netdev/20190618180900.88939-3-edumazet@google.com/

Signed-off-by: Qian Cai <cai@lca.pw>
---
 include/net/inet_frag.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 46574d996f1d..010f26b31c89 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -114,7 +114,7 @@ struct inet_frags {
 
 int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net);
 
-static void inline fqdir_pre_exit(struct fqdir *fqdir)
+static inline void fqdir_pre_exit(struct fqdir *fqdir)
 {
 	fqdir->high_thresh = 0; /* prevent creation of new frags */
 	fqdir->dead = true;
-- 
1.8.3.1

