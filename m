Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF7FB76B71
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 16:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbfGZOWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 10:22:24 -0400
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:55109 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727502AbfGZOWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 10:22:24 -0400
Received: from xps13 ([83.160.161.190])
        by smtp-cloud9.xs4all.net with ESMTPSA
        id r16whKvVQAffAr16zhYGlX; Fri, 26 Jul 2019 16:22:21 +0200
Message-ID: <1876196a0e7fc665f0f50d5e9c0e2641f713e089.camel@tiscali.nl>
Subject: Re: [PATCH] isdn/gigaset: check endpoint null in gigaset_probe
From:   Paul Bolle <pebolle@tiscali.nl>
To:     Phong Tran <tranmanphong@gmail.com>, isdn@linux-pingi.de,
        gregkh@linuxfoundation.org
Cc:     gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+35b1c403a14f5c89eba7@syzkaller.appspotmail.com
Date:   Fri, 26 Jul 2019 16:22:18 +0200
In-Reply-To: <20190726133528.11063-1-tranmanphong@gmail.com>
References: <20190726133528.11063-1-tranmanphong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFJtsA4bTDd5shYb0nHuFZYTI15MEGFgAWw8jsSPvPGvE0A8aew2qYUZToVNF69Zx9q7S/ETRWYGMQcZvIYd2UvKlgrXNZWzR+8/xc90O4NF+w9CE52s
 DV7omZgcXu3jwABtrM17VrnK3vWE46IU5zqsvpgu/P1NX5qeREMX3B1s/9tgwHcPqk7znM+mxwHSGSiD4ZoGrwSQ8VmsRsT/eRIwLPDbRGwL25vKX825bQt6
 qC8+74pGcQvytoBRVcM1oIYzPp3DFBZcUXFoNCja0+WxntwXoH7cZJUrTS54EfIqT9ksPG55rLvzG5EZDJ9wW14gsfnmcVhbhzYUOlFR98DwIWrsiOjLkFeS
 Od0JUnNt1VnCZti3RlidmEsflh0ZPzl613qThvFYFnA9TXFgYPWPHjd9ZRcSTvIIkM4rsbLLk0Df8MSMPE2gXIl4QMqtiZLGEAvOWj+sQtDflRTOEjI+NN/D
 IcBpkByBmDoZ6XDBDLQ1qjsUuthKsQ17nJruug==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phong Tran schreef op vr 26-07-2019 om 20:35 [+0700]:
> This fixed the potential reference NULL pointer while using variable
> endpoint.
> 
> Reported-by: syzbot+35b1c403a14f5c89eba7@syzkaller.appspotmail.com
> Tested by syzbot:
> https://groups.google.com/d/msg/syzkaller-bugs/wnHG8eRNWEA/Qn2HhjNdBgAJ
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>  drivers/isdn/gigaset/usb-gigaset.c | 9 +++++++++

This is now drivers/staging/isdn/gigaset/usb-gigaset.c.

>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-gigaset.c
> index 1b9b43659bdf..2e011f3db59e 100644
> --- a/drivers/isdn/gigaset/usb-gigaset.c
> +++ b/drivers/isdn/gigaset/usb-gigaset.c
> @@ -703,6 +703,10 @@ static int gigaset_probe(struct usb_interface *interface,
>  	usb_set_intfdata(interface, cs);
>  
>  	endpoint = &hostif->endpoint[0].desc;
> +        if (!endpoint) {
> +		dev_err(cs->dev, "Couldn't get control endpoint\n");
> +		return -ENODEV;
> +	}

When can this happen? Is this one of those bugs that one can only trigger with
a specially crafted (evil) usb device?

>  	buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
>  	ucs->bulk_out_size = buffer_size;
> @@ -722,6 +726,11 @@ static int gigaset_probe(struct usb_interface *interface,
>  	}
>  
>  	endpoint = &hostif->endpoint[1].desc;
> +        if (!endpoint) {
> +		dev_err(cs->dev, "Endpoint not available\n");
> +		retval = -ENODEV;
> +		goto error;
> +	}
>  
>  	ucs->busy = 0;
>  

Please note that I'm very close to getting cut off from the ISDN network, so
the chances of being able to testi this on a live system are getting small. 

Thanks,


Paul Bolle

