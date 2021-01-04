Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018702E9FC1
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 23:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbhADWBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 17:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbhADWBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 17:01:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 827552225E;
        Mon,  4 Jan 2021 22:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609797660;
        bh=TH62U7AAYl3N+Fpl/0Ilxx+FrsIwbFee0Efw7bO6Z8Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rZBxi2Tr5SufDqER3yBoGKYALmEwZ6ZciiLcmJOWbbM4HsNXePO1isKKBp3rzdEVT
         vch3kwYvWTRbHA+qZfqJqF/J5wRVNB4E7z/egEPH8Dcpj4QDN3nonmshKQQ8N+z7Q2
         TEPwTUG4Swjg77fTer1PIEscPmwuFN2MsAs2vPLKYd5AUIc6Zyevq2DN0s4wP8d0gc
         JHNDz1K+tAkSM/SnaN9/a24bzKSeCrmVEnwbZZgWStsCw9Fyme0md+o2EzqJ5xSysd
         yd8HeS7FGJIKoQjLplN30HvrAk8YmoC/8HfCcC5utcBWM+wbl998l8uQx0LuTCc0Wn
         E6PbwKops1ONA==
Date:   Mon, 4 Jan 2021 14:00:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jouni =?UTF-8?B?U2VwcMOkbmVu?= <jks@iki.fi>
Cc:     Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Enrico Mioso <mrkiko.rs@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net,stable v2] net: cdc_ncm: correct overhead in
 delayed_ndp_size
Message-ID: <20210104140058.34cb4111@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210103202309.1201-1-jks@iki.fi>
References: <20210103143602.95343-1-jks@iki.fi>
        <20210103202309.1201-1-jks@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  3 Jan 2021 22:23:09 +0200 Jouni Sepp=C3=A4nen wrote:
>  	if (ctx->drvflags & CDC_NCM_FLAG_NDP_TO_END)
> -		delayed_ndp_size =3D ALIGN(ctx->max_ndp_size, ctx->tx_ndp_modulus);
> +		delayed_ndp_size =3D ctx->max_ndp_size +
> +			max((u32)ctx->tx_ndp_modulus,
> +			    (u32)ctx->tx_modulus + ctx->tx_remainder) - 1;

Let's use max_t, like Bjorn suggested.
