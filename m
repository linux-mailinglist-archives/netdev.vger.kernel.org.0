Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E066364EA
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238972AbiKWPzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237411AbiKWPzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:55:22 -0500
Received: from out199-2.us.a.mail.aliyun.com (out199-2.us.a.mail.aliyun.com [47.90.199.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544AE79E10;
        Wed, 23 Nov 2022 07:55:01 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VVXZuFA_1669218890;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VVXZuFA_1669218890)
          by smtp.aliyun-inc.com;
          Wed, 23 Nov 2022 23:54:57 +0800
From:   "D.Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v5 00/10] optimize the parallelism of SMC-R connections
Date:   Wed, 23 Nov 2022 23:54:40 +0800
Message-Id: <1669218890-115854-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D.Wythe" <alibuda@linux.alibaba.com>

This patch set attempts to optimize the parallelism of SMC-R connections,
mainly to reduce unnecessary blocking on locks, and to fix exceptions that
occur after thoses optimization.

According to Off-CPU graph, SMC worker's off-CPU as that:

smc_close_passive_work                  (1.09%)
        smcr_buf_unuse                  (1.08%)
                smc_llc_flow_initiate   (1.02%)

smc_listen_work                         (48.17%)
        __mutex_lock.isra.11            (47.96%)


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

smc_close_passive_work                                  (41.58%)
        smcr_buf_unuse                                  (41.57%)
                smc_llc_do_delete_rkey                  (41.57%)

smc_listen_work                                         (39.10%)
        smc_clc_wait_msg                                (13.18%)
                tcp_recvmsg_locked                      (13.18)
        smc_listen_find_device                          (25.87%)
                smcr_lgr_reg_rmbs                       (25.87%)
                        smc_llc_do_confirm_rkey         (25.87%)

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
|TCP           |15k   | 35k  |  51k  |  80k   | 100k |  162k  |
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
priority
3. Only wake up one connection if the lnk is not active
4. Delete obsolete unlock logic in smc_listen_work()
5. PATCH format, do Reverse Christmas tree
6. PATCH format, change all xxx_lnk_xxx function to xxx_link_xxx 
7. PATCH format, add correct fix tag for the patches for fixes.
8. PATCH format, fix some spelling error
9. PATCH format, rename slow to do_slow

v2 -> v3:

1. add SMC-D support, remove the concept of link cluster since SMC-D has
no link at all. Replace it by lgr decision maker, who provides suggestions
to SMC-D and SMC-R on whether to create new link group.

2. Fix the corruption problem described by PATCH 'fix application
data exception' on SMC-D.

v3 -> v4:

1. Fix panic caused by uninitialization map.

v4 -> v5:

1. Make SMC-D buf creation be serial to avoid Potential error
2. Add a flag to synchronize the success of the first contact
with the ready of the link group, including SMC-D and SMC-R.
3. Fixed possible reference count leak in smc_llc_flow_start(). 
4. reorder the patch, make bugfix PATCH be ahead.

D. Wythe (10):
  net/smc: Fix potential panic dues to unprotected
    smc_llc_srv_add_link()
  net/smc: fix application data exception
  net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
  net/smc: remove locks smc_client_lgr_pending and
    smc_server_lgr_pending
  net/smc: allow confirm/delete rkey response deliver multiplex
  net/smc: make SMC_LLC_FLOW_RKEY run concurrently
  net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
  net/smc: use read semaphores to reduce unnecessary blocking in
    smc_buf_create() & smcr_buf_unuse()
  net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
  net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore

 net/smc/af_smc.c   |  74 ++++----
 net/smc/smc_core.c | 541 +++++++++++++++++++++++++++++++++++++++++++++++------
 net/smc/smc_core.h |  53 +++++-
 net/smc/smc_llc.c  | 285 ++++++++++++++++++++--------
 net/smc/smc_llc.h  |   6 +
 net/smc/smc_wr.c   |  10 -
 net/smc/smc_wr.h   |  10 +
 7 files changed, 801 insertions(+), 178 deletions(-)

-- 
1.8.3.1

