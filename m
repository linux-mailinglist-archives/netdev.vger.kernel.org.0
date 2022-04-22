Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EC750AE50
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 05:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443637AbiDVDGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 23:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443627AbiDVDGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 23:06:19 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485974D240
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 20:03:25 -0700 (PDT)
Received: from fsav413.sakura.ne.jp (fsav413.sakura.ne.jp [133.242.250.112])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23M32uxO041631;
        Fri, 22 Apr 2022 12:02:56 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav413.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp);
 Fri, 22 Apr 2022 12:02:56 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23M32tFe041624
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 22 Apr 2022 12:02:55 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <29d14fb5-8eb4-bd83-65af-7c51a9345a66@I-love.SAKURA.ne.jp>
Date:   Fri, 22 Apr 2022 12:02:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] wwan_hwsim: Avoid flush_scheduled_work() usage
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
References: <0bc6443a-dbac-70ab-bf99-9a439e35f3ef@I-love.SAKURA.ne.jp>
 <CAMZdPi_uieGNWyGAAywBz2Utg0iW1jGUTWzUbj3SmsZ+-iDTfQ@mail.gmail.com>
 <CAHNKnsTkBiS8EKHXiF1MxoRfmGrv_Zrtgc2gaciCmZQREQULMQ@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CAHNKnsTkBiS8EKHXiF1MxoRfmGrv_Zrtgc2gaciCmZQREQULMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/04/22 1:14, Sergey Ryazanov wrote:
>> Do you want
>>
>>         debugfs_remove(wwan_hwsim_debugfs_devcreate);
>>
>> here (as a separate patch)?
> 
> Nope. But I will not be against such a patch. I remove the "devcreate"
> file in wwwan_hwsim_exit() to prevent new emulated device creation
> while the workqueue flushing, which can take a sufficient time. Here
> we cleanup the leftovers of the attempt to automatically create
> emulated devices. Here is no workqueue flushing, so the race window is
> very tight.
> 
> In other words, the preparatory debugfs file removal is practically
> not required here, but it will not hurt anyone. And possibly will make
> the code less questionable.

OK. Since manual creation of emulated device via debugfs followed by
manual device deletion of emulated device via debugfs is possible before
automatic creation of emulated device via wwan_hwsim_init_devs() fails,
"/* Avoid new devs */" comment is applicable to this error path; I will
include debugfs_remove(wwan_hwsim_debugfs_devcreate) call.

On 2022/04/22 1:35, Sergey Ryazanov wrote:
>> @@ -506,9 +507,15 @@ static int __init wwan_hwsim_init(void)
>>         if (wwan_hwsim_devsnum < 0 || wwan_hwsim_devsnum > 128)
>>                 return -EINVAL;
>>
>> +       wwan_wq = alloc_workqueue("wwan_wq", 0, 0);
>> +       if (!wwan_wq)
>> +               return -ENOMEM;
>> +
>>         wwan_hwsim_class = class_create(THIS_MODULE, "wwan_hwsim");
>> -       if (IS_ERR(wwan_hwsim_class))
>> +       if (IS_ERR(wwan_hwsim_class)) {
>> +               destroy_workqueue(wwan_wq);
> 
> How about jumping to some label from here and do the workqueue
> destroying there? E.g.

OK.

>> @@ -524,6 +531,7 @@ static int __init wwan_hwsim_init(void)
>>
>>  err_clean_devs:
>>         wwan_hwsim_free_devs();
>> +       destroy_workqueue(wwan_wq);
>>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>>         class_destroy(wwan_hwsim_class);
> 
> As you can see there are no need to wait the workqueue flushing, since
> it was not used. So the queue destroying call can be moved below the
> class destroying to keep cleanup symmetrical to the init sequence.

I will add

	debugfs_remove(wwan_hwsim_debugfs_devcreate);   /* Avoid new devs */

here, for "it was not used" part is theoretically not always true.

>> @@ -534,7 +542,7 @@ static void __exit wwan_hwsim_exit(void)
>>  {
>>         debugfs_remove(wwan_hwsim_debugfs_devcreate);   /* Avoid new devs */
>>         wwan_hwsim_free_devs();
>> -       flush_scheduled_work();         /* Wait deletion works completion */
>> +       destroy_workqueue(wwan_wq);             /* Wait deletion works completion */
>>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>>         class_destroy(wwan_hwsim_class);
>>  }
> 
> I do not care too much, but can we explicitly call the queue flushing
> to make the exit handler as clear as possible?

OK.

On 2022/04/22 1:54, Sergey Ryazanov wrote:
> From what I understand, an inaccurate flushing of the system work
> queue can potentially cause a system freeze. That is why
> flush_scheduled_work() is planned to be removed. The hwsim module is
> just a random function user without any known issues. So, a 'fixes'
> tag is not required here, and there is no need to bother the stable
> team with a change backport.

Right, 'Fixes:' tag is not needed for this patch.

Flushing the system-wide workqueue is problematic under e.g. GFP_NOFS/GFP_NOIO context.
Removing flush_scheduled_work() is for proactively avoiding new problems like
https://lkml.kernel.org/r/385ce718-f965-4005-56b6-34922c4533b8@I-love.SAKURA.ne.jp
and https://lkml.kernel.org/r/20220225112405.355599-10-Jerome.Pouiller@silabs.com .

> 
> Anyway, Tetsuo, you missed a target tree in the subject. If this is
> not a fix, then you probably should target your changes to the
> 'net-next' tree.
> 

OK. I posted v2 patch at
https://lkml.kernel.org/r/7390d51f-60e2-3cee-5277-b819a55ceabe@I-love.SAKURA.ne.jp .


Thank you for responding.

