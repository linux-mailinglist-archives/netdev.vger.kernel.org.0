Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EC86144F7
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 08:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiKAHWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 03:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAHWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 03:22:49 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C5B14029;
        Tue,  1 Nov 2022 00:22:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VTebUcP_1667287362;
Received: from 30.221.145.108(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VTebUcP_1667287362)
          by smtp.aliyun-inc.com;
          Tue, 01 Nov 2022 15:22:44 +0800
Message-ID: <1615836b-3087-2467-262e-f402ec521716@linux.alibaba.com>
Date:   Tue, 1 Nov 2022 15:22:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v4 00/10] optimize the parallelism of SMC-R
 connections
Content-Language: en-US
To:     Jan Karcher <jaka@linux.ibm.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1666529042-40828-1-git-send-email-alibuda@linux.alibaba.com>
 <95feb2a1-d17a-6233-d3d0-eaebf26d2284@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <95feb2a1-d17a-6233-d3d0-eaebf26d2284@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

Our team conducted some code reviews over this, but unfortunately no obvious problems were found. Hence
we are waiting for Tony Lu's virtual SMC-D device to test, which is expected to come in this week.  Before that,
I wonder if your tests are running separately on separate PATCH? If so, I would like to please you to test
the first PATCH and the second PATCH together. I doubt that the problem repaired by the second PATCH
is the cause of this issues.

Best Wishes.
D. Wythe


