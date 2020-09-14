Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337822685DD
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgINHaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgINH35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:29:57 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C85C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:29:56 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s65so9762911pgb.0
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J9rspZOCxq8O7k+n/nXR3+KAZN7a0X66P60XNjxQOXc=;
        b=T4AYOytX8vaNExi2fr7sCjyygQ9sud0iFjejf4yCL8PAKJlSp8mf7+JIOClmaSfykH
         65J0GuYCLkw0KlBozsqMuB0QgfEPnXVlh0AFigIHa3F8zhQDsAzN+rUsBXCd6oMrgASa
         p8fJ+zSScF93OW4BoXhEpnx6CpbhZyBur6z0H53nNMVsv++eorBE8/ZN99ENl6JcUw1b
         oBJmb/WxVe4g4IOYDbmQ6JdIVhVEVX6E+9HjWM75JQbW5o4C/+c2KQwW/CpGGhXelUwB
         xLL7BvA21LCWk+q25W+F7i76g+lpcc0wLlbJePJpHvxqOXv2v3BuQcGKqyieXmahkERa
         uIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J9rspZOCxq8O7k+n/nXR3+KAZN7a0X66P60XNjxQOXc=;
        b=hYPleLvsgFqpCAATqjAynlGLzr72bPRLGS5w72PY5qOtazOTDrhb/9lbIrz+PxG5tZ
         cW9KyaydbGoF9hxKDhwRfUdJgOxbhrsyHJagulHtRMQ1eJttv/O9LKuAIqSIpo2zfe+v
         cRPt0e1VOzeVCOtGJTKwiyw//KopRbK5+/NGIyLh4+wIuVAvs+EqfPckePqFR/J5M8AP
         UF7nnm5XVrAxXDUpJRcgnMotqr7w62xM4Urka2OBSSSiCIWfK7bGV/JS/hNNBzoj9XS4
         YeINpR6N2TCexcAO2S9PKuVOE1krMoHQu+HgDOYeNhbqZQ7BvT/tLPFA7QZLTA7cVQT9
         t2qw==
X-Gm-Message-State: AOAM532fIuOm4d2wg0FiNdrjCp6aTtzMzu2oeLZRTp48TAMEpj3laus8
        SQu7jgwSmRqD5weuB2Zlwj0=
X-Google-Smtp-Source: ABdhPJzjiHiW7HAEvaEFm2N/yNeWmTny0GNRFP8lliwS4M4Bvq9843bZ1opdS1kWgMMbu40prfotPQ==
X-Received: by 2002:a62:e20a:0:b029:13c:1611:6535 with SMTP id a10-20020a62e20a0000b029013c16116535mr12218762pfi.7.1600068596399;
        Mon, 14 Sep 2020 00:29:56 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:29:55 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 01/20] net: alteon: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:20 +0530
Message-Id: <20200914072939.803280-2-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
 drivers/net/ethernet/alteon/acenic.c | 9 +++++----
 drivers/net/ethernet/alteon/acenic.h | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 8470c836fa18..1a7e4df9b3e9 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -465,6 +465,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	ap = netdev_priv(dev);
+	ap->ndev = dev;
 	ap->pdev = pdev;
 	ap->name = pci_name(pdev);
 
@@ -1562,10 +1563,10 @@ static void ace_watchdog(struct net_device *data, unsigned int txqueue)
 }
 
 
-static void ace_tasklet(unsigned long arg)
+static void ace_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *) arg;
-	struct ace_private *ap = netdev_priv(dev);
+	struct ace_private *ap = from_tasklet(ap, t, ace_tasklet);
+	struct net_device *dev = ap->ndev;
 	int cur_size;
 
 	cur_size = atomic_read(&ap->cur_rx_bufs);
@@ -2269,7 +2270,7 @@ static int ace_open(struct net_device *dev)
 	/*
 	 * Setup the bottom half rx ring refill handler
 	 */
-	tasklet_init(&ap->ace_tasklet, ace_tasklet, (unsigned long)dev);
+	tasklet_setup(&ap->ace_tasklet, ace_tasklet);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/alteon/acenic.h b/drivers/net/ethernet/alteon/acenic.h
index c670067b1541..265fa601a258 100644
--- a/drivers/net/ethernet/alteon/acenic.h
+++ b/drivers/net/ethernet/alteon/acenic.h
@@ -633,6 +633,7 @@ struct ace_skb
  */
 struct ace_private
 {
+	struct net_device	*ndev;		/* backpointer */
 	struct ace_info		*info;
 	struct ace_regs	__iomem	*regs;		/* register base */
 	struct ace_skb		*skb;
@@ -776,7 +777,7 @@ static int ace_open(struct net_device *dev);
 static netdev_tx_t ace_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev);
 static int ace_close(struct net_device *dev);
-static void ace_tasklet(unsigned long dev);
+static void ace_tasklet(struct tasklet_struct *t);
 static void ace_dump_trace(struct ace_private *ap);
 static void ace_set_multicast_list(struct net_device *dev);
 static int ace_change_mtu(struct net_device *dev, int new_mtu);
-- 
2.25.1

