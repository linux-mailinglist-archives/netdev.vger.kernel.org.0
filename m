Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099CC56F1C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfFZQuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:50:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45471 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfFZQuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:50:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id z19so1468849pgl.12
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 09:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=uyTTe4dxNJUccBF9YKWKnp8Ah+nxCnoO0Hr24p7j9fU=;
        b=RTAYC0Qfh/c7B2BJ8WSv4udzta8KttmL1I2niImh4jQsaoY4poTDccRBmm/ig6Xnd+
         iLWYwLWV+FNAyYyMFeYehq9Bp4lHYkBKgvKwXzs4IvzCNT9yQSM8WIsPwJVLzvx5d5WL
         lUnOL8aRkGcCYjN4p6T7l55rE/1yFDv0Cx9Qu3RBAA28eWwaIN12fgVkzhwrTDd/MQd/
         jo4RCjkAFmw6GorYRWLKECIA9V3TB0rn/zwedFri50X+txpvDW8fWvMQswQlxIVYDhBs
         1lZQg5IvwhfDIiYU7lGbrRJpIOWT86/PNUb5M7+hfMk8Ezhplc89OYHBxj3IZEevNzlh
         Y7fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uyTTe4dxNJUccBF9YKWKnp8Ah+nxCnoO0Hr24p7j9fU=;
        b=jFyuSH21BUnedhjEXTE4HBIvBVDmIuRYNNi5hOlGky21QoyPDlbkH3oweb+5T38yXr
         vnHmw75M2akqAxY7Vq2Fjg+REAIr0Uj/r+opQ3d6dLq320cY/CzcqM+Ai8qLk2yvCkAL
         KBE6HfcnNH8UcIcZDhW9rim4FNnI6g6+gTWApho6sR2selfRO3hjcJyjcA9LKGjJ3I7X
         Xdrq74gPmhUB5GsqMZqib4Q6m/iUvsrLqbGHIqWfFTsWjQwRk+kjX5WZJzJ9hIKIXkDn
         pplEqoUS+gO8f8QlCuJXN/8eKVEG7zo+eKewqKPgkg7fzz5HaH/51Zp6e22yQNpWHjO+
         CJOg==
X-Gm-Message-State: APjAAAX6lA6rehrDPBgt507Q1GlgCpULjUyEdD+OGizx0wkoOzX+37KX
        RnqoKgm6pantOAGMi8c/JzWQv9rSqF4=
X-Google-Smtp-Source: APXvYqzEcOB8RcekWU1tE8hPi9heElcsRYvmvS4k2suL4Qp7N7hRsk8njFVPxAeEbqhgmoxZ5itigQ==
X-Received: by 2002:a17:90a:a397:: with SMTP id x23mr29196pjp.118.1561567799980;
        Wed, 26 Jun 2019 09:49:59 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j13sm16971486pfi.42.2019.06.26.09.49.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 09:49:59 -0700 (PDT)
Subject: Re: [PATCH net-next 14/18] ionic: Add Tx and Rx handling
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-15-snelson@pensando.io>
 <20190625170803.2a23650b@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <c5953da7-2388-810e-ff11-c254d4217821@pensando.io>
Date:   Wed, 26 Jun 2019 09:49:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625170803.2a23650b@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 5:08 PM, Jakub Kicinski wrote:
> On Thu, 20 Jun 2019 13:24:20 -0700, Shannon Nelson wrote:
>> Add both the Tx and Rx queue setup and handling.  The related
>> stats display come later.  Instead of using the generic napi
>> routines used by the slow-path command, the Tx and Rx paths
>> are simplified and inlined in one file in order to get better
>> compiler optimizations.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
>> index 5ebfaa320edf..6dfcada9e822 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
>> @@ -351,6 +351,54 @@ int ionic_debugfs_add_qcq(struct lif *lif, struct qcq *qcq)
>>   				    desc_blob);
>>   	}
>>   
>> +	if (qcq->flags & QCQ_F_TX_STATS) {
>> +		stats_dentry = debugfs_create_dir("tx_stats", q_dentry);
>> +		if (IS_ERR_OR_NULL(stats_dentry))
>> +			return PTR_ERR(stats_dentry);
>> +
>> +		debugfs_create_u64("dma_map_err", 0400, stats_dentry,
>> +				   &qcq->stats->tx.dma_map_err);
>> +		debugfs_create_u64("pkts", 0400, stats_dentry,
>> +				   &qcq->stats->tx.pkts);
>> +		debugfs_create_u64("bytes", 0400, stats_dentry,
>> +				   &qcq->stats->tx.bytes);
>> +		debugfs_create_u64("clean", 0400, stats_dentry,
>> +				   &qcq->stats->tx.clean);
>> +		debugfs_create_u64("linearize", 0400, stats_dentry,
>> +				   &qcq->stats->tx.linearize);
>> +		debugfs_create_u64("no_csum", 0400, stats_dentry,
>> +				   &qcq->stats->tx.no_csum);
>> +		debugfs_create_u64("csum", 0400, stats_dentry,
>> +				   &qcq->stats->tx.csum);
>> +		debugfs_create_u64("crc32_csum", 0400, stats_dentry,
>> +				   &qcq->stats->tx.crc32_csum);
>> +		debugfs_create_u64("tso", 0400, stats_dentry,
>> +				   &qcq->stats->tx.tso);
>> +		debugfs_create_u64("frags", 0400, stats_dentry,
>> +				   &qcq->stats->tx.frags);
> I wonder why debugfs over ethtool -S?

I believe this was from early engineering, before ethtool -S had been 
filled out.  I'll clean that up.

>
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
> nit: I think counting stats on completion may be a better idea,
>       otherwise when you can a full ring on stop your HW counters are
>       guaranteed to be different than SW counters.  Am I wrong?

You are not wrong, that is how many drivers handle it.  I like seeing 
how much the driver was given (ethtool -S) versus how much the HW 
actually pushed out (netstat -i or ip -s link show).  These numbers 
shouldn't be very often be very different, but it is interesting when 
they are.

>
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
> This doesn't look correct, are you sure you don't want
> skb_shinfo(skb)->gso_segs ?

That would probably work as well.

>
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
> Surely you stop TX before taking the queues down?

Yes, in ionic_lif_stop()


>
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
>> +	q->drop++;
>> +	dev_kfree_skb(skb);
>> +	return NETDEV_TX_OK;
>> +}

