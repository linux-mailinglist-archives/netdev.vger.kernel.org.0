Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 497775C2C1
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfGASRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:17:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34378 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfGASRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:17:11 -0400
Received: by mail-pg1-f194.google.com with SMTP id p10so6424863pgn.1
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 11:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=s6cTv4Fcns8WcxyQiDlX4+JhmIQO0iIQDz7Uu7UjtO8=;
        b=tp7NIDC4oWPcb3AWvCxAQNEyGEl9cqsUc0eNj2W+oJYfp12Vbrmft6ZOwuM4sfgt+s
         BJmIgxwrx/tjH+0OyEVHMEvPg0s1D1RFvKmwC2qzdXJVZJ4ZVUDCTsifmUMNUQXzCvby
         1EFkYWtiuxOy1DyXAa05P9ydXacjjq6jaGiei1ETmN7+sCPqxFKEUo6R+iOQoYT/Et0q
         1ITfEEx64FTJIYL4NDUkxtWNhSynAT5ZOdsIB0sQFKri9pf9JH/VyvM8SPJ6wswWZows
         Q+j6tUyJByKXQHAby8btIhhmQG1QlEbkUHfKKNPqUTJxGvjxKUmIv/aQ0mkuplaIkAbb
         oI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=s6cTv4Fcns8WcxyQiDlX4+JhmIQO0iIQDz7Uu7UjtO8=;
        b=J3fGmzxNrY8e51NTvlk1dse5tarFUAoqew9DPYXNbBnRucdZdNz/CHLksgef2McH7o
         uB9XbMOu0oWMY4KsNCGmuOMB169ZDt/NHbgnjN3hLwBXuNqWiC+3xyJcLRODwTfJiZVt
         /AT0Sh82Z706IAM4UB020h7axxFFvJs2DSkEVB4KpmIUcIl2ivCppv1x1h/T3Vd9912o
         TeAfhKoQ9zoDsthxmJuCXYQgKdNQLFycDxFeJFkl9jFpZf9VHAGsRdNw4/oEzLtPRhPk
         SbqrY9v4jGEs3KTzXOMY6CDD9Fq0Yfa59MJ0iwEMJDMnJWaBP7Ua79n96/S+4NcKbFmd
         hv0w==
X-Gm-Message-State: APjAAAUri5VRLr4A5eMT+Daz0MsUBCIaDdBH+u8IOtYzoun4sBYbiKpO
        xN3AEidAo0SdQklv3YlK+ha2/RHbzCQ=
X-Google-Smtp-Source: APXvYqwqocFUrL7YRhg28eQzxxARRglwPGTQpZrjQRxlgLh6R5mC8MQWZs5rkMadf2zVyo+Ab2HW0g==
X-Received: by 2002:a63:f150:: with SMTP id o16mr26212817pgk.105.1562005031005;
        Mon, 01 Jul 2019 11:17:11 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id k14sm17047382pfg.6.2019.07.01.11.17.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 11:17:10 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 14/19] ionic: Add Tx and Rx handling
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190628213934.8810-1-snelson@pensando.io>
 <20190628213934.8810-15-snelson@pensando.io>
 <20190629115723.5ae777bc@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <b8fffe6f-e4c8-1412-1194-0ed65c27989f@pensando.io>
Date:   Mon, 1 Jul 2019 11:17:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190629115723.5ae777bc@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/19 11:57 AM, Jakub Kicinski wrote:
> On Fri, 28 Jun 2019 14:39:29 -0700, Shannon Nelson wrote:
>> +static int ionic_tx(struct queue *q, struct sk_buff *skb)
>> +{
>> +	struct tx_stats *stats = q_to_tx_stats(q);
>> +	int err;
>> +
>> +	if (skb->ip_summed == CHECKSUM_PARTIAL)
>> +		err = ionic_tx_calc_csum(q, skb);
>> +	else
>> +		err = ionic_tx_calc_no_csum(q, skb);
>> +	if (err)
>> +		return err;
>> +
>> +	err = ionic_tx_skb_frags(q, skb);
>> +	if (err)
>> +		return err;
>> +
>> +	skb_tx_timestamp(skb);
>> +	stats->pkts++;
>> +	stats->bytes += skb->len;
> Presumably this is 64bit so you should use
> u64_stats_update_begin()
> u64_stats_update_end()
> around it (and all other stats).

Since the device won't work in a 32-bit arch and I have the the Kconfig 
set to depend on 64BIT, I wasn't sure I needed to bother with the extra 
syntactic sugar.

>> +
>> +	ionic_txq_post(q, !netdev_xmit_more(), ionic_tx_clean, skb);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ionic_tx_descs_needed(struct queue *q, struct sk_buff *skb)
>> +{
>> +	struct tx_stats *stats = q_to_tx_stats(q);
>> +	int err;
>> +
>> +	/* If TSO, need roundup(skb->len/mss) descs */
>> +	if (skb_is_gso(skb))
>> +		return (skb->len / skb_shinfo(skb)->gso_size) + 1;
>> +
>> +	/* If non-TSO, just need 1 desc and nr_frags sg elems */
>> +	if (skb_shinfo(skb)->nr_frags <= IONIC_TX_MAX_SG_ELEMS)
>> +		return 1;
>> +
>> +	/* Too many frags, so linearize */
>> +	err = skb_linearize(skb);
>> +	if (err)
>> +		return err;
>> +
>> +	stats->linearize++;
>> +
>> +	/* Need 1 desc and zero sg elems */
>> +	return 1;
>> +}
>> +
>> +netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
>> +{
>> +	u16 queue_index = skb_get_queue_mapping(skb);
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct queue *q;
>> +	int ndescs;
>> +	int err;
>> +
>> +	if (unlikely(!test_bit(LIF_UP, lif->state))) {
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
> This should never really happen..

Couldn't we have an Rx interrupt and a call to ionic_tx_clean() in the 
middle of this?

>
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
> .. at this point if you can't guarantee fitting biggest possible frame
> in, you have to stop the ring.

Yep, that would work.

Thanks,
sln


