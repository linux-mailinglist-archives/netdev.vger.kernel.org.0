Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D38031A458
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhBLSNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhBLSNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 13:13:21 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC085C0613D6;
        Fri, 12 Feb 2021 10:12:40 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o38so166178pgm.9;
        Fri, 12 Feb 2021 10:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DYSCyXslW7JpprNOrHc5FjADncBRkdDqs3PWphAwNEU=;
        b=rSedlesAGjgO7MengPEN38iUKrRFhSnQ9IDS57b7dEzmhPwvLXpm4PNrLLqaLDDWGS
         t/bek5mE5JocEFy2hDyqKsNBZ2HCm7vdjEUWKHIkuEsfjaug3X2zFKE1z1uQX7BgqDh9
         TSyV16NxdPZkBIWcjgFH5a5pqLm/LVbULSIs3cD9oaqMfL0gLc3nh/2+2SkAcg7N4tdW
         3vh3jyeQaCtNfInJMcufkK6qZ7z9DHhAYOU60lj9P30xtEjbMkwnQrvpm/CC/LvpzAKW
         IrOHNxRFtakhbjWHauelHwN6T50yg5AWQ8CaK2dr7uBQQRjCJ5qLIF9QvzigTgkd0QlS
         o6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DYSCyXslW7JpprNOrHc5FjADncBRkdDqs3PWphAwNEU=;
        b=G4SRO6FatNd9s4V7+cxY0wdN7HHSJtu13YjjTLGC72YQVJT6Ey/Hx0Gc4ude0ex1C7
         ouKlm+Ly3jRgSWYaPYPtbUGybsxt4Krbdmh9wCEKksOkeuJBudtGx48pChLr0uvbj9Lz
         pKdHfmrIQ3Pb2Jbtq3nzIlJY3IQp0qTlNPv9WnBHd7lUGFm+CNwa9AmTvovG2uidNNIg
         AbBVJpIIrNu+rarbkoVaUMqPIo0svk0biI3uDwAZdqGiJuwV6Z3NZO4OcEHRs5yjy0u4
         KRT/Ty/p2ZfLup4fFv0kbOSPDi8Q1tzeBWF4/lRQZDxGOiOUz93yCaAmaXyu7KQhwFUG
         Nsww==
X-Gm-Message-State: AOAM533teZbFpReqZQqUN1h6NRfxMVLf5FSkY4snBT+m5c5SgnR6aU4H
        6J+JBsPPm/GLA+Pc7WYnKwg6mq2OKD4=
X-Google-Smtp-Source: ABdhPJwoYsp4Sp8t8amuimKE7kIoREpqi1nx3kEihL4zIPUsG3WNrKMB+WDhg+WkOwjCceHdCPg41w==
X-Received: by 2002:a63:4084:: with SMTP id n126mr4349051pga.80.1613153559952;
        Fri, 12 Feb 2021 10:12:39 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e185sm10042337pfe.117.2021.02.12.10.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 10:12:39 -0800 (PST)
Subject: Re: [PATCH v5 net-next 07/10] net: dsa: felix: restore multicast
 flood to CPU when NPI tagger reinitializes
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
 <20210212151600.3357121-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <05a93c4b-2180-afea-d077-3b1c91312b41@gmail.com>
Date:   Fri, 12 Feb 2021 10:12:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210212151600.3357121-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 7:15 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> ocelot_init sets up PGID_MC to include the CPU port module, and that is
> fine, but the ocelot-8021q tagger removes the CPU port module from the
> unknown multicast replicator. So after a transition from the default
> ocelot tagger towards ocelot-8021q and then again towards ocelot,
> multicast flooding towards the CPU port module will be disabled.
> 
> Fixes: e21268efbe26 ("net: dsa: felix: perform switch setup for tag_8021q")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
