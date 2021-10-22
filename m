Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6952A437AF9
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhJVQfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbhJVQfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 12:35:09 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E4DC061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 09:32:51 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id y4so3137911plb.0
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 09:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5rpii9ljeyCTGBIGGGZyeVodcjyEXnb0CBrwOPHqZOw=;
        b=SulFKpzExi2y2Cau6iGyGMCMbWWQPvKoR3l+n13o2oTonwKo0v6rM90YhAsce9C6tk
         MHDzGOTls0LUBe5tK8vuVnuP8VxRJ7jm02LYP+IE+fWH6qCVX63p16EG7AzNhTyc8dZ2
         L/zrKKoSK1Q1NnlcIqkeOMZHFcasQcvnTN0kLVzvDv+w/h06+SbHJHqX4xkhY3fZ8fJm
         tXKsrzH/26BzGmnsaiNiQIJyT0X5m3/D00/7HAKhuEJAU/4bxPL7O8Ngrg7mBOuIhU/4
         JmvTM3T8Fm9h+p0lMaX2Nk2Lz1UvV2WzEwOUIjeHy7PzNFjd3Fy/lGNzI0ShUPkf2uFy
         M+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5rpii9ljeyCTGBIGGGZyeVodcjyEXnb0CBrwOPHqZOw=;
        b=E/F/t6IM4i0p5jDi+9qP64vu+8skDgFK6TDHBvPuoFR40Pbwia1Z9ewlg+xNYkfb4l
         tSp1ZiTcSk5av5NuhTmdC1+3EY4ByD8BXXKTdk21J/X2p78+7DzXZ+AGE0XBYDSsXmFw
         l6UB7kJjCyJE+Mqhbgbo3JaHqbCdDzwWVrAPCv8M1QpYtEWjQOwbgZYHBlxpW4SN/VL8
         vnuTqRGkpz4DR1mnHHDx4u2v7ZDbPm4pR7yA1nXw6LIZ0Iz/zrK6h4uUrzTmFmSZj0wy
         wI1Osz+4/Q+JKNR+CxtQFw36CSPkWN30Ct2HrZp5rr1JdvzudpQGu/UlIgmmy5RNeUmz
         8Xcw==
X-Gm-Message-State: AOAM533izjeabJKR2tPzyDNCWfEj8g/9NexGEy+DlKtw9SFEM0YXkSnv
        T8T4h7YQtwI+zIp1fRi836g=
X-Google-Smtp-Source: ABdhPJxBW8VHTjGKnH4KyuZrzMludIrv+iEuN3GnJ2SohHqmR5KU6cwUArV0CRMrtD7BevlP0y2e4g==
X-Received: by 2002:a17:90b:4d84:: with SMTP id oj4mr1079009pjb.58.1634920371393;
        Fri, 22 Oct 2021 09:32:51 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n14sm8590334pgd.68.2021.10.22.09.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 09:32:50 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/9] net: dsa: b53: serialize access to the
 ARL table
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
References: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
 <20211022141616.2088304-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a370b7c1-d4b6-7fee-0405-d3e9f9c9837b@gmail.com>
Date:   Fri, 22 Oct 2021 09:32:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211022141616.2088304-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 7:16 AM, Vladimir Oltean wrote:
> The b53 driver performs non-atomic transactions to the ARL table when
> adding, deleting and reading FDB and MDB entries.
> 
> Traditionally these were all serialized by the rtnl_lock(), but now it
> is possible that DSA calls ->port_fdb_add and ->port_fdb_del without
> holding that lock.
> 
> So the driver must have its own serialization logic. Add a mutex and
> hold it from all entry points (->port_fdb_{add,del,dump},
> ->port_mdb_{add,del}).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Only if you need to spin a v2, small nit below:

[snip]

> +		if (ret) {
> +			mutex_unlock(&priv->arl_mutex);
>  			return ret;

I would be tempted to create an out label and have all of those tests
goto that label in case of error, just so there is a single place where
we unlock the arl_mutex.

Thanks!
--
Florian
