Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4C8437C01
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhJVRg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbhJVRgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:36:25 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237A1C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:34:08 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h193so3963295pgc.1
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dfH3O1yK29p6Sft3ZefCIKd68w7UPknwQlfkKwbGJMk=;
        b=Y8sZXH2YLELQXjCgZyMHcIe5Td4xE7SW3uK+O5H5+crQaupyDrVhwLv8wqlMqLlbLT
         AWatNNdOtl8bG8bEJ2YbnTuR2FoDZe2+JMNe4cGZC7leI7LxEVrNlM9hMKMg9Fkdo17C
         eayFrZ5lezd4I6E3Dm+qHRDx2MuN5JIufiX1Idvu4I7rVNchR/ahD8UZfEPwGDZtFUcI
         q51hi1O+FghXJcxFNabkyxdTRmIoJbvwkRVZ+CZifTzGI4eg5Ich3NZ8a7grT39nU1LA
         oKAHwmnh6ALwRhTCNm4M66jyHLqavQXYxAxC83m9mkxvMZcLCu2lL9esBoUiZq1R9E/z
         071w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dfH3O1yK29p6Sft3ZefCIKd68w7UPknwQlfkKwbGJMk=;
        b=O+9oAzKB2aHch2OVsUW0fLYVuAL2zXXXyM0jTdCrlx9WhCpr1bNoLI/iqBOe9zdayD
         XGUUrfbmGrr64c4aFfGlcFNp7zyp1sEdbQ0Mzj7pTAcKRxtujcVZMDg3uGwSBrPdUWJJ
         EgL7GVZT1w+ltBzAEb5Qxbv5+qf4WzDjSUMkfv4eGlUNeQZupKrslVk2m7Lu+R/2Kq4j
         eqjNDMYusmKhwiIonQf2sXVLKwDmBhhg3LBEP9iHKZvslPUx2COARnSON+1gZlj8ztn4
         GkhA4u3V+cCIX8DX3tAHHd+RvqOg0o6n+JNnncsntQCgg9t4fiGGLWURmYaQUor2uvfg
         ELsQ==
X-Gm-Message-State: AOAM533yRw18lPtGUd3C42ptbdaXr7KHg86DTUwp5Jkt4/nnlTa8ZGE5
        AvTjDFvIeamhCD7fWc7YFZc=
X-Google-Smtp-Source: ABdhPJwBsXUKKgZZOS7d55kq7RwgBJLuy4+yTm+EPSYRcfdGyEpO5abHPIzTY8qM9v1drKzPxxS36w==
X-Received: by 2002:aa7:8891:0:b0:44d:a66:2f1b with SMTP id z17-20020aa78891000000b0044d0a662f1bmr1211195pfe.22.1634924047652;
        Fri, 22 Oct 2021 10:34:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x13sm9098575pgt.80.2021.10.22.10.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 10:34:07 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 3/9] net: mscc: ocelot: serialize access to
 the MAC table
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
 <20211022172728.2379321-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9628072d-612a-ec6f-ce18-03c7f95ad5dd@gmail.com>
Date:   Fri, 22 Oct 2021 10:34:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211022172728.2379321-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 10:27 AM, Vladimir Oltean wrote:
> DSA would like to remove the rtnl_lock from its
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handlers, and the felix driver uses
> the same MAC table functions as ocelot.
> 
> This means that the MAC table functions will no longer be implicitly
> serialized with respect to each other by the rtnl_mutex, we need to add
> a dedicated lock in ocelot for the non-atomic operations of selecting a
> MAC table row, reading/writing what we want and polling for completion.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c | 53 +++++++++++++++++++++++-------
>  include/soc/mscc/ocelot.h          |  3 ++
>  2 files changed, 44 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 4e5ae687d2e2..72925529b27c 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -20,11 +20,13 @@ struct ocelot_mact_entry {
>  	enum macaccess_entry_type type;
>  };
>  
> +/* Must be called with &ocelot->mact_lock held */

I don't know if the sparse annotations: __must_hold() would work here,
but if they do, they serve as both comment and static verification,
might as well use them?

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
