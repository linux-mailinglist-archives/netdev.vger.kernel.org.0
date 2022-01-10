Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3BA489529
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbiAJJ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:27:02 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:34021 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238188AbiAJJ1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 04:27:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1QvNC4_1641806784;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1QvNC4_1641806784)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 10 Jan 2022 17:26:59 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/3] net/smc: Fixes for race in smc link group termination
Date:   Mon, 10 Jan 2022 17:26:21 +0800
Message-Id: <1641806784-93141-1-git-send-email-guwen@linux.alibaba.com>
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

Wen Gu (3):
  net/smc: Resolve the race between link group access and termination
  net/smc: Introduce a new conn->lgr validity check helper
  net/smc: Resolve the race between SMC-R link access and clear

 net/smc/af_smc.c   |  6 +++-
 net/smc/smc.h      |  1 +
 net/smc/smc_cdc.c  |  3 +-
 net/smc/smc_clc.c  |  2 +-
 net/smc/smc_core.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++--------
 net/smc/smc_core.h | 12 +++++++
 net/smc/smc_diag.c |  6 ++--
 7 files changed, 104 insertions(+), 20 deletions(-)

-- 
1.8.3.1

