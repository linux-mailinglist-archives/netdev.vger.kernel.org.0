Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40CF358157
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhDHLHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:07:33 -0400
Received: from inva020.nxp.com ([92.121.34.13]:50262 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231213AbhDHLH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 07:07:28 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 343321A44FE;
        Thu,  8 Apr 2021 13:07:16 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D63691A44F5;
        Thu,  8 Apr 2021 13:07:12 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id A975D402BB;
        Thu,  8 Apr 2021 13:07:08 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [net-next, v2, 0/2] enetc: support PTP Sync packet one-step timestamping
Date:   Thu,  8 Apr 2021 19:13:48 +0800
Message-Id: <20210408111350.3817-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set is to add one-step timestamping support for PTP Sync
packet. Since ENETC single-step register has to be configured dynamically
per packet for correctionField offeset and UDP checksum update, current
one-step timestamping packet has to be sent only when the last one
completes transmitting on hardware. So, on the TX the patch implements
below process:

- For one-step timestamping packet, queue to skb queue.
- Start a work to transmit skbs in queue.
- For other skbs, transmit immediately.
- mutex lock used to ensure the last one-step timestamping packet has
  already been transmitted on hardware before transmitting current one.

Changes for v2:
	- Rebased.
	- Fixed issues from patchwork checks.
	- netif_tx_lock for one-step timestamping packet sending.

Yangbo Lu (2):
  enetc: mark TX timestamp type per skb
  enetc: support PTP Sync packet one-step timestamping

 drivers/net/ethernet/freescale/enetc/enetc.c  | 212 ++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  24 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |   3 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   7 +
 4 files changed, 220 insertions(+), 26 deletions(-)


base-commit: 3cd52c1e32fe7dfee09815ced702db9ee9f84ec9
-- 
2.25.1

