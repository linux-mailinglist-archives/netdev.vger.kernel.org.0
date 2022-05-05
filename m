Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D6051C550
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381656AbiEEQuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352046AbiEEQuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:50:44 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAF81C137
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZABu29cmFtFz0DlUZesQvT7zWOa4NIe/EI7QueFeLSg=; b=ZMZI6EN1hzfWKZ7MDZceLYhUwQ
        S73VUmeMbp8WnKbJonj6Dyp7UNEOLY4a9MJdCq0r1ZTWgyPOoGgmJA0EWIzFi301KZ+m6kCafsDvZ
        7N1BajN+O12KDlRaKlpFJUDL/FptvBj34ohyGAHT1LEDX49ui6c6N7PsSMeDbE11YsE4=;
Received: from p200300daa70ef200412f484bca3869cd.dip0.t-ipconnect.de ([2003:da:a70e:f200:412f:484b:ca38:69cd] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nmecu-0003kr-Tg; Thu, 05 May 2022 18:46:52 +0200
Message-ID: <2a338e8e-3288-859c-d2e8-26c5712d3d06@nbd.name>
Date:   Thu, 5 May 2022 18:46:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
 <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com> <YnP1nOqXI4EO1DLU@lunn.ch>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <YnP1nOqXI4EO1DLU@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05.05.22 18:04, Andrew Lunn wrote:
>> you'll see that most used functions are:
>> v7_dma_inv_range
>> __irqentry_text_end
>> l2c210_inv_range
>> v7_dma_clean_range
>> bcma_host_soc_read32
>> __netif_receive_skb_core
>> arch_cpu_idle
>> l2c210_clean_range
>> fib_table_lookup
> 
> There is a lot of cache management functions here. Might sound odd,
> but have you tried disabling SMP? These cache functions need to
> operate across all CPUs, and the communication between CPUs can slow
> them down. If there is only one CPU, these cache functions get simpler
> and faster.
> 
> It just depends on your workload. If you have 1 CPU loaded to 100% and
> the other 3 idle, you might see an improvement. If you actually need
> more than one CPU, it will probably be worse.
> 
> I've also found that some Ethernet drivers invalidate or flush too
> much. If you are sending a 64 byte TCP ACK, all you need to flush is
> 64 bytes, not the full 1500 MTU. If you receive a TCP ACK, and then
> recycle the buffer, all you need to invalidate is the size of the ACK,
> so long as you can guarantee nothing has touched the memory above it.
> But you need to be careful when implementing tricks like this, or you
> can get subtle corruption bugs when you get it wrong.
I just took a quick look at the driver. It allocates and maps rx buffers 
that can cover a packet size of BGMAC_RX_MAX_FRAME_SIZE = 9724.
This seems rather excessive, especially since most people are going to 
use a MTU of 1500.
My proposal would be to add support for making rx buffer size dependent 
on MTU, reallocating the ring on MTU changes.
This should significantly reduce the time spent on flushing caches.

- Felix
