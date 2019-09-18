Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD99B62F4
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 14:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbfIRMRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 08:17:49 -0400
Received: from canardo.mork.no ([148.122.252.1]:46379 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbfIRMRt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 08:17:49 -0400
Received: from miraculix.mork.no ([IPv6:2a02:2121:345:8091:90c6:3fae:14f0:3126])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x8ICHjRe018136
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 18 Sep 2019 14:17:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1568809066; bh=6ReCdLpKToI7PCsGayRZb9MxdpELm+zou9tl9ZWV5QY=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=HfPE3yew4RDxJsPjfUUTUZh8oipCKZeF2dZXdIvPriK/AucWka3J0vPdDTESnOHdk
         NgFWNLFAhgtOcUhsqs7j0yVx4DLiMbRmZhWG92ZwuCUa1LkN4z1W+q9v4mORqoNCfv
         x4JW50FkS29FhRIOu9G/Ikq4BU2qB3MjOROIZyRg=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1iAYtw-0001f0-25; Wed, 18 Sep 2019 14:17:40 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH net,stable] usbnet: ignore endpoints with invalid wMaxPacketSize
Date:   Wed, 18 Sep 2019 14:17:38 +0200
Message-Id: <20190918121738.6343-1-bjorn@mork.no>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Endpoints with zero wMaxPacketSize are not usable for transferring
data. Ignore such endpoints when looking for valid in, out and
status pipes, to make the drivers more robust against invalid and
meaningless descriptors.

The wMaxPacketSize of these endpoints are used for memory allocations
and as divisors in many usbnet minidrivers. Avoiding zero is therefore
critical.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/usb/usbnet.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 58952a79b05f..dbea2136d901 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -100,6 +100,11 @@ int usbnet_get_endpoints(struct usbnet *dev, struct usb_interface *intf)
 			int				intr = 0;
 
 			e = alt->endpoint + ep;
+
+			/* ignore endpoints which cannot transfer data */
+			if (!usb_endpoint_maxp(&e->desc))
+				continue;
+
 			switch (e->desc.bmAttributes) {
 			case USB_ENDPOINT_XFER_INT:
 				if (!usb_endpoint_dir_in(&e->desc))
-- 
2.20.1

