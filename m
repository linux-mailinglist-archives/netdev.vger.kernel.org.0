Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9443B67B091
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 12:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbjAYLFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 06:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235282AbjAYLFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 06:05:21 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C63D4CE7E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 03:05:19 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id 5so12221354plo.3
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 03:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nHqLQLBY2PL1EUhG5U2fpARyHyDVWwD5R++HQSH4EVE=;
        b=BQJ26mgkeP0qOhRfklqz/8sEoeEBYsU5n8U135dZFifO6+MLofmTgj644Ra9GngvQd
         hGuG4BStw8GjMvvgC8vSg46vs5nz6H21IbCH300zT+u5/VuGPn8obnIS1XmSxWoc2c6h
         ihtqxZ10Myghl8iyudEUDlIgB6kiakFYnGfAY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nHqLQLBY2PL1EUhG5U2fpARyHyDVWwD5R++HQSH4EVE=;
        b=B3jK4U7ZBYruLMOzJ61xvXdErqirKM0ho4jvheZ6plWZqevkqdo/Ks6RcnkrnUW6kJ
         CJ84QgggxvZ7NeyhSYqD5t5OONDUdD+XQj/R8NA+vj3U7IRtzTdnuRG+zPZTqGZn2+VP
         jLtpcaOthp1TFeRm3EIbsFMZncqf6kstGQyeszhwz1Xt08yrEa97JCNk9w9SIF0VfPXn
         m8gpX5hWQ5xQRHmuyEb68pNcq8K31gJtxVotxcoIcMANHXJwcQ0sjixyLFGhz8d02+6t
         naOm1tc6H1lTmIbyatZvbc2zcSIDYKSxkyW0qWMonTPiH9O57m5gVlt6xrltTyYAKU3f
         NgxA==
X-Gm-Message-State: AFqh2kqIVt1mMc/zWFhCJb/RaaFnr314G3qpyLNeTN4OCqAdhPRa9NyF
        SE8AabWExdPB1pmw+NWVCSKJBw==
X-Google-Smtp-Source: AMrXdXv0lMDfZPG3FgFuVjuo5UYQL3rXGVT4wxPVQoElj6PBLvLDxUutuXwc0FTTCUwdxOaCwqoj/g==
X-Received: by 2002:a17:902:9a4c:b0:192:4f32:3ba7 with SMTP id x12-20020a1709029a4c00b001924f323ba7mr31365027plv.18.1674644719038;
        Wed, 25 Jan 2023 03:05:19 -0800 (PST)
Received: from ubuntu ([39.115.108.115])
        by smtp.gmail.com with ESMTPSA id az3-20020a170902a58300b001897e2fd65dsm3398392plb.9.2023.01.25.03.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 03:05:18 -0800 (PST)
Date:   Wed, 25 Jan 2023 03:05:14 -0800
From:   Hyunwoo Kim <v4bel@theori.io>
To:     ms@dev.tdt.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com
Cc:     v4bel@theori.io, imv4bel@gmail.com, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3] net/x25: Fix to not accept on connected socket
Message-ID: <20230125110514.GA134174@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If you call listen() and accept() on an already connect()ed
x25 socket, accept() can successfully connect.
This is because when the peer socket sends data to sendmsg,
the skb with its own sk stored in the connected socket's
sk->sk_receive_queue is connected, and x25_accept() dequeues
the skb waiting in the sk->sk_receive_queue.

This creates a child socket with the sk of the parent
x25 socket, which can cause confusion.

Fix x25_listen() to return -EINVAL if the socket has
already been successfully connected, and add lock_sock
to prevent this issue.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
v1 -> v2 : Change the flag to check to SS_UNCONNECTED
v2 -> v3 : Fix wrong patch description
---
 net/x25/af_x25.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 3b55502b2965..5c7ad301d742 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -482,6 +482,12 @@ static int x25_listen(struct socket *sock, int backlog)
 	int rc = -EOPNOTSUPP;
 
 	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		rc = -EINVAL;
+		release_sock(sk);
+		return rc;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		memset(&x25_sk(sk)->dest_addr, 0, X25_ADDR_LEN);
 		sk->sk_max_ack_backlog = backlog;
-- 
2.25.1

