Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9459D433220
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 11:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbhJSJ0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 05:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231652AbhJSJ0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 05:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33A176113D;
        Tue, 19 Oct 2021 09:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634635433;
        bh=ZvHmmk9NzSMdRMcuDJwACGSszzVGMNFFatXRDZYmeyw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E28/Kz3gflNxyOGdLEfbDweru7NIthIRIAm68B1k5hjLbC3lTDCToUrZs5HFJETUZ
         kVOMZuSxO3fd8upEjGxfLdr6q6SSeZ8t4VHEVtDdpAfTdtdx82ir/eW/SzhVNoVnwh
         JO2H2vBcagrbeqbNJhLkRQlxqMTfh4UqIHEXT6GE0BlJc1uhl9XRrUGV4wABFdc8+t
         DLD3ma7cYt2Qf0P9cUdHVOtMVzyAs0K+jQ9BzvmebRBmeodhGh5t5VsboGuvRjGCJB
         jTJy5kq1Syv54qrqzc63btGgF1T0tTBSnrZyVkDYsx3GgZlrdLvR3qOfY1eL66R4s7
         J2MP8hyPyslsA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mclLT-0003Ka-J1; Tue, 19 Oct 2021 11:23:44 +0200
Date:   Tue, 19 Oct 2021 11:23:43 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     syzbot <syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] divide error in usbnet_start_xmit
Message-ID: <YW6On2cAm1qLoidn@hovoldconsulting.com>
References: <000000000000046acd05ceac1a72@google.com>
 <c5a75b9b-bc2b-2bd8-f57c-833e6ca4c192@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5a75b9b-bc2b-2bd8-f57c-833e6ca4c192@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 10:14:20AM +0200, Oliver Neukum wrote:
> 
> On 19.10.21 05:17, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    c03fb16bafdf Merge 5.15-rc6 into usb-next
> > git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12d48f1f300000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=c27d285bdb7457e2
> > dashboard link: https://syzkaller.appspot.com/bug?extid=76bb1d34ffa0adc03baa
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fe6decb00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c7bcaf300000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
> 
> #syz test:
> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git c03fb16bafdf
> 
> From a5270791d4480e9a6bc009c69a4454039aa160e7 Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oneukum@suse.com>
> Date: Tue, 19 Oct 2021 10:02:42 +0200
> Subject: [PATCH] usbnet: sanity check for maxpacket
> 
> We cannot leave maxpacket at 0 because we divide by it.
> Devices that give us a 0 there are unlikely to work, but let's
> assume a 1, so we don't oops and a least try to operate.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
> ---
>  drivers/net/usb/usbnet.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 840c1c2ab16a..2bdc3e0c1579 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1788,6 +1788,9 @@ usbnet_probe (struct usb_interface *udev, const
> struct usb_device_id *prod)
>      if (!dev->rx_urb_size)
>          dev->rx_urb_size = dev->hard_mtu;
>      dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
> +    if (dev->maxpacket == 0)
> +        /* that is a strange device */
> +        dev->maxpacket = 1;

Just bail out; what can you do with a 1-byte packet size? Also compare
usbnet_get_endpoints() where such endpoints are ignored.

Johan
