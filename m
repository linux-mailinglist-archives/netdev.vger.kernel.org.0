Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C79487533
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 11:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346644AbiAGKGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 05:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346613AbiAGKGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 05:06:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AB9C061245;
        Fri,  7 Jan 2022 02:06:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB27B81F80;
        Fri,  7 Jan 2022 10:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9557DC36AE0;
        Fri,  7 Jan 2022 10:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641550012;
        bh=dbXWvgtCasKfVtJH5uVkp9Vf74ZRziPbM2Ato3R4ZzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rdb7rAYA19kw0YA20UnHia29Qi3HST9LHf/be6joqDkXIGYziDOqKqjyUjqLB5znR
         eITl3R3+EP8sc7+u70BvNetujaFUCGTk5DUkh9zpRDFBs2tK/AuYpqykAEGVXb0jkx
         j4ptn29mCvzkTr6fbZ3S+r/em4CL5JqCoZSRIWW8=
Date:   Fri, 7 Jan 2022 11:06:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, tanghui20@huawei.com,
        andrew@lunn.ch, oneukum@suse.com, arnd@arndb.de,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+003c0a286b9af5412510@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: mcs7830: handle usb read errors properly
Message-ID: <YdgQuavHA/T8tlHi@kroah.com>
References: <20220106225716.7425-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106225716.7425-1-paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 01:57:16AM +0300, Pavel Skripkin wrote:
> Syzbot reported uninit value in mcs7830_bind(). The problem was in
> missing validation check for bytes read via usbnet_read_cmd().
> 
> usbnet_read_cmd() internally calls usb_control_msg(), that returns
> number of bytes read. Code should validate that requested number of bytes
> was actually read.
> 
> So, this patch adds missing size validation check inside
> mcs7830_get_reg() to prevent uninit value bugs
> 
> CC: Arnd Bergmann <arnd@arndb.de>
> Reported-and-tested-by: syzbot+003c0a286b9af5412510@syzkaller.appspotmail.com
> Fixes: 2a36d7083438 ("USB: driver for mcs7830 (aka DeLOCK) USB ethernet adapter")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> @Arnd, I am not sure about mcs7830_get_rev() function. 
> 
> Is get_reg(22, 2) == 1 valid read? If so, I think, we should call
> usbnet_read_cmd() directly here, since other callers care only about
> negative error values.  
> 
> Thanks
> 
> 
> ---
>  drivers/net/usb/mcs7830.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
> index 326cc4e749d8..fdda0616704e 100644
> --- a/drivers/net/usb/mcs7830.c
> +++ b/drivers/net/usb/mcs7830.c
> @@ -108,8 +108,16 @@ static const char driver_name[] = "MOSCHIP usb-ethernet driver";
>  
>  static int mcs7830_get_reg(struct usbnet *dev, u16 index, u16 size, void *data)
>  {
> -	return usbnet_read_cmd(dev, MCS7830_RD_BREQ, MCS7830_RD_BMREQ,
> -				0x0000, index, data, size);
> +	int ret;
> +
> +	ret = usbnet_read_cmd(dev, MCS7830_RD_BREQ, MCS7830_RD_BMREQ,
> +			      0x0000, index, data, size);
> +	if (ret < 0)
> +		return ret;
> +	else if (ret < size)
> +		return -ENODATA;

We have a usb core function that handles these "short reads are an
error" issue.  Perhaps usbnet_read_cmd() should be converted to use it
instead?

thanks,

greg k-h
