Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FA346703B
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350572AbhLCCvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378260AbhLCCvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:11 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B845C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:48 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 133so1603651pgc.12
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SqS8l1rp8xDuoheLvvuPOhg+iERtHrbdIDpDHRwHj/U=;
        b=MLyQfQC2zvqH+yfZalUdKyMmR8LnP1rs7rYn4ffvFljXamsINOmgFpd67bjYSN2Io0
         yl7xkHH3p6zazd4uA9d44UrDFyPwOb+LoAfXJ9ehk91x0tuIzbQY2iqDqKPL5JVeTsQF
         kQsLpolb1AVAA7mu5MGfrME7Kl05hW1rbHKAnqfatuDd2IbXmebnWRp+7A9IbTCyxWRq
         O8KXVL6FaIQYlLY0ZaHTZxrSHLMMeUg6R8ijknlRz6rwolnALq8+UBqSh2VdtYmWAJDO
         4eXmgM2NpEmHvLDX9FdaPGrMYFSQ74D+48FeUpJ7zVVm8jQ5jR6VvBgx0WSNzbFReSFm
         gbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SqS8l1rp8xDuoheLvvuPOhg+iERtHrbdIDpDHRwHj/U=;
        b=2RVJCdGjEcsEZHITJtZoAxzgGV5ezce4e2Ag9NXQr4JwkAFszBBykv/F59Kdtl/uyZ
         vP9qn1t/EQraq9o8D2Vag4jz7pgkjCque5iQy/WtQfOXIBm+MhFTsj2HhI41LgezsSwx
         mDqYksW3Zfu78PZ8pzFBfXtCLkGghycoOfWyU0L625FsnNZ/iZz9VcrTlrFgdWRgPhjZ
         JuFmRx2KI4PCjfQ16cEOokJzf0aSAFoy208TS/8PIxsTpkosBE3GyaXQ9YQCNHU8E4ts
         FuS8BcexecMIgGl4gHKrYcPP6jCmId/qQ3SG1WTVwAjuneGzWmWGyEV4jGc6AqdFeQGf
         ENBw==
X-Gm-Message-State: AOAM5322BHHqXpzJkH1tfOEUPH/zZCB7Lj5ElLNlPXywHmW8hr6wh087
        1yUKNO0YwsqEV9gshcGW6Zg=
X-Google-Smtp-Source: ABdhPJxXfcFLG69xpkEwlE4Dssyqw7E5wtSCIFfrqk3hr6iiYISw3uZ65TKAs+YYmbM3NleRHdzfNA==
X-Received: by 2002:a65:6902:: with SMTP id s2mr2427887pgq.457.1638499668091;
        Thu, 02 Dec 2021 18:47:48 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:47 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 10/23] ipv6: add net device refcount tracker to rt6_probe_deferred()
Date:   Thu,  2 Dec 2021 18:46:27 -0800
Message-Id: <20211203024640.1180745-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/route.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index ba4dc94d76d63c98ff49c41b712231f81eb8af40..8d834f901b483edf75c493620d38f979a4bcbf69 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -593,6 +593,7 @@ struct __rt6_probe_work {
 	struct work_struct work;
 	struct in6_addr target;
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 };
 
 static void rt6_probe_deferred(struct work_struct *w)
@@ -603,7 +604,7 @@ static void rt6_probe_deferred(struct work_struct *w)
 
 	addrconf_addr_solict_mult(&work->target, &mcaddr);
 	ndisc_send_ns(work->dev, &work->target, &mcaddr, NULL, 0);
-	dev_put(work->dev);
+	dev_put_track(work->dev, &work->dev_tracker);
 	kfree(work);
 }
 
@@ -657,7 +658,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 	} else {
 		INIT_WORK(&work->work, rt6_probe_deferred);
 		work->target = *nh_gw;
-		dev_hold(dev);
+		dev_hold_track(dev, &work->dev_tracker, GFP_KERNEL);
 		work->dev = dev;
 		schedule_work(&work->work);
 	}
-- 
2.34.1.400.ga245620fadb-goog

