Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D1224615C
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgHQIwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgHQIwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:52:34 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6324C061388;
        Mon, 17 Aug 2020 01:52:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t6so7376876pjr.0;
        Mon, 17 Aug 2020 01:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zci4NAKwohhjC6jbPEfsLcCVWXjg3g8VJKMClXGB928=;
        b=neTJjMFs5UlhpeAmvYyBjINgwTwregw/xelketaeHGUa397oY0D5VFmv6GO5eZopZp
         YdJemYr09jxlmNQmSmVgSuXZtYhju6+l5U6RJg8+yPW70AD+pkDoYseQK1wZjnY5EYZ7
         rWQJi7otG+hpUvvqr+PcISiap2eMDWJ1jQQbFsFvOOHFh1vqDKZZreKInpS7xSyC1OQx
         OPdMF1hHdvPXaRpA58i6dnczuLb1R7nOe7nO0Xp8QYCiHvWBpFlbRRh0UPAm3LHPzBTQ
         50ns1OQs14gJwWyhTBq+CTBlIM2zcG49deLsGxfGk1VGZk9NZTElcdM7h4TLBpXx4TFO
         HGhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zci4NAKwohhjC6jbPEfsLcCVWXjg3g8VJKMClXGB928=;
        b=CiNRC9udS4we/SGopFSlPFBIUjtUakGMoj2S0QUR7TW52k+Vrpb1+KGnmjutjlRBB3
         /DTE4nOYEXwXny7316ieFtnCWQQpcYb78TwuHgkKciDelZlw4VUFHilW5rI498zikKzq
         C0DEQeJe8aZCShUawotn9XJCPP4y1ATMN9mRnz9f5464RxlbM0iUXCcyPBrxuUcWLKDs
         A3wHyF7sEwfpmQ8GbVW87sByNdw9hMp/wz/HLlhPMHq5Cvh8il55YdllCPBHshzAp+nI
         5y/Hh2D9j/UyFKLMCp0yNK8TKQxlIHxHXxoUFpN96FuG/IdkZMr+kXMuK+nm3MYErbVE
         AQpg==
X-Gm-Message-State: AOAM533bHsgFF8Yshg7ML+J6i7drEzWRrrgEWWoq0trMe03zZQph4fSy
        Qz+f0QLbOByry50K+KMhfO8=
X-Google-Smtp-Source: ABdhPJyqnKZWuEQ9WtaHZx0iO8Gc5tduriJCuSHNz/iCSB5adxOK+UjF4Co+4bML4gOaDWzJUb/SqQ==
X-Received: by 2002:a17:902:7c8b:: with SMTP id y11mr10133867pll.119.1597654354468;
        Mon, 17 Aug 2020 01:52:34 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id b185sm18554863pfg.71.2020.08.17.01.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:52:33 -0700 (PDT)
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
Subject: [PATCH 8/8] net: xfrm: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:21:20 +0530
Message-Id: <20200817085120.24894-8-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817085120.24894-1-allen.cryptic@gmail.com>
References: <20200817085120.24894-1-allen.cryptic@gmail.com>
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
 net/xfrm/xfrm_input.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 37456d022cfa..be6351e3f3cd 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -760,9 +760,9 @@ int xfrm_input_resume(struct sk_buff *skb, int nexthdr)
 }
 EXPORT_SYMBOL(xfrm_input_resume);
 
-static void xfrm_trans_reinject(unsigned long data)
+static void xfrm_trans_reinject(struct tasklet_struct *t)
 {
-	struct xfrm_trans_tasklet *trans = (void *)data;
+	struct xfrm_trans_tasklet *trans = from_tasklet(trans, t, tasklet);
 	struct sk_buff_head queue;
 	struct sk_buff *skb;
 
@@ -818,7 +818,6 @@ void __init xfrm_input_init(void)
 
 		trans = &per_cpu(xfrm_trans_tasklet, i);
 		__skb_queue_head_init(&trans->queue);
-		tasklet_init(&trans->tasklet, xfrm_trans_reinject,
-			     (unsigned long)trans);
+		tasklet_setup(&trans->tasklet, xfrm_trans_reinject);
 	}
 }
-- 
2.17.1

