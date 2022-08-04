Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261485895D8
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 04:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbiHDCKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 22:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238815AbiHDCKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 22:10:07 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF995FAC6;
        Wed,  3 Aug 2022 19:10:06 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id q3so14247896qvp.5;
        Wed, 03 Aug 2022 19:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ryAwNGrW/zNWRU/n0Vrh+3u0JLChoMJ0BiRRlgoBG8M=;
        b=L26ghPJl+d8Avfsqq+BtKVAjZDCcpALpykn5pFBHYmsj0YlEZYBsxtlV11AyEgQzZi
         7Gjd+xTvQ0lqwVYK90hwaC5L+SQkqRR8Bj5bhH4RcATGq0lfhLq/of5EOf82W95hZ4b1
         bACjfDn7s7dzj8VO9ruFWTM8FFbzAfFXjJPfEpg4JkFkGiTu39HzS2oMTL+JlrVXVtS9
         YHLbEaF3hWV4vQfG5m3iZpeBa3RGju+zzfg/qXe4SEDyxPBFAXhSDyGCBkEaSd8xvEgL
         x0PCWigGZEHiBGcWyqzvak2xfJjiUl8MakvGRTMiTfMQv1I2K81msHYlvlPVYyLD3mMq
         pZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ryAwNGrW/zNWRU/n0Vrh+3u0JLChoMJ0BiRRlgoBG8M=;
        b=UnMFxv8T30xyeF5WgDnvZ+K0H31WxP/FCQSbZ4cXOEpj/86Ny8Wf7EiLQq0fYvJu8V
         uMM9fKEyPnEZxoZZaxhkKa2wAf7IW75/3VtFiv7FOBXxnzC8ajdn597KIRO8gHxuW1Mz
         PgDnwEnxnUkHUq45MIqNO3Xds2yErzSTBH6lU0w+cXvN2Dq8X2dbPudNvthXVJJ+QJUG
         m0ia/ejxqWhT4cOwbl3Tk2VZeLGKPOwrly11a3hIT75BEdy6OQ5YFCs4kOQqSjSbrn0k
         YWiFN4heR9sn5RXlceQLKONW8STID9oKaJG8mgxvfR7EqOb8cVdCkPclu7xE9NeLKzk5
         GByg==
X-Gm-Message-State: ACgBeo1VMjJbIjHPHVu2e4r7R34Pe2I2yDL2LHAV+mPXa2PhWM/00lbP
        jq6WSNMjnJALd2NQo7/UriorXdlOUA==
X-Google-Smtp-Source: AA6agR7el9tcxV4nWCFBnB41rmuBjV6aa8JwA2QBa29vugGEEkt9HD5/q6v/fBlXXnFiaD3YPTmVNw==
X-Received: by 2002:a05:6214:226d:b0:476:564c:ee73 with SMTP id gs13-20020a056214226d00b00476564cee73mr18411247qvb.77.1659579005172;
        Wed, 03 Aug 2022 19:10:05 -0700 (PDT)
Received: from bytedance.bytedance.net ([74.199.177.246])
        by smtp.gmail.com with ESMTPSA id l3-20020a05620a28c300b006b61b2cb1d2sm14004792qkp.46.2022.08.03.19.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 19:10:04 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH RFC net-next] vsock: Reschedule connect_work for O_NONBLOCK connect() requests
Date:   Wed,  3 Aug 2022 19:09:25 -0700
Message-Id: <20220804020925.32167-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: Peilin Ye <peilin.ye@bytedance.com>

An O_NONBLOCK vsock_connect() request may try to reschedule
@connect_work.  Consider the following vsock_connect() requests:

  1. The 1st, non-blocking request schedules @connect_work, which will
     expire after, say, 200 jiffies.  Socket state is now SS_CONNECTING;

  2. Later, the 2nd, blocking request gets interrupted by a signal after
     5 jiffies while waiting for the connection to be established.
     Socket state is back to SS_UNCONNECTED, and @connect_work will
     expire after 100 jiffies;

  3. Now, the 3rd, non-blocking request tries to schedule @connect_work
     again, but @connect_work has already been scheduled, and will
     expire in, say, 50 jiffies.

In this scenario, currently this 3rd request simply decreases the sock
reference count and returns.  Instead, let it reschedules @connect_work
and resets the timeout back to @connect_timeout.

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Hi all,

This patch is RFC because it bases on Stefano's WIP fix [1] for a bug [2]
reported by syzbot, and it won't apply on current net-next.  I think it
solves a separate issue.

Please advise, thanks!
Peilin Ye

[1] https://gitlab.com/sgarzarella/linux/-/commit/2d0f0b9cbbb30d58fdcbca7c1a857fd8f3110d61
[2] https://syzkaller.appspot.com/bug?id=cd9103dc63346d26acbbdbf5c6ba9bd74e48c860

 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 194d22291d8b..417e4ad17c03 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1395,7 +1395,7 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 			/* If the timeout function is already scheduled, ungrab
 			 * the socket refcount to not leave it unbalanced.
 			 */
-			if (!schedule_delayed_work(&vsk->connect_work, timeout))
+			if (mod_delayed_work(system_wq, &vsk->connect_work, timeout))
 				sock_put(sk);
 
 			/* Skip ahead to preserve error code set above. */
-- 
2.20.1

