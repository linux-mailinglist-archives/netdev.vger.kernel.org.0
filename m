Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCB051692A
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 03:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353119AbiEBBqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 21:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbiEBBqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 21:46:21 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6282BD1
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 18:42:54 -0700 (PDT)
Received: from fsav411.sakura.ne.jp (fsav411.sakura.ne.jp [133.242.250.110])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2421gY59030313;
        Mon, 2 May 2022 10:42:34 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav411.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp);
 Mon, 02 May 2022 10:42:34 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2421gXlr030306
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 2 May 2022 10:42:34 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <83f104c0-5027-28b2-7aaf-780650026f6e@I-love.SAKURA.ne.jp>
Date:   Mon, 2 May 2022 10:42:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2] wwan_hwsim: Avoid flush_scheduled_work() usage
Content-Language: en-US
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>
References: <7390d51f-60e2-3cee-5277-b819a55ceabe@I-love.SAKURA.ne.jp>
 <CAMZdPi9eR_0zf02SPHC_+by4k9dJpFfZcDvk-peVBmpefQZchA@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CAMZdPi9eR_0zf02SPHC_+by4k9dJpFfZcDvk-peVBmpefQZchA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David, can you take this patch?

On 2022/04/22 15:38, Loic Poulain wrote:
> On Fri, 22 Apr 2022 at 05:01, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>
>> Flushing system-wide workqueues is dangerous and will be forbidden.
>> Replace system_wq with local wwan_wq.
>>
>> While we are at it, make err_clean_devs: label of wwan_hwsim_init()
>> behave like wwan_hwsim_exit(), for it is theoretically possible to call
>> wwan_hwsim_debugfs_devcreate_write()/wwan_hwsim_debugfs_devdestroy_write()
>> by the moment wwan_hwsim_init_devs() returns.
>>
>> Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> 
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> 
> 
>> ---
>> Changes in v2:
>>   Keep flush_workqueue(wwan_wq) explicit in order to match the comment.
>>   Make error path of wwan_hwsim_init() identical to wwan_hwsim_exit().
>>
>>  drivers/net/wwan/wwan_hwsim.c | 22 +++++++++++++++++-----
>>  1 file changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
>> index 5b62cf3b3c42..fad642f9ffd8 100644
>> --- a/drivers/net/wwan/wwan_hwsim.c
>> +++ b/drivers/net/wwan/wwan_hwsim.c
>> @@ -33,6 +33,7 @@ static struct dentry *wwan_hwsim_debugfs_devcreate;
>>  static DEFINE_SPINLOCK(wwan_hwsim_devs_lock);
>>  static LIST_HEAD(wwan_hwsim_devs);
>>  static unsigned int wwan_hwsim_dev_idx;
>> +static struct workqueue_struct *wwan_wq;
>>
>>  struct wwan_hwsim_dev {
>>         struct list_head list;
>> @@ -371,7 +372,7 @@ static ssize_t wwan_hwsim_debugfs_portdestroy_write(struct file *file,
>>          * waiting this callback to finish in the debugfs_remove() call. So,
>>          * use workqueue.
>>          */
>> -       schedule_work(&port->del_work);
>> +       queue_work(wwan_wq, &port->del_work);
>>
>>         return count;
>>  }
>> @@ -416,7 +417,7 @@ static ssize_t wwan_hwsim_debugfs_devdestroy_write(struct file *file,
>>          * waiting this callback to finish in the debugfs_remove() call. So,
>>          * use workqueue.
>>          */
>> -       schedule_work(&dev->del_work);
>> +       queue_work(wwan_wq, &dev->del_work);
>>
>>         return count;
>>  }
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
>> -               return PTR_ERR(wwan_hwsim_class);
>> +       if (IS_ERR(wwan_hwsim_class)) {
>> +               err = PTR_ERR(wwan_hwsim_class);
>> +               goto err_wq_destroy;
>> +       }
>>
>>         wwan_hwsim_debugfs_topdir = debugfs_create_dir("wwan_hwsim", NULL);
>>         wwan_hwsim_debugfs_devcreate =
>> @@ -523,9 +530,13 @@ static int __init wwan_hwsim_init(void)
>>         return 0;
>>
>>  err_clean_devs:
>> +       debugfs_remove(wwan_hwsim_debugfs_devcreate);   /* Avoid new devs */
>>         wwan_hwsim_free_devs();
>> +       flush_workqueue(wwan_wq);       /* Wait deletion works completion */
>>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>>         class_destroy(wwan_hwsim_class);
>> +err_wq_destroy:
>> +       destroy_workqueue(wwan_wq);
>>
>>         return err;
>>  }
>> @@ -534,9 +545,10 @@ static void __exit wwan_hwsim_exit(void)
>>  {
>>         debugfs_remove(wwan_hwsim_debugfs_devcreate);   /* Avoid new devs */
>>         wwan_hwsim_free_devs();
>> -       flush_scheduled_work();         /* Wait deletion works completion */
>> +       flush_workqueue(wwan_wq);       /* Wait deletion works completion */
>>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>>         class_destroy(wwan_hwsim_class);
>> +       destroy_workqueue(wwan_wq);
>>  }
>>
>>  module_init(wwan_hwsim_init);
>> --
>> 2.32.0
>>

