Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0F060EC99
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 01:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbiJZX2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 19:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbiJZX16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 19:27:58 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A169457567;
        Wed, 26 Oct 2022 16:27:32 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l16-20020a05600c4f1000b003c6c0d2a445so2873474wmq.4;
        Wed, 26 Oct 2022 16:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uxR0N06XcTkbcfsZ9QY/sp1sj7zmWgcYGVut7P5rowU=;
        b=MdBbHT3vFV8LjHhqH7/jJnROkFXKA6sVq2Qj15Yg39e/zHMl0IwhhuI3wT2Shc0afA
         hs5sUnFUHlyoYluE2gZ2DWPbwuCUMhK6alpKfAa9vZY3OGhXUFbDFpzapAb0QLCAvhmK
         VZ6Laa+9EnLEMXk5GPQj34+UR/AF4sKZNiGTa0HQuawdIRiSFZxLLBTwEz4o4NgaY+Og
         3/pNA6hVEQAoj5Kv502vQqT+NaLEPukOLm4ti+HUaQoLozl3C8qOpUOZQmLaSZw8TRyt
         in+kGc8n1gfatWzDCg228MGjdqflo8PFPtQywENYzxJIqCEsxFo8H3MbhoIv6ebMdaGv
         sqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uxR0N06XcTkbcfsZ9QY/sp1sj7zmWgcYGVut7P5rowU=;
        b=q4sLYnk2080qj6MQ7re27noycS3TOe7kWf0qTav+f61WHHH8eAMzGDNmD7p7IvR0Ir
         QbmHBp8ITttzV/Fk2Ih4Y7uXU34bVIP8LS0uKrL3W1d35FwUQlkW8jlTI4hOfEJkcnv4
         MnVPBNcyb0yjdDvFR38bC+eVFpy7o/cUlmc5i8AzNTwJ5RiE8m4/vHx3uIjm08dqqb3D
         TIF+blcVPcEH9o+qu/7IGv3p6POLPP5LWYL/Hj/OkGNC2562RG1L03CGO7kLKZ4Edf+G
         CV6vzgzYVhGqKoJuJ0cxlT3Dpd5d8gIBYS0MX4Jnuj3y71P0xoaTAvmhvcJogbTlwqb+
         xDpQ==
X-Gm-Message-State: ACrzQf1YvKmvQ4+b0dNu0rv1hvXiLcQIVfKe9+Sqb2LM4EoIRiHZzoKB
        QRevhEMKlTk/XQGyVVQPtgYXUbmqAP4FSA==
X-Google-Smtp-Source: AMsMyM6zsvZ8+smBAzBcYkhxQ/XshQ2TAiODQdW3lKjh40VaonuagFLtMucOaa0cOs1HnIkI7Pp9Rw==
X-Received: by 2002:a05:600c:3781:b0:3b4:63c8:554b with SMTP id o1-20020a05600c378100b003b463c8554bmr3952382wmr.25.1666826850970;
        Wed, 26 Oct 2022 16:27:30 -0700 (PDT)
Received: from 127.0.0.1localhost (213-205-70-130.net.novis.pt. [213.205.70.130])
        by smtp.gmail.com with ESMTPSA id y4-20020adfd084000000b002368424f89esm4897526wrh.67.2022.10.26.16.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 16:27:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, io-uring@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        asml.silence@gmail.com
Subject: [PATCH net 3/4] net/ulp: remove SOCK_SUPPORT_ZC from tls sockets
Date:   Thu, 27 Oct 2022 00:25:58 +0100
Message-Id: <604fa24e63524f9e0f5098df7e1a578debf471bf.1666825799.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666825799.git.asml.silence@gmail.com>
References: <cover.1666825799.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove SOCK_SUPPORT_ZC when we're setting ulp as it might not support
msghdr::ubuf_info, e.g. like TLS replacing ->sk_prot with a new set of
handlers.

Cc: <stable@vger.kernel.org> # 6.0
Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: e993ffe3da4bc ("net: flag sockets supporting msghdr originated zerocopy")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/tcp_ulp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 7c27aa629af1..9ae50b1bd844 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -136,6 +136,9 @@ static int __tcp_set_ulp(struct sock *sk, const struct tcp_ulp_ops *ulp_ops)
 	if (icsk->icsk_ulp_ops)
 		goto out_err;
 
+	if (sk->sk_socket)
+		clear_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
+
 	err = ulp_ops->init(sk);
 	if (err)
 		goto out_err;
-- 
2.38.0

