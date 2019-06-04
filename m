Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60F133F69
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 08:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfFDG7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 02:59:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfFDG7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 02:59:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x546rrlt100536;
        Tue, 4 Jun 2019 06:58:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=S0K9HT3E8cy7EzJRdJ6FyizC+4WKbxDZM2xufcbe59U=;
 b=hGffxMcfTPPxMWJ+hQq37dH/kU/dXMNfPPenFzsDE7+Aq5zzEKwdBnjB4u59yfwTbN35
 4pNKCn4ZvChAoLA/yVvSjquj8aGaGbczMLqrV1RhytLh3UZSY5XX7ZuLTSK2E40gCBUg
 BuRZPBx0N8KieYo8rZBXAruGON0mqRoIiPiE7A7tPjHJsovyI97pXy473Mu8qXYTv4hf
 CP04a2FDXqlW4s2Q9C9ePSW/4uoWcXuylHLTZKJIwCcO4A3JiSba5dot5sTxIMpSejel
 t2ai8a1aIF0yq2v8yMwQbiF9LSl/ijvKBzOL6Sd6Bfihl+ZydjACpT4ubXwIgRHcVRuX eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2suj0qb00e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 06:58:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x546wFkl013607;
        Tue, 4 Jun 2019 06:58:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2svnn8p90r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 04 Jun 2019 06:58:58 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x546wvOS014787;
        Tue, 4 Jun 2019 06:58:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2svnn8p90k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 06:58:57 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x546wuAS019842;
        Tue, 4 Jun 2019 06:58:56 GMT
