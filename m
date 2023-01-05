Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C676865E56F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 07:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjAEGNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 01:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjAEGNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 01:13:16 -0500
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D803751325;
        Wed,  4 Jan 2023 22:13:10 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id fc4so87753868ejc.12;
        Wed, 04 Jan 2023 22:13:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hqDh2Xim+tTDH75JTENXdECaatY8kGHcxbqvmsRA3E=;
        b=AZ/xqhT/M10u60SohsULnjUa2vH9KgadT8BWjPB+7FUAVKJvI/s7R7FGCyD3SREzfl
         CitAg6bIbPLZIAj0WDl+JyadYc2AscolZ//fvssT6pS8kgeEe0Snh3bOTxeVMr9TrHBU
         5BBBlf6M0mgwFym7xYo3GVdaCGc/XU3XcxU59zGoRVr7XAuhdDdjeuAomfLZgWrCuD9s
         83SfKaVBRfbXtkUn4JMVlbopipMnNYabfcfsuaLyQroVtz7oHqVDGegM43pWR5R6wU12
         4ATV/7+Sp9yXNWRE4fQMV8VGv34W8g0H12nEoUIZbeCFS73d0IKjnlmg7Nw4Q2n/QjWw
         72EA==
X-Gm-Message-State: AFqh2krxS5QPo2TLr9De5fBJEuBPCASO0JkYG9VSd/mbpK/Xb3MDHG6T
        nc1bzsb/utTRP9DJkjb/MyA=
X-Google-Smtp-Source: AMrXdXsKlRVn0RJBi17w2liEz4+CZ0KHwnMKR5bmUqdPZM/IvBJ/fkif9boqK4X7TOaFGYDo3SSuVA==
X-Received: by 2002:a17:907:3888:b0:83f:757e:f182 with SMTP id sq8-20020a170907388800b0083f757ef182mr41761314ejc.65.1672899189152;
        Wed, 04 Jan 2023 22:13:09 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id fy10-20020a1709069f0a00b007bd7178d311sm16375349ejc.51.2023.01.04.22.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 22:13:08 -0800 (PST)
Message-ID: <f4016bf5-6377-170d-dd76-8f01ff6cb7da@kernel.org>
Date:   Thu, 5 Jan 2023 07:13:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 06/10] tty: Convert ->carrier_raised() and callchains to
 bool
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Johan Hovold <johan@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230104151531.73994-1-ilpo.jarvinen@linux.intel.com>
 <20230104151531.73994-7-ilpo.jarvinen@linux.intel.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20230104151531.73994-7-ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04. 01. 23, 16:15, Ilpo Järvinen wrote:
> Return boolean from ->carrier_raised() instead of 0 and 1. Make the
> return type change also to tty_port_carrier_raised() that makes the
> ->carrier_raised() call (+ cd variable in moxa into which its return
> value is stored).
> 
> Also cleans up a few unnecessary constructs related to this change:
> 
> 	return xx ? 1 : 0;
> 	-> return xx;
> 
> 	if (xx)
> 		return 1;
> 	return 0;
> 	-> return xx;
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

Reviewed-by: Jiri Slaby <jirislaby@kernel.org>


