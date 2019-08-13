Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C638B8E4
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbfHMMnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:43:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:38764 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbfHMMno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 08:43:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 22B2CACD8;
        Tue, 13 Aug 2019 12:43:43 +0000 (UTC)
Message-ID: <1565700220.7043.8.camel@suse.com>
Subject: Re: KMSAN: uninit-value in smsc75xx_bind
From:   Oliver Neukum <oneukum@suse.com>
To:     syzbot <syzbot+6966546b78d050bb0b5d@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com,
        syzkaller-bugs@googlegroups.com, steve.glendinning@shawell.net,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Tue, 13 Aug 2019 14:43:40 +0200
In-Reply-To: <0000000000009f4316058fab3bd7@google.com>
References: <0000000000009f4316058fab3bd7@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, den 09.08.2019, 01:48 -0700 schrieb syzbot:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    beaab8a3 fix KASAN build
> git tree:       kmsan

[..]
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>   kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
>   __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
>   smsc75xx_wait_ready drivers/net/usb/smsc75xx.c:976 [inline]
>   smsc75xx_bind+0x541/0x12d0 drivers/net/usb/smsc75xx.c:1483

> 
> Local variable description: ----buf.i93@smsc75xx_bind
> Variable was created at:
>   __smsc75xx_read_reg drivers/net/usb/smsc75xx.c:83 [inline]
>   smsc75xx_wait_ready drivers/net/usb/smsc75xx.c:969 [inline]
>   smsc75xx_bind+0x44c/0x12d0 drivers/net/usb/smsc75xx.c:1483
>   usbnet_probe+0x10d3/0x3950 drivers/net/usb/usbnet.c:1722

Hi,

this looks like a false positive to me.
The offending code is likely this:

        if (size) {
                buf = kmalloc(size, GFP_KERNEL);
                if (!buf)
                        goto out;
        }

        err = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
                              cmd, reqtype, value, index, buf, size,
                              USB_CTRL_GET_TIMEOUT);

which uses 'buf' uninitialized. But it is used for input.
What is happening here?

	Regards
		Oliver



