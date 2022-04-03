Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC334F099E
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358765AbiDCNLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358691AbiDCNK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:58 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFE4E08F
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:40 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id i127-20020a1c3b85000000b0038e710da2dcso137593wma.1
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v9yxQTyA86mePd2RU+Ke+BjoJwXYliN0D9JR7+nNx10=;
        b=eh50WPqcbnMjWNo34j9nSp6EVrW1w7XIppkPs08aA3NB/XEDDXelB5JxemmWh9ay9j
         TvPSDPXOD8G36aIFPdvQ81hPQRdWZE6N4Xh8Q9cKgaJCVn+nvq5a/Uql39w9ZQ346g5Q
         zQWbA6lE9IMX5U+yIPdULIiBUDjDYAVV3KzXdjXUPxLmMpuLGKYN63lHxx8UNDKjcCsr
         iVIS0ymTMCqv39l9J9p1L84Rlpg40ciEQDuJivV8Lm4IUKpnLQsSDtmXN3T6UuXx42rr
         rXsLQwMtyBd1EHyPDCAD3SEJ2d+/TmN1ZYOekfFWHpoqoagDccGqlRf3WKl8t49udZQf
         qE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v9yxQTyA86mePd2RU+Ke+BjoJwXYliN0D9JR7+nNx10=;
        b=NZ+xmXvVcrd+VqZeb8pZDDprb2RCOE13i9/M5org73T67H2/mj7XNvJ4Wc53Xj5ltQ
         Y6y5nE+x5BSKfKaHCl2FIrUW3JTjPCvdbVWgMLm4xmU8/hxkfDcZWW37klw2N9cKKnlW
         rRIRwsZdiI2MneTdXdtkJRGdkYzsy1ALxpT3KBUIF6O2nN63fIxWducPXb+fgjIgNU82
         9YxzpxzyL8IEIbNHhVxKbX1SoJ61NjyTdKuhY17MQ0XmereSf+VYlotV54GtecyQXcMe
         9R4XBvS+13R3OE9JJZQ9EmiSXxg0NO2fOz6cfECiE2wLzevZ1AfvwxU0Llm2CEOSLs/A
         Jp5g==
X-Gm-Message-State: AOAM532jfFAMjpqrLPzQF5deRIwfcux/ZQt33oFa+QcVWB8IWNLXOUgt
        Y+wZ06gg7GNd7A7qDmy5FcfHNOo9I0g=
X-Google-Smtp-Source: ABdhPJz/nuUIpN2sgzHIcobyL9DNueuSnkK12RPkUNWHhgEv3bz9dKf9cfXD7zgwg3OEHPA9ciF/dg==
X-Received: by 2002:a05:600c:4fc4:b0:38c:d622:f445 with SMTP id o4-20020a05600c4fc400b0038cd622f445mr15775436wmq.73.1648991318942;
        Sun, 03 Apr 2022 06:08:38 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 24/27] udp/ipv6: clean up udpv6_sendmsg's saddr init
Date:   Sun,  3 Apr 2022 14:06:36 +0100
Message-Id: <a8a23f600aaee6ceed04d5399ee4dc9b9d8657a3.1648981571.git.asml.silence@gmail.com>
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

We initialise fl6 in udpv6_sendmsg() to zeroes, that sets saddr to any
addr, then it might be changed in by cmsg but only to a non-any addr.
After we check again for it left set to "any", which is likely to be so,
and try to initialise it from socket saddr.

The result of it is that fl6->saddr is set to cmsg's saddr if specified
and inet6_sk(sk)->saddr otherwise. We can achieve the same by
pre-setting it to the sockets saddr and potentially overriding by cmsg
after.

This looks a bit cleaner comparing to conditional init and also removes
extra checks from the way.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 2b5a3ed3f138..0b82447629b7 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1431,14 +1431,15 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		connected = true;
 	}
 
+	fl6->flowi6_uid = sk->sk_uid;
+	fl6->saddr = np->saddr;
+	fl6->daddr = *daddr;
+
 	if (!fl6->flowi6_oif)
 		fl6->flowi6_oif = sk->sk_bound_dev_if;
-
 	if (!fl6->flowi6_oif)
 		fl6->flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
 
-	fl6->flowi6_uid = sk->sk_uid;
-
 	if (msg->msg_controllen) {
 		opt = &opt_space;
 		memset(opt, 0, sizeof(struct ipv6_txoptions));
@@ -1473,9 +1474,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	fl6->flowi6_proto = sk->sk_protocol;
 	fl6->flowi6_mark = ipc6.sockc.mark;
-	fl6->daddr = *daddr;
-	if (ipv6_addr_any(&fl6->saddr) && !ipv6_addr_any(&np->saddr))
-		fl6->saddr = np->saddr;
 	fl6->fl6_sport = inet->inet_sport;
 
 	if (cgroup_bpf_enabled(CGROUP_UDP6_SENDMSG) && !connected) {
-- 
2.35.1

