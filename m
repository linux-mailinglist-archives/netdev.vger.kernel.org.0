Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B7E5319F6
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbiEWQbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238911AbiEWQbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:31:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97C72983F;
        Mon, 23 May 2022 09:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D3CE6124B;
        Mon, 23 May 2022 16:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8360FC385AA;
        Mon, 23 May 2022 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653323502;
        bh=rr535/e5CTloClQFK/m/2NvyT5fJ5UrwoAoj2Pa5vzk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=n0uAv6E1yLvecES93QppfWTT2L790dPoly4bfHBG4gAIGCSuKwNNtby2ycnXBFr9p
         ttXPnJU92el+foon66YPJfQ2FnZ8DwrHq8k4ErqcnoS3tBH7qSu79i/hKzVlkRbmKm
         FHXAtS3Z9XZJ2Jbqj8mhgnvm9qSdRgJs+E778Uu8S0utScavCQfqGFEMKp9YTonH1d
         bks6CIU8xe7l3iMSTj0qvnzZvj7rgExfqhyXN/xdfmmhDcWgnmeroAqOGnqPIECwPb
         L7N8qck1Vl8mWnuQ/0jkacD0RpR9dDFRwf8kKkUWJDK4Quq3X8giaZxWH8aFifr2zu
         uSM6Jk4nOF/VQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     duoming@zju.edu.cn
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org
Subject: Re: [PATCH v3] mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
References: <20220523052810.24767-1-duoming@zju.edu.cn>
        <87o7zoxrdf.fsf@email.froward.int.ebiederm.org>
        <6a270950.2c659.180f1a46e8c.Coremail.duoming@zju.edu.cn>
Date:   Mon, 23 May 2022 19:31:35 +0300
In-Reply-To: <6a270950.2c659.180f1a46e8c.Coremail.duoming@zju.edu.cn>
        (duoming's message of "Mon, 23 May 2022 23:58:46 +0800 (GMT+08:00)")
Message-ID: <87ee0kyzvc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

duoming@zju.edu.cn writes:

> Hello maintainers,
>
> Thank you for your time and suggestions! 
>
>> > There are sleep in atomic context bugs when uploading device dump
>> > data in mwifiex. The root cause is that dev_coredumpv could not
>> > be used in atomic contexts, because it calls dev_set_name which
>> > include operations that may sleep. The call tree shows execution
>> > paths that could lead to bugs:
>> >
>> >    (Interrupt context)
>> > fw_dump_timer_fn
>> >   mwifiex_upload_device_dump
>> >     dev_coredumpv(..., GFP_KERNEL)
>> >       dev_coredumpm()
>> >         kzalloc(sizeof(*devcd), gfp); //may sleep
>> >         dev_set_name
>> >           kobject_set_name_vargs
>> >             kvasprintf_const(GFP_KERNEL, ...); //may sleep
>> >             kstrdup(s, GFP_KERNEL); //may sleep
>> >
>> > In order to let dev_coredumpv support atomic contexts, this patch
>> > changes the gfp_t parameter of kvasprintf_const and kstrdup in
>> > kobject_set_name_vargs from GFP_KERNEL to GFP_ATOMIC. What's more,
>> > In order to mitigate bug, this patch changes the gfp_t parameter
>> > of dev_coredumpv from GFP_KERNEL to GFP_ATOMIC.
>> 
>> vmalloc in atomic context?
>> 
>> Not only does dev_coredumpm set a device name dev_coredumpm creates an
>> entire device to hold the device dump.
>> 
>> My sense is that either dev_coredumpm needs to be rebuilt on a
>> completely different principle that does not need a device to hold the
>> coredump (so that it can be called from interrupt context) or that
>> dev_coredumpm should never be called in an context that can not sleep.
>
> The following solution removes the gfp_t parameter of dev_coredumpv(), 
> dev_coredumpm() and dev_coredumpsg() and change the gfp_t parameter of 
> kzalloc() in dev_coredumpm() to GFP_KERNEL, in order to show that these 
> functions can not be used in atomic context.
>
> What's more, I move the operations that may sleep into a work item and use
> schedule_work() to call a kernel thread to do the operations that may sleep.
>

[...]

> --- a/drivers/net/wireless/marvell/mwifiex/init.c
> +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> @@ -63,11 +63,19 @@ static void wakeup_timer_fn(struct timer_list *t)
>  		adapter->if_ops.card_reset(adapter);
>  }
>  
> +static void fw_dump_work(struct work_struct *work)
> +{
> +	struct mwifiex_adapter *adapter =
> +		container_of(work, struct mwifiex_adapter, devdump_work);
> +
> +	mwifiex_upload_device_dump(adapter);
> +}
> +
>  static void fw_dump_timer_fn(struct timer_list *t)
>  {
>  	struct mwifiex_adapter *adapter = from_timer(adapter, t, devdump_timer);
>  
> -	mwifiex_upload_device_dump(adapter);
> +	schedule_work(&adapter->devdump_work);
>  }
>  
>  /*
> @@ -321,6 +329,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
>  	adapter->active_scan_triggered = false;
>  	timer_setup(&adapter->wakeup_timer, wakeup_timer_fn, 0);
>  	adapter->devdump_len = 0;
> +	INIT_WORK(&adapter->devdump_work, fw_dump_work);
>  	timer_setup(&adapter->devdump_timer, fw_dump_timer_fn, 0);
>  }
>  
> @@ -401,6 +410,7 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
>  {
>  	del_timer(&adapter->wakeup_timer);
>  	del_timer_sync(&adapter->devdump_timer);
> +	cancel_work_sync(&adapter->devdump_work);
>  	mwifiex_cancel_all_pending_cmd(adapter);
>  	wake_up_interruptible(&adapter->cmd_wait_q.wait);
>  	wake_up_interruptible(&adapter->hs_activate_wait_q);

In this patch please only do the API change in mwifiex. The change to
using a workqueue needs to be in separate patch so it can be properly
tested. I don't want a change like that going to the kernel without
testing on a real device.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
