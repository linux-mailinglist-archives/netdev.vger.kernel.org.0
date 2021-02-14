Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41C631AEBD
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 03:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBNCZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 21:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhBNCZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 21:25:22 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB73C061574;
        Sat, 13 Feb 2021 18:24:42 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y18so4217909edw.13;
        Sat, 13 Feb 2021 18:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f45bxa+6F5a5L8NPuEqVx9SSK6PBkhxMAl0f7anaJW0=;
        b=itchvTjJBfnpN9YpOw6n6U0TOPafmLFEws6/f8mZ5AL//l+cY2IebMCuYz6KfD9RYq
         OimY+titWxZDmvRs1nILKZihBxMxIQdDT27Yei7/b7Zy9XAD3+cvEan9QURDY1at1rZp
         HzOUTXtbFtjsmNAuzJ5Lj7R6UjEkKLDwkARTkpS52Hb7x0wynvM1P905SHVqM16Rb+pY
         sBu4oM/pY74KnCyXlG9ng+5F1yzdIv/tnLGmtgO5CUwZfawEBxFMB1d+pbDM4xzQdXrc
         sCIF1duW37LeJYals8W107Mxz8clIzBoZFwH/FD/zelfxxhJICX2TB9FsMLSpYf1gag+
         Yr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f45bxa+6F5a5L8NPuEqVx9SSK6PBkhxMAl0f7anaJW0=;
        b=MWQoJq14AAdDk1HHB54jazVziIqn0sTKOplEgwLkMN5Nz591qrTng6LA1r8/G/yDgd
         xpqiDpDvbwVZXsK9kqnUMnB83VNR5/kbUuffj0NBQDeBRolxr7DcdA3KFU6HzEwdhTBe
         KtnGcUmkbZptYOAep3/Pgvb+atUA/xiGM+u/IYsDiAzp35RAlRRC1srjZFG2AjQGvKyn
         tTZJ7DFXl051Ja7zN/AdIuRPm9o8h6kHzsLKzNzNdKgFZPSurnnHShIelch9NxqAnnZ4
         30xlNhqyLHuiGErhm/9ZwkjhgJggUbaWCFs8o6chEKAD0GULlZRi7z43NG34hTTR+vEh
         sgNA==
X-Gm-Message-State: AOAM533BAMs5Z6sEPNP2iofOdw8RtPKWRHDeciYrHTLtEtkgauRSUKHg
        ZVhJjRwvK2vMdF+QKeg/3GY=
X-Google-Smtp-Source: ABdhPJx7BLs+08eVy+iq4A2K9puZvK/xotvE8V0/Uz1Uj+K3fgNNdJtqZcBqqW61AP+CU316gMH1gA==
X-Received: by 2002:a50:bb05:: with SMTP id y5mr2965358ede.307.1613269480993;
        Sat, 13 Feb 2021 18:24:40 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k13sm1126728edq.81.2021.02.13.18.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 18:24:40 -0800 (PST)
Date:   Sun, 14 Feb 2021 04:24:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 2/2] net: phy: at803x: use proper locking in
 at803x_aneg_done()
Message-ID: <20210214022439.cyrfud4ahj4fzk7e@skbuf>
References: <20210214010405.32019-1-michael@walle.cc>
 <20210214010405.32019-3-michael@walle.cc>
 <20210214015733.tfodqglq4djj2h44@skbuf>
 <4ABD9AA0-94A3-4417-B6B2-996D193FB670@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABD9AA0-94A3-4417-B6B2-996D193FB670@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 03:18:49AM +0100, Michael Walle wrote:
> Am 14. Februar 2021 02:57:33 MEZ schrieb Vladimir Oltean <olteanv@gmail.com>:
> >Hi Michael,
> >
> >On Sun, Feb 14, 2021 at 02:04:05AM +0100, Michael Walle wrote:
> >> at803x_aneg_done() checks if auto-negotiation is completed on the
> >SGMII
> >> side. This doesn't take the mdio bus lock and the page switching is
> >> open-coded. Now that we have proper page support, just use
> >> phy_read_paged(). Also use phydev->interface to check if we have an
> >> SGMII link instead of reading the mode register and be a bit more
> >> precise on the warning message.
> >>
> >> Signed-off-by: Michael Walle <michael@walle.cc>
> >> ---
> >
> >How did you test this patch?
>
> I'm afraid it's just compile time tested.

I'm asking because at803x_aneg_done has been dead code for more than 2
years now. Unreachable. And while it was reachable it was buggy and an
abuse of the phylib API. So you might want to just delete this function
instead. Context:
https://lkml.org/lkml/2020/5/30/375
