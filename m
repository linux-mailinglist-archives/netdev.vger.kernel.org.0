Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9103664D21
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 21:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjAJURB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 15:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjAJUQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 15:16:58 -0500
Received: from mx18lb.world4you.com (mx18lb.world4you.com [81.19.149.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA1E5882D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 12:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VWNMFHIeZueffhnbGk92G4vxijKaUM4rf4UxVMq7WPw=; b=EXJ2yxNhbK4HxQkRWEuYlR/lFn
        aCe9/s8g2ulala4DY4C8G8TB+ubxtmliYcsaWxmHwf1HRLNltgQl4vfrpoggjpqT6SDRaG3AgBkbR
        e6FF9uGslPaouzPtX7LBz6yivsLhhJfNZIZNSlPVn97CggyhYbEg6Yi2cuJZmJ/QRzfQ=;
Received: from [88.117.53.243] (helo=[10.0.0.160])
        by mx18lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pFL3G-0000lz-IZ; Tue, 10 Jan 2023 21:16:54 +0100
Message-ID: <e152e992-8868-3590-708a-ecc9a98991e5@engleder-embedded.com>
Date:   Tue, 10 Jan 2023 21:16:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v4 04/10] tsnep: Add adapter down state
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-5-gerhard@engleder-embedded.com>
 <aeceda3aee89ad7e856afa45f78d482b3c490cc4.camel@gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <aeceda3aee89ad7e856afa45f78d482b3c490cc4.camel@gmail.com>
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

On 10.01.23 17:05, Alexander H Duyck wrote:
> On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
>> Add adapter state with flag for down state. This flag will be used by
>> the XDP TX path to deny TX if adapter is down.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> 
> What value is this bit adding?
> 
>  From what I can tell you could probably just use netif_carrier_ok in
> place of this and actually get better coverage in terms of identifying
> state in which the Tx queue is able to function. So in your XDP_TX
> patch you could do that if you really need it.

TX does not check the link state, because the hardware just drops all
packets if there is no link. I would like to keep it like that, because
it minimizes special behavior if the link is down. netif_carrier_ok()
would include the link state.

> As far as the use in your close function it is redundant since the
> IFF_UP is only set if ndo_open completes, and ndo_stop is only called
> if IFF_UP is set. So your down flag would be redundant with !IFF_UP in
> that case.

tsnep_netdev_close() is called directly during bpf prog setup (see last
commit). If the following tsnep_netdev_open() call fails, then this
flag signals that the device is actually down even if IFF_UP is set. So
in this case the down flag is not redundant to !IFF_UP.

Is this a good enough reason for the flag?

Gerhard