> ---
>   drivers/char/pcmcia/synclink_cs.c | 8 +++-----
>   drivers/mmc/core/sdio_uart.c      | 7 +++----
>   drivers/tty/amiserial.c           | 2 +-
>   drivers/tty/moxa.c                | 4 ++--
>   drivers/tty/mxser.c               | 5 +++--
>   drivers/tty/n_gsm.c               | 8 ++++----
>   drivers/tty/serial/serial_core.c  | 9 ++++-----
>   drivers/tty/synclink_gt.c         | 7 ++++---
>   drivers/tty/tty_port.c            | 4 ++--
>   drivers/usb/serial/ch341.c        | 7 +++----
>   drivers/usb/serial/f81232.c       | 6 ++----
>   drivers/usb/serial/pl2303.c       | 7 ++-----
>   drivers/usb/serial/spcp8x5.c      | 7 ++-----
>   drivers/usb/serial/usb-serial.c   | 4 ++--
>   include/linux/tty_port.h          | 6 +++---
>   include/linux/usb/serial.h        | 2 +-
>   net/bluetooth/rfcomm/tty.c        | 2 +-
>   17 files changed, 42 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
> index baa46e8a094b..4391138e1b8a 100644
> --- a/drivers/char/pcmcia/synclink_cs.c
> +++ b/drivers/char/pcmcia/synclink_cs.c
> @@ -377,7 +377,7 @@ static void async_mode(MGSLPC_INFO *info);
>   
>   static void tx_timeout(struct timer_list *t);
>   
> -static int carrier_raised(struct tty_port *port);
> +static bool carrier_raised(struct tty_port *port);
>   static void dtr_rts(struct tty_port *port, int onoff);
>   
>   #if SYNCLINK_GENERIC_HDLC
> @@ -2430,7 +2430,7 @@ static void mgslpc_hangup(struct tty_struct *tty)
>   	tty_port_hangup(&info->port);
>   }
>   
> -static int carrier_raised(struct tty_port *port)
> +static bool carrier_raised(struct tty_port *port)
>   {
>   	MGSLPC_INFO *info = container_of(port, MGSLPC_INFO, port);
>   	unsigned long flags;
> @@ -2439,9 +2439,7 @@ static int carrier_raised(struct tty_port *port)
>   	get_signals(info);
>   	spin_unlock_irqrestore(&info->lock, flags);
>   
> -	if (info->serial_signals & SerialSignal_DCD)
> -		return 1;
> -	return 0;
> +	return info->serial_signals & SerialSignal_DCD;
>   }
>   
>   static void dtr_rts(struct tty_port *port, int onoff)
> diff --git a/drivers/mmc/core/sdio_uart.c b/drivers/mmc/core/sdio_uart.c
> index ae7ef2e038be..47f58258d8ff 100644
> --- a/drivers/mmc/core/sdio_uart.c
> +++ b/drivers/mmc/core/sdio_uart.c
> @@ -526,7 +526,7 @@ static void sdio_uart_irq(struct sdio_func *func)
>   	port->in_sdio_uart_irq = NULL;
>   }
>   
> -static int uart_carrier_raised(struct tty_port *tport)
> +static bool uart_carrier_raised(struct tty_port *tport)
>   {
>   	struct sdio_uart_port *port =
>   			container_of(tport, struct sdio_uart_port, port);
> @@ -535,9 +535,8 @@ static int uart_carrier_raised(struct tty_port *tport)
>   		return 1;
>   	ret = sdio_uart_get_mctrl(port);
>   	sdio_uart_release_func(port);
> -	if (ret & TIOCM_CAR)
> -		return 1;
> -	return 0;
> +
> +	return ret & TIOCM_CAR;
>   }
>   
>   /**
> diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
> index 460d33a1e70b..01c4fd3ce7c8 100644
> --- a/drivers/tty/amiserial.c
> +++ b/drivers/tty/amiserial.c
> @@ -1454,7 +1454,7 @@ static const struct tty_operations serial_ops = {
>   	.proc_show = rs_proc_show,
>   };
>   
> -static int amiga_carrier_raised(struct tty_port *port)
> +static bool amiga_carrier_raised(struct tty_port *port)
>   {
>   	return !(ciab.pra & SER_DCD);
>   }
> diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
> index 2d9635e14ded..6a1e78e33a2c 100644
> --- a/drivers/tty/moxa.c
> +++ b/drivers/tty/moxa.c
> @@ -501,7 +501,7 @@ static int moxa_tiocmset(struct tty_struct *tty,
>   static void moxa_poll(struct timer_list *);
>   static void moxa_set_tty_param(struct tty_struct *, const struct ktermios *);
>   static void moxa_shutdown(struct tty_port *);
> -static int moxa_carrier_raised(struct tty_port *);
> +static bool moxa_carrier_raised(struct tty_port *);
>   static void moxa_dtr_rts(struct tty_port *, int);
>   /*
>    * moxa board interface functions:
> @@ -1432,7 +1432,7 @@ static void moxa_shutdown(struct tty_port *port)
>   	MoxaPortFlushData(ch, 2);
>   }
>   
> -static int moxa_carrier_raised(struct tty_port *port)
> +static bool moxa_carrier_raised(struct tty_port *port)
>   {
>   	struct moxa_port *ch = container_of(port, struct moxa_port, port);
>   	int dcd;
> diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
> index 2926a831727d..96c72e691cd7 100644
> --- a/drivers/tty/mxser.c
> +++ b/drivers/tty/mxser.c
> @@ -458,10 +458,11 @@ static void __mxser_stop_tx(struct mxser_port *info)
>   	outb(info->IER, info->ioaddr + UART_IER);
>   }
>   
> -static int mxser_carrier_raised(struct tty_port *port)
> +static bool mxser_carrier_raised(struct tty_port *port)
>   {
>   	struct mxser_port *mp = container_of(port, struct mxser_port, port);
> -	return (inb(mp->ioaddr + UART_MSR) & UART_MSR_DCD)?1:0;
> +
> +	return inb(mp->ioaddr + UART_MSR) & UART_MSR_DCD;
>   }
>   
>   static void mxser_dtr_rts(struct tty_port *port, int on)
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 631539c17d85..81fc2ec3693f 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -3770,16 +3770,16 @@ static int gsm_modem_update(struct gsm_dlci *dlci, u8 brk)
>   	return -EPROTONOSUPPORT;
>   }
>   
> -static int gsm_carrier_raised(struct tty_port *port)
> +static bool gsm_carrier_raised(struct tty_port *port)
>   {
>   	struct gsm_dlci *dlci = container_of(port, struct gsm_dlci, port);
>   	struct gsm_mux *gsm = dlci->gsm;
>   
>   	/* Not yet open so no carrier info */
>   	if (dlci->state != DLCI_OPEN)
> -		return 0;
> +		return false;
>   	if (debug & DBG_CD_ON)
> -		return 1;
> +		return true;
>   
>   	/*
>   	 * Basic mode with control channel in ADM mode may not respond
> @@ -3787,7 +3787,7 @@ static int gsm_carrier_raised(struct tty_port *port)
>   	 */
>   	if (gsm->encoding == GSM_BASIC_OPT &&
>   	    gsm->dlci[0]->mode == DLCI_MODE_ADM && !dlci->modem_rx)
> -		return 1;
> +		return true;
>   
>   	return dlci->modem_rx & TIOCM_CD;
>   }
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index a0260a40bdb9..f91b27e2058a 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -1859,7 +1859,7 @@ static void uart_port_shutdown(struct tty_port *port)
>   	}
>   }
>   
> -static int uart_carrier_raised(struct tty_port *port)
> +static bool uart_carrier_raised(struct tty_port *port)
>   {
>   	struct uart_state *state = container_of(port, struct uart_state, port);
>   	struct uart_port *uport;
> @@ -1873,15 +1873,14 @@ static int uart_carrier_raised(struct tty_port *port)
>   	 * continue and not sleep
>   	 */
>   	if (WARN_ON(!uport))
> -		return 1;
> +		return true;
>   	spin_lock_irq(&uport->lock);
>   	uart_enable_ms(uport);
>   	mctrl = uport->ops->get_mctrl(uport);
>   	spin_unlock_irq(&uport->lock);
>   	uart_port_deref(uport);
> -	if (mctrl & TIOCM_CAR)
> -		return 1;
> -	return 0;
> +
> +	return mctrl & TIOCM_CAR;
>   }
>   
>   static void uart_dtr_rts(struct tty_port *port, int raise)
> diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
> index 81c94906f06e..4ba71ec764f7 100644
> --- a/drivers/tty/synclink_gt.c
> +++ b/drivers/tty/synclink_gt.c
> @@ -3126,7 +3126,7 @@ static int tiocmset(struct tty_struct *tty,
>   	return 0;
>   }
>   
> -static int carrier_raised(struct tty_port *port)
> +static bool carrier_raised(struct tty_port *port)
>   {
>   	unsigned long flags;
>   	struct slgt_info *info = container_of(port, struct slgt_info, port);
> @@ -3134,7 +3134,8 @@ static int carrier_raised(struct tty_port *port)
>   	spin_lock_irqsave(&info->lock,flags);
>   	get_gtsignals(info);
>   	spin_unlock_irqrestore(&info->lock,flags);
> -	return (info->signals & SerialSignal_DCD) ? 1 : 0;
> +
> +	return info->signals & SerialSignal_DCD;
>   }
>   
>   static void dtr_rts(struct tty_port *port, int on)
> @@ -3162,7 +3163,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
>   	int		retval;
>   	bool		do_clocal = false;
>   	unsigned long	flags;
> -	int		cd;
> +	bool		cd;
>   	struct tty_port *port = &info->port;
>   
>   	DBGINFO(("%s block_til_ready\n", tty->driver->name));
> diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
> index 469de3c010b8..a573c500f95b 100644
> --- a/drivers/tty/tty_port.c
> +++ b/drivers/tty/tty_port.c
> @@ -444,10 +444,10 @@ EXPORT_SYMBOL_GPL(tty_port_tty_wakeup);
>    * to hide some internal details. This will eventually become entirely
>    * internal to the tty port.
>    */
> -int tty_port_carrier_raised(struct tty_port *port)
> +bool tty_port_carrier_raised(struct tty_port *port)
>   {
>   	if (port->ops->carrier_raised == NULL)
> -		return 1;
> +		return true;
>   	return port->ops->carrier_raised(port);
>   }
>   EXPORT_SYMBOL(tty_port_carrier_raised);
> diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
> index 6e1b87e67304..792f01a4ed22 100644
> --- a/drivers/usb/serial/ch341.c
> +++ b/drivers/usb/serial/ch341.c
> @@ -413,12 +413,11 @@ static void ch341_port_remove(struct usb_serial_port *port)
>   	kfree(priv);
>   }
>   
> -static int ch341_carrier_raised(struct usb_serial_port *port)
> +static bool ch341_carrier_raised(struct usb_serial_port *port)
>   {
>   	struct ch341_private *priv = usb_get_serial_port_data(port);
> -	if (priv->msr & CH341_BIT_DCD)
> -		return 1;
> -	return 0;
> +
> +	return priv->msr & CH341_BIT_DCD;
>   }
>   
>   static void ch341_dtr_rts(struct usb_serial_port *port, int on)
> diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
> index 891fb1fe69df..1a8c2925c26f 100644
> --- a/drivers/usb/serial/f81232.c
> +++ b/drivers/usb/serial/f81232.c
> @@ -774,7 +774,7 @@ static bool f81232_tx_empty(struct usb_serial_port *port)
>   	return true;
>   }
>   
> -static int f81232_carrier_raised(struct usb_serial_port *port)
> +static bool f81232_carrier_raised(struct usb_serial_port *port)
>   {
>   	u8 msr;
>   	struct f81232_private *priv = usb_get_serial_port_data(port);
> @@ -783,9 +783,7 @@ static int f81232_carrier_raised(struct usb_serial_port *port)
>   	msr = priv->modem_status;
>   	mutex_unlock(&priv->lock);
>   
> -	if (msr & UART_MSR_DCD)
> -		return 1;
> -	return 0;
> +	return msr & UART_MSR_DCD;
>   }
>   
>   static void f81232_get_serial(struct tty_struct *tty, struct serial_struct *ss)
> diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
> index 8949c1891164..4cb81746a149 100644
> --- a/drivers/usb/serial/pl2303.c
> +++ b/drivers/usb/serial/pl2303.c
> @@ -1050,14 +1050,11 @@ static int pl2303_tiocmget(struct tty_struct *tty)
>   	return result;
>   }
>   
> -static int pl2303_carrier_raised(struct usb_serial_port *port)
> +static bool pl2303_carrier_raised(struct usb_serial_port *port)
>   {
>   	struct pl2303_private *priv = usb_get_serial_port_data(port);
>   
> -	if (priv->line_status & UART_DCD)
> -		return 1;
> -
> -	return 0;
> +	return priv->line_status & UART_DCD;
>   }
>   
>   static void pl2303_set_break(struct usb_serial_port *port, bool enable)
> diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
> index 09a972a838ee..8175db6c4554 100644
> --- a/drivers/usb/serial/spcp8x5.c
> +++ b/drivers/usb/serial/spcp8x5.c
> @@ -247,16 +247,13 @@ static void spcp8x5_set_work_mode(struct usb_serial_port *port, u16 value,
>   		dev_err(&port->dev, "failed to set work mode: %d\n", ret);
>   }
>   
> -static int spcp8x5_carrier_raised(struct usb_serial_port *port)
> +static bool spcp8x5_carrier_raised(struct usb_serial_port *port)
>   {
>   	u8 msr;
>   	int ret;
>   
>   	ret = spcp8x5_get_msr(port, &msr);
> -	if (ret || msr & MSR_STATUS_LINE_DCD)
> -		return 1;
> -
> -	return 0;
> +	return ret || msr & MSR_STATUS_LINE_DCD;
>   }
>   
>   static void spcp8x5_dtr_rts(struct usb_serial_port *port, int on)
> diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
> index 164521ee10c6..019720a63fac 100644
> --- a/drivers/usb/serial/usb-serial.c
> +++ b/drivers/usb/serial/usb-serial.c
> @@ -754,7 +754,7 @@ static struct usb_serial_driver *search_serial_device(
>   	return NULL;
>   }
>   
> -static int serial_port_carrier_raised(struct tty_port *port)
> +static bool serial_port_carrier_raised(struct tty_port *port)
>   {
>   	struct usb_serial_port *p = container_of(port, struct usb_serial_port, port);
>   	struct usb_serial_driver *drv = p->serial->type;
> @@ -762,7 +762,7 @@ static int serial_port_carrier_raised(struct tty_port *port)
>   	if (drv->carrier_raised)
>   		return drv->carrier_raised(p);
>   	/* No carrier control - don't block */
> -	return 1;
> +	return true;
>   }
>   
>   static void serial_port_dtr_rts(struct tty_port *port, int on)
> diff --git a/include/linux/tty_port.h b/include/linux/tty_port.h
> index fa3c3bdaa234..cf098459cb01 100644
> --- a/include/linux/tty_port.h
> +++ b/include/linux/tty_port.h
> @@ -15,7 +15,7 @@ struct tty_struct;
>   
>   /**
>    * struct tty_port_operations -- operations on tty_port
> - * @carrier_raised: return 1 if the carrier is raised on @port
> + * @carrier_raised: return true if the carrier is raised on @port
>    * @dtr_rts: raise the DTR line if @raise is nonzero, otherwise lower DTR
>    * @shutdown: called when the last close completes or a hangup finishes IFF the
>    *	port was initialized. Do not use to free resources. Turn off the device
> @@ -31,7 +31,7 @@ struct tty_struct;
>    *	the port itself.
>    */
>   struct tty_port_operations {
> -	int (*carrier_raised)(struct tty_port *port);
> +	bool (*carrier_raised)(struct tty_port *port);
>   	void (*dtr_rts)(struct tty_port *port, int raise);
>   	void (*shutdown)(struct tty_port *port);
>   	int (*activate)(struct tty_port *port, struct tty_struct *tty);
> @@ -230,7 +230,7 @@ static inline void tty_port_set_kopened(struct tty_port *port, bool val)
>   
>   struct tty_struct *tty_port_tty_get(struct tty_port *port);
>   void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty);
> -int tty_port_carrier_raised(struct tty_port *port);
> +bool tty_port_carrier_raised(struct tty_port *port);
>   void tty_port_raise_dtr_rts(struct tty_port *port);
>   void tty_port_lower_dtr_rts(struct tty_port *port);
>   void tty_port_hangup(struct tty_port *port);
> diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
> index f7bfedb740f5..dc7f90522b42 100644
> --- a/include/linux/usb/serial.h
> +++ b/include/linux/usb/serial.h
> @@ -293,7 +293,7 @@ struct usb_serial_driver {
>   	/* Called by the tty layer for port level work. There may or may not
>   	   be an attached tty at this point */
>   	void (*dtr_rts)(struct usb_serial_port *port, int on);
> -	int  (*carrier_raised)(struct usb_serial_port *port);
> +	bool (*carrier_raised)(struct usb_serial_port *port);
>   	/* Called by the usb serial hooks to allow the user to rework the
>   	   termios state */
>   	void (*init_termios)(struct tty_struct *tty);
> diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
> index 8009e0e93216..5697df9d4394 100644
> --- a/net/bluetooth/rfcomm/tty.c
> +++ b/net/bluetooth/rfcomm/tty.c
> @@ -119,7 +119,7 @@ static int rfcomm_dev_activate(struct tty_port *port, struct tty_struct *tty)
>   }
>   
>   /* we block the open until the dlc->state becomes BT_CONNECTED */
> -static int rfcomm_dev_carrier_raised(struct tty_port *port)
> +static bool rfcomm_dev_carrier_raised(struct tty_port *port)
>   {
>   	struct rfcomm_dev *dev = container_of(port, struct rfcomm_dev, port);
>   

-- 
js
suse labs

