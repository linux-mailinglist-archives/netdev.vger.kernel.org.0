Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41512179468
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgCDQEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:04:35 -0500
Received: from inva021.nxp.com ([92.121.34.21]:60254 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgCDQEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 11:04:34 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BC7AA20020D;
        Wed,  4 Mar 2020 17:04:31 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AEEB9200224;
        Wed,  4 Mar 2020 17:04:31 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1CC94202D2;
        Wed,  4 Mar 2020 17:04:31 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        shawnguo@kernel.org, leoyang.li@nxp.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net v2 0/4] QorIQ DPAA FMan erratum A050385 workaround
Date:   Wed,  4 Mar 2020 18:04:24 +0200
Message-Id: <1583337868-3320-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:
 - added CONFIG_DPAA_ERRATUM_A050385
 - removed unnecessary parenthesis
 - changed alignment defines to use only decimal values

The patch set implements the workaround for FMan erratum A050385:

FMAN DMA read or writes under heavy traffic load may cause FMAN
internal resource leak; thus stopping further packet processing.
To reproduce this issue when the workaround is not applied, one
needs to ensure the FMan DMA transaction queue is already full
when a transaction split occurs so the system must be under high
traffic load (i.e. multiple ports at line rate). After the errata
occurs, the traffic stops. The only SoC impacted by this is the
LS1043A, the other ARM DPAA 1 SoC or the PPC DPAA 1 SoCs do not
have this erratum.

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

Madalin Bucur (4):
  dt-bindings: net: FMan erratum A050385
  arm64: dts: ls1043a: FMan erratum A050385
  fsl/fman: detect FMan erratum A050385
  dpaa_eth: FMan erratum A050385 workaround

 Documentation/devicetree/bindings/net/fsl-fman.txt |   7 ++
 arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi |   2 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     | 110 ++++++++++++++++++++-
 drivers/net/ethernet/freescale/fman/Kconfig        |  28 ++++++
 drivers/net/ethernet/freescale/fman/fman.c         |  18 ++++
 drivers/net/ethernet/freescale/fman/fman.h         |   5 +
 6 files changed, 167 insertions(+), 3 deletions(-)

-- 
2.1.0

