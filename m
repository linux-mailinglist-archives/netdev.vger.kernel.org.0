Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651D4A2A9F
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbfH2XTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:19:18 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36432 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbfH2XTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:19:18 -0400
Received: by mail-ed1-f67.google.com with SMTP id g24so5902560edu.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 16:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EHU3KOD8TsF4gVfzF1QNFPtd5Q+JUVWv57NDt5lvPI0=;
        b=O9Iu/kdjvuCw7hODpbrI5aEM58R+wlgQku3A/p43ALHLpqlnV0Wwd5naCyFyukVFiM
         tU0Rdd3+2662NCUtEC0sybLP9wfh58hkzw8zFEFsHw0oN1QVsQSgMwOUFcW1UHOP0V4m
         Aul3JgB14YdvS6cQJ/M90SVOZ4ymlIN3Mabr2zFInzyUuy5LNSNK+5usJ95T3nKVeX3r
         P6EL5T4V6pTDZjxjUuFoKkANsqCEZpbYUqcNvJGOO5jbpSocIFfQBlIDmG2pGY04kAto
         RspbiZnmavxU96IzdVtC6si72PFWK358lqYWvNVcsoaJ7de353nae5gu34BniHqDr4Hp
         cSnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EHU3KOD8TsF4gVfzF1QNFPtd5Q+JUVWv57NDt5lvPI0=;
        b=UJFzNrSdh5WO/2+RmblLyybQboYTmk4Xqe+HdiYm6gBQ+r3ViYIJXgfYmIBAIbpgx9
         V+Z2NTTBAl9cjjmGHBBZdXnalVjjDqPE/oAHYygF1yog9QEVKSApDshzLuvbKtjrJ8/+
         C5Cdwq+JfC3NNxqNotVglof61UhLeqkzOEGN5q+WHK/BctF3ctMBDhpltNHZ/iTNll5h
         9igQ1nBOBYZ8L9ceHvTQN0dEOGcm1Z1o3DwCMWWbmqBiwELi/VtZjj4f9r/Kpm0m0aCr
         TTQt+PGwDgiHKu0j+/KpnnoNb4c/hEPbbusBIsBItHjrLeUL2PRHzUO0hMr5JCmA+kVp
         AKjg==
X-Gm-Message-State: APjAAAVnepomxZc67sX8wfwTLSuKq12/7j0NbkHIR9YrJNWh9p0i+ZvR
        kCkOcF967Xq8HXONh5vBjA2wtg==
X-Google-Smtp-Source: APXvYqzGTrdWzw0495sEdS/9fRLQ3qtIvV8h8eXBRPu9S8lwtxFVRZAALU8Iu7Y72HIzbMNfsYcnNA==
X-Received: by 2002:a17:907:2158:: with SMTP id rk24mr7214893ejb.144.1567120756807;
        Thu, 29 Aug 2019 16:19:16 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id oq26sm556774ejb.66.2019.08.29.16.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 16:19:16 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:18:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 15/19] ionic: Add Tx and Rx handling
Message-ID: <20190829161852.1705d770@cakuba.netronome.com>
In-Reply-To: <20190829182720.68419-16-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-16-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:27:16 -0700, Shannon Nelson wrote:
> +netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
> +{
> +	u16 queue_index = skb_get_queue_mapping(skb);
> +	struct ionic_lif *lif = netdev_priv(netdev);
> +	struct ionic_queue *q;
> +	int ndescs;
> +	int err;
> +
> +	if (unlikely(!test_bit(IONIC_LIF_UP, lif->state))) {
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

You should stop the queue in advance, whenever you can't ensure that a
max size frame can be placed on the ring. Requeuing is very expensive
so modern drivers should try to never return NETDEV_TX_BUSY

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
> +	netif_stop_subqueue(netdev, queue_index);

This stopping of the queue is suspicious, if ionic_tx() fails there's
no guarantee the queue will ever be woken up, no?

> +	q->stop++;
> +	q->drop++;
> +	dev_kfree_skb(skb);
> +	return NETDEV_TX_OK;
> +}
