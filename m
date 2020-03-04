Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111DD17945C
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgCDQEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:04:36 -0500
Received: from inva021.nxp.com ([92.121.34.21]:60280 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgCDQEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 11:04:35 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6DA0F20021D;
        Wed,  4 Mar 2020 17:04:33 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 60A532001FC;
        Wed,  4 Mar 2020 17:04:33 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E27F2202D2;
        Wed,  4 Mar 2020 17:04:32 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        shawnguo@kernel.org, leoyang.li@nxp.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net v2 1/4] dt-bindings: net: FMan erratum A050385
Date:   Wed,  4 Mar 2020 18:04:25 +0200
Message-Id: <1583337868-3320-2-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1583337868-3320-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1583337868-3320-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

FMAN DMA read or writes under heavy traffic load may cause FMAN
internal resource leak; thus stopping further packet processing.

The FMAN internal queue can overflow when FMAN splits single
read or write transactions into multiple smaller transactions
such that more than 17 AXI transactions are in flight from FMAN
to interconnect. When the FMAN internal queue overflows, it can
stall further packet processing. The issue can occur with any one
of the following three conditions:

  1. FMAN AXI transaction crosses 4K address boundary (Errata
     A010022)
  2. FMAN DMA address for an AXI transaction is not 16 byte
     aligned, i.e. the last 4 bits of an address are non-zero
  3. Scatter Gather (SG) frames have more than one SG buffer in
     the SG list and any one of the buffers, except the last
     buffer in the SG list has data size that is not a multiple
     of 16 bytes, i.e., other than 16, 32, 48, 64, etc.

With any one of the above three conditions present, there is
likelihood of stalled FMAN packet processing, especially under
stress with multiple ports injecting line-rate traffic.

To avoid situations that stall FMAN packet processing, all of the
above three conditions must be avoided; therefore, configure the
system with the following rules:

  1. Frame buffers must not span a 4KB address boundary, unless
     the frame start address is 256 byte aligned
  2. All FMAN DMA start addresses (for example, BMAN buffer
     address, FD[address] + FD[offset]) are 16B aligned
  3. SG table and buffer addresses are 16B aligned and the size
     of SG buffers are multiple of 16 bytes, except for the last
     SG buffer that can be of any size.

Additional workaround notes:
- Address alignment of 64 bytes is recommended for maximally
efficient system bus transactions (although 16 byte alignment is
sufficient to avoid the stall condition)
- To support frame sizes that are larger than 4K bytes, there are
two options:
  1. Large single buffer frames that span a 4KB page boundary can
     be converted into SG frames to avoid transaction splits at
     the 4KB boundary,
  2. Align the large single buffer to 256B address boundaries,
     ensure that the frame address plus offset is 256B aligned.
- If software generated SG frames have buffers that are unaligned
and with random non-multiple of 16 byte lengths, before
transmitting such frames via FMAN, frames will need to be copied
into a new single buffer or multiple buffer SG frame that is
compliant with the three rules listed above.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl-fman.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
index 250f8d8cdce4..c00fb0d22c7b 100644
--- a/Documentation/devicetree/bindings/net/fsl-fman.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
@@ -110,6 +110,13 @@ PROPERTIES
 		Usage: required
 		Definition: See soc/fsl/qman.txt and soc/fsl/bman.txt
 
+- fsl,erratum-a050385
+		Usage: optional
+		Value type: boolean
+		Definition: A boolean property. Indicates the presence of the
+		erratum A050385 which indicates that DMA transactions that are
+		split can result in a FMan lock.
+
 =============================================================================
 FMan MURAM Node
 
-- 
2.1.0

