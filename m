Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3FD717DE53
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 12:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgCILNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 07:13:20 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50621 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgCILNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 07:13:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id a5so9391988wmb.0
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 04:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VhnNh0FQpU0IXnemYuyXF82fe/AvYFMA5w4Rk3Zgjg8=;
        b=OPuFONLR+flmNj8q3OtmclC70Xv8ZSwnJ2b3unDxiP/H22qOrNB0U8O9evExpS2Pvh
         aANMarFYBxasC60dzb2/yI3+GoWDeoshz7mgTXsYd9GrRYkLoFPeUABNInnZ49oxNSrj
         Jd0ozRGwe7VkvtE/yTFobFyc9k1B4iEgb52uU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VhnNh0FQpU0IXnemYuyXF82fe/AvYFMA5w4Rk3Zgjg8=;
        b=Ptta3RgzTJyQQJOIZTkGLjuLbkSA7GYpkfqg9Nh2qPHDLPHribdG7VOnOKP3sWX8rR
         AUdk7Ke4PUtyz70WIC5O+wNBNney5EYUHte4Y/uUS2mO43mae3gUz0uRiNWtvTN9C45V
         NewfnBYmTUjAg2VN2Lv6W9ohTnPf78Q3kuFZCqscVWy6VFwABUEY33/JDEpd0AHgYPG5
         EBjJnATSfLPtlVuphEVGYbcl0HhHmWXW1cz4UTdBaIajnb+CUS02dgNXhp/3eJOOi2Dv
         yutZ3uosdafC1uUpW4Ze0HnPB0XCCqHJwO+h5o4pAXXdkaKPLgu/psXIpmHvEqgKogM6
         McmQ==
X-Gm-Message-State: ANhLgQ3IyoCx7PJxQoSGvVVSzJ/aKWhZtwzpm1J+P7LdZORN7nd93cMP
        7csgDybFQA23Ffg6vp4ZPPskfQ==
X-Google-Smtp-Source: ADFU+vvw76jpjuBquu29c/ImGlyugCxB+gF1RrtRq0128jT1ZEa3yp+jKznj7UEb3KCDKavSApSTJw==
X-Received: by 2002:a1c:2b44:: with SMTP id r65mr19143120wmr.72.1583752395887;
        Mon, 09 Mar 2020 04:13:15 -0700 (PDT)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:3dcc:c1d:7f05:4873])
        by smtp.gmail.com with ESMTPSA id a5sm25732846wmb.37.2020.03.09.04.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 04:13:15 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 04/12] bpf: tcp: guard declarations with CONFIG_NET_SOCK_MSG
Date:   Mon,  9 Mar 2020 11:12:35 +0000
Message-Id: <20200309111243.6982-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200309111243.6982-1-lmb@cloudflare.com>
References: <20200309111243.6982-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_bpf.c is only included in the build if CONFIG_NET_SOCK_MSG is
selected. The declaration should therefore be guarded as such.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/tcp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ccf39d80b695..ad3abeaa703e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2195,6 +2195,7 @@ void tcp_update_ulp(struct sock *sk, struct proto *p,
 struct sk_msg;
 struct sk_psock;
 
+#ifdef CONFIG_NET_SOCK_MSG
 int tcp_bpf_init(struct sock *sk);
 int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
 			  int flags);
@@ -2202,13 +2203,12 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		    int nonblock, int flags, int *addr_len);
 int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		      struct msghdr *msg, int len, int flags);
-#ifdef CONFIG_NET_SOCK_MSG
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 #else
 static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 {
 }
-#endif
+#endif /* CONFIG_NET_SOCK_MSG */
 
 /* Call BPF_SOCK_OPS program that returns an int. If the return value
  * is < 0, then the BPF op failed (for example if the loaded BPF
-- 
2.20.1

