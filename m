Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F5D31AEB2
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 03:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBNB6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhBNB6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:58:17 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D16C061574;
        Sat, 13 Feb 2021 17:57:36 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id b9so5642472ejy.12;
        Sat, 13 Feb 2021 17:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K4u34jBgoN3pvvMfuoZWvbXvYcFuz5PwpprXBuuhQv0=;
        b=IzqDHceHBFxbk12UKfEeAoRQFJ2vXdSPlyWMGVk/swYicB8ozoQvdHuZqBJ6Bbb31f
         HuBBKruYuk91JIWbTzicTl3a8iuAcz+p5ruVLfTk8t94NYI/FitWChn65vcL1/I9pgX7
         yn7JvdDYfKJaIgCKjA680nepBB3AGXDP0pXFTeEt5acgHPfO/Vivf1t3dpNvLQ1YWwtH
         xaA6gpFj2xENuaQFmIZNchMDdJbDjWbk5gcPeuYil2sRw7bE2ckjHYI4a3Hf+CJ0QNmS
         oQRtpBFAxxPMVbOJJYwmAvXM4SOv+dGVvlAdBClcJx1ixDn1Uo8xDEgJEco4oEF9y4ik
         vMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K4u34jBgoN3pvvMfuoZWvbXvYcFuz5PwpprXBuuhQv0=;
        b=lVOA49IBr/nfWfw/lWAZV2UPhgch2p8gRh2mUMy485tlYqL0Ppa9TuIqPehpfg4w/b
         iF0F00sxxb9y2/eNmbTiVRtMv+ORkQCw5ye7Ne7e95fFFCFQRN1R7qypq6qlH+r/1Wxq
         bfUkBYRH1ub/yzuRouyiwxXz5QJNp6+suaUKxMZCKeEO40a5LogCPxJHN2aJhR1wBBOL
         kSmYgXlgycc29PKApDvyDT2vKhxphtqRbgcFw4CrBxrL9f6nKIxgb7dgAVd61SkIiRSJ
         29tveiz/PQL96MsIfErETkXIsP0gjhOqreaFDKH0G8LmTFDQjcSnn4pH1GMnerVn9K12
         4KYw==
X-Gm-Message-State: AOAM532KAqtXTZbHl6beVRxe+Mf578HujeYobdR5KcPG32Slw1Pw39iH
        C0BnWkzkjGL3HE9+2Xn1KZgwYl5WbcE=
X-Google-Smtp-Source: ABdhPJyHu8OErrJtbAzF3f+9zY793m6RFTXnXw5QUlP5tWApfTbdZOVV23bB7Cq7lrAIA6NCzE/a0w==
X-Received: by 2002:a17:906:a48:: with SMTP id x8mr9459263ejf.444.1613267855599;
        Sat, 13 Feb 2021 17:57:35 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id l24sm1071349edq.32.2021.02.13.17.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 17:57:35 -0800 (PST)
Date:   Sun, 14 Feb 2021 03:57:33 +0200
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
Message-ID: <20210214015733.tfodqglq4djj2h44@skbuf>
References: <20210214010405.32019-1-michael@walle.cc>
 <20210214010405.32019-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210214010405.32019-3-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Sun, Feb 14, 2021 at 02:04:05AM +0100, Michael Walle wrote:
> at803x_aneg_done() checks if auto-negotiation is completed on the SGMII
> side. This doesn't take the mdio bus lock and the page switching is
> open-coded. Now that we have proper page support, just use
> phy_read_paged(). Also use phydev->interface to check if we have an
> SGMII link instead of reading the mode register and be a bit more
> precise on the warning message.
>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

How did you test this patch?
