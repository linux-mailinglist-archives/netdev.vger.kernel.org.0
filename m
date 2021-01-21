Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FEB2FF396
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 19:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbhAUSvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 13:51:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:32950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbhAUIxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 03:53:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B63242399A;
        Thu, 21 Jan 2021 08:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611219150;
        bh=mNihBvO5Yvgk58XMrmvOtyRt7C4KQOem/4OsdCpxCX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kQ3CtDSqUcSwRUOHsStwuS+IP3di5JSymqVEJ7QmTSKY2rHpbDZ9gDyMNY38ypnJk
         21HU7y2WKOV0Webz4I6rB0z6YjLaoQGb5tT2I5SWOEARuJTtYTv2s0B6ddgpRPaB3W
         U/V+27+QLILbMwuM41How/roD1RwTDY0aXvBGM/I=
Date:   Thu, 21 Jan 2021 09:52:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Cc:     davem@davemloft.net, helmut.schaa@googlemail.com, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        stf_xl@wp.pl, syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: "KMSAN: uninit-value in rt2500usb_bbp_read" and "KMSAN:
 uninit-value in rt2500usb_probe_hw" should be duplicate crash reports
Message-ID: <YAlAy/tQXW0X310V@kroah.com>
References: <CAD-N9QX=vVdiSf5UkuoYovamfw5a0e5RQJA0dQMOKmCbs-Gyiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD-N9QX=vVdiSf5UkuoYovamfw5a0e5RQJA0dQMOKmCbs-Gyiw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 04:47:37PM +0800, 慕冬亮 wrote:
> Dear kernel developers,
> 
> I found that on the syzbot dashboard, “KMSAN: uninit-value in
> rt2500usb_bbp_read” [1] and "KMSAN: uninit-value in
> rt2500usb_probe_hw" [2] should share the same root cause.
> 
> ## Duplication
> 
> The reasons for the above statement:
> 1) The PoCs are exactly the same with each other;
> 2) The stack trace is almost the same except for the top 2 functions;
> 
> ## Root Cause Analysis
> 
> After looking at the difference between the two stack traces, we found
> they diverge at the function - rt2500usb_probe_hw.
> ------------------------------------------------------------------------------------------------------------------------
> static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
> {
>         ......
>         // rt2500usb_validate_eeprom->rt2500usb_bbp_read->rt2500usb_regbusy_read->rt2500usb_register_read_lock
> from KMSAN
>         retval = rt2500usb_validate_eeprom(rt2x00dev);
>         if (retval)
>                 return retval;
>         // rt2500usb_init_eeprom-> rt2500usb_register_read from KMSAN
>         retval = rt2500usb_init_eeprom(rt2x00dev);
>         if (retval)
>                 return retval;
> ------------------------------------------------------------------------------------------------------------------------
> >From the implementation of rt2500usb_register_read and
> rt2500usb_register_read_lock, we know that, in some situation, reg is
> not initialized in the function invocation
> (rt2x00usb_vendor_request_buff/rt2x00usb_vendor_req_buff_lock), and
> KMSAN reports uninit-value at its first memory access.
> ------------------------------------------------------------------------------------------------------------------------
> static u16 rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
>                                    const unsigned int offset)
> {
>         __le16 reg;
>         // reg is not initialized during the following function all
>         rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
>                                       USB_VENDOR_REQUEST_IN, offset,
>                                       &reg, sizeof(reg));
>         return le16_to_cpu(reg);
> }
> static u16 rt2500usb_register_read_lock(struct rt2x00_dev *rt2x00dev,
>                                         const unsigned int offset)
> {
>         __le16 reg;
>         // reg is not initialized during the following function all
>         rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
>                                        USB_VENDOR_REQUEST_IN, offset,
>                                        &reg, sizeof(reg), REGISTER_TIMEOUT);
>         return le16_to_cpu(reg);
> }
> ------------------------------------------------------------------------------------------------------------------------
> Take rt2x00usb_vendor_req_buff_lock as an example, let me illustrate
> the issue when the "reg" variable is uninitialized. No matter the CSR
> cache is unavailable or the status is not right, the buffer or reg
> will be not initialized.
> And all those issues are probabilistic events. If they occur in
> rt2500usb_register_read, KMSAN reports "uninit-value in
> rt2500usb_probe_hw"; Otherwise, it reports "uninit-value in
> rt2500usb_bbp_read".
> ------------------------------------------------------------------------------------------------------------------------
> int rt2x00usb_vendor_req_buff_lock(struct rt2x00_dev *rt2x00dev,
>                                    const u8 request, const u8 requesttype,
>                                    const u16 offset, void *buffer,
>                                    const u16 buffer_length, const int timeout)
> {
>         if (unlikely(!rt2x00dev->csr.cache || buffer_length > CSR_CACHE_SIZE)) {
>                 rt2x00_err(rt2x00dev, "CSR cache not available\n");
>                 return -ENOMEM;
>         }
> 
>         if (requesttype == USB_VENDOR_REQUEST_OUT)
>                 memcpy(rt2x00dev->csr.cache, buffer, buffer_length);
> 
>         status = rt2x00usb_vendor_request(rt2x00dev, request, requesttype,
>                                           offset, 0, rt2x00dev->csr.cache,
>                                           buffer_length, timeout);
> 
>         if (!status && requesttype == USB_VENDOR_REQUEST_IN)
>                 memcpy(buffer, rt2x00dev->csr.cache, buffer_length);
> 
>         return status;
> }
> ------------------------------------------------------------------------------------------------------------------------
> 
> ## Patch
> 
> I propose to memset reg variable before invoking
> rt2x00usb_vendor_req_buff_lock/rt2x00usb_vendor_request_buff.
> 
> ------------------------------------------------------------------------------------------------------------------------
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> index fce05fc88aaf..f6c93a25b18c 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> @@ -48,6 +48,7 @@ static u16 rt2500usb_register_read(struct rt2x00_dev
> *rt2x00dev,
>                                    const unsigned int offset)
>  {
>         __le16 reg;
> +       memset(&reg, 0, sizeof(reg));
>         rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
>                                       USB_VENDOR_REQUEST_IN, offset,
>                                       &reg, sizeof(reg));
> @@ -58,6 +59,7 @@ static u16 rt2500usb_register_read_lock(struct
> rt2x00_dev *rt2x00dev,
>                                         const unsigned int offset)
>  {
>         __le16 reg;
> +       memset(&reg, 0, sizeof(reg));
>         rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
>                                        USB_VENDOR_REQUEST_IN, offset,
>                                        &reg, sizeof(reg), REGISTER_TIMEOUT);
> ------------------------------------------------------------------------------------------------------------------------
> 
> If you can have any issues with this statement or our information is
> useful to you, please let us know. Thanks very much.
> 
> [1] “KMSAN: uninit-value in rt2500usb_bbp_read” -
> https://syzkaller.appspot.com/bug?id=f35d123de7d393019c1ed4d4e60dc66596ed62cd
> [2] “KMSAN: uninit-value in rt2500usb_probe_hw” -
> https://syzkaller.appspot.com/bug?id=5402df7259c74e15a12992e739b5ac54c9b8a4ce
> 

Can you please resend this in a form in which we can apply it?  Full
details on how to do this can be found in
Documentation/SubmittingPatches.

thanks,

greg k-h
