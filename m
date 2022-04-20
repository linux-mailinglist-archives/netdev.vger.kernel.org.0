Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581105085A6
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244785AbiDTKVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiDTKVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:21:03 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D732B641B
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 03:18:16 -0700 (PDT)
Received: from fsav113.sakura.ne.jp (fsav113.sakura.ne.jp [27.133.134.240])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23KAHtls083375;
        Wed, 20 Apr 2022 19:17:55 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav113.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp);
 Wed, 20 Apr 2022 19:17:55 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23KAHthu083371
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 20 Apr 2022 19:17:55 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <cb2f74ea-74ce-2dba-c5e3-e4672f1be663@I-love.SAKURA.ne.jp>
Date:   Wed, 20 Apr 2022 19:17:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] wwan_hwsim: Avoid flush_scheduled_work() usage
Content-Language: en-US
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
References: <0bc6443a-dbac-70ab-bf99-9a439e35f3ef@I-love.SAKURA.ne.jp>
 <CAMZdPi_uieGNWyGAAywBz2Utg0iW1jGUTWzUbj3SmsZ+-iDTfQ@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CAMZdPi_uieGNWyGAAywBz2Utg0iW1jGUTWzUbj3SmsZ+-iDTfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/04/20 18:53, Loic Poulain wrote:
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
>>                 return PTR_ERR(wwan_hwsim_class);
>> +       }
>>
>>         wwan_hwsim_debugfs_topdir = debugfs_create_dir("wwan_hwsim", NULL);
>>         wwan_hwsim_debugfs_devcreate =
>> @@ -524,6 +531,7 @@ static int __init wwan_hwsim_init(void)
>>
>>  err_clean_devs:

Do you want

	debugfs_remove(wwan_hwsim_debugfs_devcreate);

here (as a separate patch)?

>>         wwan_hwsim_free_devs();
>> +       destroy_workqueue(wwan_wq);
>>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>>         class_destroy(wwan_hwsim_class);
>>
>> @@ -534,7 +542,7 @@ static void __exit wwan_hwsim_exit(void)
>>  {
>>         debugfs_remove(wwan_hwsim_debugfs_devcreate);   /* Avoid new devs */
>>         wwan_hwsim_free_devs();
>> -       flush_scheduled_work();         /* Wait deletion works completion */
>> +       destroy_workqueue(wwan_wq);             /* Wait deletion works completion */
> 
> Wouldn't it be simpler to just remove the flush call. It Looks like
> all ports have been removed at that point, and all works cancelled,
> right?

I guess that this flush_scheduled_work() is for waiting for schedule_work(&dev->del_work) from
wwan_hwsim_debugfs_devdestroy_write(). That is, if wwan_hwsim_debugfs_devdestroy_write() already
scheduled this work, wwan_hwsim_dev_del() from wwan_hwsim_dev_del_work() might be still in progress
even after wwan_hwsim_dev_del() from wwan_hwsim_free_devs() from wwan_hwsim_exit() returned.

