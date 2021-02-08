Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083C731430B
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 23:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhBHWcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 17:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhBHWcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 17:32:12 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D419C061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 14:31:32 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id w20so11615356qta.0
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 14:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=mcDXmCcUjjRsbxHxEdB07GNNJx+l2CLdTSrP6vvO7k4=;
        b=jC0pWo4Rj0X9aTsXn+bbTz4aysLc3UgXsG58s0yLhtIlLm0EZGN+LHgsotYgd2xA5X
         +2vlHNitPLC94OU5eGXs4QGjeJX2iF2muvW+kUqPpiYjxWbAGD12vxk0FATeR0+ob7tr
         gPW/mnWR22zffdC5WntzFCt2aycxJSze2m/1K3jaiRJry9kDiR9H7/2gKt6EmA6LY+Uk
         MiFdbcZVvLETav/o0Rda8j6+tOLtngqlu4/09+BXer1TPmZbcyKppiLUeM9BpkL6zRTL
         44CBT/XNxSK25uDO5IwEmJ1Kv8zGLl4YQe/sjGGWCp8qJ5CB4HZcjS2FoY+zUryMb7an
         xwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=mcDXmCcUjjRsbxHxEdB07GNNJx+l2CLdTSrP6vvO7k4=;
        b=on1JrsAT8FcmCmUZ/HajsLFLz5w3XCMhAo6MNkvRhBTtrtSVfb/TZpq02nGAHkfSMr
         gMUW3ZJjINwUA3JbArjA69aem68Lccc9Rs3l5kCrhCSg2zoQIpgs7yKAD/o4gi6q/jLN
         aT8hOjyTefN6g4wyRgWqNNBF8cmNoNFuj0lPrf0DywQPBK+aDQuMk7MFT4syhdVcIx7p
         6NcPpARMPmDIZEy9SWnFR3eMzyEPi7Y7nBQwGbvIzs3itR7F0ppxZldJEKhVZj1/8sfY
         LwIK2OZdYVpE+7IWNvGzZE37Pc1IMIu5QA4LIG/T9oytNLkc4XysbeoJxiE7nuX6rccA
         YIKQ==
X-Gm-Message-State: AOAM5300tAMXq1ypqXpwv/RP/4bdrj5SfJUbVkoK7w6onn4+2/lejNZX
        AQF00qKallU0fVk5JDVOsxU=
X-Google-Smtp-Source: ABdhPJyo1IQ1mZ6ItemKhMagWlI+4u9/dEWfw7VLMovnJAThZoaon+iyWASvJkd6tH5PEfv7lTGQDg==
X-Received: by 2002:a05:622a:216:: with SMTP id b22mr17021782qtx.163.1612823491406;
        Mon, 08 Feb 2021 14:31:31 -0800 (PST)
Received: from localhost.localdomain ([50.39.189.65])
        by smtp.gmail.com with ESMTPSA id q204sm158435qka.84.2021.02.08.14.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 14:31:30 -0800 (PST)
Subject: [net-next PATCH] net-sysfs: Add rtnl locking for getting Tx queue
 traffic class
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, atenart@kernel.org
Date:   Mon, 08 Feb 2021 14:29:18 -0800
Message-ID: <161282332082.135732.12397609202412953449.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

In order to access the suboordinate dev for a device we should be holding
the rtnl_lock when outside of the transmit path. The existing code was not
doing that for the sysfs dump function and as a result we were open to a
possible race.

To resolve that take the rtnl lock prior to accessing the sb_dev field of
the Tx queue and release it after we have retrieved the tc for the queue.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/core/net-sysfs.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index daf502c13d6d..91afb0b6de69 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1136,18 +1136,25 @@ static ssize_t traffic_class_show(struct netdev_queue *queue,
 				  char *buf)
 {
 	struct net_device *dev = queue->dev;
+	int num_tc, tc;
 	int index;
-	int tc;
 
 	if (!netif_is_multiqueue(dev))
 		return -ENOENT;
 
+	if (!rtnl_trylock())
+		return restart_syscall();
+
 	index = get_netdev_queue_index(queue);
 
 	/* If queue belongs to subordinate dev use its TC mapping */
 	dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
 
+	num_tc = dev->num_tc;
 	tc = netdev_txq_to_tc(dev, index);
+
+	rtnl_unlock();
+
 	if (tc < 0)
 		return -EINVAL;
 
@@ -1158,8 +1165,8 @@ static ssize_t traffic_class_show(struct netdev_queue *queue,
 	 * belongs to the root device it will be reported with just the
 	 * traffic class, so just "0" for TC 0 for example.
 	 */
-	return dev->num_tc < 0 ? sprintf(buf, "%d%d\n", tc, dev->num_tc) :
-				 sprintf(buf, "%d\n", tc);
+	return num_tc < 0 ? sprintf(buf, "%d%d\n", tc, num_tc) :
+			    sprintf(buf, "%d\n", tc);
 }
 
 #ifdef CONFIG_XPS


