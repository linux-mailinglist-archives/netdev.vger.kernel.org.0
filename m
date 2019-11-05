Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D745EFC6C
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 12:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730903AbfKELbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 06:31:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:36390 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730645AbfKELbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 06:31:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7519BB249;
        Tue,  5 Nov 2019 11:31:16 +0000 (UTC)
Message-ID: <1572952516.2921.6.camel@suse.com>
Subject: Re: KMSAN: uninit-value in cdc_ncm_set_dgram_size
From:   Oliver Neukum <oneukum@suse.com>
To:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        syzbot <syzbot+0631d878823ce2411636@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Date:   Tue, 05 Nov 2019 12:15:16 +0100
In-Reply-To: <87ftj32v6y.fsf@miraculix.mork.no>
References: <00000000000013c4c1059625a655@google.com>
         <87ftj32v6y.fsf@miraculix.mork.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, den 04.11.2019, 22:22 +0100 schrieb Bjørn Mork:
> This looks like a false positive to me. max_datagram_size is two bytes
> declared as
> 
>         __le16 max_datagram_size;
> 
> and the code leading up to the access on drivers/net/usb/cdc_ncm.c:587
> is:
> 
>         /* read current mtu value from device */
>         err = usbnet_read_cmd(dev, USB_CDC_GET_MAX_DATAGRAM_SIZE,
>                               USB_TYPE_CLASS | USB_DIR_IN | USB_RECIP_INTERFACE,
>                               0, iface_no, &max_datagram_size, 2);

At this point err can be 1.

>         if (err < 0) {
>                 dev_dbg(&dev->intf->dev, "GET_MAX_DATAGRAM_SIZE failed\n");
>                 goto out;
>         }
> 
>         if (le16_to_cpu(max_datagram_size) == ctx->max_datagram_size)
> 
> 
> 
> AFAICS, there is no way max_datagram_size can be uninitialized here.
> usbnet_read_cmd() either read 2 bytes into it or returned an error,

No. usbnet_read_cmd() will return the number of bytes transfered up
to the number requested or an error.

> causing the access to be skipped.  Or am I missing something?

Yes. You can get half the MTU. We have a similar class of bugs
with MAC addresses.

	Regards
		Oliver


