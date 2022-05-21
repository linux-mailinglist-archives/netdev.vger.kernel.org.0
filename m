Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B6F52F941
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 08:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354625AbiEUGcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 02:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiEUGcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 02:32:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906058BD32;
        Fri, 20 May 2022 23:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A92760EE7;
        Sat, 21 May 2022 06:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A612C385AA;
        Sat, 21 May 2022 06:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653114763;
        bh=efPk0p+UJo7cJytlqn2hlByqat6qgT2sqsmvczDyuOU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eWo/ItEBDBK0OihZ+HzktBCA5tpCrqzI4ghXzoycnIn0buMzK34JtPjbEQiy7Ttej
         JkAEwYJVSbdOhuO9VlFZuZeIaKerTn529eE2zPBqjYSSeup4eEH5vEDw/gsvCi79Jl
         cf7gAnzcr8Q3LhGtgUj7Q6O33x8WAvQC4p4SIBHtoCJPfY8YnQ+Km7/RVDJfLtouFB
         jVx/RoGxb4LnXuawOOE6eezWRlPckH6jYcKTcjDXPidld2vHjymWAtiG3B0ltTlD9D
         Osbh8C1ZlPOP7kd4ER31LdlSGlVHV/QFpsDMvy7xJ9SFVLxgNSpXND7yxnLDvXur75
         nHyH3teb/klOw==
From:   Kalle Valo <kvalo@kernel.org>
To:     duoming@zju.edu.cn
Cc:     "Jeff Johnson" <quic_jjohnson@quicinc.com>,
        linux-kernel@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: wireless: marvell: mwifiex: fix sleep in atomic context bugs
References: <20220519135345.109936-1-duoming@zju.edu.cn>
        <87zgjd1sd4.fsf@kernel.org>
        <699e56d5.22006.180dce26e02.Coremail.duoming@zju.edu.cn>
        <18852332-ee42-ef7e-67a3-bbd91a6694ba@quicinc.com>
        <4e778cb1.22654.180decbcb8e.Coremail.duoming@zju.edu.cn>
        <ec16c0b5-b8c7-3bd1-e733-f054ec3c2cd1@quicinc.com>
        <ed03525.253c1.180e4a21950.Coremail.duoming@zju.edu.cn>
Date:   Sat, 21 May 2022 09:32:37 +0300
In-Reply-To: <ed03525.253c1.180e4a21950.Coremail.duoming@zju.edu.cn>
        (duoming's message of "Sat, 21 May 2022 11:21:10 +0800 (GMT+08:00)")
Message-ID: <87ilpzwg3e.fsf@kernel.org>
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
> On Fri, 20 May 2022 09:08:52 -0700 Jeff Johnson wrote:
>
>> >>>>> There are sleep in atomic context bugs when uploading device dump
>> >>>>> data on usb interface. The root cause is that the operations that
>> >>>>> may sleep are called in fw_dump_timer_fn which is a timer handler.
>> >>>>> The call tree shows the execution paths that could lead to bugs:
>> >>>>>
>> >>>>>      (Interrupt context)
>> >>>>> fw_dump_timer_fn
>> >>>>>     mwifiex_upload_device_dump
>> >>>>>       dev_coredumpv(..., GFP_KERNEL)
>> >>
>> >> just looking at this description, why isn't the simple fix just to
>> >> change this call to use GFP_ATOMIC?
>> > 
>> > Because change the parameter of dev_coredumpv() to GFP_ATOMIC could only solve
>> > partial problem. The following GFP_KERNEL parameters are in /lib/kobject.c
>> > which is not influenced by dev_coredumpv().
>> > 
>> >   kobject_set_name_vargs
>> >     kvasprintf_const(GFP_KERNEL, ...); //may sleep
>> >     kstrdup(s, GFP_KERNEL); //may sleep
>> 
>> Then it seems there is a problem with dev_coredumpm().
>> 
>> dev_coredumpm() takes a gfp param which means it expects to be called in 
>> any context, but it then calls dev_set_name() which, as you point out, 
>> cannot be called from an atomic context.
>> 
>> So if we cannot change the fact that dev_set_name() cannot be called 
>> from an atomic context, then it would seem to follow that 
>> dev_coredumpv also cannot be called from an atomic 
>> context and hence their gfp param is pointless and should presumably be 
>> removed.
>
> Thanks for your time and suggestions! I think the gfp_t parameter of dev_coredumpv and
> dev_coredumpm may not be removed, because it could be used to pass value to gfp_t
> parameter of kzalloc in dev_coredumpm. What's more, there are also many other places
> use dev_coredumpv and dev_coredumpm, if we remove the gfp_t parameter, there are too many
> places that need to modify and these places are not in interrupt
> context.

"Too many users" is not a valid reason to leave a bug in place, either
dev_coredumpv() should support GFP_ATOMIC or the gfp_t parameter should
be removed.

> There are two solutions now: one is to moves the operations that may
> sleep into a work item.

That does not fix the root cause that dev_coredumpv() claims it can be
called in atomic contexts.

> Another is to change the gfp_t parameter of dev_coredumpv from GFP_KERNEL to GFP_ATOMIC, and
> change the gfp_t parameter of kvasprintf_const and kstrdup from GFP_KERNEL to 
> "in_interrupt() ? GFP_ATOMIC : GFP_KERNEL".

in_interrupt() is deprecated and should not be used. And I don't think
it detects all atomic contexts like spinlocks.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
