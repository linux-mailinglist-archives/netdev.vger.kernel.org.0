Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09861230F2D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731347AbgG1Q0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731192AbgG1Q0Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:26:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5655E20663;
        Tue, 28 Jul 2020 16:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595953575;
        bh=8e/IpfH0tEGQw4eRgZPxqGN1xvDTdZgV9fdlNOZ6og8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V+tGZn7u7iHhNApaehm+Ii1gc1McMh/MHLoyFFsy9dWvgCCd15BxjY9uNB9TiDeSP
         Ly4qXDCEvsM8EW1V7Xaz1wq0jzbcYeFm84ur6UnndE3m6kBc4gamvIYj7tNKAjbdtS
         IwDw05oGkUlZB2La5VmWtEZkkSs8rhv8JNoUEQZM=
Date:   Tue, 28 Jul 2020 18:26:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH v2 10/21] netgpu: add network/gpu/host dma module
Message-ID: <20200728162608.GA4181352@kroah.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200727224444.2987641-11-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727224444.2987641-11-jonathan.lemon@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:44:33PM -0700, Jonathan Lemon wrote:
> From: Jonathan Lemon <bsd@fb.com>
> 
> Netgpu provides a data path for zero-copy sends and receives
> without having the host CPU touch the data.  Protocol processing
> is done on the host CPU, while data is DMA'd to and from DMA
> mapped memory areas.  The initial code provides transfers between
> (mlx5 / host memory) and (mlx5 / nvidia GPU memory).
> 
> The use case for this module are GPUs used for machine learning,
> which are located near the NICs, and have a high bandwidth PCI
> connection between the GPU/NIC.

Do we have such a GPU driver in the kernel today?  We can't add new
apis/interfaces for no in-kernel users, as you well know.

There's lots of crazyness in this patch, but this is just really odd:

> +#if IS_MODULE(CONFIG_NETGPU)
> +#define MAYBE_EXPORT_SYMBOL(s)
> +#else
> +#define MAYBE_EXPORT_SYMBOL(s)	EXPORT_SYMBOL(s)
> +#endif

Why is that needed at all?  Why does no one else in the kernel need such
a thing?

And why EXPORT_SYMBOL() and not EXPORT_SYMBOL_GPL() (I have to ask).

thanks,

greg k-h
