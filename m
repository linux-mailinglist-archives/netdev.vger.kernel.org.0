Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B65285C9A
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgJGKMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgJGKMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:12:41 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FEFC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:12:41 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 7so1058245pgm.11
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 03:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T/XYKCC2zWQ/TXZqr1X46RbRC8zh9kKIy6k3ZDTLGg4=;
        b=lVZ/qrgve8Q9Jc76SriBF6hRydhVuF4Geccethf7NFSzCI4i2yMoCfgy52f78hQub4
         BEUZ4HRwanXO2UY/WCEULbwYo67Pma6jbnauvrW0YDRTG/mUSyh9oCJl3g1lkJYhsjG+
         4Z2Q4yRZzC02FfQjFD19FXAXwlvOSn04H7Slh2pSQjC64ZbCmLDtVawYI3FdpQl1fVGh
         gOlaRpUgwBoWaNaY14qohanl6Pq07KJXnXTSg/ondVsFVFO1ACqOdSXIOwvYHwot+goh
         4mMO5xt/MroIXolBqxymX+zR3Dp5cZySEmRBbjNOGJNa5D1s+/sZM+ES5I4xRO3KUDVZ
         dsGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T/XYKCC2zWQ/TXZqr1X46RbRC8zh9kKIy6k3ZDTLGg4=;
        b=N6lVzg4jX/DaDryMvQIc1NONHi9D+njG1XvckPP+04fCa3iGuhwdVQloix6km+MWS0
         5QdqN8z7NCfWykUPO4i2HsxIeTpHRWn4/HkZCRooAXSJK3uOEQFG9HL24PrU0k7qXI4V
         e0aXrdz/nfpLgQxQvQufvcVCnyjKAjm8Xa1WKEwo0mZgCJTuQLb2hlN6VuyHUXjQCq80
         SXF5L/6DNVrbO/bx1hETEZyA9im31S6etnFosKx7cjW7SYO1Az7+IN9bMNb77ItqgpE5
         XFUWICRiB0Evr2Ar/ddqKeW29peHCyxJh9TP+VGPkJBu+C/1WZkWZrt7Gfulne4lUcDE
         ZgWw==
X-Gm-Message-State: AOAM532zrIyWveQpby84vJgDuxbAWjAVKJDTRM0Vivyp4WbVnZ28fNLV
        A3J1dxc1PG9XLgYvskX/dhQ=
X-Google-Smtp-Source: ABdhPJwJwnBu4hpjodFdybJVBSz3n18feV03BrSGzAtlWbrcvMuU0akny3MHHf9KDg4VJhL7tUokTQ==
X-Received: by 2002:a63:29c8:: with SMTP id p191mr2337835pgp.45.1602065560716;
        Wed, 07 Oct 2020 03:12:40 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id q24sm1105291pgb.12.2020.10.07.03.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:12:40 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v2 1/8] net: dccp: convert tasklets to use new tasklet_setup() API
Date:   Wed,  7 Oct 2020 15:42:12 +0530
Message-Id: <20201007101219.356499-2-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201007101219.356499-1-allen.lkml@gmail.com>
References: <20201007101219.356499-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/dccp/timer.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/dccp/timer.c b/net/dccp/timer.c
index a934d2932..db768f223 100644
--- a/net/dccp/timer.c
+++ b/net/dccp/timer.c
@@ -215,13 +215,14 @@ static void dccp_delack_timer(struct timer_list *t)
 
 /**
  * dccp_write_xmitlet  -  Workhorse for CCID packet dequeueing interface
- * @data: Socket to act on
+ * @t: pointer to the tasklet associated with this handler
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
@@ -235,16 +236,15 @@ static void dccp_write_xmitlet(unsigned long data)
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
2.25.1

