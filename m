Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CDA66632F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbjAKS62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbjAKS61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:58:27 -0500
Received: from mx07lb.world4you.com (mx07lb.world4you.com [81.19.149.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69A4A1A1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ITe/T5WnBV/61UAgw086KEloGFWl0DbHDso4yyjYdoo=; b=qxU6l4ExAGhq3SNzIHzvNQKXYG
        ok5keI7AQ3aXqx6ZxkH/gCqCCV3k8ZeKpOcnI3zb81EEcTwpT09vhtn1+FANqGJsua/mvgWONUk9F
        m4pWbQg2KM0k8HzaopTyowGCCz9wuMUII6TnswDp9cu7SAmfjOfe5V9OmAuhJLXTA+Ds=;
Received: from [88.117.53.243] (helo=[10.0.0.160])
        by mx07lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pFgIr-0004DV-BH; Wed, 11 Jan 2023 19:58:25 +0100
Message-ID: <87ea391d-a971-ffcd-35f8-83a1fc5963e2@engleder-embedded.com>
Date:   Wed, 11 Jan 2023 19:58:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v4 10/10] tsnep: Support XDP BPF program setup
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-11-gerhard@engleder-embedded.com>
 <336b9f28bca980813310dd3007c862e9f738279e.camel@gmail.com>
 <3d0bc2ad-2c4a-527a-be09-b9746c87b2a8@engleder-embedded.com>
 <cb2057cf002611c58ee109d9f250bf43f0b15b01.camel@gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <cb2057cf002611c58ee109d9f250bf43f0b15b01.camel@gmail.com>
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

On 11.01.23 00:00, Alexander H Duyck wrote:
> On Tue, 2023-01-10 at 22:38 +0100, Gerhard Engleder wrote:
>> On 10.01.23 18:33, Alexander H Duyck wrote:
>>> On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
>>>> Implement setup of BPF programs for XDP RX path with command
>>>> XDP_SETUP_PROG of ndo_bpf(). This is the final step for XDP RX path
>>>> support.
>>>>
>>>> tsnep_netdev_close() is called directly during BPF program setup. Add
>>>> netif_carrier_off() and netif_tx_stop_all_queues() calls to signal to
>>>> network stack that device is down. Otherwise network stack would
>>>> continue transmitting pakets.
>>>>
>>>> Return value of tsnep_netdev_open() is not checked during BPF program
>>>> setup like in other drivers. Forwarding the return value would result in
>>>> a bpf_prog_put() call in dev_xdp_install(), which would make removal of
>>>> BPF program necessary.
>>>>
>>>> If tsnep_netdev_open() fails during BPF program setup, then the network
>>>> stack would call tsnep_netdev_close() anyway. Thus, tsnep_netdev_close()
>>>> checks now if device is already down.
>>>>
>>>> Additionally remove $(tsnep-y) from $(tsnep-objs) because it is added
>>>> automatically.

<...>

>>>> +	netif_carrier_off(netdev);
>>>> +	netif_tx_stop_all_queues(netdev);
>>>>    
>>>
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
> If the call to close was fouled up you should probably be blocking
> access to the device via at least a netif_device_detach. I susppose you
> could use the __LINK_STATE_PRESENT bit as the inverse of the
> __TSNEP_DOWN bit. If your open fails you clean up, detatch the device,
> and in the close path you only run through it if the device is present.
> 
> Basically what we want to avoid is adding a bunch of extra state as
> what we tend to see is that it will start to create a snarl as you add
> more and more layers.

To be honest, I cannot argue that __TSNEP_DOWN is great solution. It is
may more about fighting symptoms from the

	close()
	change config
	open()

style which according to Jabuk should be prevented anyway. I will
suggest a different solution as a reply to Jakubs comment.

Gerhard
