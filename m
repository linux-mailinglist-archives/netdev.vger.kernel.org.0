Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6E455ED3B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiF1TBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234310AbiF1TA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:26 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4909765B;
        Tue, 28 Jun 2022 12:00:08 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id c65so18908157edf.4;
        Tue, 28 Jun 2022 12:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h75qpnVIOBkauWn8J3X7YKBCKHImJX+zNFdRExDFoHs=;
        b=ka2eRn+/WtfG/myqqKawD5QFwCJoWSJfeOfoyHs9WGQ9SjgwYtf0+PwDijc4+N1dkz
         Q1NwVa20WM3fviOcG+qYQJrKRMQxwr9KhmIkYFx2N781FhGFxty8pZOoS3ejCzZwjKTN
         2PbuXgi6IWlkcnDpnOEnC7e4ht28Lw8EIzQEgJvm0JD3zDifZXyqiXoieZe/QVJgaNEQ
         OZ4T2iho8CICMri7n1/7puniFnDSm9Arqdpgb6IkpHZghK+A0jZCPvPHGnmW1afTfcSW
         0YgAu5fcYjuo9A0ESuYN9qHxZSxl0gt/M6mCCRso/Fc6hQ7uj/prEPz7NhIfyqYB2Gc6
         Z+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h75qpnVIOBkauWn8J3X7YKBCKHImJX+zNFdRExDFoHs=;
        b=VPnfJkFV+wYLGUpengBGXEi3zi25q1tALeanvtep0r+BOc56UKQICsObZNw/1KM4QH
         N4s6HkX9ykK9J5T7ZFko8FX9RbFviipusv4RxXDriqJ/rOcrdJHaiSAAD9olJTVxKxLW
         kcCM+eeYdrdGFRgpaThcfaMex/mE+UKZA0neWEiyCPisjtvw/2p3qytBWMa5sQ8FuzbW
         RtttiJhqOv/GV7LPnSdFS3O7PYUBSJy1iQZAa+8V5OULdnN9gpIhm6WSnM0Oj8SeJ+aO
         z5nzGjES7EPQpCHbaNeJrxUH6Rh/3aZhQ0c6DKkMC/n+sXjLVNEDwpAJaIPYy7iKmUke
         1NEw==
X-Gm-Message-State: AJIora+s7F9w8l35IJGXBt9nTkq03Nbp9Vx6+Z+B/E/dnW1Kq8O4umKt
        LItaNM/fgy07oP8BJijC+GuqQgsJpDymZw==
X-Google-Smtp-Source: AGRyM1sU7nw1K6Rsocdf52of8qspW3fyrA1OmAFouOsXXPzfXcHOVeVha+CJZgDvP3ntUV2TuhANnw==
X-Received: by 2002:a05:6402:254c:b0:435:c541:fc8d with SMTP id l12-20020a056402254c00b00435c541fc8dmr25331254edb.385.1656442806885;
        Tue, 28 Jun 2022 12:00:06 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 12/29] tcp: kill extra io_uring's uarg refcounting
Date:   Tue, 28 Jun 2022 19:56:34 +0100
Message-Id: <c3414a501553038eec00021de01ac2cf6b052cf8.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

io_uring guarantees that passed in uarg stays alive until we return from
sendmsg, so no need to temporarily refcount-pin it in
tcp_sendmsg_locked().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/tcp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 832c1afcdbe7..3482c934eec8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1207,7 +1207,6 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 		if (msg->msg_ubuf) {
 			uarg = msg->msg_ubuf;
-			net_zcopy_get(uarg);
 			zc = sk->sk_route_caps & NETIF_F_SG;
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
@@ -1437,7 +1436,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
 	}
 out_nopush:
-	net_zcopy_put(uarg);
+	if (uarg && !msg->msg_ubuf)
+		net_zcopy_put(uarg);
 	return copied + copied_syn;
 
 do_error:
@@ -1446,7 +1446,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	if (copied + copied_syn)
 		goto out;
 out_err:
-	net_zcopy_put_abort(uarg, true);
+	if (uarg && !msg->msg_ubuf)
+		net_zcopy_put_abort(uarg, true);
 	err = sk_stream_error(sk, flags, err);
 	/* make sure we wake any epoll edge trigger waiter */
 	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
-- 
2.36.1

