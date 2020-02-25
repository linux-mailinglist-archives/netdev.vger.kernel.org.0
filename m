Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C1016B968
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 07:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgBYGGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 01:06:25 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50480 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgBYGGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 01:06:25 -0500
Received: by mail-pj1-f66.google.com with SMTP id r67so794773pjb.0
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 22:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NL+8QKcJIo9UjBfd77xLS5pLZL6WsmvH9RUdBt70aro=;
        b=nbX9S2G/Q+e5Mkiqv0RyvMX545B8rseKqiX9RmmWnsKFUHy4uKTyiYGVR04BWIGMGn
         ANz3Jv3/jZ8nlZHGOFOVJZTcm7efE+hQbIT+Phx4CeDWX8+TvbVTYgLC5KPQHZHDsdko
         HZY3Ds74HulEYwaavIfbL0+MybZ5WXElnkcgMjSqO5ZV33eci3E+koI78uWKjFn1Zpok
         WVBBf03Ua7PfZ+/OznguF6CECcKQDdta8Lq/52159hA4D8TVOVkUhtv4vjOMQYQ51DMk
         GNqvfkic9kibKeQikWGFPIGkU/AshDnmxa610dPzGsPpNbj/Sb3sMC8SUapAeYR0rLl3
         ktxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NL+8QKcJIo9UjBfd77xLS5pLZL6WsmvH9RUdBt70aro=;
        b=Y0TLLaV52xnJoJvCr1a24TqYDV54Doms8uufLnMHsOOyBbnJtr9XqTgDlNs3NzYabV
         HJorDqu6lb8XaZSuVSMiuI5uYnQd4PZplIhCHj1R5qZI8VOKJgKpXi/yKLDbko0A4w8b
         JM+Pno3eRtOutFyp4dFrjkUYW62EqAdicB1CX2PCpWz+Xg3p48803BkWNoSy0UbjS757
         rEYgEVAC7UflUl4ArEIzztzWOVnfzWiZmchLS8duVZ6B/95xxNWHVTSUX5Y+gHWwvEHJ
         fanA/d0crqCw4QR9+ki7oedJEmBH9HtPD1kZeitpeE2/yUGGySjdwv8yJ3SUiyVsbzPk
         O3Ng==
X-Gm-Message-State: APjAAAVeQRSD3GX5ZL/ux1B1ODnlmi02hYB0g+DQwIsnK3LTEuZAM9aC
        NbRF3Jo8ZqKz5G6BAZ+wJmw=
X-Google-Smtp-Source: APXvYqwo68ka3H5KHHir1p7/XcV8T+ufeMVKJt56gf9Yu3OmpQNTLdIXDyY4PlgwE5CBckLy2G7w6Q==
X-Received: by 2002:a17:902:bb93:: with SMTP id m19mr55053436pls.310.1582610784494;
        Mon, 24 Feb 2020 22:06:24 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id s7sm1529990pjk.22.2020.02.24.22.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 22:06:23 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, soheil@google.com, edumazet@google.com,
        willemb@google.com
Subject: [PATCH net-next] tcp-zerocopy: Update returned getsockopt() optlen.
Date:   Mon, 24 Feb 2020 22:06:20 -0800
Message-Id: <20200225060620.76486-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

TCP receive zerocopy currently does not update the returned optlen for
getsockopt(). Thus, userspace cannot properly determine if all the
fields are set in the passed-in struct. This patch sets the optlen
before return, in keeping with the expected operation of getsockopt().

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive
zerocopy.")


---
 net/ipv4/tcp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 600deb39f17de..fb9894d3d30e9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4148,8 +4148,12 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 zerocopy_rcv_inq:
 		zc.inq = tcp_inq_hint(sk);
 zerocopy_rcv_out:
-		if (!err && copy_to_user(optval, &zc, len))
-			err = -EFAULT;
+		if (!err) {
+			if (put_user(len, optlen))
+				return -EFAULT;
+			if (copy_to_user(optval, &zc, len))
+				return -EFAULT;
+		}
 		return err;
 	}
 #endif
-- 
2.25.0.265.gbab2e86ba0-goog

