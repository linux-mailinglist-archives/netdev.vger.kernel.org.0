Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838EB4D288A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 06:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiCIFsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 00:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiCIFsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 00:48:08 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89506161114
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 21:47:10 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id e15so1296996pfv.11
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 21:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A7mOymJ06pWxL93GzYhO70J42qYqkTfQfRPErUxtCBw=;
        b=az/rVPXazysJbcu6Kn5T05DycKP+ZPd2Z2IVbONRwqq9oJ+d1TPN1HfQxlGZFwXCpo
         yqYoNes35AK1Ys4AsZ94nt1NTsWnxlUejxKRQV/r+vzOhe/VOK+gB7tq67vQJSEkxV6H
         w8VddSYB732Z2t+KPV6KHCKY5HdS3YNj4KV/LtSD6VCq/1PQLwRYZi4ZsJFzBo8tkxxn
         f8DzRsGWYTiDkYLCeYH+ixT/fFyKl7Une57PHXb2gU7WZwTEjuZ7rRU6EXGJ5RwgcVwu
         8gq7z8TN/TLkIh+uZHZoAlwxzB0ApeMF5M1+2L2ewEcZeVkM23XONod5h3LcfW1f8eF3
         RQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A7mOymJ06pWxL93GzYhO70J42qYqkTfQfRPErUxtCBw=;
        b=ZMrX8zTM5UdbRIG3/oDXINZutVM+PBBHl2Db2otZXvL67Q9Q3y74XKY6uUEqI17gxC
         GIZFUbsTV0fydBFn1YDNCM0QYPFZLR18jNo33Ss0rwQABVxPIRRRvs05HchHF8x+bG4c
         zDVrnXrRjQMBf3okpXmpF9iEuBQIa3StGt8+j5Ugbhleb405wiE+Gk+rj5LhnBqES6Kz
         U2y0skBo7XAEmRYCHeA3TKQ402By4I6gZR+1+WL6H/Rsd+g9nP2BaL1Pru39KCm0vLSG
         bxW6fQXZkFmd/CExOcT4LchhjcR5BwNAl9UJna5XqotIrn8p7w5BZJKGl7aHnJih/3NJ
         UD/A==
X-Gm-Message-State: AOAM530pEO6gVMMuov76im8Ycka8idtgQuFlHTdDdBF2JR0MXpkF88gB
        s7x94cw+hyj+V3JZ1d0fUrY=
X-Google-Smtp-Source: ABdhPJwy5ygrS2tWxk3avdVPIwFkUpOH2HU+c5s1hOnQfYrPcrjoE0CrAYtl0PcSmpPI5t89ZVurcQ==
X-Received: by 2002:a65:6b93:0:b0:380:afc8:fa83 with SMTP id d19-20020a656b93000000b00380afc8fa83mr2352916pgw.279.1646804830097;
        Tue, 08 Mar 2022 21:47:10 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ec26:3a58:d9f3:4e46])
        by smtp.gmail.com with ESMTPSA id oc3-20020a17090b1c0300b001bf8c88a8c4sm4612537pjb.35.2022.03.08.21.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 21:47:09 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] tcp: autocork: take MSG_EOR hint into consideration
Date:   Tue,  8 Mar 2022 21:47:06 -0800
Message-Id: <20220309054706.2857266-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
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

tcp_should_autocork() is evaluating if it makes senses
to not immediately send current skb, hoping that
user space will add more payload on it by the
time TCP stack reacts to upcoming TX completions.

If current skb got MSG_EOR mark, then we know
that no further data will be added, it is therefore
futile to wait.

SOF_TIMESTAMPING_TX_ACK will become a bit more accurate,
if prior packets are still in qdisc/device queues.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 33f20134e3f19c1cd8a4046a2f88533693a9a912..b6a03a121e7694e3e8cc5b4f47b7954a341c966e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -688,7 +688,8 @@ static bool tcp_should_autocork(struct sock *sk, struct sk_buff *skb,
 	return skb->len < size_goal &&
 	       sock_net(sk)->ipv4.sysctl_tcp_autocorking &&
 	       !tcp_rtx_queue_empty(sk) &&
-	       refcount_read(&sk->sk_wmem_alloc) > skb->truesize;
+	       refcount_read(&sk->sk_wmem_alloc) > skb->truesize &&
+	       tcp_skb_can_collapse_to(skb);
 }
 
 void tcp_push(struct sock *sk, int flags, int mss_now,
-- 
2.35.1.616.g0bdcbb4464-goog

