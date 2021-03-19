Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5CD34285A
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhCSWEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhCSWEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:04:22 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E01C06175F;
        Fri, 19 Mar 2021 15:04:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h3so6820885pfr.12;
        Fri, 19 Mar 2021 15:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+RM5t93/xhq+0reaDCBMvkptlXoFfafLIulGmE6T4l8=;
        b=FTrITc6lRBQId8J+R1UI7ZYI6qlBSkFmyAlkNiY/kZv55b9RcPMwtlOXfIvgMMNy9/
         cfv3NkY43htTBxRitMsDccqH6dLJLOL8UlxUg0eirhUJ+iKymaPht1+nTQbmhaOfGv+7
         APm5X39rugoA9e2SElecT10dUcXHpU3FfN2i3K8N+y1jTqh5/zDZ8gebY5vDgLSP/1N8
         Oap/MTRdE5ykbaam1RGf/l6oHwKQzG/GhbBoCSQkuaJwf/w9StarLDhKf2NeTrexAJ7y
         TSPnDYPj6OpxAU9rqgYlD9VIci3itZkqhGyOuz0DOOATFeb7MIviilvILWhSEV77oll5
         NRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+RM5t93/xhq+0reaDCBMvkptlXoFfafLIulGmE6T4l8=;
        b=JIb4PSCeWbo37N9DOOu9Ru7P2tDJsBbA0pJm093VanRGLhlFkmzPjPyife6DOpLQLm
         vA6XVZ0rMhu9nb9CIuvO2r+I1oho9BeAtfri+Yu9sZMZjpM3eJ58VpYAUSZt0mxNwg9W
         UIWFikvpPa+CRvZs7VlzIOdqr/iJGuCKlu9Nlu3/koodJAWCpXskLUZ0oyGJaSXdu/1q
         AQDBcsPWuj06DjMUZ4AM4y3O++j5TOGlUJelDLVcfMbCBLxCtKAW5R0POEZCvXpzxm1+
         Pb44pOVkcUwxEscokDFSwIn/mY+MvxqEH4kO72dygr751cWBTQ+q6FvY59U2NKIAhF3y
         6A2w==
X-Gm-Message-State: AOAM531j85Z/LM+vFl0YQLzUTNKy8mVOWyNQDfuTRI4OLQDRibxJUKPl
        Eo0aa0RtVahmR/V+HYDdOjQ=
X-Google-Smtp-Source: ABdhPJz8u9qZsJSfqK7vmTeYdCdSdZBpUwyKrl8hKNhqQWfPQi3DMNnBXrHZCJhz2wVQCJ3IMSLvMw==
X-Received: by 2002:a63:1d26:: with SMTP id d38mr13717489pgd.385.1616191462187;
        Fri, 19 Mar 2021 15:04:22 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c24sm6344437pjv.18.2021.03.19.15.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 15:04:21 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 01/16] net: dsa: call dsa_port_bridge_join
 when joining a LAG that is already in a bridge
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
 <20210318231829.3892920-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fc343be0-a420-8d49-69f3-f15dd9dc8a18@gmail.com>
Date:   Fri, 19 Mar 2021 15:04:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318231829.3892920-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA can properly detect and offload this sequence of operations:
> 
> ip link add br0 type bridge
> ip link add bond0 type bond
> ip link set swp0 master bond0
> ip link set bond0 master br0
> 
> But not this one:
> 
> ip link add br0 type bridge
> ip link add bond0 type bond
> ip link set bond0 master br0
> ip link set swp0 master bond0
> 
> Actually the second one is more complicated, due to the elapsed time
> between the enslavement of bond0 and the offloading of it via swp0, a
> lot of things could have happened to the bond0 bridge port in terms of
> switchdev objects (host MDBs, VLANs, altered STP state etc). So this is
> a bit of a can of worms, and making sure that the DSA port's state is in
> sync with this already existing bridge port is handled in the next
> patches.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
