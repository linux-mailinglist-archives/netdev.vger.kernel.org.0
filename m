Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D334B37744A
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhEHWKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhEHWKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:20 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF8EC06138C;
        Sat,  8 May 2021 15:09:18 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id y12so9297393qtx.11;
        Sat, 08 May 2021 15:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uz9J1zJKumDnC+H3DASRwpCq7TM2++iFeyTtmw6XOWA=;
        b=bn+jhPUUWdrTp48FkzBc4xAKA9bwe9NNdvdW+QaqENeOi/yQjzspaQcz07LYAmyh1x
         +K+CGoojiVkflvhKCRTAcDMmWARJpX3NV7f4YH4RIMxa4Jkg6I0pVVpB36rLITbvK8k0
         gugC3nLaOegISPGdaEdcLAKqnLd210HPHyKcltE1+9Hv/miUdgP4Dqh+AT1wi7DMAZML
         6aa3UCYAg9uMpCGUi+IQs57RrC2ykt1WtRtppko24iIm08Ad0Xk09og2zWsBKJwrBYiQ
         PUO0HHdLt50WGwFB/8TVdHVNa2aXxzWkqXPJfVpol5n3aQHkxyNA3M/KLn87oWOHINDl
         SgrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uz9J1zJKumDnC+H3DASRwpCq7TM2++iFeyTtmw6XOWA=;
        b=rIHVSQbNvYqGgMH1UhJPZM465Tj6m26q8CajXTwcIVg7rL5071obLS9LnDfieVOhNF
         TIMhULsI/+xA8sF8vLVcRAiuLr8qxUj966CXqpvs7mR5zIBwVSizmuYc6J2HAlHW+8Hi
         7sJFe66IvXj50UrOnNefGOvjR4RHA4un2sV9797bdeGiR68oQKi5/cFlX3Lf99LYg74v
         DwklKqYCJgCqmLv153k+8fyxrjEwS9nOS0Cxe9OEaDLQFXBoaN5ZHk/1fKrF9v7zo5XL
         /wC5e1AqXq9gfi6ZRBOjKOIxd7Mlez6KnV+3VPs5dCEA9XqqSIpZ+68KZIWer5Tr533A
         urqA==
X-Gm-Message-State: AOAM531mOE+vE7i9Go62EnemdUqzgsbzQADKvTcFGxJkSW2MA5eZDxLQ
        FTdwe/8XWckFRuximwqZV7JuB4uJXgS4jA==
X-Google-Smtp-Source: ABdhPJx7Vp+TcTZXrbhbNyWkMVIzvPKEtLAr68fC0VA/fNA8F4iPepvDTmREGeS0RlLP947rcfTdLA==
X-Received: by 2002:ac8:5bc1:: with SMTP id b1mr15001360qtb.161.1620511757831;
        Sat, 08 May 2021 15:09:17 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:17 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 08/12] sock_map: update sock type checks for AF_UNIX
Date:   Sat,  8 May 2021 15:08:31 -0700
Message-Id: <20210508220835.53801-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Now AF_UNIX datagram supports sockmap and redirection,
we can update the sock type checks for them accordingly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 13b474d89f93..ee9a6dfcf269 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -533,6 +533,12 @@ static bool sk_is_udp(const struct sock *sk)
 	       sk->sk_protocol == IPPROTO_UDP;
 }
 
+static bool sk_is_unix(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_DGRAM &&
+	       sk->sk_family == AF_UNIX;
+}
+
 static bool sock_map_redirect_allowed(const struct sock *sk)
 {
 	if (sk_is_tcp(sk))
@@ -552,6 +558,8 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 		return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
 	else if (sk_is_udp(sk))
 		return sk_hashed(sk);
+	else if (sk_is_unix(sk))
+		return sk->sk_state == TCP_ESTABLISHED;
 
 	return false;
 }
-- 
2.25.1

