Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6511FDFB2
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731869AbgFRBmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:42:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45590 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732581AbgFRBms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:42:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jljZm-0013Ea-Ae; Thu, 18 Jun 2020 03:42:46 +0200
Date:   Thu, 18 Jun 2020 03:42:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [net-next PATCH 5/5 v2] net: dsa: rtl8366: Use top VLANs for
 default
Message-ID: <20200618014246.GF249144@lunn.ch>
References: <20200617083132.1847234-1-linus.walleij@linaro.org>
 <20200617083132.1847234-5-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617083132.1847234-5-linus.walleij@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:31:32AM +0200, Linus Walleij wrote:
> The RTL8366 DSA switches will not work unless we set
> up a default VLAN for each port. We are currently using
> e.g. VLAN 1..6 for a 5-port switch as default VLANs.
> 
> This is not very helpful for users, move it to allocate
> the top VLANs for default instead, for example on
> RTL8366RB there are 16 VLANs so instead of using
> VLAN 1..6 as default use VLAN 10..15 so VLAN 1
> thru VLAN 9 is available for users.
> 
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Rebase on v5.8-rc1.
> ---
>  drivers/net/dsa/rtl8366.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
> index 7f0691a6da13..4e7562b41598 100644
> --- a/drivers/net/dsa/rtl8366.c
> +++ b/drivers/net/dsa/rtl8366.c
> @@ -260,8 +260,8 @@ static int rtl8366_set_default_vlan_and_pvid(struct realtek_smi *smi,
>  	u16 vid;
>  	int ret;
>  
> -	/* This is the reserved default VLAN for this port */
> -	vid = port + 1;
> +	/* Use the top VLANs for per-port default VLAN */
> +	vid = smi->num_vlan_mc - smi->num_ports + port;

Hi Linus

I've not looked at the whole driver much, but i'm surprised the change
is this small. Is there any checks when user space ask for a VLAN to
be added to a port to see if it is already in use an return -EBUSY or
-EINVAL or something?

	Andrew
