Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A03A2BC6A
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 01:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfE0X5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 19:57:02 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:36089 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfE0X5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 19:57:01 -0400
Received: by mail-pf1-f202.google.com with SMTP id d125so11190005pfd.3
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 16:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a8uTVWU3kiCWi1xOjbjcSefZWusp/CVIpCQFIxtKEcE=;
        b=T6h6U0FOtqnvZ5WmRKR4UV8xFPGtpU5ceaIz3KLQ/dI+JiIV91ZimmTpkxlPqzq0S/
         xfgTmLi4UnGEP8ytqHKFrVoJN7tPUX8/2AAjMxQWhsOKiJtny+V0RYpDxgIYrcjgvqxJ
         ur2xWVZC+YbeFgo8g0LHj4pnkd1xzRzib+IrxHpstOsF507dbbZ/8eagav4Sm9Ixu+EM
         NwcP7ZT80Vfr8EOim+EbyzM6cvTVtTXQe9zJqU435AJ1wXciOJLP/ILgJek5IziMpOdT
         ROup/BVOM0Z3Rw4gDvpdagNW5KDbjKaFsw4PAOyJzEEryf0kuLt/mTli6J6jVTVG08We
         G5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a8uTVWU3kiCWi1xOjbjcSefZWusp/CVIpCQFIxtKEcE=;
        b=WNJ3PQ9BrU570H/0U0mODpnaajr/Irb+B6rj1j+W21sCkDSenUZ1uECKNFdxlUPyBV
         YKI+i5kn9y7qMgj3O4bWkGbHqMd5Isyb6s7XTW2JkTIieAWn9P9n8M7/+/2oDEWtpYB7
         /T31bE07X7SUEUpY7tsqzFffx2ok1b2b7xSAOwpr64zzJYDKfj0oigEQhRoa7egJzHjO
         LD1EtuL2IW/QtHX8xrxixYRfA2pAJf/RZo5Mw6J+JlnmoNDRLTxUsj41WExymuTurDZS
         kEG0joIRp/HUDeXdOUwL8GVHgbjtNsZnfZxOBaedPOnSEFNSK9LnNCjFEcwbPsKnobyb
         guCg==
X-Gm-Message-State: APjAAAXN0aTVHkyh6OGcOC1Z4X2ZyaSYkdLxqFM7+agl6njjb5JQti47
        /mBueNu+f8W7LpdcYNUr5cBCu1XSgebwzw==
X-Google-Smtp-Source: APXvYqyDavPPY4Hd/LzY+tQEB959AF5VLENCb9dh2UtpHSHwxvaPTJ3WHYMHl6btYXMuJLtZQEip1u6ZkkevHA==
X-Received: by 2002:a63:140c:: with SMTP id u12mr22931700pgl.378.1559001420834;
 Mon, 27 May 2019 16:57:00 -0700 (PDT)
Date:   Mon, 27 May 2019 16:56:48 -0700
In-Reply-To: <20190527235649.45274-1-edumazet@google.com>
Message-Id: <20190527235649.45274-3-edumazet@google.com>
Mime-Version: 1.0
References: <20190527235649.45274-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 2/3] inet: frags: call inet_frags_fini() after unregister_pernet_subsys()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both IPv6 and 6lowpan are calling inet_frags_fini() too soon.

inet_frags_fini() is dismantling a kmem_cache, that might be needed
later when unregister_pernet_subsys() eventually has to remove
frags queues from hash tables and free them.

This fixes potential use-after-free, and is a prereq for the following patch.

Fixes: d4ad4d22e7ac ("inet: frags: use kmem_cache for inet_frag_queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ieee802154/6lowpan/reassembly.c | 2 +-
 net/ipv6/reassembly.c               | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index e59c3b7089691ef95ce3b7ce02afe68ffc256dcc..5b56f16ed86b09ac7235ebaf741cc8c434bbef5c 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -540,7 +540,7 @@ int __init lowpan_net_frag_init(void)
 
 void lowpan_net_frag_exit(void)
 {
-	inet_frags_fini(&lowpan_frags);
 	lowpan_frags_sysctl_unregister();
 	unregister_pernet_subsys(&lowpan_frags_ops);
+	inet_frags_fini(&lowpan_frags);
 }
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 836ea964cf140d8b0134894455f18addc069e13e..ff5b6d8de2c6e65f5b2925649c77fad900b1e768 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -583,8 +583,8 @@ int __init ipv6_frag_init(void)
 
 void ipv6_frag_exit(void)
 {
-	inet_frags_fini(&ip6_frags);
 	ip6_frags_sysctl_unregister();
 	unregister_pernet_subsys(&ip6_frags_ops);
 	inet6_del_protocol(&frag_protocol, IPPROTO_FRAGMENT);
+	inet_frags_fini(&ip6_frags);
 }
-- 
2.22.0.rc1.257.g3120a18244-goog

