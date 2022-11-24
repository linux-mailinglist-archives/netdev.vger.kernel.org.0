Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DB0636FF3
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 02:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiKXBnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 20:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiKXBnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 20:43:02 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCE04A584;
        Wed, 23 Nov 2022 17:43:00 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NHgdL1rzvzqSZ1;
        Thu, 24 Nov 2022 09:39:02 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 09:42:57 +0800
Message-ID: <801c9133-b776-a78e-8e98-6ea0f4238dfa@huawei.com>
Date:   Thu, 24 Nov 2022 09:42:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [syzbot] unregister_netdevice: waiting for DEV to become free (7)
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Bernard Metzler <bmt@zurich.ibm.com>
CC:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com>,
        Leon Romanovsky <leon@kernel.org>, <chenzhongjin@huawei.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Bob Pearson <rpearsonhpe@gmail.com>
References: <00000000000060c7e305edbd296a@google.com>
 <CACT4Y+a=HbyJE3A_SnKm3Be-kcQytxXXF89gZ_cN1gwoAW-Zgw@mail.gmail.com>
 <Y3wwOPmH1WoRj0Uo@ziepe.ca> <ecc8b532-4e80-b7bd-3621-78cd55fd48fa@huawei.com>
 <2f54056f-0acf-e088-c6cc-9ffce77bbe24@linux.dev> <Y365S5s5qRQvm8m0@ziepe.ca>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <Y365S5s5qRQvm8m0@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/11/24 8:22, Jason Gunthorpe 写道:
> On Wed, Nov 23, 2022 at 05:45:53PM +0800, Guoqing Jiang wrote:
>> But it is the caller's responsibility to destroy it since commit
>> dd37d2f59eb8.
>>
>>> The causes are as follows:
>>>
>>> rdma_listen()
>>>    rdma_bind_addr()
>>>      cma_acquire_dev_by_src_ip()
>>>        cma_attach_to_dev()
>>>          _cma_attach_to_dev()
>>>            cma_dev_get()
>>
>> Thanks for the analysis.
>>
>> And for the two callers of cma_listen_on_dev, looks they have
>> different behaviors with regard to handling failure.
> 
> Yes, the CM is not the problem, and that print from it is unrelated
> 
Yes, I misanalyzed earlier.

> I patched in netdevice_tracker and get this:
> 
> [  237.475070][ T7541] unregister_netdevice: waiting for vlan0 to become free. Usage count = 2
> [  237.477311][ T7541] leaked reference.
> [  237.478378][ T7541]  ib_device_set_netdev+0x266/0x730
> [  237.479848][ T7541]  siw_newlink+0x4e0/0xfd0
> [  237.481100][ T7541]  nldev_newlink+0x35c/0x5c0
> [  237.482121][ T7541]  rdma_nl_rcv_msg+0x36d/0x690
> [  237.483312][ T7541]  rdma_nl_rcv+0x2ee/0x430
> [  237.484483][ T7541]  netlink_unicast+0x543/0x7f0
> [  237.485746][ T7541]  netlink_sendmsg+0x918/0xe20
> [  237.486866][ T7541]  sock_sendmsg+0xcf/0x120
> [  237.488006][ T7541]  ____sys_sendmsg+0x70d/0x8b0
> [  237.489294][ T7541]  ___sys_sendmsg+0x11d/0x1b0
> [  237.490404][ T7541]  __sys_sendmsg+0xfa/0x1d0
> [  237.491451][ T7541]  do_syscall_64+0x35/0xb0
> [  237.492566][ T7541]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Which seems to confirm my original prediction, except this is siw not
> rxe..
> 
Rxe dose not have this issue, maybe because it does not support vlan dev.

> Maybe rxe was the wrong guess, or maybe it is troubled too in other
> reports?


> 
> Jason
