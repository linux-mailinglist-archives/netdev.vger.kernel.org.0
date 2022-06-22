Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B280F554FA3
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357300AbiFVPm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359422AbiFVPmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:42:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 272383CA7A
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655912543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lYg19QbrWLn+AB4CBMITi/5vzGTh85mgQgsOKd71tIk=;
        b=VPPozl3KMciA5xP6AF3DBtrYlYcdYbDV3WjpcI/Mp6+7caJl7QgY1hDFQu0iZBaZCXl+av
        gUcii3kSL0WnCS+1gHfdysDEifHji638zYHpyujeexIajuEhhQaqMV+2RlegLLikiN9EpB
        LFqm3pDBQPALBtc5pYDDzFtBxjDqndE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-epqpHMlSOYWwI8luh80lhw-1; Wed, 22 Jun 2022 11:42:22 -0400
X-MC-Unique: epqpHMlSOYWwI8luh80lhw-1
Received: by mail-qk1-f199.google.com with SMTP id t66-20020a372d45000000b006aee88c3281so1062925qkh.6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lYg19QbrWLn+AB4CBMITi/5vzGTh85mgQgsOKd71tIk=;
        b=slCIs375Og0ww3qYMfEjTEiW8graRdp4WtmFYd5CgLFMeOeBvp5a+d7kAZWB4jcS+H
         R/6qsWEKMq44ajC2YBkuS414oNxSyXK/8FXJn215Z1i4etgVOfeiWVdaTEWpd21e/GNu
         Og0uu0KyOdHsUCk4CmmukKRhjsX4RVMwiEsm+aqbnJhlyFJeqYxw1LQ49thlpGpS63gh
         81+ShiANSBBPLOlsCtYo+VD7PWluq17ob6RdGY4hbI2VEArGrbBI5XDFDtfRFpfXAdWs
         nw1FuNzqY8Xkis/JGfISotyXMa566JKNBBQk30KU2V+c7cYa/aB73LiETREkc6+A072k
         MPZw==
X-Gm-Message-State: AJIora+oEKi7KqoN11NOnOB60xl8jU5oL8AbJxsI0SLW/VNWqGirc9RG
        t8HO1+lZU3DpMyYkVhfNtFMoIN0nS/ENvR0Niyhcp3L/K6RiAlIS8/3lr5jXj3GzDGWGKQGbffH
        3JjRYh4be3g6btnx5
X-Received: by 2002:a37:a496:0:b0:6ae:d5d5:363c with SMTP id n144-20020a37a496000000b006aed5d5363cmr2749752qke.419.1655912541513;
        Wed, 22 Jun 2022 08:42:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1unfxWS+IItVoUrPS/ZynQUxJ44nF49/PHczgmjHHrxjB4tsB29fD/9ifOvCHj2fOin+q+Axw==
X-Received: by 2002:a37:a496:0:b0:6ae:d5d5:363c with SMTP id n144-20020a37a496000000b006aed5d5363cmr2749730qke.419.1655912541237;
        Wed, 22 Jun 2022 08:42:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id t12-20020a05620a450c00b006a746826feesm17452442qkp.120.2022.06.22.08.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 08:42:20 -0700 (PDT)
Message-ID: <cebed632d3337a40cedbf3da78ff1e1154b1ae3a.camel@redhat.com>
Subject: Re: [PATCH net-next] net: pcs: xpcs: depends on PHYLINK in Kconfig
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Date:   Wed, 22 Jun 2022 17:42:13 +0200
In-Reply-To: <20220622083521.0de3ea5c@kernel.org>
References: <6959a6a51582e8bc2343824d0cee56f1db246e23.1655797997.git.pabeni@redhat.com>
         <20220621125045.7e0a78c2@kernel.org>
         <YrMkEp6EWDvd3GT/@shell.armlinux.org.uk>
         <20220622083521.0de3ea5c@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-22 at 08:35 -0700, Jakub Kicinski wrote:
> On Wed, 22 Jun 2022 15:15:46 +0100 Russell King (Oracle) wrote:
> > > We can't use depends with PHYLINK, AFAIU, because PHYLINK is not 
> > > a user-visible knob. Its always "select"ed and does not show up
> > > in {x,n,menu}config.  
> > 
> > I'm not sure I understand the point you're making. You seem to be
> > saying we can't use "depend on PHYLINK" for this PCS driver, but
> > then you sent a patch doing exactly that.
> 
> Nuh uh, I sent a patch which does _select_ PHYLINK.
> 
> My concern is that since PHYLINK is not visible user will not be able
> to see PCS_XPCS unless something else already enabled PHYLINK.
> 
> I may well be missing some higher level relations here, on the surface
> "depending" on a symbol which is not user-visible seems.. unusual.
> 
> > As these PCS drivers are only usable if PHYLINK is already enabled,
> > there is a clear dependency between them and phylink. The drivers
> > that make use of xpcs are:
> > 
> > stmmac, which selects both PCS_XPCS and PHYLINK.
> > sja1105 (dsa driver), which selects PCS_XPCS. All DSA drivers depend
> > on NET_DSA, and NET_DSA selects PHYLINK.
> > 
> > So, for PCS_XPCS, PHYLINK will be enabled whenever PCS_XPCS is
> > selected. No other drivers in drivers/net appear to make use of
> > the XPCS driver (I couldn't find any other references to
> > xpcs_create()) so using "depends on PHYLINK" for it should be safe.
> > 
> > Moreover, the user-visible nature of PCS_XPCS doesn't add anything
> > to the kernel - two drivers require PCS_XPCS due to code references
> > to the xpcs code, these two select that symbol. Offering it to the
> > user just gives the user an extra knob to twiddle with no useful
> > result (other than more files to be built.)
> > 
> > It could be argued that it helps compile coverage, which I think is
> > the only reason to make PCS_XPCS visible... but then we get compile
> > coverage when stmmac or sja1105 are enabled.
> 
> Interesting, hiding PCS_XPCS sounds good then. PCS_LYNX is not visible.
> 
> diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
> index 22ba7b0b476d..9eb32220efea 100644
> --- a/drivers/net/pcs/Kconfig
> +++ b/drivers/net/pcs/Kconfig
> @@ -6,7 +6,7 @@
>  menu "PCS device drivers"
>  
>  config PCS_XPCS
> -	tristate "Synopsys DesignWare XPCS controller"
> +	tristate
>  	depends on MDIO_DEVICE && MDIO_BUS
>  	help
>  	  This module provides helper functions for Synopsys DesignWare XPCS
> 
@Jakub: please let me know if you prefer to go ahead yourself, or me
sending a v3 with 'depends PHYLINK' + the above (or any other option ;)

Thanks!

Paolo

