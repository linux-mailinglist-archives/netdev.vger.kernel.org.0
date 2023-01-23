Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90FE678691
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjAWTka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbjAWTk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:40:28 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B475510276
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:40:26 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9so12476208pll.9
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G2ns64YdTQGyB93XCyw4IBhbiRpiReSdyKsHHqkh3Rc=;
        b=V1xiKjP/ewAPV6EOQxN2iCEk97jKjHvTsLYGRvPPg0he1XbCRVj3DrtEX9mdepX7OQ
         xu04xxcNb3JUxUrix5mzpDFjdiITerJkhTMacTENBS31h3o2nJVWwlkZHUDCmMxEhZSZ
         AlzNRZjbjJ2pUlm1ITZGoTDmrJYBbcvrdGaYc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G2ns64YdTQGyB93XCyw4IBhbiRpiReSdyKsHHqkh3Rc=;
        b=m0uhteZnwy0jP+6B+gpYexvLajY7dDt4Ia7DYxSBpmj5WWarDcOyN9y1m9Tic+wQWC
         7JhAAXph0PuJiCPUqpdRGsRrdSdjS18ei1LPHudGEEMgMu6s7WiFoqNij61HNex+pF3b
         vsJ8ievcJymlv5ip2xL49fdpvua2/0zdOnrXGM23vO/yrR6BhzV68V5IF+t5Xhlp0vkr
         UnGDyKhnlhk+Cl2fD1nBf2lcRpFztKw/1LsYYwQYDKkPp6dCKCSP1u1iKwY1LrSRFn9/
         Kcx71XGszUcnGltV7psruu7MWdNUPEi7deNZoqSMq2efRoi2BGpJvM38qnWqynRkJTB6
         B5Kw==
X-Gm-Message-State: AFqh2kokeUr7E+GsXCD+CGLbxcOcm3LPlclZdk4rglWxOOFuOZyxybJs
        hYmNgj/pY7cUZuoKtPSTidooLw==
X-Google-Smtp-Source: AMrXdXtHOooAn8GWRAtP/F1TqIqStt+zSNAFUUVGI1BsH+8m5rZthiUozHxDtrcYkvb23gtsKYWfFA==
X-Received: by 2002:a17:903:26c9:b0:194:9b68:aba4 with SMTP id jg9-20020a17090326c900b001949b68aba4mr23857302plb.69.1674502826146;
        Mon, 23 Jan 2023 11:40:26 -0800 (PST)
Received: from ubuntu ([39.115.108.115])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902aa4b00b001948107490csm95583plr.19.2023.01.23.11.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 11:40:25 -0800 (PST)
Date:   Mon, 23 Jan 2023 11:40:20 -0800
From:   Hyunwoo Kim <v4bel@theori.io>
To:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     v4bel@theori.io, imv4bel@gmail.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2] net/rose: Fix to not accept on connected socket
Message-ID: <20230123194020.GA115501@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If listen() and accept() are called on a rose socket
that connect() is successful, accept() succeeds immediately.
This is because rose_connect() queues the skb to
sk->sk_receive_queue, and rose_accept() dequeues it.

This creates a child socket with the sk of the parent
rose socket, which can cause confusion.

Fix rose_listen() to return -EINVAL if the socket has
already been successfully connected, and add lock_sock
to prevent this issue.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
---
 net/rose/af_rose.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 36fefc3957d7..ca2b17f32670 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -488,6 +488,12 @@ static int rose_listen(struct socket *sock, int backlog)
 {
 	struct sock *sk = sock->sk;
 
+	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		release_sock(sk);
+		return -EINVAL;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		struct rose_sock *rose = rose_sk(sk);
 
@@ -497,8 +503,10 @@ static int rose_listen(struct socket *sock, int backlog)
 		memset(rose->dest_digis, 0, AX25_ADDR_LEN * ROSE_MAX_DIGIS);
 		sk->sk_max_ack_backlog = backlog;
 		sk->sk_state           = TCP_LISTEN;
+		release_sock(sk);
 		return 0;
 	}
+	release_sock(sk);
 
 	return -EOPNOTSUPP;
 }
-- 
2.25.1

