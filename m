Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449376E6C0F
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbjDRS0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbjDRS0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:26:12 -0400
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C7786BA;
        Tue, 18 Apr 2023 11:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=60JTq/3AkEEH6ZJ7cFdFxzFkEQSOLeVK0t83wrNDlRs=; b=DSJ01PZvuAjkKcfQSMvCtGoj7y
        3hXPJmswpBtNsxFUiK1tYAmsbUpqDrFVTkKehqnJNkJa65iUY7ZJpK2tzqa3AEcbAvY5IlPcQhNU0
        gOjQF7yb2nda40GAWLvLGlIwPL1t4gy4szWbCjCYiiMcwqgJ8jk9W8CRwZ2G8yB2qc3w=;
Received: from [88.117.57.231] (helo=[10.0.0.160])
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1poq1a-0004IW-Se; Tue, 18 Apr 2023 20:25:54 +0200
Message-ID: <986ca495-ef49-4eff-4d92-3f96e7b37fb3@engleder-embedded.com>
Date:   Tue, 18 Apr 2023 20:25:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v2 6/6] tsnep: Add XDP socket zero-copy TX
 support
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com
References: <20230415144256.27884-1-gerhard@engleder-embedded.com>
 <20230415144256.27884-7-gerhard@engleder-embedded.com>
 <e4309e95bc98ff2d464dd26fc4f3e77a914a6cb5.camel@redhat.com>
Content-Language: en-US
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <e4309e95bc98ff2d464dd26fc4f3e77a914a6cb5.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.04.23 10:27, Paolo Abeni wrote:
> On Sat, 2023-04-15 at 16:42 +0200, Gerhard Engleder wrote:
>> Send and complete XSK pool frames within TX NAPI context. NAPI context
>> is triggered by ndo_xsk_wakeup.
>>
>> Test results with A53 1.2GHz:
>>
>> xdpsock txonly copy mode:
>>                     pps            pkts           1.00
>> tx                 284,409        11,398,144
>> Two CPUs with 100% and 10% utilization.
>>
>> xdpsock txonly zero-copy mode:
>>                     pps            pkts           1.00
>> tx                 511,929        5,890,368
>> Two CPUs with 100% and 1% utilization.
>>
>> Packet rate increases and CPU utilization is reduced.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/tsnep.h      |   2 +
>>   drivers/net/ethernet/engleder/tsnep_main.c | 131 +++++++++++++++++++--
>>   2 files changed, 123 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
>> index d0bea605a1d1..11b29f56aaf9 100644
>> --- a/drivers/net/ethernet/engleder/tsnep.h
>> +++ b/drivers/net/ethernet/engleder/tsnep.h
>> @@ -70,6 +70,7 @@ struct tsnep_tx_entry {
>>   	union {
>>   		struct sk_buff *skb;
>>   		struct xdp_frame *xdpf;
>> +		bool zc;
>>   	};
>>   	size_t len;
>>   	DEFINE_DMA_UNMAP_ADDR(dma);
>> @@ -88,6 +89,7 @@ struct tsnep_tx {
>>   	int read;
>>   	u32 owner_counter;
>>   	int increment_owner_counter;
>> +	struct xsk_buff_pool *xsk_pool;
>>   
>>   	u32 packets;
>>   	u32 bytes;
>> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
>> index 13e5d4438082..de51d0cc8935 100644
>> --- a/drivers/net/ethernet/engleder/tsnep_main.c
>> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
>> @@ -54,6 +54,8 @@
>>   #define TSNEP_TX_TYPE_SKB_FRAG	BIT(1)
>>   #define TSNEP_TX_TYPE_XDP_TX	BIT(2)
>>   #define TSNEP_TX_TYPE_XDP_NDO	BIT(3)
>> +#define TSNEP_TX_TYPE_XDP	(TSNEP_TX_TYPE_XDP_TX | TSNEP_TX_TYPE_XDP_NDO)
>> +#define TSNEP_TX_TYPE_XSK	BIT(4)
>>   
>>   #define TSNEP_XDP_TX		BIT(0)
>>   #define TSNEP_XDP_REDIRECT	BIT(1)
>> @@ -322,13 +324,51 @@ static void tsnep_tx_init(struct tsnep_tx *tx)
>>   	tx->increment_owner_counter = TSNEP_RING_SIZE - 1;
>>   }
>>   
>> +static void tsnep_tx_enable(struct tsnep_tx *tx)
>> +{
>> +	struct netdev_queue *nq;
>> +
>> +	nq = netdev_get_tx_queue(tx->adapter->netdev, tx->queue_index);
>> +
>> +	local_bh_disable();
>> +	__netif_tx_lock(nq, smp_processor_id());
> 
> The above 2 statements could be replaced with:
> 
> 	__netif_tx_lock_bh()
> 
>> +	netif_tx_wake_queue(nq);
>> +	__netif_tx_unlock(nq);
>> +	local_bh_enable();
> 
> __netif_tx_unlock_bh()
> 
>> +}
>> +
>> +static void tsnep_tx_disable(struct tsnep_tx *tx, struct napi_struct *napi)
>> +{
>> +	struct netdev_queue *nq;
>> +	u32 val;
>> +
>> +	nq = netdev_get_tx_queue(tx->adapter->netdev, tx->queue_index);
>> +
>> +	local_bh_disable();
>> +	__netif_tx_lock(nq, smp_processor_id());
> 
> Same here.

Will be done.

Thank you!

Gerhard
