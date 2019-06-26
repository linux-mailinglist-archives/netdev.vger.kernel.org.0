Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DE955CDE
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 02:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFZAU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 20:20:59 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42135 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFZAU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 20:20:59 -0400
Received: by mail-qt1-f193.google.com with SMTP id s15so486111qtk.9
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 17:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=T7PhJFhETrL5enCRjIgkk5L+XgVX997LdFhJ+SAwQeQ=;
        b=pmIldHIRKjfJ9AI+fWNfU0jV+4IIlU0iCSA9RtVlgfUxEQoNRyaXUDCR5hk9cxACaj
         MfmA8p5GUO0Y4C3iPnJjAChlCzOsrxqfacuCgQk8bD8xIm+42viaIcLircALFz5RDnXr
         x2s3qxVkQh6hQ6JqWrdZIGB2SqukrN8u9TZdDVXqaz6qEI4ZtklihrSeZ6FhHQdpj5nl
         +u2SkquVDgYbfERS4A3rsmHY1wyyV28vvL6g2TJZ12k69cpOZbOP9qnjA5NN/SEqXH+M
         cp+CZ4uREQY3PUThN+x3yrGZC0wx4sGFw74KUrIDwDTxQkyi/JOg1YgzKUIEUOxu1MxK
         Jf7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=T7PhJFhETrL5enCRjIgkk5L+XgVX997LdFhJ+SAwQeQ=;
        b=JlRjCYmEHb1JLPdE7eN/Qu4RPkQ9FP8MgOVSWXWJ9fe03fjYd8WtXeF2k836i1nTNK
         WpqANvkK2riupFObz6X8sXLKOHXrxJ4qqN7gaMhgvLDg7PCn7ESi32sHIZj69CuHzX/B
         d3p1NmoUnspPlxaX2KJeyhoeaH4Ypq6fhPkE769nGbM7+R2p58xdpQHroDxN4Wg3Lb/s
         E7jN0EPdtXyQCqoCwkkMPQGadrXrWDZm+OF2SRaooQEbwVk+4AtayrSItBOM1B9SWCrR
         2IRAQGXLOi8JES/VvNdpPiYjlZTjX35+2KYzN5lv8k4Qqbb/kBBeN0h2xCw2GS2YyeeA
         DCdw==
X-Gm-Message-State: APjAAAWA33AiJhG7FSu7mLFLTvwwcc/2JmjfCM4MByklsxTgUCBwiBoz
        ES9qLhfqJlLZY+wIujDh6+IdKA==
X-Google-Smtp-Source: APXvYqysC4jmXEmd8oXM8+ehdXgIDGx49yZSA1ko14Mf1B+6/DpbNgeUxpaYHCAHrT4ssD61Z+yQJw==
X-Received: by 2002:aed:2241:: with SMTP id o1mr1083972qtc.233.1561508458076;
        Tue, 25 Jun 2019 17:20:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q9sm7100362qtn.86.2019.06.25.17.20.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 17:20:57 -0700 (PDT)
Date:   Tue, 25 Jun 2019 17:20:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 17/18] ionic: Add RSS support
Message-ID: <20190625172054.6a9d22dc@cakuba.netronome.com>
In-Reply-To: <20190620202424.23215-18-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-18-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:24:23 -0700, Shannon Nelson wrote:
> +static int ionic_lif_rss_init(struct lif *lif)
> +{
> +	static const u8 toeplitz_symmetric_key[] = {
> +		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
> +		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
> +		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
> +		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
> +		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
> +	};

netdev_rss_key_fill()

> +	unsigned int i, tbl_sz;
> +
> +	lif->rss_types = IONIC_RSS_TYPE_IPV4     |
> +			 IONIC_RSS_TYPE_IPV4_TCP |
> +			 IONIC_RSS_TYPE_IPV4_UDP |
> +			 IONIC_RSS_TYPE_IPV6     |
> +			 IONIC_RSS_TYPE_IPV6_TCP |
> +			 IONIC_RSS_TYPE_IPV6_UDP;
> +
> +	/* Fill indirection table with 'default' values */
> +	tbl_sz = le16_to_cpu(lif->ionic->ident.lif.eth.rss_ind_tbl_sz);
> +	for (i = 0; i < tbl_sz; i++)
> +		lif->rss_ind_tbl[i] = i % lif->nxqs;

ethtool_rxfh_indir_default()

> +	return ionic_lif_rss_config(lif, lif->rss_types,
> +				    toeplitz_symmetric_key, NULL);
> +}
