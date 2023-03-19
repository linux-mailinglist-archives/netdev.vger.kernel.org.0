Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C846C007F
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 11:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjCSKGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 06:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCSKGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 06:06:15 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCA019BA
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 03:06:12 -0700 (PDT)
Received: from thinkpad (unknown [172.20.6.87])
        by mail.nic.cz (Postfix) with ESMTPS id 8EF421C182C;
        Sun, 19 Mar 2023 11:06:07 +0100 (CET)
Authentication-Results: mail.nic.cz;
        none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1679220368; bh=oleRbfcFPLhdNwKjQV2gLOZht2FchLMSwi51SD7t7tE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From:Reply-To:
         Subject:To:Cc;
        b=a2MTAk/+y4NweNCmQnuTC7XuTrIsJ6oWxRNH5jl86zi/IebxC/wJfHzZhrpu72P5l
         MMqttKTIG45cc+iqckRsuNvif3x/DVl1Uaf/NYJTwCr+PJy4oRo5yda3jC6dA5znUe
         W8SR7Q+FBLGrxpE7SpG13QWTgeX/TWx/hBrVXuSU=
Date:   Sun, 19 Mar 2023 11:06:06 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 4/4] net: dsa: mv88e6xxx: mask apparently
 non-existing phys during probing
Message-ID: <20230319110606.23e30050@thinkpad>
In-Reply-To: <20230315163846.3114-5-klaus.kudielka@gmail.com>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
        <20230315163846.3114-5-klaus.kudielka@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.35; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.7 at mail
X-Virus-Status: Clean
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: WHITELISTED_IP
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Rspamd-Server: mail
X-Rspamd-Queue-Id: 8EF421C182C
X-Spamd-Bar: /
X-Spamd-Result: default: False [-0.10 / 20.00];
        MIME_GOOD(-0.10)[text/plain];
        ARC_NA(0.00)[];
        FREEMAIL_TO(0.00)[gmail.com];
        FROM_EQ_ENVFROM(0.00)[];
        TAGGED_RCPT(0.00)[];
        FROM_HAS_DN(0.00)[];
        FREEMAIL_ENVRCPT(0.00)[gmail.com];
        WHITELISTED_IP(0.00)[172.20.6.87];
        MIME_TRACE(0.00)[0:+]
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 17:38:46 +0100
Klaus Kudielka <klaus.kudielka@gmail.com> wrote:

> To avoid excessive mdio bus transactions during probing, mask all phy
> addresses that do not exist (there is a 1:1 mapping between switch port
> number and phy address).
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> 
> Notes:
>     v2: Patch is new
> 
>  drivers/net/dsa/mv88e6xxx/chip.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 29b0f3bb1c..c52798d9ce 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -3797,6 +3797,7 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
>  	bus->read_c45 = mv88e6xxx_mdio_read_c45;
>  	bus->write_c45 = mv88e6xxx_mdio_write_c45;
>  	bus->parent = chip->dev;
> +	bus->phy_mask = GENMASK(31, mv88e6xxx_num_ports(chip));

shouldnt this be
  GENMASK(31, mv88e6xxx_num_ports(chip) + chip->info->phy_base_addr) |
  GENMASK(chip->info->phy_base_addr, 0)
?
Or alternatively
  ~GENMASK(chip->info->phy_base_addr + mv88e6xxx_num_ports(chip),
           chip->info->phy_base_addr)

Marek
