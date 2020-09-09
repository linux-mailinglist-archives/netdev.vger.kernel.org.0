Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84616262ABD
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgIIIpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgIIIp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:45:26 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D505C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:45:26 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x123so1545006pfc.7
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H6jpxBumaCDaO159OdBzGuWOvuYBCCMGOhfIY3efDD4=;
        b=e87TfbEkOHmeaLvVEBSQ7eb9fxhktr6xDmp+PEBR6mc0ihepS4rhjT/YYh++bHhZvX
         mEnECIs+bxba1OrKreGLWtwjiRam9H2W/RnHgLbd4e/vdVcC7DbSyNrIpZe3cY0YRkSw
         qpjm4iZft/DI/7+ZMk4o4uzPjzugngXfJgPFXiyjsnp/jA/qvUH7LX55EuS138EhgwCI
         UdeGcIIUAe7NJnTmDO28MBHReL2EqUjq3EdmXORzeecKbbw5pVgSm4WOOGhTHLwmGqS8
         1SeJQ6OUhjdZX/OsLVyv6J6zGA7CIm7JrWyDdDukGR39CzCDEkaVbhtl9GU1SshSDEiU
         a5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H6jpxBumaCDaO159OdBzGuWOvuYBCCMGOhfIY3efDD4=;
        b=M9xG51XCrm5Yw0IHxmx98XhEAkLGvGI1duLgIPdeUWHuJx/ea6LRWHRCc80MFD3HMI
         Xf9NKEetOKaP06NiftE+84cCxlmrpfMgSjEY5p6g0eOGBK4Js5ZfHkuFSK4K/c1yAepS
         K2TSTf2XJqYaoa9Ho6tZ5N1vRFyN8aM/znTPR8NVNPnTm73Kf+pL7dT1N6pSUVWa2oWI
         jRPEV1rtSA0+/THoe3abbVkPh5bwlYSk1oggyAvL9NRd6q1ZsnwqVndUZ1zbNnxotWu1
         5l2VfANswfY30Er2mntnP2c6AlGc3lSCdFpqrtO3KThV3FiFAxf1Sg/ImysZQhPEOCRy
         9NRg==
X-Gm-Message-State: AOAM5335YBIRplaUQ6Jyx5rS5bs2sbrNNIwLnLBLGFvajoj0I8A3FN0g
        Lz4COXzpW9tiPXFdmREReL0=
X-Google-Smtp-Source: ABdhPJxywGQDK4mrr4Ox0qvLTc3cHcRpc08xN3fFnx6hXG/45uNjqgqEt93Syhe6yiAgrkirt+OTUg==
X-Received: by 2002:a17:902:7d92:: with SMTP id a18mr1558034plm.68.1599641125661;
        Wed, 09 Sep 2020 01:45:25 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:45:25 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 01/20] ethernet: alteon: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:14:51 +0530
Message-Id: <20200909084510.648706-2-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/alteon/acenic.c | 9 +++++----
 drivers/net/ethernet/alteon/acenic.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 8470c836fa18..056afc8bb519 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -1562,10 +1562,11 @@ static void ace_watchdog(struct net_device *data, unsigned int txqueue)
 }
 
 
-static void ace_tasklet(unsigned long arg)
+static void ace_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *) arg;
-	struct ace_private *ap = netdev_priv(dev);
+	struct ace_private *ap = from_tasklet(ap, t, ace_tasklet);
+	struct net_device *dev = (struct net_device *)((char *)ap -
+				ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
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
index c670067b1541..4b02c705859c 100644
--- a/drivers/net/ethernet/alteon/acenic.h
+++ b/drivers/net/ethernet/alteon/acenic.h
@@ -776,7 +776,7 @@ static int ace_open(struct net_device *dev);
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

