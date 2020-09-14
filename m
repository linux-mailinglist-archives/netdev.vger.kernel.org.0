Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495DD268611
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgINHdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgINHcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:32:16 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B34C06178A;
        Mon, 14 Sep 2020 00:32:16 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id v14so3569882pjd.4;
        Mon, 14 Sep 2020 00:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sJggIAfe397aQgyhd39vo3xIvt4xXOJn0ISXsGwpGPk=;
        b=ORDx3mTOp0ELrPlTi5zYxf82LertcsNjbu6NRJpMmKxAjk5vDyaeFrRqMj+MoTP4Pk
         z5I2iGxnPbHIc1k6fHGfT9WatOyh/xyfAPFsUNsrMDQ9l7z/LW13oVk6RviByIKDEnUp
         rPXgC0+6nud91RSnndClQLre4mce00eDttPvn2GhFFM7bg9/0pWAIHlQbNGYqHihIBmn
         qYzjO06dOSrVT4rRZtJMqQcIeOD7ol1LFny3O2xjJi/FA5OVNVLYqTr97KVysehLSsAi
         r98lHwpOFMqQli2iD17lwP9koNLJd9zASiiJSJoCrpMtyOPEup+uyZrCXY9m0ueFIWdh
         IJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sJggIAfe397aQgyhd39vo3xIvt4xXOJn0ISXsGwpGPk=;
        b=ApsVYtxe91knvkffyIui2qCdcEOiLjH5yhrRuT8zmIc1gBU/F4qFfCnS+KjhcOBUXT
         qiksuxNA5bP6XrUpMFtUNFV775y8BOteGEliTtWc6jj+0LCa9Ap0fbHpo7CrCUjd5CzU
         v00aj+XpomjD/Dno2Ef85SFdDyDc9hjH8Tk+nDQjaVPfaVIAc+zyiDDH07BR1J62ZbhA
         IMaqs4ckn2Y2iNer4Y3LVBRW87DiphxzXDxGVk+ZDc9PCSXQmnojo81G88nZgrwBabi5
         FoUBsvEJ/lXjRn5CFbUCA2f0JDEO/alZNpuAq4rWtOIz7XUuRRhqPXGHPCVdiLhgkVV3
         3mVQ==
X-Gm-Message-State: AOAM533Mou6qVQabhkRHj0mMHNTYfNaAuq0WO7OpPptBV1c89380w2Xk
        SvwuHVI8hPB7dYiKyg6qLq8=
X-Google-Smtp-Source: ABdhPJz67Y5hfe+/3Bk6EXgTMIEUxexvDWNrnIsKuIMYbJykErH2VRxfAr2UVftiHmEcEuloUtGgFg==
X-Received: by 2002:a17:90b:20d1:: with SMTP id ju17mr12062731pjb.134.1600068735818;
        Mon, 14 Sep 2020 00:32:15 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:32:15 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 08/12] net: lan78xx: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:27 +0530
Message-Id: <20200914073131.803374-9-allen.lkml@gmail.com>
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
 drivers/net/usb/lan78xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 65b315bc60ab..3f6b3712086b 100644
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

