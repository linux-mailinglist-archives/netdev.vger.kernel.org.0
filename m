Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938E3607BA2
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiJUP50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiJUP5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:57:16 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC0A280EC7;
        Fri, 21 Oct 2022 08:57:07 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VSk0LZR_1666367822;
Received: from 30.32.123.91(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VSk0LZR_1666367822)
          by smtp.aliyun-inc.com;
          Fri, 21 Oct 2022 23:57:04 +0800
Message-ID: <4127d84d-e3b4-ca44-2531-8aed12fdee3f@linux.alibaba.com>
Date:   Fri, 21 Oct 2022 23:57:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v3 00/10] optimize the parallelism of SMC-R
 connections
Content-Language: en-US
To:     Jan Karcher <jaka@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
 <62001adc-129a-d477-c916-7a4cf2000553@linux.alibaba.com>
 <79e3bccb-55c2-3b92-b14a-7378ef02dd78@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <79e3bccb-55c2-3b92-b14a-7378ef02dd78@linux.ibm.com>
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

Sorry for this bug. It's my bad to do not enough code checking, here is the problems:

int __init smc_core_init(void)
{
         int i;

         /* init smc lgr decision maker builder */
         for (i = 0; i < SMC_TYPE_D; i++)


i < SMC_TYPE_D should change to i <= SMC_TYPE_D, otherwise the SMC-D related
map has not init yet. i thinks the two bugs was all caused by it.


I has reproduced the first problem and verified that it can be fixed.
Please help me to see if the SMC-D problem can be fixed too after this change, thx.

By the way, Is there any way to simulate SMC-D dev for testing? All of our problems are caused by poor consideration on SMC-D.
In fact, we have some SMC-D related work plans in the future. It seems not a perfect way to bother you every time.


Best Wishes.
D. Wythe

On 10/21/22 7:57 PM, Jan Karcher wrote:
> 
> 
> On 20/10/2022 09:00, D. Wythe wrote:
>>
>> Hi Jan,
>>
>> Sorry for the long delay, The main purpose of v3 is to put optimizes also works on SMC-D, dues to the environment,
>> I can only tests it in SMC-R, so please help us to verify the stability and functional in SMC-D,
>> Thanks a lot.
>>
>> If you have any problems, please let us know.
>>
>> Besides, PATCH bug fixes need to be reordered. After the code review passes and the SMC-D test goes stable, I will adjust it
>> in next serial.
>>
>>
> 
> Hi D. Wythe,
> 
> thank you again for your submission. I ran the first tests and here are my findings:
> 
> For SMC-R we are facing problems during unloading of the smc module:
> 
> vvvvvvvvvv
> 
> [root@testsys10 ~]# dmesg -C
> [root@testsys10 ~]# dmesg
> [root@testsys10 ~]# rmmod ism
> [root@testsys10 ~]# rmmod smc_diag
> [root@testsys10 ~]# dmesg
> [   51.671365] smc: removing smcd device 1522:00:00.0
> [root@testsys10 ~]# rmmod smc
> [root@testsys10 ~]# dmesg
> [   51.671365] smc: removing smcd device 1522:00:00.0
> [   65.378445] NET: Unregistered PF_SMC protocol family
> [   65.378463] ------------[ cut here ]------------
> [   65.378465] WARNING: CPU: 0 PID: 1155 at kernel/workqueue.c:3066 __flush_work.isra.0+0x28a/0x298
> [   65.378476] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat mlx5_ib nf_conntrack ib_uverbs nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink mlx5_core smc(-) ib_core vfio_ccw s390_trng mdev vfio_iommu_type1 vfio sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 des_s390 libdes sha3_512_s390 sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common pkey zcrypt rng_core autofs4 [last unloaded: smc_diag]
> [   65.378509] CPU: 0 PID: 1155 Comm: rmmod Not tainted 6.1.0-rc1-00035-g9980a965416f #4
> [   65.378514] Hardware name: IBM 8561 T01 701 (z/VM 7.2.0)
> [   65.378517] Krnl PSW : 0704c00180000000 00000000f9d5f17e (__flush_work.isra.0+0x28e/0x298)
> [   65.378523]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> [   65.380675] Krnl GPRS: 8000000000000001 0000000000000000 000003ff7fd40270 0000000000000000
> [   65.380683]            0000038000c73d70 000e002100000000 0000000000000000 0000000000000001
> [   65.380686]            0000038000c73d70 0000000000000000 000003ff7fd40270 000003ff7fd40270
> [   65.380688]            000000009b8d2100 000003ffe38f98f8 0000038000c73cd0 0000038000c73c30
> [   65.380697] Krnl Code: 00000000f9d5f172: a7780000            lhi %r7,0
>                            00000000f9d5f176: a7f4ff7b            brc 15,00000000f9d5f06c
>                           #00000000f9d5f17a: af000000            mc      0,0
>                           >00000000f9d5f17e: a7780000            lhi %r7,0
>                            00000000f9d5f182: a7f4ff75            brc 15,00000000f9d5f06c
>                            00000000f9d5f186: 0707                bcr 0,%r7
>                            00000000f9d5f188: c004005daa34        brcl 0,00000000fa9145f0
>                            00000000f9d5f18e: ebaff0680024        stmg %r10,%r15,104(%r15)
> [   65.380773] Call Trace:
> [   65.380774]  [<00000000f9d5f17e>] __flush_work.isra.0+0x28e/0x298
> [   65.380779]  [<00000000f9d61228>] __cancel_work_timer+0x130/0x1c0
> [   65.380782]  [<00000000fa46b1b4>] rhashtable_free_and_destroy+0x2c/0x170
> [   65.380787]  [<000003ff7fd3a08e>] smc_exit+0x3e/0x1b8 [smc]
> [   65.380804]  [<00000000f9de946a>] __do_sys_delete_module+0x1a2/0x298
> [   65.380809]  [<00000000fa8f85ac>] __do_syscall+0x1d4/0x200
> [   65.380814]  [<00000000fa907722>] system_call+0x82/0xb0
> [   65.380817] Last Breaking-Event-Address:
> [   65.380818]  [<00000000f9d5ef24>] __flush_work.isra.0+0x34/0x298
> [   65.380820] ---[ end trace 0000000000000000 ]---
> [   65.380828] smc: removing ib device mlx5_0
> [   65.380833] smc: removing ib device mlx5_1
> 
> ^^^^^^^^^^
> 
> For SMC-D it seems like your decisionmaker is causing some troubles (crash). I did not have the time yet to look into it, i still dump you the console log - maybe you're seeing the problem faster then me:
> 
> 
> vvvvvvvvvv
> 
> [  135.528259] smc-tests: test_cs_security started
> [  136.397056] illegal operation: 0001 ilc:1 [#1] SMP
> [  136.397064] Modules linked in: tcp_diag inet_diag ism mlx5_ib ib_uverbs mlx5_core smc_diag smc ib_core vmur nft_fib_inet nft_fib_
> ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defra
> g_ipv6 nf_defrag_ipv4 ip_set nf_tab
> [  136.397093] CPU: 0 PID: 9 Comm: kworker/0:1 Not tainted 6.1.0-rc1-00035-g1c11cab281ca #4
> [  136.397098] Hardware name: IBM 8561 T01 701 (z/VM 7.2.0)
> [  136.397100] Workqueue: smc_hs_wq smc_listen_work [smc]
> [  136.397123] Krnl PSW : 0704e00180000000 0000000000000002 (0x2)
> [  136.397128]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> [  136.397133] Krnl GPRS: 0000000000000001 0000000000000000 00000000a5670600 0000000000000000
> 
> [  136.398410]            0000000000000000 000003ff7feee620 00000000000000c8 0000000000000000
> [  136.398417]            000003ff7feed2b8 00000000a5670600 000003ff7feed168 000003ff7fed1628
> [  136.398420]            0000000080334200 0000000000000001 000003ff7fed3ab0 0000037fffb5fa30
> [  136.398425] Krnl Code:#0000000000000000: 0000                illegal
> [  136.398425]           >0000000000000002: 0000                illegal
> [  136.398425]            0000000000000004: 0000                illegal
> [  136.398425]            0000000000000006: 0000                illegal
> [  136.398425]            0000000000000008: 0000                illegal
> [  136.398425]            000000000000000a: 0000                illegal
> [  136.398425]            000000000000000c: 0000                illegal
> [  136.398425]            000000000000000e: 0000                illegal
> [  136.398465] Call Trace:
> [  136.398469]  [<0000000000000002>] 0x2
> [  136.398472] ([<00000001790fdbde>] release_sock+0x6e/0xd8)
> [  136.398482]  [<000003ff7fed746a>] smc_conn_create+0xc2/0x9d8 [smc]
> 01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from CPU 01.
> 01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from CPU 00.
> 
> [  136.408436]  [<000003ff7fec8206>] smc_find_ism_v2_device_serv+0x186/0x288 [smc]
> [  136.408444]  [<000003ff7fec8336>] smc_listen_find_device+0x2e/0x370 [smc]
> [  136.408452]  [<000003ff7fecaa8a>] smc_listen_work+0x2ca/0x580 [smc]
> [  136.408459]  [<00000001788481e8>] process_one_work+0x200/0x458
> [  136.408466]  [<000000017884896e>] worker_thread+0x66/0x480
> [  136.408470]  [<0000000178851888>] kthread+0x108/0x110
> [  136.408474]  [<00000001787d72cc>] __ret_from_fork+0x3c/0x58
> [  136.408478]  [<00000001793ef75a>] ret_from_fork+0xa/0x40
> [  136.408484] Last Breaking-Event-Address:
> [  136.408486]  [<000003ff7fed3aae>] smc_get_or_create_lgr_decision_maker.constprop.0+0xe6/0x398 [smc]
> [  136.408495] Kernel panic - not syncing: Fatal exception in interrupt
> 
> ^^^^^^^^^^
> 
> - Jan
