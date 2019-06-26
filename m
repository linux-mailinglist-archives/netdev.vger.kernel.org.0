Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F6A55CD4
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 02:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfFZAIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 20:08:21 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37347 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbfFZAIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 20:08:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id y57so491987qtk.4
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 17:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Qis5gEnE/ikQtMblFgGubwLznY8SiR+X4kNlNsh9yu0=;
        b=XvMhEi4I5P34e9TwemSrMDDAxKR7CedAPxHNwf2ELlOxri96xUnpvdOfCYfDoc4sID
         p2FSuQjHCcfGrE3QiUBG9ocIQX3VvGnhxgcOVyuhmOrI+DaPkLEchiBwhX1ByfwPWz0Q
         /xDtrnMxD3Am4lkW5xD9EFsTWnfmtfayucCPy2veSDDKdwCsvO9jLOpH95prsBKAZXD6
         LDBYrxZGbX3KmgJeARFGG/rvg9H+hOkASnYXpTMLjwv5beBftU/omypW/xAWTlUDdx2G
         xs24ZlA45GV+1uapargIFOsDCGVR1izwBDkKxTowKgW7eLP1HiX5XT7UybRmJogOtlUk
         lD5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Qis5gEnE/ikQtMblFgGubwLznY8SiR+X4kNlNsh9yu0=;
        b=rbu5vOsa6b/wqDJZuX1ojaPamnz6Wy/75p8VFO1dam8V6FRRnEFSBt7VEDlN3olgKt
         gjy2fwymgAWkioU85iRcWQqEn6g6C7n5qhKNDb7AyKtsCs6B/KVqXGf5nH8IeUsxBrqR
         6dYJYWzV/RHiTkXftIthCy5Vol2nSpMKx3hbh0gpijg5db6YPj9sLig6HadO41sXIqbJ
         ltGFluzjvqAibkoEv1Lr+05rc7m/4OeMS6TcpiiiSZa70MHBvq4pvfsJdP6NUmsKiO6W
         bj/UoVl9LuAbfiLLyQEtHIPwDKaofm1A7T8Iw6nY3OSwa9GjEhf1m9/bVHyZFa1gCZ8b
         xa6g==
X-Gm-Message-State: APjAAAX9j8kaAW2RT7hhabw352ytxHPrwyJPoVbWOy2mGUIQHnFQPO0K
        DEHqoOjdyOHWtJIMkppdssNWPFJDORo=
X-Google-Smtp-Source: APXvYqxGoaAuIsBqYjcetMcho+QMtW6z98ZPw+GCJPEy5eU2qf03+7sdBhPLGoRcA9TmxfuWIxOl4w==
X-Received: by 2002:a0c:984a:: with SMTP id e10mr938958qvd.57.1561507699361;
        Tue, 25 Jun 2019 17:08:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t2sm9533958qth.33.2019.06.25.17.08.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 17:08:19 -0700 (PDT)
