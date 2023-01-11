Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0D2666347
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 20:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbjAKTLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 14:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbjAKTLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 14:11:48 -0500
Received: from mx18lb.world4you.com (mx18lb.world4you.com [81.19.149.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40623F5B5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 11:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=b/qVzB2cqUrvEhrHnbdzi7Z6A0nwkVWYNJ62tKnn+0A=; b=EWl91cDvlphxCAGGFoSTEhxcRL
        XZ9Hrq3gFF+NBCisVtJbqEbe9yUUwMJNcxS1o4JtHWK0xu+0szjJozdf2d2n6b5ZqDjTYMGxHvCha
        eK1gqbSBhCfSxsNtW2OeEEhdXqDs3CU/orggewyBzNt8Pdl8NRK5qE2MaZodInx+LGdo=;
Received: from [88.117.53.243] (helo=[10.0.0.160])
        by mx18lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pFgVk-0007MI-O5; Wed, 11 Jan 2023 20:11:44 +0100
Message-ID: <8e6fae4d-83f4-e31c-2274-208e27e7b156@engleder-embedded.com>
Date:   Wed, 11 Jan 2023 20:11:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v4 10/10] tsnep: Support XDP BPF program setup
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-11-gerhard@engleder-embedded.com>
 <336b9f28bca980813310dd3007c862e9f738279e.camel@gmail.com>
 <3d0bc2ad-2c4a-527a-be09-b9746c87b2a8@engleder-embedded.com>
 <20230110161237.2a40ccc8@kernel.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230110161237.2a40ccc8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.01.23 01:12, Jakub Kicinski wrote:
> On Tue, 10 Jan 2023 22:38:04 +0100 Gerhard Engleder wrote:
>>> As I called out earlier the __TSNEP_DOWN is just !IFF_UP so you don't
>>> need that bit.
>>>
>>> The fact that netif_carrier_off is here also points out the fact that
>>> the code in the Tx path isn't needed regarding __TSNEP_DOWN and you can
>>> probably just check netif_carrier_ok if you need the check.
>>
>> tsnep_netdev_close() is called directly during bpf prog setup (see
>> tsnep_xdp_setup_prog() in this commit). If the following
>> tsnep_netdev_open() call fails, then this flag signals that the device
>> is already down and nothing needs to be cleaned up if
>> tsnep_netdev_close() is called later (because IFF_UP is still set).
> 
> TBH we've been pushing pretty hard for a while now to stop people
> from implementing the:
> 
> 	close()
> 	change config
> 	open()
> 
> sort of reconfiguration. I did that myself when I was a was
> implementing my first Ethernet driver and DaveM nacked the change.
> Must have been a decade ago.
> 
> Imagine you're working on a remote box via SSH and the box is under
> transient memory pressure. Allocations fail, we don't want the machine
> to fall off the network :(

I agree with you that this pattern is bad. Most XDP BPF program setup do
it like that, but this is of course no valid argument.

In the last review round I made the following suggestion (but got no
reply so far):

What about always using 'XDP_PACKET_HEADROOM' as offset in the RX
buffer? The offset 'NET_SKB_PAD + NET_IP_ALIGN' would not even be used
if XDP is not enabled. Changing this offset is the only task to be done
at the first XDP BFP prog setup call. By always using this offset
no

	close()
	change config
	open()

pattern is needed. As a result no handling for failed open() is needed
and __TSNEP_DOWN is not needed. Simpler code with less problems in my
opinion.

The only problem could be that NET_IP_ALIGN is not used, but
NET_IP_ALIGN is 0 anyway on the two platforms (x86, arm64) where this
driver is used.

Gerhard
