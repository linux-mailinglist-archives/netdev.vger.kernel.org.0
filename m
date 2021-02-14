Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A0B31AEC7
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 04:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBNC6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 21:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhBNC6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 21:58:36 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C707C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 18:57:56 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id k204so4241458oih.3
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 18:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9+5Vwyl+wc2KJWGdNdCosuJyM765EK+OmhPCgfgqaz0=;
        b=TGKHDGgyxo2azQykfiS2EUDgPHH0k7dt8GtfoyIqlNvv+PkJ8rDM7oRamg6E97zOi2
         BdoazjXdBYJwfK+WBPj6/Ru/ZCyAn6ksCnlYmm4MooQddj29pjj0ZUebtBbD0qZsmAXl
         9sjq41hRzozHk43N+en77m+F1qPAtJ93uIGKyoqAML0X7PHLye2BrxJgASwfisbUCwH4
         POS/z1uyH3QgB3ejkLLzOFlbVa5Le8JyLf6G/A2WptdGuGXP75bAdxkJKrRF0j871xSP
         wQooDk++LtX4cuDbgbCO9VIICpJ8tdhHSj2G+JlDoFtydmWqEhWJ2vLJP/aRzB/wHp4N
         7Y3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9+5Vwyl+wc2KJWGdNdCosuJyM765EK+OmhPCgfgqaz0=;
        b=t0vLAPbF7RZp7CNeh5DL/3QSCZMRus+LDwBDeBl3aOcHAmDgItFHXhOq3fhf1Wv/tq
         z4VMaFMotaS0wVwlma2jAxIHGzSHrd1MGakLnj/nstFO2yFJHw7buWLZDi4lCsOAWLhz
         NUQdHW0vZamGeom4+xH5EGT5G6B+U3wMLzRuoqZ/DTuku4nGtoyxPoUq2B6cKyTLgafF
         JuTHsXPu8wSMKHGxUbXj7bqU+HVtVT7dHrqLQXKzg/e8c9xVUrrK/y7O6IxeA80IM1cu
         qa7Kt67cEE8G/byArXW2izL9NMcMHn3nwVyum5DLXdWnW/7pjcFV5kXYgxYkcBFaAmvi
         TGPA==
X-Gm-Message-State: AOAM532FmkYTA2PAVYdrWCD5xq8giHpoK3TSTZT8CWtA5dHo7BZXw7de
        zUOlswghAYOqEAvrfbxlxdI=
X-Google-Smtp-Source: ABdhPJx7xQcwl5RJf44LJrXxCndihRYlJ6r9xT/a5MiAoj7TZXBKMYDbZSxyZdIMabP3fGTEmSRuQQ==
X-Received: by 2002:aca:1813:: with SMTP id h19mr4354594oih.102.1613271473881;
        Sat, 13 Feb 2021 18:57:53 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id v5sm2729140oto.8.2021.02.13.18.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 18:57:53 -0800 (PST)
Subject: Re: [PATCH v2 net-next 10/12] net: mscc: ocelot: refactor
 ocelot_xtr_irq_handler into ocelot_xtr_poll
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
References: <20210213223801.1334216-1-olteanv@gmail.com>
 <20210213223801.1334216-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b6397474-f8ae-8308-d0a0-51472b25fe63@gmail.com>
Date:   Sat, 13 Feb 2021 18:57:49 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213223801.1334216-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 14:37, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Since the felix DSA driver will need to poll the CPU port module for
> extracted frames as well, let's create some common functions that read
> an Extraction Frame Header, and then an skb, from a CPU extraction
> group.
> 
> We abuse the struct ocelot_ops :: port_to_netdev function a little bit,
> in order to retrieve the DSA port net_device or the ocelot switchdev
> net_device based on the source port information from the Extraction
> Frame Header, but it's all in the benefit of code simplification -
> netdev_alloc_skb needs it. Originally, the port_to_netdev method was
> intended for parsing act->dev from tc flower offload code.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
