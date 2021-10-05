Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9FD422EDE
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 19:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbhJERRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 13:17:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49550 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234459AbhJERRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 13:17:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195FuNX5026580;
        Tue, 5 Oct 2021 10:15:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=ODzWgPgY/UOcdL/xxI5MZHqqI5o/7wF30J7IX2H0DNQ=;
 b=bL5RpLBOHSDcmUsbrDDFA/xxPMkpINID94pw6HSAG+b8GZdk0rOgeGsFf6YIvtVQsTuN
 FNynxaALohIZHDS+33aHjkgS177ae23+d9T2K1+92mrsvJ+jzuPXTsZwvOTfwkdBJ/07
 fuCCRFhDZAP8miLgW9xtCvuL4JwP5QeNmUnrpun9aLGqoHyvEGg+YanvJmdQK1c2qMFe
 yhnI9dDkNwiTuwyqA7QL+oB9RnjXixxbNIoVyIUNs9Tu3XOOu1HnOZ7S5Ra1TZR6Z7t1
 Rb7Q/9ucZFZli3kSK4eXZnEHg35IeCs25PKq3sTMZZ3vA6pobspAocYA8bCe5oHQ2hDE Tw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bgmv5t48n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 10:15:44 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Oct
 2021 10:15:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 5 Oct 2021 10:15:42 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 6AC373F707C;
        Tue,  5 Oct 2021 10:15:40 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 0/3] Add devlink params to vary cqe and rbuf
Date:   Tue, 5 Oct 2021 22:45:33 +0530
Message-ID: <1633454136-14679-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: lUw1QPkgpgSwqCRiFTPBWyLnycn5-upv
X-Proofpoint-ORIG-GUID: lUw1QPkgpgSwqCRiFTPBWyLnycn5-upv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_03,2021-10-04_01,2020-04-07_01
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


Thanks,
Sundeep


Subbaraya Sundeep (3):
  octeontx2-pf: Simplify the receive buffer size calculation
  octeontx2-pf: Add devlink param to vary cqe size
  octeontx2-pf: Add devlink param to vary rbuf size

 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  20 ++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  | 116 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  24 +++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  30 ++++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   4 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   7 ++
 7 files changed, 176 insertions(+), 29 deletions(-)

-- 
2.7.4

