Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765A43E5734
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhHJJlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbhHJJlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:41:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95D3C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:41:13 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so4422262pjl.4
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SHAQQAei3foAn1vGAqWXIkDOWNAwsY08zVYsFG5+Gnw=;
        b=H/jdpSuFvB0xIMhEbNuJdoQQuxdGKkb+fuJGBRN/4uNrvKtvWv9gG1iSvqJLYTpEu1
         p2OHi+pUgw4iFvqYaT1ogzhcN91Levgluvo7HPE3m0AWJe5Ml02FOA8xOmdFTrSGlG/m
         gtTjvm2wyhP3m24mwPNn0eHxF/Adp7MMZhdAHXdf6w8QCTud9xslk2Hpk1IJLAXjjRBC
         cGi/4NiVivyLHs6GVB67+GoK+g8o8vIdxy8rfR/OJ830mLZR5i1bkXLnIzeuojvMYjnY
         /DhY235H2p4TqCwroVxWEJQ/6W7nKWsC4BGeT3hLMd8gfbtp9oRgALO5/L8PoaVVUgu3
         G7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SHAQQAei3foAn1vGAqWXIkDOWNAwsY08zVYsFG5+Gnw=;
        b=VxeWJn98SuwP9xTJoC+hhSF8SwKOF2Pofzc59/XdYFp5N+mTABamiEb95Ac4GpN6z8
         WeJ9yo0yNXwdEZIyb5qU5+nIk27EvT14aYF6mS7xGaQ77SGcoOfT99YtSTkHP5IdDhdt
         OSGrfYqdDZAF/TflvtZEPeHnN2aU+STUODkjw6Odcem0agcjAk0AZ1lWj5hs7qtzSog8
         tYUb/Hx7Z3nlC7oi0Bi6CI2ERIb0zqf13GhRrMBTjZZvB22WKkRF+5n1h6o8kI+EQK4Z
         T23mEL9U4RFzfETcTdcNQYy9FfwCYDS+4G6yRM5oeSnxzDPrc1noDujd7Nmmt+QTidiU
         Z2ww==
X-Gm-Message-State: AOAM532LB2Q4ZFsJKAOdRJnAmUfrUuH56ZW1yA7aJLIS3/u2J+IYhYHn
        SracaK3qx9mFFI9AGvFiFnU=
X-Google-Smtp-Source: ABdhPJzkRA6TTOZq3ClWEEFQIhakQ0d1GGZUXBV7V9fBZGztzC5BW90IVT4v68KdKxJ7MBy9/D6RgQ==
X-Received: by 2002:a17:90a:e88:: with SMTP id 8mr30571975pjx.108.1628588473406;
        Tue, 10 Aug 2021 02:41:13 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with ESMTPSA id on15sm2273829pjb.19.2021.08.10.02.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:41:12 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 2/4] net: dsa: remove the "dsa_to_port in a
 loop" antipattern from the core
To:     DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
 <20210809190320.1058373-3-vladimir.oltean@nxp.com>
 <20210810033339.1232663-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dec1d0a7-b0b3-b3e0-3bfa-0201858b11d1@gmail.com>
Date:   Tue, 10 Aug 2021 02:41:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810033339.1232663-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/2021 8:33 PM, DENG Qingfang wrote:
> On Mon, Aug 09, 2021 at 10:03:18PM +0300, Vladimir Oltean wrote:
>> Ever since Vivien's conversion of the ds->ports array into a dst->ports
>> list, and the introduction of dsa_to_port, iterations through the ports
>> of a switch became quadratic whenever dsa_to_port was needed.
> 
> So, what is the benefit of a linked list here? Do we allow users to
> insert/delete a dsa_port at runtime? If not, how about using a
> dynamically allocated array instead?

The goal was to flatten the space while doing cross switch operations, 
which would have otherwise required iterating over dsa_switch instances 
within a dsa_switch_tree, and then over dsa_port within each dsa_switch.
-- 
Florian
