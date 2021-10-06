Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406BB4238B3
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbhJFHU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:20:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40306 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229861AbhJFHUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 03:20:54 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19623DPL028833;
        Wed, 6 Oct 2021 00:18:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pfpt0220;
 bh=SxWksmwfxwt9KRUyWgmbzlC2wYB2rrtBNdYVAhJKnOY=;
 b=LjV4BK5ksXSbMvr3ybfczv+nvvRJxxpu/R9PN2NPzM9N6UMr9J6n6t4rGbVKsBdYrQUS
 NlleIcYYaKSK7Phym27TLvOTG13tdide2FmAfHZAjXaUSbNeEpE9/Uj5BM3/W+B6BN/8
 oMqH19+IxdvoHqw3METkhp56Wl4yoXKRUwLptkcNca7HncoMzvLkbnBrKNw/Ri5i/iSd
 fawKfAY9YfxvP7R6yCk58/WM16Tu47d0FJcend5bRw62hnW0KnFhePVxC9UWltbeqOmq
 U019GSMp0Q2OryBbTGzGvrWhgbdCgxyx7bk9rS+rr1NL8XD4pEN7KDDv/q6G3cIEIITq MA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bgr1qkj7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 00:18:59 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 6 Oct
 2021 00:18:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 6 Oct 2021 00:18:57 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 315453F704C;
        Wed,  6 Oct 2021 00:18:54 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH v2 0/3] Add devlink params to vary cqe and rbuf
Date:   Wed, 6 Oct 2021 12:48:43 +0530
Message-ID: <1633504726-30751-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: JcnLNfqbkQp3pWXx64IdEIO8fdQGJ-iG
X-Proofpoint-GUID: JcnLNfqbkQp3pWXx64IdEIO8fdQGJ-iG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_06,2021-10-04_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Octeontx2 hardware writes a Completion Queue Entry(CQE) in the
memory provided by software when a packet is received or
transmitted. CQE has the buffer pointers (IOVAs) where the
packet data fragments are written by hardware. One 128 byte
CQE can hold 6 buffer pointers and a 512 byte CQE can hold
42 buffer pointers. Hence large packets can be received either
by using 512 byte CQEs or by increasing size of receive buffers.
Current driver only supports 128 byte CQEs.
This patchset adds devlink params to change CQE and receive
buffer sizes which inturn helps to tune whether many small size
buffers or less big size buffers are needed to receive larger
packets. Below is the patches description:

Patch 1 - This prepares for 512 byte CQE operation by
seperating out transmit side and receive side config.
Also simplifies existing rbuf size calculation.

Patch 2 - Adds devlink param to change cqe. Basically
sets new config and toggles interface to cleanup and init properly.

Patch 3 - Similar to patch 2 and adds devlink param to
change receive buffer size


v2 changes:
Fixed compilation error in patch 1
error: ‘struct otx2_nic’ has no member named ‘max_frs’



Thanks,
Sundeep


Subbaraya Sundeep (3):
  octeontx2-pf: Simplify the receive buffer size calculation
  octeontx2-pf: Add devlink param to vary cqe size
  octeontx2-pf: Add devlink param to vary rbuf size

 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  20 ++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  | 116 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  24 +++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  30 ++++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   4 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   7 ++
 8 files changed, 177 insertions(+), 30 deletions(-)

-- 
2.7.4

