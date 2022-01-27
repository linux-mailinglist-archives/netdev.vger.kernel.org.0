Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B7549DEC7
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbiA0KKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiA0KKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24669C061714;
        Thu, 27 Jan 2022 02:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C2866106D;
        Thu, 27 Jan 2022 10:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2788C340E4;
        Thu, 27 Jan 2022 10:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643278215;
        bh=Ap7drMT4Q1FIZCM2H6MmACkCe9woB02SORB5H3rkUkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MbS4kQE5WQTvD43bPMFyF9w1teRK6VXYJaZlx4BeSciOHM+79VblvvYcSZPdioBTD
         1TvCxaBZ9wnOcH1p8G/FuzGuPWHTQlnBzl4peAn3gB/4nQRIfiZlS5RDfoMsNRx4o4
         1ZVjgtWfWnvnztsbLBNCrq4nuupb5mNMR5b5O48g=
Date:   Thu, 27 Jan 2022 11:10:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     Mario.Limonciello@amd.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Message-ID: <YfJvhItQAmRJrool@kroah.com>
References: <20220127100109.12979-1-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127100109.12979-1-aaron.ma@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 06:01:09PM +0800, Aaron Ma wrote:
> RTL8153-BL is used in Lenovo Thunderbolt4 dock.
> Add the support of MAC passthrough.
> This is ported from Realtek Outbox driver r8152.53.56-2.15.0.
> 
> There are 2 kinds of rules for MAC passthrough of Lenovo products,
> 1st USB vendor ID belongs to Lenovo, 2nd the chip of RTL8153-BL
> is dedicated for Lenovo. Check the ocp data first then set ACPI object
> names.
> 
> Suggested-by: Hayes Wang <hayeswang@realtek.com>
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 44 ++++++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index ee41088c5251..df997b330ee4 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -718,6 +718,7 @@ enum spd_duplex {
>  #define AD_MASK			0xfee0
>  #define BND_MASK		0x0004
>  #define BD_MASK			0x0001
> +#define BL_MASK                 BIT(3)

No tab?  :(

