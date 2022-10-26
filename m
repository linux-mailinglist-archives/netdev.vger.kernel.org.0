Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB2A60EC94
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 01:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiJZX2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 19:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbiJZX16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 19:27:58 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D43559E83;
        Wed, 26 Oct 2022 16:27:30 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id k8so20401228wrh.1;
        Wed, 26 Oct 2022 16:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mw2s7wAvpFdjBac+RJ5XjlO7wY/8JdIzBylcaNWwwcM=;
        b=dT6rsR+rKxLWm7s7dtgtCzGkjWHq6Iv7Kp5GwujJK6NHSTNVeX93gkrhuHKTUh5WK0
         Mq1ENWnJjiDUPTaPdnqDZV18OPSgk2Fk1gx8MVfA2GZoRmIxWl+OptZ95b9xVsRup2Qm
         Eg9M6e5EZsHttTxAs7by6HAV2XU9Tum2tf+j59XLIElYMvW7R5TovDUFDDz7mosvLRAC
         EIiZxB/+YA97nude8oxbWywTJqYvRRH1JyFq5kSdds7W7whIH/OfGWJOjmhdwsLx3Bec
         UuJro7hm8q6AeCtw0xLr4zo6/7hmqrdbn8Bw/eopeD0Ihqz67ZGBVA/xDHymId6UraTI
         58mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mw2s7wAvpFdjBac+RJ5XjlO7wY/8JdIzBylcaNWwwcM=;
        b=U7M4Q75KvkmbeOPl2QJi5YpH8kEwiT6KFuUj3NgF/YrEpobsljh1pxgW29lT8NGY1U
         3a9OAGLRSc/HzsB0+vf4RiGYdEriejvpBC9R67tYI51QiG48bhlsLkGcrSpRGAqPFE5M
         UwFepwFhUh+Nwb4sK8qkx3MK35Ywp9kJGFEyGyTcKKs3CHC6SozMYr2vIBZDgR5JyT5R
         NZVVtkcansLOr+HV7yuew4nwG7H969US10Vsp30hiVzZDaNV57hzXk5AadTSffuL42Ab
         1OPb8jYAPRmBPDyQ0ogH5QdKTRoNExw4GMFvRwjKhIJ3EuPccEKpQYKyk76Admu7c3zU
         EANw==
X-Gm-Message-State: ACrzQf17HgreyNh7/3JZtDdCXrE6dH5mo5/kydACfkwzPr0iApIbBp4q
        0Duuuz+8oXW97Sutxuqa0dPKPTvvIDdnJw==
X-Google-Smtp-Source: AMsMyM5OP6wmEEeqcZkCOaBOcHWs9BmhTaPxWZbPo/EOrtelra8g/+TI2cSSXWKBC5HopOG79v/cHw==
X-Received: by 2002:a5d:64a3:0:b0:231:f82e:9a57 with SMTP id m3-20020a5d64a3000000b00231f82e9a57mr30651301wrp.492.1666826848318;
        Wed, 26 Oct 2022 16:27:28 -0700 (PDT)
Received: from 127.0.0.1localhost (213-205-70-130.net.novis.pt. [213.205.70.130])
        by smtp.gmail.com with ESMTPSA id y4-20020adfd084000000b002368424f89esm4897526wrh.67.2022.10.26.16.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 16:27:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, io-uring@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        asml.silence@gmail.com
Subject: [PATCH net 1/4] udp: advertise ipv6 udp support for msghdr::ubuf_info
Date:   Thu, 27 Oct 2022 00:25:56 +0100
Message-Id: <63bd51f76b1951ae1ca387eef514e2d90c329230.1666825799.git.asml.silence@gmail.com>
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

Mark udp ipv6 as supporting msghdr::ubuf_info. In the original commit
SOCK_SUPPORT_ZC was supposed to be set by a udp_init_sock() call from
udp6_init_sock(), but
d38afeec26ed4 ("tcp/udp: Call inet6_destroy_sock() in IPv6 ...")
removed it and so ipv6 udp misses the flag.

Cc: <stable@vger.kernel.org> # 6.0
Fixes: e993ffe3da4bc ("net: flag sockets supporting msghdr originated zerocopy")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 129ec5a9b0eb..bc65e5b7195b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -66,6 +66,7 @@ int udpv6_init_sock(struct sock *sk)
 {
 	skb_queue_head_init(&udp_sk(sk)->reader_queue);
 	sk->sk_destruct = udpv6_destruct_sock;
+	set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 	return 0;
 }
 
-- 
2.38.0

