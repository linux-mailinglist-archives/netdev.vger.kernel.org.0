Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B04B7D4A
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390738AbfISO4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:56:07 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:50654 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388551AbfISO4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:56:07 -0400
Received: from localhost.localdomain (p200300E9D7197E1C5D26FA1D92192C91.dip0.t-ipconnect.de [IPv6:2003:e9:d719:7e1c:5d26:fa1d:9219:2c91])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 3E21BC167A;
        Thu, 19 Sep 2019 16:56:05 +0200 (CEST)
Subject: Re: [PATCH] ieee802154: atusb: fix use-after-free at disconnect
To:     Johan Hovold <johan@kernel.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andreyknvl@google.com,
        syzkaller-bugs@googlegroups.com, stable <stable@vger.kernel.org>,
        syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com
References: <20190919121234.30620-1-johan@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <fe42123b-d454-776e-759c-bf42c0a214c7@datenfreihafen.org>
Date:   Thu, 19 Sep 2019 16:56:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919121234.30620-1-johan@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 19.09.19 14:12, Johan Hovold wrote:
> The disconnect callback was accessing the hardware-descriptor private
> data after having having freed it.
> 
> Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
> Cc: stable <stable@vger.kernel.org>     # 4.2
> Cc: Alexander Aring <alex.aring@gmail.com>
> Reported-by: syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> 
> #syz test: https://github.com/google/kasan.git f0df5c1b
> 
>  drivers/net/ieee802154/atusb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> index ceddb424f887..0dd0ba915ab9 100644
> --- a/drivers/net/ieee802154/atusb.c
> +++ b/drivers/net/ieee802154/atusb.c
> @@ -1137,10 +1137,11 @@ static void atusb_disconnect(struct usb_interface *interface)
>  
>  	ieee802154_unregister_hw(atusb->hw);
>  
> +	usb_put_dev(atusb->usb_dev);
> +
>  	ieee802154_free_hw(atusb->hw);
>  
>  	usb_set_intfdata(interface, NULL);
> -	usb_put_dev(atusb->usb_dev);
>  
>  	pr_debug("%s done\n", __func__);
>  }
> 


This patch has been applied to the wpan tree and will be
part of the next pull request to net.

Thanks a lot for having a look at this!

regards
Stefan Schmidt
