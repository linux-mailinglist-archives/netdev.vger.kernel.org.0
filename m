Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E9D9ABFD
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 11:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389743AbfHWJxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 05:53:11 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:42936 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389636AbfHWJxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 05:53:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id 7EDB123F3BB;
        Fri, 23 Aug 2019 11:53:07 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.113
X-Spam-Level: 
X-Spam-Status: No, score=-3.113 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.213, BAYES_00=-1.9] autolearn=ham
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EtZZPu5spIOh; Fri, 23 Aug 2019 11:53:06 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPSA id E66B823F488;
        Fri, 23 Aug 2019 11:53:05 +0200 (CEST)
Date:   Fri, 23 Aug 2019 12:06:11 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Claudiu.Beznea@microchip.com
Cc:     gregkh@linuxfoundation.org, tglx@linutronix.de, swinslow@gmail.com,
        allison@lohutok.net, opensource@jilayne.com,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v6 5/7] nfc: pn533: add UART phy driver
Message-ID: <20190823100611.GB14401@lem-wkst-02.lemonage>
References: <20190820120345.22593-1-poeschel@lemonage.de>
 <20190820120345.22593-5-poeschel@lemonage.de>
 <909777a0-a70e-2174-4455-4afa0591a462@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <909777a0-a70e-2174-4455-4afa0591a462@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 10:09:09AM +0000, Claudiu.Beznea@microchip.com wrote:
