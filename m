Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01973CCC2A
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 04:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhGSCUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 22:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhGSCUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 22:20:53 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EB9C061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:17:54 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id p67so19071887oig.2
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cTgRVDtghkxyZQfyDmHBQUQJXuRVf+/7cKDTFF5F3gU=;
        b=WApIw/si/Yd74Gfm/puLIoV+MV73/wft6KVqOYzzRSPaigvY6OpdaVlC/cS5RQ8q5B
         /+Pjjkuhd+hHdwGQp57T3/vu+DvRQhT8Nb90oqM+FgYkXYJgnRvqhNm39bD2J2Y26LJI
         jezveRuR3nPFvRjOfotkB8rp1Da62ymknwU+6Z6X15PO/0Yj6Xaqs0aCp0hLp82ruqPg
         7UhyqUxAPvqgAdZH5xligAUF/n2Y/W3/UhVCLtj2WBoYETEy590Pb4pggKXgCf3gxVLQ
         9Mgxd32atma7EiA2sROLHNjmmawK40+NYfjeqkQegss+sIZyjrBzPMox0h8di2X3DQh/
         ePmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cTgRVDtghkxyZQfyDmHBQUQJXuRVf+/7cKDTFF5F3gU=;
        b=KdxTryPTlXdrr4m5/0jLw2yL38dX9YrKJa4vGXaYN+mlUy1YwrGH5hfuoF+bgR0i4h
         vLwilPT/BJ61DFh7e6jSl/l4set/y2Q2XficMJnTtZSurabKVeIwL4IYlssccZzlicvw
         X4k0AYM8l7YEUnyAzyWSKjBP/bu4IY4IpLTVHlmuuKGl+rpfsbFM5lxIEH7dwiEI55Tc
         8clHpKJbmfs2TK16oGqZvf+oQHB8EdK70HTIMOk9bB9N3CU82eA0LJW8xxJZKSQ8mH8d
         k871EVHOyLHBrsbvPEsSY6qyBf2oGL7vFHSp7CF2n+m9UYjwLcxc2q5JjLeQWAdIB0Nk
         lH8w==
X-Gm-Message-State: AOAM5316i6AjaYa9coSfII5Sz6d5Gw5p8GNyiXLa4yovJTgn+GZl/2In
        kRBISulN/5KjbeRAT93Drl0=
X-Google-Smtp-Source: ABdhPJwu+I/7zWrmyGWn4EKJrXju0B35YkbVS1wrtNAFXfPpxDYksgmXY1gpgMZXgGbp9WlHd32u4A==
X-Received: by 2002:aca:e107:: with SMTP id y7mr20862566oig.11.1626661073945;
        Sun, 18 Jul 2021 19:17:53 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:49e1:751f:b992:b4f3? ([2600:1700:dfe0:49f0:49e1:751f:b992:b4f3])
        by smtp.gmail.com with ESMTPSA id e29sm3538630oiy.53.2021.07.18.19.17.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 19:17:53 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 06/15] net: switchdev: guard drivers against
 multiple obj replays on same bridge port
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d4ee8b6c-d171-9b7d-130b-d244de756cfe@gmail.com>
Date:   Sun, 18 Jul 2021 19:17:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210718214434.3938850-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2021 2:44 PM, Vladimir Oltean wrote:
> Prepare the drivers which support LAG offload but don't have support for
> switchdev object replay yet, i.e. the mlxsw and prestera drivers, to
> deal with bridge switchdev objects being replayed on the LAG bridge port
> multiple times, once for each time a physical port beneath the LAG calls
> switchdev_bridge_port_offload().
> 
> Cc: Vadym Kochan <vkochan@marvell.com>
> Cc: Taras Chornyi <tchornyi@marvell.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