Received: from [10.182.69.170] (/10.182.69.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Jun 2019 23:58:56 -0700
Subject: Re: [PATCH 1/1] net: rds: fix memory leak when unload rds_rdma
To:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com,
        =?UTF-8?B?aGFha29uLmJ1Z2dlQG9yYWNsZS5jb20gPj4gSMOla29uIEJ1Z2dl?= 
        <haakon.bugge@oracle.com>
References: <1559566099-30289-1-git-send-email-yanjun.zhu@oracle.com>
 <80d57531-761e-9465-23bd-a9b8d9e30e66@oracle.com>
From:   Yanjun Zhu <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <041e760e-5cd7-42e9-5d95-149cb4bc06cd@oracle.com>
Date:   Tue, 4 Jun 2019 14:58:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <80d57531-761e-9465-23bd-a9b8d9e30e66@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040047
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, All

The steps to reproduce this problem. And  it is easy to reproduce.

1. boot with 5.2.0-rc2+, and KASAN is also enabled in this kernel

2. run the following scripts:

"

for i in `seq 0 5`
do
         rds-ping -c 2 1.1.1.14 -Q $i
done

"

3. run "rmmod rds_rdma"

4. check /var/log/dmesg, the following will appear.

"

BUG rds_ib_incoming (Tainted: G           OE    ): Objects remaining in 
rds_ib_incoming on __kmem_cache_shutdown()
-----------------------------------------------------------------------------
Disabling lock debugging due to kernel taint
INFO: Slab 0x00000000e0306204 objects=32 used=1 fp=0x0000000050936906 
flags=0x17fffc000010200
CPU: 20 PID: 6643 Comm: rmmod Tainted: G    B      OE 5.2.0-rc2+ #1
Hardware name: Oracle Corporation SUN FIRE X4170 M2 SERVER 
/ASSY,MOTHERBOARD,X4170, BIOS 08140112 08/03/2016
Call Trace:
dump_stack+0x71/0xab
slab_err+0xad/0xd0
? __kasan_kmalloc+0xd5/0xf0
? kasan_unpoison_shadow+0x31/0x40
__kmem_cache_shutdown+0x17d/0x370
shutdown_cache+0x17/0x130
kmem_cache_destroy+0x1df/0x210
rds_ib_recv_exit+0x11/0x20 [rds_rdma]
rds_ib_exit+0x7a/0x90 [rds_rdma]
__x64_sys_delete_module+0x224/0x2c0
? __ia32_sys_delete_module+0x2c0/0x2c0
do_syscall_64+0x73/0x190
entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f424d53b457
Code: 73 01 c3 48 8b 0d 19 7a 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 
f0 ff ff 73 01 c3 48 8b 0d e9 79 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe70e8f048 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
RAX: ffffffffffffffda RBX: 0000000001bc1210 RCX: 00007f424d53b457
RDX: 00007f424d5afbe0 RSI: 0000000000000800 RDI: 0000000001bc1278
RBP: 0000000000000000 R08: 00007f424d804060 R09: 00007f424d5afbe0
R10: 00007ffe70e8ec10 R11: 0000000000000206 R12: 00007ffe70e90879
R13: 0000000000000000 R14: 0000000001bc1210 R15: 0000000001bc1010
INFO: Object 0x000000003c6e3538 @offset=0
kmem_cache_destroy rds_ib_incoming: Slab cache still has objects
CPU: 20 PID: 6643 Comm: rmmod Tainted: G    B      OE 5.2.0-rc2+ #1
Hardware name: Oracle Corporation SUN FIRE X4170 M2 SERVER 
/ASSY,MOTHERBOARD,X4170, BIOS 08140112 08/03/2016
Call Trace:
dump_stack+0x71/0xab
kmem_cache_destroy+0x1fd/0x210
rds_ib_recv_exit+0x11/0x20 [rds_rdma]
rds_ib_exit+0x7a/0x90 [rds_rdma]
__x64_sys_delete_module+0x224/0x2c0
? __ia32_sys_delete_module+0x2c0/0x2c0
do_syscall_64+0x73/0x190
entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f424d53b457
Code: 73 01 c3 48 8b 0d 19 7a 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 
f0 ff ff 73 01 c3 48 8b 0d e9 79 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe70e8f048 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
RAX: ffffffffffffffda RBX: 0000000001bc1210 RCX: 00007f424d53b457
RDX: 00007f424d5afbe0 RSI: 0000000000000800 RDI: 0000000001bc1278
RBP: 0000000000000000 R08: 00007f424d804060 R09: 00007f424d5afbe0
R10: 00007ffe70e8ec10 R11: 0000000000000206 R12: 00007ffe70e90879
R13: 0000000000000000 R14: 0000000001bc1210 R15: 0000000001bc1010
=============================================================================
BUG rds_ib_frag (Tainted: G    B      OE    ): Objects remaining in 
rds_ib_frag on __kmem_cache_shutdown()
-----------------------------------------------------------------------------
INFO: Slab 0x00000000b70dee4a objects=32 used=1 fp=0x000000001dde4640 
flags=0x17fffc000000200
CPU: 21 PID: 6643 Comm: rmmod Tainted: G    B      OE 5.2.0-rc2+ #1
Hardware name: Oracle Corporation SUN FIRE X4170 M2 SERVER 
/ASSY,MOTHERBOARD,X4170, BIOS 08140112 08/03/2016
Call Trace:
dump_stack+0x71/0xab
slab_err+0xad/0xd0
? __kasan_kmalloc+0xd5/0xf0
? kasan_unpoison_shadow+0x31/0x40
__kmem_cache_shutdown+0x17d/0x370
shutdown_cache+0x17/0x130
kmem_cache_destroy+0x1df/0x210
rds_ib_exit+0x7a/0x90 [rds_rdma]
__x64_sys_delete_module+0x224/0x2c0
? __ia32_sys_delete_module+0x2c0/0x2c0
do_syscall_64+0x73/0x190
entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f424d53b457
Code: 73 01 c3 48 8b 0d 19 7a 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 
f0 ff ff 73 01 c3 48 8b 0d e9 79 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe70e8f048 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
RAX: ffffffffffffffda RBX: 0000000001bc1210 RCX: 00007f424d53b457
RDX: 00007f424d5afbe0 RSI: 0000000000000800 RDI: 0000000001bc1278
RBP: 0000000000000000 R08: 00007f424d804060 R09: 00007f424d5afbe0
R10: 00007ffe70e8ec10 R11: 0000000000000206 R12: 00007ffe70e90879
R13: 0000000000000000 R14: 0000000001bc1210 R15: 0000000001bc1010
INFO: Object 0x000000001d5f42ef @offset=0
kmem_cache_destroy rds_ib_frag: Slab cache still has objects
CPU: 21 PID: 6643 Comm: rmmod Tainted: G    B      OE 5.2.0-rc2+ #1
Hardware name: Oracle Corporation SUN FIRE X4170 M2 SERVER 
/ASSY,MOTHERBOARD,X4170, BIOS 08140112 08/03/2016
Call Trace:
dump_stack+0x71/0xab
kmem_cache_destroy+0x1fd/0x210
rds_ib_exit+0x7a/0x90 [rds_rdma]
__x64_sys_delete_module+0x224/0x2c0
? __ia32_sys_delete_module+0x2c0/0x2c0
do_syscall_64+0x73/0x190
entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f424d53b457
Code: 73 01 c3 48 8b 0d 19 7a 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 
f0 ff ff 73 01 c3 48 8b 0d e9 79 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe70e8f048 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
RAX: ffffffffffffffda RBX: 0000000001bc1210 RCX: 00007f424d53b457
RDX: 00007f424d5afbe0 RSI: 0000000000000800 RDI: 0000000001bc1278
RBP: 0000000000000000 R08: 00007f424d804060 R09: 00007f424d5afbe0
R10: 00007ffe70e8ec10 R11: 0000000000000206 R12: 00007ffe70e90879
R13: 0000000000000000 R14: 0000000001bc1210 R15: 0000000001bc1010
Unregistered RDS/infiniband transport

"

5. after this commit is applied. Repeat the above steps. Check 
/var/log/dmesg,

only the following appear.

"

[101287.926043] Unregistered RDS/infiniband transport

"

So IMO, this commit fixes this problem. The root cause is in the commit log.

Zhu Yanjun

On 2019/6/3 20:43, Yanjun Zhu wrote:
> Sorry. Add Håkon Bugge <haakon.bugge@oracle.com>
>
> He told me to notice the memory leak when caches are freed.
>
> Zhu Yanjun
>
> On 2019/6/3 20:48, Zhu Yanjun wrote:
>> When KASAN is enabled, after several rds connections are
>> created, then "rmmod rds_rdma" is run. The following will
>> appear.
>>
>> "
>> BUG rds_ib_incoming (Not tainted): Objects remaining
>> in rds_ib_incoming on __kmem_cache_shutdown()
>>
>> Call Trace:
>>   dump_stack+0x71/0xab
>>   slab_err+0xad/0xd0
>>   __kmem_cache_shutdown+0x17d/0x370
>>   shutdown_cache+0x17/0x130
>>   kmem_cache_destroy+0x1df/0x210
>>   rds_ib_recv_exit+0x11/0x20 [rds_rdma]
>>   rds_ib_exit+0x7a/0x90 [rds_rdma]
>>   __x64_sys_delete_module+0x224/0x2c0
>>   ? __ia32_sys_delete_module+0x2c0/0x2c0
>>   do_syscall_64+0x73/0x190
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> "
>> This is rds connection memory leak. The root cause is:
>> When "rmmod rds_rdma" is run, rds_ib_remove_one will call
>> rds_ib_dev_shutdown to drop the rds connections.
>> rds_ib_dev_shutdown will call rds_conn_drop to drop rds
>> connections as below.
>> "
>> rds_conn_path_drop(&conn->c_path[0], false);
>> "
>> In the above, destroy is set to false.
>> void rds_conn_path_drop(struct rds_conn_path *cp, bool destroy)
>> {
>>          atomic_set(&cp->cp_state, RDS_CONN_ERROR);
>>
>>          rcu_read_lock();
>>          if (!destroy && rds_destroy_pending(cp->cp_conn)) {
>>                  rcu_read_unlock();
>>                  return;
>>          }
>>          queue_work(rds_wq, &cp->cp_down_w);
>>          rcu_read_unlock();
>> }
>> In the above function, destroy is set to false. rds_destroy_pending
>> is called. This does not move rds connections to ib_nodev_conns.
>> So destroy is set to true to move rds connections to ib_nodev_conns.
>> In rds_ib_unregister_client, flush_workqueue is called to make rds_wq
>> finsh shutdown rds connections. The function rds_ib_destroy_nodev_conns
>> is called to shutdown rds connections finally.
>> Then rds_ib_recv_exit is called to destroy slab.
>>
>> void rds_ib_recv_exit(void)
>> {
>>          kmem_cache_destroy(rds_ib_incoming_slab);
>>          kmem_cache_destroy(rds_ib_frag_slab);
>> }
>> The above slab memory leak will not occur again.
>>
>> >From tests,
>> 256 rds connections
>> [root@ca-dev14 ~]# time rmmod rds_rdma
>>
>> real    0m16.522s
>> user    0m0.000s
>> sys     0m8.152s
>> 512 rds connections
>> [root@ca-dev14 ~]# time rmmod rds_rdma
>>
>> real    0m32.054s
>> user    0m0.000s
>> sys     0m15.568s
>>
>> To rmmod rds_rdma with 256 rds connections, about 16 seconds are needed.
>> And with 512 rds connections, about 32 seconds are needed.
>> >From ftrace, when one rds connection is destroyed,
>>
>> "
>>   19)               |  rds_conn_destroy [rds]() {
>>   19)   7.782 us    |    rds_conn_path_drop [rds]();
>>   15)               |  rds_shutdown_worker [rds]() {
>>   15)               |    rds_conn_shutdown [rds]() {
>>   15)   1.651 us    |      rds_send_path_reset [rds]();
>>   15)   7.195 us    |    }
>>   15) + 11.434 us   |  }
>>   19)   2.285 us    |    rds_cong_remove_conn [rds]();
>>   19) * 24062.76 us |  }
>> "
>> So if many rds connections will be destroyed, this function
>> rds_ib_destroy_nodev_conns uses most of time.
>>
>> Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>> ---
>>   net/rds/ib.c      | 2 +-
>>   net/rds/ib_recv.c | 3 +++
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/rds/ib.c b/net/rds/ib.c
>> index f9baf2d..ec05d91 100644
>> --- a/net/rds/ib.c
>> +++ b/net/rds/ib.c
>> @@ -87,7 +87,7 @@ static void rds_ib_dev_shutdown(struct 
>> rds_ib_device *rds_ibdev)
>>         spin_lock_irqsave(&rds_ibdev->spinlock, flags);
>>       list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
>> -        rds_conn_drop(ic->conn);
>> +        rds_conn_path_drop(&ic->conn->c_path[0], true);
>>       spin_unlock_irqrestore(&rds_ibdev->spinlock, flags);
>>   }
>>   diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
>> index 8946c89..3cae88c 100644
>> --- a/net/rds/ib_recv.c
>> +++ b/net/rds/ib_recv.c
>> @@ -168,6 +168,7 @@ void rds_ib_recv_free_caches(struct 
>> rds_ib_connection *ic)
>>           list_del(&inc->ii_cache_entry);
>>           WARN_ON(!list_empty(&inc->ii_frags));
>>           kmem_cache_free(rds_ib_incoming_slab, inc);
>> +        atomic_dec(&rds_ib_allocation);
>>       }
>>         rds_ib_cache_xfer_to_ready(&ic->i_cache_frags);
>> @@ -1057,6 +1058,8 @@ int rds_ib_recv_init(void)
>>     void rds_ib_recv_exit(void)
>>   {
>> +    WARN_ON(atomic_read(&rds_ib_allocation));
>> +
>>       kmem_cache_destroy(rds_ib_incoming_slab);
>>       kmem_cache_destroy(rds_ib_frag_slab);
>>   }
>
