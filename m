Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35F12C6FD
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfE1Mtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:49:46 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:18836 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfE1Mtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:49:45 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Joergen.Andreasen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="Joergen.Andreasen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Joergen.Andreasen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,523,1549954800"; 
   d="scan'208";a="34882554"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 May 2019 05:49:43 -0700
Received: from localhost (10.10.85.251) by mx.microchip.com (10.10.85.143)
 with Microsoft SMTP Server id 15.1.1713.5; Tue, 28 May 2019 05:49:37 -0700
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 0/1] Add hw offload of TC police on MSCC ocelot
Date:   Tue, 28 May 2019 14:49:16 +0200
Message-ID: <20190528124917.22034-1-joergen.andreasen@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190502094029.22526-1-joergen.andreasen@microchip.com>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series enables hardware offload of ingress port policing
on the MSCC ocelot board.

Changes v2 -> v3:

v3 now incorporates the following changes suggested by Jakub Kicinski:

 - Add a check in ndo_set_features() in order to prevent users to clear the
   NETIF_F_HW_TC flag while offload is active.

 - Reject the offload if the block is shared.

Changes v1 -> v2:

v2 now consists of only one patch: "[PATCH net-next v2 1/1] net: mscc:
ocelot: Implement port policers via tc command".

The patch, "[PATCH net-next 00/13] net: act_police offload support", from
Jakub Kicinski, removed the need for this patch:
"[PATCH net-next 1/3] net/sched: act_police: move police parameters".

Alexandre Belloni asked me to remove patch,
"[PATCH net-next 3/3] MIPS: generic: Add police related options to
ocelot_defconfig", from the series and instead send it through the MIPS
tree and I will do that.

The remaining patch is now the only patch in this series and all suggested
changes have been incorporated.

Joergen Andreasen (1):
  net: mscc: ocelot: Implement port policers via tc command

 drivers/net/ethernet/mscc/Makefile        |   2 +-
 drivers/net/ethernet/mscc/ocelot.c        |  13 +-
 drivers/net/ethernet/mscc/ocelot.h        |   3 +
 drivers/net/ethernet/mscc/ocelot_police.c | 227 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_police.h |  22 +++
 drivers/net/ethernet/mscc/ocelot_tc.c     | 174 +++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_tc.h     |  22 +++
 7 files changed, 460 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_police.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_police.h
 create mode 100644 drivers/net/ethernet/mscc/ocelot_tc.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_tc.h

-- 
2.17.1

