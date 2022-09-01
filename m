Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E5F5A913F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiIAHwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbiIAHwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:52:34 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21161114F
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 00:51:17 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 937EF7F475;
        Thu,  1 Sep 2022 09:51:14 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DCC234068;
        Thu,  1 Sep 2022 09:51:14 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6521334065;
        Thu,  1 Sep 2022 09:51:14 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Thu,  1 Sep 2022 09:51:14 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id 38D607F482;
        Thu,  1 Sep 2022 09:51:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1662018674; bh=5FJrKUyNCDfhf/HIbCEtPUYqKg2U9uwmuVvV3KgECvs=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=Qs927nS9TEANYseCDKuY6PLomDuL7vqg3p2t0wF1mexZTOi3NwioI1tq3szmN6fsf
         sG86eUfuUk/l6NlbfGeoT5dR2G7zrz5Y2zl/V7cymIM6RwH0Lc1my+N0NXlgHjZ9Ax
         w+AjE+fypNf/FNmwKfZdBldNJoOe9GunUonS3cc5mVLXJnAYE4UZV0rWgWOTDiuUBs
         kO20ClNjyjWeK8j95RCNS9khYttTYlh/3gMxjIe4E5Aq5JDXdyOudFz33dqwRcUps9
         q4LoxxeubsI5k7KudJUFcJGu6IxIzo8505b2wjGPEYtNViRxy8sKMvNDN7fzPZFlZW
         btoo1cGJMrW/w==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.12; Thu, 1
 Sep 2022 09:51:13 +0200
Message-ID: <18c0c238-a006-7e52-65c5-1bcec0ee31e5@prolan.hu>
Date:   Thu, 1 Sep 2022 09:51:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] Use a spinlock to guard `fep->ptp_clk_on`
Content-Language: en-US
To:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
References: <20220831125631.173171-1-csokas.bence@prolan.hu>
 <20220831171259.GA147052@francesco-nb.int.toradex.com>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <20220831171259.GA147052@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF456637C61
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022. 08. 31. 18:24, Andrew Lunn wrote:
 >>> Please keep to reverse christmas tree
 >>
 >> checkpatch didn't tell me that was a requirement... Easy to fix though.
 >
 > checkpatch does not have the smarts to detect this. And it is a netdev
 > only thing.

I thought checkpatch also has the per-subsystem rules, too.

 > There is also a different between not being able to sleep, and not
 > being able to process an interrupt for some other hardware. You got a
 > report about taking a mutex in atomic context. That just means you
 > cannot sleep, probably because a spinlock is held. That is very
 > different to not being able to handle interrupts. You only need
 > spin_lock_irqsave() if the interrupt handler also needs the same spin
 > lock to protect it from a thread using the spin lock.

Alright, I will switch to plain `spin_lock()` then.

On 2022. 08. 31. 19:12, Francesco Dolcini wrote:
> On Wed, Aug 31, 2022 at 02:56:31PM +0200, Csókás Bence wrote:
>> Mutexes cannot be taken in a non-preemptible context,
>> causing a panic in `fec_ptp_save_state()`. Replacing
>> `ptp_clk_mutex` by `ptp_clk_lock` fixes this.
> 
> I would probably add the kernel BUG trace to the commit message.
> 
>> Fixes: 91c0d987a9788dcc5fe26baafd73bf9242b68900
>> Fixes: 6a4d7234ae9a3bb31181f348ade9bbdb55aeb5c5
>> Fixes: f79959220fa5fbda939592bf91c7a9ea90419040
> 
> Just
> 
> Fixes: f79959220fa5 ("fec: Restart PPS after link state change >
>>
>> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> Is this https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/ the report?

Yes, precisely.

> 
> I just stumbled on the same issue on latest torvalds 6.0-rc3.
> 
> [   22.718465] =============================
> [   22.725431] [ BUG: Invalid wait context ]
> [   22.732439] 6.0.0-rc3-00007-gdcf8e5633e2e #1 Tainted: G        W
> [   22.742278] -----------------------------
> [   22.749217] kworker/3:1/45 is trying to lock:
> [   22.757157] c211b71c (&fep->ptp_clk_mutex){+.+.}-{3:3}, at: fec_ptp_gettime+0x30/0xcc
> [   22.770814] other info that might help us debug this:
> [   22.778718] context-{4:4}
> [   22.784065] 4 locks held by kworker/3:1/45:
> [   22.790949]  #0: c20072a8 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work+0x1e4/0x730
> [   22.806494]  #1: e6a15f18 ((work_completion)(&(&dev->state_queue)->work)){+.+.}-{0:0}, at: process_one_work+0x1e4/0x730
> [   22.822744]  #2: c287a478 (&dev->lock){+.+.}-{3:3}, at: phy_state_machine+0x34/0x228
> [   22.835884]  #3: c211b2a4 (&dev->tx_global_lock){+...}-{2:2}, at: netif_tx_lock+0x10/0x1c

Thank you, this lock was the source of the problem!

> 
> Francesco
> 

Bence
