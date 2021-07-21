Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120AC3D0E32
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238598AbhGULOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 07:14:18 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:12231 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbhGUK6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 06:58:03 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GVD2P0ZHJz1CM0x;
        Wed, 21 Jul 2021 19:32:13 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 21 Jul 2021 19:37:59 +0800
Subject: Re: [PATCH net] can: raw: fix raw_rcv panic for sock UAF
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mkl@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20210721010937.670275-1-william.xuanziyang@huawei.com>
 <YPeoQG19PSh3B3Dc@kroah.com>
 <44c3e0e2-03c5-80e5-001c-03e7e9758bca@hartkopp.net>
 <11822417-5931-b2d8-ae77-ec4a84b8b895@hartkopp.net>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <d5eb8e8d-bce9-cccd-a102-b60692c242f0@huawei.com>
Date:   Wed, 21 Jul 2021 19:37:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <11822417-5931-b2d8-ae77-ec4a84b8b895@hartkopp.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/2021 5:24 PM, Oliver Hartkopp wrote:
> Answering myself ...
> 
> On 21.07.21 08:35, Oliver Hartkopp wrote:
>>
>>
>> On 21.07.21 06:53, Greg KH wrote:
>>> On Wed, Jul 21, 2021 at 09:09:37AM +0800, Ziyang Xuan wrote:
>>>> We get a bug during ltp can_filter test as following.
>>>>
>>>> ===========================================
>>>> [60919.264984] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
>>>> [60919.265223] PGD 8000003dda726067 P4D 8000003dda726067 PUD 3dda727067 PMD 0
>>>> [60919.265443] Oops: 0000 [#1] SMP PTI
>>>> [60919.265550] CPU: 30 PID: 3638365 Comm: can_filter Kdump: loaded Tainted: G        W         4.19.90+ #1
>>
>> This kernel version 4.19.90 is definitely outdated.
>>
>> Can you please check your issue with the latest uptream kernel as this problem should have been fixed with this patch:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8d0caedb759683041d9db82069937525999ada53
>> ("can: bcm/raw/isotp: use per module netdevice notifier")
>>
>> Thanks!
> 
> I think my hint had a wrong assumption. The suggestion to add some locking seems correct.
> 
>>>> [60919.266068] RIP: 0010:selinux_socket_sock_rcv_skb+0x3e/0x200
>>>> [60919.293289] RSP: 0018:ffff8d53bfc03cf8 EFLAGS: 00010246
>>>> [60919.307140] RAX: 0000000000000000 RBX: 000000000000001d RCX: 0000000000000007
>>>> [60919.320756] RDX: 0000000000000001 RSI: ffff8d5104a8ed00 RDI: ffff8d53bfc03d30
>>>> [60919.334319] RBP: ffff8d9338056800 R08: ffff8d53bfc29d80 R09: 0000000000000001
>>>> [60919.347969] R10: ffff8d53bfc03ec0 R11: ffffb8526ef47c98 R12: ffff8d53bfc03d30
>>>> [60919.350320] perf: interrupt took too long (3063 > 2500), lowering kernel.perf_event_max_sample_rate to 65000
>>>> [60919.361148] R13: 0000000000000001 R14: ffff8d53bcf90000 R15: 0000000000000000
>>>> [60919.361151] FS:  00007fb78b6b3600(0000) GS:ffff8d53bfc00000(0000) knlGS:0000000000000000
>>>> [60919.400812] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [60919.413730] CR2: 0000000000000010 CR3: 0000003e3f784006 CR4: 00000000007606e0
>>>> [60919.426479] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> [60919.439339] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>> [60919.451608] PKRU: 55555554
>>>> [60919.463622] Call Trace:
>>>> [60919.475617]  <IRQ>
>>>> [60919.487122]  ? update_load_avg+0x89/0x5d0
>>>> [60919.498478]  ? update_load_avg+0x89/0x5d0
>>>> [60919.509822]  ? account_entity_enqueue+0xc5/0xf0
>>>> [60919.520709]  security_sock_rcv_skb+0x2a/0x40
>>>> [60919.531413]  sk_filter_trim_cap+0x47/0x1b0
>>>> [60919.542178]  ? kmem_cache_alloc+0x38/0x1b0
>>>> [60919.552444]  sock_queue_rcv_skb+0x17/0x30
>>>> [60919.562477]  raw_rcv+0x110/0x190 [can_raw]
>>>> [60919.572539]  can_rcv_filter+0xbc/0x1b0 [can]
>>>> [60919.582173]  can_receive+0x6b/0xb0 [can]
>>>> [60919.591595]  can_rcv+0x31/0x70 [can]
>>>> [60919.600783]  __netif_receive_skb_one_core+0x5a/0x80
>>>> [60919.609864]  process_backlog+0x9b/0x150
>>>> [60919.618691]  net_rx_action+0x156/0x400
>>>> [60919.627310]  ? sched_clock_cpu+0xc/0xa0
>>>> [60919.635714]  __do_softirq+0xe8/0x2e9
>>>> [60919.644161]  do_softirq_own_stack+0x2a/0x40
>>>> [60919.652154]  </IRQ>
>>>> [60919.659899]  do_softirq.part.17+0x4f/0x60
>>>> [60919.667475]  __local_bh_enable_ip+0x60/0x70
>>>> [60919.675089]  __dev_queue_xmit+0x539/0x920
>>>> [60919.682267]  ? finish_wait+0x80/0x80
>>>> [60919.689218]  ? finish_wait+0x80/0x80
>>>> [60919.695886]  ? sock_alloc_send_pskb+0x211/0x230
>>>> [60919.702395]  ? can_send+0xe5/0x1f0 [can]
>>>> [60919.708882]  can_send+0xe5/0x1f0 [can]
>>>> [60919.715037]  raw_sendmsg+0x16d/0x268 [can_raw]
>>>>
>>>> It's because raw_setsockopt() concurrently with
>>>> unregister_netdevice_many(). Concurrent scenario as following.
>>>>
>>>>     cpu0                        cpu1
>>>> raw_bind
>>>> raw_setsockopt                    unregister_netdevice_many
>>>>                         unlist_netdevice
>>>> dev_get_by_index                raw_notifier
>>>> raw_enable_filters                ......
>>>> can_rx_register
>>>> can_rcv_list_find(..., net->can.rx_alldev_list)
>>>>
>>>> ......
>>>>
>>>> sock_close
>>>> raw_release(sock_a)
>>>>
>>>> ......
>>>>
>>>> can_receive
>>>> can_rcv_filter(net->can.rx_alldev_list, ...)
>>>> raw_rcv(skb, sock_a)
>>>> BUG
>>>>
>>>> After unlist_netdevice(), dev_get_by_index() return NULL in
>>>> raw_setsockopt(). Function raw_enable_filters() will add sock
>>>> and can_filter to net->can.rx_alldev_list.
> 
> Btw. this should not happen too!
> 
> dev_get_by_index() is executed depending on ro->ifindex which means there should be a real network interface. When dev_get_by_index() returns NULL this can considered to be wrong.
> 
> Adding a new filter to net->can.rx_alldev_list as a consequence is wrong too.
> 
>>>> Then the sock is closed.
>>>> Followed by, we sock_sendmsg() to a new vcan device use the same
>>>> can_filter. Protocol stack match the old receiver whose sock has
>>>> been released on net->can.rx_alldev_list in can_rcv_filter().
>>>> Function raw_rcv() uses the freed sock. UAF BUG is triggered.
>>>>
>>>> We can find that the key issue is that net_device has not been
>>>> protected in raw_setsockopt(). Use rtnl_lock to protect net_device
>>>> in raw_setsockopt().
>>>>
>>>> Fixes: c18ce101f2e4 ("[CAN]: Add raw protocol")
>>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> Can you please resend the below patch as suggested by Greg KH and add my
> 
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> as it also adds the dev_get_by_index() return check.
> 
> diff --git a/net/can/raw.c b/net/can/raw.c
> index ed4fcb7ab0c3..d3cbc32036c7 100644
> --- a/net/can/raw.c
> +++ b/net/can/raw.c
> @@ -544,14 +544,18 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>          } else if (count == 1) {
>              if (copy_from_sockptr(&sfilter, optval, sizeof(sfilter)))
>                  return -EFAULT;
>          }
> 
> +        rtnl_lock();
>          lock_sock(sk);
> 
> -        if (ro->bound && ro->ifindex)
> +        if (ro->bound && ro->ifindex) {
>              dev = dev_get_by_index(sock_net(sk), ro->ifindex);
> +            if (!dev)
> +                goto out_fil;
> +        }
At first, I also use this modification. After discussion with my partner, we found that
it is impossible scenario if we use rtnl_lock to protect net_device object.
We can see two sequences:
1. raw_setsockopt first get rtnl_lock, unregister_netdevice_many later.
It can be simplified to add the filter in raw_setsockopt, then remove the filter in raw_notify.

