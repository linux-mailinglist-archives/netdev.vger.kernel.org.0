Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB4E664E1E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjAJViO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbjAJViI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:38:08 -0500
Received: from mx24lb.world4you.com (mx24lb.world4you.com [81.19.149.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3767C109C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q32ARSYGiX9uuPZe+2ZeD5erSL4GUWo01v1ru7ZfMzs=; b=IlB+wUkN5UGCIwJ93RVVcjgYt2
        WRhZlPt8xJCJhNko4wJO+K4wVHePYYYSgaeDJ8+B/LeszF/ll+mQ6KpfF2fdYVx6TbAoMDJklpLFj
        OwWSyRqFfL0wWNlExM6cN9v3HhvaBHJaTp0jDkyqoULR4VIZHU9Rjfeg3ZhOqC7JIHuM=;
Received: from [88.117.53.243] (helo=[10.0.0.160])
        by mx24lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pFMJp-0002O0-03; Tue, 10 Jan 2023 22:38:05 +0100
Message-ID: <3d0bc2ad-2c4a-527a-be09-b9746c87b2a8@engleder-embedded.com>
Date:   Tue, 10 Jan 2023 22:38:04 +0100
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
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <336b9f28bca980813310dd3007c862e9f738279e.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.01.23 18:33, Alexander H Duyck wrote:
> On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
>> Implement setup of BPF programs for XDP RX path with command
>> XDP_SETUP_PROG of ndo_bpf(). This is the final step for XDP RX path
>> support.
>>
>> tsnep_netdev_close() is called directly during BPF program setup. Add
>> netif_carrier_off() and netif_tx_stop_all_queues() calls to signal to
>> network stack that device is down. Otherwise network stack would
>> continue transmitting pakets.
>>
>> Return value of tsnep_netdev_open() is not checked during BPF program
>> setup like in other drivers. Forwarding the return value would result in
>> a bpf_prog_put() call in dev_xdp_install(), which would make removal of
>> BPF program necessary.
>>
>> If tsnep_netdev_open() fails during BPF program setup, then the network
>> stack would call tsnep_netdev_close() anyway. Thus, tsnep_netdev_close()
>> checks now if device is already down.
>>
>> Additionally remove $(tsnep-y) from $(tsnep-objs) because it is added
>> automatically.
>>
>> Test results with A53 1.2GHz:
>>
>> XDP_DROP (samples/bpf/xdp1)
>> proto 17:     883878 pkt/s
>>
>> XDP_TX (samples/bpf/xdp2)
>> proto 17:     255693 pkt/s
>>
>> XDP_REDIRECT (samples/bpf/xdpsock)
>>   sock0@eth2:0 rxdrop xdp-drv
>>                     pps            pkts           1.00
>> rx                 855,582        5,404,523
>> tx                 0              0
>>
>> XDP_REDIRECT (samples/bpf/xdp_redirect)
>> eth2->eth1         613,267 rx/s   0 err,drop/s   613,272 xmit/s
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/Makefile     |  2 +-
>>   drivers/net/ethernet/engleder/tsnep.h      |  6 +++++
>>   drivers/net/ethernet/engleder/tsnep_main.c | 25 ++++++++++++++++---
>>   drivers/net/ethernet/engleder/tsnep_xdp.c  | 29 ++++++++++++++++++++++
>>   4 files changed, 58 insertions(+), 4 deletions(-)
>>   create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c
>>
>>
> 
> <...>
> 
>> --- a/drivers/net/ethernet/engleder/tsnep_main.c
>> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
>> @@ -1373,7 +1373,7 @@ static void tsnep_free_irq(struct tsnep_queue *queue, bool first)
>>   	memset(queue->name, 0, sizeof(queue->name));
>>   }
>>   
>> -static int tsnep_netdev_open(struct net_device *netdev)
>> +int tsnep_netdev_open(struct net_device *netdev)
>>   {
>>   	struct tsnep_adapter *adapter = netdev_priv(netdev);
>>   	int tx_queue_index = 0;
>> @@ -1436,6 +1436,8 @@ static int tsnep_netdev_open(struct net_device *netdev)
>>   		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
>>   	}
>>   
>> +	netif_tx_start_all_queues(adapter->netdev);
>> +
>>   	clear_bit(__TSNEP_DOWN, &adapter->state);
>>   
>>   	return 0;
>> @@ -1457,12 +1459,16 @@ static int tsnep_netdev_open(struct net_device *netdev)
>>   	return retval;
>>   }
>>   
>> -static int tsnep_netdev_close(struct net_device *netdev)
>> +int tsnep_netdev_close(struct net_device *netdev)
>>   {
>>   	struct tsnep_adapter *adapter = netdev_priv(netdev);
>>   	int i;
>>   
>> -	set_bit(__TSNEP_DOWN, &adapter->state);
>> +	if (test_and_set_bit(__TSNEP_DOWN, &adapter->state))
>> +		return 0;
>> +
>> +	netif_carrier_off(netdev);
>> +	netif_tx_stop_all_queues(netdev);
>>   
> 
> As I called out earlier the __TSNEP_DOWN is just !IFF_UP so you don't
> need that bit.
> 
> The fact that netif_carrier_off is here also points out the fact that
> the code in the Tx path isn't needed regarding __TSNEP_DOWN and you can
> probably just check netif_carrier_ok if you need the check.

tsnep_netdev_close() is called directly during bpf prog setup (see
tsnep_xdp_setup_prog() in this commit). If the following
tsnep_netdev_open() call fails, then this flag signals that the device
is already down and nothing needs to be cleaned up if
tsnep_netdev_close() is called later (because IFF_UP is still set).

Thanks for the review!

Gerhard
