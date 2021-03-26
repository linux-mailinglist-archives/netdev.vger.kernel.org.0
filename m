Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5911D34A3B1
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 10:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCZJHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 05:07:51 -0400
Received: from inva020.nxp.com ([92.121.34.13]:58902 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhCZJHd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 05:07:33 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4C3441A3CDA;
        Fri, 26 Mar 2021 10:07:32 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 48C651A3CDD;
        Fri, 26 Mar 2021 10:07:29 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 7109B406BC;
        Fri, 26 Mar 2021 09:29:54 +0100 (CET)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH 0/2] enetc: support PTP Sync packet one-step timestamping
Date:   Fri, 26 Mar 2021 16:35:52 +0800
Message-Id: <20210326083554.28985-1-yangbo.lu@nxp.com>
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

Yangbo Lu (2):
  enetc: mark TX timestamp type per skb
  enetc: support PTP Sync packet one-step timestamping

 drivers/net/ethernet/freescale/enetc/enetc.c  | 206 ++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  24 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |   3 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   7 +
 4 files changed, 214 insertions(+), 26 deletions(-)

-- 
2.25.1

