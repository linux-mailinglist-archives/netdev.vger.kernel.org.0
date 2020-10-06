Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1763D2845D9
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgJFGMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:12:45 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D38C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:12:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s19so698355plp.3
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VgNwRXJyEDG01lBqMPdHE+//hDQm9seBMBcDf8TI/sQ=;
        b=feFA5KuLoPL+uhPS3bdJuNdgg2TfuEvXyfuw0fVXG/IeCG91f4mFwJyAmB4ky+JTWH
         Xv9BIEetgXRgC7rWcbnUX8Jxr3YDAExm1+NwXHVCs8AuvuJOYM8owoZkjGsR7UTXolrn
         HNtwmDFWGO7IC5LTzmE/0kOpv9I5C8VFkiDVXof85eQzOl2ft6mLnilyTKfwv2W0WJMz
         LjejrFT46tNMuJbqrZ7doaexegzNjRHmMgwg3IsVK+dZElwKT8Ia8yvHInGX/zo+ZudN
         942qT07viiY43QMWleHI8EJzlRUw3VD9mjMqX49laZhsS5zMhM45eWcQaI1mOMXHRq+a
         A5NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VgNwRXJyEDG01lBqMPdHE+//hDQm9seBMBcDf8TI/sQ=;
        b=mZf7ssSsUHCriSNfVPwW56cj+Q5aSuRDRec1qOaFOreZlhqPv4WMBbzNtFemlupXbs
         VQ8wzHmx6sDrOs5j945vmaer5UIVHUJI8O5TDcIiZazEucNZY44C7dtGgJc3ngqkBGWI
         F7fpunsf7AFQLF8Av3FvB9XB6RxV7HKJTGq1SOWZMGv/ScAz2R2zO3DCbRaIsA7FdZQt
         dsEqkerDKWdRsw6OzuZNEmdMTimfPhQ2sZxGmSkDVWz4ST5hnzPSqir+naOuI3iXAhzt
         jkOHYbj6laUn2VhHUZAADkaZc9zTuktiH9FIoMbZRG4xdX1GmRnMbN5xLCpZoCZzgaTA
         saqA==
X-Gm-Message-State: AOAM532pp/c0FqY8y6jj4XhCqVhG+6lBTRhRxbL/ZsO7PVmo6dJ7ren9
        YQdBZaDNI5T5aPeYwC8ssmY=
X-Google-Smtp-Source: ABdhPJwmC3oyCuxJ+6UZe+4MdfNOeOtICggqI6WgBHLbvtKLE2GoAN8IeGaINfjDIG/Nv4hzQ3vNrg==
X-Received: by 2002:a17:902:6847:b029:d3:d44c:3c7b with SMTP id f7-20020a1709026847b02900d3d44c3c7bmr1787320pln.53.1601964763620;
        Mon, 05 Oct 2020 23:12:43 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id c12sm2046410pfj.164.2020.10.05.23.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:12:43 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [next-next v3 07/10] net: lan78xx: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:41:56 +0530
Message-Id: <20201006061159.292340-8-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006061159.292340-1-allen.lkml@gmail.com>
References: <20201006061159.292340-1-allen.lkml@gmail.com>
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
 drivers/net/usb/lan78xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 65b315bc6..3f6b37120 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3386,9 +3386,9 @@ static void lan78xx_rx_bh(struct lan78xx_net *dev)
 		netif_wake_queue(dev->net);
 }
 
-static void lan78xx_bh(unsigned long param)
+static void lan78xx_bh(struct tasklet_struct *t)
 {
-	struct lan78xx_net *dev = (struct lan78xx_net *)param;
+	struct lan78xx_net *dev = from_tasklet(dev, t, bh);
 	struct sk_buff *skb;
 	struct skb_data *entry;
 
@@ -3666,7 +3666,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	skb_queue_head_init(&dev->txq_pend);
 	mutex_init(&dev->phy_mutex);
 
-	tasklet_init(&dev->bh, lan78xx_bh, (unsigned long)dev);
+	tasklet_setup(&dev->bh, lan78xx_bh);
 	INIT_DELAYED_WORK(&dev->wq, lan78xx_delayedwork);
 	init_usb_anchor(&dev->deferred);
 
-- 
2.25.1

