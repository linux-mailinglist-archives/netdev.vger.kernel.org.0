Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9D926C7FE
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgIPSiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:38:07 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46756 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgIPS24 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:28:56 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CF4831A0CCA;
        Wed, 16 Sep 2020 14:16:42 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B8F3A1A0098;
        Wed, 16 Sep 2020 14:16:39 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id E8B5A402AE;
        Wed, 16 Sep 2020 14:16:34 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [v3, 0/6] dpaa2_eth: support 1588 one-step timestamping
Date:   Wed, 16 Sep 2020 20:08:24 +0800
Message-Id: <20200916120830.11456-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set is to add MC APIs of 1588 one-step timestamping, and
support one-step timestamping for PTP Sync packet on DPAA2.

Before egress, one-step timestamping enablement needs,

- Enabling timestamp and FAS (Frame Annotation Status) in
  dpni buffer layout.

- Write timestamp to frame annotation and set PTP bit in
  FAS to mark as one-step timestamping event.

- Enabling one-step timestamping by dpni_set_single_step_cfg()
  API, with offset provided to insert correction time on frame.
  The offset must respect all MAC headers, VLAN tags and other
  protocol headers accordingly. The correction field update can
  consider delays up to one second. So PTP frame needs to be
  filtered and parsed, and written timestamp into Sync frame
  originTimestamp field.

The operation of API dpni_set_single_step_cfg() has to be done
when no one-step timestamping frames are in flight. So we have
to make sure the last one-step timestamping frame has already
been transmitted on hardware before starting to send the current
one. The resolution is,

- Utilize skb->cb[0] to mark timestamping request per packet.
  If it is one-step timestamping PTP sync packet, queue to skb queue.
  If not, transmit immediately.

- Schedule a work to transmit skbs in skb queue.

- mutex lock is used to ensure the last one-step timestamping packet
  has already been transmitted on hardware through TX confirmation queue
  before transmitting current packet.

Changes for v2:
	- Removed unused variable priv in dpaa2_eth_xdp_create_fd().
Changes for v3:
	- Fixed sparse warnings.
	- Fix build issue on 32-bit.
	- Converted to use ptp_parse_header.

Yangbo Lu (6):
  dpaa2-eth: add APIs of 1588 single step timestamping
  dpaa2-eth: define a global ptp_qoriq structure pointer
  dpaa2-eth: invoke dpaa2_eth_enable_tx_tstamp() once in code
  dpaa2-eth: utilize skb->cb[0] for hardware timestamping
  dpaa2-eth: support PTP Sync packet one-step timestamping
  dpaa2-eth: fix a build warning in dpmac.c

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 232 ++++++++++++++++++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  44 +++-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c   |   3 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h   |   4 +
 drivers/net/ethernet/freescale/dpaa2/dpmac.c       |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h    |  21 ++
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |  79 +++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h        |  31 +++
 9 files changed, 382 insertions(+), 38 deletions(-)

-- 
2.7.4

