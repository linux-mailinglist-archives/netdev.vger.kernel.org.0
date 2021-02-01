Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0396130A219
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 07:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhBAGm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 01:42:57 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56968 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231508AbhBAFZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 00:25:58 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1115Luqn005337;
        Sun, 31 Jan 2021 21:24:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=M607Xx7ODJ4SslAPfQywdejQPMsoVMNdNbBPDkA7ImQ=;
 b=fH0c7UG/ommVf/BgAJL4JsK7d7ggy8yCStNcyLiOfKAWg7wSSD5BHXWeVOrDhluFX5Ae
 RNEW3CXrXelpwQvh015H2XUAQ03TLOfjrdopC48UcPWvPJNAPiC2TQl6TYcAIF5ifJkg
 n0aI4naotr3KPi7N9HbY2uSbNSK2yI/zzsw+06SyYhP3xzLg09u7gLXob9ODDe4JRxyO
 uwRR52Fm2YjuUqCGRB5jt9UC8iAz7l85KdAAF86M2HzgbdhRMt1rzsbAo6BQulwEzCRY
 pL9l153umfRgMkq6a0TMudcmD7hOYNLUWPuSiKov8BQyJe72/GJ3ZHpYKR5G1A2NpR4N 4Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq2s4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 21:24:51 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 21:24:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 21:24:49 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id C89503F703F;
        Sun, 31 Jan 2021 21:24:45 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [Patch v3 net-next 0/7] ethtool support for fec and link configuration
Date:   Mon, 1 Feb 2021 10:54:37 +0530
Message-ID: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_02:2021-01-29,2021-02-01 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support for forward error correction(fec) and
physical link configuration. Patches 1&2 adds necessary mbox handlers for fec
mode configuration request and to fetch stats. Patch 3 registers driver
callbacks for fec mode configuration and display. Patch 4&5 adds support of mbox
handlers for configuring link parameters like speed/duplex and autoneg etc.
Patche 6&7 registers driver callbacks for physical link configuration.

Change-log:
v2:
	- Fixed review comments
	- Corrected indentation issues
        - Return -ENOMEM incase of mbox allocation failure
	- added validation for input fecparams bitmask values
        - added more comments

V3:
	- Removed inline functions
        - Make use of ethtool helpers APIs to display supported
          advertised modes
        - corrected indentation issues
        - code changes such that return early in case of failure
          to aid branch prediction


Christina Jacob (6):
  octeontx2-af: forward error correction configuration
  octeontx2-pf: ethtool fec mode support
  octeontx2-af: Physical link configuration support
  octeontx2-af: advertised link modes support on cgx
  octeontx2-pf: ethtool physical link status
  octeontx2-pf: ethtool physical link configuration

Felix Manlunas (1):
  octeontx2-af: Add new CGX_CMD to get PHY FEC statistics

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 258 ++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  10 +
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |  70 +++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  87 ++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  80 +++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  20 ++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 399 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
 10 files changed, 930 insertions(+), 7 deletions(-)

--
2.7.4
