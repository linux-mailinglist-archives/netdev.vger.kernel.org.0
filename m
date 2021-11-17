Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1BC453EEE
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhKQDc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbhKQDc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 22:32:27 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E65C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:29:30 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so1261295pjb.4
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Babaruj0XBTQborZwEH4EzaqrqMRkYLo0Z0jQCwEXI=;
        b=J546tGnJO6lHrf/f2gcX4i6sj6YaBpFs4mEmARux7q/nnC3lmfshZ43j3gyqwvhZeg
         T0NpERzBFHL2GbA7rLCLinIHQhk/9g1sOyBBWT7SjpS9bFKR+9SGNmbCnH/3FQcFxkez
         sqGy5N+N4PCWtblHAhKxzl2m+GwqA5U2VIZj+J6KAbhunGow7e3AE8lWZohdCXSjZmGJ
         P3lljob8Fc7np9EFOgDpKid+w+FoLIVOOnoaBoS1PakqPyG8i0SGFf+fJ4ShD4IGxbvL
         Utz+sOjQCDsXQrhp8rnfTxB19omkVk6sswKUUNFW2ZJfBuJwTLZqa/C/Ue7KGfPK7kE8
         uWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Babaruj0XBTQborZwEH4EzaqrqMRkYLo0Z0jQCwEXI=;
        b=LRGRnz6P3OlvkZWCeDK5DOHq6uhuOAnS4LWfG//hkFtIoqAJkktNGyvwdAG1Epn4l6
         4HL7Goz0PYzlKB1dqZO69IsmHFV1pTwbW2wt42yyvSbXukUq3BAqcgOpZRb3MLwkhJcC
         zbjsJnj16+O0UgyQGl0GnD+tf0SD0naZmUOlbhZaHHES0p+vLIW/p5z0effv29mT9BN7
         l6p6OHBlYbRsO66Gl0B0f73Vyma9r3HqnPZbmgyYFQHeNoq7mFw410U5g2ZovvcCaA5m
         GtMT5cUYz0SFJNKTIwmbqO4B5KwhsRXVMXwlGICcWcpdrG3RGVDf3THaFudchrBVSHO+
         QIfg==
X-Gm-Message-State: AOAM5308onSo+H47E9Jz4xsUNjHqmlja+3Wswb0L1v26RM878Usk++5J
        zGp+rEflqnmRDLuhc7IocYc=
X-Google-Smtp-Source: ABdhPJzObVibw5jI5htLJiUXBe2cb+93f4eA/E6SrBycBNejf+JKTC+nRlMDUtk2qQvGx8HMrfhC0A==
X-Received: by 2002:a17:90b:97:: with SMTP id bb23mr5383133pjb.201.1637119769629;
        Tue, 16 Nov 2021 19:29:29 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bea:143e:3360:c708])
        by smtp.gmail.com with ESMTPSA id mi18sm4042394pjb.13.2021.11.16.19.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 19:29:29 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        david decotigny <david.decotigny@google.com>
Subject: [PATCH net-next 1/4] net: use an atomic_long_t for queue->trans_timeout
Date:   Tue, 16 Nov 2021 19:29:21 -0800
Message-Id: <20211117032924.1740327-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211117032924.1740327-1-eric.dumazet@gmail.com>
References: <20211117032924.1740327-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tx_timeout_show() assumed dev_watchdog() would stop all
the queues, to fetch queue->trans_timeout under protection
of the queue->_xmit_lock.

As we want to no longer disrupt transmits, we use an
atomic_long_t instead.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: david decotigny <david.decotigny@google.com>
---
 include/linux/netdevice.h | 2 +-
 net/core/net-sysfs.c      | 6 +-----
 net/sched/sch_generic.c   | 2 +-
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 31a7e6b2768123021690a3dc8572c5e8cb0e0027..143ac02c7f1cc90cf6704574fb0012e1ba830c70 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -592,7 +592,7 @@ struct netdev_queue {
 	 * Number of TX timeouts for this queue
 	 * (/sys/class/net/DEV/Q/trans_timeout)
 	 */
-	unsigned long		trans_timeout;
+	atomic_long_t		trans_timeout;
 
 	/* Subordinate device that the queue has been assigned to */
 	struct net_device	*sb_dev;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9c01c642cf9ef384fe54e56243b102ef838d0a62..addbef5419fbb62ce83f5132ae21c9d2872e95f5 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1201,11 +1201,7 @@ static const struct sysfs_ops netdev_queue_sysfs_ops = {
 
 static ssize_t tx_timeout_show(struct netdev_queue *queue, char *buf)
 {
-	unsigned long trans_timeout;
-
-	spin_lock_irq(&queue->_xmit_lock);
-	trans_timeout = queue->trans_timeout;
-	spin_unlock_irq(&queue->_xmit_lock);
+	unsigned long trans_timeout = atomic_long_read(&queue->trans_timeout);
 
 	return sprintf(buf, fmt_ulong, trans_timeout);
 }
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 3b0f620958037eb46e395f172c2315fdd98be914..1b4328bd495d54d44a9d51b53c8e8bc18b9cc294 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -467,7 +467,7 @@ static void dev_watchdog(struct timer_list *t)
 				    time_after(jiffies, (trans_start +
 							 dev->watchdog_timeo))) {
 					some_queue_timedout = 1;
-					txq->trans_timeout++;
+					atomic_long_inc(&txq->trans_timeout);
 					break;
 				}
 			}
-- 
2.34.0.rc1.387.gb447b232ab-goog

