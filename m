Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA455A24FE
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245408AbiHZJvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241772AbiHZJvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:51:53 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C38D758A;
        Fri, 26 Aug 2022 02:51:50 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VNIZezx_1661507507;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VNIZezx_1661507507)
          by smtp.aliyun-inc.com;
          Fri, 26 Aug 2022 17:51:48 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [PATCH net-next v2 00/10] optimize the parallelism of SMC-R connections
Date:   Fri, 26 Aug 2022 17:51:27 +0800
Message-Id: <cover.1661407821.git.alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This patch set attempts to optimize the parallelism of SMC-R connections,
mainly to reduce unnecessary blocking on locks, and to fix exceptions that
occur after thoses optimization.

According to Off-CPU graph, SMC worker's off-CPU as that: 

smc_close_passive_work			(1.09%)
	smcr_buf_unuse			(1.08%)
		smc_llc_flow_initiate	(1.02%)
	
smc_listen_work 			(48.17%)
	__mutex_lock.isra.11 		(47.96%)


An ideal SMC-R connection process should only block on the IO events
of the network, but it's quite clear that the SMC-R connection now is
queued on the lock most of the time.

The goal of this patchset is to achieve our ideal situation where
network IO events are blocked for the majority of the connection lifetime.

There are three big locks here:

1. smc_client_lgr_pending & smc_server_lgr_pending

2. llc_conf_mutex

3. rmbs_lock & sndbufs_lock

And an implementation issue:

1. confirm/delete rkey msg can't be sent concurrently while
protocol allows indeed.

Unfortunately,The above problems together affect the parallelism of
SMC-R connection. If any of them are not solved. our goal cannot
be achieved.

After this patch set, we can get a quite ideal off-CPU graph as
following:

smc_close_passive_work					(41.58%)
	smcr_buf_unuse					(41.57%)
		smc_llc_do_delete_rkey			(41.57%)

smc_listen_work						(39.10%)
	smc_clc_wait_msg				(13.18%)
		tcp_recvmsg_locked			(13.18)
	smc_listen_find_device				(25.87%)
		smcr_lgr_reg_rmbs			(25.87%)
			smc_llc_do_confirm_rkey		(25.87%)

We can see that most of the waiting times are waiting for network IO
events. This also has a certain performance improvement on our
short-lived conenction wrk/nginx benchmark test:

+--------------+------+------+-------+--------+------+--------+
|conns/qps     |c4    | c8   |  c16  |  c32   | c64  |  c200  |
+--------------+------+------+-------+--------+------+--------+
|SMC-R before  |9.7k  | 10k  |  10k  |  9.9k  | 9.1k |  8.9k  | 
+--------------+------+------+-------+--------+------+--------+
|SMC-R now     |13k   | 19k  |  18k  |  16k   | 15k  |  12k   |
+--------------+------+------+-------+--------+------+--------+
|TCP	       |15k   | 35k  |  51k  |  80k   | 100k |  162k  |
+--------------+------+------+-------+--------+------+--------+

The reason why the benefit is not obvious after the number of connections
has increased dues to workqueue. If we try to change workqueue to UNBOUND,
we can obtain at least 4-5 times performance improvement, reach up to half
of TCP. However, this is not an elegant solution, the optimization of it
will be much more complicated. But in any case, we will submit relevant
optimization patches as soon as possible.

Please note that the premise here is that the lock related problem
must be solved first, otherwise, no matter how we optimize the workqueue,
there won't be much improvement. 

Because there are a lot of related changes to the code, if you have
any questions or suggestions, please let me know.

Thanks
D. Wythe

v1 -> v2:

1. Fix panic in SMC-D scenario
2. Fix lnkc related hashfn calculation exception, caused by operator
priority.
3. Remove -EBUSY processing of rhashtable_insert_fast, see more details
in comments around smcr_link_get_or_create_cluster().
4. Only wake up one connection if the link has not been active.
5. Delete obsolete unlock logic in smc_listen_work().
6. PATCH format, do Reverse Christmas tree.
7. PATCH format, change all xxx_lnk_xxx function to xxx_link_xxx.
8. PATCH format, add correct fix tag for the patches for fixes.
9. PATCH format, fix some spelling error.
10.PATCH format, rename slow to do_slow in smcr_lgr_reg_rmbs().


D. Wythe (10):
  net/smc: remove locks smc_client_lgr_pending and
    smc_server_lgr_pending
  net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
  net/smc: allow confirm/delete rkey response deliver multiplex
  net/smc: make SMC_LLC_FLOW_RKEY run concurrently
  net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
  net/smc: use read semaphores to reduce unnecessary blocking in
    smc_buf_create() & smcr_buf_unuse()
  net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
  net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
  net/smc: Fix potential panic dues to unprotected
    smc_llc_srv_add_link()
  net/smc: fix application data exception

 net/smc/af_smc.c   |  42 +++--
 net/smc/smc_core.c | 443 +++++++++++++++++++++++++++++++++++++++++++++++------
 net/smc/smc_core.h |  78 +++++++++-
 net/smc/smc_llc.c  | 286 +++++++++++++++++++++++++---------
 net/smc/smc_llc.h  |   6 +
 net/smc/smc_wr.c   |  10 --
 net/smc/smc_wr.h   |  10 ++
 7 files changed, 725 insertions(+), 150 deletions(-)

-- 
1.8.3.1