> Hi Lars,
> 
> On 20.08.2019 15:03, Lars Poeschel wrote:
> > This adds the UART phy interface for the pn533 driver.
> > The pn533 driver can be used through UART interface this way.
> > It is implemented as a serdev device.
> > 
> > Cc: Johan Hovold <johan@kernel.org>
> > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> > ---
> > Changes in v6:
> > - Rebased the patch series on v5.3-rc5
> > 
> > Changes in v5:
> > - Use the splitted pn53x_common_init and pn53x_register_nfc
> >   and pn53x_common_clean and pn53x_unregister_nfc alike
> > 
> > Changes in v4:
> > - SPDX-License-Identifier: GPL-2.0+
> > - Source code comments above refering items
> > - Error check for serdev_device_write's
> > - Change if (xxx == NULL) to if (!xxx)
> > - Remove device name from a dev_err
> > - move pn533_register in _probe a bit towards the end of _probe
> > - make use of newly added dev_up / dev_down phy_ops
> > - control send_wakeup variable from dev_up / dev_down
> > 
> > Changes in v3:
> > - depend on SERIAL_DEV_BUS in Kconfig
> > 
> > Changes in v2:
> > - switched from tty line discipline to serdev, resulting in many
> >   simplifications
> > - SPDX License Identifier
> > 
> >  drivers/nfc/pn533/Kconfig  |  11 ++
> >  drivers/nfc/pn533/Makefile |   2 +
> >  drivers/nfc/pn533/pn533.h  |   8 +
> >  drivers/nfc/pn533/uart.c   | 316 +++++++++++++++++++++++++++++++++++++
> >  4 files changed, 337 insertions(+)
> >  create mode 100644 drivers/nfc/pn533/uart.c
> > 
> > diff --git a/drivers/nfc/pn533/Kconfig b/drivers/nfc/pn533/Kconfig
> > index f6d6b345ba0d..7fe1bbe26568 100644
> > --- a/drivers/nfc/pn533/Kconfig
> > +++ b/drivers/nfc/pn533/Kconfig
> > @@ -26,3 +26,14 @@ config NFC_PN533_I2C
> >  
> >  	  If you choose to build a module, it'll be called pn533_i2c.
> >  	  Say N if unsure.
> > +
> > +config NFC_PN532_UART
> > +	tristate "NFC PN532 device support (UART)"
> > +	depends on SERIAL_DEV_BUS
> > +	select NFC_PN533
> > +	---help---
> > +	  This module adds support for the NXP pn532 UART interface.
> > +	  Select this if your platform is using the UART bus.
> > +
> > +	  If you choose to build a module, it'll be called pn532_uart.
> > +	  Say N if unsure.
> > diff --git a/drivers/nfc/pn533/Makefile b/drivers/nfc/pn533/Makefile
> > index 43c25b4f9466..b9648337576f 100644
> > --- a/drivers/nfc/pn533/Makefile
> > +++ b/drivers/nfc/pn533/Makefile
> > @@ -4,7 +4,9 @@
> >  #
> >  pn533_usb-objs  = usb.o
> >  pn533_i2c-objs  = i2c.o
> > +pn532_uart-objs  = uart.o
> >  
> >  obj-$(CONFIG_NFC_PN533)     += pn533.o
> >  obj-$(CONFIG_NFC_PN533_USB) += pn533_usb.o
> >  obj-$(CONFIG_NFC_PN533_I2C) += pn533_i2c.o
> > +obj-$(CONFIG_NFC_PN532_UART) += pn532_uart.o
> > diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
> > index 510ddebbd896..6541088fad73 100644
> > --- a/drivers/nfc/pn533/pn533.h
> > +++ b/drivers/nfc/pn533/pn533.h
> > @@ -43,6 +43,11 @@
> >  
> >  /* Preamble (1), SoPC (2), ACK Code (2), Postamble (1) */
> >  #define PN533_STD_FRAME_ACK_SIZE 6
> > +/*
> > + * Preamble (1), SoPC (2), Packet Length (1), Packet Length Checksum (1),
> > + * Specific Application Level Error Code (1) , Postamble (1)
> > + */
> > +#define PN533_STD_ERROR_FRAME_SIZE 8
> >  #define PN533_STD_FRAME_CHECKSUM(f) (f->data[f->datalen])
> >  #define PN533_STD_FRAME_POSTAMBLE(f) (f->data[f->datalen + 1])
> >  /* Half start code (3), LEN (4) should be 0xffff for extended frame */
> > @@ -84,6 +89,9 @@
> >  #define PN533_CMD_MI_MASK 0x40
> >  #define PN533_CMD_RET_SUCCESS 0x00
> >  
> > +#define PN533_FRAME_DATALEN_ACK 0x00
> > +#define PN533_FRAME_DATALEN_ERROR 0x01
> > +#define PN533_FRAME_DATALEN_EXTENDED 0xFF
> >  
> >  enum  pn533_protocol_type {
> >  	PN533_PROTO_REQ_ACK_RESP = 0,
> > diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
> > new file mode 100644
> > index 000000000000..f1cc2354a4fd
> > --- /dev/null
> > +++ b/drivers/nfc/pn533/uart.c
> > @@ -0,0 +1,316 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * Driver for NXP PN532 NFC Chip - UART transport layer
> > + *
> > + * Copyright (C) 2018 Lemonage Software GmbH
> > + * Author: Lars Pöschel <poeschel@lemonage.de>
> > + * All rights reserved.
> > + */
> > +
> > +#include <linux/device.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/nfc.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/of.h>
> > +#include <linux/serdev.h>
> > +#include "pn533.h"
> > +
> > +#define PN532_UART_SKB_BUFF_LEN	(PN533_CMD_DATAEXCH_DATA_MAXLEN * 2)
> > +
> > +enum send_wakeup {
> > +	PN532_SEND_NO_WAKEUP = 0,
> > +	PN532_SEND_WAKEUP,
> > +	PN532_SEND_LAST_WAKEUP,
> > +};
> > +
> > +
> > +struct pn532_uart_phy {
> > +	struct serdev_device *serdev;
> > +	struct sk_buff *recv_skb;
> > +	struct pn533 *priv;
> > +	enum send_wakeup send_wakeup;
> 
> Could there be any concurrency issues w/ regards to accessing this
> variable? I see it is accessed in pn532_uart_send_frame(), pn532_dev_up(),
> pn532_dev_down() which may be called from the following wq:
> 
>         INIT_WORK(&priv->mi_tm_rx_work, pn533_wq_tm_mi_recv);
> 
>         INIT_WORK(&priv->mi_tm_tx_work, pn533_wq_tm_mi_send);
> 
>         INIT_DELAYED_WORK(&priv->poll_work, pn533_wq_poll);
> 
> 
> and from net/nfc/core.c via dev_up()/dev_down().

Well, I spend some minutes thinking about this. There should be no real
problem. The code in pn533.c ensures, that commands are transmitted
sequencially. And it always is command - response. So if a command is
send, the driver waits for a response from the chip.
So pn532_uart_send_frame should not be called multiple times without
reaching at least serdev_device_write, but at this point the race is
already over.
There is one exception, this is the abort command. This command can be
sent without receiving a previous response. So there is the possibility
of a successful race.
The send_wakeup variable is used to control if we need to send a
wakeup request to the pn532 chip prior to the actual command we would
like to send.
Worst thing that I see could happen - if the race succeeds - is that we
send a wakeup to the chip that is propably not needed as it is already
awake. But this does not hurt as a wakeup send to the pn532 is
essentially a no-op if the chip is awake already. I could have
implemented it so, that a wakeup is sent in front of every command
without thinking and the driver would work.
The same is with pn532_dev_up. It could be that there is one wakeup sent
to much, but it does not hurt.
pn532_dev_down is not problematic I think.

To sum it up: There is maybe a very little probability, but it does
nothing bad. Question is now: Is it worth mutex'ing the send_wakeup
variable or can we leave it as-is ?

Thank you for your review, Claudiu.
Regards,
Lars
