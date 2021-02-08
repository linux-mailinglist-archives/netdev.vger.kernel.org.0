Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC41313414
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbhBHN5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:57:36 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:56764 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhBHN46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:56:58 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v2 02/24] dt-bindings: net: dwmac: Extend number of PBL values
Date:   Mon, 8 Feb 2021 16:55:46 +0300
Message-ID: <20210208135609.7685-3-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In accordance with [1] the permitted PBL values can be set as one of [1,
2, 4, 8, 16, 32]. The rest of the values result in undefined behavior. At
the same time some of the permitted values can be also invalid depending
on the controller FIFOs size and the data bus width. Due to having too
many variables all the possible PBL property constraints can't be
implemented in the bindings schema, let's extend the set of permitted PBL
values to be as much as the configuration register supports leaving the
undefined behaviour cases for developers to handle.

[1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
    October 2013, p. 380.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Rob Herring <robh@kernel.org>

Changelog v2:
- Use correct syntax of the JSON pointers, so the later would begin
  with a '/' after the '#'.
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 40a002770441..cb68a8dcafd7 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -267,23 +267,26 @@ properties:
 
   snps,pbl:
     description:
-      Programmable Burst Length (tx and rx)
+      Programmable Burst Length (tx and rx). Note some of these values
+      can be still invalid due to HW limitations connected with the data
+      bus width and the FIFOs depth, so a total length of a single DMA
+      burst shouldn't exceed half the FIFO depth.
     $ref: /schemas/types.yaml#/definitions/uint32
-    enum: [2, 4, 8]
+    enum: [1, 2, 4, 8, 16, 32]
 
   snps,txpbl:
     description:
       Tx Programmable Burst Length. If set, DMA tx will use this
       value rather than snps,pbl.
     $ref: /schemas/types.yaml#/definitions/uint32
-    enum: [2, 4, 8]
+    enum: [1, 2, 4, 8, 16, 32]
 
   snps,rxpbl:
     description:
       Rx Programmable Burst Length. If set, DMA rx will use this
       value rather than snps,pbl.
     $ref: /schemas/types.yaml#/definitions/uint32
-    enum: [2, 4, 8]
+    enum: [1, 2, 4, 8, 16, 32]
 
   snps,no-pbl-x8:
     $ref: /schemas/types.yaml#/definitions/flag
-- 
2.29.2

