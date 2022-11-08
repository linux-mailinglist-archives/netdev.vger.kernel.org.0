Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528F9621A97
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiKHR2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbiKHR2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:28:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DCC110C;
        Tue,  8 Nov 2022 09:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8140BB81B4D;
        Tue,  8 Nov 2022 17:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8804C4347C;
        Tue,  8 Nov 2022 17:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667928525;
        bh=qWpgGL0Fuxq6HiPF8qMs/u+1EiRyISVIX7Ir5Bvbl8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iGEplp73ZbSchZyheqRe0Inh035fT5ZefgNmjOwxGhNFnTTZXH5B2FPqzOjyLe8h3
         B4ZN02ssl/9mwaE9gvtlDyIDeLYA+eUmxcOG6Tq3bgLVeqpRKKXYosNkd/UQHLyLZu
         +wyhM8aR//yehqtq0zO2KNCgjm7EijuB5znmP4sQ=
Date:   Tue, 8 Nov 2022 18:28:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Albert Zhou <albert.zhou.50@gmail.com>
Cc:     linux-usb@vger.kernel.org, nic_swsd@realtek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next RFC 2/5] r8152: update to version two
Message-ID: <Y2qRyqiVuJ0LwySh@kroah.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <20221108153342.18979-3-albert.zhou.50@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108153342.18979-3-albert.zhou.50@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 02:33:39AM +1100, Albert Zhou wrote:
> Update the r8152 module to version two; the original source code is
> accessible from the Realtek website. The website is included in a
> comment in r8152.c, also describing the udev rules file I left out, in
> case this affects future development.
> 
> The only other edit from the original driver source is amending
> netif_napi_add, due to commit b48b89f9c189 ("net: drop the weight
> argument from netif_napi_add"), which removed the weight argument. This
> is also marked by a brief comment in the code.
> 
> The r8152_compatibility.h header was renamed from compatibility.h in the
> original driver.
> 
> Signed-off-by: Albert Zhou <albert.zhou.50@gmail.com>
> ---
>  drivers/net/usb/r8152.c               | 17938 +++++++++++++++++++-----
>  drivers/net/usb/r8152_compatibility.h |   658 +
>  2 files changed, 15130 insertions(+), 3466 deletions(-)
>  create mode 100644 drivers/net/usb/r8152_compatibility.h
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index a481a1d831e2..cda0f4ed2a90 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -1,6 +1,19 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - *  Copyright (c) 2014 Realtek Semiconductor Corp. All rights reserved.
> + *  Copyright (c) 2021 Realtek Semiconductor Corp. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.

To start with, this is not correct.  Don't add back license boiler-plate
code.

And you just changed the copyright notice incorrectly, that is not ok.

> + *
> + *  This product is covered by one or more of the following patents:
> + *  US6,570,884, US6,115,776, and US6,327,625.

Oh wow.  That's playing with fire...

thanks,

greg k-h
