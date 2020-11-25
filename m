Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312942C45F9
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 17:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732480AbgKYQxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 11:53:47 -0500
Received: from inva021.nxp.com ([92.121.34.21]:33154 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbgKYQxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 11:53:47 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1245820172E;
        Wed, 25 Nov 2020 17:53:46 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 04CD920172D;
        Wed, 25 Nov 2020 17:53:46 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 9CE802030D;
        Wed, 25 Nov 2020 17:53:45 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, maciej.fijalkowski@intel.com, brouer@redhat.com,
        saeed@kernel.org, davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v5 0/7] dpaa_eth: add XDP support
Date:   Wed, 25 Nov 2020 18:53:29 +0200
Message-Id: <cover.1606322126.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable XDP support for the QorIQ DPAA1 platforms.

Implement all the current actions (DROP, ABORTED, PASS, TX, REDIRECT). No
Tx batching is added at this time.

Additional XDP_PACKET_HEADROOM bytes are reserved in each frame's headroom.

After transmit, a reference to the xdp_frame is saved in the buffer for
clean-up on confirmation in a newly created structure for software
annotations. DPAA_TX_PRIV_DATA_SIZE bytes are reserved in the buffer for
storing this structure and the XDP program is restricted from accessing
them.

The driver shares the egress frame queues used for XDP with the network
stack. The DPAA driver is a LLTX driver so no explicit locking is required
on transmission.

Changes in v2:
- warn only once if extracting the timestamp from a received frame fails
  in 2/7

Changes in v3:
- drop received S/G frames when XDP is enabled in 2/7

Changes in v4:
- report a warning if the MTU is too hight for running XDP in 2/7
- report an error if opening the device fails in the XDP setup in 2/7
- call xdp_rxq_info_is_reg() before unregistering in 4/7
- minor cleanups (remove unneeded variable, print error code) in 4/7
- add more details in the commit message in 4/7
- did not call qman_destroy_fq() in case of xdp_rxq_info_reg() failure
since it would lead to a double free of the fq resources in 4/7

Changes in v5:
- report errors on XDP setup with extack in 2/7
- checkpath fix in 4/7
- add more details in the commit message in 4/7
- reduce the impact of the A050385 erratum workaround code on non-erratum
platforms in 7/7

Camelia Groza (7):
  dpaa_eth: add struct for software backpointers
  dpaa_eth: add basic XDP support
  dpaa_eth: limit the possible MTU range when XDP is enabled
  dpaa_eth: add XDP_TX support
  dpaa_eth: add XDP_REDIRECT support
  dpaa_eth: rename current skb A050385 erratum workaround
  dpaa_eth: implement the A050385 erratum workaround for XDP

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 465 +++++++++++++++++++++++--
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |  13 +
 2 files changed, 448 insertions(+), 30 deletions(-)

--
1.9.1

