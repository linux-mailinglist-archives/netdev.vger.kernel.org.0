Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1962FE1FE
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbhAUFqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728672AbhAUDoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 22:44:04 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCE3C0617A2
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:40:58 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id x20so732556pjh.3
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qAyoR5PX7yRHGQTJVioS8UlmuBJqcri8hRFmtF+ARUA=;
        b=tkRylR8DeJ8KFiycKXU3oZ8OOeQE+JPXboLYMLRTPp4KSwy/RHy8djmMRtVvYJgh5R
         POtGQ56cw8C4UMvD5fhtfihuZdu9X7fpIeI0p29DzrhTxqCxMVUD7TP0an3mj5vvXnlH
         XhC4LxboiuMFFTJLtw1YDUkCOdIb56eOg4TbXBJ5039CNa0El2qkaknmEiYrVXjxbFGs
         kKtBdaswi8dZ27PQiKxXXU7sMVmTdItgCFgDcTkyz1AVDCbUlZenheloYxeT/lJPm11N
         EWFdfNNzbDl9ctaM+etqETDUvhOEIRB/cEBlarviIxvohFjkhW3z4Wdcbl/m9KMgDLdQ
         NaBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qAyoR5PX7yRHGQTJVioS8UlmuBJqcri8hRFmtF+ARUA=;
        b=qIgNRCt49dcKC21TCLD0A0epZukO9vCKa6pPAe82O0kNDkS5WdPmQGxoZGzDzcBsZ+
         /Q6+HQKHcVTRxg6/WK0Lb6rJYUP4LwXdF1SZXHG9ubkXojiegp6F9qPt+qnkxdXxFPFH
         LpIl6jK6wkZhNHFCkRPzwqQYGXNoEjnEOEjZtBDxFtKZsL1Zxg9yakmuhm2+TBj+YUcc
         fWFK1G6BiBOr5oTFcpG7OqXQ6wmFt1JG7VFttTJFms9xZp/RHEbK5vTz3rekVBds/SDb
         4/OrNsWNjV8lpnLDz4U/uQG4tkI6gUrkkBYT9dv4TDD9o1VSxU3EnRspmFZgFUg9V+PT
         hiuQ==
X-Gm-Message-State: AOAM532jPRjatAsqshWEUJ7HQBQbNnXbnWilSlr6LCp75VpX2p2aDX4l
        3/RFBJ+3D2FZoajWimRS+u4=
X-Google-Smtp-Source: ABdhPJxr3k7YpAZzlx9mgSmLt+mjaMLe8QoAghUJ2qTCsfwrWi8whnntFQxBxtdr6iv+MC4AOTEdeg==
X-Received: by 2002:a17:902:e74d:b029:df:c991:8c4f with SMTP id p13-20020a170902e74db02900dfc9918c4fmr3250185plf.52.1611200458318;
        Wed, 20 Jan 2021 19:40:58 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c5sm2461774pgd.68.2021.01.20.19.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 19:40:57 -0800 (PST)
Subject: Re: [PATCH v5 net-next 04/10] net: mscc: ocelot: reapply bridge
 forwarding mask on bonding join/leave
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
 <20210121023616.1696021-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f79fc541-9043-e24e-275c-d54b908e25c1@gmail.com>
Date:   Wed, 20 Jan 2021 19:40:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121023616.1696021-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2021 6:36 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Applying the bridge forwarding mask currently is done only on the STP
> state changes for any port. But it depends on both STP state changes,
> and bonding interface state changes. Export the bit that recalculates
> the forwarding mask so that it could be reused, and call it when a port
> starts and stops offloading a bonding interface.
> 
> Now that the logic is split into a separate function, we can rename "p"
> into "port", since the "port" variable was already taken in
> ocelot_bridge_stp_state_set. Also, we can rename "i" into "lag", to make
> it more clear what is it that we're iterating through.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
