Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568AD283B25
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgJEPj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:39:57 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58602 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728249AbgJEPjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 11:39:54 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095FP2gr000880;
        Mon, 5 Oct 2020 08:39:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=znEg5N8vT1fCef3nG/uMxc75C4mDHlFEYI+Q7tFFv7U=;
 b=AMe036KXrolwCMGjjLN5wJyAEkppno1facrYh3oUh2dnnBMj0Awlb03hYX0L6VVXx8P0
 kTdL3hbpz3Y7ElP8/MuRQk9s9jAEAYmIBmKEaaoREuHYSCkTF94uMQvTrIy/j07i/9zP
 uppRz5xHK7Jzer9TsFlRkuCcNfnE0KYfKFtmjWRboQ3rJdRjC6UzaNUniu37uXIp7RFQ
 NbezBLrnr/gtx71tchLIynldygWWg04G2tfTiydT2yTxHgmSNCnbdZ9KIYkjAboWewGU
 QZ1rOPjk+T6lER7YIqXZnxX40GFJgCbAdr11zjFPGR37Mdr96TfIq+2xSZP3uRR76qPm ew== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33xrtncwjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 08:39:44 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Oct
 2020 08:39:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 5 Oct 2020 08:39:43 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.39.7])
        by maili.marvell.com (Postfix) with ESMTP id 485A03F703F;
        Mon,  5 Oct 2020 08:39:41 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v3 net-next 0/3] net: atlantic: phy tunables from mac driver
Date:   Mon, 5 Oct 2020 18:39:36 +0300
Message-ID: <20201005153939.248-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_11:2020-10-05,2020-10-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements phy tunables settings via MAC driver callbacks.

AQC 10G devices use integrated MAC+PHY solution, where PHY is fully controlled
by MAC firmware. Therefore, it is not possible to implement separate phy driver
for these.

We use ethtool ops callbacks to implement downshift and EDPC tunables.

v3: fixed flaw in EDPD logic, from Andrew
v2: comments from Andrew

Igor Russkikh (3):
  ethtool: allow netdev driver to define phy tunables
  net: atlantic: implement phy downshift feature
  net: atlantic: implement media detect feature via phy tunables

 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 53 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  6 +++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 50 +++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  4 ++
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 37 +++++++++++++
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 13 +++++
 include/linux/ethtool.h                       |  4 ++
 net/ethtool/ioctl.c                           | 37 ++++++++-----
 8 files changed, 191 insertions(+), 13 deletions(-)

-- 
2.17.1

