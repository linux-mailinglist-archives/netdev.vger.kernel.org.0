Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F928254C6E
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgH0Rwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726977AbgH0Rwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 13:52:31 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DEE5207CD;
        Thu, 27 Aug 2020 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598550751;
        bh=iOxLgmIGQYHrxMElFT3exVNdV/6tWHPjbcYrBonVTVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cun4+ImZ+yvvc46aY/WjwXu3szA3hLizs32IMEtX3BJt56GbT65LdsxBhLNLAkLFU
         KnbyJDTc/U9ezZ42ZjSfd+DoZfKSr2zm/NwzjQ1LayblEKQMMP9XWsPmqhka6hKFsm
         m2B9VvCgk7N+tocFDJ6KqxB3ZUGXc9g+zNcuYvww=
Date:   Thu, 27 Aug 2020 10:52:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Himadri Pandya <himadrispandya@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] net: usb: Fix uninit-was-stored issue in
 asix_read_phy_addr()
Message-ID: <20200827175215.GA2582911@gmail.com>
References: <20200827065355.15177-1-himadrispandya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827065355.15177-1-himadrispandya@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 12:23:55PM +0530, Himadri Pandya wrote:
> The buffer size is 2 Bytes and we expect to receive the same amount of
> data. But sometimes we receive less data and run into uninit-was-stored
> issue upon read. Hence modify the error check on the return value to match
> with the buffer size as a prevention.
> 
> Reported-and-tested by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com
> Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> ---
>  drivers/net/usb/asix_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index e39f41efda3e..7bc6e8f856fe 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -296,7 +296,7 @@ int asix_read_phy_addr(struct usbnet *dev, int internal)
>  
>  	netdev_dbg(dev->net, "asix_get_phy_addr()\n");
>  
> -	if (ret < 0) {
> +	if (ret < 2) {
>  		netdev_err(dev->net, "Error reading PHYID register: %02x\n", ret);
>  		goto out;
>  	}

If ret is 0 or 1 here, shouldn't asix_read_phy_addr() return an error code
instead of 0 or 1?

- Eric
