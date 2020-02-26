Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D63A16FCF1
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 12:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgBZLGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 06:06:20 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40047 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbgBZLGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 06:06:19 -0500
Received: by mail-ed1-f65.google.com with SMTP id p3so3246477edx.7;
        Wed, 26 Feb 2020 03:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qD490qP8YoHuMggNJ+4rCSwLuR21SazsOZ1+Y/A5tXY=;
        b=nAB7CUTnvsBjhe/PIwUREoSD8Dtea7xSb4TC/ZjuCq1rN7YookFkVvp8f5NZr8ViuK
         JDwLBw/0dPnEXcIRSMONvffCxwYafU6qASRFtw2FNJWsgVFLjapX7Y4NaqL3meEK0zbK
         uNBpTss6XQOEf+r08uX1VGCQ0l4g5Jtd4g7oug1CoUkmD6Lkte+9/zOKo7RA7ZGzOP5h
         34i5PNdEEhbSXfsPuH7I/CNg7jeUY9/lkboGTTuf0f5N0YJ2dZrhkAngbkNKktHnf1FZ
         /TIxN12YKiz/RCiSaMauemnXMy4FcKVLARcxQHPhLrOT7xcsiujLwxQ2HYaqpa7W2KQZ
         s4SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qD490qP8YoHuMggNJ+4rCSwLuR21SazsOZ1+Y/A5tXY=;
        b=BTyuIT+UmI0/Ma/+ZZKYMXW7Sg9mwzfVlRYpifOsOrdwUkpeEye7GCqd6OfLtYA0/X
         TLRrEgjTAzfHM5R8LFhLGpLVziSPQO8ZCXMPoD0eCz/bgCjoRR1m8tgpeHilYkAM/WJH
         1ora014PKQ3UfgWk9Rht+6ke5RBj3bCgJrBajJfwvaoh6Yut06XJVkmV6RxlH1fCCscg
         8QP/MoM0W1G033ONcbD89DikhBwANgnhApH9IbguFERBk74Y2yTnlMCNW1ndTctWfDn8
         ivbcveGsYTiYOymqDRLYfwzlpdrxFuMFWb0GIQAfYuzjzGHz03gVqjgmPyZPUNLz8d91
         1hlA==
X-Gm-Message-State: APjAAAVd9Jb4e290gpTgz/mAobT0p5qjZkyeLJz0XHC9kcuDFLlCE3Zg
        0M6bG29DVHxoFnzVP515urK7XXSParffJzUxW50=
X-Google-Smtp-Source: APXvYqxKn9EHYJorI3u34MIoTYZ1p/XSstU3KzZU6YSsE3nbzrut7Z7pjBq/4/6dZdIrJEtcRK8EZjxaPv8Js3jOl/c=
X-Received: by 2002:a05:6402:3046:: with SMTP id bu6mr4201533edb.139.1582715177721;
 Wed, 26 Feb 2020 03:06:17 -0800 (PST)
MIME-Version: 1.0
References: <20200226102312.GX25745@shell.armlinux.org.uk> <E1j6tqv-0003G6-BO@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1j6tqv-0003G6-BO@rmk-PC.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 26 Feb 2020 13:06:06 +0200
Message-ID: <CA+h21hrR1Xkx9gwAT2FHqcH38L=xjWiPxmF2Er7-4fHFTrA8pQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/8] net: phylink: propagate resolved link
 config via mac_link_up()
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jose Abreu <joabreu@synopsys.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        netdev <netdev@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Wed, 26 Feb 2020 at 12:23, Russell King <rmk+kernel@armlinux.org.uk> wrote:
>
> Propagate the resolved link parameters via the mac_link_up() call for
> MACs that do not automatically track their PCS state. We propagate the
> link parameters via function arguments so that inappropriate members
> of struct phylink_link_state can't be accessed, and creating a new
> structure just for this adds needless complexity to the API.
>
> Tested-by: Andre Przywara <andre.przywara@arm.com>
> Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  Documentation/networking/sfp-phylink.rst      | 17 +++++-
>  drivers/net/ethernet/cadence/macb_main.c      |  7 ++-
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  7 ++-
>  drivers/net/ethernet/marvell/mvneta.c         |  8 ++-
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 19 +++++--
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  7 ++-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +-
>  .../net/ethernet/xilinx/xilinx_axienet_main.c |  7 ++-
>  drivers/net/phy/phylink.c                     |  9 ++-
>  include/linux/phylink.h                       | 57 ++++++++++++++-----
>  net/dsa/port.c                                |  4 +-
>  11 files changed, 105 insertions(+), 41 deletions(-)
>
> diff --git a/Documentation/networking/sfp-phylink.rst b/Documentation/networking/sfp-phylink.rst
> index d753a309f9d1..8d7af28cd835 100644
> --- a/Documentation/networking/sfp-phylink.rst
> +++ b/Documentation/networking/sfp-phylink.rst
> @@ -74,10 +74,13 @@ phylib to the sfp/phylink support.  Please send patches to improve
>  this documentation.
>
>  1. Optionally split the network driver's phylib update function into
> -   three parts dealing with link-down, link-up and reconfiguring the
> -   MAC settings. This can be done as a separate preparation commit.
> +   two parts dealing with link-down and link-up. This can be done as
> +   a separate preparation commit.
>
> -   An example of this preparation can be found in git commit fc548b991fb0.
> +   An older example of this preparation can be found in git commit
> +   fc548b991fb0, although this was splitting into three parts; the
> +   link-up part now includes configuring the MAC for the link settings.
> +   Please see :c:func:`mac_link_up` for more information on this.
>
>  2. Replace::
>
> @@ -207,6 +210,14 @@ this documentation.
>     using. This is particularly important for in-band negotiation
>     methods such as 1000base-X and SGMII.
>
> +   The :c:func:`mac_link_up` method is used to inform the MAC that the
> +   link has come up. The call includes the negotiation mode and interface
> +   for reference only. The finalised link parameters are also supplied
> +   (speed, duplex and flow control/pause enablement settings) which
> +   should be used to configure the MAC when the MAC and PCS are not
> +   tightly integrated, or when the settings are not coming from in-band
> +   negotiation.
> +
>     The :c:func:`mac_config` method is used to update the MAC with the
>     requested state, and must avoid unnecessarily taking the link down
>     when making changes to the MAC configuration.  This means the

Just to make sure I understand the changes:
- A MAC with no PCS can be configured in either .mac_config or .mac_link_up
- A MAC that needs to be manually reconfigured to the link mode
negotiated by its PCS needs to have the PCS configured in .mac_config
and the MAC in .mac_link_up
- A MAC with PCS where the MAC follows the PCS negotiation
automatically in hardware is basically equivalent with a MAC with no
PCS, and therefore can be configured in either .mac_config or
.mac_link_up
Is this correct?

Regards,
-Vladimir
