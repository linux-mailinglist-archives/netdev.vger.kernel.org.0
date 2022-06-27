Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8714D55DED5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbiF0MKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 08:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiF0MKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 08:10:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88520BE2A
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 05:10:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u131-20020a254789000000b0066c8beed1e2so4775112yba.16
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 05:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Dwpo1nep3UGiZJY5l6NyxfXrUEP7wnxKsudZdsMvFW0=;
        b=SgAQlxMSBojvLkSv9fcuJc3SqmTBwZvjcHaPQUkqinspFgeiAsMXBYX/UMm+lWBKow
         O3xBZE1dK8F+Ou668GDbML16BuDxC00YFiTiXgTnwQ/WVA4LtHNwrlzE7yVHurVXL6QN
         ZWG7U99zs5rjO4Tvwp1MZ+zWxoYR6Ui06Vz8HH2xrkyz58xJ9kDBQxw7vvuC1QI/vDXf
         w8dMXqlikuy+/YBqQk2UFyPIpB6+0eF2/2aoyI/77R+U1nTUsK5ZQ5m1FUBF1KD7h7gg
         BrJDPAG70fQkrxDfGUuiRD6x9yZrWp+3Om2SZjekyrybeJdfTf9Q+eSzgym6hYrcpM1B
         rSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Dwpo1nep3UGiZJY5l6NyxfXrUEP7wnxKsudZdsMvFW0=;
        b=CwccQ84izAZ5n1Y3Tbs2FxJ+fNbb8Qf3M9ML3a/ZYco3rnP4yUml3l36Gy8JCSxNK8
         M9eNjAZWsKg3T172k3vvu4ASbk/rpp6EBPAmCFQOr0bJ/CuRpt+bvm1AKxxWvPoGUOkA
         KZNad7OUk0jLqGJPNBwNMNzZOLf5Ysbs/sjK/M0mYYAxOIdozgrutCoq8Y7xz0GXn1l8
         GLBAxpZ0R6GpbKguO6djfAqNNZKLSdHm4hHqZhuy56GBxAknqWNh1vDk+63lIZf2qXkx
         8a5osXkWn6JQ+3QgwKZJwWzh7hrOW2zAVT5DtlJNc4b1L1Vf6psGUkofnCA9c3PY0gUK
         ODwA==
X-Gm-Message-State: AJIora/A6cFBEznwjIxYL+da0cNon0SltfaAx/7+NaKoK7K0tJaCznjl
        Fw9KDvp/hiwGsyOTpPpWcOzN+JXJbmYFJQ==
X-Google-Smtp-Source: AGRyM1s3fPoFeW8fWGXQKlQyt6CboRrAkMIGmHOlv2bYYlRtKiYp724uf8Mdjy3prOhsyWEdFYGvkP8IMRztxw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:a28d:0:b0:66c:e11a:5152 with SMTP id
 c13-20020a25a28d000000b0066ce11a5152mr3238810ybi.286.1656331839862; Mon, 27
 Jun 2022 05:10:39 -0700 (PDT)
Date:   Mon, 27 Jun 2022 12:10:38 +0000
Message-Id: <20220627121038.226500-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH net-next] tcp: diag: add support for TIME_WAIT sockets to tcp_abort()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, "ss -K -ta ..." does not support TIME_WAIT sockets.

Issue has been raised at least two times in the past [1] [2]
it is time to fix it.

[1] https://lore.kernel.org/netdev/ba65f579-4e69-ae0d-4770-bc6234beb428@gmail.com/
[2] https://lore.kernel.org/netdev/CANn89i+R9RgmD=AQ4vX1Vb_SQAj4c3fi7-ZtQz-inYY4Sq4CMQ@mail.gmail.com/T/

While we are at it, use inet_sk_state_load() while tcp_abort()
does not hold a lock on the socket.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 net/ipv4/tcp.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f7309452bdcec095fd7d923089881f0b99c97df7..d2ca56aa18eb35b314ff02bbece8c3e713fe57bd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4531,16 +4531,24 @@ EXPORT_SYMBOL_GPL(tcp_done);
 
 int tcp_abort(struct sock *sk, int err)
 {
-	if (!sk_fullsock(sk)) {
-		if (sk->sk_state == TCP_NEW_SYN_RECV) {
-			struct request_sock *req = inet_reqsk(sk);
+	int state = inet_sk_state_load(sk);
 
-			local_bh_disable();
-			inet_csk_reqsk_queue_drop(req->rsk_listener, req);
-			local_bh_enable();
-			return 0;
-		}
-		return -EOPNOTSUPP;
+	if (state == TCP_NEW_SYN_RECV) {
+		struct request_sock *req = inet_reqsk(sk);
+
+		local_bh_disable();
+		inet_csk_reqsk_queue_drop(req->rsk_listener, req);
+		local_bh_enable();
+		return 0;
+	}
+	if (state == TCP_TIME_WAIT) {
+		struct inet_timewait_sock *tw = inet_twsk(sk);
+
+		refcount_inc(&tw->tw_refcnt);
+		local_bh_disable();
+		inet_twsk_deschedule_put(tw);
+		local_bh_enable();
+		return 0;
 	}
 
 	/* Don't race with userspace socket closes such as tcp_close. */
-- 
2.37.0.rc0.161.g10f37bed90-goog

