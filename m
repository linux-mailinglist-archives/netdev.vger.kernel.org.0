Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E063664CC5
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 20:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjAJTrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 14:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbjAJTrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 14:47:47 -0500
Received: from mx15lb.world4you.com (mx15lb.world4you.com [81.19.149.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D72A1E3D2
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 11:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xktJjzXstiPTDHA1LT3t6gW+H7ETpyS/m/4BzfmtnVM=; b=gU4tSsAfFaR0Lnzq31dREukl2E
        0itSJZcfME3Hix/KqaUNb39COitEC+YfvVSiN7Daw9bMi+d0jN92hJOTKxJ3Mesn/pC/i5A2D9mCz
        s0znGXfMbG1gq9u07NpRoYWLs6Hs1v2wrC6L7EbFS6ohX9QlgtjhXgvILgx8WVZzJDuk=;
Received: from [88.117.53.243] (helo=[10.0.0.160])
        by mx15lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pFKb2-0000Nn-No; Tue, 10 Jan 2023 20:47:44 +0100
Message-ID: <fcf4e29a-003c-6ba8-161f-b6a9e51bb449@engleder-embedded.com>
Date:   Tue, 10 Jan 2023 20:47:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v4 03/10] tsnep: Do not print DMA mapping error
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-4-gerhard@engleder-embedded.com>
 <6ef7979d1617b669e792154c32a5f7bf8fe1682d.camel@gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <6ef7979d1617b669e792154c32a5f7bf8fe1682d.camel@gmail.com>
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



On 10.01.23 16:53, Alexander H Duyck wrote:
> On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
>> Printing in data path shall be avoided. DMA mapping error is already
>> counted in stats so printing is not necessary.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/tsnep_main.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
>> index d148ba422b8c..8c6d6e210494 100644
>> --- a/drivers/net/ethernet/engleder/tsnep_main.c
>> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
>> @@ -469,8 +469,6 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>>   
>>   		spin_unlock_bh(&tx->lock);
>>   
>> -		netdev_err(tx->adapter->netdev, "TX DMA map failed\n");
>> -
>>   		return NETDEV_TX_OK;
>>   	}
>>   	length = retval;
> 
> It might be nice to add a stat to indicate that this is specifically a
> mapping error rather than just incrementing dropped but that could also
> be done in a future patch.

I took a note for future work.

Gerhard
