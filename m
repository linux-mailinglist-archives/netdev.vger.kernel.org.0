Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC413BAE87
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhGDTFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhGDTFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:47 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3ACAC061574;
        Sun,  4 Jul 2021 12:03:10 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id m18-20020a9d4c920000b029048b4f23a9bcso4041106otf.9;
        Sun, 04 Jul 2021 12:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=31s+2qFOVsvB9jiiHm6j2fxeI0GOjABu//sl0zrbyyc=;
        b=LDBS2G6WcuqXl4qug4GJn/8YfQdmqY5AhBXx2K81VkA61Ntu5kaRlG72NbfFxtvNJQ
         Dd38JCUt7+N0S0lzRM7bsTLH/mW3kWb73DcWhlDRo6eXVBvrtUCmzinNvXITzf9FWxB1
         qyfxwmFni0pqu1viC2WKN37MnQZqvYO+aBcwrcIqwRDZq2qlPmhY+YUwYAZcjpx5JJr6
         GrIe6HwbQ6jkl7WWS0MmSiaLHg43yv8cGbLdY2TXHzTzdLNxIQ0zkV1whgKexnKQyS+Z
         14EajKubMGTBEnuWKTRWf7D5M/QRqV6AIeaKABwQAPg+nlNaqwnKOzu/QFtVAP3K09sO
         kqiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=31s+2qFOVsvB9jiiHm6j2fxeI0GOjABu//sl0zrbyyc=;
        b=m7tE/uiVTO9vodfjGo3zlIiUBMZx+q0eST+/xr5UYQRspKSdGEdBnrsVUXd7fUO/+6
         i6FbCgktbWhxGaidKwbIpANYj+5aa63IUsdKlLeeLloqlEuAzu5vo7SWM8T0JDib3PXY
         9+0JCBhYQHPCSnje2xvtfkkHNpAx5Om05h8A0+1EPPT9FBQ6UIS7Fm4qyb6PuDjzKIW/
         EH1+cPuwVFs9AdhUdhPVKOi7A+A0aqoBmcLh7UylvpIyQyqxs2gyoAzeZjsh2At3YAkg
         8443voA7WWiCVVHdlTnmyca3ybgdUGUKApSp6fW3/0JDSgo1cUfaZx5WamDPj3omvSfM
         uDTw==
X-Gm-Message-State: AOAM530GpKVvUCsd06snZmzBFRgRimBXH460J+u86FoyDAFkMhleqCUY
        /WprBN3i32uaIY4xuNnRs9BBbkzbyzA=
X-Google-Smtp-Source: ABdhPJy5f1zIFyddgHFMuoERp2qIk8d6rApPH2z3lpSBwFEYF0l3LlfMB6/imiejP2ZKwbCpoaftQA==
X-Received: by 2002:a9d:4104:: with SMTP id o4mr8503179ote.139.1625425390284;
        Sun, 04 Jul 2021 12:03:10 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:09 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v5 04/11] af_unix: set TCP_ESTABLISHED for datagram sockets too
Date:   Sun,  4 Jul 2021 12:02:45 -0700
Message-Id: <20210704190252.11866-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently only unix stream socket sets TCP_ESTABLISHED,
datagram socket can set this too when they connect to its
peer socket. At least __ip4_datagram_connect() does the same.

This will be used to determine whether an AF_UNIX datagram
socket can be redirected to in sockmap.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/unix/af_unix.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 38863468768a..77fb3910e1c3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -494,6 +494,7 @@ static void unix_dgram_disconnected(struct sock *sk, struct sock *other)
 			sk_error_report(other);
 		}
 	}
+	sk->sk_state = other->sk_state = TCP_CLOSE;
 }
 
 static void unix_sock_destructor(struct sock *sk)
@@ -1202,6 +1203,9 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		unix_peer(sk) = other;
 		unix_state_double_unlock(sk, other);
 	}
+
+	if (unix_peer(sk))
+		sk->sk_state = other->sk_state = TCP_ESTABLISHED;
 	return 0;
 
 out_unlock:
@@ -1434,12 +1438,10 @@ static int unix_socketpair(struct socket *socka, struct socket *sockb)
 	init_peercred(ska);
 	init_peercred(skb);
 
-	if (ska->sk_type != SOCK_DGRAM) {
-		ska->sk_state = TCP_ESTABLISHED;
-		skb->sk_state = TCP_ESTABLISHED;
-		socka->state  = SS_CONNECTED;
-		sockb->state  = SS_CONNECTED;
-	}
+	ska->sk_state = TCP_ESTABLISHED;
+	skb->sk_state = TCP_ESTABLISHED;
+	socka->state  = SS_CONNECTED;
+	sockb->state  = SS_CONNECTED;
 	return 0;
 }
 
-- 
2.27.0