Date:   Tue, 25 Jun 2019 17:08:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 14/18] ionic: Add Tx and Rx handling
Message-ID: <20190625170803.2a23650b@cakuba.netronome.com>
In-Reply-To: <20190620202424.23215-15-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-15-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:24:20 -0700, Shannon Nelson wrote:
> Add both the Tx and Rx queue setup and handling.  The related
> stats display come later.  Instead of using the generic napi
> routines used by the slow-path command, the Tx and Rx paths
> are simplified and inlined in one file in order to get better
> compiler optimizations.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> index 5ebfaa320edf..6dfcada9e822 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> @@ -351,6 +351,54 @@ int ionic_debugfs_add_qcq(struct lif *lif, struct qcq *qcq)
>  				    desc_blob);
>  	}
>  
> +	if (qcq->flags & QCQ_F_TX_STATS) {
> +		stats_dentry = debugfs_create_dir("tx_stats", q_dentry);
> +		if (IS_ERR_OR_NULL(stats_dentry))
> +			return PTR_ERR(stats_dentry);
> +
> +		debugfs_create_u64("dma_map_err", 0400, stats_dentry,
> +				   &qcq->stats->tx.dma_map_err);
> +		debugfs_create_u64("pkts", 0400, stats_dentry,
> +				   &qcq->stats->tx.pkts);
> +		debugfs_create_u64("bytes", 0400, stats_dentry,
> +				   &qcq->stats->tx.bytes);
> +		debugfs_create_u64("clean", 0400, stats_dentry,
> +				   &qcq->stats->tx.clean);
> +		debugfs_create_u64("linearize", 0400, stats_dentry,
> +				   &qcq->stats->tx.linearize);
> +		debugfs_create_u64("no_csum", 0400, stats_dentry,
> +				   &qcq->stats->tx.no_csum);
> +		debugfs_create_u64("csum", 0400, stats_dentry,
> +				   &qcq->stats->tx.csum);
> +		debugfs_create_u64("crc32_csum", 0400, stats_dentry,
> +				   &qcq->stats->tx.crc32_csum);
> +		debugfs_create_u64("tso", 0400, stats_dentry,
> +				   &qcq->stats->tx.tso);
> +		debugfs_create_u64("frags", 0400, stats_dentry,
> +				   &qcq->stats->tx.frags);

I wonder why debugfs over ethtool -S?

> +static int ionic_tx(struct queue *q, struct sk_buff *skb)
> +{
> +	struct tx_stats *stats = q_to_tx_stats(q);
> +	int err;
> +
> +	if (skb->ip_summed == CHECKSUM_PARTIAL)
> +		err = ionic_tx_calc_csum(q, skb);
> +	else
> +		err = ionic_tx_calc_no_csum(q, skb);
> +	if (err)
> +		return err;
> +
> +	err = ionic_tx_skb_frags(q, skb);
> +	if (err)
> +		return err;
> +
> +	skb_tx_timestamp(skb);
> +	stats->pkts++;
> +	stats->bytes += skb->len;

nit: I think counting stats on completion may be a better idea,
     otherwise when you can a full ring on stop your HW counters are
     guaranteed to be different than SW counters.  Am I wrong?

> +	ionic_txq_post(q, !netdev_xmit_more(), ionic_tx_clean, skb);
> +
> +	return 0;
> +}
> +
> +static int ionic_tx_descs_needed(struct queue *q, struct sk_buff *skb)
> +{
> +	struct tx_stats *stats = q_to_tx_stats(q);
> +	int err;
> +
> +	/* If TSO, need roundup(skb->len/mss) descs */
> +	if (skb_is_gso(skb))
> +		return (skb->len / skb_shinfo(skb)->gso_size) + 1;

This doesn't look correct, are you sure you don't want
skb_shinfo(skb)->gso_segs ?

> +
> +	/* If non-TSO, just need 1 desc and nr_frags sg elems */
> +	if (skb_shinfo(skb)->nr_frags <= IONIC_TX_MAX_SG_ELEMS)
> +		return 1;
> +
> +	/* Too many frags, so linearize */
> +	err = skb_linearize(skb);
> +	if (err)
> +		return err;
> +
> +	stats->linearize++;
> +
> +	/* Need 1 desc and zero sg elems */
> +	return 1;
> +}
> +
> +netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
> +{
> +	u16 queue_index = skb_get_queue_mapping(skb);
> +	struct lif *lif = netdev_priv(netdev);
> +	struct queue *q;
> +	int ndescs;
> +	int err;
> +
> +	if (unlikely(!test_bit(LIF_UP, lif->state))) {
> +		dev_kfree_skb(skb);
> +		return NETDEV_TX_OK;
> +	}

Surely you stop TX before taking the queues down?

> +	if (likely(lif_to_txqcq(lif, queue_index)))
> +		q = lif_to_txq(lif, queue_index);
> +	else
> +		q = lif_to_txq(lif, 0);
> +
> +	ndescs = ionic_tx_descs_needed(q, skb);
> +	if (ndescs < 0)
> +		goto err_out_drop;
> +
> +	if (!ionic_q_has_space(q, ndescs)) {
> +		netif_stop_subqueue(netdev, queue_index);
> +		q->stop++;
> +
> +		/* Might race with ionic_tx_clean, check again */
> +		smp_rmb();
> +		if (ionic_q_has_space(q, ndescs)) {
> +			netif_wake_subqueue(netdev, queue_index);
> +			q->wake++;
> +		} else {
> +			return NETDEV_TX_BUSY;
> +		}
> +	}
> +
> +	if (skb_is_gso(skb))
> +		err = ionic_tx_tso(q, skb);
> +	else
> +		err = ionic_tx(q, skb);
> +
> +	if (err)
> +		goto err_out_drop;
> +
> +	return NETDEV_TX_OK;
> +
> +err_out_drop:
> +	q->drop++;
> +	dev_kfree_skb(skb);
> +	return NETDEV_TX_OK;
> +}
