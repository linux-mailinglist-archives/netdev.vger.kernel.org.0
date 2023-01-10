Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0F6664CBB
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 20:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjAJToj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 14:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbjAJToi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 14:44:38 -0500
Received: from mx15lb.world4you.com (mx15lb.world4you.com [81.19.149.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1121510AE
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 11:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2l3Xbktd3b6QBVqh+pYpZBLrmBix9p6ztyNw9xtd3jk=; b=FZeFbgI4OI/6FOQvyjL8cJyvz/
        e6w3oY06crfzdcyUGOnrmkrvuuy84Wqc6EropKGeVE/oIneWYKemPMD1gVrLPE/OVWCLOtXNA4ITQ
        ZzOkthF/rwJ7mAWgraOw5SdKA+U+O1Zu7jqWWrZX+hu+yTFK6vMOC8rrmek8yChQD0+0=;
Received: from [88.117.53.243] (helo=[10.0.0.160])
        by mx15lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pFKXx-00087W-Rs; Tue, 10 Jan 2023 20:44:33 +0100
Message-ID: <91161723-6968-17f1-e1af-b9c85b2ab55f@engleder-embedded.com>
Date:   Tue, 10 Jan 2023 20:44:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v4 01/10] tsnep: Use spin_lock_bh for TX
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-2-gerhard@engleder-embedded.com>
 <f4c818ba6cb5ac6f34bd73a67b18c5cd9da5f42a.camel@gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <f4c818ba6cb5ac6f34bd73a67b18c5cd9da5f42a.camel@gmail.com>
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

On 10.01.23 16:49, Alexander H Duyck wrote:
> On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
>> TX processing is done only within BH context. Therefore, _irqsafe
>> variant is not necessary.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> 
> Rather than reducing the context of this why not drop it completely? It
> doesn't look like you are running with the NETIF_F_LLTX flag set so
> from what I can tell it looks like you are taking the Tx lock in the
> xmit path. So Tx queues are protected with the Tx queue lock at the
> netdev level via the HARD_TX_LOCK macro.
> 
> Since it is already being used in the Tx path to protect multiple
> access you could probably just look at getting rid of it entirely.
> 
> The only caveat you would need to watch out for is a race between the
> cleaning and transmitting which can be addressed via a few barriers
> like what was done in the intel drivers via something like the
> __ixgbe_maybe_stop_tx function and the logic to wake the queue in the
> clean function.

I know these barriers in the intel drivers. But I chose to use a lock
like the microchip driver to be on the safe side rather than having a
fully optimized driver.

> Alternatively if you really feel you need this in the non-xmit path
> functions you could just drop the lock and instead use __netif_tx_lock
> for those spots that are accessing the queue outside the normal
> transmit path.

Ok, I will work on that. One of your suggestions will be done.

Gerhard
