Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235F454049F
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345509AbiFGRSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345500AbiFGRR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:17:59 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537BF51E6F
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:17:59 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-fe023ab520so756365fac.10
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YdqU5p5P1KJbnolEPhwdA3nRakckKoJfnz6ajx5T568=;
        b=GSsypi/ofmOkV3K/qYbPnrha9KLvWG8RtyhAo7YXXJd2RGQjbCK0YR6L76KXlOoPZ4
         3C+Zaz2F6P2cinFtAP3H4Y3FlNYbNzN3FAIXKg97HijbXBFfYYdOKklrwSqpUz6qt5QF
         qtZvhzSaryI6groa8Co8iJTm7zrZh80ru/JKhXtb372NEyupcoaf3djmOhwUfbhrOHBm
         UiGG0XkanO+0CSxGe94nftta4Q9ZHH3R9IIxjKAIA3HmxWMwIZ7pgpY/0xedSDOUO2br
         KSR1QEEo4UdVPh5yXHOQ5Jk3X1SArLKg/wluQ4T3Qdv5ObI96S+aIe38gjqGAMj82UnM
         ObQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YdqU5p5P1KJbnolEPhwdA3nRakckKoJfnz6ajx5T568=;
        b=RK/qtunK6XXiZ1p338kXgqk48sp+X+FrvgHlbUItpxklLzevBe8d6LSaENoCoPeeGs
         /hgD3h/GV3H1H6sZF0bfushZVoPvmOETDqGY5jloga32/0wJrSdZY917wZ1pCRB00NgR
         6HJrTH8pRgmw+d/TY/+61cXuqXTVXpfEl9nQmC0Aviap3V5IpwUAgYEl5X+YQhA4QXW/
         XTlotVjGWV6b1vF/OzjGhpeOUGayYQR/0cB6OOO0eeB/bcmqY/iTraoXhNldXStEXpOw
         ENrIkwcv65o888PlCbHbrP7HXU4Gl2Ycy9AB2riCF6/D1np0eSrSUWkRSNLfVil+txxa
         F7Eg==
X-Gm-Message-State: AOAM530FK9cGBlXSiODdJsMo3FjvXhmycQtlmfo88kmQUb6sJUS3jl5K
        0FSuDOs8gTZDSV3gMnz37BenCbca8Tw=
X-Google-Smtp-Source: ABdhPJw6VvXnARdnA2LMVfRQxFsvNcuSGsLGDRuVJkoM7cPJb2hRY1ZTVF8T5fKQOkK89lTfkgZYBA==
X-Received: by 2002:a17:90b:3a90:b0:1e6:a203:c7dd with SMTP id om16-20020a17090b3a9000b001e6a203c7ddmr28321749pjb.144.1654622267456;
        Tue, 07 Jun 2022 10:17:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id d4-20020a621d04000000b0051b930b7bbesm13001616pfd.135.2022.06.07.10.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 10:17:47 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/8] net: use DEBUG_NET_WARN_ON_ONCE() in sk_stream_kill_queues()
Date:   Tue,  7 Jun 2022 10:17:28 -0700
Message-Id: <20220607171732.21191-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220607171732.21191-1-eric.dumazet@gmail.com>
References: <20220607171732.21191-1-eric.dumazet@gmail.com>
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
could flood the syslog, and really only a developper
can make sense of them.

Keep the checks for CONFIG_DEBUG_NET=y builds,
and issue them once only.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/stream.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/stream.c b/net/core/stream.c
index 06b36c730ce8a29bb2d8984495e780931907ca72..a5aa3620be95574c6d0f371f5943bb3b8f36cb4c 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -196,13 +196,13 @@ void sk_stream_kill_queues(struct sock *sk)
 	__skb_queue_purge(&sk->sk_receive_queue);
 
 	/* Next, the write queue. */
-	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
+	DEBUG_NET_WARN_ON_ONCE(!skb_queue_empty(&sk->sk_write_queue));
 
 	/* Account for returned memory. */
 	sk_mem_reclaim_final(sk);
 
-	WARN_ON(sk->sk_wmem_queued);
-	WARN_ON(sk->sk_forward_alloc);
+	DEBUG_NET_WARN_ON_ONCE(sk->sk_wmem_queued);
+	DEBUG_NET_WARN_ON_ONCE(sk->sk_forward_alloc);
 
 	/* It is _impossible_ for the backlog to contain anything
 	 * when we get here.  All user references to this socket
-- 
2.36.1.255.ge46751e96f-goog

