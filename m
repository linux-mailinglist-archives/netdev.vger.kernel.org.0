Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5BB63A6DE
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiK1LO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiK1LO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:14:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62601193CE;
        Mon, 28 Nov 2022 03:14:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F347261118;
        Mon, 28 Nov 2022 11:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BFBC433D7;
        Mon, 28 Nov 2022 11:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669634066;
        bh=2dBnazs7c83SCuppqPo/hbSVH4BqaPDHbb54lLbEdxc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=tbJVYSG8rk9C2aLZqbZ+0t3j/esiEwW4Qnkmn4QfodwLuj6WYKcKBm2lcVKsjEZSF
         nkn/q9kQL4TVlyRgrwrkiANbkEUTZUctgkPH4FKtmn2gWwxVT3oqpePRnQGNrAuJ2m
         xNwFJvBKXsFBEXf9xlpOiepYM5hooZKaG9dnW344aG+F24ZKEmU1H4nG4hB2E8/qEG
         fxMo+jh8opB72Vqo4Ub0wRk5t6FE2RcRpAcVfsySF2U4EEsAB/wAKNl37MaynjyMPl
         J8I3GkPuoV1Dge2A4nuOfhbXOlsmjY64gY2+wGN/wArIBF/fiG2EYlMa6/AwOFXxkl
         2uHmWJmL7fOyg==
From:   Kalle Valo <kvalo@kernel.org>
To:     "zhangxiaoxu \(A\)" <zhangxiaoxu5@huawei.com>
Cc:     <Ajay.Kathat@microchip.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH wireless] wifi: wilc1000: Fix UAF in wilc_netdev_cleanup() when iterator the RCU list
In-Reply-To: <88650c25-5358-1f03-dc96-fb7fc550fb18@huawei.com> (zhangxiaoxu's
        message of "Sat, 26 Nov 2022 16:14:43 +0800")
References: <20221124151349.2386077-1-zhangxiaoxu5@huawei.com>
        <a6d8f548-bcf4-4a02-df25-3a06aa8f2b42@microchip.com>
        <88650c25-5358-1f03-dc96-fb7fc550fb18@huawei.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Mon, 28 Nov 2022 13:14:19 +0200
Message-ID: <871qpn72lw.fsf@kernel.org>
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

> On 2022/11/26 0:17, Ajay.Kathat@microchip.com wrote:
>>
>> On 24/11/22 20:43, Zhang Xiaoxu wrote:
>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>>
>>> There is a UAF read when remove the wilc1000_spi module:
>>>
>>>   BUG: KASAN: use-after-free in wilc_netdev_cleanup.cold+0xc4/0xe0 [wilc1000]
>>>   Read of size 8 at addr ffff888116846900 by task rmmod/386
>>>
>>>   CPU: 2 PID: 386 Comm: rmmod Tainted: G                 N 6.1.0-rc6+ #8
>>>   Call Trace:
>>>    dump_stack_lvl+0x68/0x85
>>>    print_report+0x16c/0x4a3
>>>    kasan_report+0x95/0x190
>>>    wilc_netdev_cleanup.cold+0xc4/0xe0
>>>    wilc_bus_remove+0x52/0x60
>>>    spi_remove+0x46/0x60
>>>    device_remove+0x73/0xc0
>>>    device_release_driver_internal+0x12d/0x210
>>>    driver_detach+0x84/0x100
>>>    bus_remove_driver+0x90/0x120
>>>    driver_unregister+0x4f/0x80
>>>    __x64_sys_delete_module+0x2fc/0x440
>>>    do_syscall_64+0x38/0x90
>>>    entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>
>>> Since set 'needs_free_netdev=true' when initialize the net device, the
>>> net device will be freed when unregister, then use the freed 'vif' to
>>> find the next will UAF read.
>>
>>
>> Did you test this behaviour on the real device. I am seeing a kernel
>> crash when the module is unloaded after the connection with an AP.
>
> Thanks Ajay, I have no real device, what kind of crash about your
> scenario?

If you don't have a real device to test on, please state that clearly in
the commit log. For example, "Compile tested only" or something like
that.

We get way too much untested patches where there's no indication that
they have had no testing. I'm really concerned about this trend, I'm
even considering should I just start dropping these kind of untested
cleanup patches?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
