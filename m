Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC98B31730
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfEaW1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:27:05 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:46068 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfEaW1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 18:27:05 -0400
Received: by mail-qk1-f201.google.com with SMTP id u129so9154425qkd.12
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 15:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=q966+WsM0aWKcMLMoESqg9HP4rfdJz0al/h98xW2Jkw=;
        b=f38RwaIge8wWaGhhSZPEjEYpisJ+qsel6GfpH8SJHQhdPAFL5NJLxg3HO2dYijUYlH
         poYpEmxrxlOexNrJ57LMMP+wbk3lsilbSvCgC8+yr0BCUZU7EdCyXIi0t8FUhwVq9OLO
         Mwch8npshmXYEZw60R+7LOXsURToMVofxS19zt1YAhMn3Oth2F+q8YXFn3/eq8/Vy8jB
         kjJj2gpXGVx7xW9Ws77HrCZ3f82/JTqME56WosJfOEGisAwKAsTVrfmK2E+IY16FWU2f
         n0/xd0MScn08GdSfnGt5IYGPIGnuvPwlG5Eh8+k1h/x0uUJtVx/A3mwnKisUVWnUCXlR
         yIqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=q966+WsM0aWKcMLMoESqg9HP4rfdJz0al/h98xW2Jkw=;
        b=osF56GUPOsg3EbPHBSANBwpJuMAfNypnhomG//HQSBfZYGM6dmgwLt7vB8YZFIl2Gq
         DfKhLZGPdODeFdfZ0D8jiqysFOg++dkFI4fPdKCfl9NUZOotKBJLc9c+rgNJ2+lGskbc
         R90At8CZ90I3sslD6CNj6Mef5RIGNXw7zOeDzvTz82ZX8MKpza4CXd3lWNl1cvBHOn9R
         L8kqasC7tia3cr1yleXVNpfnliWILHfKef0KQSxLL4SKuyrlDHHO4divYGZLqsxy7zKv
         vJojK+QYfCcEg+hEw7IPhxKFk2WH4BI11pxe0yVi55N9T5a4cS3nseX9KjEa0h75pjb0
         7VOQ==
X-Gm-Message-State: APjAAAUeGnk+HEMCRUL76mlYs0p7j8JoOJoFe7OK3ZW0JtRI+ctAt7/W
        mydKlqV2VZH7A6BMmKvqydYquRw+3Sxpzw==
X-Google-Smtp-Source: APXvYqwi3axQ7/78LaRzHmShU/ev46Btq0RC9Kx6orEtrpxDO1phsqnpop2ojHF7/8FjtJ0j57zfsXhEnxoFow==
X-Received: by 2002:a05:620a:16c1:: with SMTP id a1mr10768037qkn.269.1559341624121;
 Fri, 31 May 2019 15:27:04 -0700 (PDT)
Date:   Fri, 31 May 2019 15:27:00 -0700
Message-Id: <20190531222700.252607-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next] ipv6: icmp: use this_cpu_read() in icmpv6_sk()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In general, this_cpu_read(*X) is faster than *this_cpu_ptr(X)

Also remove the inline attibute, totally useless.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 net/ipv6/icmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index afb915807cd0109e02df6e0858319c0ff78c33e8..d274f5b64afe0c5325d6f14c33842b7da61653e8 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -79,9 +79,9 @@
  *
  *	On SMP we have one ICMP socket per-cpu.
  */
-static inline struct sock *icmpv6_sk(struct net *net)
+static struct sock *icmpv6_sk(struct net *net)
 {
-	return *this_cpu_ptr(net->ipv6.icmp_sk);
+	return this_cpu_read(*net->ipv6.icmp_sk);
 }
 
 static int icmpv6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
-- 
2.22.0.rc1.257.g3120a18244-goog

