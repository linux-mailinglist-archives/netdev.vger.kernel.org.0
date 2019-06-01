Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5CC8318F1
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 04:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfFACJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 22:09:07 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:40693 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfFACJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 22:09:06 -0400
Received: by mail-qk1-f202.google.com with SMTP id n5so9533999qkf.7
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 19:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9KgZzYWXetbxJ1ZpCfMaxPqmnNdHH2S3HCSttXXXF7k=;
        b=PxVB7XN3iVjthY15Ey47IQifyxz+siXkPaNDpI7BQVaWFbyE9MWVmkj1J/ysL+R1gp
         oyWxmHOj9bSxYKrCboFXAx7DCPgIWzVnp9DXXjXoJoGl9u/5N7FCUt1aBEq86u/Zsklf
         8N08TaXiEHoCVHK4l8No9r/Ti0XzMEuG4Hp+YbPFnM58+c/4jJwJydj2Yr9niJDXNXd0
         Yknx9eRTRR1uwukIg0rJkCf8dSm4r1TsT3gM7DKyX/U+utUEmr7zo+DqFUZMh7B7kyb0
         mRMbWdmZ2H0cZiMoM0lHf3iQ4a5ASDbkxjPX/RXcGot6JSg/R7KtKqZLOkRVHsqgQCvX
         Nqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9KgZzYWXetbxJ1ZpCfMaxPqmnNdHH2S3HCSttXXXF7k=;
        b=OFp8LiZ8QtWQQD1YhMJXL5A6a471tRMTbM4KTZw91GORcdVdrk4EzxtYSA9rn5cdGI
         8owlPv2f5bDj933dQmgyPB9dg0rma+kxSwR3BbjH59NKCNLYwwl9Naz7i5WXosE1BULq
         9mqRHa2s6cU4+b6oAz7c/Dmc7FqoGciuK7PePYn2szVuW4ClNZmnUmGjRAs7nSs+Pl8F
         rRJ/RrHG/rLnmMVKdBv+QUEJ/Qf6G4yD4l4wjvHauLepTtUj1tOhbBPTmJmGLe5y5Q1b
         t6+GCwpJxHu2Ubg/YbIMlSJrUrEKaZoxOFVuWRKIHrMmW+CBm6m6sPNi3uH0SRIEZ03y
         tK3g==
X-Gm-Message-State: APjAAAW6vjHy7uKd37nXMR8v7bvE1QXH3UPGj2dUZ8ysNY57ZSQNFxAA
        Mwgxxo7KmjYIPwVYRVS73R0tq/2ZAVcfOw==
X-Google-Smtp-Source: APXvYqxGLEy1cLV8x7rcu8//lajCQmeJ5DjD+42CIu88GfZ6AvtJ5UM4UpLjGX2qx25UnhQAXrDN9CiJ1Cddgg==
X-Received: by 2002:aed:3b33:: with SMTP id p48mr5708025qte.143.1559354945808;
 Fri, 31 May 2019 19:09:05 -0700 (PDT)
Date:   Fri, 31 May 2019 19:09:02 -0700
Message-Id: <20190601020902.158016-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next] ipv4: icmp: use this_cpu_read() in icmp_sk()
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

this_cpu_read(*X) is faster than *this_cpu_ptr(X)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/icmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index f3a5893b1e8619716f19f85dc77f2e1e12284b4d..49d6b037b113e85877f8e689e690f1c0d3427386 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -206,7 +206,7 @@ static const struct icmp_control icmp_pointers[NR_ICMP_TYPES+1];
  */
 static struct sock *icmp_sk(struct net *net)
 {
-	return *this_cpu_ptr(net->ipv4.icmp_sk);
+	return this_cpu_read(*net->ipv4.icmp_sk);
 }
 
 /* Called with BH disabled */
-- 
2.22.0.rc1.257.g3120a18244-goog

