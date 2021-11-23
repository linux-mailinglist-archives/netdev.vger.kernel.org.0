Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8243645AF18
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 23:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhKWWeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 17:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhKWWea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 17:34:30 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B042EC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:31:21 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id p19so749117qtw.12
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e1MHoVIQ7VWLpMYL3DiSa1iMpQLfgouyOY2dzL1fhzQ=;
        b=oWpwGu/W6E3wTwqCM1OVTquUAAMbxFxnE47D3De51Q0G45xvGtwoo33IF7DqbiSaFZ
         jOn2y2rxv8yB8APkK4dIe4bpd6NgrJjrO7/k+74G8JeGQY7yFplm1jerHw8AaYzMc6bw
         Fm3jcci+aO3l+QH8LP4MHRjvyBCQloy7NyR3WwoJf0bxwJ25hkYjBHmJeMR2uhvLiXxB
         CE4i/Iv17EgcRvzshj4LcfuvfjMZ9EvrIRXvhr7uZKsjSgx5aZ+H+3JxuQbRJSIBdfCr
         /Y1/OEGE+t8ZrSWa/r96HIbyxejIB+5um1T6AdS8at8wAjTKcrUFIjKTESyPYXLnUZ9q
         x0fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e1MHoVIQ7VWLpMYL3DiSa1iMpQLfgouyOY2dzL1fhzQ=;
        b=T6HEp8EOCsh3h6knqvZgsJUiXEq/2WRZ7/Rg2xqkPAc4JsGhOPb77BEqoIh4/+f9/k
         4sPAbMiMHXbmH9vQ11yxsXAwUletSk11QWAmJ0ayYNELOBzbG+R/kYXNUTDjSFX3jSuS
         EddwYQaLqHw0Fn/I4YgViN0IoCfOYr8PrYN50b5JgJXMLkTW0Xv+KuxgjYws8ebyB25j
         ri1j53P5QrDQCJxLp3XOmfNmFpsdBJrTwvk4Rto4Aay+7XgNva4FIRA2//tp2CpY0mXR
         Ouy0EIQc6va0FOSA9SvpePkCgTNvG76WeUSd5nCKiDDvdKo41s5E++BbdemG5aM+9zBy
         4dfA==
X-Gm-Message-State: AOAM5321V7uZnvkzu7fnhR2UIaS+BB6759WxOdI17LfICcvrVN3seWZJ
        1KU26mf+oqTgDPEA/ibi1Ys=
X-Google-Smtp-Source: ABdhPJx2HkJZDBhjroPBQtNTeoKbRKc+swGP5f+F167xccQ42/dmt7ZxV1xHbxcSRLeW2SjTy2nZVA==
X-Received: by 2002:ac8:5f4b:: with SMTP id y11mr1055823qta.285.1637706680874;
        Tue, 23 Nov 2021 14:31:20 -0800 (PST)
Received: from work ([187.105.166.74])
        by smtp.gmail.com with ESMTPSA id g19sm6982418qtg.82.2021.11.23.14.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 14:31:20 -0800 (PST)
Date:   Tue, 23 Nov 2021 19:31:14 -0300
From:   Alessandro B Maurici <abmaurici@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] phy: fix possible double lock calling link changed
 handler
Message-ID: <20211123193114.346852d6@work>
In-Reply-To: <06d158a7-4b1f-d635-2de8-7b34b9c2b0c2@gmail.com>
References: <20211122235548.38b3fc7c@work>
        <YZxrhhm0YdfoJcAu@lunn.ch>
        <20211123014946.1ec2d7ee@work>
        <017ea94f-7caf-3d4e-5900-aa23a212aa26@gmail.com>
        <YZz2irnGkrVQPjTb@lunn.ch>
        <20211123130634.14fa4972@work>
        <06d158a7-4b1f-d635-2de8-7b34b9c2b0c2@gmail.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 21:32:56 +0100
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> Great that you have test hw, could you please test the following patch?
> The duplex argument of lan743x_phy_update_flowcontrol() seems to be some
> leftover, it isn't used and can be removed.
> 
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index 4fc97823b..7d7647481 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -914,8 +914,7 @@ static int lan743x_phy_reset(struct lan743x_adapter *adapter)
>  }
>  
>  static void lan743x_phy_update_flowcontrol(struct lan743x_adapter *adapter,
> -					   u8 duplex, u16 local_adv,
> -					   u16 remote_adv)
> +					   u16 local_adv, u16 remote_adv)
>  {
>  	struct lan743x_phy *phy = &adapter->phy;
>  	u8 cap;
> @@ -943,7 +942,6 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
>  
>  	phy_print_status(phydev);
>  	if (phydev->state == PHY_RUNNING) {
> -		struct ethtool_link_ksettings ksettings;
>  		int remote_advertisement = 0;
>  		int local_advertisement = 0;
>  
> @@ -980,18 +978,14 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
>  		}
>  		lan743x_csr_write(adapter, MAC_CR, data);
>  
> -		memset(&ksettings, 0, sizeof(ksettings));
> -		phy_ethtool_get_link_ksettings(netdev, &ksettings);
>  		local_advertisement =
>  			linkmode_adv_to_mii_adv_t(phydev->advertising);
>  		remote_advertisement =
>  			linkmode_adv_to_mii_adv_t(phydev->lp_advertising);
>  
> -		lan743x_phy_update_flowcontrol(adapter,
> -					       ksettings.base.duplex,
> -					       local_advertisement,
> +		lan743x_phy_update_flowcontrol(adapter, local_advertisement,
>  					       remote_advertisement);
> -		lan743x_ptp_update_latency(adapter, ksettings.base.speed);
> +		lan743x_ptp_update_latency(adapter, phydev->speed);
>  	}
>  }
>  

Patch tested and working as expected.

Alessandro
