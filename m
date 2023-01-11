Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9BE6661EE
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238792AbjAKRan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239669AbjAKR2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:28:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CAB3AA9A;
        Wed, 11 Jan 2023 09:25:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A715461DA8;
        Wed, 11 Jan 2023 17:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D301C433F0;
        Wed, 11 Jan 2023 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457902;
        bh=DVZXWm+6uZXTGUquageewQdNitAS0dZ/Rv0HUi2X+jA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DPY8nHsUYUyB1FMkKMK5P8AKgMQ9KX2B6f247PvJ+riiRDiQoqC/5OzHrzDJ/Vl1P
         1UCrywVZq6EVIa8yMp/Du7Rec5ZCul8/WdqXUQfJm37zgP/MNHnH93azniNI3/rVXx
         JKKKrg/yVcOa+w+hxVOEuMn84V+9VByHs+tKbf+o5cVdHYnFE0tlH2u0Ijl9t9Vj0s
         9m7y2y55yRrNes8naqVEoTmKvUBBRJVkmIzPCN1k/cZTmMONERW9vmSYAW07lKNVS3
         Wdg41E/mJeGERYO6QM58xc3RtY0Z4fSp909QhAK3H+x5ZZ0xLItWwz4oxSB4nDhied
         fWU9/PViL4aPg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pFeqT-00045s-AT; Wed, 11 Jan 2023 18:25:02 +0100
Date:   Wed, 11 Jan 2023 18:25:01 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>
Cc:     linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Samuel Iglesias =?utf-8?Q?Gons=C3=A1lvez?= 
        <siglesias@igalia.com>, Rodolfo Giometti <giometti@enneenne.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
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
Subject: Re: [PATCH v3 06/13] tty: Convert ->carrier_raised() and callchains
 to bool
Message-ID: <Y77w7aUX4f/f6kFV@hovoldconsulting.com>
References: <20230111142331.34518-1-ilpo.jarvinen@linux.intel.com>
 <20230111142331.34518-7-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230111142331.34518-7-ilpo.jarvinen@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 04:23:24PM +0200, Ilpo Järvinen wrote:
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
> Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> ---
>  drivers/char/pcmcia/synclink_cs.c | 8 +++-----
>  drivers/mmc/core/sdio_uart.c      | 7 +++----
>  drivers/tty/amiserial.c           | 2 +-
>  drivers/tty/moxa.c                | 4 ++--
>  drivers/tty/mxser.c               | 5 +++--
>  drivers/tty/n_gsm.c               | 8 ++++----
>  drivers/tty/serial/serial_core.c  | 9 ++++-----
>  drivers/tty/synclink_gt.c         | 7 ++++---
>  drivers/tty/tty_port.c            | 4 ++--
>  drivers/usb/serial/ch341.c        | 7 +++----
>  drivers/usb/serial/f81232.c       | 6 ++----
>  drivers/usb/serial/pl2303.c       | 7 ++-----
>  drivers/usb/serial/spcp8x5.c      | 7 ++-----
>  drivers/usb/serial/usb-serial.c   | 4 ++--
>  include/linux/tty_port.h          | 6 +++---
>  include/linux/usb/serial.h        | 2 +-
>  net/bluetooth/rfcomm/tty.c        | 2 +-
>  17 files changed, 42 insertions(+), 53 deletions(-)

Same here, please split out the USB serial changes except for the
actual tty-port op change in usb-serial.c.

You can submit a follow-up series for USB serial as those changes are
otherwise unrelated to the changed tty-port interface.

Johan
