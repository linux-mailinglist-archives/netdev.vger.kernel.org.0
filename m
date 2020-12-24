Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7222E287E
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 19:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgLXSHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 13:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgLXSHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 13:07:15 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C6AC061573
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 10:06:35 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id 22so2588613qkf.9
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 10:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vWUZz1Io2zg9e+pgMYCpaOSykFlhfnxpcEv2UfdXqJo=;
        b=FfetDuB79mVxzySbkCjgms2U52xpAI8RugzM4QYDKBcjADflHgX59DD0tj7/qhKFdt
         t0UwI/kjCjlywkBk+14S+fF/Pu/4Px8EklgoWfeAwlntfztM6GrhsKed+gShaq/NaujG
         8mvqbK1WG5pmK2xuJBMLYeNuB3pSfIW2O4JjI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vWUZz1Io2zg9e+pgMYCpaOSykFlhfnxpcEv2UfdXqJo=;
        b=Cmb+zRDCaZIeXhTlaaHFKddttZx9YIQC/SeArvxOXs8lk99HbtpwY3XjkJ61Yyaf75
         LQyqjOpReeRSn05CKIQiibjFwitWw5rkZAusijKYEVIkcCVXGx66uRzji/Vaa541ZkiL
         kXruDzoFccc/eukpYIeQX83WrMwmzULpyuXB8g3sScf6iR44mRaRH+Teirb0iO6aghtz
         Y9eyFvPT0qr/Jt3A2G3kbuhRko/LnZin8X/nN8b1uKH8cKdYKXXKoJVLT2R8hh/32oLE
         n/GgAEOqiesdxjmQPTNOLU3Ip6X1i16Cmq/6ZxhXXcVeGh3Lrha/za9xCmrVYcPbr6gx
         +bTg==
X-Gm-Message-State: AOAM531wpmqhrSBs+/QdfKqB86mLho6M7qZ1Xq7wTHgVVIH+PAXJHeK9
        R2oTr6iwUHUoBdlZ3aKxzBklxSduwXOJZ5ru
X-Google-Smtp-Source: ABdhPJzxAqlogi2LTj9IG0vhnXPUeflayrdtuFjjzJAZnU8eg35Jp/up/+KQCGrCpX+1w4U596d7hA==
X-Received: by 2002:a05:620a:625:: with SMTP id 5mr31340274qkv.498.1608833194108;
        Thu, 24 Dec 2020 10:06:34 -0800 (PST)
Received: from chatter.i7.local ([89.36.78.230])
        by smtp.gmail.com with ESMTPSA id c14sm15584486qtc.90.2020.12.24.10.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 10:06:33 -0800 (PST)
Date:   Thu, 24 Dec 2020 13:06:31 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
Message-ID: <20201224180631.l4zieher54ncqvwl@chatter.i7.local>
References: <20201223110615.31389-1-dinghao.liu@zju.edu.cn>
 <20201223153304.GD3198262@lunn.ch>
 <20201223123218.1cf7d9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201223210044.GA3253993@lunn.ch>
 <20201223131149.15fff8d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <680850a9-8ab0-4672-498e-6dc740720da3@gmail.com>
 <20201223174146.37e62326@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201223174146.37e62326@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 05:41:46PM -0800, Jakub Kicinski wrote:
> > >> Does patchwork not automagically add Fixes: lines from full up emails?
> > >> That seems like a reasonable automation.  
> > > 
> > > Looks like it's been a TODO for 3 years now:
> > > 
> > > https://github.com/getpatchwork/patchwork/issues/151  
> > 
> > It was proposed before, but rejected. You can have your local patchwork
> > admin take care of that for you though and add custom tags:
> > 
> > https://lists.ozlabs.org/pipermail/patchwork/2017-January/003910.html
> 
> Konstantin, would you be willing to mod the kernel.org instance of
> patchwork to populate Fixes tags in the generated mboxes?

I'd really rather not -- we try not to diverge from project upstream if at all
possible, as this dramatically complicates upgrades.

-K
