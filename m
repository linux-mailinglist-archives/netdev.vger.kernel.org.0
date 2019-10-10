Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A306D2A39
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 15:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387640AbfJJNAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 09:00:52 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:24636 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbfJJNAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 09:00:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1570712450;
        s=strato-dkim-0002; d=pixelbox.red;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=tQBdWLg+vAtBeTaPYxvRH0gMkm352FfDmv7e4JZ6bTg=;
        b=GrRhnR5+7cBjl2akXfNUXgYwvjk4KyL9NXC+V/0DvIhOhW6xn4RnJnWg1SzJQa33CP
        iK4Yzrv8TmiOHo8lpHXwUX4EKg3m0BNYVXjeu1lQc/OB15QiYmCZmJ+mGD5HwQ0tw7cF
        Hybiax0vjF08TdecEGO6/Nrr4c/in5nVG0SpCJy2UtNsUPt0oITLnrismLa6XiK8sRkm
        YAm0QflVGpAP99gh8fPbziDf4/rGClCT7yAGC2nTGXkzK7sbIvhCnsnqeW8N9JP0XevW
        AWd9aMxg05wiCHq8sfDS4cTL4l29ai2FEiQY02fSoXbnVyk0hoaGjnnTdw2/rFLrytEO
        kNEA==
X-RZG-AUTH: ":PGkAZ0+Ia/aHbZh+i/9QzqYeH5BDcTFH98iPmzDT881S1Jv9Y40I0vUpkEK3poY1KyL7e8vwUVd6rhLT+3nQPD/JTWrS4IlCVOSV0M8="
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
        by smtp.strato.de (RZmta 44.28.0 AUTH)
        with ESMTPSA id d0520cv9AD0jpOB
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 10 Oct 2019 15:00:45 +0200 (CEST)
From:   Peter Fink <pedro@pixelbox.red>
To:     netdev@vger.kernel.org
Cc:     pfink@christ-es.de, davem@davemloft.net
Subject: [PATCH net-next v2] net: usb: ax88179_178a: write mac to hardware in get_mac_addr
Date:   Thu, 10 Oct 2019 15:00:22 +0200
Message-Id: <1570712422-32397-1-git-send-email-pedro@pixelbox.red>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Fink <pfink@christ-es.de>

When the MAC address is supplied via device tree or a random
MAC is generated it has to be written to the asix chip in
order to receive any data.

Previously in 9fb137aef34e ("net: usb: ax88179_178a: allow
optionally getting mac address from device tree") this line was
omitted because it seemed to work perfectly fine without it.

But it was simply not detected because the chip keeps the mac
stored even beyond a reset and it was tested on a hardware
with an integrated UPS where the asix chip was permanently
powered on even throughout power cycles.

Fixes: 9fb137aef34e ("net: usb: ax88179_178a: allow optionally getting mac address from device tree")
Signed-off-by: Peter Fink <pfink@christ-es.de>
---
v1->v2: fix citation style and add 'fixes' tag

 drivers/net/usb/ax88179_178a.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 5a58766..c5a6e75 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1235,6 +1235,9 @@ static void ax88179_get_mac_addr(struct usbnet *dev)
 		netdev_info(dev->net, "invalid MAC address, using random\n");
 		eth_hw_addr_random(dev->net);
 	}
+
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN, ETH_ALEN,
+			  dev->net->dev_addr);
 }
 
 static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
-- 
2.7.4

