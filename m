Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745FE5135F3
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347816AbiD1OCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347893AbiD1OCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:14 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843CBB53F4;
        Thu, 28 Apr 2022 06:58:56 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id kq17so9758090ejb.4;
        Thu, 28 Apr 2022 06:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e5oHEvN5cdUAoS8mD1OQl++xLisYKnIOLW+OJZESkSc=;
        b=B7Ay620N58CnzzJIYv3/eZeSgCBFkaObDPN90zJTsS4BrONhV+NZlmrn6y6ydPNNXz
         5k69AVZcE39uD3dCnCNCS+XHkANfqzcUfzT46TdqwXR7u8fKQo55BU5Cdq/yQQ8SJddb
         t7DlVCyL0eNtE1dFtBRJyMU2cQUEfVCtV2CGJ65cbC+OjeZujhXdoCMq1Mmpdl0LCyj1
         mA7gvx2IORw7zk9eJm4JR3W4qFiLyw+eL1VEjcXgje2LTwOmR8GJgIEXsmVRxzAv0HUQ
         PTHmGFE97hubbcDH9sy3crMaiIDOAK8UE3XeXLdbk3UghbK6Bask48JZuO/v67qA+h4N
         mcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e5oHEvN5cdUAoS8mD1OQl++xLisYKnIOLW+OJZESkSc=;
        b=czRRNl7vWci9bo+jvvaC1r1k1+kAnI3RK30xBml9iGpy2WVj1ywS3S9/xq/nMstC+8
         ZEL6cIsPMPMIJLCDTZ0Ks9S/UmfOgslGeqeeLs0/ujQ6S8EheUsnvMUl0x63LL+bfWS6
         5eqlBCOy2ENrMuUZuia+UX2CioNFeSqb5qE9SiaixeuEYbNvUiDft0SoswTr9WP9vojA
         Gj8O1OYkYer7sM8Ol23P2rvVEvtiBNRiPydE5j+Xurj4qycYLaehgTXSwGdP5PwVjYaZ
         NDvCxy3goTsShg1J2wKGjL7ZQu72xgt2M9kCN1VRxzxUDNbW4FuYq1AFvvZmaWfjYgYf
         d9jQ==
X-Gm-Message-State: AOAM533uICAjMf3qCXnNrBdbma2FRSaiJeBAHfiAqs5zjEOhKUy93u9p
        E/nMh7dUqgpoHpRWUXCR6KYZ9KqxITQ=
X-Google-Smtp-Source: ABdhPJyZ0rR8NSm+QymuJOkEhtZQ5MCz8DRDPpnA77mAmSTd77k4CSZwTyBjeQkEfcwmBKAs7+dmWg==
X-Received: by 2002:a17:907:9705:b0:6f0:2b25:784e with SMTP id jg5-20020a170907970500b006f02b25784emr9396865ejc.76.1651154334833;
        Thu, 28 Apr 2022 06:58:54 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 07/11] udp/ipv6: clean up udpv6_sendmsg's saddr init
Date:   Thu, 28 Apr 2022 14:58:02 +0100
Message-Id: <ba41e7ce639f7d8c7c111ef1aa1b3ee6b7a97cae.1651153920.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651153920.git.asml.silence@gmail.com>
References: <cover.1651153920.git.asml.silence@gmail.com>
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
index 34c5919afa3e..ae774766c116 100644
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
2.36.0

