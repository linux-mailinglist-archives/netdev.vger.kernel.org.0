Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D51365F6CA
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 23:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbjAEW3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 17:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbjAEW3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 17:29:15 -0500
Received: from mx04lb.world4you.com (mx04lb.world4you.com [81.19.149.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69AA1ADB6
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 14:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7mka5k2l3e2+AD2rtpWSxCiWBKIdLBRyM+3Y4oBVqek=; b=pmmalQKKvPdZwq8Nfv6g3oPb1t
        TxHW8PSqpDfTppziVr1QpGYfV8f7SU2iHOSo6lyuPNBiSTW6QNLZ+VK4uCzA4F2eofdfsnglClW/N
        /VCdhN/VSS93MqRztmipfV1QUmTdcbxxFXQvab5KugQ5AEP3cVplRBiWmsgrOkLi6k4k=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx04lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pDYj3-0006Yo-AO; Thu, 05 Jan 2023 23:28:41 +0100
Message-ID: <7b61f312-2377-53c2-ff66-cc4f71c124d3@engleder-embedded.com>
Date:   Thu, 5 Jan 2023 23:28:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 8/9] tsnep: Add RX queue info for XDP support
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Saeed Mahameed <saeed@kernel.org>,
        netdev@vger.kernel.org
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-9-gerhard@engleder-embedded.com>
 <1dbae52d-6aba-467a-a864-24eeb3f96449@intel.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <1dbae52d-6aba-467a-a864-24eeb3f96449@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.01.23 18:35, Alexander Lobakin wrote:
> From: Gerhard Engleder <gerhard@engleder-embedded.com>
> Date: Wed Jan 04 2023 20:41:31 GMT+0100
> 
>> Register xdp_rxq_info with page_pool memory model. This is needed for
>> XDP buffer handling.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
>> ---
>>   drivers/net/ethernet/engleder/tsnep.h      |  6 ++--
>>   drivers/net/ethernet/engleder/tsnep_main.c | 34 +++++++++++++++++-----
>>   2 files changed, 31 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
>> index 0e7fc36a64e1..0210dab90f71 100644
>> --- a/drivers/net/ethernet/engleder/tsnep.h
>> +++ b/drivers/net/ethernet/engleder/tsnep.h
>> @@ -133,17 +133,19 @@ struct tsnep_rx {
>>   	u32 dropped;
>>   	u32 multicast;
>>   	u32 alloc_failed;
>> +
>> +	struct xdp_rxq_info xdp_rxq;
>>   };
>>   
>>   struct tsnep_queue {
>>   	struct tsnep_adapter *adapter;
>>   	char name[IFNAMSIZ + 9];
>>   
>> +	struct napi_struct napi;
>> +
>>   	struct tsnep_tx *tx;
>>   	struct tsnep_rx *rx;
>>   
>> -	struct napi_struct napi;
>> -
> 
> I'd leave a word in the commit message that you're moving ::napi to
> improve structure cacheline span. Or even do that in a separate commit
> with some pahole output to make it clear why you do that.

I only reordered based on access order during initialization. But I 
understand that this not a valid reason. I will remove that reordering.

>>   	int irq;
>>   	u32 irq_mask;
>>   	void __iomem *irq_delay_addr;
> 
> [...]
> 
>> @@ -1253,6 +1266,7 @@ int tsnep_netdev_open(struct net_device *netdev)
>>   {
>>   	struct tsnep_adapter *adapter = netdev_priv(netdev);
>>   	int i;
>> +	unsigned int napi_id;
> 
> Reverse Christmas Tree variable style is already messed up here, maybe
> you could fix it inplace while at it or at least not make it worse? :D

I forgot to do that here. Will be fixed.

Gerhard
