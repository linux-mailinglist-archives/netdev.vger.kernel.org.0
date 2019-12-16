Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE77120372
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 12:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfLPLMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 06:12:25 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:52562 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbfLPLMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 06:12:24 -0500
Received: from fsav109.sakura.ne.jp (fsav109.sakura.ne.jp [27.133.134.236])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id xBGBCLSI064422;
        Mon, 16 Dec 2019 20:12:21 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav109.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav109.sakura.ne.jp);
 Mon, 16 Dec 2019 20:12:21 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav109.sakura.ne.jp)
Received: from [192.168.1.9] (softbank126040062084.bbtec.net [126.40.62.84])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id xBGBCKOO064416
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Mon, 16 Dec 2019 20:12:21 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To:     =?UTF-8?Q?Jouni_H=c3=b6gander?= <jouni.hogander@unikie.com>
Cc:     syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        YueHaibing <yuehaibing@huawei.com>, Julian Anastasov <ja@ssi.bg>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Hulk Robot <hulkci@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
References: <0000000000007d22100573d66078@google.com>
 <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
 <ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp>
 <87y2vrgkij.fsf@unikie.com>
 <c03d8353-ae34-2f84-68d3-0153873ffc3e@i-love.sakura.ne.jp>
Message-ID: <9c563a2d-4805-dbd3-08c6-4c541ec30a60@i-love.sakura.ne.jp>
Date:   Mon, 16 Dec 2019 20:12:19 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <c03d8353-ae34-2f84-68d3-0153873ffc3e@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, again.

On 2019/12/05 20:00, Tetsuo Handa wrote:
> On 2019/12/05 19:00, Jouni Högander wrote:
>>> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>>> index ae3bcb1540ec..562d06c274aa 100644
>>> --- a/net/core/net-sysfs.c
>>> +++ b/net/core/net-sysfs.c
>>> @@ -1459,14 +1459,14 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
>>>  	struct kobject *kobj = &queue->kobj;
>>>  	int error = 0;
>>>  
>>> +	dev_hold(queue->dev);
>>> +
>>>  	kobj->kset = dev->queues_kset;
>>>  	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
>>>  				     "tx-%u", index);
>>>  	if (error)
>>>  		goto err;
>>>  
>>> -	dev_hold(queue->dev);
>>> -
>>>  #ifdef CONFIG_BQL
>>>  	error = sysfs_create_group(kobj, &dql_group);
>>>  	if (error)
>>
>> Now after reproducing the issue I think this is actually proper fix for
>> the issue.  It's not related to missing error handling in in
>> tun_set_real_num_queues as I commented earlier. Can you prepare patch
>> for this?
> 
> You can write the patch; I don't know about commit a3e23f719f5c4a38
> ("net-sysfs: call dev_hold if kobject_init_and_add success").
> 
> I was wondering how can the caller tell whether to drop the refcount, for
> the caller won't be able to know which one (kobject_init_and_add() or
> sysfs_create_group()) returned an error. Therefore, always taking the
> refcount seems to be a proper fix...
> 

sysbot is still reporting this problem.

[  878.476981][T12832] FAULT_INJECTION: forcing a failure.
[  878.476981][T12832] name failslab, interval 1, probability 0, space 0, times 0
[  878.490068][T12832] CPU: 1 PID: 12832 Comm: syz-executor.3 Not tainted 5.5.0-rc1-syzkaller #0
[  878.498850][T12832] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
[  878.508957][T12832] Call Trace:
[  878.512243][T12832]  dump_stack+0x197/0x210
[  878.516570][T12832]  should_fail.cold+0xa/0x15
[  878.531871][T12832]  __should_failslab+0x121/0x190
[  878.536792][T12832]  should_failslab+0x9/0x14
[  878.541474][T12832]  __kmalloc_track_caller+0x2dc/0x760
[  878.561156][T12832]  kvasprintf+0xc8/0x170
[  878.588298][T12832]  kvasprintf_const+0x65/0x190
[  878.593044][T12832]  kobject_set_name_vargs+0x5b/0x150
[  878.598309][T12832]  kobject_init_and_add+0xc9/0x160
[  878.620657][T12832]  net_rx_queue_update_kobjects+0x1d3/0x460
[  878.626547][T12832]  netif_set_real_num_rx_queues+0x16e/0x210
[  878.632424][T12832]  tun_attach+0x5a1/0x1530
[  878.641587][T12832]  __tun_chr_ioctl+0x1ef0/0x3fa0
[  878.667270][T12832]  tun_chr_ioctl+0x2b/0x40
[  878.671678][T12832]  do_vfs_ioctl+0x977/0x14e0
[  878.717612][T12832]  ksys_ioctl+0xab/0xd0
[  878.721752][T12832]  __x64_sys_ioctl+0x73/0xb0
[  878.726336][T12832]  do_syscall_64+0xfa/0x790
[  878.730834][T12832]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  878.736703][T12832] RIP: 0033:0x45a909
[  878.740585][T12832] Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
[  878.760179][T12832] RSP: 002b:00007fb6b281cc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  878.768587][T12832] RAX: ffffffffffffffda RBX: 00007fb6b281cc90 RCX: 000000000045a909
[  878.776543][T12832] RDX: 0000000020000040 RSI: 00000000400454ca RDI: 0000000000000004
[  878.784503][T12832] RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
[  878.792466][T12832] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb6b281d6d4
[  878.800420][T12832] R13: 00000000004c5fdc R14: 00000000004dc3b0 R15: 0000000000000005
[  878.810319][T12832] kobject: can not set name properly!
[  888.898307][T12830] unregister_netdevice: waiting for nr0 to become free. Usage count = -1

I think that the same problem exists in rx_queue_add_kobject().

static int rx_queue_add_kobject(struct net_device *dev, int index)
{
        struct netdev_rx_queue *queue = dev->_rx + index;
        struct kobject *kobj = &queue->kobj;
        int error = 0;

        kobj->kset = dev->queues_kset;
        error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
                                     "rx-%u", index);
        if (error)
                goto err;

        dev_hold(queue->dev);

        if (dev->sysfs_rx_queue_group) {
                error = sysfs_create_group(kobj, dev->sysfs_rx_queue_group);
                if (error)
                        goto err;
        }

        kobject_uevent(kobj, KOBJ_ADD);

        return error;

err:
        kobject_put(kobj);
        return error;
}
