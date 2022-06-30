Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CC9561BB3
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbiF3NrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 09:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbiF3NrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 09:47:04 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342372CDEE
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 06:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656596822; x=1688132822;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rAFoNgE7UKxfiOfiQnWbDCYY+hwJGeOrHVMywG18ews=;
  b=Q7oCpY8vF9D4d4CbCPJAirxHSl7AR3MjLhWuSl8J5MbnINAUBcAJmFnq
   c5EdfDODtMaSYk5IT0V//0DomQJNU2EM1R+BjcL2CUbkLjSD3xK8ZuArY
   0wj5qUQKkYtvkQ9TEqAcRKeGamDYBzScJCo2pejLN3sN8H1A8KeL13A8M
   UFa3KDmY7sNPRSvY/A9EvbEfnL/WT3KUfjD2bydoF+PMNgfb8pDZgYkZv
   Ym4dJf6zmoQihIFDdJcBmTdvVxyXwQaQ6QvZGgXC+4yyYTL20vlIXVQS1
   ZYGLUGwW8XjcsdRCU2T1AvkykbS7PEsxi+Bp//D5eQaSzUysdmGtHVpEM
   A==;
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="170260032"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 06:47:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 06:46:58 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 06:46:56 -0700
Message-ID: <bfe3b0a0-5f42-6c32-6de7-4d989544e488@microchip.com>
Date:   Thu, 30 Jun 2022 15:46:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next] net: phylink: fix NULL pl->pcs dereference
 during phylink_pcs_poll_start
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>,
        Santiago Esteban <Santiago.Esteban@microchip.com>
References: <20220629193358.4007923-1-vladimir.oltean@nxp.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20220629193358.4007923-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir, Russell,

On 29/06/2022 at 21:33, Vladimir Oltean wrote:
> The current link mode of the phylink instance may not require an
> attached PCS. However, phylink_major_config() unconditionally
> dereferences this potentially NULL pointer when restarting the link poll
> timer, which will panic the kernel.
> 
> Fix the problem by checking whether a PCS exists in phylink_pcs_poll_start(),
> otherwise do nothing. The code prior to the blamed patch also only
> looked at pcs->poll within an "if (pcs)" block.
> 
> Fixes: bfac8c490d60 ("net: phylink: disable PCS polling over major configuration")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>   drivers/net/phy/phylink.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 1a7550f5fdf5..48f0b9b39491 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -766,7 +766,7 @@ static void phylink_pcs_poll_stop(struct phylink *pl)
>   
>   static void phylink_pcs_poll_start(struct phylink *pl)
>   {
> -	if (pl->pcs->poll && pl->cfg_link_an_mode == MLO_AN_INBAND)
> +	if (pl->pcs && pl->pcs->poll && pl->cfg_link_an_mode == MLO_AN_INBAND)
>   		mod_timer(&pl->link_poll, jiffies + HZ);
>   }
>   

Fixes the NULL pointer on my boards:
Tested-by: Nicolas Ferre <nicolas.ferre@microchip.com> # on sam9x60ek

Best regards,
   Nicolas


-- 
Nicolas Ferre
