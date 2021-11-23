Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BB445AF1F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 23:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhKWWfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 17:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhKWWfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 17:35:12 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B711C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:32:03 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id s137so356456pgs.5
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XcBOjpj5WIC/erbsuKGbK6VTsc2A8dTqk6SNtxw9Bk8=;
        b=VZ9TKchp1OO2GazlBKUfNUoF+2j/qKYlearoF3uNrs9Lkl1/vO2TbJuzdoUxY8bbV2
         gRJj/LOaO/fGms1BHymieOlamwV2bKSCoyMuqCk7BlN+ZA5L8hLillSku02XPD/7x/Ip
         i4P86IyBLF1fxADhLLu93oWq+9HxT7DC5zDNLJJa0LQ6kANihl0q3uOV3HEs2ZmdCDSl
         k8663lCNP0ccSRQXi73+NjqtuQV2dCEwzOa1TIsqzziH4D8iZO7OPmCZRi9oS650jiHE
         Rj/PhPLNj725JryU4uL4ixyb8yoniuEedKrZXplQvpM47HaV/YPbCccZV1HctFdea7J7
         1Lwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XcBOjpj5WIC/erbsuKGbK6VTsc2A8dTqk6SNtxw9Bk8=;
        b=MoXNHNG72tnisNe4BRQiop0ljrRwiLyTM0H/LbN7DSFNdiDVG2FGIuv6BCB7QhM29o
         mPUkqoILcR21NVNnqkGjn20Z4FJ712F+u6NPfK++tmuxQZOiIRoer3vWkSwkloOxU1mn
         vAdqTslE0sphZYi6kvePIjIlZUIYGHXUgZZXTxCJK5GXbuKR5bva3LUeKcr04qzlZdrx
         /m+Bq4i0wU7KXpq6onGI36b7p/XNsax5MDTbDoYEA+0yREwdpStcDdI0BhnbezXHUGeM
         yT5elFbcsqNnOI38WOoqjgvqXoOZaKU4awZydCthPnmm4mBG35X7Fx1sF86439O8wTzi
         v25g==
X-Gm-Message-State: AOAM531hluzXPLYwiC6qDq4J7I3mjTJlx6emZYZPO4hbjjukCUBf51Ar
        S4yei2PAQ0e3qfsEcAos66Mc3BikQj4FFA==
X-Google-Smtp-Source: ABdhPJynExqkxKfXCViuViOx58L/sEnqFHceOAEHv4w3h/6+SzLzPlq+y0BEDnikL0vqYizGjXZS9Q==
X-Received: by 2002:a63:374c:: with SMTP id g12mr6425723pgn.35.1637706723097;
        Tue, 23 Nov 2021 14:32:03 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:cd70:5ac2:9066:1bb8])
        by smtp.gmail.com with ESMTPSA id oa2sm2281338pjb.53.2021.11.23.14.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 14:32:02 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH] net-ipv6: do not allow IPV6_TCLASS to muck with tcp's ECN
Date:   Tue, 23 Nov 2021 14:31:54 -0800
Message-Id: <20211123223154.1117794-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This is to match ipv4 behaviour, see __ip_sock_set_tos()
implementation at ipv4/ip_sockglue.c:579

void __ip_sock_set_tos(struct sock *sk, int val)
{
  if (sk->sk_type == SOCK_STREAM) {
    val &= ~INET_ECN_MASK;
    val |= inet_sk(sk)->tos & INET_ECN_MASK;
  }
  if (inet_sk(sk)->tos != val) {
    inet_sk(sk)->tos = val;
    sk->sk_priority = rt_tos2priority(val);
    sk_dst_reset(sk);
  }
}

Cc: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/ipv6/ipv6_sockglue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 41efca817db4..204b0b4d10c8 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -599,6 +599,10 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		/* RFC 3542, 6.5: default traffic class of 0x0 */
 		if (val == -1)
 			val = 0;
+		if (sk->sk_type == SOCK_STREAM) {
+			val &= ~INET_ECN_MASK;
+			val |= np->tclass & INET_ECN_MASK;
+		}
 		np->tclass = val;
 		retv = 0;
 		break;
-- 
2.34.0.rc2.393.gf8c9666880-goog

