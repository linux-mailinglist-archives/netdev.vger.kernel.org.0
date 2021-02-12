Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B8431996C
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 06:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhBLFHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 00:07:18 -0500
Received: from pbmsgap01.intersil.com ([192.157.179.201]:55182 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhBLFHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 00:07:14 -0500
X-Greylist: delayed 1629 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2021 00:07:13 EST
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 11C4Y2LJ016819;
        Thu, 11 Feb 2021 23:39:18 -0500
Received: from pbmxdp02.intersil.corp (pbmxdp02.pb.intersil.com [132.158.200.223])
        by pbmsgap01.intersil.com with ESMTP id 36hqh6adwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 23:39:18 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Thu, 11 Feb 2021 23:39:17 -0500
Received: from localhost (132.158.202.108) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 11 Feb 2021 23:39:16 -0500
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next 0/2] ptp: ptp_clockmatrix: Fix output 1 PPS alignment.
Date:   Thu, 11 Feb 2021 23:38:43 -0500
Message-ID: <1613104725-22056-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 mlxlogscore=923 adultscore=0
 spamscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120032
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

Vincent Cheng (2):
  ptp: ptp_clockmatrix: Add wait_for_sys_apll_dpll_lock.
  ptp: ptp_clockmatrix: Add alignment of 1 PPS to idtcm_perout_enable.

 drivers/ptp/idt8a340_reg.h    | 10 +++++
 drivers/ptp/ptp_clockmatrix.c | 92 ++++++++++++++++++++++++++++++++++++++++---
 drivers/ptp/ptp_clockmatrix.h | 17 +++++++-
 3 files changed, 112 insertions(+), 7 deletions(-)

-- 
2.7.4

