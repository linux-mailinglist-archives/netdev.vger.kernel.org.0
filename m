Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A9B268616
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgINHdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgINHcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:32:00 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC39C06174A;
        Mon, 14 Sep 2020 00:31:58 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t14so10812624pgl.10;
        Mon, 14 Sep 2020 00:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nCXxnuAt1fX5hvo8OyzQOdQYZNM/qXDUgrQxb+zH55Y=;
        b=TXK8eRC4ymOFFPb5FEZ5hfqhu3SqIqp8KgGjsSnFjHG+4ZwGPPB1w8dT9F0o6IB9yd
         PihDn2ti9IbQP79VXVTKlDwvvmE9hfv10T2IDCbZ9Ep+/lEizQzDo+8GG43b3jwZyKL5
         VqUeEZNERg9yYjc0rqsIVdlJVIq0wjYnAprUAWY8xPKAAvqQVb97Duc42uJtZzFj4h1Q
         eszf10GtTDv2A/BNf/d8Dx52GWak+80GqJWva4MQ569SMV+PpmEXz6rvt0MSJGGTvm2i
         VWNyBci6/cminKGi8US/5Lzs2XQOPeQvzxfFrw6uJFun2HVs+WfRwNFf68vtMVyB1Nty
         6VAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nCXxnuAt1fX5hvo8OyzQOdQYZNM/qXDUgrQxb+zH55Y=;
        b=rfEeTGRjZvg3sW216g/xhnqgqQ1T6pTU85pcF6yGV1IE6fRjew7KBm1O/SMKhevRIN
         aXt+EezXYEcKU+7MetfSeWceP3lISh/Cz9y6lbGdenO3KSaJVu4B0LHBytL8+Q5Lf6eh
         ZP+BnUWBRjxRs9bR/1BHDpJwl4t7hWQ5Ci0nkbYtN+Ip/Q+xUcVMGx9hiDLfQDRvbngA
         wUrvsoAjbn2Z8F1HKKz5UBAZteE/yAPD9gOP67h2TASLvZvnCKyxRc7E6+XPsFC+x1uN
         6gBoZQT9OfklIOTshnKN2tNB/IEVtUeFgFnyPw9Gp2Ts3oup/0HCvs/oOR9Y7b5vN2V5
         bvQw==
X-Gm-Message-State: AOAM533a8oOGeyWUTkJgi1H/iivckd4fB1NWIy7l/C55uYKTpelEilV0
        GExFEBqpCxX1dWUqMkOnG8E=
X-Google-Smtp-Source: ABdhPJzvtQsUGPxp4EH5pqtUt3Z3HA3HPD+xFngiqPjH8Tw/S5S8TRNGyI9N9SNegylxmQGF7JCN4A==
X-Received: by 2002:a17:902:28:: with SMTP id 37mr12795896pla.107.1600068718597;
        Mon, 14 Sep 2020 00:31:58 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:31:58 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 04/12] net: ifb: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:23 +0530
Message-Id: <20200914073131.803374-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914073131.803374-1-allen.lkml@gmail.com>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
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
 drivers/net/ifb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 7fe306e76281..a2d6027362d2 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -59,9 +59,9 @@ static netdev_tx_t ifb_xmit(struct sk_buff *skb, struct net_device *dev);
 static int ifb_open(struct net_device *dev);
 static int ifb_close(struct net_device *dev);
 
-static void ifb_ri_tasklet(unsigned long _txp)
+static void ifb_ri_tasklet(struct tasklet_struct *t)
 {
-	struct ifb_q_private *txp = (struct ifb_q_private *)_txp;
+	struct ifb_q_private *txp = from_tasklet(txp, t, ifb_tasklet);
 	struct netdev_queue *txq;
 	struct sk_buff *skb;
 
@@ -170,8 +170,7 @@ static int ifb_dev_init(struct net_device *dev)
 		__skb_queue_head_init(&txp->tq);
 		u64_stats_init(&txp->rsync);
 		u64_stats_init(&txp->tsync);
-		tasklet_init(&txp->ifb_tasklet, ifb_ri_tasklet,
-			     (unsigned long)txp);
+		tasklet_setup(&txp->ifb_tasklet, ifb_ri_tasklet);
 		netif_tx_start_queue(netdev_get_tx_queue(dev, i));
 	}
 	return 0;
-- 
2.25.1

