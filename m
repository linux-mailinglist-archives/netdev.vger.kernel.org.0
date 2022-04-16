Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C22E50339A
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238655AbiDPANr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbiDPANq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:13:46 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6418745522
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:15 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so12872166pjb.2
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ALmzQ9Q+8X6XJAsK0gGaBbMoAKqVtAapFOiAAHKn22A=;
        b=WZQQ65R3dnkZiL3jdvUIwRtrsDpT2ootgOEUwcfxhgZp8RBPu4h61CKP/M/3F66FlG
         Tl0vxQ1gyJA+/OXeezFiDYOoyfo6PNfVmDzmvWlLpIp//WxznG5/AlJpzZZDMmYM717R
         8UMFGsKuq2uOr3kqT2r0II9rvMJKJ1jdjh4rMZwA6WK9AvhMBMP0kq9LHhneNLTN1+Fy
         NtemCXI9AvS3oGXFNdyMN1wyRrLmZCEftcf7KjwyB2oPTAGOAi//E2dyC+wjJsNuuNMb
         hEjN77Dw8V8bleBfwzvEHvyrd1cdAOigcFQfk+NA/0qTTKsGHGJ2gKhJONGKQLgnMJ9R
         SWcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ALmzQ9Q+8X6XJAsK0gGaBbMoAKqVtAapFOiAAHKn22A=;
        b=74ss2RE/FzMUScPDjfbyKGaPOAvr++IRaOPCKbelfKdl6vje0s6Hp7TFTtdzeNy5NS
         LYHJ35WRAgtW7N6TDhn7JTO0EY+20gSKkiDyTOl05pFaHkRdsHQem49RQGZ1hytsMlpr
         9gqi8YfTZ22/VG7br1piHPoJgvSlegL0oXlWUudvNWXDoOK2V5T4qUTe8QlXHtIJBFGm
         cjXYSeGudUNVoun/fBdFrHcs6W3VY7Ftcf2Ur2WM4LeACRxrNS2jTXdZiUdm8oOYoEaq
         DwOIkJAZa2/J1ijx2F8Vuqr7zloax9jVEBxCaLBYjZEQlnZiy7+MIJCbCDmBMTy02yL0
         Gc0g==
X-Gm-Message-State: AOAM533vHas9NgtPmuyCiHwxi3lXttVteB07qDs6TgwjSwO65Sv0x6Uv
        EGJb1BbJB1a31Rs46qjQU6E=
X-Google-Smtp-Source: ABdhPJy60xWV+CB9xH2cUFeoGTxgRUkoh3u+C3BNlE/tXU4MoI2LA1vBPlk8u4dWzdU1g2eCGASjxQ==
X-Received: by 2002:a17:903:2445:b0:158:85bb:35f2 with SMTP id l5-20020a170903244500b0015885bb35f2mr1364329pls.123.1650067874971;
        Fri, 15 Apr 2022 17:11:14 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm5729514pjf.23.2022.04.15.17.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:11:14 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 04/10] tcp: make tcp_rcv_state_process() drop monitor friendly
Date:   Fri, 15 Apr 2022 17:10:42 -0700
Message-Id: <20220416001048.2218911-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220416001048.2218911-1-eric.dumazet@gmail.com>
References: <20220416001048.2218911-1-eric.dumazet@gmail.com>
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

tcp_rcv_state_process() incorrectly drops packets
instead of consuming it, making drop monitor very noisy,
if not unusable.

Calling tcp_time_wait() or tcp_done() is part
of standard behavior, packets triggering these actions
were not dropped.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9a1cb3f48c3fb26beac4283001d38828ca15a4d9..f95a8368981d319400d0f46b81ced954d941f718 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6580,7 +6580,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			inet_csk_reset_keepalive_timer(sk, tmo);
 		} else {
 			tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
-			goto discard;
+			goto consume;
 		}
 		break;
 	}
@@ -6588,7 +6588,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	case TCP_CLOSING:
 		if (tp->snd_una == tp->write_seq) {
 			tcp_time_wait(sk, TCP_TIME_WAIT, 0);
-			goto discard;
+			goto consume;
 		}
 		break;
 
@@ -6596,7 +6596,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (tp->snd_una == tp->write_seq) {
 			tcp_update_metrics(sk);
 			tcp_done(sk);
-			goto discard;
+			goto consume;
 		}
 		break;
 	}
@@ -6650,6 +6650,10 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		tcp_drop(sk, skb);
 	}
 	return 0;
+
+consume:
+	__kfree_skb(skb);
+	return 0;
 }
 EXPORT_SYMBOL(tcp_rcv_state_process);
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

