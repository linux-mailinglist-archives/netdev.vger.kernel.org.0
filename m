Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E826770F9
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 18:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjAVRKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 12:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjAVRKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 12:10:20 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5757D222DA
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 09:09:36 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m3-20020a17090a414300b00229ef93c5b0so8444754pjg.2
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 09:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9q3bR3q+jWpwQUPs7WwVJoC9NtlmUNwWWj9tISIL2ek=;
        b=ATAdwDoDC7PqzkIZxzVrLoyWt+CINbQhif10ufrC4VDHtyOzZUf/K01MYx+ZlN9FF7
         ztVrJSFVSJesS+G/Mc5Zm7fDaaDKSQJ5pUMn/MtGZ8TMdRNMTgaR5zgUpd5QmQDNxctf
         m0q+nAk7B0GqRhpOQBc7+Owh1ktZKg7vz5QUY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9q3bR3q+jWpwQUPs7WwVJoC9NtlmUNwWWj9tISIL2ek=;
        b=HhABdlc4OHbwCMN1jBno4q+GlLtPE9UEwVnlyMHpHm70/6tfEwlWeOzXJV3jDFRY/o
         hYDtL2BOl3vGNtY73yrQkxYTjo5NnBYlfQm5dscUU/x6JvewfUtOgFudXH0f3ZXlUuIB
         ShfG/f/PS3bdFVJLjJhuDpyMmGQA4k/NocD+YbAb5uoQGQM+4AnGFaY+mlgiv9Z46lO5
         ONEWbE7CtoxrtSXiofFgtCP9JKnPDuvfemcidgT9k6wxjBFTTpcGDYwig4DkC1x5kQTd
         mMcHsibDuttA3ZsIVOneI6QvWCIgaNdozApLeW5q8lucLxMt2PHIUiPXvhg1aS4qXta3
         RBaw==
X-Gm-Message-State: AFqh2kqopRqE/PDoLxHAC4/pMSWomjX4dXGzmzNeQZQot8nHvsv4xFtd
        XBuUrYqHmFeoU34BPLWF3jj4Pg==
X-Google-Smtp-Source: AMrXdXuI5EMntklTOq7nVDd2UxyjGwBd6ByS6alvZ/tJgCE+AiRSAkU8TAMdRrsD52AqbJ4MEt0oZQ==
X-Received: by 2002:a17:902:6549:b0:194:b2aa:c1bc with SMTP id d9-20020a170902654900b00194b2aac1bcmr15667020pln.2.1674407370375;
        Sun, 22 Jan 2023 09:09:30 -0800 (PST)
Received: from ubuntu ([39.115.108.115])
        by smtp.gmail.com with ESMTPSA id x6-20020a1709027c0600b001943d58268csm3599755pll.55.2023.01.22.09.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 09:09:29 -0800 (PST)
Date:   Sun, 22 Jan 2023 09:09:25 -0800
From:   Hyunwoo Kim <v4bel@theori.io>
To:     ms@dev.tdt.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     v4bel@theori.io, imv4bel@gmail.com, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] net/x25: Fix to not accept on connected socket
Message-ID: <20230122170925.GA98061@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When listen() and accept() are called on an x25 socket
that connect() succeeds, accept() succeeds immediately.
This is because x25_connect() queues the skb to
sk->sk_receive_queue, and x25_accept() dequeues it.

This creates a child socket with the sk of the parent
x25 socket, which can cause confusion.

Fix x25_listen() to return -EINVAL if the socket has
already been successfully connect()ed to avoid this issue.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
---
 net/x25/af_x25.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 3b55502b2965..4407a625daa6 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -482,6 +482,12 @@ static int x25_listen(struct socket *sock, int backlog)
 	int rc = -EOPNOTSUPP;
 
 	lock_sock(sk);
+	if (sock->state == SS_CONNECTED) {
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

