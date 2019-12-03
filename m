Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C382A10FC70
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 12:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfLCLWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 06:22:06 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:20173 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCLWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 06:22:06 -0500
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3jXdVqE32oRVrGn+26OxA=="
X-RZG-CLASS-ID: mo00
Received: from [10.180.55.161]
        by smtp.strato.de (RZmta 46.0.2 SBL|AUTH)
        with ESMTPSA id 90101evB3BLu3RS
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 3 Dec 2019 12:21:56 +0100 (CET)
Subject: Re: [PATCH 3/6] can: slcan: Fix use-after-free Read in slcan_open
To:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jouni Hogander <jouni.hogander@unikie.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-stable <stable@vger.kernel.org>
References: <20191203104703.14620-1-mkl@pengutronix.de>
 <20191203104703.14620-4-mkl@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <df8db94f-307f-6a08-2711-c869b4548a67@hartkopp.net>
Date:   Tue, 3 Dec 2019 12:21:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191203104703.14620-4-mkl@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/12/2019 11.47, Marc Kleine-Budde wrote:
> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> Slcan_open doesn't clean-up device which registration failed from the
> slcan_devs device list. On next open this list is iterated and freed
> device is accessed. Fix this by calling slc_free_netdev in error path.
> 
> Driver/net/can/slcan.c is derived from slip.c. Use-after-free error was
> identified in slip_open by syzboz. Same bug is in slcan.c. Here is the
> trace from the Syzbot slip report:
> 
> __dump_stack lib/dump_stack.c:77 [inline]
> dump_stack+0x197/0x210 lib/dump_stack.c:118
> print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
> __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
> kasan_report+0x12/0x20 mm/kasan/common.c:634
> __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
> sl_sync drivers/net/slip/slip.c:725 [inline]
> slip_open+0xecd/0x11b7 drivers/net/slip/slip.c:801
> tty_ldisc_open.isra.0+0xa3/0x110 drivers/tty/tty_ldisc.c:469
> tty_set_ldisc+0x30e/0x6b0 drivers/tty/tty_ldisc.c:596
> tiocsetd drivers/tty/tty_io.c:2334 [inline]
> tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2594
> vfs_ioctl fs/ioctl.c:46 [inline]
> file_ioctl fs/ioctl.c:509 [inline]
> do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
> ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
> __do_sys_ioctl fs/ioctl.c:720 [inline]
> __se_sys_ioctl fs/ioctl.c:718 [inline]
> __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
> do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
> entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Fixes: ed50e1600b44 ("slcan: Fix memory leak in error path")
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: David Miller <davem@davemloft.net>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> Cc: linux-stable <stable@vger.kernel.org> # >= v5.4

I think this problem existed from the initial commit in 2010 and is not 
restricted to >= v5.4

Together with commit commit ed50e1600b4483c049 ("slcan: Fix memory leak 
in error path") from Jouni Hogander.

Regards,
Oliver

> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>   drivers/net/can/slcan.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index 0a9f42e5fedf..2e57122f02fb 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -617,6 +617,7 @@ static int slcan_open(struct tty_struct *tty)
>   	sl->tty = NULL;
>   	tty->disc_data = NULL;
>   	clear_bit(SLF_INUSE, &sl->flags);
> +	slc_free_netdev(sl->dev);
>   	free_netdev(sl->dev);
>   
>   err_exit:
> 
