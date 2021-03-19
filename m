Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E92342884
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhCSWLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhCSWLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:11:35 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABB2C061760;
        Fri, 19 Mar 2021 15:11:24 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id o2so3580749plg.1;
        Fri, 19 Mar 2021 15:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t8WayWLX100d3xFTK35dbfG/wOjXzoQhDFEPaisQ7eI=;
        b=RgYIyxe03R+Jy1z5L+rb6cBGH2Qb1DV9sNFUQGfj69Kfmqk9/iJ8DECNE8GCDp+wCn
         /PF7C6qtlDAuxpn9q1vBh2yp+wopRHaskbwm8iUBK4oxiosKJKuOwA1QRhSE0P/dDyWZ
         7XsB4DtPLoeaw0se3lLaCLEdVwPO/kCEEboiOeeIUHYL4lHE5538KIl1yp02a2eBjVbs
         NlGryOafI/X9nfwfcJLpU5pRaFIF+A6TcAAXS5vzPQNccYAsP3gyCtbcMNuF0cITcctH
         9RTNBg7gfieIRBdDrM21dVFbAVaiZ5b6bwhjvBf6IeD2J6cy3rwUMjjE8QObI1ckiZOd
         v1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t8WayWLX100d3xFTK35dbfG/wOjXzoQhDFEPaisQ7eI=;
        b=oOAm1MbJ+uvyjx1oStEJSESEeiM57bYkJcKTPSnTQAL+yRyGOlH/nuKU6XGOJFslA1
         rl/RYBm2Mh7rK5M6vU8gOfJyutfskfEKIM6gH+dEI//k7aQaIwXoOUoLHhUixpnuhnM6
         sSEcZqLAfhGnhWImrwE5AejkF9b1U2e+1WtYNAsATznea6txP1+BMnwzsYr7TrkAvuFU
         KgUj3Q0xlXz1njh9IolgucIP6ePcIuJa/Em3svnOwAKMWLKgVmiS3s0I5H350Raa/1aZ
         cC9YV830pND5q0wVOTSXnzBkKcHlwOR+pPaxwg3hecsPtdE+NSli10yD24EdtuYNJYDe
         NS0g==
X-Gm-Message-State: AOAM5300nMFQFK7rZGe89/x/txjI/wufVH/jhoIlvlbh7I1sxJNBUoxG
        RFNQrSc4PdaeFdU3x5GZbf4=
X-Google-Smtp-Source: ABdhPJyisagm4D5zoRtKG3oF2VcxketjF4NttZj6PUIP0lph4ypKh2uzUvA8NEXKDH95sos75hrKuA==
X-Received: by 2002:a17:902:da92:b029:e5:fa64:e9f3 with SMTP id j18-20020a170902da92b02900e5fa64e9f3mr15916568plx.54.1616191883967;
        Fri, 19 Mar 2021 15:11:23 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id fa21sm6475082pjb.41.2021.03.19.15.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 15:11:23 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 04/16] net: dsa: sync up with bridge
 port's STP state when joining
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c8094b39-3a9c-88dc-1e4b-198a9ef0f93b@gmail.com>
Date:   Fri, 19 Mar 2021 15:11:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318231829.3892920-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It may happen that we have the following topology:
> 
> ip link add br0 type bridge stp_state 1
> ip link add bond0 type bond
> ip link set bond0 master br0
> ip link set swp0 master bond0
> ip link set swp1 master bond0
> 
> STP decides that it should put bond0 into the BLOCKING state, and
> that's that. The ports that are actively listening for the switchdev
> port attributes emitted for the bond0 bridge port (because they are
> offloading it) and have the honor of seeing that switchdev port
> attribute can react to it, so we can program swp0 and swp1 into the
> BLOCKING state.
> 
> But if then we do:
> 
> ip link set swp2 master bond0
> 
> then as far as the bridge is concerned, nothing has changed: it still
> has one bridge port. But this new bridge port will not see any STP state
> change notification and will remain FORWARDING, which is how the
> standalone code leaves it in.
> 
> Add a function to the bridge which retrieves the current STP state, such
> that drivers can synchronize to it when they may have missed switchdev
> events.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
