Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0922489E3B
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 18:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbiAJRW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 12:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238139AbiAJRW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 12:22:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4781C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 09:22:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D829B81722
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 17:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5026C36AE9;
        Mon, 10 Jan 2022 17:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641835346;
        bh=MFylPzwZ9SdvtDayeG73HIri2N4dRq2TUPUQ+I+U7Uo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ck7gc9LOfuP8kDyrNUTc3GuBHC1StOh+ixdCHDDm46CFv4S9qu15/gPPNAi71IkzA
         IQIjqyUFIkN5ES6uxYcBE0H7VelRVm5FmKD1QJ5SZ1BSX5PEhZDhopsgLQmhq/WCZO
         s5gpeqC1zM5Ar8zWtaf3JRgR/DknsDJz/BdLaQVi3rDbLL/rU8pfUq7iw1JmbOln3V
         EA4JWCXcaiYrZbjgN7G4HS4P4sIWTlEiDaDMhxAvFq4M+rC6JvclQJwTuQxK7JCmIG
         o+7rvbbbJP31aFYC5UoQi4EqNe1Oo/e7x2x8wE/4/PQQu+bYehDano84nDdUFwW3bl
         e3sJpoE6ljhzw==
Date:   Mon, 10 Jan 2022 09:22:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>,
        davem@davemloft.net, ecree.xilinx@gmail.com,
        netdev@vger.kernel.org, dinang@xilinx.com
Subject: Re: [PATCH net-next] sfc: The size of the RX recycle ring should be
 more flexible
Message-ID: <20220110092224.5a8ecddf@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110085820.zi73go4etyyrkixr@gmail.com>
References: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
        <20211120083107.z2cm7tkl2rsri2v7@gmail.com>
        <CACT4oufpvQ1Qzg3eC6wDu33_xBo5tVghr9G7Q=d-7F=bZbW4Vg@mail.gmail.com>
        <CACT4ouc=LNnrTdz37YEOAkm3G+02vrmJ5Sxk0JwKSMoCGnLs-w@mail.gmail.com>
        <20220102092207.rxz7kpjii4ermnfo@gmail.com>
        <20220110085820.zi73go4etyyrkixr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 08:58:21 +0000 Martin Habets wrote:
> +static unsigned int efx_ef10_recycle_ring_size(const struct efx_nic *efx)
> +{
> +	unsigned int ret;
> +
> +	/* There is no difference between PFs and VFs. The side is based on
> +	 * the maximum link speed of a given NIC.
> +	 */
> +	switch (efx->pci_dev->device & 0xfff) {
> +	case 0x0903:	/* Farmingdale can do up to 10G */
> +#ifdef CONFIG_PPC64
> +		ret = 4 * EFX_RECYCLE_RING_SIZE_10G;
> +#else
> +		ret = EFX_RECYCLE_RING_SIZE_10G;
> +#endif
> +		break;
> +	case 0x0923:	/* Greenport can do up to 40G */
> +	case 0x0a03:	/* Medford can do up to 40G */
> +#ifdef CONFIG_PPC64
> +		ret = 16 * EFX_RECYCLE_RING_SIZE_10G;
> +#else
> +		ret = 4 * EFX_RECYCLE_RING_SIZE_10G;
> +#endif
> +		break;
> +	default:	/* Medford2 can do up to 100G */
> +		ret = 10 * EFX_RECYCLE_RING_SIZE_10G;
> +	}
> +	return ret;
> +}

Why not factor out the 4x scaling for powerpc outside of the switch?

The callback could return the scaling factor but failing that:

static unsigned int efx_ef10_recycle_ring_size(const struct efx_nic *efx)
{
	unsigned int ret = EFX_RECYCLE_RING_SIZE_10G;;

	/* There is no difference between PFs and VFs. The side is based on
	 * the maximum link speed of a given NIC.
	 */
	switch (efx->pci_dev->device & 0xfff) {
	case 0x0903:	/* Farmingdale can do up to 10G */
		break;
	case 0x0923:	/* Greenport can do up to 40G */
	case 0x0a03:	/* Medford can do up to 40G */
		ret *= 4;
		break;
	default:	/* Medford2 can do up to 100G */
		ret *= 10;
	}

	if (IS_ENABLED(CONFIG_PPC64))
		ret *= 4;

	return ret;
}

Other than that - net-next is closed, please switch to RFC postings
until it opens back up once 5.17-rc1 is cut. Thanks!
