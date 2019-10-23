Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B89E0F8B
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 03:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731266AbfJWBGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 21:06:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58794 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731059AbfJWBGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 21:06:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ab36XEbIO9dGtvulmA1y5l4Y+OEvyatTrK5rRhzAxBg=; b=sFrY7MPG/5rgSbn8tyKYqZ1Qf9
        7gKYgbvcnrY8Fg65sRokIudW594VKOuELTs3pXKR1xixb/M7IPsYWRzIXCsalqMhzdk+k/JFf5GMq
        kulHL9OcOC2siFDhtt/E5Oop8hWhlA8Nb3j6w6de//lxn9siLHPm3Wlj95zdZut6wFmc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iN56T-0004QO-76; Wed, 23 Oct 2019 03:06:21 +0200
Date:   Wed, 23 Oct 2019 03:06:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Iwan R Timmer <irtimmer@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net
Subject: Re: [PATCH net-next v2 1/2] net: dsa: mv88e6xxx: Split monitor port
 configuration
Message-ID: <20191023010621.GH5707@lunn.ch>
References: <20191021210143.119426-1-irtimmer@gmail.com>
 <20191021210143.119426-2-irtimmer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021210143.119426-2-irtimmer@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 11:01:42PM +0200, Iwan R Timmer wrote:
> Separate the configuration of the egress and ingress monitor port.
> This allows the port mirror functionality to do ingress and egress
> port mirroring to separate ports.
> 
> Signed-off-by: Iwan R Timmer <irtimmer@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c    |  9 ++++++++-
>  drivers/net/dsa/mv88e6xxx/chip.h    |  3 ++-
>  drivers/net/dsa/mv88e6xxx/global1.c | 23 +++++++++++------------
>  drivers/net/dsa/mv88e6xxx/global1.h |  6 ++++--
>  4 files changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 6787d560e9e3..e9735346838d 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2378,7 +2378,14 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
>  
>  		if (chip->info->ops->set_egress_port) {
>  			err = chip->info->ops->set_egress_port(chip,
> -							       upstream_port);
> +							       true,
> +							       upstream_port);
> +			if (err)
> +				return err;
> +
> +			err = chip->info->ops->set_egress_port(chip,
> +							       false,
> +							       upstream_port);

Hi Iwam

I never find true/false very simple to understand. Please could you
add an enum. We already have

enum mv88e6xxx_egress_mode {
        MV88E6XXX_EGRESS_MODE_UNMODIFIED,
        MV88E6XXX_EGRESS_MODE_UNTAGGED,
        MV88E6XXX_EGRESS_MODE_TAGGED,
        MV88E6XXX_EGRESS_MODE_ETHERTYPE,
};

so maybe

enum mv88e6xxx_egress_direction {
        MV88E6XXX_EGRESS_DIR_INGRESS,
        MV88E6XXX_EGRESS_DIR_EGRESS,
};

Otherwise the spirit of the patch is O.K.

	  Andrew
