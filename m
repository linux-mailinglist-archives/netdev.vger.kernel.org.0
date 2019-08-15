Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889B68EC7A
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732168AbfHONMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:12:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59378 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731282AbfHONMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 09:12:02 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 12B529F445E8D19AE68A;
        Thu, 15 Aug 2019 20:55:55 +0800 (CST)
Received: from [127.0.0.1] (10.133.205.80) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 15 Aug 2019
 20:55:53 +0800
Subject: Re: [PATCH] tun: fix use-after-free when register netdev failed
To:     Jason Wang <jasowang@redhat.com>, <netdev@vger.kernel.org>
References: <1565857122-24660-1-git-send-email-yangyingliang@huawei.com>
 <f9dd102e-e3b4-6522-6094-63aa31b890ea@redhat.com>
CC:     <xiyou.wangcong@gmail.com>, <davem@davemloft.net>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <5D555659.60307@huawei.com>
Date:   Thu, 15 Aug 2019 20:55:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <f9dd102e-e3b4-6522-6094-63aa31b890ea@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.205.80]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/8/15 17:21, Jason Wang wrote:
>
> On 2019/8/15 下午4:18, Yang Yingliang wrote:
>> I got a UAF repport in tun driver when doing fuzzy test:
>>
>> [  466.269490] 
>> ==================================================================
>> [  466.271792] BUG: KASAN: use-after-free in 
>> tun_chr_read_iter+0x2ca/0x2d0
>> [  466.271806] Read of size 8 at addr ffff888372139250 by task 
>> tun-test/2699
>> [  466.271810]
>> [  466.271824] CPU: 1 PID: 2699 Comm: tun-test Not tainted 
>> 5.3.0-rc1-00001-g5a9433db2614-dirty #427
>> [  466.271833] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
>> BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
>> [  466.271838] Call Trace:
>> [  466.271858]  dump_stack+0xca/0x13e
>> [  466.271871]  ? tun_chr_read_iter+0x2ca/0x2d0
>> [  466.271890]  print_address_description+0x79/0x440
>> [  466.271906]  ? vprintk_func+0x5e/0xf0
>> [  466.271920]  ? tun_chr_read_iter+0x2ca/0x2d0
>> [  466.271935]  __kasan_report+0x15c/0x1df
>> [  466.271958]  ? tun_chr_read_iter+0x2ca/0x2d0
>> [  466.271976]  kasan_report+0xe/0x20
>> [  466.271987]  tun_chr_read_iter+0x2ca/0x2d0
>> [  466.272013]  do_iter_readv_writev+0x4b7/0x740
>> [  466.272032]  ? default_llseek+0x2d0/0x2d0
>> [  466.272072]  do_iter_read+0x1c5/0x5e0
>> [  466.272110]  vfs_readv+0x108/0x180
>> [  466.299007]  ? compat_rw_copy_check_uvector+0x440/0x440
>> [  466.299020]  ? fsnotify+0x888/0xd50
>> [  466.299040]  ? __fsnotify_parent+0xd0/0x350
>> [  466.299064]  ? fsnotify_first_mark+0x1e0/0x1e0
>> [  466.304548]  ? vfs_write+0x264/0x510
>> [  466.304569]  ? ksys_write+0x101/0x210
>> [  466.304591]  ? do_preadv+0x116/0x1a0
>> [  466.304609]  do_preadv+0x116/0x1a0
>> [  466.309829]  do_syscall_64+0xc8/0x600
>> [  466.309849]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  466.309861] RIP: 0033:0x4560f9
>> [  466.309875] Code: 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 
>> 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 
>> 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 
>> 89 01 48
>> [  466.309889] RSP: 002b:00007ffffa5166e8 EFLAGS: 00000206 ORIG_RAX: 
>> 0000000000000127
>> [  466.322992] RAX: ffffffffffffffda RBX: 0000000000400460 RCX: 
>> 00000000004560f9
>> [  466.322999] RDX: 0000000000000003 RSI: 00000000200008c0 RDI: 
>> 0000000000000003
>> [  466.323007] RBP: 00007ffffa516700 R08: 0000000000000004 R09: 
>> 0000000000000000
>> [  466.323014] R10: 0000000000000000 R11: 0000000000000206 R12: 
>> 000000000040cb10
>> [  466.323021] R13: 0000000000000000 R14: 00000000006d7018 R15: 
>> 0000000000000000
>> [  466.323057]
>> [  466.323064] Allocated by task 2605:
>> [  466.335165]  save_stack+0x19/0x80
>> [  466.336240]  __kasan_kmalloc.constprop.8+0xa0/0xd0
>> [  466.337755]  kmem_cache_alloc+0xe8/0x320
>> [  466.339050]  getname_flags+0xca/0x560
>> [  466.340229]  user_path_at_empty+0x2c/0x50
>> [  466.341508]  vfs_statx+0xe6/0x190
>> [  466.342619]  __do_sys_newstat+0x81/0x100
>> [  466.343908]  do_syscall_64+0xc8/0x600
>> [  466.345303]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  466.347034]
>> [  466.347517] Freed by task 2605:
>> [  466.348471]  save_stack+0x19/0x80
>> [  466.349476]  __kasan_slab_free+0x12e/0x180
>> [  466.350726]  kmem_cache_free+0xc8/0x430
>> [  466.351874]  putname+0xe2/0x120
>> [  466.352921]  filename_lookup+0x257/0x3e0
>> [  466.354319]  vfs_statx+0xe6/0x190
>> [  466.355498]  __do_sys_newstat+0x81/0x100
>> [  466.356889]  do_syscall_64+0xc8/0x600
>> [  466.358037]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  466.359567]
>> [  466.360050] The buggy address belongs to the object at 
>> ffff888372139100
>> [  466.360050]  which belongs to the cache names_cache of size 4096
>> [  466.363735] The buggy address is located 336 bytes inside of
>> [  466.363735]  4096-byte region [ffff888372139100, ffff88837213a100)
>> [  466.367179] The buggy address belongs to the page:
>> [  466.368604] page:ffffea000dc84e00 refcount:1 mapcount:0 
>> mapping:ffff8883df1b4f00 index:0x0 compound_mapcount: 0
>> [  466.371582] flags: 0x2fffff80010200(slab|head)
>> [  466.372910] raw: 002fffff80010200 dead000000000100 
>> dead000000000122 ffff8883df1b4f00
>> [  466.375209] raw: 0000000000000000 0000000000070007 
>> 00000001ffffffff 0000000000000000
>> [  466.377778] page dumped because: kasan: bad access detected
>> [  466.379730]
>> [  466.380288] Memory state around the buggy address:
>> [  466.381844]  ffff888372139100: fb fb fb fb fb fb fb fb fb fb fb fb 
>> fb fb fb fb
>> [  466.384009]  ffff888372139180: fb fb fb fb fb fb fb fb fb fb fb fb 
>> fb fb fb fb
>> [  466.386131] >ffff888372139200: fb fb fb fb fb fb fb fb fb fb fb fb 
>> fb fb fb fb
>> [  466.388257] ^
>> [  466.390234]  ffff888372139280: fb fb fb fb fb fb fb fb fb fb fb fb 
>> fb fb fb fb
>> [  466.392512]  ffff888372139300: fb fb fb fb fb fb fb fb fb fb fb fb 
>> fb fb fb fb
>> [  466.394667] 
>> ==================================================================
>>
>> tun_chr_read_iter() accessed the memory which freed by free_netdev()
>> called by tun_set_iff():
>>
>>     CPUA                CPUB
>>      tun_set_iff()
>>        alloc_netdev_mqs()
>>        tun_attach()
>>                     tun_chr_read_iter()
>>                       tun_get()
>>        register_netdevice()
>>        tun_detach_all()
>>          synchronize_net()
>>                       tun_do_read()
>>                         tun_ring_recv()
>>                           schedule()
>>        free_netdev()
>>                       tun_put() <-- UAF
>>
>> Set a new bit in tun->flag if register_netdevice() successed,
>> without this bit, tun_get() returns NULL to avoid using a
>> freed tun pointer.
>
>
> Good catch.
>
> Some comments inline.
>
>
>>
>> Fixes: eb0fb363f920 ("tuntap: attach queue 0 before registering 
>> netdevice")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/net/tun.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index db16d7a13e00..cbd60c276c40 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -115,6 +115,7 @@ do {                                \
>>   /* High bits in flags field are unused. */
>>   #define TUN_VNET_LE     0x80000000
>>   #define TUN_VNET_BE     0x40000000
>> +#define TUN_DEV_REGISTERED    0x20000000
>>     #define TUN_FEATURES (IFF_NO_PI | IFF_ONE_QUEUE | IFF_VNET_HDR | \
>>                 IFF_MULTI_QUEUE | IFF_NAPI | IFF_NAPI_FRAGS)
>> @@ -719,8 +720,10 @@ static void __tun_detach(struct tun_file *tfile, 
>> bool clean)
>>               netif_carrier_off(tun->dev);
>>                 if (!(tun->flags & IFF_PERSIST) &&
>> -                tun->dev->reg_state == NETREG_REGISTERED)
>> +                tun->dev->reg_state == NETREG_REGISTERED) {
>>                   unregister_netdevice(tun->dev);
>> +                tun->flags &= ~TUN_DEV_REGISTERED;
>> +            }
>>           }
>>           if (tun)
>>               xdp_rxq_info_unreg(&tfile->xdp_rxq);
>> @@ -884,8 +887,10 @@ static struct tun_struct *tun_get(struct 
>> tun_file *tfile)
>>         rcu_read_lock();
>>       tun = rcu_dereference(tfile->tun);
>> -    if (tun)
>> +    if (tun && (tun->flags & TUN_DEV_REGISTERED))
>>           dev_hold(tun->dev);
>> +    else
>> +        tun = NULL;
>>       rcu_read_unlock();
>>         return tun;
>> @@ -2836,6 +2841,7 @@ static int tun_set_iff(struct net *net, struct 
>> file *file, struct ifreq *ifr)
>>           err = register_netdevice(tun->dev);
>>           if (err < 0)
>>               goto err_detach;
>> +        tun->flags |= TUN_DEV_REGISTERED;
>>       }
>>         netif_carrier_on(tun->dev);
>
>
> This looks just a duplicated of netdev->state? However it lacks 
> sufficient synchronization like barriers or locks. How about:
It's not same, register_netdevice() will return error if 
call_netdevice_notifiers() failed after dev->reg_state is set to 
NETREG_REGISTERED.
>
> - call tun_set_real_num_queues() before register_netdevice() this can 
> have the same result as what  eb0fb363f920 did.
> - move tun_attach() after register_netdevice() this makes sure we 
> won't publish tfile->tun until we are sure at least one refcnt is held 
> by register_netdevice()?
Yes, I think this way is better, I will try this later.
>
> Thanks
>
>
> .
>


