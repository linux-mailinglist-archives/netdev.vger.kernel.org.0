Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA7737B71D
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 09:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhELHzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 03:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhELHy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 03:54:58 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5454BC061574;
        Wed, 12 May 2021 00:53:51 -0700 (PDT)
Received: from localhost ([127.0.0.1] helo=bute.mt.lv)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lgjgX-0000nY-BE; Wed, 12 May 2021 10:53:37 +0300
MIME-Version: 1.0
Date:   Wed, 12 May 2021 10:53:37 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] atl1c: improve performance by avoiding
 unnecessary pcie writes on xmit
In-Reply-To: <217ba8c9-ab09-46be-3e49-149f810e72fd@gmail.com>
References: <20210511190518.8901-1-gatis@mikrotik.com>
 <20210511190518.8901-3-gatis@mikrotik.com>
 <217ba8c9-ab09-46be-3e49-149f810e72fd@gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <f15674a0a6544d8c90522cc8938e3eb6@mikrotik.com>
X-Sender: gatis@mikrotik.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-05-12 00:39, Eric Dumazet wrote:
>> @@ -2270,8 +2272,11 @@ static netdev_tx_t atl1c_xmit_frame(struct 
>> sk_buff *skb,
>>  		atl1c_tx_rollback(adapter, tpd, type);
>>  		dev_kfree_skb_any(skb);
>>  	} else {
>> -		netdev_sent_queue(adapter->netdev, skb->len);
>> -		atl1c_tx_queue(adapter, skb, tpd, type);
>> +		bool more = netdev_xmit_more();
>> +
>> +		__netdev_sent_queue(adapter->netdev, skb->len, more);
> 
> 
> This is probably buggy.
> 
> You must check and use the return code of this function,
> as in :
> 
> 	bool door_bell = __netdev_sent_queue(adapter->netdev, skb->len,
> netdev_xmit_more());
> 
> 	if (door_bell)
> 		atl1c_tx_queue(adapter, type);
> 

Eric, thank you for taking your time to look at this!

You are correct, tx queue can get stopped in __netdev_sent_queue
and if there were more packets coming the submit to HW would be
missed / unnecessarily delayed.


> 
>> +		if (!more)
>> +			atl1c_tx_queue(adapter, type);
>>  	}
>> 
>>  	return NETDEV_TX_OK;
>> 
