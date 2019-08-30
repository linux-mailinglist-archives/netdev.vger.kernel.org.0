Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B120A412D
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 01:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfH3X5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 19:57:45 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34969 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbfH3X5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 19:57:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id n4so4303019pgv.2
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 16:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=vbfHQCbQOz6pXaMD1WdGmyVXpNXS38xujbQ+/0JQkQM=;
        b=WMKWfiuBvH5lMjSQEzDAk5wOOd4aGxdQtY+6NmQT/fB9RTqFr/PPXO+mUlgKs6w35v
         Cs9VGi6+VIsh2t02t6igMIdjhFRA0w0GFE6t1+xFQm8xF1x6vK8Lrmc55uQl/pb0N1sl
         T+cWiA+BCKSmOxJZZmoHBHLl0ujBAKVkv6PtDR43Mk1ybUwawEWu7/Ksi02zkBcXqCHR
         vw3+niyvhN1Tah3eMNBqwPK0BdTP4ZffNIvImkikbXtnQZnxqKwJSKnMCnfUbKBQ6sgC
         lxqDvtEu4pjh2Fn8n2BmS30OVSp8bANnS+sR25t80GpBAOAUgM6voLnc0P/GKqm9w6CN
         nOjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vbfHQCbQOz6pXaMD1WdGmyVXpNXS38xujbQ+/0JQkQM=;
        b=FrSbX9Ofw6afNigaaGNH/g0QkwvWIFBuNRyjH1cebQr8uWFK7DyiHvfIdfr/QWxuhe
         6q7JQ1SSbgHhS4aTJGQlgLLpHAKtSwnRCjAtyL3VQ2Ja3Qg8KNQyyDcnBpi3RfUbZ9nb
         yVGErU8t9HizUXLYtwHUxYFc0WOZMUFoGbGs/pG2MipyFe5IKXED6nlH0GVzUaFmZh5J
         yLNT7pv5PQ2MFRdpmSH9JxFO+od1trX9gYLw9NjHBccIG3eGpfi8pkS1iPHISq+raWvL
         Kfs/szDRqLy5eEmiS/79LbeTEvqw45DANIpy5hFXDYTvKsNDnxx2EWFbR2nA15Zo5HWe
         ZmPg==
X-Gm-Message-State: APjAAAX7CouJB4As0WOi+Qag63uuZkLUCqw6VGdbuJpYguwWsFnQxp8r
        dqazdIT6ckpkny8DRXDWAMWWfCWoF4A=
X-Google-Smtp-Source: APXvYqw0k5tlWlbqs7drBHLQwYkq9a+fObw8KXDFfk59hnyQgyajK/AzOvl/rwHX5+AmNXkqAX9KiA==
X-Received: by 2002:a63:c304:: with SMTP id c4mr14821840pgd.126.1567209464341;
        Fri, 30 Aug 2019 16:57:44 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t9sm6152686pgj.89.2019.08.30.16.57.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 16:57:43 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 15/19] ionic: Add Tx and Rx handling
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190829182720.68419-1-snelson@pensando.io>
 <20190829182720.68419-16-snelson@pensando.io>
 <20190829161852.1705d770@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <f1adfff7-82b8-9aca-1b17-706b7d45c4f3@pensando.io>
Date:   Fri, 30 Aug 2019 16:57:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829161852.1705d770@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/19 4:18 PM, Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 11:27:16 -0700, Shannon Nelson wrote:
>> +netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
>> +{
>> +	u16 queue_index = skb_get_queue_mapping(skb);
>> +	struct ionic_lif *lif = netdev_priv(netdev);
>> +	struct ionic_queue *q;
>> +	int ndescs;
>> +	int err;
>> +
>> +	if (unlikely(!test_bit(IONIC_LIF_UP, lif->state))) {
>> +		dev_kfree_skb(skb);
>> +		return NETDEV_TX_OK;
>> +	}
>> +
>> +	if (likely(lif_to_txqcq(lif, queue_index)))
>> +		q = lif_to_txq(lif, queue_index);
>> +	else
>> +		q = lif_to_txq(lif, 0);
>> +
>> +	ndescs = ionic_tx_descs_needed(q, skb);
>> +	if (ndescs < 0)
>> +		goto err_out_drop;
>> +
>> +	if (!ionic_q_has_space(q, ndescs)) {
> You should stop the queue in advance, whenever you can't ensure that a
> max size frame can be placed on the ring. Requeuing is very expensive
> so modern drivers should try to never return NETDEV_TX_BUSY

Yes, I see how that's been done in nfp - good idea.

>
>> +		netif_stop_subqueue(netdev, queue_index);
>> +		q->stop++;
>> +
>> +		/* Might race with ionic_tx_clean, check again */
>> +		smp_rmb();
>> +		if (ionic_q_has_space(q, ndescs)) {
>> +			netif_wake_subqueue(netdev, queue_index);
>> +			q->wake++;
>> +		} else {
>> +			return NETDEV_TX_BUSY;
>> +		}
>> +	}
>> +
>> +	if (skb_is_gso(skb))
>> +		err = ionic_tx_tso(q, skb);
>> +	else
>> +		err = ionic_tx(q, skb);
>> +
>> +	if (err)
>> +		goto err_out_drop;
>> +
>> +	return NETDEV_TX_OK;
>> +
>> +err_out_drop:
>> +	netif_stop_subqueue(netdev, queue_index);
> This stopping of the queue is suspicious, if ionic_tx() fails there's
> no guarantee the queue will ever be woken up, no?

Yes, that does look odd.  If there isn't a new descriptor with an skb in 
the queue, it won't get cleaned and reenabled in the Tx clean.

sln

>
>> +	q->stop++;
>> +	q->drop++;
>> +	dev_kfree_skb(skb);
>> +	return NETDEV_TX_OK;
>> +}

