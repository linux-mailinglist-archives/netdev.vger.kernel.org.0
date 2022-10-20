Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F9C6057D2
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJTHBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiJTHA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:00:58 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430AA110B1C;
        Thu, 20 Oct 2022 00:00:55 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VSe.paA_1666249247;
Received: from 30.221.146.23(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VSe.paA_1666249247)
          by smtp.aliyun-inc.com;
          Thu, 20 Oct 2022 15:00:52 +0800
Message-ID: <62001adc-129a-d477-c916-7a4cf2000553@linux.alibaba.com>
Date:   Thu, 20 Oct 2022 15:00:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v3 00/10] optimize the parallelism of SMC-R
 connections
Content-Language: en-US
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
In-Reply-To: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Jan,

Sorry for the long delay, The main purpose of v3 is to put optimizes also works on SMC-D, dues to the environment,
I can only tests it in SMC-R, so please help us to verify the stability and functional in SMC-D,
Thanks a lot.

If you have any problems, please let us know.

Besides, PATCH bug fixes need to be reordered. After the code review passes and the SMC-D test goes stable, I will adjust it
in next serial.


On 10/20/22 2:43 PM, D.Wythe wrote:
> From: "D.Wythe" <alibuda@linux.alibaba.com>
> 
> This patch set attempts to optimize the parallelism of SMC-R connections,
> mainly to reduce unnecessary blocking on locks, and to fix exceptions that
> occur after thoses optimization.
> 
> According to Off-CPU graph, SMC worker's off-CPU as that:
> 
> smc_close_passive_work                  (1.09%)
>          smcr_buf_unuse                  (1.08%)
>                  smc_llc_flow_initiate   (1.02%)
> 
> smc_listen_work                         (48.17%)
>          __mutex_lock.isra.11            (47.96%)
> 
> 
> An ideal SMC-R connection process should only block on the IO events
> of the network, but it's quite clear that the SMC-R connection now is
> queued on the lock most of the time.
> 
> The goal of this patchset is to achieve our ideal situation where
> network IO events are blocked for the majority of the connection lifetime.
> 
> There are three big locks here:
> 
> 1. smc_client_lgr_pending & smc_server_lgr_pending
> 
> 2. llc_conf_mutex
> 
> 3. rmbs_lock & sndbufs_lock
> 
> And an implementation issue:
> 
> 1. confirm/delete rkey msg can't be sent concurrently while
> protocol allows indeed.
> 
> Unfortunately,The above problems together affect the parallelism of
> SMC-R connection. If any of them are not solved. our goal cannot
> be achieved.
> 
> After this patch set, we can get a quite ideal off-CPU graph as
> following:
> 
> smc_close_passive_work                                  (41.58%)
>          smcr_buf_unuse                                  (41.57%)
>                  smc_llc_do_delete_rkey                  (41.57%)
> 
> smc_listen_work                                         (39.10%)
>          smc_clc_wait_msg                                (13.18%)
>                  tcp_recvmsg_locked                      (13.18)
>          smc_listen_find_device                          (25.87%)
>                  smcr_lgr_reg_rmbs                       (25.87%)
>                          smc_llc_do_confirm_rkey         (25.87%)
> 
> We can see that most of the waiting times are waiting for network IO
> events. This also has a certain performance improvement on our
> short-lived conenction wrk/nginx benchmark test:
> 
> +--------------+------+------+-------+--------+------+--------+
> |conns/qps     |c4    | c8   |  c16  |  c32   | c64  |  c200  |
> +--------------+------+------+-------+--------+------+--------+
> |SMC-R before  |9.7k  | 10k  |  10k  |  9.9k  | 9.1k |  8.9k  |
> +--------------+------+------+-------+--------+------+--------+
> |SMC-R now     |13k   | 19k  |  18k  |  16k   | 15k  |  12k   |
> +--------------+------+------+-------+--------+------+--------+
> |TCP           |15k   | 35k  |  51k  |  80k   | 100k |  162k  |
> +--------------+------+------+-------+--------+------+--------+
> 
> The reason why the benefit is not obvious after the number of connections
> has increased dues to workqueue. If we try to change workqueue to UNBOUND,
> we can obtain at least 4-5 times performance improvement, reach up to half
> of TCP. However, this is not an elegant solution, the optimization of it
> will be much more complicated. But in any case, we will submit relevant
> optimization patches as soon as possible.
> 
> Please note that the premise here is that the lock related problem
> must be solved first, otherwise, no matter how we optimize the workqueue,
> there won't be much improvement.
> 
> Because there are a lot of related changes to the code, if you have
> any questions or suggestions, please let me know.
> 
> Thanks
> D. Wythe
> 
> v1 -> v2:
> 
> 1. Fix panic in SMC-D scenario
> 2. Fix lnkc related hashfn calculation exception, caused by operator
> priority
> 3. Only wake up one connection if the lnk is not active
> 4. Delete obsolete unlock logic in smc_listen_work()
> 5. PATCH format, do Reverse Christmas tree
> 6. PATCH format, change all xxx_lnk_xxx function to xxx_link_xxx
> 7. PATCH format, add correct fix tag for the patches for fixes.
> 8. PATCH format, fix some spelling error
> 9. PATCH format, rename slow to do_slow
> 
> v2 -> v3:
> 
> 1. add SMC-D support, remove the concept of link cluster since SMC-D has
> no link at all. Replace it by lgr decision maker, who provides suggestions
> to SMC-D and SMC-R on whether to create new link group.
> 
> 2. Fix the corruption problem described by PATCH 'fix application
> data exception' on SMC-D.
> 
> D. Wythe (10):
>    net/smc: remove locks smc_client_lgr_pending and
>      smc_server_lgr_pending
>    net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
>    net/smc: allow confirm/delete rkey response deliver multiplex
>    net/smc: make SMC_LLC_FLOW_RKEY run concurrently
>    net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
>    net/smc: use read semaphores to reduce unnecessary blocking in
>      smc_buf_create() & smcr_buf_unuse()
>    net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
>    net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
>    net/smc: Fix potential panic dues to unprotected
>      smc_llc_srv_add_link()
>    net/smc: fix application data exception
> 
>   net/smc/af_smc.c   |  70 ++++----
>   net/smc/smc_core.c | 478 +++++++++++++++++++++++++++++++++++++++++++++++------
>   net/smc/smc_core.h |  36 +++-
>   net/smc/smc_llc.c  | 277 ++++++++++++++++++++++---------
>   net/smc/smc_llc.h  |   6 +
>   net/smc/smc_wr.c   |  10 --
>   net/smc/smc_wr.h   |  10 ++
>   7 files changed, 712 insertions(+), 175 deletions(-)
> 
