Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE04275620
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 12:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgIWKW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 06:22:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:60038 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgIWKW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 06:22:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600856577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jbE3xqWmrav8NliPhuXnwoHoxrt72ZS1tqSJlMbrbqs=;
        b=rUuUIJ0j6ln/3DCMxMrtfIeELX/iS75yliSp+iYcNLunbappoz/0BURyQiFr1m7mjZq7WL
        xDiiqnO3Kz9T5khtGzgVo7s9tFvcvmbLWu0IBTMncSxWcCxcAtMNSNwaIsax54twjDHMs2
        nUgOTeGhu7fNiGKZdzBacZ6kxIggVyo=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 504AFB009;
        Wed, 23 Sep 2020 10:23:34 +0000 (UTC)
Message-ID: <1600856557.26851.6.camel@suse.com>
Subject: Re: [PATCH 3/4] net: usb: rtl8150: use usb_control_msg_recv() and
 usb_control_msg_send()
From:   Oliver Neukum <oneukum@suse.com>
To:     Himadri Pandya <himadrispandya@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pankaj.laxminarayan.bharadiya@intel.com,
        keescook@chromium.org, yuehaibing@huawei.com, petkan@nucleusys.com,
        ogiannou@gmail.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org
Date:   Wed, 23 Sep 2020 12:22:37 +0200
In-Reply-To: <20200923090519.361-4-himadrispandya@gmail.com>
References: <20200923090519.361-1-himadrispandya@gmail.com>
         <20200923090519.361-4-himadrispandya@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, den 23.09.2020, 14:35 +0530 schrieb Himadri Pandya:

Hi,

> Many usage of usb_control_msg() do not have proper error check on return
> value leaving scope for bugs on short reads. New usb_control_msg_recv()
> and usb_control_msg_send() nicely wraps usb_control_msg() with proper
> error check. Hence use the wrappers instead of calling usb_control_msg()
> directly.
> 
> Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
Nacked-by: Oliver Neukum <oneukum@suse.com>

> ---
>  drivers/net/usb/rtl8150.c | 32 ++++++--------------------------
>  1 file changed, 6 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> index 733f120c852b..e3002b675921 100644
> --- a/drivers/net/usb/rtl8150.c
> +++ b/drivers/net/usb/rtl8150.c
> @@ -152,36 +152,16 @@ static const char driver_name [] = "rtl8150";
>  */
>  static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
>  {
> -	void *buf;
> -	int ret;
> -
> -	buf = kmalloc(size, GFP_NOIO);

GFP_NOIO is used here for a reason. You need to use this helper
while in contexts of error recovery and runtime PM.

> -	if (!buf)
> -		return -ENOMEM;
> -
> -	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
> -			      RTL8150_REQ_GET_REGS, RTL8150_REQT_READ,
> -			      indx, 0, buf, size, 500);
> -	if (ret > 0 && ret <= size)
> -		memcpy(data, buf, ret);
> -	kfree(buf);
> -	return ret;
> +	return usb_control_msg_recv(dev->udev, 0, RTL8150_REQ_GET_REGS,
> +				    RTL8150_REQT_READ, indx, 0, data,
> +				    size, 500);

This internally uses kmemdup() with GFP_KERNEL.
You cannot make this change. The API does not support it.
I am afraid we will have to change the API first, before more
such changes are done.

I would suggest dropping the whole series for now.

	Regards
		Oliver

