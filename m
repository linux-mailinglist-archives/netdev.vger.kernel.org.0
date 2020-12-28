Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B353B2E6C64
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgL1Wzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729410AbgL1UXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 15:23:46 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40436C061798
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 12:23:06 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id p14so9814572qke.6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 12:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9EpTdIYOFXIEGqAx9s+sFGrEVZtrYKtNXXy9SEY9qRE=;
        b=XzEoX7se7gdT+PPesqt7TRoQ5DJYbGHBQPFSEnWBTeaycsn8zErxFaVUwZ6O0/eBQX
         JvXxcj07SrGRt8NC+oCDbEX8H9ZEy8wQwyzMPGTYjfgh5PwbOjZCH4sux40D36rzbCl8
         a5zKHuOxyxEYgEc6rSpQIj9wvML1U7hH2O23Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9EpTdIYOFXIEGqAx9s+sFGrEVZtrYKtNXXy9SEY9qRE=;
        b=K2OZe9B0PlWVcCu6yPYeD6cj8sDBr0r/gfynol4A6dgB6FuW9zKdpycUxijdzyJeZs
         yvc88r5kNwkTiCca8zWZtKI8zNW3yt/V1cbexlLujq8tj5CFClzYoKoK2JokRUjBhnUX
         3IEAtI8IFL7lbfSsaa4WuOxxZ9sYtn1H9ouDhuFbZ0T7FJwOGBYCfP6wi62a8JOXGV8x
         MkwmkX5jSpG8XRPhGnjnoO8ss5+cDcZMRBmrKZmsSkR7fTEfWaceQ6nvB9Q8w4bE7/tZ
         LelmneNYiKbARfcSKQu0H/HKKUphGIk0dNQ9G5y0voVo8tabqYdq+z6nGrhgckeVV+4O
         pkAA==
X-Gm-Message-State: AOAM532CbvQ5+TJRWASVqqb8Y8lE2memfKz3+I+hgoEPrJkHolkYA08C
        lRsnxffKQYu4a6QZ33jqhIuGpgtEZZmiMlp7
X-Google-Smtp-Source: ABdhPJxq/0XcSIyWLCuk2o5XNjIVM6Bureox3/RV7HCZzpMA0Y+pdx2v3wSOCsNVXetAzx3iObNPoQ==
X-Received: by 2002:a37:b543:: with SMTP id e64mr37520059qkf.10.1609186985195;
        Mon, 28 Dec 2020 12:23:05 -0800 (PST)
Received: from chatter.i7.local ([89.36.78.230])
        by smtp.gmail.com with ESMTPSA id g26sm24036747qkl.60.2020.12.28.12.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 12:23:04 -0800 (PST)
Date:   Mon, 28 Dec 2020 15:23:02 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
Message-ID: <20201228202302.afkxtco27j4ahh6d@chatter.i7.local>
References: <20201223110615.31389-1-dinghao.liu@zju.edu.cn>
 <20201223153304.GD3198262@lunn.ch>
 <20201223123218.1cf7d9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201223210044.GA3253993@lunn.ch>
 <20201223131149.15fff8d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <680850a9-8ab0-4672-498e-6dc740720da3@gmail.com>
 <20201223174146.37e62326@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201224180631.l4zieher54ncqvwl@chatter.i7.local>
 <fc7be127-648c-6b09-6f00-3542e0388197@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fc7be127-648c-6b09-6f00-3542e0388197@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 24, 2020 at 01:57:40PM -0800, Florian Fainelli wrote:
> >> Konstantin, would you be willing to mod the kernel.org instance of
> >> patchwork to populate Fixes tags in the generated mboxes?
> > 
> > I'd really rather not -- we try not to diverge from project upstream if at all
> > possible, as this dramatically complicates upgrades.
> 
> Well that is really unfortunate then because the Linux developer
> community settled on using the Fixes: tag for years now and having
> patchwork automatically append those tags would greatly help maintainers.

I agree -- but this is something that needs to be implemented upstream.
Picking up a one-off patch just for patchwork.kernel.org is not the right way
to go about this.

-K
