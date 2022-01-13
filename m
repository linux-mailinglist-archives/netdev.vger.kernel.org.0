Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5535248D3AF
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiAMIgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:36:53 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:58698 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231140AbiAMIgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 03:36:53 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1imC6N_1642063002;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1imC6N_1642063002)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 Jan 2022 16:36:51 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/3] net/smc: Fixes for race in smc link group termination
Date:   Thu, 13 Jan 2022 16:36:39 +0800
Message-Id: <1642063002-45688-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We encountered some crashes recently and they are caused by the
race between the access and free of link/link group in abnormal
smc link group termination. The crashes can be reproduced in
frequent abnormal link group termination, like setting RNICs up/down.

This set of patches tries to fix this by extending the life cycle
of link/link group to ensure that they won't be referred to after
cleared or freed.

v1 -> v2:
- Improve some comments.

- Move codes of waking up lgrs_deleted wait queue from smc_lgr_free()
  to __smc_lgr_free().

- Move codes of waking up links_deleted wait queue from smcr_link_clear()
  to __smcr_link_clear().

- Move codes of smc_ibdev_cnt_dec() and put_device() from smcr_link_clear()
  to __smcr_link_clear()

- Move smc_lgr_put() to the end of __smcr_link_clear().

- Call smc_lgr_put() after 'out' tag in smcr_link_init() when link
  initialization fails.

- Modify the location where smc connection holds the lgr or link.

    before:
      * hold lgr in smc_lgr_register_conn().
      * hold link in smcr_lgr_conn_assign_link().
    after:
      * hold both lgr and link in smc_conn_create().

  Modify the location to symmetrical with the place where smc connections
  put the lgr or link, which is smc_conn_free().

- Initialize conn->freed as zero in smc_conn_create().

Wen Gu (3):
  net/smc: Resolve the race between link group access and termination
  net/smc: Introduce a new conn->lgr validity check helper
  net/smc: Resolve the race between SMC-R link access and clear

 net/smc/af_smc.c   |   6 ++-
 net/smc/smc.h      |   1 +
 net/smc/smc_cdc.c  |   3 +-
 net/smc/smc_clc.c  |   2 +-
 net/smc/smc_core.c | 120 +++++++++++++++++++++++++++++++++++++++++------------
 net/smc/smc_core.h |  12 ++++++
 net/smc/smc_diag.c |   6 +--
 7 files changed, 118 insertions(+), 32 deletions(-)

-- 
1.8.3.1

