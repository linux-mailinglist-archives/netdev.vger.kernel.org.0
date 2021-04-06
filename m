Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60936355609
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 16:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbhDFOGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 10:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233554AbhDFOGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 10:06:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 746B06139C;
        Tue,  6 Apr 2021 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617717960;
        bh=qEX/6JcIH0tvPPBJ0/FFoBpj98iXPxdaCuo5ByOWTbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gFYaUKc25ivU3lsCHPxdml6UB6rqURBPXl6bgdwev7/XrzmsZy8h9j5ShkstUVbJa
         D65PWwl9DRiPj+PKOuzh8MVRdM9tdp45wcd58nFmMM3N3rykhFqQH/SA5Q8Wwyyicp
         fF5PANEvHR7hLtadRncftDmPghckev8aXyFIDbjs=
Date:   Tue, 6 Apr 2021 16:05:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hso: fix null-ptr-deref during tty device
 unregistration
Message-ID: <YGxqxddOyyDM9ueu@kroah.com>
References: <20210406124402.20930-1-mail@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406124402.20930-1-mail@anirudhrb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 06:13:59PM +0530, Anirudh Rayabharam wrote:
> Multiple ttys try to claim the same the minor number causing a double
> unregistration of the same device. The first unregistration succeeds
> but the next one results in a null-ptr-deref.
> 
> The get_free_serial_index() function returns an available minor number
> but doesn't assign it immediately. The assignment is done by the caller
> later. But before this assignment, calls to get_free_serial_index()
> would return the same minor number.
> 
> Fix this by modifying get_free_serial_index to assign the minor number
> immediately after one is found to be and rename it to obtain_minor()
> to better reflect what it does. Similary, rename set_serial_by_index()
> to release_minor() and modify it to free up the minor number of the
> given hso_serial. Every obtain_minor() should have corresponding
> release_minor() call.
> 
> Reported-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
> Tested-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
> 
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> ---
>  drivers/net/usb/hso.c | 32 ++++++++++++--------------------
>  1 file changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index 31d51346786a..295ca330e70c 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -611,7 +611,7 @@ static struct hso_serial *get_serial_by_index(unsigned index)
>  	return serial;
>  }
>  
> -static int get_free_serial_index(void)
> +static int obtain_minor(struct hso_serial *serial)
>  {
>  	int index;
>  	unsigned long flags;
> @@ -619,8 +619,10 @@ static int get_free_serial_index(void)
>  	spin_lock_irqsave(&serial_table_lock, flags);
>  	for (index = 0; index < HSO_SERIAL_TTY_MINORS; index++) {
>  		if (serial_table[index] == NULL) {
> +			serial_table[index] = serial->parent;
> +			serial->minor = index;
>  			spin_unlock_irqrestore(&serial_table_lock, flags);
> -			return index;
> +			return 0;

Minor note, you might want to convert this to use an idr structure in
the future, this "loop and find a free minor" isn't really needed now
that we have a data structure that does this all for us :)

But that's not going to fix this issue, that's for future changes.

thanks,

greg k-h
