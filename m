Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1691E2FE0D6
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbhAUEhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbhAUEGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:06:05 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4337C0613D6
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:05:15 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m5so751560pjv.5
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PrXnwIzdiZa8p1+4jAjt67vrk+owSCcZ6LP6GOg/4/w=;
        b=eGvGVu3njic6ihiPEjxSrRSu8hu2AjrfGdH++NeguybDMGDX9u/JSBos27eVmzLs96
         wPeX1ggVV23xi/PhzjU4LNrcKREqZIm2I5Emwbj50aLOtfStj3OGDnZgEgd4G23LUaqY
         rsYygbQ76b5FYodOF5Gy/4ln0WAlYzn3lLBONp8GttPpHC21PddwEg2cqFU1DaHwOjd5
         g35jQ6k8A9GtWEuzJeOtNCE9cjyDFrUb1jYMhWyVyMLAAYu2kGylisxpknKMZkNpciHT
         WtjPmHZc+ug2w+DEI4vK/NfRMe4D87EhL5xLlA27Nn4QpL+nXojQS0SuHky2cX8wy0vS
         g3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PrXnwIzdiZa8p1+4jAjt67vrk+owSCcZ6LP6GOg/4/w=;
        b=BQ8ZuA+Hevc31PR+AwSG5xQ4c0cZnOP6VjqU5IriF9zWJFMac6VC9jSGKn0KLZDdGK
         qdel7k2yBySdfSmVSefh5pRugbBthQDSUopY+1y6D8kOBClcJ73Y4+Cu/iA3ejlhfLyC
         uc/v02AC/vEXLyy3IcfGdMJlhAscla34ZaiNmxE4b/icZsRajbj9CFyRRYPL77d5OPad
         a/W9onE+c9mfpRCZUr8iFzhPavtOv/RftYBrK+rdkvXVbe0ZDTAE2Hy2j3NgAHQLs3DZ
         RQ962z4U29IblrWQ+Dx3dp6zBsZvPKioDIf5zyyJL6pX01R3xRfImoGGk3zmPBUj7s57
         M9qQ==
X-Gm-Message-State: AOAM531obK6zdoOV/b3OR5uAdU+ElUGNqF9me7f3ONJEOqu+Bd+JB2fe
        Qr/9rwIg+9SJmrNcFTvVLsg=
X-Google-Smtp-Source: ABdhPJzF7AnY4vIk02VAnmwc/MVZPiov4GvGMGA/ggo7+jDktn/uBxiYcTz+SjElgCYdciuDq5JtPw==
X-Received: by 2002:a17:90b:11d8:: with SMTP id gv24mr9322536pjb.232.1611201915268;
        Wed, 20 Jan 2021 20:05:15 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm3902207pfc.153.2021.01.20.20.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 20:05:14 -0800 (PST)
Subject: Re: [PATCH v5 net-next 09/10] net: dsa: add a second tagger for
 Ocelot switches based on tag_8021q
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
References: <20210121023616.1696021-1-olteanv@gmail.com>
 <20210121023616.1696021-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7cd5d30d-e93a-9651-61f1-9f406d7f11a1@gmail.com>
Date:   Wed, 20 Jan 2021 20:05:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121023616.1696021-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2021 6:36 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There are use cases for which the existing tagger, based on the NPI
> (Node Processor Interface) functionality, is insufficient.
> 
> Namely:
> - Frames injected through the NPI port bypass the frame analyzer, so no
>   source address learning is performed, no TSN stream classification,
>   etc.
> - Flow control is not functional over an NPI port (PAUSE frames are
>   encapsulated in the same Extraction Frame Header as all other frames)
> - There can be at most one NPI port configured for an Ocelot switch. But
>   in NXP LS1028A and T1040 there are two Ethernet CPU ports. The non-NPI
>   port is currently either disabled, or operated as a plain user port
>   (albeit an internally-facing one). Having the ability to configure the
>   two CPU ports symmetrically could pave the way for e.g. creating a LAG
>   between them, to increase bandwidth seamlessly for the system.
> 
> So there is a desire to have an alternative to the NPI mode. This change
> keeps the default tagger for the Seville and Felix switches as "ocelot",
> but it can be changed via the following device attribute:
> 
> echo ocelot-8021q > /sys/class/<dsa-master>/dsa/tagging
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
