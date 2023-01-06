Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F86966020C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbjAFOZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjAFOZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:25:26 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3647BDE3
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:25:25 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-46839d9ca5dso19259067b3.16
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 06:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bd8ai8qv1wKopdO9WVErBGIsnnYrc0zRGIlCsBo5A0k=;
        b=khFqWr4rRt/kd7KsJe+IbnPEUw0zk+PAyTmaf0nOWvVgj4JATxYs3QXHB0IkyPvbP5
         sIWehjHQvo1xfdXsXHVnPk2lPkZoNU/I3h+KGfjbzCa+sLW/f0sI7/u0BViKXLQz1YlK
         KEXJfVDp5kHoq3nUO4NPSvxymx4UF1keK3cgQelycnC8b7VMb7SMmLjYxTAx1oV3Qtec
         k07hHLkr8pOxQB0gLQ4i4cLX/ntgUR5SnRJ9uK9GRog0H8iM54v+lJf09yxfid6XorF8
         bC+Bi7s/2s91DLHjVy/C8Or0jPDnMvHe3X0yLBQ5wjJK0+iiR5N3B4HDjm9gBhpLgLvD
         TNWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bd8ai8qv1wKopdO9WVErBGIsnnYrc0zRGIlCsBo5A0k=;
        b=Ek6F9m7E1m3FKsXwd8H9MmQRtMCushpl2TSqJxMr4hP3PL29BrSAq0b4A4M1Qxrv6F
         em/Ltxd2eFEgdRbW3Imz4ZJ0S3AsIAXUu1/EFo7VCyLcORsfeheKc/SL8TpBSm32Iqfk
         9e3SUM1gQGwSjdCMZydalChYPNWHudt3Qe//h5zA0M78SltVQ/uU048qLOWFaCnVdk9M
         phODZvB9O90YXtvlIl+iZa3Y1n8rq85xDrEtrOdeIbebIrqtaHMgTLLouUT/S+M5hySb
         xXSb25d2vDF5yXX/tDmaoJGFfFeB75CsXIHFyw61tBGX9VgifYSmwf78sUtWJuXpkb7v
         LI1g==
X-Gm-Message-State: AFqh2kq8+EPbmnQmyzLa0Jx7+yca3Z6UaLygPZG6W6UrEoWBWPXrNezV
        h1GJmU12LGxhiT8neQOHgTydaXeuxpqd4w==
X-Google-Smtp-Source: AMrXdXvncwNeqXe9cfyayVKATafrskSsVmKnrpyjZszYuGCh7YRMzZ8CaI2MP+Nmo/MWVrLn03xLCuyqTeBMhg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:4f4b:0:b0:36a:bc93:587c with SMTP id
 d72-20020a814f4b000000b0036abc93587cmr341337ywb.59.1673015124797; Fri, 06 Jan
 2023 06:25:24 -0800 (PST)
Date:   Fri,  6 Jan 2023 14:25:23 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106142523.1234476-1-edumazet@google.com>
Subject: [PATCH net] gro: take care of DODGY packets
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jaroslav reported a recent throughput regression with virtio_net
caused by blamed commit.

It is unclear if DODGY GSO packets coming from user space
can be accepted by GRO engine in the future with minimal
changes, and if there is any expected gain from it.

In the meantime, make sure to detect and flush DODGY packets.

Fixes: 5eddb24901ee ("gro: add support of (hw)gro packets to gro stack")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-and-bisected-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc: Coco Li <lixiaoyan@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 net/core/gro.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index fd8c6a7e8d3e2e6b439109d0089f44a547c7347e..506f83d715f873c9bc3727e28ace71e00fa79d2f 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -505,8 +505,9 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	NAPI_GRO_CB(skb)->count = 1;
 	if (unlikely(skb_is_gso(skb))) {
 		NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
-		/* Only support TCP at the moment. */
-		if (!skb_is_gso_tcp(skb))
+		/* Only support TCP and non DODGY users. */
+		if (!skb_is_gso_tcp(skb) ||
+		    (skb_shinfo(skb)->gso_type & SKB_GSO_DODGY))
 			NAPI_GRO_CB(skb)->flush = 1;
 	}
 
-- 
2.39.0.314.g84b9a713c41-goog

