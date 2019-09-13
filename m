Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9272B244F
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 18:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfIMQqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 12:46:38 -0400
Received: from a6-96.smtp-out.eu-west-1.amazonses.com ([54.240.6.96]:46102
        "EHLO a6-96.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725777AbfIMQqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 12:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=awgt3ic55kqhwizgro5hhdlz56bi7lbf; d=origamienergy.com;
        t=1568393196; h=From:To:Cc:Subject:Date:Message-Id;
        bh=KIcU6LZAQlzqeyn3RwZltjh2jxpbkTuDnUGbGEkRmw0=;
        b=dIGYwTgkcPjClw9Pu7eglPegePoopXo6GDcxBPrn4iq775LUJ2bl1JfshD3LJZle
        txpboLxQSl2ZZoz4Q6ocu0vWiEggZ+VBAOB8CrySTHhUws1lXBnF+9dFJjUnyXLrbQi
        KyJsmJ5ay6h43qA0WtJfq355BcSUfUH56fSftV2A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ihchhvubuqgjsxyuhssfvqohv7z3u4hn; d=amazonses.com; t=1568393196;
        h=From:To:Cc:Subject:Date:Message-Id:Feedback-ID;
        bh=KIcU6LZAQlzqeyn3RwZltjh2jxpbkTuDnUGbGEkRmw0=;
        b=b770G31GFSFWfO5QP7hBTX4+zcHyZggVbrlzWUDVhjGAuqZVy0J5HSD4vMfgutk7
        AnMNYtJhvxWwJyx5Ms+fODblDt7Ro/ljg937abq/kOe1XG+c2iFNBgycNn+BiTE0RCw
        XgpjHSXWq9aOMgy8E8zqcbrGE7genX2I3p08zLeI=
From:   James Byrne <james.byrne@origamienergy.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        James Byrne <james.byrne@origamienergy.com>
Subject: [PATCH] dt-bindings: net: Correct the documentation of KSZ9021 skew values
Date:   Fri, 13 Sep 2019 16:46:35 +0000
Message-ID: <0102016d2b84f180-bd396cb9-16cf-4472-b718-7a4d2d8d8017-000000@eu-west-1.amazonses.com>
X-Mailer: git-send-email 2.17.1
X-SES-Outgoing: 2019.09.13-54.240.6.96
Feedback-ID: 1.eu-west-1.sQ65CuNSNkrvjFrT7j7oeWmhxZgivYoP5c3BHSC7Qc8=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The documentation of skew values for the KSZ9021 PHY was misleading
because the driver implementation followed the erroneous information
given in the original KSZ9021 datasheet before it was corrected in
revision 1.2 (Feb 2014). It is probably too late to correct the driver
now because of the many existing device trees, so instead this just
corrects the documentation to explain that what you actually get is not
what you might think when looking at the device tree.

Signed-off-by: James Byrne <james.byrne@origamienergy.com>
---
 .../bindings/net/micrel-ksz90x1.txt           | 32 +++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt b/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
index 5100358177c9..b921731cd970 100644
--- a/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
+++ b/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
@@ -12,8 +12,36 @@ and therefore may overwrite them.
 KSZ9021:
 
   All skew control options are specified in picoseconds. The minimum
-  value is 0, the maximum value is 3000, and it is incremented by 200ps
-  steps.
+  value is 0, the maximum value is 3000, and it can be specified in 200ps
+  steps, *but* these values are in not fact what you get because this chip's
+  skew values actually increase in 120ps steps, starting from -840ps. The
+  incorrect values came from an error in the original KSZ9021 datasheet
+  before it was corrected in revision 1.2 (Feb 2014), but it is too late to
+  change the driver now because of the many existing device trees that have
+  been created using values that go up in increments of 200.
+
+  The following table shows the actual skew delay you will get for each of the
+  possible devicetree values, and the number that will be programmed into the
+  corresponding pad skew register:
+
+  Device Tree Value	Delay	Pad Skew Register Value
+  -----------------------------------------------------
+	0   		-840ps		0000
+	200 		-720ps		0001
+	400 		-600ps		0010
+	600 		-480ps		0011
+	800 		-360ps		0100
+	1000		-240ps		0101
+	1200		-120ps		0110
+	1400		   0ps		0111
+	1600		 120ps		1000
+	1800		 240ps		1001
+	2000		 360ps		1010
+	2200		 480ps		1011
+	2400		 600ps		1100
+	2600		 720ps		1101
+	2800		 840ps		1110
+	3000		 960ps		1111
 
   Optional properties:
 
-- 
2.17.1

