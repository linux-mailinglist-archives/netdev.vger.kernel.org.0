Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3542D3ADF06
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 16:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhFTO2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 10:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhFTO2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 10:28:12 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40ACEC061574
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:25:59 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id w31so11995698pga.6
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WheepCFJqusZkxTJSJ46SFwF7yBfmc3pCcG4Z8MylfU=;
        b=SlK4qfFAFBrfkl1sJZQhGZMKfUcow3nrDlvszhAkjGWWo30ZN1dlFJp4sd/HcnWBAv
         yThiux+PQrDyqIVLNjlroGlx6ZwqXEzzNJufx/2uCHazb86GMvuQErpVZ3zkidMEKAxx
         VKXBRK2lUzsvk1ECpuVTtL+siTqF5dQomPlsPYotHGjGkT/SgvgCTzD5DyhypGWEjmOW
         NSZqsr8Fr4RvwJ06dKaKADm3g6XyvBcH7+SZfkaJ7irDVxhhGwe/6OfTZyBzlO/+Kzqy
         lRvZpJkqm95+s4p/OtUxmdREj/WBj2+98XIRqWuwOSf5bFvFq2lryIgMIeELsiu7ltkl
         vvqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WheepCFJqusZkxTJSJ46SFwF7yBfmc3pCcG4Z8MylfU=;
        b=eKta3ucAa0MtX4DSgPb8sd5Gi2DENIcDveXznGNEnUBDpkKTneWD8/MGYg8wAw8QWD
         9vDQjEvx7gZxuxIYE5yfQUlo7dWc0GjXVyfFytikwTB8ryY8zDj/GnTogLOzgpdDYpkp
         C9byOfcThI0SRi9G5ymPApODhve/rRw9sal5EcmSaXu2NHfJyJBOtQ9byaxX4PeUyRWL
         Fku9G9oxy89HcLCISnbVIxO8uJL5TkXyHSs4u2xtVymJbbgV0sRW7f85KAPz6JJYARRM
         Re8/vUPrVXJW27pXNwnjKJqkMEAx8KH4RGZGi75lfCR4pImYgLNv6Lrx2WdZ65ibYO5W
         V4Sw==
X-Gm-Message-State: AOAM5339gvFZZnOdoO5IYxGqry1sKhKOZ+CgnBznESS43+AQUD5+HDjo
        Y2Wmlbjg83D+t6fo3Q6Fc3w=
X-Google-Smtp-Source: ABdhPJxclvWmd3Z8aclB3zhtcGyyT2CMk99MUrltF0T+vVplD6vbMWgfThoHdF1eyxEodh0rkUJ//A==
X-Received: by 2002:a65:63d2:: with SMTP id n18mr19481078pgv.447.1624199158865;
        Sun, 20 Jun 2021 07:25:58 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id gl13sm15771904pjb.5.2021.06.20.07.25.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 07:25:58 -0700 (PDT)
Subject: Re: [PATCH net-next 5/6] net: dsa: targeted MTU notifiers should only
 match on one port
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
 <20210618183017.3340769-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a3f51f33-32de-9ac0-8b4d-68d785cb1991@gmail.com>
Date:   Sun, 20 Jun 2021 07:25:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618183017.3340769-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2021 11:30 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> dsa_slave_change_mtu() calls dsa_port_mtu_change() twice:
> - it sends a cross-chip notifier with the MTU of the CPU port which is
>   used to update the DSA links.
> - it sends one targeted MTU notifier which is supposed to only match the
>   user port on which we are changing the MTU. The "propagate_upstream"
>   variable is used here to bypass the cross-chip notifier system from
>   switch.c
> 
> But due to a mistake, the second, targeted notifier matches not only on
> the user port, but also on the DSA link which is a member of the same
> switch, if that exists.
> 
> And because the DSA links of the entire dst were programmed in a
> previous round to the largest_mtu via a "propagate_upstream == true"
> notification, then the dsa_port_mtu_change(propagate_upstream == false)
> call that is immediately upcoming will break the MTU on the one DSA link
> which is chip-wise local to the dp whose MTU is changing right now.
> 
> Example given this daisy chain topology:
> 
>    sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
> [  cpu  ] [  user ] [  user ] [  dsa  ] [  user ]
> [   x   ] [       ] [       ] [   x   ] [       ]
>                                   |
>                                   +---------+
>                                             |
>    sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
> [  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
> [       ] [       ] [       ] [       ] [   x   ]
> 
> ip link set sw0p1 mtu 9000
> ip link set sw1p1 mtu 9000 # at this stage, sw0p1 and sw1p1 can talk
>                            # to one another using jumbo frames
> ip link set sw0p2 mtu 1500 # this programs the sw0p3 DSA link first to
>                            # the largest_mtu of 9000, then reprograms it to
>                            # 1500 with the "propagate_upstream == false"
>                            # notifier, breaking communication between
>                            # sw0p1 and sw1p1
> 
> To escape from this situation, make the targeted match really match on a
> single port - the user port, and rename the "propagate_upstream"
> variable to "targeted_match" to clarify the intention and avoid future
> issues.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
