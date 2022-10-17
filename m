Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EAC6010BF
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 16:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiJQOG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 10:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJQOG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 10:06:28 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5611A25C51;
        Mon, 17 Oct 2022 07:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nnNaPHsK6FwMseLsC5mx5u23AVdFa4nC/67pGYTx9iw=; b=VnO3i3W9PnC25b/uABFAWH4zD9
        IddvmWj5M3YARUxvtiYJK9qOj9HsnaTXguCNUswoIDWihuxqgA0z7Td2FjR78uWHBvcy+a7MouxzO
        1ugt/DYFA1Lgg4Qfzki6NpD8qJbKPgg0OYXn1Jee7JsOdT3DPkQOl31y6AESAsFkdH5I40wha5BPs
        /BZtAPyrnYLzNk5NXdWpCnb0ZcB2xcASRfSNL/vA50luXoXH2aFpANFoii+++U5P/OCWXal++FJva
        NVxuR2YBT6IE5QidG5q30Mj/tkJnoKBETl2z1fasjEJLkbmLG+AjZLtpC7qOGEXBxs/bsk8YLuC0z
        EnRJofeg==;
Received: from [179.113.159.85] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1okQkz-000OT3-Sj; Mon, 17 Oct 2022 16:06:17 +0200
Message-ID: <1df38599-ace7-5673-4cbd-7861de385d79@igalia.com>
Date:   Mon, 17 Oct 2022 11:05:53 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 08/11] EDAC/altera: Skip the panic notifier if kdump is
 loaded
Content-Language: en-US
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     Dinh Nguyen <dinguyen@kernel.org>, Tony Luck <tony.luck@intel.com>,
        linux-edac@vger.kernel.org, bp@alien8.de
Cc:     kexec@lists.infradead.org, bhe@redhat.com, pmladek@suse.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, xuqiang36@huawei.com
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-9-gpiccoli@igalia.com>
 <742d2a7e-efee-e212-178e-ba642ec94e2a@igalia.com>
In-Reply-To: <742d2a7e-efee-e212-178e-ba642ec94e2a@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2022 11:10, Guilherme G. Piccoli wrote:
> On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
>> The altera_edac panic notifier performs some data collection with
>> regards errors detected; such code relies in the regmap layer to
>> perform reads/writes, so the code is abstracted and there is some
>> risk level to execute that, since the panic path runs in atomic
>> context, with interrupts/preemption and secondary CPUs disabled.
>>
>> Users want the information collected in this panic notifier though,
>> so in order to balance the risk/benefit, let's skip the altera panic
>> notifier if kdump is loaded. While at it, remove a useless header
>> and encompass a macro inside the sole ifdef block it is used.
>>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Petr Mladek <pmladek@suse.com>
>> Cc: Tony Luck <tony.luck@intel.com>
>> Acked-by: Dinh Nguyen <dinguyen@kernel.org>
>> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
>>
>> ---
>>
>> V3:
>> - added the ack tag from Dinh - thanks!
>> - had a good discussion with Boris about that in V2 [0],
>> hopefully we can continue and reach a consensus in this V3.
>> [0] https://lore.kernel.org/lkml/46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com/
>>
>> V2:
>> - new patch, based on the discussion in [1].
>> [1] https://lore.kernel.org/lkml/62a63fc2-346f-f375-043a-fa21385279df@igalia.com/
>>
>> [...]
> 
> Hi Dinh, Tony, Boris - sorry for the ping.

Hey folks, apologies for the new ping.

Is there anything to improve here maybe? Reviews / opinions are very
appreciated!
Cheers,


Guilherme
