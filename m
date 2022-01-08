Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D137B4880ED
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 03:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiAHCer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 21:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiAHCeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 21:34:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE09C061574;
        Fri,  7 Jan 2022 18:34:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE4B7B82760;
        Sat,  8 Jan 2022 02:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280E8C36AE5;
        Sat,  8 Jan 2022 02:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641609282;
        bh=DNoFnlc+g6I3Shbp/QTo9YTbp0+UgI4aMPPMxfkn6iE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n3O8pQ2+q2yPGJRyqHXei84T3NkRrGVTuS+zCpURdv7xpHn9v+8FhREcgRI+uXaWX
         c01kmFE60/7X/beMKjTDVCPxpGK5/CV7lSMw6T1IEAqcbYt+X/XNVDerwwwJmaKoDs
         nL4KLhDgLjKpJNk37+gY3YvnlHHz3UQVt7Q7t5K97NcTsBymK9P8OJcCH5tOOVgz5e
         4kHRK9nLx3BIwYSlUAJwhDJNgFcFoZfpRKX6aGTwKKJyS9GQK+W7agRius8IpBGTu9
         QUQqkECzgMDa8gcy9f9OeaRWPPivdg2glFsSMB5bPSlCi4N9tY9vu/JHK2Kuli8IEA
         zzgeSgSKxk43w==
Date:   Fri, 7 Jan 2022 18:34:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     conleylee@foxmail.com, davem@davemloft.net, mripard@kernel.org,
        wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
Message-ID: <20220107183441.484b0de5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <202201071532.57A08030@keescook>
References: <20211228164817.1297c1c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <tencent_DE05ADA53D5B084D4605BE6CB11E49EF7408@qq.com>
        <202201071532.57A08030@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jan 2022 15:34:18 -0800 Kees Cook wrote:
> On Wed, Dec 29, 2021 at 09:43:51AM +0800, conleylee@foxmail.com wrote:
> > From: Conley Lee <conleylee@foxmail.com>
> >
> > Thanks for your review. Here is the new version for this patch.
> >
> > This patch adds support for the emac rx dma present on sun4i. The emac
> > is able to move packets from rx fifo to RAM by using dma.
> >
> > Change since v4.
> >   - rename sbk field to skb
> >   - rename alloc_emac_dma_req to emac_alloc_dma_req
> >   - using kzalloc(..., GPF_ATOMIC) in interrupt context to avoid
> >     sleeping
> >   - retry by using emac_inblk_32bit when emac_dma_inblk_32bit fails
> >   - fix some code style issues
> >
> > Change since v5.
> >   - fix some code style issue
> >
> > Signed-off-by: Conley Lee <conleylee@foxmail.com>
>
> This is causing build failures:
> 
> $ make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 allmodconfig
> $ make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 -j... -k -s
> drivers/net/ethernet/allwinner/sun4i-emac.c: In function 'emac_configure_dma':
> drivers/net/ethernet/allwinner/sun4i-emac.c:922:60: error: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'resource_size_t' {aka 'long long unsigned int'} [-Werror=format=]
>   922 |         netdev_info(ndev, "get io resource from device: 0x%x, size = %u\n",
>       |                                                           ~^
>       |                                                            |                                      |                                                            unsigned int
>       |                                                           %llx
>   923 |                     regs->start, resource_size(regs));
>       |                     ~~~~~~~~~~~
>       |                         |
>       |                         resource_size_t {aka long long unsigned int}
> drivers/net/ethernet/allwinner/sun4i-emac.c:922:71: error: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' {aka 'long long unsigned int'} [-Werror=format=]
>   922 |         netdev_info(ndev, "get io resource from device: 0x%x, size = %u\n",
>       |                                                                      ~^
>       |                                                                       |
>       |                                                                       unsigned int
>       |                                                                      %llu
>   923 |                     regs->start, resource_size(regs));
>       |                                  ~~~~~~~~~~~~~~~~~~~
>       |                                  |
>       |                                  resource_size_t {aka long long unsigned int}
> 

Ugh, I saw this and somehow it didn't enter my brain that it's new.
%pa right? Let me test that and send a fix before we close net-next..