2. unregister_netdevice_many first get rtnl_lock, raw_setsockopt later.
raw_notify will set ro->ifindex, ro->bound and ro->count to zero firstly. The filter will not
be added to any filter_list in raw_notify.

So I selected the current modification. Do you think so?

My first modification as following:

diff --git a/net/can/raw.c b/net/can/raw.c
index ed4fcb7ab0c3..a0ce4908317f 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -546,10 +546,16 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
                                return -EFAULT;
                }

+               rtnl_lock();
                lock_sock(sk);

-               if (ro->bound && ro->ifindex)
+               if (ro->bound && ro->ifindex) {
                        dev = dev_get_by_index(sock_net(sk), ro->ifindex);
+                       if (!dev) {
+                               err = -ENODEV;
+                               goto out_fil;
+                       }
+               }

                if (ro->bound) {
                        /* (try to) register the new filters */
@@ -559,11 +565,8 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
                        else
                                err = raw_enable_filters(sock_net(sk), dev, sk,
                                                         filter, count);
-                       if (err) {
-                               if (count > 1)
-                                       kfree(filter);
+                       if (err)
                                goto out_fil;
-                       }

                        /* remove old filter registrations */
                        raw_disable_filters(sock_net(sk), dev, sk, ro->filter,
@@ -584,10 +587,14 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
                ro->count  = count;

  out_fil:
+               if (err && count > 1)
+                       kfree(filter);
+
                if (dev)
                        dev_put(dev);

                release_sock(sk);
+               rtnl_unlock();

                break;

@@ -600,10 +607,16 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,

                err_mask &= CAN_ERR_MASK;

+               rtnl_lock();
                lock_sock(sk);

-               if (ro->bound && ro->ifindex)
+               if (ro->bound && ro->ifindex) {
                        dev = dev_get_by_index(sock_net(sk), ro->ifindex);
+                       if (!dev) {
+                               err = -ENODEV;
+                               goto out_err;
+                       }
+               }

                /* remove current error mask */
                if (ro->bound) {
@@ -627,6 +640,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
                        dev_put(dev);

                release_sock(sk);
+               rtnl_unlock();

                break;

> 
>          if (ro->bound) {
>              /* (try to) register the new filters */
>              if (count == 1)
>                  err = raw_enable_filters(sock_net(sk), dev, sk,
> @@ -586,10 +590,11 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>   out_fil:
>          if (dev)
>              dev_put(dev);
> 
>          release_sock(sk);
> +        rtnl_unlock();
> 
>          break;
> 
>      case CAN_RAW_ERR_FILTER:
>          if (optlen != sizeof(err_mask))
> @@ -598,14 +603,18 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>          if (copy_from_sockptr(&err_mask, optval, optlen))
>              return -EFAULT;
> 
>          err_mask &= CAN_ERR_MASK;
> 
> +        rtnl_lock();
>          lock_sock(sk);
> 
> -        if (ro->bound && ro->ifindex)
> +        if (ro->bound && ro->ifindex) {
>              dev = dev_get_by_index(sock_net(sk), ro->ifindex);
> +            if (!dev)
> +                goto out_err;
> +        }
> 
>          /* remove current error mask */
>          if (ro->bound) {
>              /* (try to) register the new err_mask */
>              err = raw_enable_errfilter(sock_net(sk), dev, sk,
> @@ -625,10 +634,11 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>   out_err:
>          if (dev)
>              dev_put(dev);
> 
>          release_sock(sk);
> +        rtnl_unlock();
> 
>          break;
> 
>      case CAN_RAW_LOOPBACK:
>          if (optlen != sizeof(ro->loopback))
> 
> 
> 
> 
> Thanks for the finding!
> 
> Best regards,
> Oliver
> 
> (..)
>>>
>>>
>>> <formletter>
>>>
>>> This is not the correct way to submit patches for inclusion in the
>>> stable kernel tree.  Please read:
>>>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>>> for how to do this properly.
>>>
>>> </formletter>
>>>
> .
