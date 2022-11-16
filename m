Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FF162CDC3
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiKPWgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiKPWgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:36:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503726AEF4;
        Wed, 16 Nov 2022 14:36:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD0A161FF9;
        Wed, 16 Nov 2022 22:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C82DC433C1;
        Wed, 16 Nov 2022 22:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668638180;
        bh=PBtBrhR6SnvnYI1/YyRvPYjE5wE5qScBBW+6ZtsQn3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gcmbe9TPSgnloH0Xj5T7JSM1en4RAl/sPLhlLslHSATsbmeAYqb7kUZ5COZ3yBcyq
         wnqbnvb9+DowAyBAzrLISSZPg2tPtduQFLddITss5ufGKMYuAShI1AQet08WoNyAD5
         h/1MbJJHigEQoP19MBKvCQ2u0r1TINkJTvpIwq8fdV+wBKj2VGOXQH/mcN2Ajftm9a
         sMP7pA2fLjSo7sA8yfZmjbM/lwC868Sh+L7juM1LPT4B9NcF+YE3m2C7p9vzuA4ir4
         7nV3KLoZa9hk+0Sfz/1PpShtIMSuLNRuw8F8j7J5uWIw6onHqoD8sU0+D7DS0nAMnH
         YqISmJDCbmW4w==
Date:   Wed, 16 Nov 2022 14:36:19 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Moritz Fischer <mdf@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: nixge: fix potential memory leak in
 nixge_start_xmit()
Message-ID: <Y3Vl40BzsL9nFqQv@x130.lan>
References: <1668416136-33530-1-git-send-email-zhangchangzhong@huawei.com>
 <Y3IbBCioK1Clt/3a@electric-eye.fr.zoreil.com>
 <21641ba0-3ce1-c409-b513-1bbbaeccaa51@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <21641ba0-3ce1-c409-b513-1bbbaeccaa51@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 21:20, Zhang Changzhong wrote:
>On 2022/11/14 18:40, Francois Romieu wrote:
>> Zhang Changzhong <zhangchangzhong@huawei.com> :
>>> The nixge_start_xmit() returns NETDEV_TX_OK but does not free skb on two
>>> error handling cases, which can lead to memory leak.
>>>
>>> To fix this, return NETDEV_TX_BUSY in case of nixge_check_tx_bd_space()
>>> fails and add dev_kfree_skb_any() in case of dma_map_single() fails.
>>
>> This patch merge two unrelated changes. Please split.
>>
>>> Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
>>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>>> ---
>>>  drivers/net/ethernet/ni/nixge.c | 6 ++++--
>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
>>> index 19d043b593cc..b9091f9bbc77 100644
>>> --- a/drivers/net/ethernet/ni/nixge.c
>>> +++ b/drivers/net/ethernet/ni/nixge.c
>>> @@ -521,13 +521,15 @@ static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
>>>  	if (nixge_check_tx_bd_space(priv, num_frag)) {
>>>  		if (!netif_queue_stopped(ndev))
>>>  			netif_stop_queue(ndev);
>>> -		return NETDEV_TX_OK;
>>> +		return NETDEV_TX_BUSY;
>>>  	}
>>
>> The driver should probably check the available room before returning
>> from hard_start_xmit and turn the check above unlikely().
>>
>> Btw there is no lock and the Tx completion is irq driven: the driver
>> is racy. :o(
>>
>
>Hi Francois,
>
>Thanks for you review. I'll make v2 according to your suggestion.
>

you will probably need to check out: Transmit path guidelines:
https://www.kernel.org/doc/Documentation/networking/driver.rst

