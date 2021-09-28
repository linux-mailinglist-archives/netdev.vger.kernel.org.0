Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5F041B558
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 19:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242044AbhI1Rph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 13:45:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10118 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241438AbhI1Rpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 13:45:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SHQdZL008783;
        Tue, 28 Sep 2021 10:43:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=vbkgzhZN0sAVFDDsp58RBo+1kkGXqFov6oAcUQccd8g=;
 b=JaPeSrlzux4c9TKH0CAFEP617wFZArOiueVm8/rfPZ4hGw9NORjn2g8iq8oPP1NJXLs8
 V862W5xHdkfnUcIfyNDUTm4EdZ52Lp2wYw6mN3l8M+oajtrdEFl/oUFxC1hzMYNeHYZN
 jORNklXyAGS1khCMLghhwL70eZJniUPYaPDVxmJtnUYGvTSTkIjHDqgte0zA62qtfSq0
 tZgNYnO5XTjfPljah5DamkrYygQZajwOEyk1RRz+HOHFL+bwEqI7IvvNuAuxICAHebdi
 4SoCR0iYs7i6jw2DRuTP60Y5NobZz9KjLY5gh58GRgtyK9WmrjD+mCq+KHP4cB/qsI73 yw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bc7eyg2ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 10:43:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 10:43:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 10:43:51 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id D2DBE3F707E;
        Tue, 28 Sep 2021 10:43:48 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        <naveenm@marvell.com>, <rsaladi2@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 0/2] Add PTP support for VFs
Date:   Tue, 28 Sep 2021 23:13:44 +0530
Message-ID: <1632851026-5415-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: k4KrG0HPESqUAh2p4bVz0ArCVHOcLt29
X-Proofpoint-ORIG-GUID: k4KrG0HPESqUAh2p4bVz0ArCVHOcLt29
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP is a shared hardware block which can prepend
RX timestamps to packets before directing packets to
PFs or VFs and can notify the TX timestamps to PFs or VFs
via TX completion queue descriptors. Hence adding PTP
support for VFs is exactly similar to PFs with minimal changes.
This patchset adds that PTP support for VFs.

Patch 1 - When an interface is set in promisc/multicast
the same setting is not retained when changing mtu or channels.
This is due to toggling of the interface by driver but not
calling set_rx_mode in the down-up sequence. Since setting
an interface to multicast properly is required for ptp this is
addressed in this patch.

Patch 2 - Changes in VF driver for registering timestamping
ethtool ops and ndo_ioctl. 

Thanks,
Sundeep


Naveen Mamindlapalli (1):
  octeontx2-nicvf: Add PTP hardware clock support to NIX VF

Rakesh Babu (1):
  octeontx2-pf: Enable promisc/allmulti match MCAM entries.

 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  3 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  3 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 84 ++++++++++++----------
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |  5 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  6 ++
 7 files changed, 66 insertions(+), 38 deletions(-)

-- 
2.7.4

