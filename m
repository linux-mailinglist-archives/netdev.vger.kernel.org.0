Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590C6437C08
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhJVRjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhJVRjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:39:45 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5ECC061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:37:27 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d5so4316573pfu.1
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pc0826T+VwuovDnY6HohkwgcIAGyMCT3BX5VOE9cMKg=;
        b=WoSedGnjFGm26AtfKuNuHMpxhH/Xksm/3388SuBoZHUk3HP+UjiD3zSHFUWcp4Nq7T
         I32lMudYdu8CNkAekCdg4S+AF5KAj/uYfsFYYAIHHeoaS0eL0OjuY02aOH4ffeEzZaCV
         +cHu9rfFiUrhf5u7ssbeCaj1J7YggSVhvKK2W8bawxa2SyU0M7ZUN8fM6LYkdyW5bZ60
         yoxmYesoLFLj6ntfU+f6up3i+B8Or1wNTjald4k9YoGxXUXv2YjVoX6ki24rnk2WtTMV
         LqvGifR0DrvaM5DHaMckmLDmLHNOxSSlANEpLgwjmanvIXEitzIRoLGtdHOtYyljglCe
         fPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pc0826T+VwuovDnY6HohkwgcIAGyMCT3BX5VOE9cMKg=;
        b=aVeOwEnLltnceK3hxX7VS3Ktm9Mivpp5wJ9fulsD9JK7fwYfuc7NwaaC39LJfcdNep
         48DjHSM3njuO/8uDKiAfPCyqpYw/VXL5C5THJ6TDwtWfEfiU9DXsuPd4dTMsERSxgD8W
         Anou6oU2v8UXWL4hE6JW4T2oYW/c+YKV/fAC7dbwcqYaf+GBU5vvp/vDWf7SSMOUfk98
         B2BmZcKLtI9mVHQYgUQi/T/5yBtW43XGvgLDlW41xI82i9Ge2L5Hu/THsPFQA3NXNN+B
         /rxBE9YMex6Uc11/BhHBnnRDFn9gMXBGc3p9btONVAk2u3It0o7+4v71mHhAeNx+BCav
         8mAw==
X-Gm-Message-State: AOAM532NTgQS7eD/+ymsqh1bswAXjAQuqy1c/y/KtRiBk1H2cK3h19aS
        YNZwSsFfEDXcHDsUUCx05vA=
X-Google-Smtp-Source: ABdhPJyvC4W4hYCMorCe1Mh3TFUatpmkPv439CxhqQuEBc9X1xS49L7b3AjBYKgoPWGItOILlDQj4g==
X-Received: by 2002:a65:44c4:: with SMTP id g4mr871595pgs.254.1634924246623;
        Fri, 22 Oct 2021 10:37:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gk1sm12008710pjb.2.2021.10.22.10.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 10:37:26 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 7/9] net: dsa: drop rtnl_lock from
 dsa_slave_switchdev_event_work
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
 <20211022172728.2379321-8-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d33925e1-c28a-7643-9a29-f37f83957bb2@gmail.com>
Date:   Fri, 22 Oct 2021 10:37:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211022172728.2379321-8-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 10:27 AM, Vladimir Oltean wrote:
> After talking with Ido Schimmel, it became clear that rtnl_lock is not
> actually required for anything that is done inside the
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE deferred work handlers.
> 
> The reason why it was probably added by Arkadi Sharshevsky in commit
> c9eb3e0f8701 ("net: dsa: Add support for learning FDB through
> notification") was to offer the same locking/serialization guarantees as
> .ndo_fdb_{add,del} and avoid reworking any drivers.
> 
> DSA has implemented .ndo_fdb_add and .ndo_fdb_del until commit
> b117e1e8a86d ("net: dsa: delete dsa_legacy_fdb_add and
> dsa_legacy_fdb_del") - that is to say, until fairly recently.
> 
> But those methods have been deleted, so now we are free to drop the
> rtnl_lock as well.
> 
> Note that exposing DSA switch drivers to an unlocked method which was
> previously serialized by the rtnl_mutex is a potentially dangerous
> affair. Driver writers couldn't ensure that their internal locking
> scheme does the right thing even if they wanted.
> 
> We could err on the side of paranoia and introduce a switch-wide lock
> inside the DSA framework, but that seems way overreaching. Instead, we
> could check as many drivers for regressions as we can, fix those first,
> then let this change go in once it is assumed to be fairly safe.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
