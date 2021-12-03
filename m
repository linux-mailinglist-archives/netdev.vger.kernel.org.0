Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5D8466F4E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 02:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243010AbhLCBzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 20:55:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51474 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbhLCBzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 20:55:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD91662905;
        Fri,  3 Dec 2021 01:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38D6C00446;
        Fri,  3 Dec 2021 01:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638496296;
        bh=8c4aq1AdxZxDjQt/G6uY3qiBn94axpo7U7Hv78cF/qo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L4e0sxUPh5LFvxb1DnC5Z9J+c1ilHchyonJW3i9ecYCK3hkNIxEvSDh4/yq8R3dgP
         tvq8nHtt1dJkoJ2Qz36dgFmSsIN/zT9q4FBkr4bZAcjNEHOaKDOEFwmBTwIXGI4lFU
         R7/K26jGw9iprRmpgunkn0FFbyAGe3Af4tCVRJRHYlTdr7PlAZnWOp7YRgTtV/6m3g
         1FYdQiHF8cNOsp0IjajBMS3dnltPHSypD6ihvEdYpJqdQs+2WNm9BQxw8350u963cK
         rXjc5avgWyCzzb6ex0TdLgQ+h3IDil6grmbfW+AuDTwlc96vGACOM5XTtrYP/OJc6U
         JTSj9xC+BHazg==
Date:   Thu, 2 Dec 2021 17:51:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, bjorn@mork.no
Subject: Re: [PATCH 1/1] net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset
 or zero
Message-ID: <20211202175134.5b463e18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211202143437.1411410-1-lee.jones@linaro.org>
References: <20211202143437.1411410-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Dec 2021 14:34:37 +0000 Lee Jones wrote:
> Currently, due to the sequential use of min_t() and clamp_t() macros,
> in cdc_ncm_check_tx_max(), if dwNtbOutMaxSize is not set, the logic
> sets tx_max to 0.  This is then used to allocate the data area of the
> SKB requested later in cdc_ncm_fill_tx_frame().
> 
> This does not cause an issue presently because when memory is
> allocated during initialisation phase of SKB creation, more memory
> (512b) is allocated than is required for the SKB headers alone (320b),
> leaving some space (512b - 320b = 192b) for CDC data (172b).
> 
> However, if more elements (for example 3 x u64 = [24b]) were added to
> one of the SKB header structs, say 'struct skb_shared_info',
> increasing its original size (320b [320b aligned]) to something larger
> (344b [384b aligned]), then suddenly the CDC data (172b) no longer
> fits in the spare SKB data area (512b - 384b = 128b).
> 
> Consequently the SKB bounds checking semantics fails and panics:
> 
>   skbuff: skb_over_panic: text:ffffffff830a5b5f len:184 put:172   \
>      head:ffff888119227c00 data:ffff888119227c00 tail:0xb8 end:0x80 dev:<NULL>
> 
>   ------------[ cut here ]------------
>   kernel BUG at net/core/skbuff.c:110!
>   RIP: 0010:skb_panic+0x14f/0x160 net/core/skbuff.c:106
>   <snip>
>   Call Trace:
>    <IRQ>
>    skb_over_panic+0x2c/0x30 net/core/skbuff.c:115
>    skb_put+0x205/0x210 net/core/skbuff.c:1877
>    skb_put_zero include/linux/skbuff.h:2270 [inline]
>    cdc_ncm_ndp16 drivers/net/usb/cdc_ncm.c:1116 [inline]
>    cdc_ncm_fill_tx_frame+0x127f/0x3d50 drivers/net/usb/cdc_ncm.c:1293
>    cdc_ncm_tx_fixup+0x98/0xf0 drivers/net/usb/cdc_ncm.c:1514
> 
> By overriding the max value with the default CDC_NCM_NTB_MAX_SIZE_TX
> when not offered through the system provided params, we ensure enough
> data space is allocated to handle the CDC data, meaning no crash will
> occur.
> 
> Cc: stable@vger.kernel.org
> Cc: Oliver Neukum <oliver@neukum.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-usb@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: 289507d3364f9 ("net: cdc_ncm: use sysfs for rx/tx aggregation tuning")
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

CC: bjorn@mork.no

Please make sure you CC the authors of all blamed commits as they are
likely to have the most context.

> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 24753a4da7e60..e303b522efb50 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -181,6 +181,8 @@ static u32 cdc_ncm_check_tx_max(struct usbnet *dev, u32 new_tx)
>  		min = ctx->max_datagram_size + ctx->max_ndp_size + sizeof(struct usb_cdc_ncm_nth32);
>  
>  	max = min_t(u32, CDC_NCM_NTB_MAX_SIZE_TX, le32_to_cpu(ctx->ncm_parm.dwNtbOutMaxSize));
> +	if (max == 0)
> +		max = CDC_NCM_NTB_MAX_SIZE_TX; /* dwNtbOutMaxSize not set */
>  
>  	/* some devices set dwNtbOutMaxSize too low for the above default */
>  	min = min(min, max);

