Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E20A4BBEDC
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 18:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbiBRR7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 12:59:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238877AbiBRR7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 12:59:17 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F7910A2
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 09:59:00 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id z4so8484754pgh.12
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 09:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bx6RiUgET9DPFe/GsmAXrJ7N4qhEJSAPK1731DhGyqg=;
        b=Y4rNz0QLktG2HLZNnfNFPW0D69GDlb7fFLMJHbS1WtNavixJI2pvygfsi7N3jdAQR/
         YEJNQR2bkf6TzVxFwnLmLMK/QrhzCVej7s6SyY9IiGp7CxtqKZ9jerzITUtMO2W6xLGh
         6YwGZ+YhnHIp3pJLK36JeowN8LP/+p2O09q6w+h+d4P1pG0UC8nz+43KbBmxj/3WCMu0
         kYYUFyZrGNzyR+37eZQUYR2X5y1cNo1CvWKrNhEHzv+6J07A+bCAj9fEM8k6BHG2qNSt
         WMWaZaTE4FScYSpWOU3hirdybuFEumIKGF/PP9hVG065kbrVFhdd7n3faTaTRdCb3GQQ
         ZjZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bx6RiUgET9DPFe/GsmAXrJ7N4qhEJSAPK1731DhGyqg=;
        b=rQTeBL2SZckfGD9DURsyyXe/Xs7In/WIyrJ2diTowITSQ1LHGAy2JLmvmjuPvshZdN
         VF7ODrACiO3NJkRm7AkK1dRDf5qoRPH/giU7Yxt1QR3UIk1XBLyN56LYnjFDmeQltaXH
         aX11kQN4aiYwmoVok3u2FZcPbKKYW2sGf7r3D9urtAlT06akWPQxbDEeOAwnrvyeftel
         QKAAU0zSEiRa9mJn7TykNFX5ozyz0WzIHT5chn+JV1HTYTTXw3RXZOfjOGHnT7WYXHSL
         LdtAmlhCeDU+1JxEOZpvIeEhTYlw52qhtOAUPKOl3X+vQsQr0bKcRh7DrzZxlej2k31g
         AkaQ==
X-Gm-Message-State: AOAM533c02yGCQQN5AgdPLsoxM5wxkyj2a4/+tFG4BiT9rNrnYlf6oDu
        rVKxmSdY4A8/y0cM7autjAY=
X-Google-Smtp-Source: ABdhPJwtuA3bS6QAsb4fs5LmK0nbVaaOFXYY9+/uAUn4veSf3wHpHZf8P2yfIdDWsE78HSvsIhWQLw==
X-Received: by 2002:a65:41c3:0:b0:363:5711:e234 with SMTP id b3-20020a6541c3000000b003635711e234mr7178078pgq.386.1645207140369;
        Fri, 18 Feb 2022 09:59:00 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5c60:79a8:8f41:618f])
        by smtp.gmail.com with ESMTPSA id c9sm3718370pfv.70.2022.02.18.09.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 09:58:59 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: get rid of rtnl_lock_unregistering()
Date:   Fri, 18 Feb 2022 09:58:56 -0800
Message-Id: <20220218175856.2836878-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
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

After recent patches, and in particular commits
 faab39f63c1f ("net: allow out-of-order netdev unregistration") and
 e5f80fcf869a ("ipv6: give an IPv6 dev to blackhole_netdev")
we no longer need the barrier implemented in rtnl_lock_unregistering().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 42 ------------------------------------------
 1 file changed, 42 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index acd884910e12a040841e1e0525e0d4bc5e3ee799..a1190291c48e6cdb7fd20916793f72e2aac668cc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10884,36 +10884,6 @@ static void __net_exit default_device_exit_net(struct net *net)
 	}
 }
 
-static void __net_exit rtnl_lock_unregistering(struct list_head *net_list)
-{
-	/* Return (with the rtnl_lock held) when there are no network
-	 * devices unregistering in any network namespace in net_list.
-	 */
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	bool unregistering;
-	struct net *net;
-
-	ASSERT_RTNL();
-	add_wait_queue(&netdev_unregistering_wq, &wait);
-	for (;;) {
-		unregistering = false;
-
-		list_for_each_entry(net, net_list, exit_list) {
-			if (atomic_read(&net->dev_unreg_count) > 0) {
-				unregistering = true;
-				break;
-			}
-		}
-		if (!unregistering)
-			break;
-		__rtnl_unlock();
-
-		wait_woken(&wait, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
-		rtnl_lock();
-	}
-	remove_wait_queue(&netdev_unregistering_wq, &wait);
-}
-
 static void __net_exit default_device_exit_batch(struct list_head *net_list)
 {
 	/* At exit all network devices most be removed from a network
@@ -10930,18 +10900,6 @@ static void __net_exit default_device_exit_batch(struct list_head *net_list)
 		default_device_exit_net(net);
 		cond_resched();
 	}
-	/* To prevent network device cleanup code from dereferencing
-	 * loopback devices or network devices that have been freed
-	 * wait here for all pending unregistrations to complete,
-	 * before unregistring the loopback device and allowing the
-	 * network namespace be freed.
-	 *
-	 * The netdev todo list containing all network devices
-	 * unregistrations that happen in default_device_exit_batch
-	 * will run in the rtnl_unlock() at the end of
-	 * default_device_exit_batch.
-	 */
-	rtnl_lock_unregistering(net_list);
 
 	list_for_each_entry(net, net_list, exit_list) {
 		for_each_netdev_reverse(net, dev) {
-- 
2.35.1.473.g83b2b277ed-goog

