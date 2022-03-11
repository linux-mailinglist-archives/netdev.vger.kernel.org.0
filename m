Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDE24D5D06
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 09:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347375AbiCKIHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 03:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347263AbiCKIHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 03:07:30 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05311B8BE9;
        Fri, 11 Mar 2022 00:06:27 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z16so7269791pfh.3;
        Fri, 11 Mar 2022 00:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I4mPMM0gIhSxQZ/tzxXpTn3ZOiYuivV0O9sNop/c8sI=;
        b=il1d1E3OFC7Csbd3qnuZS5YRJ5y/Rc4uPfRoXmfth3ij5lYfLx5PJovulX25nKiqqn
         vGePV3TL+cyve3s37baTWod1BPphum7yd2gT/HCubM2qqqqEm52VivO6ehOZU2UsH+PK
         8wtkISRmnTQVexlioR99rW2FmrJ1tUdVmCyhQzgRlbx1R0ERSwUIKjjfGZtpvp2lcHmw
         0KGF+d5k3GCJa2/nz8INa4e1d4RDNGJ8VGr5KIoADmtOj93UEMlmkQZJwoBgJRfhQ5AH
         uNZwQddq3TodFiuEWHaubThYbU7NKE2Aw+D9Ps2FDXGnQ4MhQeIuz7jbvRwYR1dtUwXn
         cv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I4mPMM0gIhSxQZ/tzxXpTn3ZOiYuivV0O9sNop/c8sI=;
        b=NX0PiRWcfn3mE3Ll2rWfcsvHZIRpwyLJwBmLk8saj6+E8X4RenoXXTGT0yPs19Hrua
         u33Pze8hWhYsd1KSTL/QZBLjx6DKFtFB/0zrWpqzPfENw+7bHlRFMcPSWgEv3sz2F8vU
         fYsJ1utL+I6OuOTjz+2DiJ87vIcNe1J76pVjF+lFuSYEWyvkySGAgT3FzNylYgZu3JCb
         85VlO7wtkiFc4i8hooJfDgFxKUbFSfF8LfU6p3HgOdpa1DA8GYD2AmyT6a98wGi96Bjt
         PvQWF83p1e6cRBgYn+0hfTLH3muhYJykAQhjNWY3oukvlF26KflB4nFehHOO7dgWsucr
         A0pA==
X-Gm-Message-State: AOAM530MX+YKLbIuri/kaZ08KIeA5Eq5t+xDkUdn7EaDQPY5HrIe6qRz
        bjtTdjAMnFLy7BMjbe8GMwo=
X-Google-Smtp-Source: ABdhPJx3i3wIHo6UiI84MecSCwTjGmum3NqQnyb1CeMpqDDoStSDeMTk2gNNMhl3buwRZVfo7h/UkQ==
X-Received: by 2002:a63:e5e:0:b0:380:d345:589d with SMTP id 30-20020a630e5e000000b00380d345589dmr7315022pgo.453.1646985987278;
        Fri, 11 Mar 2022 00:06:27 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.54])
        by smtp.gmail.com with ESMTPSA id b5-20020a056a000cc500b004f6ff0f51f4sm9230383pfv.5.2022.03.11.00.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 00:06:26 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, b.krumboeck@gmail.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] can: usb_8dev: fix possible double dev_kfree_skb in usb_8dev_start_xmit
Date:   Fri, 11 Mar 2022 16:06:14 +0800
Message-Id: <20220311080614.45229-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
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

There is no need to call dev_kfree_skb when usb_submit_urb fails beacause
can_put_echo_skb deletes original skb and can_free_echo_skb deletes the cloned
skb.

Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 drivers/net/can/usb/usb_8dev.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 431af1ec1e3c..b638604bf1ee 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -663,9 +663,20 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 	atomic_inc(&priv->active_tx_urbs);
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (unlikely(err))
-		goto failed;
-	else if (atomic_read(&priv->active_tx_urbs) >= MAX_TX_URBS)
+	if (unlikely(err)) {
+		can_free_echo_skb(netdev, context->echo_index, NULL);
+
+		usb_unanchor_urb(urb);
+		usb_free_coherent(priv->udev, size, buf, urb->transfer_dma);
+
+		atomic_dec(&priv->active_tx_urbs);
+
+		if (err == -ENODEV)
+			netif_device_detach(netdev);
+		else
+			netdev_warn(netdev, "failed tx_urb %d\n", err);
+		stats->tx_dropped++;
+	} else if (atomic_read(&priv->active_tx_urbs) >= MAX_TX_URBS)
 		/* Slow down tx path */
 		netif_stop_queue(netdev);
 
@@ -684,19 +695,6 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 
 	return NETDEV_TX_BUSY;
 
-failed:
-	can_free_echo_skb(netdev, context->echo_index, NULL);
-
-	usb_unanchor_urb(urb);
-	usb_free_coherent(priv->udev, size, buf, urb->transfer_dma);
-
-	atomic_dec(&priv->active_tx_urbs);
-
-	if (err == -ENODEV)
-		netif_device_detach(netdev);
-	else
-		netdev_warn(netdev, "failed tx_urb %d\n", err);
-
 nomembuf:
 	usb_free_urb(urb);
 
-- 
2.25.1

