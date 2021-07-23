Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52563D3A10
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 14:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbhGWLlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 07:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbhGWLln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 07:41:43 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69492C061575;
        Fri, 23 Jul 2021 05:22:16 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ga41so3258354ejc.10;
        Fri, 23 Jul 2021 05:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s/UNyVSx8Uo8huA1dZoq7cmEWQXga5WOzxahb6SPanE=;
        b=spCzqL16k4og6Li/5mUP8qW1wHvemfyaK7LcMUQ2WUOE4RsI1R42VWeW0DfONY5HLG
         NZiM9XvdMnGsc7pa4tNFJRJWa83bIh038C9TFG++GaLIfq47SUEl3QslfxM1ejaLGpOm
         M/7vhUyMjcC/GdwlJQT7dDS/7c4dQ4omyNQEjwVlrqCOyoqX8DJAvcuKwytGc6jsIJFL
         kmMfTNQH7Gb7nbqi6ZoVdrQxk7UDO7eK5xG0okoMJaNecTFWutK+g7M8BagHLyKWh3wz
         /oITIBIYFkqNTt0eEuCbhYfH7J4lEbArXrhKhX1kR6iFE4vReaMJY+3CEvj71RS1OuMF
         4k2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s/UNyVSx8Uo8huA1dZoq7cmEWQXga5WOzxahb6SPanE=;
        b=SRPcHuvb+kEGQmrf4Wq9QGsrCG7fIpUxfaBhCQJKetaG8op5bkz4g9cNElPZRxT2rJ
         UeX9RLdWBLvkyd7u2SloPemMNMhhJABBo2g2c2/Do+f43NjIlENVLG/DTss9cu2X1qKs
         BmEgdr0KnIqxiygm6fKBnSl8MuOPx/STCGdVFz1v6rEvVfQH0aLl3I18GU0Ibs5ZAof8
         0ArvH7yHnQ0NBz1uOXyIdHWwNSsl2Thk0/K/zDvfB4hFuLOPN5LtyVnLQzVmSE5B8XWD
         ETEFPGtcYDVjhAIZixbWkAlrqujqkftHbMuMM2g7gjudEqdvRXby2gE3LgE17Jzn4lMH
         V0MA==
X-Gm-Message-State: AOAM530Ix/7U01ONlWd3LhcQPFVs1g2c2hOlfDAl+7wNYUgoeU7ohiiK
        o0pLjqnWtucdzyj9TeyG9/Q=
X-Google-Smtp-Source: ABdhPJxbT/tsVsxRsuDbiBAibpeRekVmHirhKMo9QMEGiCD7DOP56DrA68ISPUr3a7I7OX4vdyLpyA==
X-Received: by 2002:a17:906:a896:: with SMTP id ha22mr4294991ejb.479.1627042934954;
        Fri, 23 Jul 2021 05:22:14 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id hb7sm10593712ejb.18.2021.07.23.05.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 05:22:14 -0700 (PDT)
Date:   Fri, 23 Jul 2021 15:22:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: dsa: ensure linearized SKBs in case of tail
 taggers
Message-ID: <20210723122213.fvhudwyk36u7pw52@skbuf>
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
 <20210721215642.19866-2-LinoSanfilippo@gmx.de>
 <20210721233549.mhqlrt3l2bbyaawr@skbuf>
 <8460fa10-6db7-273c-a2c2-9b54cc660d9a@gmail.com>
 <YPl9UX52nfvLzIFy@lunn.ch>
 <7b99c47a-1a3e-662d-edcd-8c91ccb3911e@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b99c47a-1a3e-662d-edcd-8c91ccb3911e@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 09:47:39AM +0200, Lino Sanfilippo wrote:
> since I got a message that the patches have already been applied to netdev/net.git.
> How should I proceed if I want to send a new version of the series? Just ignore the
> merge to netdev and send the patches nevertheless?

Since the git history is immutable you need to work with what is already
in the current net/master branch. What do you want to change, just
address the feedback I gave? If that is all, just don't bother, I intend
to look at adding a framework through which the DSA master can declare
what features it supports in conjunction with specific DSA tagging protocols.
That is material for net-next, and Dave took your patch at the last
minute for the "net" pull request towards Linus' tree. If you send
another patch on "net" in that area now, we'd have to wait for another
week or two until "net" will be merged again into "net-next". Not sure
if it's worth it. The only thing that was of concern to me is that you
assign the DSA interface's slave->vlan_features = master->vlan_features.
So even though you clear the NETIF_F_SG feature for the DSA slave
interface, VLAN uppers on top of DSA interfaces will still have NETIF_F_SG.
However, those skbs will be linearized during the dev_queue_xmit call
done by the 8021q driver towards DSA, so in the end, the way in which
you restructured the code may not be cosmetically ideal, but also
appears to not be functionally problematic.
Anyway, your patch will probably conflict with the stable trees (the
tag_ops->needed_tailroom was introduced very recently), so we will have
another chance to fix it up when Greg sends the email that the patch
failed to apply.
