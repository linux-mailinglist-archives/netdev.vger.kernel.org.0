Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FF43B50DC
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 05:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhF0DEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 23:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhF0DEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 23:04:06 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DF9C061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 20:01:43 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v12so6863365plo.10
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 20:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qX2DssqRUo+MeaWOl2rzT5kW9rGxLHqJT1oOuWx5jTQ=;
        b=Ov5k5Psqii89sJIm8PM3r9aHCN55fOjtomJreI/daCqW85+2jsuKesOxa3w+7tqiyL
         gwWmUzI+o0yBoYmDAxTrtmYGJFaERYqOVY+caFtBpcYijNCLAqRrYfbuBdpGGtSOD9xy
         WxJAqs4aHPR59qTMJTVHMK2DSLGAsWANs0UCVpUkwzlCZ47PcicHJvulzk4FNY0j7DKl
         fTEgslqOoUU9ClXsYpwp6GopMqM5pXc6/hreK8OvkufqIcMnk68/+TNZtfgvfKyRzGab
         C3+ZAwoULtcHCfzDw+VNNDvjcF7Nf3hUi7ZUgHw+IfZvq+2QjIo4/IsMwf9RbWdnpmMd
         NzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qX2DssqRUo+MeaWOl2rzT5kW9rGxLHqJT1oOuWx5jTQ=;
        b=qVLjHqBvzFAVbq2QHTj+mN4Zpemorjl1cIkwqUIzsvihfzj28+588G/akUAt2j8tpY
         VuJ/jIkfaVkCWVgTC4Ox8zxPKso58F4xMNwLXGXsIUQ+dTBG8SjwfnUP4i1RqC6b5248
         di9FN32Ib+wDnduwsWz6CYHhBeueee6/B4W71gIXjc1pKn3VYb0/EOD8prBB3+4CaykK
         eYW87rWHQ/MwqDJ+Ch/36Ppw0op+4tHuTkyjT3l6ddcCyQ5r23MA4Nlg70zUG/kq+pjN
         vZ+2Yi6eLal4PNlWOLqrY1Yw6FNWk1PFTytXKzt2cr9Y/aCajDrTbBuMrNEX0KH2F5Th
         f7sg==
X-Gm-Message-State: AOAM531lrJHr0m5vPvT9bUPpS97zJx5Mb97551SpxNRLcwNxx/Y+KNfm
        QwQsCLko2VZYzu5lmjxwz40=
X-Google-Smtp-Source: ABdhPJxMzgIaVqgE/oNpcyTxuucDWXkcJ5Txk5+L5nnK+nsT6ZZv0+trH7BDH2Y+42+g9wDFh00tLQ==
X-Received: by 2002:a17:90a:708d:: with SMTP id g13mr29554397pjk.81.1624762903317;
        Sat, 26 Jun 2021 20:01:43 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id lb14sm15051818pjb.5.2021.06.26.20.01.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jun 2021 20:01:42 -0700 (PDT)
Subject: Re: [PATCH net-next 7/7] net: dsa: replay a deletion of switchdev
 objects for ports leaving a bridged LAG
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
 <20210625185321.626325-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4a68c9c3-5f10-6b6c-bd9b-eb560fde7ed2@gmail.com>
Date:   Sat, 26 Jun 2021 20:01:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625185321.626325-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/2021 11:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When a DSA switch port leaves a bonding interface that is under a
> bridge, there might be dangling switchdev objects on that port left
> behind, because the bridge is not aware that its lower interface (the
> bond) changed state in any way.
> 
> Call the bridge replay helpers with adding=false before changing
> dp->bridge_dev to NULL, because we need to simulate to
> dsa_slave_port_obj_del() that these notifications were emitted by the
> bridge.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
