Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA922685E0
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgINHaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgINHaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:09 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A05C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:08 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c196so12017415pfc.0
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=htQObXixxwaiINxkL0CCtd2DyfiXYaJaLxNSxLo3xak=;
        b=EOA6pEVNg9tsVywbfoluXq3VG7pm5+A6AVxel11ogIogem44L4nco9Z0UbN8UR9PyH
         5zXSg/p6zq3TwmIUqsg8eif0HC29VL/ExJ+Qaol0LrSJOD7barvmU/5ae5I2wv+/jZ7K
         QnzS+C7hNKbmY6zyUFmGJgLwkstCT7jzpe338ATMuyRdRcnIFNpMS+Z7pmmbSi8Zq//g
         Bh7ryj/hk2wB0krfXNEcHPvK0j+ekG3GmWMXvYUZmu89Fg2jbKxB6yZPlKgKg3BKiPOH
         xQ45L3/Hqy0oCe6WFBmV4FNb1gPhZz68cjdGyxe9Xe82FeeTQeS44RconPDML2eQdqAU
         10mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=htQObXixxwaiINxkL0CCtd2DyfiXYaJaLxNSxLo3xak=;
        b=iOFiu5XRzh5AFVTkpvv+vDOR4t6IDcGmir0r5FSjETQ4JRal7i4YmdQdF7UJ3+SLFk
         1IUHrw+4hf/9JX7EUQK9jnTlPFWPNAZ6xJOH4V/kM/YR6fSShrYhaPXl1GB8YWy+nLrc
         7lxfR3Z77pAkRH3mQqgAZitlqSN/cV7pHknHtZU6GeHp793H5erlFfoyyNA1RVn+dFaN
         VzgZvIgXqEjmIL+sopqOYSregIEZ/YBWlsdIG8BTu4UW94EKB2ghtzx/YKC3lD74OBWL
         9AICAT54dEdbnzSxLYiXeN0xQ7tCt1qHpb+KToyYUHQz6MNa+5EEQqXMmyHfDjywLe8m
         0pig==
X-Gm-Message-State: AOAM532jda5GyvQ0Ktro/THkVbS6/xvVyt6xXRN/uW/PM2i0fUFx133+
        S2tW7Jww4CVPRHM4BDEYSJ4=
X-Google-Smtp-Source: ABdhPJwX+HAqER6fOqRBWvJgerV5Ev1lqArdG93j7tG19i7v+EcCc9X6o9Y5RVP13DVGtDPLkXI0Cg==
X-Received: by 2002:a63:161e:: with SMTP id w30mr9739417pgl.255.1600068608373;
        Mon, 14 Sep 2020 00:30:08 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:07 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 04/20] net: macb: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:23 +0530
Message-Id: <20200914072939.803280-5-allen.lkml@gmail.com>
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
 drivers/net/ethernet/cadence/macb_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 6761f404b8aa..830c537bc08c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1466,9 +1466,9 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static void macb_hresp_error_task(unsigned long data)
+static void macb_hresp_error_task(struct tasklet_struct *t)
 {
-	struct macb *bp = (struct macb *)data;
+	struct macb *bp = from_tasklet(bp, t, hresp_err_tasklet);
 	struct net_device *dev = bp->dev;
 	struct macb_queue *queue;
 	unsigned int q;
@@ -4560,8 +4560,7 @@ static int macb_probe(struct platform_device *pdev)
 		goto err_out_unregister_mdio;
 	}
 
-	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
-		     (unsigned long)bp);
+	tasklet_setup(&bp->hresp_err_tasklet, macb_hresp_error_task);
 
 	netdev_info(dev, "Cadence %s rev 0x%08x at 0x%08lx irq %d (%pM)\n",
 		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),
-- 
2.25.1

