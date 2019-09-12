Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EE5B0A84
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 10:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbfILImS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 04:42:18 -0400
Received: from canardo.mork.no ([148.122.252.1]:48937 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730049AbfILImR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 04:42:17 -0400
Received: from miraculix.mork.no ([IPv6:2a02:2121:340:af89:304b:a5ff:fe41:6a88])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x8C8gAef030205
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 12 Sep 2019 10:42:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1568277734; bh=0kzHipba7JDB2zZdsoc3Tx3P2A5WmFo1FDCKYtkan+E=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=Z5sW09IrHUoJUhNI4s/q7m842EFqVE0Mo3Sc/W8GgNqAYkopzj9gbKDn0+1AUkPr1
         ednlmwfKA+OItkcFd3Sp5oApRxa/o0tIhb6oqaVetHc5zYg5QwCF7vLN816q3YRctD
         mtkQekz0MNq+on4uWu2TWixdtDGYJ1tQ7uC5pXxU=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1i8Kg0-0001fJ-Ev; Thu, 12 Sep 2019 10:42:04 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        Lars Melin <larsm17@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH net,stable] cdc_ether: fix rndis support for Mediatek based smartphones
Date:   Thu, 12 Sep 2019 10:42:00 +0200
Message-Id: <20190912084200.6359-1-bjorn@mork.no>
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

A Mediatek based smartphone owner reports problems with USB
tethering in Linux.  The verbose USB listing shows a rndis_host
interface pair (e0/01/03 + 10/00/00), but the driver fails to
bind with

[  355.960428] usb 1-4: bad CDC descriptors

The problem is a failsafe test intended to filter out ACM serial
functions using the same 02/02/ff class/subclass/protocol as RNDIS.
The serial functions are recognized by their non-zero bmCapabilities.

No RNDIS function with non-zero bmCapabilities were known at the time
this failsafe was added. But it turns out that some Wireless class
RNDIS functions are using the bmCapabilities field. These functions
are uniquely identified as RNDIS by their class/subclass/protocol, so
the failing test can safely be disabled.  The same applies to the two
types of Misc class RNDIS functions.

Applying the failsafe to Communication class functions only retains
the original functionality, and fixes the problem for the Mediatek based
smartphone.

Tow examples of CDC functional descriptors with non-zero bmCapabilities
from Wireless class RNDIS functions are:

0e8d:000a  Mediatek Crosscall Spider X5 3G Phone

      CDC Header:
        bcdCDC               1.10
      CDC ACM:
        bmCapabilities       0x0f
          connection notifications
          sends break
          line coding and serial state
          get/set/clear comm features
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          1

and

19d2:1023  ZTE K4201-z

      CDC Header:
        bcdCDC               1.10
      CDC ACM:
        bmCapabilities       0x02
          line coding and serial state
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          1
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1

The Mediatek example is believed to apply to most smartphones with
Mediatek firmware.  The ZTE example is most likely also part of a larger
family of devices/firmwares.

Suggested-by: Lars Melin <larsm17@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/usb/cdc_ether.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 8458e88c18e9..32f53de5b1fe 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -206,7 +206,15 @@ int usbnet_generic_cdc_bind(struct usbnet *dev, struct usb_interface *intf)
 		goto bad_desc;
 	}
 skip:
-	if (rndis && header.usb_cdc_acm_descriptor &&
+	/* Communcation class functions with bmCapabilities are not
+	 * RNDIS.  But some Wireless class RNDIS functions use
+	 * bmCapabilities for their own purpose. The failsafe is
+	 * therefore applied only to Communication class RNDIS
+	 * functions.  The rndis test is redundant, but a cheap
+	 * optimization.
+	 */
+	if (rndis && is_rndis(&intf->cur_altsetting->desc) &&
+	    header.usb_cdc_acm_descriptor &&
 	    header.usb_cdc_acm_descriptor->bmCapabilities) {
 		dev_dbg(&intf->dev,
 			"ACM capabilities %02x, not really RNDIS?\n",
-- 
2.20.1

