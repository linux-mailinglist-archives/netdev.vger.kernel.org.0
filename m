Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A2F3B50D9
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 05:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhF0DCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 23:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhF0DCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 23:02:19 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C913C061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 19:59:55 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e20so12134400pgg.0
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 19:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uZwB7XAjwnYGnVKivth6WAkPdVdITuREDD7ibzddp1U=;
        b=rp+epZ5gFKrOHUs0Or3gLW/cS7RmKszQ9mo+HgtNk0GQRMlE3P0U7x0wCx8TZsUjC1
         Wr//5wwkbrzZj1PU033FSs0MA9I2XBhw5YJNthbN092JiXWSpLMQT8Rba2NzcIumcGla
         fE89kJFOqCXxh9syN8fmL/IthZ6evjHeOkB6FGTZe9kHO4bihwW5UGf7ilYPUs+RMdEb
         Y1lT4qCx7od45i4qKMuNqMPlTWSnfAlOBEDbUb/gOVkGtwM6z3oxZvcyyMbiDA3DQgPf
         XZN4hCSfxMPboxMDQXkVuHsT6/vOP7cg6krpAPJGr6LppHrZugfTmxuuKHOV1pLdiZOY
         Fg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uZwB7XAjwnYGnVKivth6WAkPdVdITuREDD7ibzddp1U=;
        b=iCLThntsbd4gekJ/geFZk8YQ6FesooHCnyiXAaHftkIs5X1J6hHUxTGE5jWqmqPG2B
         a3oCTGazVw8ZcsoWWf2yWW4JP7xgkLOaP8P3lzrlUJGUCHMwDtWOQ/Nrd1Q7QtLkleke
         Mizhvrp2/78dK+AjoN1FB4BsAuDWc4y7kXzvqC11U2+5E+4N/5OGHpRMjB2OrIKGAPgr
         DWBxf3zEhmpIuOzGIjhNEHEaklICR1olya9m0XgK94nGo6RJ31d6NP30m/mzt10157vF
         nVtY5ldmq2NkIfkF7bN4+lylffrlwNJoukgYHdqCZBbNUniYotEpY8s6dvAHvXv39TFH
         5mog==
X-Gm-Message-State: AOAM532+5rFg9h1hd+UJAbVyRN1OysH53gzEiepsuSvA/CYIgNkkf9cH
        N4GNv3bnmFx/2XmfpwK2/AQ=
X-Google-Smtp-Source: ABdhPJxT8Xb85hnpNjeR3D9yRkSl2qL/yPYmEw1Wqxl9XQSKB8mVvQjLt3omP955Fvc2l37er6lX0A==
X-Received: by 2002:a63:1c0e:: with SMTP id c14mr4284712pgc.11.1624762794857;
        Sat, 26 Jun 2021 19:59:54 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id a9sm9691186pfo.69.2021.06.26.19.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jun 2021 19:59:54 -0700 (PDT)
Subject: Re: [PATCH net-next 4/7] net: bridge: ignore switchdev events for LAG
 ports which didn't request replay
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210625185321.626325-1-olteanv@gmail.com>
 <20210625185321.626325-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6b065c09-1db8-1b80-b0ea-c66451adc8af@gmail.com>
Date:   Sat, 26 Jun 2021 19:59:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625185321.626325-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/2021 11:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There is a slight inconvenience in the switchdev replay helpers added
> recently, and this is when:
> 
> ip link add br0 type bridge
> ip link add bond0 type bond
> ip link set bond0 master br0
> bridge vlan add dev bond0 vid 100
> ip link set swp0 master bond0
> ip link set swp1 master bond0
> 
> Since the underlying driver (currently only DSA) asks for a replay of
> VLANs when swp0 and swp1 join the LAG because it is bridged, what will
> happen is that DSA will try to react twice on the VLAN event for swp0.
> This is not really a huge problem right now, because most drivers accept
> duplicates since the bridge itself does, but it will become a problem
> when we add support for replaying switchdev object deletions.
> 
> Let's fix this by adding a blank void *ctx in the replay helpers, which
> will be passed on by the bridge in the switchdev notifications. If the
> context is NULL, everything is the same as before. But if the context is
> populated with a valid pointer, the underlying switchdev driver
> (currently DSA) can use the pointer to 'see through' the bridge port
> (which in the example above is bond0) and 'know' that the event is only
> for a particular physical port offloading that bridge port, and not for
> all of them.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

With your own comment fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
