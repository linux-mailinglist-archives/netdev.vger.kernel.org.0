Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54D331C3A4
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBOVcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBOVct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 16:32:49 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E0BC061574;
        Mon, 15 Feb 2021 13:32:09 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r17so3278817edy.10;
        Mon, 15 Feb 2021 13:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a+i8LH/PcwLLtmLudhzON962m8PZ6C4JQBNhKKesSEE=;
        b=RYDcxzO1mpPLwg+IKOV59toc8r9MQ9PIcQf/F8XpPUoo4rgVdsfMp6F0ismnB9AfEX
         4ZefqedpMP8yEUxziHPhBM8n/9wJdexRAGSJ4Xnj1ekMbRL6F4VNO7mrJV8l1MV9WGhD
         N9Go4ToWtmERicdIEqJx9VsEU5gT+Ie06vFOt2YAHJ1BY2hTtMXzAlrOePSYUfa/UAl8
         p5hcrKwPgQ8VEdSzxbOOlFFYg2kgPXfmpG4An0UqOuqxjmq0fQaMQS1qiADvfR48UuQX
         yp3nTm1RNHeKhUPofcD0JwejCbwpVVdqNPuKNwOJSh+BBsl3NiUAsMGtGRAEOdlyJWRr
         VIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a+i8LH/PcwLLtmLudhzON962m8PZ6C4JQBNhKKesSEE=;
        b=mZTPBzlcOUSbBeS4lrP0uIZyDoKhBVw3b075OzxLqMZRA2YwK1Ovcvb7jMJzziVexR
         aaohQjJV2/OJN0se4NNTI3jdhRfocmSAobB+asBfIrk1pOHB4GdoqoZuOMulm7jlQ9uY
         s5z8Ut1V26B1utBN8U4UueV7GkP9qFKzKpw403fjMyOeS9SehvuDuor5CBKWqPHM5jzy
         8a++4mHELNintN5H8C70Wot8nVJCrt0bgiv/uUqQvo2PcGbtQ/tixhvv7BCZ9BwfhnMA
         8FNip04bod+jXeLGRFJC46+5/3aJPH0r3eXku9NTQq43yTSW5Gn8ZJGcpW8+i8XeFgRQ
         3aUw==
X-Gm-Message-State: AOAM530cMivWkdRrqqZWpZlVGdRSU+ujd338DT5Ft8obLGX0yARlt0QM
        ZPxFs2xw11RILPO//Vn6MQ4=
X-Google-Smtp-Source: ABdhPJysuri2sVJ5r4kDjVF9BbeXfcSnTaQkC6UULyjo5G3FTHHa9bEMe/UD8vawzvY6oj4zaeJqMQ==
X-Received: by 2002:a50:cf02:: with SMTP id c2mr17676860edk.333.1613424727639;
        Mon, 15 Feb 2021 13:32:07 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id r11sm11249670edt.58.2021.02.15.13.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 13:32:07 -0800 (PST)
Date:   Mon, 15 Feb 2021 23:32:06 +0200
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
Message-ID: <20210215213206.qhjiyk4ahg75v6d2@skbuf>
References: <20210214010405.32019-1-michael@walle.cc>
 <20210214010405.32019-3-michael@walle.cc>
 <20210214015733.tfodqglq4djj2h44@skbuf>
 <4ABD9AA0-94A3-4417-B6B2-996D193FB670@walle.cc>
 <20210214022439.cyrfud4ahj4fzk7e@skbuf>
 <758cac1a76541e0e419a54af14d0cd20@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <758cac1a76541e0e419a54af14d0cd20@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 09:48:53PM +0100, Michael Walle wrote:
> Am 2021-02-14 03:24, schrieb Vladimir Oltean:
> > On Sun, Feb 14, 2021 at 03:18:49AM +0100, Michael Walle wrote:
> > > Am 14. Februar 2021 02:57:33 MEZ schrieb Vladimir Oltean <olteanv@gmail.com>:
> > > >Hi Michael,
> > > >
> > > >On Sun, Feb 14, 2021 at 02:04:05AM +0100, Michael Walle wrote:
> > > >> at803x_aneg_done() checks if auto-negotiation is completed on the SGMII
> > > >> side. This doesn't take the mdio bus lock and the page switching is
> > > >> open-coded. Now that we have proper page support, just use
> > > >> phy_read_paged(). Also use phydev->interface to check if we have an
> > > >> SGMII link instead of reading the mode register and be a bit more
> > > >> precise on the warning message.
> > > >>
> > > >> Signed-off-by: Michael Walle <michael@walle.cc>
> > > >> ---
> > > >
> > > >How did you test this patch?
> > >
> > > I'm afraid it's just compile time tested.
> >
> > I'm asking because at803x_aneg_done has been dead code for more than 2
> > years now. Unreachable. And while it was reachable it was buggy and an
> > abuse of the phylib API. So you might want to just delete this function
> > instead. Context:
> > https://lkml.org/lkml/2020/5/30/375
>
> Are you sure? While it isn't called from phylib, it might be called from
> some drivers directly or indirectly if they use phy_speed_down().
> But it is questionable if this is much of a use then.
>
> That being said, if no one objects, I'd remove it, too.

It might, true, but it is certainly of no use.
