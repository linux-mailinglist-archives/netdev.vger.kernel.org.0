Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28062573A4D
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 17:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbiGMPgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 11:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiGMPgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 11:36:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3261F4E845;
        Wed, 13 Jul 2022 08:36:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3F83B8204D;
        Wed, 13 Jul 2022 15:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F184C34114;
        Wed, 13 Jul 2022 15:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657726558;
        bh=mgxy9tQlFOmuXGe/eDtjY4cNpf4Y+AzDQIzHZ79WdcU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pYuTs0tk2wj9krwWwVU7XAoM7TqSndfIBr601D0J36JHSuzoIsmSftnD3LfBN6j5f
         CYyX76ZU0MrLKgJD/zO+5IhBxFj7Ecl2Nv56vs33nbQsSofTebQ0St3dfQAy2/JxL6
         RpzqIQIwIHqfOlPztwzTmSGZW4F4OGi0ri2DGtJ0=
Date:   Wed, 13 Jul 2022 17:35:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Richard Palethorpe <rpalethorpe@suse.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        kernel test robot <oliver.sang@intel.com>, lkp@intel.com,
        lkp@lists.01.org, ltp@lists.linux.it,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] can: slcan: do not sleep with a spin lock held
Message-ID: <Ys7mWmIfuJy+1ax7@kroah.com>
References: <20220713151947.56379-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713151947.56379-1-dario.binacchi@amarulasolutions.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 05:19:47PM +0200, Dario Binacchi wrote:
> We can't call close_candev() with a spin lock held, so release the lock
> before calling it.
> 
> Fixes: c4e54b063f42f ("can: slcan: use CAN network device driver API")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/linux-kernel/Ysrf1Yc5DaRGN1WE@xsang-OptiPlex-9020/
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> 
> ---
> 
>  drivers/net/can/slcan/slcan-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
> index 54d29a410ad5..6aaf2986effc 100644
> --- a/drivers/net/can/slcan/slcan-core.c
> +++ b/drivers/net/can/slcan/slcan-core.c
> @@ -688,6 +688,7 @@ static int slc_close(struct net_device *dev)
>  		/* TTY discipline is running. */
>  		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
>  	}
> +	spin_unlock_bh(&sl->lock);
>  	netif_stop_queue(dev);

Can you have a lock held when calling netif_stop_queue()?  You don't
mention this in your changelog text :(

thanks,

greg k-h
