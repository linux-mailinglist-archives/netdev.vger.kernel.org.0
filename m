Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A03311FF9
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 21:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBFUjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 15:39:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBFUi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 15:38:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC64964E50;
        Sat,  6 Feb 2021 20:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612643897;
        bh=lJVF1na15MXvXp4vfqhcevq3+7rYDrdxdHqsEjilDww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=buVhRVkc4CrsYshIRd7am74DC+GjfFN9XpFzlc13QnZa87hE2q0WVE0dh6afIv76a
         1VvdF1d2mrxbQUMf6vhPVeMv4giufH8a1iiZZEbXaimvAx9rSGXGzaH5gihpMxPXwx
         v4G3scqaKHBKhU7OEYq5m5zbdnT3QWpMrjqBOphZkNviKHMEhSqCFPtLongciwiSCr
         XJ9cOMjPFdzGcndFuP2WeH4Sosh/rP9qv3IY9nrBOIDF1BFo7xTuiOy9puhdkwLCkH
         omMyUwtrVrh43W5+7ox298gDRnd3h+/5Wr+6cMNz7NkWHob6YIoqx+GIgc5tglwVne
         AOxrVDI21Xu2w==
Date:   Sat, 6 Feb 2021 12:38:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V4 net 5/5] net: stmmac: re-init rx buffers when mac
 resume back
Message-ID: <20210206123815.213b27ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210204112144.24163-6-qiangqing.zhang@nxp.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
        <20210204112144.24163-6-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Feb 2021 19:21:44 +0800 Joakim Zhang wrote:
> +err_reinit_rx_buffers:
> +	while (queue >= 0) {
> +		while (--i >= 0)
> +			stmmac_free_rx_buffer(priv, queue, i);
> +
> +		if (queue == 0)
> +			break;
> +
> +		i = priv->dma_rx_size;
> +		queue--;
> +	}

nit:

	do {
		...
	} while (queue-- > 0);

> +
> +	return -ENOMEM;

the caller ignores the return value anyway, so you make make this
function void.

I'm not sure why you recycle and reallocate every buffer. Isn't it
enough to reinitialize the descriptors with the buffers which are
already allocated?
