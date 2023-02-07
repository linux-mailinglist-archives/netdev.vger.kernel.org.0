Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE0A68D80F
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjBGNFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjBGNEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:04:55 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA18D39CEC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:04:45 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id d14so13469012wrr.9
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 05:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=beGgM2LbSkA8IGAfTfFvAxgcywRr6/D7z4MyBTSCBrQ=;
        b=SEx05llstpytJjDvzeR65GSYxlxUj4nkxDXeYbz8g1KVIb0Cb3MBtIJKUJTdBiSGxK
         nqg0ItCQ7Y10GTLXSkh12lZ+pKIWyLIlQv/E46zBlTonmoKx2mWJYGMAuPKguy5a5s38
         ZQHKK6D/KF5JrMs/GPFEYrGMjnpaaPp6NQEz/OFGb7kqUnpJ0ZHyAfb32uxjObStvn6m
         AvLhx1z7UZJVeRMJ6b9cTBP631IM6ofU27EJO1XmaI6VT3fbl57PgjuIwMKP3QGJv9DM
         jgAz++ZmB77D0h97Ncpwa2l56NdiiCnUQE9m07syabj0j+tTI9faAHNa78v1uHl7Odw9
         KWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=beGgM2LbSkA8IGAfTfFvAxgcywRr6/D7z4MyBTSCBrQ=;
        b=zSPNbG4K4xSLq6MwNPJYKFgoWk1AKj+jALEJ2cDOkhjwEKUJnpkLynqVPb3dfODhTf
         UVSxrlw0uA2n1GpuQ6zuImJLOOCP7/uym6Da/pizEvO3W6we47AcnvLoN7iY5OaxoAjM
         kcMOmTv2AzG8X6pF8rcCjN/htj0yLUzFkcCwD9+Qt7tP1PMkXcVG8SSmvZMR6fR5WQrz
         C0zNvrxeh2WU5tcpkIUB+XWhcbLeeaHxUoszNT+WDL1rPRFlu5eSPuzVMx9xEnVRjiWc
         GxJiOjkr/FBvb61W9+Q6SHQHIim9G2c2/9C/Pq9GIVRRFmeOy5BDh3fHBGXl+Gvfv+cr
         gjlw==
X-Gm-Message-State: AO0yUKXHsPmSF4/nBLJZ5TnX0TdfF+ONwv8lb06gTTf+IzwwKK0vcWiF
        eT3khDB+VjKYwih8/sFHGavFuPKFmuUxalRigYA=
X-Google-Smtp-Source: AK7set8BACEuCqBdlUhOpzEs9iSk0+Ev3Cz0G1FqEtiOnCLMzuI5nG6VfPyZbe/GjrTiJIW17+B1OQ==
X-Received: by 2002:a5d:6046:0:b0:2be:5ca0:a7f9 with SMTP id j6-20020a5d6046000000b002be5ca0a7f9mr2642129wrt.33.1675775083981;
        Tue, 07 Feb 2023 05:04:43 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d5989000000b002bc7fcf08ddsm11645394wri.103.2023.02.07.05.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:04:43 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 07 Feb 2023 14:04:14 +0100
Subject: [PATCH net 2/6] mptcp: fix locking for setsockopt corner-case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230207-upstream-net-20230207-various-fix-6-2-v1-2-2031b495c7cc@tessares.net>
References: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
In-Reply-To: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1507;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=tU92Z5FtU+rxP2x5Q9J2r5aQ+mvHt8iWMbRSULE+GL8=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj4kxo3Fz3M6U+ZqFEqliFhKp6GfvWCWFMRgKtp
 KfknMVgtAiJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY+JMaAAKCRD2t4JPQmmg
 c7XfD/43VLBXwdb+RbXPVii16WQ7mY2RSpjNlzgqZ3sBZup/f8WZGkVzNABwdXWm9QMzPNHwEnU
 kBeYf+UtjhvF+f3lkdU0PZ756cNxJQkbS7VxrzFt5dpy9doA/i8xTeV7TNLnA5NaVR6BGSbXit6
 UZzXqoPZRWErMWFN3jcTkiKsbGX2Z+CUSRdo0jh8YLXpZtLt3Slxi5x4Xr3xNv6cFKpUCzDGEAX
 vPi8JFtfMzVzfQx3R1PK2kGGXE7qmzVJZVrQNwRba7s32pGuYOn4w1quZ9oALgBbNWw1YtxH+5y
 ZK8JwgaGyxrVOyrREUKORoLrTVkzc8oDze9MGSxQ+Fynn2k+uy9PcEK5blZwGWIRP/ChPU8XZ2P
 jANo1DCq5XrEqkTP2Qo3b3kwmoFggzZO5H6M9VBCWgjpl+OOF/zYTVZ+bi3RiD1yUWSlKDV4F27
 mtE3FPGWfLBedr2gZnIBxjWDZBvaTQL51YgyuPKYMKW8y8lxu+LDG1ExexmXgoqLefI/63OeMdz
 kRa9NAD2ineJZd5cChSQRpvDIlTcHKyDVUMciS14uuZwA76y37D5NgG8F37JBHZx+HUrymsYqDj
 NCXByJtLbR0eu8vqlsd7DOGznFk5E8C8sRiVAcGnqjuObFdNHmv7kekqWhcoHGW30OFm78J9Scz
 CJvs9L9o6bHugmA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

We need to call the __mptcp_nmpc_socket(), and later subflow socket
access under the msk socket lock, or e.g. a racing connect() could
change the socket status under the hood, with unexpected results.

Fixes: 54635bd04701 ("mptcp: add TCP_FASTOPEN_CONNECT socket option")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/sockopt.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index d4b1e6ec1b36..7f2c3727ab23 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -760,14 +760,21 @@ static int mptcp_setsockopt_v4(struct mptcp_sock *msk, int optname,
 static int mptcp_setsockopt_first_sf_only(struct mptcp_sock *msk, int level, int optname,
 					  sockptr_t optval, unsigned int optlen)
 {
+	struct sock *sk = (struct sock *)msk;
 	struct socket *sock;
+	int ret = -EINVAL;
 
 	/* Limit to first subflow, before the connection establishment */
+	lock_sock(sk);
 	sock = __mptcp_nmpc_socket(msk);
 	if (!sock)
-		return -EINVAL;
+		goto unlock;
 
-	return tcp_setsockopt(sock->sk, level, optname, optval, optlen);
+	ret = tcp_setsockopt(sock->sk, level, optname, optval, optlen);
+
+unlock:
+	release_sock(sk);
+	return ret;
 }
 
 static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,

-- 
2.38.1

