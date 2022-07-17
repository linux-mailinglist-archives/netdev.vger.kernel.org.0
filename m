Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16619577875
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 23:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiGQVjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 17:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiGQVi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 17:38:58 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89DC7656A;
        Sun, 17 Jul 2022 14:38:57 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id A8A25FF95E;
        Sun, 17 Jul 2022 21:38:55 +0000 (UTC)
Date:   Sun, 17 Jul 2022 23:38:42 +0200
From:   Max Staudt <max@enpas.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/5] can: slcan: remove legacy infrastructure
Message-ID: <20220717233842.1451e349.max@enpas.org>
In-Reply-To: <20220716170007.2020037-3-dario.binacchi@amarulasolutions.com>
References: <20220716170007.2020037-1-dario.binacchi@amarulasolutions.com>
        <20220716170007.2020037-3-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dario,

This looks good, thank you for continuing to look after slcan!

A few comments below.



On Sat, 16 Jul 2022 19:00:04 +0200
Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:

[...]


> @@ -68,7 +62,6 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
>  				   SLC_STATE_BE_TXCNT_LEN)
>  struct slcan {
>  	struct can_priv         can;
> -	int			magic;
>  
>  	/* Various fields. */
>  	struct tty_struct	*tty;		/* ptr to TTY structure	     */
> @@ -84,17 +77,14 @@ struct slcan {
>  	int			xleft;          /* bytes left in XMIT queue  */
>  
>  	unsigned long		flags;		/* Flag values/ mode etc     */
> -#define SLF_INUSE		0		/* Channel in use            */
> -#define SLF_ERROR		1               /* Parity, etc. error        */
> -#define SLF_XCMD		2               /* Command transmission      */
> +#define SLF_ERROR		0               /* Parity, etc. error        */
> +#define SLF_XCMD		1               /* Command transmission      */
>  	unsigned long           cmd_flags;      /* Command flags             */
>  #define CF_ERR_RST		0               /* Reset errors on open      */
>  	wait_queue_head_t       xcmd_wait;      /* Wait queue for commands   */

I assume xcmd_wait() came in as part of the previous patch series?


[...]


>  /* Send a can_frame to a TTY queue. */
> @@ -652,25 +637,21 @@ static int slc_close(struct net_device *dev)
>  	struct slcan *sl = netdev_priv(dev);
>  	int err;
>  
> -	spin_lock_bh(&sl->lock);
> -	if (sl->tty) {
> -		if (sl->can.bittiming.bitrate &&
> -		    sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
> -			spin_unlock_bh(&sl->lock);
> -			err = slcan_transmit_cmd(sl, "C\r");
> -			spin_lock_bh(&sl->lock);
> -			if (err)
> -				netdev_warn(dev,
> -					    "failed to send close command 'C\\r'\n");
> -		}
> -
> -		/* TTY discipline is running. */
> -		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
> +	if (sl->can.bittiming.bitrate &&
> +	    sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
> +		err = slcan_transmit_cmd(sl, "C\r");
> +		if (err)
> +			netdev_warn(dev,
> +				    "failed to send close command 'C\\r'\n");
>  	}
> +
> +	/* TTY discipline is running. */
> +	clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
> +	flush_work(&sl->tx_work);
> +
>  	netif_stop_queue(dev);
>  	sl->rcount   = 0;
>  	sl->xleft    = 0;

I suggest moving these two assignments to slc_open() - see below.


[...]


> @@ -883,72 +786,50 @@ static int slcan_open(struct tty_struct *tty)
>  	if (!tty->ops->write)
>  		return -EOPNOTSUPP;
>  
> -	/* RTnetlink lock is misused here to serialize concurrent
> -	 * opens of slcan channels. There are better ways, but it is
> -	 * the simplest one.
> -	 */
> -	rtnl_lock();
> +	dev = alloc_candev(sizeof(*sl), 1);
> +	if (!dev)
> +		return -ENFILE;
>  
> -	/* Collect hanged up channels. */
> -	slc_sync();
> +	sl = netdev_priv(dev);
>  
> -	sl = tty->disc_data;
> +	/* Configure TTY interface */
> +	tty->receive_room = 65536; /* We don't flow control */
> +	sl->rcount   = 0;
> +	sl->xleft    = 0;

I suggest moving the zeroing to slc_open() - i.e. to the netdev open
function. As a bonus, you can then remove the same two assignments from
slc_close() (see above). They are only used when netif_running(), with
appropiate guards already in place as far as I can see.


> +	spin_lock_init(&sl->lock);
> +	INIT_WORK(&sl->tx_work, slcan_transmit);
> +	init_waitqueue_head(&sl->xcmd_wait);
>  
> -	err = -EEXIST;
> -	/* First make sure we're not already connected. */
> -	if (sl && sl->magic == SLCAN_MAGIC)
> -		goto err_exit;
> +	/* Configure CAN metadata */
> +	sl->can.bitrate_const = slcan_bitrate_const;
> +	sl->can.bitrate_const_cnt = ARRAY_SIZE(slcan_bitrate_const);
>  
> -	/* OK.  Find a free SLCAN channel to use. */
> -	err = -ENFILE;
> -	sl = slc_alloc();
> -	if (!sl)
> -		goto err_exit;
> +	/* Configure netdev interface */
> +	sl->dev	= dev;
> +	strscpy(dev->name, "slcan%d", sizeof(dev->name));

The third parameter looks... unintentional :)

What do the maintainers think of dropping the old "slcan" name, and
just allowing this to be a normal canX device? These patches do bring
it closer to that, after all. In this case, this name string magic
could be dropped altogether.


[...]



This looks good to me overall.

Thanks Dario!


Max
