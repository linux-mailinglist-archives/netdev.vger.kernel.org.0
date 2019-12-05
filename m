Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21DC2113FD5
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 12:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfLELAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 06:00:38 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:53610 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729017AbfLELAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 06:00:38 -0500
Received: from fsav109.sakura.ne.jp (fsav109.sakura.ne.jp [27.133.134.236])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id xB5B0ZXE069614;
        Thu, 5 Dec 2019 20:00:35 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav109.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav109.sakura.ne.jp);
 Thu, 05 Dec 2019 20:00:35 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav109.sakura.ne.jp)
Received: from [192.168.1.9] (softbank126040062084.bbtec.net [126.40.62.84])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id xB5B0Zfm069611
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Thu, 5 Dec 2019 20:00:35 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
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
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <c03d8353-ae34-2f84-68d3-0153873ffc3e@i-love.sakura.ne.jp>
Date:   Thu, 5 Dec 2019 20:00:35 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <87y2vrgkij.fsf@unikie.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/05 19:00, Jouni Högander wrote:
>> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>> index ae3bcb1540ec..562d06c274aa 100644
>> --- a/net/core/net-sysfs.c
>> +++ b/net/core/net-sysfs.c
>> @@ -1459,14 +1459,14 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
>>  	struct kobject *kobj = &queue->kobj;
>>  	int error = 0;
>>  
>> +	dev_hold(queue->dev);
>> +
>>  	kobj->kset = dev->queues_kset;
>>  	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
>>  				     "tx-%u", index);
>>  	if (error)
>>  		goto err;
>>  
>> -	dev_hold(queue->dev);
>> -
>>  #ifdef CONFIG_BQL
>>  	error = sysfs_create_group(kobj, &dql_group);
>>  	if (error)
> 
> Now after reproducing the issue I think this is actually proper fix for
> the issue.  It's not related to missing error handling in in
> tun_set_real_num_queues as I commented earlier. Can you prepare patch
> for this?

You can write the patch; I don't know about commit a3e23f719f5c4a38
("net-sysfs: call dev_hold if kobject_init_and_add success").

I was wondering how can the caller tell whether to drop the refcount, for
the caller won't be able to know which one (kobject_init_and_add() or
sysfs_create_group()) returned an error. Therefore, always taking the
refcount seems to be a proper fix...
