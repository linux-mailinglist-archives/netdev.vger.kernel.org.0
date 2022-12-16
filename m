Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB8F64EF0F
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiLPQ3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiLPQ3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:29:21 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826C229351
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 08:29:20 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id ay43-20020a05620a17ab00b006fa30ed61fdso2150166qkb.5
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 08:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QZCQPWd/7SSVO5XHgM4re5UEGB/nXf/LhBKVgCNLpkw=;
        b=jlYn2wYxGkhXkc88gBML54YftujTKpxZLPUu5vw4AK05jU3GkMBaVZJI+N4bcbkWmG
         6jfF6hue3o0iTPuZvCXm4KygxgVbgscGhhMzBXdDUDb6RwYSSfWMCh3KQffgJtJut3B5
         y5EgRrTnTGxntigxBZQ7NHzuuxDh8Yc+UfpB3M6KTYWx9SVPbNyFkzFrEHUd1w+pYdgp
         uFSMdVx65BazChcgFnJHn5Xo26RhnxeaKTD7KcfHag/hxOReZ4w5i43QKf0UO0rAy0n/
         VK+I7qWir41pIql8tsj9iUERNX7ZEaQ5CC2EgAEApoHa3veW0KLcRCtz4QccQipvSt2H
         H/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QZCQPWd/7SSVO5XHgM4re5UEGB/nXf/LhBKVgCNLpkw=;
        b=8QGqsK3LRMrPhYiEtqitjJ1AJxCypKtsW7KdCMJCKICjXrA4eY+I7QebKd3cbi98NG
         JXCUWZWb8DKjXHcsBlq6mHLgIr088wWCKDlOEUB1f0B08ryWlpTZJapzDT+KX4NRE5Bz
         3uJs8CCosipyPQBic27bewOioLrz2XhKxooN02VWdn2HMZ/lbrsITqbdLsdA0YTHWUFP
         i3n+fbjJ2ryIq57iR7x4OnPXHrCun87rpXSZVOpktAOQTazCBYgZXqoXhWhhOrKk64fm
         taIWS26hIEqT4IbBN27KV6pcXQtbq8dev4ODFy+gVGcvOl3QuwYlMNiKBE3y3DI42K5l
         qj2Q==
X-Gm-Message-State: ANoB5pn5PmStdctTuo/CPu9MF6LJ1TGICCXsFJQaiOiKuEpqiYPPFvda
        VzlmUVzquONN+BlfeVgsibjokjIq9OlZ/w==
X-Google-Smtp-Source: AA0mqf7q6pGHodEjiBe8irTOhUTX/PpZiG+EMhNKgfoYcUVOpcK4mPIhKFaCAMe1uwJPPxjhkTZjG5FuDpOqog==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6214:1843:b0:4c7:2b1f:841a with SMTP
 id d3-20020a056214184300b004c72b1f841amr29700452qvy.68.1671208159738; Fri, 16
 Dec 2022 08:29:19 -0800 (PST)
Date:   Fri, 16 Dec 2022 16:29:17 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221216162917.119406-1-edumazet@google.com>
Subject: [PATCH net] net: stream: purge sk_error_queue in sk_stream_kill_queues()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Changheon Lee <darklight2357@icloud.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changheon Lee reported TCP socket leaks, with a nice repro.

It seems we leak TCP sockets with the following sequence:

1) SOF_TIMESTAMPING_TX_ACK is enabled on the socket.

   Each ACK will cook an skb put in error queue, from __skb_tstamp_tx().
   __skb_tstamp_tx() is using skb_clone(), unless
   SOF_TIMESTAMPING_OPT_TSONLY was also requested.

2) If the application is also using MSG_ZEROCOPY, then we put in the
   error queue cloned skbs that had a struct ubuf_info attached to them.

   Whenever an struct ubuf_info is allocated, sock_zerocopy_alloc()
   does a sock_hold().

   As long as the cloned skbs are still in sk_error_queue,
   socket refcount is kept elevated.

3) Application closes the socket, while error queue is not empty.

Since tcp_close() no longer purges the socket error queue,
we might end up with a TCP socket with at least one skb in
error queue keeping the socket alive forever.

This bug can be (ab)used to consume all kernel memory
and freeze the host.

We need to purge the error queue, with proper synchronization
against concurrent writers.

Fixes: 24bcbe1cc69f ("net: stream: don't purge sk_error_queue in sk_stream_kill_queues()")
Reported-by: Changheon Lee <darklight2357@icloud.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/stream.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/stream.c b/net/core/stream.c
index 5b1fe2b82eac753bc8e18c02db04c5906b3a2d97..cd06750dd3297cd0e0f073057a4d85d4078f87c3 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -196,6 +196,12 @@ void sk_stream_kill_queues(struct sock *sk)
 	/* First the read buffer. */
 	__skb_queue_purge(&sk->sk_receive_queue);
 
+	/* Next, the error queue.
+	 * We need to use queue lock, because other threads might
+	 * add packets to the queue without socket lock being held.
+	 */
+	skb_queue_purge(&sk->sk_error_queue);
+
 	/* Next, the write queue. */
 	WARN_ON_ONCE(!skb_queue_empty(&sk->sk_write_queue));
 
-- 
2.39.0.314.g84b9a713c41-goog

