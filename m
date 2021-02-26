Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A70E3261A6
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 12:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhBZK6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 05:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhBZK6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 05:58:35 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8F3C061756;
        Fri, 26 Feb 2021 02:57:55 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w18so6021004pfu.9;
        Fri, 26 Feb 2021 02:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nkqZfm1IVmHlgkfrgERi5+nsYfFO9YY+14JhEYD2HfQ=;
        b=a/en15zUF4ioqnE5XPA0bez1vpCKbJQSQSt2N8kc/F5ChUb1cS8xRUtjVE/pNxpGVY
         CxBx1t/cO3O4TpQu5mFMdox+8udJxVHPmB39nYf/Ds5K8Ae+QfK9i1xfqPG5BlMCo8ma
         zNOox6I8DSquOnM9/2m08cSZVk7QGKBtUwloJo+PQvxAM306Pig/+N7vUD/aweuPr83Q
         nL96ir2FNwwI1ozhTk1HCKBvZ/n9nSvZkrtGF1d9xdhIx7upIA3V8HF+DCUSjON4P5dH
         yqZeq4xpPcBC/uys3WZi6w4g8S+cWS1L+NLwyiisWwfo2Vy5Nx9m9usILg6b2ZGZHGox
         OdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nkqZfm1IVmHlgkfrgERi5+nsYfFO9YY+14JhEYD2HfQ=;
        b=H46ZMzOSdarzDitYoNkaSN1FCREgQF8AE6oJIvhepaW2fi2PbbG9QIOjlqBST7FIVB
         zGcT4mCT6t0XYOTuzWZNTS+MeFIvk+2WmpJQVmQ5snF13DmYpH4emlb/hQD5d8dPaT3W
         vKaDuRTy6dCPTDibsud9PpyadbMSqVD664wYVbql2V2wTsBfG6L4BNZnIyJl+JdKqNO2
         BC0eJwdTs/GCYU0E8ifbDBN2uncd0E1yWaXQr+86gpLHJWvL0owo1lXzWLDhUC7smFyV
         y+UVci/wMi8cW1iOQ4PfEyVdOYHLXshRoB8+Isv7xWsgmxQ+nHX0fLilpPEEzHSDlcnb
         nEPw==
X-Gm-Message-State: AOAM533+T7TdOuzEEsmRzDVxY/YoMEYYRaduFyG6x6xxEgd+6MtvEZdk
        nx0+ogBysjaVo/vywUKOM/A=
X-Google-Smtp-Source: ABdhPJz62xOF1pYl8xcDg8Zn98lb7EuaeS4GF1FAPVvcDCO4HSMtZ1sxOf1/gTOJ7/K0tUMaVbNo1g==
X-Received: by 2002:a63:374f:: with SMTP id g15mr2459219pgn.212.1614337075362;
        Fri, 26 Feb 2021 02:57:55 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id b3sm8412038pjh.22.2021.02.26.02.57.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Feb 2021 02:57:54 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] inetpeer: use else if instead of if to reduce judgment
Date:   Fri, 26 Feb 2021 18:57:46 +0800
Message-Id: <20210226105746.29240-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In inet_initpeers(), if si.totalram <= (8192*1024)/PAGE_SIZE, it will
be judged three times. Use else if instead of if, it only needs to be
judged once.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/ipv4/inetpeer.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index ff327a62c9ce..07cd1f8204b3 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -81,12 +81,12 @@ void __init inet_initpeers(void)
 	 * <kuznet@ms2.inr.ac.ru>.  I don't have any opinion about the values
 	 * myself.  --SAW
 	 */
-	if (si.totalram <= (32768*1024)/PAGE_SIZE)
+	if (si.totalram <= (8192 * 1024) / PAGE_SIZE)
+		inet_peer_threshold >>= 4; /* about 128KB */
+	else if (si.totalram <= (16384 * 1024) / PAGE_SIZE)
+		inet_peer_threshold >>= 2; /* about 512KB */
+	else if (si.totalram <= (32768 * 1024) / PAGE_SIZE)
 		inet_peer_threshold >>= 1; /* max pool size about 1MB on IA32 */
-	if (si.totalram <= (16384*1024)/PAGE_SIZE)
-		inet_peer_threshold >>= 1; /* about 512KB */
-	if (si.totalram <= (8192*1024)/PAGE_SIZE)
-		inet_peer_threshold >>= 2; /* about 128KB */
 
 	peer_cachep = kmem_cache_create("inet_peer_cache",
 			sizeof(struct inet_peer),
-- 
2.29.0

