Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38B4543859
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245090AbiFHQE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245079AbiFHQEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:04:50 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF7D27EBCA
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:04:48 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r71so19343551pgr.0
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s/yjgAWN6ga6buAhDAV9p3FMONiUhJ1Xnyb57YPRcdg=;
        b=be2yqTzc4suwMQb845QjAzjSwZBOEM1X8h8Uc5ft62whkCOjpdpFiA8am46rBd0X4O
         KehCNoC9oSEFBkigAeX2tbRpj6R0M4fabapJR7HwygAPQA6HcEBnEdKoMzYpkNSxUq9g
         7n4xIJnnZilW+zIhpbd7q8iM5qkV7+vuDdlJvLDi/WtiIp8EMtPApjnjknflsfn/z61z
         wOFjtRowm+mF6itF5TwXb7beA5cx5Lj6Y8q9cfqYEYQ/h92an7326FoGBa7LwRfRAguk
         4mLLPpJhogL85pLkhQPTeJtdnol/DPMdqUZYhH+YyCzW1kzz5/oTRL+Oo9VDS0+D7xw6
         jXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s/yjgAWN6ga6buAhDAV9p3FMONiUhJ1Xnyb57YPRcdg=;
        b=ndmCsSy0Js/nD3pYBNlcpk8MYn4lnzc3GIn+EiIHwUtTTqhlXj3IKes7yatuUr4/pQ
         6eOgwUiv2+ZKzC17Boz0zLdxHjSGWE17s9SJvtIkWZkqHRHlr4YkwZGz2RAToChC0M1i
         Ft+XbdlTfr6Ute1GrtUk+w18o6NFmWCxU57oLWZmNdws4ukSVkLGH9pyuwZ9Bu2IRkOT
         4gaFcL/ggHvSWNLu2SYp7Ub4MsO72qr5acu+gH73sQWoKpO4rHYHWbtyaphWhQeG87FU
         78qjKZ9p1d4ujdyGm8OcxTbDjrNUHuXUBYlMbJ0fNpSpXE34ZtR1Duk1Eap/E6pPqVNu
         fMBQ==
X-Gm-Message-State: AOAM532yRvLAWtcSx1eQCG/0l0XJnAGz7CW3vNNZYG2zPy55Qh+uOWs5
        Q8Ly/+V+Q4hZHfQhSlsWfyc=
X-Google-Smtp-Source: ABdhPJxLckQ41XwJfT7PLMjiUZZrTxgFkJtsKlXvD+OXcqL+6htbSbPCBX/B44ekpkndOEEQu/JvJQ==
X-Received: by 2002:a63:5515:0:b0:3fd:9833:d9f7 with SMTP id j21-20020a635515000000b003fd9833d9f7mr16934374pgb.16.1654704287261;
        Wed, 08 Jun 2022 09:04:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id ju10-20020a17090b20ca00b001df264610c4sm18622019pjb.0.2022.06.08.09.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:04:47 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 4/8] net: use WARN_ON_ONCE() in sk_stream_kill_queues()
Date:   Wed,  8 Jun 2022 09:04:34 -0700
Message-Id: <20220608160438.1342569-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608160438.1342569-1-eric.dumazet@gmail.com>
References: <20220608160438.1342569-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

sk_stream_kill_queues() has three checks which have been
useful to detect kernel bugs in the past.

However they are potentially a problem because they
could flood the syslog.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/stream.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/stream.c b/net/core/stream.c
index 06b36c730ce8a29bb2d8984495e780931907ca72..ccc083cdef23266dc100368a7183bdeb0e99cbb7 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -196,13 +196,13 @@ void sk_stream_kill_queues(struct sock *sk)
 	__skb_queue_purge(&sk->sk_receive_queue);
 
 	/* Next, the write queue. */
-	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
+	WARN_ON_ONCE(!skb_queue_empty(&sk->sk_write_queue));
 
 	/* Account for returned memory. */
 	sk_mem_reclaim_final(sk);
 
-	WARN_ON(sk->sk_wmem_queued);
-	WARN_ON(sk->sk_forward_alloc);
+	WARN_ON_ONCE(sk->sk_wmem_queued);
+	WARN_ON_ONCE(sk->sk_forward_alloc);
 
 	/* It is _impossible_ for the backlog to contain anything
 	 * when we get here.  All user references to this socket
-- 
2.36.1.255.ge46751e96f-goog

