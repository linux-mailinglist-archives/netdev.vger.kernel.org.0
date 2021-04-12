Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5506C35BEBF
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 11:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbhDLJBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 05:01:55 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36210 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238785AbhDLI5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 04:57:16 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D64EE1A1B85;
        Mon, 12 Apr 2021 10:56:57 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 842071A1B82;
        Mon, 12 Apr 2021 10:56:54 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 0AFF94032C;
        Mon, 12 Apr 2021 10:56:49 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [net-next, v3, 0/2] enetc: support PTP Sync packet one-step timestamping
Date:   Mon, 12 Apr 2021 17:03:25 +0800
Message-Id: <20210412090327.22330-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set is to add support for PTP Sync packet one-step timestamping.
Since ENETC single-step register has to be configured dynamically per
packet for correctionField offeset and UDP checksum update, current
one-step timestamping packet has to be sent only when the last one
completes transmitting on hardware. So, on the TX, this patch handles
one-step timestamping packet as below:

- Trasmit packet immediately if no other one in transfer, or queue to
  skb queue if there is already one in transfer.
  The test_and_set_bit_lock() is used here to lock and check state.
- Start a work when complete transfer on hardware, to release the bit
  lock and to send one skb in skb queue if has.

Changes for v2:
	- Rebased.
	- Fixed issues from patchwork checks.
	- netif_tx_lock for one-step timestamping packet sending.
Changes for v3:
	- Used system workqueue.
	- Set bit lock when transmitted one-step packet, and scheduled
	  work when completed. The worker cleared the bit lock, and
	  transmitted one skb in skb queue if has, instead of a loop.

Yangbo Lu (2):
  enetc: mark TX timestamp type per skb
  enetc: support PTP Sync packet one-step timestamping

 drivers/net/ethernet/freescale/enetc/enetc.c  | 193 ++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  23 ++-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |   3 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   7 +
 4 files changed, 200 insertions(+), 26 deletions(-)


base-commit: 5b489fea977c2b23e26e2f630478da0f4bfdc879
-- 
2.25.1

