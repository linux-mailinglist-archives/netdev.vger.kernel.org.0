Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882D6547663
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 18:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiFKQUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 12:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbiFKQUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 12:20:52 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EFABB;
        Sat, 11 Jun 2022 09:20:51 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a10so1963948pju.3;
        Sat, 11 Jun 2022 09:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x4vkCY0Dmjz4WZzLAFOkm0e4CCsi4T4LIBkosBb21to=;
        b=RX9C/mEWyapHnRTdRROpfzXhSTimnJDqppKHJRDhCt1Ybj1GU9wKeAKDDC6TgOmbc3
         LukQS738f3r/jEtPrSsv2Ye0wA4R2SZnX6rWgVul+QBaHFkwktq7rUb+FtaI5OIe0+HT
         qZtN3A8w4FBRTwS9OG7WfVk/7cTUeufQd/gu+e2ZeqhjiYgpOEO4jDNMql11kvZKTMKG
         lu9dyosbfq0nEjJ5YvPDkj9WQVFl6Bq1cCFSGXR2JeIpSsTqIK4312hqT4jITU422XXe
         YO2OYWmy0Mz2ACYg+dfi293kGNglqoxSMGERicRNCGMInF3XBq8v/mpf3ot6dm0CAHwO
         hqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=x4vkCY0Dmjz4WZzLAFOkm0e4CCsi4T4LIBkosBb21to=;
        b=lMo6BYB/4OfNnKIRgSm42WZ31IUGSTNS13efogefKJ1mBS6GVS70/+4ioOSHyAk0lQ
         Sj2e/xK+KUKidux8x17ItL6F28vijX6xuy//5MOgrF9ae6SlxQWaKumIDMSpPvUMKFvt
         sudDOCOw1DPgyfRoJzvrv3fS7Uan/EBCG/zj2xPiw8hA5DfNr2836QOgEr9EfDQ9qPkm
         8ThTAU7+pYS4dhu/VU0wbQPlleHlAyp5VNDFXJB0E548HTXoGS7LLsIBiDo31oyeFVfV
         Ln6Wn3xBWa/HmnSd7eZDtlnC96Nuxcp7/MuyXoUOC54FPf2zSUg9MXob1jWO1SMfiBDL
         xfPg==
X-Gm-Message-State: AOAM5321hJcuAXLqZFGvTGIKRVJiEPDDbaZo1gxLTDxjpRPiXsYwEtF2
        6ASlZRuqDyMJojxlc8ffkl2NkfvrCQ79cA==
X-Google-Smtp-Source: ABdhPJw5NuPCtR4ViJy9f0CoygYIyfDGt/iarRsWB6e2/nHxICS2QIahrv6EuecAiGfL0U+LixsVrA==
X-Received: by 2002:a17:902:854c:b0:163:7dd2:130f with SMTP id d12-20020a170902854c00b001637dd2130fmr50408526plo.57.1654964450652;
        Sat, 11 Jun 2022 09:20:50 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id je9-20020a170903264900b0015e8d4eb2e3sm1692469plb.301.2022.06.11.09.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jun 2022 09:20:50 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH 1/2] can: etas_es58x: replace es58x_device::rx_max_packet_size by usb_maxpacket()
Date:   Sun, 12 Jun 2022 01:20:36 +0900
Message-Id: <20220611162037.1507-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611162037.1507-1-mailhol.vincent@wanadoo.fr>
References: <20220611162037.1507-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The field rx_max_packet_size of struct es58x_device in nothing else
than usb_endpoint_descriptor::wMaxPacketSize and can be easily
retrieved using usb_maxpacket(). Also, rx_max_packet_size being used a
single time, there is no merit to cache it locally.

Remove es58x_device::rx_max_packet_size and rely on usb_maxpacket()
instead.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 5 ++---
 drivers/net/can/usb/etas_es58x/es58x_core.h | 2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 2d73ebbf3836..7353745f92d7 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1707,7 +1707,7 @@ static int es58x_alloc_rx_urbs(struct es58x_device *es58x_dev)
 {
 	const struct device *dev = es58x_dev->dev;
 	const struct es58x_parameters *param = es58x_dev->param;
-	size_t rx_buf_len = es58x_dev->rx_max_packet_size;
+	u16 rx_buf_len = usb_maxpacket(es58x_dev->udev, es58x_dev->rx_pipe);
 	struct urb *urb;
 	u8 *buf;
 	int i;
@@ -1739,7 +1739,7 @@ static int es58x_alloc_rx_urbs(struct es58x_device *es58x_dev)
 		dev_err(dev, "%s: Could not setup any rx URBs\n", __func__);
 		return ret;
 	}
-	dev_dbg(dev, "%s: Allocated %d rx URBs each of size %zu\n",
+	dev_dbg(dev, "%s: Allocated %d rx URBs each of size %u\n",
 		__func__, i, rx_buf_len);
 
 	return ret;
@@ -2223,7 +2223,6 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
 					     ep_in->bEndpointAddress);
 	es58x_dev->tx_pipe = usb_sndbulkpipe(es58x_dev->udev,
 					     ep_out->bEndpointAddress);
-	es58x_dev->rx_max_packet_size = le16_to_cpu(ep_in->wMaxPacketSize);
 
 	return es58x_dev;
 }
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index e5033cb5e695..512c5b7a1cfa 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -380,7 +380,6 @@ struct es58x_operators {
  * @timestamps: a temporary buffer to store the time stamps before
  *	feeding them to es58x_can_get_echo_skb(). Can only be used
  *	in RX branches.
- * @rx_max_packet_size: Maximum length of bulk-in URB.
  * @num_can_ch: Number of CAN channel (i.e. number of elements of @netdev).
  * @opened_channel_cnt: number of channels opened. Free of race
  *	conditions because its two users (net_device_ops:ndo_open()
@@ -414,7 +413,6 @@ struct es58x_device {
 
 	u64 timestamps[ES58X_ECHO_BULK_MAX];
 
-	u16 rx_max_packet_size;
 	u8 num_can_ch;
 	u8 opened_channel_cnt;
 
-- 
2.35.1

