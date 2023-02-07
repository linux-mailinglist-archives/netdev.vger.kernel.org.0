Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9711B68D0A6
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 08:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjBGHg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 02:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBGHg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 02:36:27 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7991A144B0;
        Mon,  6 Feb 2023 23:36:25 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Vb6MLKQ_1675755374;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Vb6MLKQ_1675755374)
          by smtp.aliyun-inc.com;
          Tue, 07 Feb 2023 15:36:22 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [net-next 0/2] Deliver confirm/delete rkey message in parallel
Date:   Tue,  7 Feb 2023 15:36:12 +0800
Message-Id: <1675755374-107598-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

According to the SMC protocol specification, we know that all flows except
confirm_rkey adn delete_rkey are exclusive, confirm/delete rkey flows
can run concurrently (local and remote).

However, although the protocol allows, all flows are actually mutually
exclusive in implementation, deus to we are waiting for LLC message
in serial.

On the one hand, this implementation does not conform to the protocol
specification, on the other hand, this implementation aggravates the
time for establishing or destroying a SMC-R connection, connection
have to be queued in smc_llc_wait.

This patch will improve the performance of the short link scenario
by about 5%. In fact, we all know that the performance bottleneck
of the short link scenario is not here.

This patch try use rtokens or rkey to correlate a confirm/delete
rkey message with its response.

This patch contains two parts.

At first, we have added the process
of asynchronously waiting for the response of confirm/delete rkey
messages, using rtokens or rkey to be correlate with.

And then, we try to send confirm/delete rkey message in parallel,
allowing parallel execution of start (remote) or initialization (local)
SMC_LLC_FLOW_RKEY flows.

D. Wythe (2):
  net/smc: allow confirm/delete rkey response deliver multiplex
  net/smc: make SMC_LLC_FLOW_RKEY run concurrently

 net/smc/smc_core.h |   1 +
 net/smc/smc_llc.c  | 263 +++++++++++++++++++++++++++++++++++++++++------------
 net/smc/smc_llc.h  |   6 ++
 net/smc/smc_wr.c   |  10 --
 net/smc/smc_wr.h   |  10 ++
 5 files changed, 220 insertions(+), 70 deletions(-)

-- 
1.8.3.1

