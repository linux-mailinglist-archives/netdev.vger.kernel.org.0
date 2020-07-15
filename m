Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF7B220D07
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgGOMiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:38:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57400 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726968AbgGOMiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:38:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06FCUnIV018206;
        Wed, 15 Jul 2020 05:38:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=qSfO5pMOtlBzkyu2NSbe0hPl0yDaRvB3IFuU6rF4cS4=;
 b=e+5JBO90Wwurk+GiDi8ehHeKriu0mLaBnFHEX+rUb/YXpNFVeeT+nA8QLjznZrlQvaTa
 LTKQHgkmEL3wFuSjodhfY15nEpAIDnYZDMhE022lxUJhUCjD8Y4iA1gidXNIyYe8FYIX
 DUOFRfnZgYs3TVJSeVuslgME4WcGJGf9HCpVsFM54y8+rUb+7NC3X9oUMos09MqIcjme
 JH3fBIT82+ENsb4+KBzx7SD0vbzg7IKYL9vi8CtKbr1RysjgR1CxIxwHAW/DZJz3litF
 L3VDaalmoodyE+1b97Im8EhO0b4Tj8d30/9/Ry57RfwyRttcKLqvrX6N5BJLCzMKk2if 9g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asnhhkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 05:38:16 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 05:38:16 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 05:38:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 05:38:15 -0700
Received: from hyd1358.caveonetworks.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 15F653F703F;
        Wed, 15 Jul 2020 05:38:12 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>
Subject: [PATCH v4 net-next 0/3] Add PTP support for Octeontx2
Date:   Wed, 15 Jul 2020 18:08:06 +0530
Message-ID: <1594816689-5935-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_11:2020-07-15,2020-07-15 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset adds PTP support for Octeontx2 platform.
PTP is an independent coprocessor block from which
CGX block fetches timestamp and prepends it to the
packet before sending to NIX block. Patches are as
follows:

Patch 1: Patch to enable/disable packet timstamping
	 in CGX upon mailbox request. It also adjusts
	 packet parser (NPC) for the 8 bytes timestamp
	 appearing before the packet.

Patch 2: Patch adding PTP pci driver which configures
	 the PTP block and hooks up to RVU AF driver.
	 It also exposes a mailbox call to adjust PTP
	 hardware clock.

Patch 3: Patch adding PTP clock driver for PF netdev.


Aleksey Makarov (2):
  octeontx2-af: Add support for Marvell PTP coprocessor
  octeontx2-pf: Add support for PTP clock

Zyta Szpak (1):
  octeontx2-af: Support to enable/disable HW timestamping

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  29 +++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   4 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  21 ++
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    | 244 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |  22 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  29 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  54 +++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  52 +++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  27 +++
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  19 ++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  28 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 170 +++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  | 209 ++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.h  |  13 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  87 +++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   1 +
 20 files changed, 1016 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h

-- 
2.7.4

