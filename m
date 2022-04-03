Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0164F09A8
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358720AbiDCNLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358550AbiDCNKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:44 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AB263B6
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:39 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h4so10584783wrc.13
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uKsgDfFrJ6sHu/Q67vDokAer++R96ex3/kqPUqL2P3Y=;
        b=onKw21DPHB/wMUHDHUpOxOM9DwsKwfIMsIfLBLpaIjY7hE39w6KYf8I1TvXBE0BBrt
         keWPdtsywbscivuacOUvo39eF7wlJz0SQRgJLBdL4VaBdbfpe8FO7h/kFwQNrch7PedE
         Hs6qgIngX2hwS5N8MMjsEf97uuGD+g7QzUGbNwQd9kIHHCecpOzK3wr5AbRXqLGh4sU6
         r56vi52sQ/rngdeoQ9l1rMfEdMmAjRJeFVGwhVjv7aTpRCDlGM+DKhjjVPFfHFiXOaQW
         O9Hu9Yc/t42udnH1vYnPsjgHhIrpi51+UFxSL1IYqcbFyqcb6DWrnRjYznoYmI/q1qBP
         YwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uKsgDfFrJ6sHu/Q67vDokAer++R96ex3/kqPUqL2P3Y=;
        b=PMbfBfMKZWuSFeD2r7z6vJRPks24wXPRDTUhr6re7mKKkDfoOZY/jQB7vmoTxHyG0t
         bbWXqvea6HLNw0anxKZ9AyLoTpEKIEWCJBn2tIcZ73XBLHMcokwjWwHTxxGwDBjPlhpO
         guTuzaIQEXJZLDGG+ZAl3azA3OtzrfUtfav+/Dc3SMPLP6UwwLhJM2vsNUfMR3XA6nmd
         gpCYx/PuAODHKWTv0bhnmH+uiWvNgawVpnuBfk35quue9qCk84BBAi9sdLEn1q7N5HjE
         ovBDr0xEPh2iWMV+Pwwn1yAuNzZywVmpYWQUZ8NYY0j5xrrF9zcrdJ1qjvoN7Jcg7OT6
         /McQ==
X-Gm-Message-State: AOAM533Ye498mvuZ1iP0DVUFamxa40oSbER2M8sK784zJZ5DcwJU0yJJ
        FE9D1iVaYw7BBmlr79u7bAUkh5c/me0=
X-Google-Smtp-Source: ABdhPJzkbqUTzhXiSpknivlerCj6Nfygtjd6hFDLbTIg2LpEKBPzLJip/qoedpUbN1u2B8pcrgiWXw==
X-Received: by 2002:a5d:5704:0:b0:203:f9bb:b969 with SMTP id a4-20020a5d5704000000b00203f9bbb969mr13439886wrv.459.1648991317790;
        Sun, 03 Apr 2022 06:08:37 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 23/27] udp/ipv6: optimise out daddr reassignment
Date:   Sun,  3 Apr 2022 14:06:35 +0100
Message-Id: <24a4aec56b6a94c1d54a0e81bc0af6efd29fd622.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
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

There is nothing that checks daddr placement in udpv6_sendmsg(), so the
check reassigning it to ->sk_v6_daddr looks like a not needed anymore
artifact from the past. Remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index cbb11316a526..2b5a3ed3f138 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1417,14 +1417,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			}
 		}
 
-		/*
-		 * Otherwise it will be difficult to maintain
-		 * sk->sk_dst_cache.
-		 */
-		if (sk->sk_state == TCP_ESTABLISHED &&
-		    ipv6_addr_equal(daddr, &sk->sk_v6_daddr))
-			daddr = &sk->sk_v6_daddr;
-
 		if (addr_len >= sizeof(struct sockaddr_in6) &&
 		    sin6->sin6_scope_id &&
 		    __ipv6_addr_needs_scope_id(__ipv6_addr_type(daddr)))
-- 
2.35.1

