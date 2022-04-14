Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF865008B9
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 10:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240924AbiDNIwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 04:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbiDNIwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 04:52:06 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD27918E3E
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 01:49:41 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id k14so4255453pga.0
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 01:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=52xoWc0fpCWeHzM+yM9WHHbsetQNq9MHzCL2pPBApiI=;
        b=XWiFxMT+UWDp7Vz0jzxoFt4hqWis6mV9c69E0BRPhKjUM5aPsG0wu88vvME8Z+YPu7
         yYwd2KshY51yj+y2mEIF866q/Q6LC6Zf43yVODtJS2ZBlxDoFO9anzS2/B18+SenKUCh
         AqjwVs+jvuqsvtor65wYKc2I3aHvzm5idy3tZt8v8/ZPPI44720OUbuOnUSqpHQW/T+/
         HIrWhbjWJQUQu6ZTu7jqtP7HH9iHnXApaXs4qmCU0E7AQWKTxvyRPeS30GdQHJEu5TYK
         UK+ienUNVd1/1I0Lpba0/RTfweaen3Qgjv1TSCDsvzMWEaUxw5LkbjrT05jHzkLQwY3r
         nBvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=52xoWc0fpCWeHzM+yM9WHHbsetQNq9MHzCL2pPBApiI=;
        b=otIsg5nHDK1uLymHL722yD/OhsvEZoeAI3/G8+qyE0QJHXltCUkLGSdgNOSC1Y2dR2
         4wLoUbIfae3L6Nqs7fuWmu6aLbM6eQzoWOzkMxDiRRpd417qb5/ssdCia/M8CdkNNkbk
         i0Bgy/+WoCinB+DqyCx2D7v2wN9qcmvOBDNr+sxb4iiDrKpMX1sqzna9pz8VJDejfgZK
         /lXerm4PvHATnyTcjIYTH9PDzWstbc+Y82fnBSkG9tEATCDRyZOZtKjQ4rpKkW7BbE2c
         ujWoWN51x2tjbWdToD4MfEEsq6V46SJg5vDe6tPYySqCkxxZ6ueLUNVDzXuJv82WWHe/
         SRGQ==
X-Gm-Message-State: AOAM532G9coCQDtylF8VoAoT2k4tQHzZmOktY8XE9INkOgYABXt5jiik
        i86ZXHcX4hvGMClCUdh5U1rZPGMsBzA=
X-Google-Smtp-Source: ABdhPJyEtMUMS20fmtwUu0ewlLpWRGwpeBqHKsCaOQi3VCnjbIUZHBFPJz9SxO79zRkU414jm8r8Yw==
X-Received: by 2002:a65:4188:0:b0:39d:2197:13b5 with SMTP id a8-20020a654188000000b0039d219713b5mr1482495pgq.368.1649926180963;
        Thu, 14 Apr 2022 01:49:40 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f4-20020aa79d84000000b00505f920ffb8sm1437871pfq.179.2022.04.14.01.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 01:49:40 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Flavio Leitner <fbl@redhat.com>
Subject: [PATCH net] net/packet: fix packet_sock xmit return value checking
Date:   Thu, 14 Apr 2022 16:49:25 +0800
Message-Id: <20220414084925.22731-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
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

packet_sock xmit could be dev_queue_xmit, which also returns negative
errors. So only checking positive errors is not enough, or userspace
sendmsg may return success while packet is not send out.

Move the net_xmit_errno() assignment in the braces as checkpatch.pl said
do not use assignment in if condition.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/packet/af_packet.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c39c09899fd0..002d2b9c69dd 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2858,8 +2858,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 		status = TP_STATUS_SEND_REQUEST;
 		err = po->xmit(skb);
-		if (unlikely(err > 0)) {
-			err = net_xmit_errno(err);
+		if (unlikely(err != 0)) {
+			if (err > 0)
+				err = net_xmit_errno(err);
 			if (err && __packet_get_status(po, ph) ==
 				   TP_STATUS_AVAILABLE) {
 				/* skb was destructed already */
@@ -3060,8 +3061,12 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		skb->no_fcs = 1;
 
 	err = po->xmit(skb);
-	if (err > 0 && (err = net_xmit_errno(err)) != 0)
-		goto out_unlock;
+	if (unlikely(err != 0)) {
+		if (err > 0)
+			err = net_xmit_errno(err);
+		if (err)
+			goto out_unlock;
+	}
 
 	dev_put(dev);
 
-- 
2.35.1

