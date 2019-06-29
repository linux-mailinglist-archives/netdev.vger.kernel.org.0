Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7145ACF1
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfF2S50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:57:26 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45841 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbfF2S50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 14:57:26 -0400
Received: by mail-pl1-f194.google.com with SMTP id bi6so5057032plb.12
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 11:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bRCRdRYrn423A1HBbi4MKLceCoMdoKMyRFxGDd/QBs0=;
        b=gNfy/qRD8H9pkZnLh6jzsbycEV78ckh4KJrit1C26DM/bQHyAAi5HtyGVTb46KdBAR
         Vm4y0R5u/qCnaajvPibA2rsyXoFeHN4boLKhWUagwNhVFwD5StGKb9NTxcOsFN7kCg2j
         sqnv6c2oFagEfDtzFNGT0TYNPN0n5P34P3LhXodEH2DCph8axRmDQxqMUQiUjbdKbPfO
         tCkoxZG+2Sg2usCVpomqsatGogJ5TIq0QpB+Oy0T9kOEE7sNcs8dwfK7dasCHM1JeXJR
         UycbLUAmbmb856XXNJppPc5fm+bpQgMalLeLbdlnXVQalCgpJJalDwW9TxwsOSzAyY7O
         48aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bRCRdRYrn423A1HBbi4MKLceCoMdoKMyRFxGDd/QBs0=;
        b=sgiSOMtlEUHMtqYMPzAkEC8jb2FDJwBxTIFSsifzDKDi+/Voy9bNUNb/kCFxaL/LKj
         8cfeHjTiNy8zYMvJ6SUbStR3RK7/F7PuDK2yt3DYTvu7en1oOStXMoFqSEf9fOLL10oO
         t6zVf2XUpNQYIQKJNca7/3CebF/bn2uF2cFa5KXoPCnmtLYlUpvPFR9tZ0I9NIIuzuzy
         RO1SvvPHVUjL8hM20rbR+hSKDLTeY/3GQvuwtnyuw359GPHY5ZlNsE3edF6R+jnSxdKl
         lzpp2mLaj230bZTFXWVzre1ZGwHhASJiLYSZyZuv81g+P9jRZIeoj6Cv7781Sq3M1YA3
         qImQ==
X-Gm-Message-State: APjAAAV5hQ4FRCugeBAe1WyJ0kpYg+YSiiiHJUTMsvBOwe+4pfwbtKDg
        sZnDKfHccJVFI4YgEGigtOqzpsdsrlk=
X-Google-Smtp-Source: APXvYqxi6eu6tSL8RK13SCWNdUTLiby/YvAeQYXmjmduLvKtvkICTfc/f6+PKPZ3pur/ngb0hcgrtQ==
X-Received: by 2002:a17:902:aa5:: with SMTP id 34mr19832178plp.166.1561834645206;
        Sat, 29 Jun 2019 11:57:25 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id br18sm10379932pjb.20.2019.06.29.11.57.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 29 Jun 2019 11:57:25 -0700 (PDT)
Date:   Sat, 29 Jun 2019 11:57:23 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 14/19] ionic: Add Tx and Rx handling
Message-ID: <20190629115723.5ae777bc@cakuba.netronome.com>
In-Reply-To: <20190628213934.8810-15-snelson@pensando.io>
References: <20190628213934.8810-1-snelson@pensando.io>
        <20190628213934.8810-15-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 14:39:29 -0700, Shannon Nelson wrote:
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

Presumably this is 64bit so you should use 
u64_stats_update_begin()
u64_stats_update_end() 
around it (and all other stats).

> +
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
> +
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

This should never really happen..

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

.. at this point if you can't guarantee fitting biggest possible frame
in, you have to stop the ring.

> +	return NETDEV_TX_OK;
> +
> +err_out_drop:
> +	q->drop++;
> +	dev_kfree_skb(skb);
> +	return NETDEV_TX_OK;
> +}

