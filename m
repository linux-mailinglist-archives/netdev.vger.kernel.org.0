Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF5B52D671
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239977AbiESOuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239965AbiESOuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:50:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B798E27A3;
        Thu, 19 May 2022 07:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28A8EB82332;
        Thu, 19 May 2022 14:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAD1C385AA;
        Thu, 19 May 2022 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652971804;
        bh=co3fUDj78RM5wW0Lh+KE75FvB8/+RLtvVClhMBRExrI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jor/8LF2QYz1lNosyOhrcyDZMBWYL6OfzWpgq49cXjr2b+IuabhWfp/BQZDB+Y+CW
         a00LmmAHVaS1DXgsku78Dim9JODaC/+gqMQWg3ReHeykwYcYpSmfx3yfB5Q8GlHDxi
         RqP15TS91rKCKB3bRjsSmnmvMV6UKnTwSj2hCsaQ1hWfUUt6Z3L2rF3SbavmcpgVzZ
         9szNaSt9ZdD3s6RXM9qnRPxI+QQaJe249KauuijsgENEU9KaqjhUeorBzURdCVVyO5
         QOVuA0G6pjX2ZEq+aCsOoj4PVfaJkwCmJTExyzYYxvQpQPnf4kTHje8SEXWUHzACta
         hCu5kQGRUELew==
From:   Kalle Valo <kvalo@kernel.org>
To:     duoming@zju.edu.cn
Cc:     linux-kernel@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: wireless: marvell: mwifiex: fix sleep in atomic context bugs
References: <20220519101656.44513-1-duoming@zju.edu.cn>
        <87fsl53jic.fsf@kernel.org>
        <257f8e7.216cd.180dc1af4d3.Coremail.duoming@zju.edu.cn>
Date:   Thu, 19 May 2022 17:49:58 +0300
In-Reply-To: <257f8e7.216cd.180dc1af4d3.Coremail.duoming@zju.edu.cn>
        (duoming's message of "Thu, 19 May 2022 19:36:35 +0800 (GMT+08:00)")
Message-ID: <877d6h37c9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

duoming@zju.edu.cn writes:

> Hello,
>
> On Thu, 19 May 2022 13:27:07 +0300 Kalle Valo wrote:
>
>> > There are sleep in atomic context bugs when uploading device dump
>> > data on usb interface. The root cause is that the operations that
>> > may sleep are called in fw_dump_timer_fn which is a timer handler.
>> > The call tree shows the execution paths that could lead to bugs:
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
>> > This patch moves the operations that may sleep into a work item.
>> > The work item will run in another kernel thread which is in
>> > process context to execute the bottom half of the interrupt.
>> > So it could prevent atomic context from sleeping.
>> >
>> > Fixes: f5ecd02a8b20 ("mwifiex: device dump support for usb interface")
>> > Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
>> 
>> Have you tested this on real hardware? Or is this just a theoretical
>> fix?
>
> This is a theoretical fix. I don't have the real hardware.

For such patches clearly document that in the commit log, for example
something like "Compile tested only." or similar. But do take into
account that I'm wary about non-trivial fixes which have not been tested
on a real device, it's easy to do more harm than good.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
