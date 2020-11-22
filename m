Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8942BC2DD
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 01:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgKVAbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 19:31:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgKVAbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 19:31:31 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E12EC2078D;
        Sun, 22 Nov 2020 00:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606005097;
        bh=SxU0CbhcuLDJk1tLkPPZnHRso5M0Nu5lb2YNvpiCEQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lSmRWMVIMxz3yN6kGQ3HaD1kmzuV1pJnsX1AdLTDcl+esfDaOzQZKtJ5bq9bjZSVv
         3uAmyu8zV7L+V7Am9RW63QsB2hp4MZ1AZbfzg+4SIExph3Gk6v2s9txrT7RHdsGxNO
         4w0HCEVYaQu4cJ5a45c6trX7F96iWNJRdoD/WozE=
Date:   Sat, 21 Nov 2020 16:31:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH net-next v3 1/5] net: implement threaded-able napi poll
 loop support
Message-ID: <20201121163136.024d636c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118191009.3406652-2-weiwan@google.com>
References: <20201118191009.3406652-1-weiwan@google.com>
        <20201118191009.3406652-2-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 11:10:05 -0800 Wei Wang wrote:
> +int napi_set_threaded(struct napi_struct *n, bool threaded)
> +{
> +	ASSERT_RTNL();
> +
> +	if (n->dev->flags & IFF_UP)
> +		return -EBUSY;
> +
> +	if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
> +		return 0;
> +	if (threaded)
> +		set_bit(NAPI_STATE_THREADED, &n->state);
> +	else
> +		clear_bit(NAPI_STATE_THREADED, &n->state);

Do we really need the per-NAPI control here? Does anyone have use cases
where that makes sense? The user would be guessing which NAPI means
which queue and which bit, currently.

> +	/* if the device is initializing, nothing todo */
> +	if (test_bit(__LINK_STATE_START, &n->dev->state))
> +		return 0;
> +
> +	napi_thread_stop(n);
> +	napi_thread_start(n);
> +	return 0;
> +}
> +EXPORT_SYMBOL(napi_set_threaded);

Why was this exported? Do we still need that?

Please rejig the patches into a reviewable form. You can use the
Co-developed-by tag to give people credit on individual patches.