On 10/24/22 9:11 PM, Jan Karcher wrote:
> Hi D. Wythe,
> 
> I re-run the tests with your fix.
> SMC-R works fine now. For SMC-D we still have the following problem. It is kind of the same as i reported in v2 but even weirder:
> 
> smc stats:
> 
> t8345011
> SMC-D Connections Summary
>    Total connections handled          2465
> SMC-R Connections Summary
>    Total connections handled           232
> 
> t8345010
> SMC-D Connections Summary
>    Total connections handled          2290
> SMC-R Connections Summary
>    Total connections handled           231
> 
> 
> smc linkgroups:
> 
> t8345011
> [root@t8345011 ~]# smcr linkgroup
> LG-ID    LG-Role  LG-Type  VLAN  #Conns  PNET-ID
> 00000400 SERV     SYM         0       0  NET25
> [root@t8345011 ~]# smcd linkgroup
> LG-ID    VLAN  #Conns  PNET-ID
> 00000300    0      16  NET25
> 
> t8345010
> [root@t8345010 tela-kernel]# smcr linkgroup
> LG-ID    LG-Role  LG-Type  VLAN  #Conns  PNET-ID
> 00000400 CLNT     SYM         0       0  NET25
> [root@t8345010 tela-kernel]# smcd linkgroup
> LG-ID    VLAN  #Conns  PNET-ID
> 00000300    0       1  NET25
> 
> 
> smcss:
> 
> t8345011
> [root@t8345011 ~]# smcss
> State          UID   Inode   Local Address           Peer Address     Intf Mode
> 
> t8345010
> [root@t8345010 tela-kernel]# smcss
> State          UID   Inode   Local Address           Peer Address     Intf Mode
> 
> 
> lsmod:
> 
> t8345011
> [root@t8345011 ~]# lsmod | grep smc
> smc                   225280  18 ism,smc_diag
> t8345010
> [root@t8345010 tela-kernel]# lsmod | grep smc
> smc                   225280  3 ism,smc_diag
> 
> Also smc_dbg and netstat do not show any more information on this problem. We only see in the dmesg that the code seems to build up SMC-R linkgroups even tho we are running the SMC-D tests.
> NOTE: we disabled the syncookies for the tests.
> 
> dmesg:
> 
> t8345011
> smc-tests: test_smcapp_torture_test started
> kernel: TCP: request_sock_TCP: Possible SYN flooding on port 22465. Dropping request.  Check SNMP counters.
> kernel: smc: SMC-R lg 00000400 net 1 link added: id 00000401, peerid 00000401, ibdev mlx5_0, ibport 1
> kernel: smc: SMC-R lg 00000400 net 1 state changed: SINGLE, pnetid NET25
> kernel: smc: SMC-R lg 00000400 net 1 link added: id 00000402, peerid 00000402, ibdev mlx5_1, ibport 1
> kernel: smc: SMC-R lg 00000400 net 1 state changed: SYMMETRIC, pnetid NET25
> 
> t8345010
> smc-tests: test_smcapp_torture_test started
> kernel: smc: SMC-R lg 00000400 net 1 link added: id 00000401, peerid 00000401, ibdev mlx5_0, ibport 1
> kernel: smc: SMC-R lg 00000400 net 1 state changed: SINGLE, pnetid NET25
> kernel: smc: SMC-R lg 00000400 net 1 link added: id 00000402, peerid 00000402, ibdev mlx5_1, ibport 1
> kernel: smc: SMC-R lg 00000400 net 1 state changed: SYMMETRIC, pnetid NET25
> 
> If this output does not help and if you want us to look deeper into it feel free to let us know and we can debug further.
> 
> On 23/10/2022 14:43, D.Wythe wrote:
>> From: "D.Wythe" <alibuda@linux.alibaba.com>
>>
>> This patch set attempts to optimize the parallelism of SMC-R connections,
>> mainly to reduce unnecessary blocking on locks, and to fix exceptions that
>> occur after thoses optimization.
>>
>> According to Off-CPU graph, SMC worker's off-CPU as that:
>>
>> smc_close_passive_work                  (1.09%)
>>          smcr_buf_unuse                  (1.08%)
>>                  smc_llc_flow_initiate   (1.02%)
>>
>> smc_listen_work                         (48.17%)
>>          __mutex_lock.isra.11            (47.96%)
>>
>>
>> An ideal SMC-R connection process should only block on the IO events
>> of the network, but it's quite clear that the SMC-R connection now is
>> queued on the lock most of the time.
>>
>> The goal of this patchset is to achieve our ideal situation where
>> network IO events are blocked for the majority of the connection lifetime.
>>
>> There are three big locks here:
>>
>> 1. smc_client_lgr_pending & smc_server_lgr_pending
>>
>> 2. llc_conf_mutex
>>
>> 3. rmbs_lock & sndbufs_lock
>>
>> And an implementation issue:
>>
>> 1. confirm/delete rkey msg can't be sent concurrently while
>> protocol allows indeed.
>>
>> Unfortunately,The above problems together affect the parallelism of
>> SMC-R connection. If any of them are not solved. our goal cannot
>> be achieved.
>>
>> After this patch set, we can get a quite ideal off-CPU graph as
>> following:
>>
>> smc_close_passive_work                                  (41.58%)
>>          smcr_buf_unuse                                  (41.57%)
>>                  smc_llc_do_delete_rkey                  (41.57%)
>>
>> smc_listen_work                                         (39.10%)
>>          smc_clc_wait_msg                                (13.18%)
>>                  tcp_recvmsg_locked                      (13.18)
>>          smc_listen_find_device                          (25.87%)
>>                  smcr_lgr_reg_rmbs                       (25.87%)
>>                          smc_llc_do_confirm_rkey         (25.87%)
>>
>> We can see that most of the waiting times are waiting for network IO
>> events. This also has a certain performance improvement on our
>> short-lived conenction wrk/nginx benchmark test:
>>
>> +--------------+------+------+-------+--------+------+--------+
>> |conns/qps     |c4    | c8   |  c16  |  c32   | c64  |  c200  |
>> +--------------+------+------+-------+--------+------+--------+
>> |SMC-R before  |9.7k  | 10k  |  10k  |  9.9k  | 9.1k |  8.9k  |
>> +--------------+------+------+-------+--------+------+--------+
>> |SMC-R now     |13k   | 19k  |  18k  |  16k   | 15k  |  12k   |
>> +--------------+------+------+-------+--------+------+--------+
>> |TCP           |15k   | 35k  |  51k  |  80k   | 100k |  162k  |
>> +--------------+------+------+-------+--------+------+--------+
>>
>> The reason why the benefit is not obvious after the number of connections
>> has increased dues to workqueue. If we try to change workqueue to UNBOUND,
>> we can obtain at least 4-5 times performance improvement, reach up to half
>> of TCP. However, this is not an elegant solution, the optimization of it
>> will be much more complicated. But in any case, we will submit relevant
>> optimization patches as soon as possible.
>>
>> Please note that the premise here is that the lock related problem
>> must be solved first, otherwise, no matter how we optimize the workqueue,
>> there won't be much improvement.
>>
>> Because there are a lot of related changes to the code, if you have
>> any questions or suggestions, please let me know.
>>
>> Thanks
>> D. Wythe
>>
>> v1 -> v2:
>>
>> 1. Fix panic in SMC-D scenario
>> 2. Fix lnkc related hashfn calculation exception, caused by operator
>> priority
>> 3. Only wake up one connection if the lnk is not active
>> 4. Delete obsolete unlock logic in smc_listen_work()
>> 5. PATCH format, do Reverse Christmas tree
>> 6. PATCH format, change all xxx_lnk_xxx function to xxx_link_xxx
>> 7. PATCH format, add correct fix tag for the patches for fixes.
>> 8. PATCH format, fix some spelling error
>> 9. PATCH format, rename slow to do_slow
>>
>> v2 -> v3:
>>
>> 1. add SMC-D support, remove the concept of link cluster since SMC-D has
>> no link at all. Replace it by lgr decision maker, who provides suggestions
>> to SMC-D and SMC-R on whether to create new link group.
>>
>> 2. Fix the corruption problem described by PATCH 'fix application
>> data exception' on SMC-D.
>>
>> v3 -> v4:
>>
>> 1. Fix panic caused by uninitialization map.
>>
>> D. Wythe (10):
>>    net/smc: remove locks smc_client_lgr_pending and
>>      smc_server_lgr_pending
>>    net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
>>    net/smc: allow confirm/delete rkey response deliver multiplex
>>    net/smc: make SMC_LLC_FLOW_RKEY run concurrently
>>    net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
>>    net/smc: use read semaphores to reduce unnecessary blocking in
>>      smc_buf_create() & smcr_buf_unuse()
>>    net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
>>    net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
>>    net/smc: Fix potential panic dues to unprotected
>>      smc_llc_srv_add_link()
>>    net/smc: fix application data exception
>>
>>   net/smc/af_smc.c   |  70 ++++----
>>   net/smc/smc_core.c | 478 +++++++++++++++++++++++++++++++++++++++++++++++------
>>   net/smc/smc_core.h |  36 +++-
>>   net/smc/smc_llc.c  | 277 ++++++++++++++++++++++---------
>>   net/smc/smc_llc.h  |   6 +
>>   net/smc/smc_wr.c   |  10 --
>>   net/smc/smc_wr.h   |  10 ++
>>   7 files changed, 712 insertions(+), 175 deletions(-)
>>
