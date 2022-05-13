Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4361526619
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382055AbiEMP1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382008AbiEMP1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:27:10 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD41D205F8;
        Fri, 13 May 2022 08:26:54 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id m20so16892035ejj.10;
        Fri, 13 May 2022 08:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MdffPT0YM78EitIudyoFbqjCIcS1NHxhBv6aczYla1Q=;
        b=IWf5fvyqwI7ymlG6Mvh6Uai+D7DbXCSJlMEODdUs83qoW1qJFQHPBk2dER5lq2ec9Y
         96SCA1zyQ1289Or2jJ78YV5ALyxGM/7jPbYAgqmaJgv9GL5XDRDamptB9fixG/eXdCVz
         V/K1akmkHRsfKeHLIyXyis+y3MaM73zSMd6EHuJUNSrDZIGylgev1aZOqe3+3vPi4e1H
         6WbFuy29+854tqzrMPlkOYRkXSGbWuvKXctuulP+PBXvKeda3TX/ivOKQSuk68FD0pp5
         P+rCLZ5u8BcTfnEmOmbrS8Oy6o+hIS1SGtSJCXdDUS3W6e1aDVqQ6taHMCVk9EwMjw0+
         6Lqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MdffPT0YM78EitIudyoFbqjCIcS1NHxhBv6aczYla1Q=;
        b=0Eh8W30WsIt+FFeXCNLGPTJyGLiSmpf78HfDNECrFaJ5aoq60+CiMAgD87WMA3PGp+
         GnL9zoAWTUCoYB6aXCO0SfqS7w0cdBhM8jYSxxcHBdrX909O/mTtMx7vFvjyryn+ARRd
         oxAq+ZyEaAt7vqJ1XpMI/sALOV37cwslsES4C/5uUkpies8avSy96RQmj2s5AWatPF85
         Vc3YrSmnIxwpvnP5A2eVonmIRalA9VHFilMPD7dIMnr3egBGbh/FQFD2HRzYhwXFEHOg
         ZiW0rSVxWSjAUFUiRlJ15kpebKx3Oefj1qyMR050LYcAjKGImEe0pIWVywZIsxK7tvEN
         BCdw==
X-Gm-Message-State: AOAM530PPZHc3tEFDi43r/jOqUQzN2+epvlowW1fPQ3bewZR3nEZHa9O
        MEeffANLuDutuYzKEz9WZXjrohAg9s4=
X-Google-Smtp-Source: ABdhPJw9jBhhp+PMj+9mJMyRz2PcqazYPwajbKaFd+y4ODIv0RhFDwpfytllQNC23xspaWUCbENPNQ==
X-Received: by 2002:a17:907:d1d:b0:6fa:1f27:b39 with SMTP id gn29-20020a1709070d1d00b006fa1f270b39mr4554972ejc.146.1652455613343;
        Fri, 13 May 2022 08:26:53 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm1015351edj.85.2022.05.13.08.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:26:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 06/10] udp/ipv6: clean up udpv6_sendmsg's saddr init
Date:   Fri, 13 May 2022 16:26:11 +0100
Message-Id: <2a0bd67940ed265cb9f4734f602792da37292968.1652368648.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1652368648.git.asml.silence@gmail.com>
References: <cover.1652368648.git.asml.silence@gmail.com>
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
index 61dbe2f04675..9bd317c2b67f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1434,14 +1434,15 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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
@@ -1476,9 +1477,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	fl6->flowi6_proto = sk->sk_protocol;
 	fl6->flowi6_mark = ipc6.sockc.mark;
-	fl6->daddr = *daddr;
-	if (ipv6_addr_any(&fl6->saddr) && !ipv6_addr_any(&np->saddr))
-		fl6->saddr = np->saddr;
 	fl6->fl6_sport = inet->inet_sport;
 
 	if (cgroup_bpf_enabled(CGROUP_UDP6_SENDMSG) && !connected) {
-- 
2.36.0

