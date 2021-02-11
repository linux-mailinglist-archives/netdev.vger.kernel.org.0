Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDFF318431
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 05:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhBKENK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 23:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhBKENH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 23:13:07 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0778EC061574;
        Wed, 10 Feb 2021 20:12:26 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b8so2599811plh.12;
        Wed, 10 Feb 2021 20:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WOudY93SgpXlwWt2mPFyzJ30b3FUMM1XmeZpD48+PWs=;
        b=gtmhq+gKxAIQwRoLueiyyM8KSz4zS74fz60WRnCzlmWBkOSNceC6LXR/Cp0Q8TGI1b
         ZcaEOxXCJIZSevyBzh7CUZvR2ctixi2PtczMc5b+WErQkPB5ZdsL9HTbl0NCRJZ9BoVM
         qMItqyj21CC6NlKcXy32PD8ORyArFEETL6/K9qAWfN9aupXIfgkOvehV2v3yy27jFIDn
         96JyFUUAQa5h6ZpFBn1RkwN2l8LhQvOFfWqyHmK79ChTuRMNBOJy9oe/1YiVoICmvO6c
         W5tN0SwmeS+oK462NWLtOlM2sOMiGOLoYmrMlGyJcAodpCQJDuIyv7aQmlcWbgkWN91H
         Ik9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WOudY93SgpXlwWt2mPFyzJ30b3FUMM1XmeZpD48+PWs=;
        b=Ovun79Ad/seLVLpq4WW+Mhhf3zkmRFpSTJoYDN2zbQdiYwcATIvE4MNuR8rCMUwtyX
         wJK1nkNx6ZGUhO23IYO1SQKC837GtsE80qIDTFxgFm7xZCij8Ha/dtyMGzofL3PogWc2
         fDXQYAD2q3oZKC+t0xQR5KOc5KaGX97hk9VgyHxYvnXt7mm3xz5qRPWvacC1vDJzYnSh
         jAYpZGFdBDsp8csXdclacF+kmNM04Qwm/eGWA9yiVdntThBzPnYiY1qGA77ANcTuxFHC
         yq1VSdZ/4NgFn0Kh15vlAQ/EF6eIlqSc281FdtPK3SZQhgFlxLQRfGyNvlHPudxBDdxo
         KhEw==
X-Gm-Message-State: AOAM532smHpTbD45c/p4mHhBiGsyAoDUE1BVFZ7dr/CVNXGeM1XpY6mA
        M33P89azzw6sFQVFhCsTuWuONOm7ZNU=
X-Google-Smtp-Source: ABdhPJwMmXJ+BcCWGjq+/TD/aAM7GHDHaHV5fg0VMeLDDPvPLiaFtBqEnRTUiL16VUTJF0Wppj9J0Q==
X-Received: by 2002:a17:90a:a585:: with SMTP id b5mr2172130pjq.110.1613016746009;
        Wed, 10 Feb 2021 20:12:26 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c17sm3415368pjq.17.2021.02.10.20.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 20:12:25 -0800 (PST)
Subject: Re: [PATCH v3 net-next 01/11] net: switchdev: propagate extack to
 port attributes
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
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
References: <20210210091445.741269-1-olteanv@gmail.com>
 <20210210091445.741269-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <588cff67-699e-1971-a1a5-79d42f969f15@gmail.com>
Date:   Wed, 10 Feb 2021 20:12:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210091445.741269-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2021 1:14 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When a struct switchdev_attr is notified through switchdev, there is no
> way to report informational messages, unlike for struct switchdev_obj.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
