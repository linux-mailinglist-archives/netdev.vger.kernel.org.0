Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58F731A438
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhBLSGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhBLSF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 13:05:59 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DC2C061574;
        Fri, 12 Feb 2021 10:05:20 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id a24so245379plm.11;
        Fri, 12 Feb 2021 10:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e7FvX3805mVbi8rUejyIm26agQLfcgUZJrMWSiLjNGs=;
        b=lNMCouqv+fTjmMB6cirFrl9lgwfiYme91mERyye0MrSQwDCWRBAA8nxOyadU0JP1GM
         2+78codzGdNu57tEuXnoFu7IobxUP2aYirkbJr28Dm7BWbmrvwUwjBcmrPiAYh+qBgtO
         2oi4c6DHF22Kn9p7hWKmzSLq3BrbDfp1snMMHl4gbxbz70OOyBegaRybHK+9kTsuJelI
         sX9n3adDZpn2lvnhNC9ZnBin4UlcBYC1LTzYqPV9XqtyKQVe7EUeGDgd/KTQlJ0iZiLp
         fwm/Zs1QqxP+LnnLT9T4qzF2MEyxwZGEGwECPkLtovPlelRmrQOiI2Cl779Kna3slRjJ
         PNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e7FvX3805mVbi8rUejyIm26agQLfcgUZJrMWSiLjNGs=;
        b=h88VgQjiww7lonaGjvTneYaRQ1whgucgiy2sUobkOJBatsodP57ggqhLTvIriZbaMI
         FgiOjOWh7ZEZ1Rnjg+weFBseQGvocmrXoX5892Pm9eTbYHXTXptG9sg+UAPO/T+oG0op
         n/3MvrZUYscvRndUTnhjWV0BphhsLCJyPmfvhter5zOqDnxl99GmKNyI9o4CNq7Rtxsf
         7ll8HmlgibQjS92QYewBgpgWIumAC1PPL9xunmn34XcESagtZjkc6zvR2lt+9EQ1TurB
         MNihg0UUkviyNKWwJnyxcOLMVyawQsbrxmc9X+ElRiAKUpciauJYepqez1TJ10nvlHV9
         oxkg==
X-Gm-Message-State: AOAM533HHK29Pu3wFAjGm8RVgtC3l1IXl7E+BgEISnEdN6hQE7d2rMXF
        jzOr9Oe7o5GxDFfmywu7ibCdZmy5bGs=
X-Google-Smtp-Source: ABdhPJxbX9H47ViGLWUpCf4ZDXGVxxJ2XlKtdlv42d9ua1WR5Bsy0WUcnV+kUq8ziygwgtpEbfgKww==
X-Received: by 2002:a17:90a:ad09:: with SMTP id r9mr3793493pjq.51.1613153119543;
        Fri, 12 Feb 2021 10:05:19 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r13sm10104082pfc.198.2021.02.12.10.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 10:05:19 -0800 (PST)
Subject: Re: [PATCH v5 net-next 02/10] net: bridge: offload all port flags at
 once in br_setport
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
References: <20210212151600.3357121-1-olteanv@gmail.com>
 <20210212151600.3357121-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ce3cd74e-2f58-e368-e108-fd148d69d4cb@gmail.com>
Date:   Fri, 12 Feb 2021 10:05:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210212151600.3357121-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 7:15 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> If for example this command:
> 
> ip link set swp0 type bridge_slave flood off mcast_flood off learning off
> 
> succeeded at configuring BR_FLOOD and BR_MCAST_FLOOD but not at
> BR_LEARNING, there would be no attempt to revert the partial state in
> any way. Arguably, if the user changes more than one flag through the
> same netlink command, this one _should_ be all or nothing, which means
> it should be passed through switchdev as all or nothing.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
