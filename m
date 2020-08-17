Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0647C24612F
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgHQIvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgHQIvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:51:37 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B26C061389;
        Mon, 17 Aug 2020 01:51:36 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y10so5603518plr.11;
        Mon, 17 Aug 2020 01:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wOFnP+mIOUunUyi6RmfOX+Q5ALinLxcvae3Yp9Ni+zM=;
        b=FhPl0yESGUE8TFhEMqa043m95wRC5RdMMRPdR5UgsrxCgGMSnZzudvjAwnJEl2hIJ1
         oGndCZEaXVgoEMpGLQWbDq4g3kJ7z95+EP4HzK121db5e9kS55CzPp0XdHralL2dfHQh
         dgpDPajBcs1sN12jaJpV3bPULcS4nizJvfIo9rn/3fx7vilSqLpMAKagKZrY7/vxomUR
         /JvCYcmXLl2q9Y472Ww1UkCTwD/85BnJRzs3v8oBCg2Xd0tNW8YFSoJqcc2ADB76cSwb
         2ZTQh2o3tq+8V+wdji6oB02Wot5qgPQpO+XpR/ggCT5pnQeKTXhPd1Wd60Oid5sZ9psL
         3KfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wOFnP+mIOUunUyi6RmfOX+Q5ALinLxcvae3Yp9Ni+zM=;
        b=CcRbs4NcmDfom0OZH1z12y9Az0knzvKtAXBvdPAlAmhVy7MLX3gYqZFk92cfchySs8
         V1z/WJBpc/YBY/arZRTIRxuK8lKRNW4Btjt7XIhSADpdFbC6hxsXtrf9SYDSeFAiWzlF
         Y9pRxjfnPtPvMwTxcAo6oqSDNNuRlKXJvCcbVZ78vFZ3KSe4oPOcXBTFmYqh5pGi9fKM
         h8Znui2VSWjxfqgwstPJxzsv6YijPaZ35IjtUBmTjfwWqs3gCUzuFrlNMb6hN8z4fY6B
         W614ZG4c77J5MoAE7WXMmMijEGlLa1cahLdasAbdEH+TYh1oO1WfCsoVLBwIrwoaODld
         1UVQ==
X-Gm-Message-State: AOAM533EhBRQei4eartpp5/gbi7csWF8Jrsd7ZPw7ll6si5wUR2dk39R
        Jd+HVHI6Dc4RFfvMqucguvo=
X-Google-Smtp-Source: ABdhPJwkHrfrADxoARIyFesLt8svDhCVc8Neq3PWKmf9xTMPVNTGXJJNDk1NroIFsEd4Jvyoxz8amQ==
X-Received: by 2002:a17:90b:1493:: with SMTP id js19mr10627721pjb.223.1597654296487;
        Mon, 17 Aug 2020 01:51:36 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id b185sm18554863pfg.71.2020.08.17.01.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:51:35 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 1/8] net: dccp: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:21:13 +0530
Message-Id: <20200817085120.24894-1-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 net/dccp/timer.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/dccp/timer.c b/net/dccp/timer.c
index 0e06dfc32273..f174ecb2fb4e 100644
--- a/net/dccp/timer.c
+++ b/net/dccp/timer.c
@@ -220,9 +220,10 @@ static void dccp_delack_timer(struct timer_list *t)
  *
  * See the comments above %ccid_dequeueing_decision for supported modes.
  */
-static void dccp_write_xmitlet(unsigned long data)
+static void dccp_write_xmitlet(struct tasklet_struct *t)
 {
-	struct sock *sk = (struct sock *)data;
+	struct dccp_sock *dp = from_tasklet(dp, t, dccps_xmitlet);
+	struct sock *sk = &dp->dccps_inet_connection.icsk_inet.sk;
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk))
@@ -236,16 +237,15 @@ static void dccp_write_xmitlet(unsigned long data)
 static void dccp_write_xmit_timer(struct timer_list *t)
 {
 	struct dccp_sock *dp = from_timer(dp, t, dccps_xmit_timer);
-	struct sock *sk = &dp->dccps_inet_connection.icsk_inet.sk;
 
-	dccp_write_xmitlet((unsigned long)sk);
+	dccp_write_xmitlet(&dp->dccps_xmitlet);
 }
 
 void dccp_init_xmit_timers(struct sock *sk)
 {
 	struct dccp_sock *dp = dccp_sk(sk);
 
-	tasklet_init(&dp->dccps_xmitlet, dccp_write_xmitlet, (unsigned long)sk);
+	tasklet_setup(&dp->dccps_xmitlet, dccp_write_xmitlet);
 	timer_setup(&dp->dccps_xmit_timer, dccp_write_xmit_timer, 0);
 	inet_csk_init_xmit_timers(sk, &dccp_write_timer, &dccp_delack_timer,
 				  &dccp_keepalive_timer);
-- 
2.17.1

