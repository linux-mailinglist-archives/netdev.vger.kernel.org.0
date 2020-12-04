Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440D12CF32A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbgLDRfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728495AbgLDRfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 12:35:44 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF19C061A53
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 09:35:04 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id g18so3945099pgk.1
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 09:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mZnBi3hnF6ooLl87IFaFAweqdfFiQr8/x3VXkzRn/0c=;
        b=mMOi482uSb4JqOPWY0Z/tsuFan2Y8MAU25W21q4pxNJq0aNoWRUhgkn9+tUSgm+0v6
         TngNZZwc4X+LyAcJWA3XxkYIcZud91RxIBodRUouBup4jBKy9EFJXOYtWj+v3SKl1Ui6
         8MuNXu6yC58aNgjA92cMm0pdUrgNu01delpVvOOP0rjlPpYmOtXyjaoXqNEfTQWLpvYj
         tWZqX30R1Ikv7dn5k9dFHel1n+nQ4rZj7TeQpt/APRPrQ/qidWve8GhYfHv4y8xIkCjb
         SThvRfxTcwnbppR1WLRPLRXRHu+u9YvEap7T3iP12vaP34Grz+LIXQje4PxlRPSibiHs
         M0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mZnBi3hnF6ooLl87IFaFAweqdfFiQr8/x3VXkzRn/0c=;
        b=kKbClPnPl/HYIx4it4ePnbQQoiQ1DMhjBD2yQA/1o1H+z9Byui8DSSoR/wOJ8xKGCs
         JlDvYiyePVnp0yLZw7ulV5GWQ5QkX+mj220A3LmTk1ViQJFVKYjBgXdJuSFzXCAzOZxM
         niFqWIEPkrOcPpXBTr02i/2gTz9dRhWvhs7IaWxHjxr+tDeyYTRpRvjZ3kiGbfx/ozcw
         uItGnBp4swb36Y7Ove0XniP0OnO0r9//t7IpHS9AUG+vDGfTewMaqJpvAABzZrNCzRP7
         BeiygRhAD9N7N6CvmnyYbqlEWvjxphjdrnHz5CX86rzD8eSyEEveI90/+sNb4dGIyCkB
         ZMHg==
X-Gm-Message-State: AOAM531Zt0Ta2OQO86Ofb33RO+BUZEfy24LCbyi3aZQXS7LCe8N3+W9y
        Z3DXd+C0nrEZOg1ayPnaFeA=
X-Google-Smtp-Source: ABdhPJwzJlWTVc5dZzrnVOBVyZ++oId9SWQAdoyfs6WM0X0cl8Bjf+UCf8pthl7576khf75pbMIEpQ==
X-Received: by 2002:a63:368e:: with SMTP id d136mr8323865pga.239.1607103303842;
        Fri, 04 Dec 2020 09:35:03 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c132sm2875966pfc.119.2020.12.04.09.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 09:35:03 -0800 (PST)
Subject: Re: [PATCH net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
References: <20201204170938.1415582-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ae82dc10-11af-e48a-a317-fc60cda3b993@gmail.com>
Date:   Fri, 4 Dec 2020 09:34:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204170938.1415582-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/2020 9:09 AM, Vladimir Oltean wrote:
> Currently ocelot_set_rx_mode calls ocelot_mact_learn directly, which has
> a very nice ocelot_mact_wait_for_completion at the end. Introduced in
> commit 639c1b2625af ("net: mscc: ocelot: Register poll timeout should be
> wall time not attempts"), this function uses readx_poll_timeout which
> triggers a lot of lockdep warnings and is also dangerous to use from
> atomic context, leading to lockups and panics.
> 
> Steen Hegelund added a poll timeout of 100 ms for checking the MAC
> table, a duration which is clearly absurd to poll in atomic context.
> So we need to defer the MAC table access to process context, which we do
> via a dynamically allocated workqueue which contains all there is to
> know about the MAC table operation it has to do.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Did you want to have a Fixes tag to help identify how far back this
needs to be back ported?
-- 
Florian
