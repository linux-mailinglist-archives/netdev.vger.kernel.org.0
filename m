Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F5A69C689
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjBTIXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjBTIXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:23:15 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3C810F8;
        Mon, 20 Feb 2023 00:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RBXd4It+F3YLLpPGZfjI9YJWGqK7uJekTapxFOvzrK4=; b=AQbAdNfqlVO+snABga5LMAIZ2v
        nlxYHStsFfjTMuhLL5e+vOm+fyr6k/S7mYp4giZpWGMue6csLuF/afRHPz4IMuaAl1Yd98cA/443Y
        mvdYEH/iyN2Ptc6KdN97aWVkoJ1ZsSbyRbZAiEXZWlE1GLJdrcrmZZu6IzvcGFTQeAHw=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pU1Rv-00AFUD-EB; Mon, 20 Feb 2023 09:23:03 +0100
Message-ID: <632b578a-10c7-a478-6e89-e44815fcec66@nbd.name>
Date:   Mon, 20 Feb 2023 09:23:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [RFC v3] net/core: add optional threading for backlog processing
Content-Language: en-US
To:     Hillf Danton <hdanton@sina.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20230220004132.2287-1-hdanton@sina.com>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20230220004132.2287-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.02.23 01:41, Hillf Danton wrote:
> On Sun, 19 Feb 2023 14:10:05 +0100 Felix Fietkau <nbd@nbd.name>
>>  /* Network device is going away, flush any packets still pending */
>>  static void flush_backlog(struct work_struct *work)
>>  {
>> +	unsigned int process_queue_empty;
>> +	bool threaded, flush_processq;
>>  	struct sk_buff *skb, *tmp;
>>  	struct softnet_data *sd;
>>  
>> @@ -5792,8 +5794,15 @@ static void flush_backlog(struct work_struct *work)
>>  			input_queue_head_incr(sd);
>>  		}
>>  	}
>> +
>> +	threaded = test_bit(NAPI_STATE_THREADED, &sd->backlog.state);
>> +	flush_processq = threaded &&
>> +			 !skb_queue_empty_lockless(&sd->process_queue);
>>  	rps_unlock_irq_enable(sd);
>>  
>> +	if (threaded)
>> +		goto out;
>> +
>>  	skb_queue_walk_safe(&sd->process_queue, skb, tmp) {
>>  		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
>>  			__skb_unlink(skb, &sd->process_queue);
>> @@ -5801,7 +5810,16 @@ static void flush_backlog(struct work_struct *work)
>>  			input_queue_head_incr(sd);
>>  		}
>>  	}
>> +
>> +out:
>>  	local_bh_enable();
>> +
>> +	while (flush_processq) {
>> +		msleep(1);
>> +		rps_lock_irq_disable(sd);
>> +		flush_processq = process_queue_empty == sd->process_queue_empty;
>> +		rps_unlock_irq_enable(sd);
>> +	}
>>  }
> 
> Have hard time guessing how this wait works given process_queue_empty
> not initialized. Is this random check intended?
Please check my initial reply to this patch. I forgot to amend the 
commit with the missing initialization lines before sending out the patch.

- Felix
