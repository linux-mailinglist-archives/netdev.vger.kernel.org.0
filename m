Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673F748078D
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 10:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbhL1JD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 04:03:28 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:35412 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229843AbhL1JD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 04:03:28 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V057BOz_1640682205;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V057BOz_1640682205)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 17:03:26 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: [PATCH net 0/2] net/smc: fix kernel panic caused by race of smc_sock
Date:   Tue, 28 Dec 2021 17:03:23 +0800
Message-Id: <20211228090325.27263-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes the race between smc_release triggered by
close(2) and cdc_handle triggered by underlaying RDMA device.

The race is caused because the smc_connection may been released
before the pending tx CDC messages got its CQEs. In order to fix
this, I add a counter to track how many pending WRs we have posted
through the smc_connection, and only release the smc_connection
after there is no pending WRs on the connection.

The first patch prevents posting WR on a QP that is not in RTS
state. This patch is needed because if we post WR on a QP that
is not in RTS state, ib_post_send() may success but no CQE will
return, and that will confuse the counter tracking the pending
WRs.

The second patch add a counter to track how many WRs were posted
through the smc_connection, and don't reset the QP on link destroying
to prevent leak of the counter.

Dust Li (2):
  net/smc: don't send CDC/LLC message if link not ready
  net/smc: fix kernel panic caused by race of smc_sock

 net/smc/smc.h      |  5 +++++
 net/smc/smc_cdc.c  | 52 +++++++++++++++++++++-------------------------
 net/smc/smc_cdc.h  |  2 +-
 net/smc/smc_core.c | 27 ++++++++++++++++++------
 net/smc/smc_core.h |  6 ++++++
 net/smc/smc_ib.c   |  4 ++--
 net/smc/smc_ib.h   |  1 +
 net/smc/smc_llc.c  |  2 +-
 net/smc/smc_wr.c   | 45 +++++----------------------------------
 net/smc/smc_wr.h   |  5 ++---
 10 files changed, 68 insertions(+), 81 deletions(-)

-- 
2.19.1.3.ge56e4f7

