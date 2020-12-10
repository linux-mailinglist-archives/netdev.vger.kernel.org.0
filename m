Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7462D6630
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393348AbgLJTQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393341AbgLJTQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:16:57 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EDEC0613D6
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 11:16:17 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id c79so5038541pfc.2
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 11:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zL0EQDZBD8L149j0GQeMbTWPQrBUR3VB9U7TLAvaaL4=;
        b=IXk9dWgN8TgRLVEpZZDaVkbigfdnSoBTDOwVeOgnUTslq0ZidyeVz4mwWd7kkf55/R
         dSeQnjkKfL9nMbRvh3yQ0ezfE5ewkQWtwycYnaPEXwo9+03LtOXn9QeD1S9MA5T2h7Vf
         8quA4Jo6CMVAdApsc7X4uQV1onafNDy63bXTkeGqKV3CBu+jokHeJUGzdNkJjlEac2Co
         +wrbf7Xe0HQI8ZOAUTkW7dOt1b5SAfelHQ7UVSJPd9b5XQ95o8FKd3SV/rAiC94tigdV
         FZJyWXxRcVyl49C6i2AVDvpiwihi7VxEXC8cy/aOXNG5WBgpbWoe5rWriXCQ4PFcVeHP
         SIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zL0EQDZBD8L149j0GQeMbTWPQrBUR3VB9U7TLAvaaL4=;
        b=aqtEMWWKBLr3ZC3tA8AMpYX/xGTfUsn2n0t1C5MVwFFlW8EySJl/bJEjHYRXYm5iHw
         mW+FybnTw31zqvTII3X3Z0RQ35qfheDtZcH25qVCr/AaEO0ebN3JF/RScz7NSgZJIIAz
         YKFYG+9lKsIuGG1c1AShBtwQdpjT/a2rLtd6i48lK2wS1JpnLAri4oGkCIOAuKLFTdF/
         uo2CmYLcctqwzSxEQMa4ijsF6Y5LWMDXcCOdjeeSJDTZU6WPZlyahEEH/Yibn9xALbwq
         Z4HZgLQ8W1sqW858WM6WS6mIz2VQxtd6eUfN8D+0py3NcyGuD3P5hS3xLyhbFYwfH2HJ
         TPqQ==
X-Gm-Message-State: AOAM532xGRs7f9DnkITVPgVO9z4rWYMMB///p2gY/GIoCTK2dwFv+2yJ
        HLcu+Szcm8vSIB+Jb3RukP1d6CRwyMg=
X-Google-Smtp-Source: ABdhPJxEekg6/xd48dduhzbf+Y3MGwCKd4QecorpW1Dm2oFIxKNGN5oFxCJHy5M4PYTEAzYj6ab0Xg==
X-Received: by 2002:a17:90b:78d:: with SMTP id l13mr9222073pjz.51.1607627776917;
        Thu, 10 Dec 2020 11:16:16 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id gw21sm7267062pjb.28.2020.12.10.11.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 11:16:16 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next] tcp: correctly handle increased zerocopy args struct size
Date:   Thu, 10 Dec 2020 11:16:03 -0800
Message-Id: <20201210191603.963856-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

A prior patch increased the size of struct tcp_zerocopy_receive
but did not update do_tcp_getsockopt() handling to properly account
for this.

This patch simply reintroduces content erroneously cut from the
referenced prior patch that handles the new struct size.

Fixes: 18fb76ed5386 ("net-zerocopy: Copy straggler unaligned data for TCP Rx. zerocopy.")
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 net/ipv4/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3c99d48b65d8..ed42d2193c5c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4082,7 +4082,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	}
 #ifdef CONFIG_MMU
 	case TCP_ZEROCOPY_RECEIVE: {
-		struct tcp_zerocopy_receive zc;
+		struct tcp_zerocopy_receive zc = {};
 		int err;
 
 		if (get_user(len, optlen))
@@ -4099,7 +4099,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		lock_sock(sk);
 		err = tcp_zerocopy_receive(sk, &zc);
 		release_sock(sk);
-		if (len == sizeof(zc))
+		if (len >= offsetofend(struct tcp_zerocopy_receive, err))
 			goto zerocopy_rcv_sk_err;
 		switch (len) {
 		case offsetofend(struct tcp_zerocopy_receive, err):
-- 
2.29.2.576.ga3fc446d84-goog

