Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64335A45BF
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiH2JIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiH2JIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:08:45 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58F15924C;
        Mon, 29 Aug 2022 02:08:44 -0700 (PDT)
Received: from [IPV6:2003:e9:d701:1d41:444a:bdf5:adf8:9c98] (p200300e9d7011d41444abdf5adf89c98.dip0.t-ipconnect.de [IPv6:2003:e9:d701:1d41:444a:bdf5:adf8:9c98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id DC52CC025B;
        Mon, 29 Aug 2022 11:08:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1661764123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kmK1xA3ChRDfbs0TeBtj2omjGednU5QOYRX/hf9CLvY=;
        b=J+LMzCfIJh5USARdHZll17yWkpMM1GhQgg1nTknvtwECow/iAbAECbttAsIAccrGZEybGM
        08W/WHkggZ3BtxYj//RWM4fb/HJ7zRB6Y786DRIVJdCcIhGmwBF9hOqB3EHiYEQtx4nJf1
        L/kDChq0CZNHqnZFVvqJlUW3UDjwvwp9Xwk6Kj7wrHhoQmOouGtMbKsc11KOXl1vd/EkD5
        57lfPrUI0d5A3Kjwtxv1JmNd/0MshTo44MWx4gNe10j4oUPvWttWBCmSkTQkpykLd9vK7o
        ZhrrnBc7rnU9hF/WJFM1N7OaxgGCrlZ8n7U36me0IzjP8OQEopcpeu/qk9YV4g==
Message-ID: <85f66a3a-95fa-5aaa-def0-998bf3f5139f@datenfreihafen.org>
Date:   Mon, 29 Aug 2022 11:08:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net/ieee802154: fix uninit value bug in dgram_sendmsg
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Haimin Zhang <tcs.kernel@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haimin Zhang <tcs_kernel@tencent.com>
References: <20220822071902.3419042-1-tcs_kernel@tencent.com>
 <f7e87879-1ac6-65e5-5162-c251204f07d4@datenfreihafen.org>
 <CAK-6q+hf27dY9d-FyAh2GtA_zG5J4kkHEX2Qj38Rac_PH63bQg@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAK-6q+hf27dY9d-FyAh2GtA_zG5J4kkHEX2Qj38Rac_PH63bQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Alex.

On 23.08.22 14:22, Alexander Aring wrote:
> Hi,
> 
> On Tue, Aug 23, 2022 at 5:42 AM Stefan Schmidt
> <stefan@datenfreihafen.org> wrote:
>>
>> Hello.
>>
>> On 22.08.22 09:19, Haimin Zhang wrote:
>>> There is uninit value bug in dgram_sendmsg function in
>>> net/ieee802154/socket.c when the length of valid data pointed by the
>>> msg->msg_name isn't verified.
>>>
>>> This length is specified by msg->msg_namelen. Function
>>> ieee802154_addr_from_sa is called by dgram_sendmsg, which use
>>> msg->msg_name as struct sockaddr_ieee802154* and read it, that will
>>> eventually lead to uninit value read. So we should check the length of
>>> msg->msg_name is not less than sizeof(struct sockaddr_ieee802154)
>>> before entering the ieee802154_addr_from_sa.
>>>
>>> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
>>
>>
>> This patch has been applied to the wpan tree and will be
>> part of the next pull request to net. Thanks!
> 
> For me this patch is buggy or at least it is questionable how to deal
> with the size of ieee802154_addr_sa here.

You are right. I completely missed this. Thanks for spotting!

> There should be a helper to calculate the size which depends on the
> addr_type field. It is not required to send the last 6 bytes if
> addr_type is IEEE802154_ADDR_SHORT.
> Nitpick is that we should check in the beginning of that function.

Haimin, in ieee802154 we could have two different sizes for 
ieee802154_addr_sa depending on the addr_type. We have short and 
extended addresses.

Could you please rework this patch to take this into account as Alex 
suggested?

I reverted your original patch from my tree.

regards
Stefan Schmidt
