Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702BA2914E1
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 00:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439670AbgJQWL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 18:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439622AbgJQWL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 18:11:56 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9835FC061755
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 15:11:56 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r10so3616659pgb.10
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 15:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5DNDeVGnBh5RPciuLCLQ8h2JxKI2lKmnzYplYjlBqzI=;
        b=DVkicNfALqjmuPg6xc4mZs3jgrwTgZLaQcbpHgmVwklaX+Tw5vTEJb2Q7oGTxFj9Rh
         /b4wFNNm3uDRw6Oz3UaRqjvd8cQ+foPOG9nXlsQZEDYunxOLlz8Zc7JI5Rys3rpxV55A
         D7Rq22oeRVL7dawN0fKPBnkWqtE/jx347SdOUVp+XwHSfwGRxwpQclSE8RfFztag0Iam
         BhHEYi4WxIIQ4LIo9olluEJ9DJv2mnn9aUySNPtTDVo846E80pIFHS5v92mYnMTvQnOq
         +WegJDxfGIvJpdN4QMawGwoGL7+d4HMpg4Y5Cd/x06ewNku1gsggMyEP9wIniO1LJhGX
         H6zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5DNDeVGnBh5RPciuLCLQ8h2JxKI2lKmnzYplYjlBqzI=;
        b=d3tTsMl0PLOso2EH9UxOq1OE0kxIBCXA56prhrd6LkIvpPHK4KZjWV0jx7U9n8J3s/
         xMu0BANjPfI1EtPewUo+iqLxhDLMv8Ppvnekzk+tAo8u4/3mm2JGHp7oHrzhmgoYzgNr
         FHjWZggRfIYFumCUI6czuppTQdIqZOlZgZCLmEC+WMj8qAxvNstB+veLhHPdSqYVKYw8
         Yv0XTQZpiWRirewfS78IvdyuEe4I9Fe6wYk0YQ4u9YH4+3/SAfeD6Lgv3Wud2jU9Z81v
         R4h9YJDpCkly5F2l84l/aS7vYFsqBq0fL8G4kBiHLDgshqmQNHSI8EkOQaJn9ZEqIhQS
         9klQ==
X-Gm-Message-State: AOAM5331OWtk38LkqZf+IT7abs4t51WDV/TvAy6+cpD0ra7CJfRXmeV/
        oPTr/X7yH2paU+o948GBcWg=
X-Google-Smtp-Source: ABdhPJyZJNDuI0gGhy3csocJopP5PqLrhRUKoQwPeGhP5aq+TKrDe7mucuJurynx0TKMjqDp1X139g==
X-Received: by 2002:a63:5b60:: with SMTP id l32mr8820774pgm.134.1602972715952;
        Sat, 17 Oct 2020 15:11:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s186sm7373488pfc.171.2020.10.17.15.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 15:11:54 -0700 (PDT)
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-3-vladimir.oltean@nxp.com>
 <20201017220104.wejlxn2a4seefkfv@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d2578c4b-7da6-e25d-5dde-5ec89b82aeef@gmail.com>
Date:   Sat, 17 Oct 2020 15:11:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201017220104.wejlxn2a4seefkfv@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/17/2020 3:01 PM, Vladimir Oltean wrote:
> On Sun, Oct 18, 2020 at 12:36:00AM +0300, Vladimir Oltean wrote:
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index d4326940233c..790f5c8deb13 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -548,6 +548,36 @@ netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev)
>>   }
>>   EXPORT_SYMBOL_GPL(dsa_enqueue_skb);
>>   
>> +static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)
> 
> I forgot to actually pad the skb here, if it's a tail tagger, silly me.
> The following changes should do the trick.
> 
>> +{
>> +	struct net_device *master = dsa_slave_to_master(dev);
> 
> The addition of master->needed_headroom and master->needed_tailroom used
> to be here, that's why this unused variable is here.
> 
>> +	struct dsa_slave_priv *p = netdev_priv(dev);
>> +	struct dsa_slave_stats *e;
>> +	int headroom, tailroom;
> 	int padlen = 0, err;
>> +
>> +	headroom = dev->needed_headroom;
>> +	tailroom = dev->needed_tailroom;
>> +	/* For tail taggers, we need to pad short frames ourselves, to ensure
>> +	 * that the tail tag does not fail at its role of being at the end of
>> +	 * the packet, once the master interface pads the frame.
>> +	 */
>> +	if (unlikely(tailroom && skb->len < ETH_ZLEN))
>> +		tailroom += ETH_ZLEN - skb->len;
> 		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 		padlen = ETH_ZLEN - skb->len;
> 	tailroom += padlen;
>> +
>> +	if (likely(skb_headroom(skb) >= headroom &&
>> +		   skb_tailroom(skb) >= tailroom) &&
>> +		   !skb_cloned(skb))
>> +		/* No reallocation needed, yay! */
>> +		return 0;
>> +
>> +	e = this_cpu_ptr(p->extra_stats);
>> +	u64_stats_update_begin(&e->syncp);
>> +	e->tx_reallocs++;
>> +	u64_stats_update_end(&e->syncp);
>> +
>> +	return pskb_expand_head(skb, headroom, tailroom, GFP_ATOMIC);
> 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 	err = pskb_expand_head(skb, headroom, tailroom, GFP_ATOMIC);
> 	if (err < 0 || !padlen)
> 		return err;
> 
> 	return __skb_put_padto(skb, padlen, false);
>> +}
>> +
>>   static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
>>   {
>>   	struct dsa_slave_priv *p = netdev_priv(dev);
>> @@ -567,6 +597,11 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
>>   	 */
>>   	dsa_skb_tx_timestamp(p, skb);
>>   
>> +	if (dsa_realloc_skb(skb, dev)) {
>> +		kfree_skb(skb);
>> +		return NETDEV_TX_OK;
>> +	}
>> +
>>   	/* Transmit function may have to reallocate the original SKB,
>>   	 * in which case it must have freed it. Only free it here on error.
>>   	 */
>> @@ -1802,6 +1837,14 @@ int dsa_slave_create(struct dsa_port *port)
>>   	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
>>   	if (ds->ops->port_max_mtu)
>>   		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
>> +	/* Try to save one extra realloc later in the TX path (in the master)
>> +	 * by also inheriting the master's needed headroom and tailroom.
>> +	 * The 8021q driver also does this.
>> +	 */
> 
> Also, this comment is bogus given the current code. It should be removed
> from here, and...
> 
>> +	if (cpu_dp->tag_ops->tail_tag)
>> +		slave_dev->needed_tailroom = cpu_dp->tag_ops->overhead;
>> +	else
>> +		slave_dev->needed_headroom = cpu_dp->tag_ops->overhead;
> ...put here, along with:
> 	slave_dev->needed_headroom += master->needed_headroom;
> 	slave_dev->needed_tailroom += master->needed_tailroom;

Not positive you need that because you may be account for more head or 
tail room than necessary.

For instance with tag_brcm.c and systemport.c we need 4 bytes of head 
room for the Broadcom tag and an additional 8 bytes for pushing the 
transmit status block descriptor in front of the Ethernet frame about to 
be transmitted. These additional 8 bytes are a requirement of the DSA 
master here and exist regardless of DSA being used, but we should not be 
propagating them to the DSA slave.
-- 
Florian
