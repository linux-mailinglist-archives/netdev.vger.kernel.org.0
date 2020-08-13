Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7AE243EBC
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 20:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgHMSRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 14:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgHMSRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 14:17:14 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06CBC061757;
        Thu, 13 Aug 2020 11:17:14 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 74so3203956pfx.13;
        Thu, 13 Aug 2020 11:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6J6/ZU0XbO+1z0IeOrxIOq56pykTQVgam02T5CujhsY=;
        b=Sfl2o3IupApdQfJYRrhDbZz83oL0Faj84cpfTA5gWAqGN9YwQD5RH2i4FnYIphPeaM
         X8p0vHWcaT12XRonncClBL0QtnF2ElVeUHc0qdWV/nlfiOMSRNd+e0OeM/1c63Gl7kdn
         p4SGfcO14Se72YcMESVTXtgSRQ019N9q1SmTn+Hj61TPrP69fHUJzkKZJLs2NH4yoOMd
         lx3ujMG8hTKyiIFK3K15aRIWsls80wjLjvB63r77l4bOWz9OC2mcmeYgcd2lYLxZWrF3
         64/d/mqIihhZm8okdlmWUJqr5q4OuNzCop/snlEs1iZFvCITFs05yfsZ2uVq3LIurAN2
         J61A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6J6/ZU0XbO+1z0IeOrxIOq56pykTQVgam02T5CujhsY=;
        b=SS13T8T+bldFenImW2BcLPW7s3of68PUuWGHC1vzel46kc3ioi7IjJRfGQi00s07pJ
         Z2xIYRMfXjRrShK6YngFdcMCpy3Yezad1NAc5KY+fKph0fJDJFYErPEmyHFkFgEcJiAp
         rxwQ/AzVqYAuERTRjB2432JuNYwb6tV6DCvujQsRJUpC+HKe9/Mu6QaqT4LFvHqeRa+Y
         lTl8i85E7xBc/2fXXHuh/H/G69rHjVfdvGhQseelTtntTqnh7uoNVB8S3vxvFCFXT9Pd
         6TitP8f29T86qT9Otd64GrL3J5RHM+ppRF+4wItoBd1Gvrphv7UV3McLVACNCRzHm8Wu
         T/Yw==
X-Gm-Message-State: AOAM530gBYG1Yv2GACsAPWv8MXqm8IFCRdtcoFvWuncgq74bT+KTftJH
        vYRl6+loHWLPUQv2L2Gspco=
X-Google-Smtp-Source: ABdhPJyqwPenOAaISNvhIDlThUwNOmobc4MGRd6N09vIHLbyOdOWHKSNMlh3KmCdUWMOJq3Gh8aiTA==
X-Received: by 2002:a63:ef46:: with SMTP id c6mr4740468pgk.96.1597342633192;
        Thu, 13 Aug 2020 11:17:13 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net (c-73-189-11-147.hsd1.ca.comcast.net. [73.189.11.147])
        by smtp.gmail.com with ESMTPSA id f6sm6169684pje.16.2020.08.13.11.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 11:17:12 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: [PATCH net] drivers/net/wan/hdlc_x25: Added needed_headroom and a skb->len check
Date:   Thu, 13 Aug 2020 11:17:04 -0700
Message-Id: <20200813181704.62694-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Added a skb->len check

This driver expects upper layers to include a pseudo header of 1 byte
when passing down a skb for transmission. This driver will read this
1-byte header. This patch added a skb->len check before reading the
header to make sure the header exists.

2. Added needed_headroom and set hard_header_len to 0

When this driver transmits data,
  first this driver will remove a pseudo header of 1 byte,
  then the lapb module will prepend the LAPB header of 2 or 3 bytes.
So the value of needed_headroom in this driver should be 3 - 1.

Because this driver has no header_ops, according to the logic of
af_packet.c, the value of hard_header_len should be 0.

Reason of setting needed_headroom and hard_header_len at this place:

This driver is written using the API of the hdlc module, the hdlc
module enables this driver (the protocol driver) to run on any hardware
that has a driver (the hardware driver) written using the API of the
hdlc module.

Two other hdlc protocol drivers - hdlc_ppp and hdlc_raw_eth, also set
things like hard_header_len at this place. In hdlc_ppp, it sets
hard_header_len after attach_hdlc_protocol and before setting dev->type.
In hdlc_raw_eth, it sets hard_header_len by calling ether_setup after
attach_hdlc_protocol and after memcpy the settings.

3. Reset needed_headroom when detaching protocols (in hdlc.c)

When detaching a protocol from a hardware device, the hdlc module will
reset various parameters of the device (including hard_header_len) to
the default values. We add needed_headroom here so that needed_headroom
will also be reset.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Cc: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc.c     |  1 +
 drivers/net/wan/hdlc_x25.c | 17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index dfc16770458d..386ed2aa31fd 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -230,6 +230,7 @@ static void hdlc_setup_dev(struct net_device *dev)
 	dev->max_mtu		 = HDLC_MAX_MTU;
 	dev->type		 = ARPHRD_RAWHDLC;
 	dev->hard_header_len	 = 16;
+	dev->needed_headroom	 = 0;
 	dev->addr_len		 = 0;
 	dev->header_ops		 = &hdlc_null_ops;
 }
diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index f70336bb6f52..f52b9fed0593 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -107,8 +107,14 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	int result;
 
+	/* There should be a pseudo header of 1 byte added by upper layers.
+	 * Check to make sure it is there before reading it.
+	 */
+	if (skb->len < 1) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
 
-	/* X.25 to LAPB */
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:	/* Data to be transmitted */
 		skb_pull(skb, 1);
@@ -294,6 +300,15 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 			return result;
 
 		memcpy(&state(hdlc)->settings, &new_settings, size);
+
+		/* There's no header_ops so hard_header_len should be 0. */
+		dev->hard_header_len = 0;
+		/* When transmitting data:
+		 * first we'll remove a pseudo header of 1 byte,
+		 * then we'll prepend an LAPB header of at most 3 bytes.
+		 */
+		dev->needed_headroom = 3 - 1;
+
 		dev->type = ARPHRD_X25;
 		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
 		netif_dormant_off(dev);
-- 
2.25.1

