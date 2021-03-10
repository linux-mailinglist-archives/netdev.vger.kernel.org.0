Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD3D33355B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhCJFd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhCJFdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 00:33:03 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167E3C0613D9;
        Tue,  9 Mar 2021 21:32:47 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id a14so207758qvj.7;
        Tue, 09 Mar 2021 21:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LEg3npv0kkNxuAwGAdkyF3a2ih0UPGgcksP1uJl2DHk=;
        b=ky5HOPgg64POSkmeu+ucHhFbqZWHKCsWP2qeLLOP0fxuZGZVcAYSiX1yFK6ujztNd9
         n+Gf1lm7+rI3JZTDmxU4IlN9TDCcnJ2PdFWPOvuFH0M3oS9Ws4hM66u9XoL9b2ztpNug
         8OInkvaf72g9khID2j2aYQMOzEov5RXUf/8TbQ0nx58ajheEDHCbPI5JfXCSsL7iGgNH
         IKpTM9lHAbn2W0qbOuoAmXh9hvXMOKMMWUXMAAPg6Gv94Tz2XzymGoQEekJljHluJfE/
         GRP9OdLZo0CyP3j7+i8k1fTwRASSsrjiI2GDn4l0ug69duRDA2mh9YqB94hFsA/E/EQL
         eR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LEg3npv0kkNxuAwGAdkyF3a2ih0UPGgcksP1uJl2DHk=;
        b=rmGybaWl6MG4thEeaKgjS6ypuG76IsCmuEPZIUbOx00VcYBbriXNL3eQitQbcBJjG2
         QWJ8OsA0ZePGpSIbyHkb5y+6HEaAnwjOBepwFvCwHibLpBKSyiqDONkr719pMI3Kuwmi
         Xtsn0Wc1wjPDjdGfrJnEKAGpg6Jbnx+QeGpXMy5negirZPj6eCTs7f3b7h+ipJClTWpv
         eS3pG9Q4CvJGVrnAE7EWZMeXXgjOZn+YP+N7u0b2u4C5yM/b459YsXL+iQk0TLHNUUpd
         jef/RTEFd9zMuq9mfwzX84MAvnV2DrzMElNQPTrgsoWjoO7EZUvPGaKCunfnLVCH6d3L
         fVGA==
X-Gm-Message-State: AOAM533mp9yeqm+8HKObGLB6eshTQVNEaTmbPnVM0eu+cX4VIKdHdzoO
        YakWU2haEWbC/WIa/mw5mMXgyc6NUu+eGQ==
X-Google-Smtp-Source: ABdhPJz0P6JFb6m9hbhQ6P2spc/IDy5u2Ol4nZEic2XDmJABrfnEPwvGEx0Uc26eAt7GL7VD6xi/Nw==
X-Received: by 2002:a05:6214:1454:: with SMTP id b20mr1294910qvy.24.1615354366772;
        Tue, 09 Mar 2021 21:32:46 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:91f3:e7ef:7f61:a131])
        by smtp.gmail.com with ESMTPSA id g21sm12118739qkk.72.2021.03.09.21.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 21:32:46 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 10/11] sock_map: update sock type checks for UDP
Date:   Tue,  9 Mar 2021 21:32:21 -0800
Message-Id: <20210310053222.41371-11-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
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
index 82e33622a020..69293495c4a9 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -549,7 +549,10 @@ static bool sk_is_udp(const struct sock *sk)
 
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

