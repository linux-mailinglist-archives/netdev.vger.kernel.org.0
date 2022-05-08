Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BA251EEEF
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 18:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiEHQXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 12:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiEHQXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 12:23:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41227C3F;
        Sun,  8 May 2022 09:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCD9F61238;
        Sun,  8 May 2022 16:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1B3C385A4;
        Sun,  8 May 2022 16:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652026782;
        bh=zrC5JzfMZu1blCIF9XsTPjYQwlFVmczwl6h74uQUH+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JDSspYlDJl4dy8dwZzEU663/k0P+Hhpso4lFI1e63KrMQzIjklnIgAu21XeIEAWPv
         5YdkOhdG0+3xgVNyhbdHCAB1MocIsVBHqmO7jZmKdCtqGz3cI3WfSBWL4c856Hhbfu
         /rYs0523exg0XnDCkmqMRzxXkY8Sb+HyGJ0y+kx+ySaDjY1dUuktcXBZSApJ4kCTDr
         D7pdX7iZ/T89KI7FyHgb0KZPDi7X4MxYC2yVIyMyulcRg56CmDdJsz8PnqNiEookNZ
         F4oXGB/WMD2R1XHT89heI1MtEGBVVeDL7zVoO6bJlP6vt9/CGHhInNnJ0kzzml9Ib9
         Ui0cbCBLwqEZw==
Received: by pali.im (Postfix)
        id 619877F7; Sun,  8 May 2022 18:19:39 +0200 (CEST)
Date:   Sun, 8 May 2022 18:19:39 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: sfp: Add tx-fault workaround for Huawei MA5671A
 SFP ONT
Message-ID: <20220508161939.wk5c6sjkakzhqrz7@pali>
References: <20220502223315.1973376-1-mnhagan88@gmail.com>
 <20220508161712.wgzrq3wigaa7kobh@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220508161712.wgzrq3wigaa7kobh@pali>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday 08 May 2022 18:17:12 Pali Rohár wrote:
> On Monday 02 May 2022 23:33:15 Matthew Hagan wrote:
> > As noted elsewhere, various GPON SFP modules exhibit non-standard
> > TX-fault behaviour. In the tested case, the Huawei MA5671A, when used
> > in combination with a Marvell mv88e6085 switch, was found to
> > persistently assert TX-fault, resulting in the module being disabled.
> 
> Hello! I have some other GPON SFP modules with this issue... which has
> inverted TX-fault signal.

Anyway, I'm planning to send patches for fixing other GPON modules...

> > This patch adds a quirk to ignore the SFP_F_TX_FAULT state, allowing the
> > module to function.
> 
> I think that you should rather invert TX-fault signal, instead of
> masking it.
> 
> > Change from v1: removal of erroneous return statment (Andrew Lunn)
> > 
> > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> > ---
> >  drivers/net/phy/sfp.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> > index 4dfb79807823..9a5d5a10560f 100644
> > --- a/drivers/net/phy/sfp.c
> > +++ b/drivers/net/phy/sfp.c
> > @@ -250,6 +250,7 @@ struct sfp {
> >  	struct sfp_eeprom_id id;
> >  	unsigned int module_power_mW;
> >  	unsigned int module_t_start_up;
> > +	bool tx_fault_ignore;
> >  
> >  #if IS_ENABLED(CONFIG_HWMON)
> >  	struct sfp_diag diag;
> > @@ -1956,6 +1957,12 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
> >  	else
> >  		sfp->module_t_start_up = T_START_UP;
> >  
> > +	if (!memcmp(id.base.vendor_name, "HUAWEI          ", 16) &&
> > +	    !memcmp(id.base.vendor_pn, "MA5671A         ", 16))
> > +		sfp->tx_fault_ignore = true;
> > +	else
> > +		sfp->tx_fault_ignore = false;
> > +
> >  	return 0;
> >  }
> >  
> > @@ -2409,7 +2416,10 @@ static void sfp_check_state(struct sfp *sfp)
> >  	mutex_lock(&sfp->st_mutex);
> >  	state = sfp_get_state(sfp);
> >  	changed = state ^ sfp->state;
> > -	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
> > +	if (sfp->tx_fault_ignore)
> > +		changed &= SFP_F_PRESENT | SFP_F_LOS;
> > +	else
> > +		changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
> >  
> >  	for (i = 0; i < GPIO_MAX; i++)
> >  		if (changed & BIT(i))
> > -- 
> > 2.27.0
> > 
