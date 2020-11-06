Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD702A8C28
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 02:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732656AbgKFBkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 20:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730246AbgKFBkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 20:40:19 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B10F220759;
        Fri,  6 Nov 2020 01:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604626819;
        bh=969kQmZ6XfP8mnESIv5YIDkBarsLQ2m+HXB+LOyk2Fw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LpklMJRLOwUiWu7UHq2a8ysBAlZTXKgvsWhlRASJOSJL5SpjPepQldCucKxXxheMG
         GLtlnbHLm7FsueRClbkJhAPqgan/3wFmrNb1fkRS7H3uYg/S8q92zk++affX1dBsTY
         Mu3ZWVFRZnSVkbf2Au4kLKgxVMYm2BjxtoZeRKMk=
Date:   Thu, 5 Nov 2020 17:40:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH v8 3/4] net: dsa: mv88e6xxx: Change serdes lane
 parameter  from u8 type to int
Message-ID: <20201105174017.48ddfa3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a4caa1d2b1c8fe17edca376a6fee0bf2460716e1.1604388359.git.pavana.sharma@digi.com>
References: <cover.1604388359.git.pavana.sharma@digi.com>
        <a4caa1d2b1c8fe17edca376a6fee0bf2460716e1.1604388359.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 18:50:02 +1000 Pavana Sharma wrote:
> Returning 0 is no more an error case with MV88E6393 family
> which has serdes lane numbers 0, 9 or 10.
> So with this change .serdes_get_lane will return lane number
> or error (-ENODEV).
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>

>  	mv88e6xxx_reg_lock(chip);
>  	lane = mv88e6xxx_serdes_get_lane(chip, port);
> -	if (lane && chip->info->ops->serdes_pcs_get_state)
> +	if ((lane >= 0) && chip->info->ops->serdes_pcs_get_state)

unnecessary parenthesis, checkpatch even warns about this

>  		err = chip->info->ops->serdes_pcs_get_state(chip, port, lane,
>  							    state);
>  	else


> @@ -522,15 +522,15 @@ static void mv88e6xxx_serdes_pcs_an_restart(struct dsa_switch *ds, int port)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	const struct mv88e6xxx_ops *ops;
> +	int lane;
>  	int err = 0;

Please keep the reverse xmas tree order of variables

int lane; should be after int err = 0; 

We're ordering full lines, not just the type and name.

> -	u8 lane;
>  
>  	ops = chip->info->ops;
>  
>  	if (ops->serdes_pcs_an_restart) {
>  		mv88e6xxx_reg_lock(chip);
>  		lane = mv88e6xxx_serdes_get_lane(chip, port);
> -		if (lane)
> +		if (lane >= 0)
>  			err = ops->serdes_pcs_an_restart(chip, port, lane);
>  		mv88e6xxx_reg_unlock(chip);

>  void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
>  {
> -	u16 *p = _p;
>  	int lane;
> +	u16 *p = _p;
>  	u16 reg;
>  	int i;

ditto

> @@ -129,18 +129,18 @@ void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
>  int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
>  void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
>  
> -/* Return the (first) SERDES lane address a port is using, 0 otherwise. */
> +/* Return the (first) SERDES lane address a port is using, ERROR otherwise. */

The usual notation is -errno, instead of ERROR.
