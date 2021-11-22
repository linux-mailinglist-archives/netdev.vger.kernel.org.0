Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C113C45893E
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 07:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhKVGT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 01:19:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhKVGTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 01:19:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 184E46069B;
        Mon, 22 Nov 2021 06:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637561779;
        bh=A8OkKYkNsVqzS1Kdck6fFI3BJ/xcsMVMb1R9tMssKOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JezSZTth+rMgwesKBQf0QIDrlbhPTI6nQXooyW0pK810y2kT6Is264imF2VCgCnIJ
         TWQHnSdQeFtrzERekm/mlFXIXa4lcq6xq6qrcLswBBWjQI5+v0S8T7yvdmpoAkPf8r
         nzGFcwUAUWh/BLEhG3yIX/8yIHRHE3TBnWpu7TQY=
Date:   Mon, 22 Nov 2021 07:16:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH net-next] mctp: Add MCTP-over-serial transport binding
Message-ID: <YZs1p+lkKO+194zN@kroah.com>
References: <20211122042817.2988517-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122042817.2988517-1-jk@codeconstruct.com.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 12:28:17PM +0800, Jeremy Kerr wrote:
> This change adds a MCTP Serial transport binding, as per DMTF DSP0253.

What is "DMTF DSP0253"?  Can you provide a link to this or more
information that explains why this has to be a serial thing?

> This is implemented as a new serial line discipline, and can be attached
> to arbitrary serial devices.

Why?  Who is going to use this?

> The 'mctp' utility provides the ldisc magic to set up the serial link:
> 
>   # mctp link serial /dev/ttyS0 &
>   # mctp link
>   dev lo index 1 address 0x00:00:00:00:00:00 net 1 mtu 65536 up
>   dev mctpserial0 index 5 address 0x(no-addr) net 1 mtu 68 down

Where is this magic mctp application?  I can't find it in my distro
packages anywhere.


> 
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
> ---
>  drivers/net/mctp/Kconfig       |  11 +
>  drivers/net/mctp/Makefile      |   1 +
>  drivers/net/mctp/mctp-serial.c | 494 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/tty.h       |   1 +
>  4 files changed, 507 insertions(+)
>  create mode 100644 drivers/net/mctp/mctp-serial.c
> 
> diff --git a/drivers/net/mctp/Kconfig b/drivers/net/mctp/Kconfig
> index d8f966cedc89..02f3c2d600fd 100644
> --- a/drivers/net/mctp/Kconfig
> +++ b/drivers/net/mctp/Kconfig
> @@ -3,6 +3,17 @@ if MCTP
>  
>  menu "MCTP Device Drivers"
>  
> +config MCTP_SERIAL
> +	tristate "MCTP serial transport"
> +	depends on TTY
> +	select CRC_CCITT
> +	help
> +	  This driver provides an MCTP-over-serial interface, through a
> +	  serial line-discipline. By attaching the ldisc to a serial device,
> +	  we get a new net device to transport MCTP packets.
> +
> +	  Say y here if you need to connect to MCTP devices over serial.

Module name?

> +
>  endmenu
>  
>  endif
> diff --git a/drivers/net/mctp/Makefile b/drivers/net/mctp/Makefile
> index e69de29bb2d1..d32622613ce4 100644
> --- a/drivers/net/mctp/Makefile
> +++ b/drivers/net/mctp/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_MCTP_SERIAL) += mctp-serial.o
> diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-serial.c
> new file mode 100644
> index 000000000000..30950f1ea6f4
> --- /dev/null
> +++ b/drivers/net/mctp/mctp-serial.c
> @@ -0,0 +1,494 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Management Component Transport Protocol (MCTP) - serial transport
> + * binding.
> + *
> + * Copyright (c) 2021 Code Construct
> + */
> +
> +#include <linux/idr.h>
> +#include <linux/if_arp.h>
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <linux/tty.h>
> +#include <linux/workqueue.h>
> +#include <linux/crc-ccitt.h>
> +
> +#include <linux/mctp.h>
> +#include <net/mctp.h>
> +#include <net/pkt_sched.h>
> +
> +#define MCTP_SERIAL_MTU		68 /* base mtu (64) + mctp header */
> +#define MCTP_SERIAL_FRAME_MTU	(MCTP_SERIAL_MTU + 6) /* + serial framing */
> +
> +#define MCTP_SERIAL_VERSION	0x1

Where does this number come from?

> +
> +#define BUFSIZE			MCTP_SERIAL_FRAME_MTU
> +
> +#define BYTE_FRAME		0x7e
> +#define BYTE_ESC		0x7d
> +
> +static DEFINE_IDA(mctp_serial_ida);

I think you forgot to clean this up when the module is removed.

thanks,

greg k-h
