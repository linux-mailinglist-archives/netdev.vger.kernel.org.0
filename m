Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126903013E1
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 09:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbhAWIKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 03:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbhAWIKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 03:10:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3340D233EB;
        Sat, 23 Jan 2021 08:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611389362;
        bh=Fgm9/xbqlbNXszt11L5eQwhybmZiw4XD5SMRQe5jUIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oG+CGP+ZVZ9oSSOiV1Qg0sGRmawQVb5C6oPmBheoeHxyQUEEjNzRjMHwoLITfwQ7m
         s9TKa/dV/OAqZZ8zgH/U5d+8MbVjjl5Zm9Dfy5Rh0CjphJ428UCEnyxib0uS/P7gcO
         T8PwfP4koOsW5TYLiyx7cqUL/yiZohaqZVGCFB2M=
Date:   Sat, 23 Jan 2021 09:09:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com
Subject: Re: Duplicate crash reports related with smsc75xx/smsc95xx and root
 cause analysis
Message-ID: <YAvZr1OoDUj7Ze83@kroah.com>
References: <CAD-N9QUdXFhTqZXpjg02Ya7viR8WmkORbU7pwNTquNg8k_kzMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD-N9QUdXFhTqZXpjg02Ya7viR8WmkORbU7pwNTquNg8k_kzMg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 01:40:30PM +0800, 慕冬亮 wrote:
> Dear kernel developers,
> 
> I found that on the syzbot dashboard, “KMSAN: uninit-value in
> smsc75xx_read_eeprom (2)” [1],
> "KMSAN: uninit-value in smsc95xx_read_eeprom (2)" [2], "KMSAN:
> uninit-value in smsc75xx_bind" [3],
> "KMSAN: uninit-value in smsc95xx_reset" [4], "KMSAN: uninit-value in
> smsc95xx_wait_eeprom (2)" [5]
> should share the same root cause.
> 
> ## Root Cause Analysis && Different behaviors
> 
> The root cause of these crash reports resides in the
> "__smsc75xx_read_reg/__smsc95xx_read_reg". Take __smsc95xx_read_reg as
> an example,
> 
> -----------------------------------------------------------------------------------------------------------------
> static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
>                                             u32 *data, int in_pm)
> {
>         u32 buf;
>         int ret;
>         int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
> 
>         BUG_ON(!dev);
> 
>         if (!in_pm)
>                 fn = usbnet_read_cmd;
>         else
>                 fn = usbnet_read_cmd_nopm;
> 
>         ret = fn(dev, USB_VENDOR_REQUEST_READ_REGISTER, USB_DIR_IN
>                  | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>                  0, index, &buf, 4);
>         if (unlikely(ret < 0)) {
>                 netdev_warn(dev->net, "Failed to read reg index 0x%08x: %d\n",
>                             index, ret);
>                 return ret;
>         }
> 
>         le32_to_cpus(&buf);
>         *data = buf;
> 
>         return ret;
> }
> 
> 
> static int __must_check smsc95xx_eeprom_confirm_not_busy(struct usbnet *dev)
> {
>         unsigned long start_time = jiffies;
>         u32 val;
>         int ret;
> 
>         do {
>                 ret = smsc95xx_read_reg(dev, E2P_CMD, &val);
>                 if (ret < 0) {
>                         netdev_warn(dev->net, "Error reading E2P_CMD\n");
>                         return ret;
>                 }
> 
>                 if (!(val & E2P_CMD_BUSY_))
>                         return 0;
>         ......
> }
> -----------------------------------------------------------------------------------------------------------------
> 
> In a special situation, local variable "buf" is not initialized with
> "fn" function invocation. And the ret is bigger than zero, and buf is
> assigned to "*data". In its parent function -
> smsc95xx_eeprom_confirm_not_busy, KMSAN reports "uninit-value" when
> accessing variable "val".
> Note, due to the lack of testing environment, I don't know the
> concrete reason for the uninitialization of "buf" local variable.
> 
> The reason for such different crash behaviors is that the event -
> "buf" is not initialized is random when
> "__smsc75xx_read_reg/__smsc95xx_read_reg" is invoked.
> 
> ## Patch
> 
> diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> index 4353b370249f..a8e500d92285 100644
> --- a/drivers/net/usb/smsc75xx.c
> +++ b/drivers/net/usb/smsc75xx.c
> @@ -76,7 +76,7 @@ static int smsc75xx_phy_gig_workaround(struct usbnet *dev);
>  static int __must_check __smsc75xx_read_reg(struct usbnet *dev, u32 index,
>                                             u32 *data, int in_pm)
>  {
> -       u32 buf;
> +       u32 buf = 0;
>         int ret;
>         int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
> 
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index 4c8ee1cff4d4..dae3be723e0c 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -70,7 +70,7 @@ MODULE_PARM_DESC(turbo_mode, "Enable multiple frames
> per Rx transaction");
>  static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
>                                             u32 *data, int in_pm)
>  {
> -       u32 buf;
> +       u32 buf = 0;
>         int ret;
>         int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
> 
> If you can have any issues with this statement or our information is
> useful to you, please let us know. Thanks very much.
> 
> [1] “KMSAN: uninit-value in smsc75xx_read_eeprom (2)” - url
> [2] “KMSAN: uninit-value in smsc95xx_read_eeprom (2)” - URL
> [3] "KMSAN: uninit-value in smsc75xx_bind" -
> [4] "KMSAN: uninit-value in smsc95xx_reset" -
> [5] "KMSAN: uninit-value in smsc95xx_wait_eeprom (2)" -

As I asked before, please just turn this into a real patch and submit it
to the syzbot to see if it fixes the issue.  If so, then submit it
normally, no need to do any huge writeup.

thnaks,

greg k-h
