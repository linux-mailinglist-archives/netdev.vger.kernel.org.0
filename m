Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F9631AA37
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 06:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhBMFgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 00:36:44 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:51246 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhBMFgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 00:36:43 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 11D52i4r025400;
        Sat, 13 Feb 2021 00:06:23 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 36ntxd0ath-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 13 Feb 2021 00:06:22 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Sat, 13 Feb 2021 00:06:21 -0500
Received: from localhost (132.158.202.108) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 13 Feb 2021 00:06:21 -0500
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v2 net-next 0/3] ptp: ptp_clockmatrix: Fix output 1 PPS alignment.
Date:   Sat, 13 Feb 2021 00:06:03 -0500
Message-ID: <1613192766-14010-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-13_01:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 mlxlogscore=849 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102130041
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

This series fixes a race condition that may result in the output clock
not aligned to internal 1 PPS clock.

Part of device initialization is to align the rising edge of output
clocks to the internal rising edge of the 1 PPS clock.  If the system
APLL and DPLL are not locked when this alignment occurs, the alignment
fails and a fixed offset between the internal 1 PPS clock and the
output clock occurs.

If a clock is dynamically enabled after power-up, the output clock
also needs to be aligned to the internal 1 PPS clock.

v2:
Suggested by: Richard Cochran <richardcochran@gmail.com>
- Added const to "char * fmt"
- Break unrelated header change into separate patch

Vincent Cheng (3):
  ptp: ptp_clockmatrix: Add wait_for_sys_apll_dpll_lock.
  ptp: ptp_clockmatrix: Add alignment of 1 PPS to idtcm_perout_enable.
  ptp: ptp_clockmatrix: Remove unused header declarations.

 drivers/ptp/idt8a340_reg.h    | 10 +++++
 drivers/ptp/ptp_clockmatrix.c | 92 ++++++++++++++++++++++++++++++++++++++++---
 drivers/ptp/ptp_clockmatrix.h | 17 +++++++-
 3 files changed, 112 insertions(+), 7 deletions(-)

-- 
2.7.4

