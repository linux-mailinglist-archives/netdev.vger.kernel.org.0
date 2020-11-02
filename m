Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932302A2BB1
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgKBNkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:40:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58538 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgKBNkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 08:40:09 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZa41-004owc-3L; Mon, 02 Nov 2020 14:40:01 +0100
Date:   Mon, 2 Nov 2020 14:40:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     marek.behun@nic.cz, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v7 3/4] net: dsa: mv88e6xxx: Change serdes lane parameter
  from u8 type to int
Message-ID: <20201102134001.GH1109407@lunn.ch>
References: <cover.1604298276.git.pavana.sharma@digi.com>
 <205569de82d73e543625583e55e808981a7c9ee8.1604298276.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <205569de82d73e543625583e55e808981a7c9ee8.1604298276.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 04:43:09PM +1000, Pavana Sharma wrote:
> Returning 0 is no more an error case with MV88E6393 family
> which has serdes lane numbers 0, 9 or 10.
> So with this change .serdes_get_lane will return lane number
> or error (-ENODEV).
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c   | 28 +++++------
>  drivers/net/dsa/mv88e6xxx/chip.h   | 16 +++----
>  drivers/net/dsa/mv88e6xxx/port.c   |  6 +--
>  drivers/net/dsa/mv88e6xxx/serdes.c | 76 +++++++++++++++---------------
>  drivers/net/dsa/mv88e6xxx/serdes.h | 50 ++++++++++----------
>  5 files changed, 88 insertions(+), 88 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index f0dbc05e30a4..4994b8eee659 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -484,12 +484,12 @@ static int mv88e6xxx_serdes_pcs_get_state(struct dsa_switch *ds, int port,
>  					  struct phylink_link_state *state)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
> -	u8 lane;
> +	int lane = -ENODEV;
>  	int err;

You have added a lot of initialises which are not needed.

>  
>  	mv88e6xxx_reg_lock(chip);
>  	lane = mv88e6xxx_serdes_get_lane(chip, port);


lane is always set, so there is no point in setting it to -ENODEV
first.

> -	if (lane && chip->info->ops->serdes_pcs_get_state)
> +	if ((lane >= 0) && chip->info->ops->serdes_pcs_get_state)
>  		err = chip->info->ops->serdes_pcs_get_state(chip, port, lane,
>  							    state);
>  	else
> @@ -505,11 +505,11 @@ static int mv88e6xxx_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
>  				       const unsigned long *advertise)
>  {
>  	const struct mv88e6xxx_ops *ops = chip->info->ops;
> -	u8 lane;
> +	int lane = -ENODEV;
>  
>  	if (ops->serdes_pcs_config) {
>  		lane = mv88e6xxx_serdes_get_lane(chip, port);
> -		if (lane)
> +		if (lane >= 0)
>  			return ops->serdes_pcs_config(chip, port, lane, mode,
>  						      interface, advertise);
>  	}
> @@ -521,15 +521,15 @@ static void mv88e6xxx_serdes_pcs_an_restart(struct dsa_switch *ds, int port)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	const struct mv88e6xxx_ops *ops;
> +	int lane = -ENODEV;
>  	int err = 0;
> -	u8 lane;
>  
>  	ops = chip->info->ops;
>  
>  	if (ops->serdes_pcs_an_restart) {
>  		mv88e6xxx_reg_lock(chip);
>  		lane = mv88e6xxx_serdes_get_lane(chip, port);
> -		if (lane)

lane is always set inside this if statement, and is never used outside
of it.

> +		if (lane >= 0)
>  			err = ops->serdes_pcs_an_restart(chip, port, lane);
>  		mv88e6xxx_reg_unlock(chip);
>  
> @@ -543,11 +543,11 @@ static int mv88e6xxx_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
>  					int speed, int duplex)
>  {
>  	const struct mv88e6xxx_ops *ops = chip->info->ops;
> -	u8 lane;
> +	int lane = -ENODEV;
>  
>  	if (!phylink_autoneg_inband(mode) && ops->serdes_pcs_link_up) {
>  		lane = mv88e6xxx_serdes_get_lane(chip, port);
> -		if (lane)
> +		if (lane >= 0)
>  			return ops->serdes_pcs_link_up(chip, port, lane,

lane is always set, and never used outside of the if ....

     Andrew
