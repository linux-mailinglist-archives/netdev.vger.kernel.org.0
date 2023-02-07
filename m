Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D9368D7F6
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjBGNE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjBGNEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:04:53 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B0A39B8F
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:04:44 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id m14so13447284wrg.13
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 05:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YigoELKCrpUqlWaz+JzApl9ulOjOQ+EyFOAYydAJKAc=;
        b=IfVVHcp3uqHqEHMUodirLKV+dXsscALBdeOGPQbKFW6YuAquAX6NESuO3GSahqcYWv
         7KmTfF2qeaeD1eWvN8U5ylBM5V7qbox8mQN+p8wWvBj5u8hNLVx+iYK0pFmKU9UtOdnT
         ujhNpsLiblDQ7eNJX1K6CFUipZw0/Is5c2yIBVfx1ieQmiA1aSlFw/yvbFY4AdA3wj9c
         A4JiPQ7A9gl4wEt84KqtAVLIQfnoYLa/SwbSpJDEGodQsmXA2h1cfGDYUwTgDkvQnd+B
         pNySZheaW08JAdpKf2EJKXwkDFdKAlwsmklctaEJmXtffXFoocF/b10vpsJf8lvp+e+Y
         uHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YigoELKCrpUqlWaz+JzApl9ulOjOQ+EyFOAYydAJKAc=;
        b=zEgtjd6E6MGXu8np8TO23P/G54UWNovDMUhtpLNndomyq70y11UnsmYv5M0YrRaCfu
         i5f7rl+li+gskutsbbNVhBC6pS4n4UrptPEXqSOh2x48mj/ZlE/9DNhGyxkW4qMMRQ95
         IjFSBzVRPO3cZtTlgOsQDfPao4tAageaH3Ojf9nHgs73fpw+qdV30fNucukFheMUvXNh
         JAkTGp+3jwBXmKdyrMB/ws1VisDxi862lLJUTNiIFlktONzUAWmAIqScuPtmRDXLzxaj
         SD453kMqAgKgrydcyZSnHZNRjrTwJesh0TplVT4eEQiZYW7H8OC4H6oRPSK3rnZHKRlw
         kwHA==
X-Gm-Message-State: AO0yUKURtC+As4QYbtQaUmhWFdomyDRfEnykB7WUzWFZLF3Q5vKylCPl
        0xphXC77Z4zAoKIBW9IpDFkBweZ941iSYW50pJ4=
X-Google-Smtp-Source: AK7set9MJrNmL54fvgoCvb2c3yURh10pY5u360N8noAgikphDF+SSpzSDOjfORofL68VUEULOFAIvg==
X-Received: by 2002:a5d:6791:0:b0:2c3:f00c:ebaa with SMTP id v17-20020a5d6791000000b002c3f00cebaamr2686389wru.4.1675775082895;
        Tue, 07 Feb 2023 05:04:42 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d5989000000b002bc7fcf08ddsm11645394wri.103.2023.02.07.05.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:04:42 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 07 Feb 2023 14:04:13 +0100
Subject: [PATCH net 1/6] mptcp: do not wait for bare sockets' timeout
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230207-upstream-net-20230207-various-fix-6-2-v1-1-2031b495c7cc@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1997;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=BKFYEPn2x47UTnz/1wV7jxosBMkqNJMuzJVlkB5njrY=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj4kxo9wElir7BZ5w/IUv9IpIMUHyT6BLACenEJ
 tIVcWuEAdCJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY+JMaAAKCRD2t4JPQmmg
 c994EADn03+OGgtrXU/XxOfxmNW5na0cI1MzmQxrlE78RGt7nyu9UXNYGaVzdzR+9wxLK9nFW61
 pE4fpwus/sVZlWfwwGavQyzGrq1n5ij7Qp2oE36H5dQ6Nfm6yAfE+02CovR0thRQxR2eHaneBt1
 W9U1YDIwqj3X/g3auJ8FIVlj+Ucb2FItNBO7VEu3hcwWU+LQ/kvJG6tR+OzLLVqZPQCcMrt8mTb
 N9bpDWHWKmXQa0GLqz9Mdo4W/tmvZcr0htX/2TqhqWMgjQcJxJpdkpH9xyEY2fcuKiAcO4oZOxI
 u5/YMJ418AMs+T2JPghbb7/rULAEZWPcLaL1sA/oCV2zJnCNzepVvPaQVI8zSVwdON0p0xBWAoO
 vktbXiiyHyQCZyWIkhxmIFUpisvNOnqRnSCAvzvwrI732ONKUTEvxOb9uM1b4mFwvXGaAPbHTB/
 nEXpoPCXJgGeoSRVsaRc4Wf1nEyGxnPWS9H+2CUayoajODACyHcMcVrCwcilimCCF5UaUPW1Gex
 /fER7ayaSNmN0qwQyPwDvbtEZOTTwvF3iBa73l2IPRRK25qwyDMQFZOr6e5u4irG5SRQlrPSof2
 JLT8IztvKWh9+84olpjQ7HNn1g6gSTPRj9G0S60GFvcWLNdjZS8F6bB9UN6BLZOVniEzXVaNttT
 QM28cN8cFKZdsvw==
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

If the peer closes all the existing subflows for a given
mptcp socket and later the application closes it, the current
implementation let it survive until the timewait timeout expires.

While the above is allowed by the protocol specification it
consumes resources for almost no reason and additionally
causes sporadic self-tests failures.

Let's move the mptcp socket to the TCP_CLOSE state when there are
no alive subflows at close time, so that the allocated resources
will be freed immediately.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8cd6cc67c2c5..bc6c1f62a690 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2897,6 +2897,7 @@ bool __mptcp_close(struct sock *sk, long timeout)
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool do_cancel_work = false;
+	int subflows_alive = 0;
 
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
@@ -2922,6 +2923,8 @@ bool __mptcp_close(struct sock *sk, long timeout)
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow = lock_sock_fast_nested(ssk);
 
+		subflows_alive += ssk->sk_state != TCP_CLOSE;
+
 		/* since the close timeout takes precedence on the fail one,
 		 * cancel the latter
 		 */
@@ -2937,6 +2940,12 @@ bool __mptcp_close(struct sock *sk, long timeout)
 	}
 	sock_orphan(sk);
 
+	/* all the subflows are closed, only timeout can change the msk
+	 * state, let's not keep resources busy for no reasons
+	 */
+	if (subflows_alive == 0)
+		inet_sk_state_store(sk, TCP_CLOSE);
+
 	sock_hold(sk);
 	pr_debug("msk=%p state=%d", sk, sk->sk_state);
 	if (msk->token)

-- 
2.38.1

