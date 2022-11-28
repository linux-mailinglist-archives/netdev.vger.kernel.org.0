Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDCA63AA63
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiK1OFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbiK1OFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C920D130;
        Mon, 28 Nov 2022 06:05:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 124D0B80DD7;
        Mon, 28 Nov 2022 14:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23B2C433D6;
        Mon, 28 Nov 2022 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669644307;
        bh=pKzLRH5VeKBoKsem26OCcfqPYm0NJSVab6m05kUq5vc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jXIgL58gQSOg3zhcJXeedmhzNiH8fpS81FW1tl1E2ExrK+E7uP1z9AYeWbAK0GtPo
         YIu/jb5dqmBBQ6KmjpRVezsIwhFl1WGsaDcqGGSSoFXhuBGn7uIpdW9/88F4M+OO3D
         l6C01xIDOcTiN1YBxXgXX4FqsafcgOzUmoP3WjLTiEBPpItdjtpL7lt86Wh9sJWC6P
         dwsdprG/Db7XfhrVjlN90EZSbjbjGy3n4NptwOhygAS/FyVX4K3zH1HBYnw+MpYbQa
         o4V84nYI2OWfkgdEnPcPdJDVK9nYK/xBZ6nY8/ALbElv0tqFTc8uhcjyvQ5hzFs9NU
         KK8IDxQub2hyw==
From:   Kalle Valo <kvalo@kernel.org>
To:     "zhangxiaoxu \(A\)" <zhangxiaoxu5@huawei.com>
Cc:     <Ajay.Kathat@microchip.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH wireless] wifi: wilc1000: Fix UAF in wilc_netdev_cleanup() when iterator the RCU list
References: <20221124151349.2386077-1-zhangxiaoxu5@huawei.com>
        <a6d8f548-bcf4-4a02-df25-3a06aa8f2b42@microchip.com>
        <88650c25-5358-1f03-dc96-fb7fc550fb18@huawei.com>
        <871qpn72lw.fsf@kernel.org>
        <736584e7-571d-13f9-eb3e-34ce49e71e6c@huawei.com>
Date:   Mon, 28 Nov 2022 16:05:03 +0200
In-Reply-To: <736584e7-571d-13f9-eb3e-34ce49e71e6c@huawei.com> (zhangxiaoxu's
        message of "Mon, 28 Nov 2022 22:01:38 +0800")
Message-ID: <87fse35g4w.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com> writes:

> On 2022/11/28 19:14, Kalle Valo wrote:
>> "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com> writes:
>>
>>> On 2022/11/26 0:17, Ajay.Kathat@microchip.com wrote:
>>>>
>>>> On 24/11/22 20:43, Zhang Xiaoxu wrote:
>>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>>>>
>>>>> There is a UAF read when remove the wilc1000_spi module:
>>>>>
>>>>>    BUG: KASAN: use-after-free in wilc_netdev_cleanup.cold+0xc4/0xe0 [wilc1000]
>>>>>    Read of size 8 at addr ffff888116846900 by task rmmod/386
>>>>>
>>>>>    CPU: 2 PID: 386 Comm: rmmod Tainted: G                 N 6.1.0-rc6+ #8
>>>>>    Call Trace:
>>>>>     dump_stack_lvl+0x68/0x85
>>>>>     print_report+0x16c/0x4a3
>>>>>     kasan_report+0x95/0x190
>>>>>     wilc_netdev_cleanup.cold+0xc4/0xe0
>>>>>     wilc_bus_remove+0x52/0x60
>>>>>     spi_remove+0x46/0x60
>>>>>     device_remove+0x73/0xc0
>>>>>     device_release_driver_internal+0x12d/0x210
>>>>>     driver_detach+0x84/0x100
>>>>>     bus_remove_driver+0x90/0x120
>>>>>     driver_unregister+0x4f/0x80
>>>>>     __x64_sys_delete_module+0x2fc/0x440
>>>>>     do_syscall_64+0x38/0x90
>>>>>     entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>>
>>>>> Since set 'needs_free_netdev=true' when initialize the net device, the
>>>>> net device will be freed when unregister, then use the freed 'vif' to
>>>>> find the next will UAF read.
>>>>
>>>>
>>>> Did you test this behaviour on the real device. I am seeing a kernel
>>>> crash when the module is unloaded after the connection with an AP.
>>>
>>> Thanks Ajay, I have no real device, what kind of crash about your
>>> scenario?
>>
>> If you don't have a real device to test on, please state that clearly in
>> the commit log. For example, "Compile tested only" or something like
>> that.
>
> Thanks Kalle,
>
> I found this problem with a bpf mock device, and test this patch use
> the same way.

That's very good info, please always include that information to the
commit log as well. That way there's a better understanding how this
patch is found.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
