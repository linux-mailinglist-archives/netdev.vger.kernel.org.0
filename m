Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F171726F923
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgIRJXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:23:53 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47368 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbgIRJXx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 05:23:53 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id ECFDC1A0252;
        Fri, 18 Sep 2020 11:16:19 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7DA3E1A0057;
        Fri, 18 Sep 2020 11:16:16 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id E7299402AA;
        Fri, 18 Sep 2020 11:16:11 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [v4, 0/5] dpaa2_eth: support 1588 one-step timestamping
Date:   Fri, 18 Sep 2020 17:07:57 +0800
Message-Id: <20200918090802.13757-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
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
Changes for v4:
	- Used WARN_ONCE instead of netdev_err in data path.
	- Enabled timestamping only when PTP driver is ready.
	- Added comments in using onestep_tstamp_lock.
	- Dropped dpmac.c sparse warning fix-up patch.

Yangbo Lu (5):
  dpaa2-eth: add APIs of 1588 single step timestamping
  dpaa2-eth: define a global ptp_qoriq structure pointer
  dpaa2-eth: invoke dpaa2_eth_enable_tx_tstamp() once in code
  dpaa2-eth: utilize skb->cb[0] for hardware timestamping
  dpaa2-eth: support PTP Sync packet one-step timestamping

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 227 ++++++++++++++++++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  44 +++-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |   7 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c   |   3 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h   |   4 +
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h    |  21 ++
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |  79 +++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h        |  31 +++
 8 files changed, 379 insertions(+), 37 deletions(-)

-- 
2.7.4

