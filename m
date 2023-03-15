Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CEC6BAE99
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjCOLHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjCOLGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:06:42 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BCB85A43
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:34 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m18-20020a05600c3b1200b003ed2a3d635eso902051wms.4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678878392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JK3QCAzV2uxsgFdaubQ9QvC1c5aZ/o2EHMkQeIZH7RA=;
        b=lYYgm1cNWYtBWM9/MP6pOb3usNz4beGBqUXvyznePJP2TBOG5eGAexBzwQFP5OG4Wi
         TLTAhPPo4TeaNcrcRyhxqkbiqcPUkki0sHYsevJL0a3o1bUzDUD+5kn/hhYjIEYOHbUQ
         cs1SMmShHlET6PpHWudYdrNXJ4/TerAH8UTd1oPW2GFsaCfZCyfwrF0SYztqD+8Tb0u6
         N40pDsV8/jdNalHUmPZPcrlQ2W80zBYzkXri2kC9mxUrrgmjjbLB2/zYlN3i1bxFLPf8
         l0m9c0FBmZYfC3VE9Bm7l9BVMsZAh9kMj7rjGHi2J1jMianx5izwJhgSgaqpmVR/YW92
         LBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678878392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JK3QCAzV2uxsgFdaubQ9QvC1c5aZ/o2EHMkQeIZH7RA=;
        b=Z8e1qejGorRSmT4hIq0YKZXPXAnrVYq7/cqKju2q8ymMn+C6+bp6vkI8qncGxu7w39
         LUWjF9FdFImQhwemHRqIlA7cvl0kmrU1hqPCyBDKfBJFJ+MZWrVMslmLBlD+LjGUFgob
         FF0UbTvoNDVQPq0KxQG1n/iD0cLDde/IBZLNJ/VqOjQVWsRlZFynX4nSuhU/vB6jywgS
         oaD7L0Tu+gBfNbbyshVoXDEU7R0532k9rnoZBWGPpIbN/B+nnD+KLXzNCtyHs0OI45im
         3pX+2CtA2Rb4Ao4NSUrx8S63fyIDs61l5TbbYoR6XANzHzWS2w/iMXkzeLoNvVg465uW
         b28A==
X-Gm-Message-State: AO0yUKV9WmKPtoUnWbGH7NW7lmR83X+r6Qsoj0sSr1vIBaFVnz+nhDil
        LxSqXWgErjnNjQKwVQ+7PcvvWg==
X-Google-Smtp-Source: AK7set+M8FfH33AGCEsFcrdmf25rP7/fKaKuloslLUfALJ9MAViDSLOzF2LISvw9ZCWKKuQ7JwQiXw==
X-Received: by 2002:a05:600c:4751:b0:3ea:f0d6:5d36 with SMTP id w17-20020a05600c475100b003eaf0d65d36mr17547733wmo.29.1678878392795;
        Wed, 15 Mar 2023 04:06:32 -0700 (PDT)
Received: from blmsp.fritz.box ([2001:4090:a247:8056:be7d:83e:a6a5:4659])
        by smtp.gmail.com with ESMTPSA id l4-20020a7bc444000000b003eafc47eb09sm1460563wmi.43.2023.03.15.04.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 04:06:32 -0700 (PDT)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v3 09/16] can: m_can: Add rx coalescing ethtool support
Date:   Wed, 15 Mar 2023 12:05:39 +0100
Message-Id: <20230315110546.2518305-10-msp@baylibre.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315110546.2518305-1-msp@baylibre.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the possibility to set coalescing parameters with ethtool.

rx-frames-irq and rx-usecs-irq can only be set and unset together as the
implemented mechanism would not work otherwise. rx-frames-irq can't be
greater than the RX FIFO size.

Also all values can only be changed if the chip is not active.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 94c962ac6992..7f8decfae81e 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1936,8 +1936,54 @@ static const struct net_device_ops m_can_netdev_ops = {
 	.ndo_change_mtu = can_change_mtu,
 };
 
+static int m_can_get_coalesce(struct net_device *dev,
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kec,
+			      struct netlink_ext_ack *ext_ack)
+{
+	struct m_can_classdev *cdev = netdev_priv(dev);
+
+	ec->rx_max_coalesced_frames_irq = cdev->rx_max_coalesced_frames_irq;
+	ec->rx_coalesce_usecs_irq = cdev->rx_coalesce_usecs_irq;
+
+	return 0;
+}
+
+static int m_can_set_coalesce(struct net_device *dev,
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kec,
+			      struct netlink_ext_ack *ext_ack)
+{
+	struct m_can_classdev *cdev = netdev_priv(dev);
+
+	if (cdev->can.state != CAN_STATE_STOPPED) {
+		netdev_err(dev, "Device is in use, please shut it down first\n");
+		return -EBUSY;
+	}
+
+	if (ec->rx_max_coalesced_frames_irq > cdev->mcfg[MRAM_RXF0].num) {
+		netdev_err(dev, "rx-frames-irq %u greater than the RX FIFO %u\n",
+			   ec->rx_max_coalesced_frames_irq,
+			   cdev->mcfg[MRAM_RXF0].num);
+		return -EINVAL;
+	}
+	if ((ec->rx_max_coalesced_frames_irq == 0) != (ec->rx_coalesce_usecs_irq == 0)) {
+		netdev_err(dev, "rx-frames-irq and rx-usecs-irq can only be set together\n");
+		return -EINVAL;
+	}
+
+	cdev->rx_max_coalesced_frames_irq = ec->rx_max_coalesced_frames_irq;
+	cdev->rx_coalesce_usecs_irq = ec->rx_coalesce_usecs_irq;
+
+	return 0;
+}
+
 static const struct ethtool_ops m_can_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS_IRQ |
+		ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ,
 	.get_ts_info = ethtool_op_get_ts_info,
+	.get_coalesce = m_can_get_coalesce,
+	.set_coalesce = m_can_set_coalesce,
 };
 
 static int register_m_can_dev(struct net_device *dev)
-- 
2.39.2

