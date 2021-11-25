Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7434D45D4AB
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 07:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347215AbhKYG0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 01:26:08 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:43015 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347534AbhKYGYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 01:24:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UyESS1._1637821254;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UyESS1._1637821254)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 14:20:55 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net 0/2] Fixes for clcsock shutdown behaviors
Date:   Thu, 25 Nov 2021 14:19:31 +0800
Message-Id: <20211125061932.74874-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches fix issues when calling kernel_sock_shutdown(). To make
the solution clear, I split it into two patches.

Patch 1 keeps the return code of smc_close_final() in
smc_close_active(), which is more important than kernel_sock_shutdown().

Patch 2 doesn't call clcsock shutdown twice when applications call
smc_shutdown(). It should be okay to call kernel_sock_shutdown() twice,
I decide to avoid it for slightly speed up releasing socket.

Tony Lu (2):
  net/smc: Keep smc_close_final rc during active close
  net/smc: Don't call clcsock shutdown twice when smc shutdown

 net/smc/af_smc.c    | 8 ++++++++
 net/smc/smc_close.c | 8 ++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

-- 
2.32.0.3.g01195cf9f

