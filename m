Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAD05A9197
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 10:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiIAIG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 04:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbiIAIGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 04:06:16 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09894D41B0
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 01:06:05 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 52C8C7F4A1;
        Thu,  1 Sep 2022 10:06:04 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F7F334064;
        Thu,  1 Sep 2022 10:06:04 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25F7A3405A;
        Thu,  1 Sep 2022 10:06:04 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Thu,  1 Sep 2022 10:06:04 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id EF38B7F4A1;
        Thu,  1 Sep 2022 10:06:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1662019564; bh=FWJ5xLVEpc8QAaGZINUD22+7Yv2OSGH+KBhN1YST9lI=;
        h=Date:Subject:From:To:CC:References:In-Reply-To:From;
        b=p6+ukYM/2/hmHeZqNBHq3VRcbomUSBf2ufc4/0i8Tkgj+b4oPkBZjptUufJVNiLCl
         CNbS/6IKoAYfMo43jGBAgCxTfgJLqAtYxuWEce6nbnch6TePYQ+j32K/M1uajpnuyJ
         vkjM7ymnHAZzVByvjaGNARg0VZZ2WqrrYuaUMsNCv8MC0dz1z53WV+0sjzYF5DhAy5
         vDZIqSKMzJGvAVggeytECmpsGjPWwQ+jwjjBusyNgteT4uecx/qJYXPlBrneTKF4H3
         0+78PQWb9jVZ/u5tNr5dLiHaGBLc6VUJrlgwSAv8JdiihWMQXjkECDIR1ZLAl0PYDZ
         f2ISpVIXQGjPA==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.12; Thu, 1
 Sep 2022 10:06:02 +0200
Message-ID: <bfd69a72-1c45-a9a3-002b-697aa932c261@prolan.hu>
Date:   Thu, 1 Sep 2022 10:06:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] Use a spinlock to guard `fep->ptp_clk_on`
Content-Language: en-US
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <kernel@pengutronix.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
References: <20220831125631.173171-1-csokas.bence@prolan.hu>
 <20220831171259.GA147052@francesco-nb.int.toradex.com>
 <18c0c238-a006-7e52-65c5-1bcec0ee31e5@prolan.hu>
In-Reply-To: <18c0c238-a006-7e52-65c5-1bcec0ee31e5@prolan.hu>
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


On 2022. 09. 01. 9:51, Csókás Bence wrote:
> 
> On 2022. 08. 31. 18:24, Andrew Lunn wrote:
>  >>> Please keep to reverse christmas tree
>  >>
>  >> checkpatch didn't tell me that was a requirement... Easy to fix though.
>  >
>  > checkpatch does not have the smarts to detect this. And it is a netdev
>  > only thing.
> 
> I thought checkpatch also has the per-subsystem rules, too.
> 
>  > There is also a different between not being able to sleep, and not
>  > being able to process an interrupt for some other hardware. You got a
>  > report about taking a mutex in atomic context. That just means you
>  > cannot sleep, probably because a spinlock is held. That is very
>  > different to not being able to handle interrupts. You only need
>  > spin_lock_irqsave() if the interrupt handler also needs the same spin
>  > lock to protect it from a thread using the spin lock.
> 
> Alright, I will switch to plain `spin_lock()` then.

By the way, what about `&fep->tmreg_lock`? Should that also be switched 
to `spin_lock()`? If not, how should I handle the nested locking? 
Calling `spin_lock_irqsave(&fep->tmreg_lock)` after 
`spin_lock(&&fep->ptp_clk_lock)` seems pointless. Should I lock with 
`spin_lock_irqsave(&fep->ptp_clk_lock)` there?
