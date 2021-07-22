Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9E13D273C
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 18:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhGVPZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGVPZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 11:25:00 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471B0C061575;
        Thu, 22 Jul 2021 09:05:34 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e14so4971408plh.8;
        Thu, 22 Jul 2021 09:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j2FsvvMjL+4fkX/qUSaxx8KmLD31gvj7x4fULCDYfgU=;
        b=sWeeV6OY2qjEevZJ3PinYmi3I+R6SvzTknE3eAhUDm+xLXcTpTNhTD9aEjM6uuswAb
         wygOuptdWE5oAjXkHo9toZ25qlGwqaLjFvaMObztxFMHRCIptYpvQz356QSxwsqzUY/O
         RFGfxTZvop+rkm8P5TvZi0yO3D3rcBBpyDPyRXxtHp2eh5WK3YM2aCY5DHAQsBsc74dX
         /akfn+OL4zigoGt1jHgEiRd/OnfmgBp85P5Kf9c+GHVK9uDj+lriohCgBkzw918ew8Mi
         n9jzX7iHfWMkEr9N6asNEFjktf11vTCATxSH/OPxTkKRBXSkQ/jB0fgnAecG8ionxzjG
         AnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j2FsvvMjL+4fkX/qUSaxx8KmLD31gvj7x4fULCDYfgU=;
        b=LSzdATwzUW1P16HvFmmNPDZIpcwBO/xl+IXgbI4QEpWm7MAg3Z7Dag0n680+AhdH5W
         oO8HgJolCHjUBJ4WqhlSHNVVYhMXNBCe9iYaCZLrCVbapVl2hKPm7HbJNQRRbAh52dV5
         q8lZClAxEiiMsGkGQMAGOeJBzXHkIhyxaObxLIJ4c4iUgU9Fx4I/5M1qQMKEPf9+Qia1
         Q1SIROb+npDwLnXwOqoV3f3G0BtZHV+UXJvDL55cD7Lrhim7ce5zxTGtU9/4cV5KIxLS
         q96m1+FOjkfikuZbj0tb3/71JIMmQeRavGqJFn+/07j1+BepgeaZWZU8rzOZE2HzFYFQ
         NB9Q==
X-Gm-Message-State: AOAM5335u+UDP/rcErlg2wrrpehp7XvYpwvVpdlNyUW0P3iHU5Bfw5HW
        JrwBwz+b8L2Tjeoa/gWg1gtydVuPTjQ=
X-Google-Smtp-Source: ABdhPJwOFGetWq/MdpAHO3k9946yJ5rSE7KTUGX/d4x0iNJAjozk9IhOMg3oT3Xke6K4x5XPPTjz0A==
X-Received: by 2002:aa7:8e51:0:b029:332:920f:1430 with SMTP id d17-20020aa78e510000b0290332920f1430mr546029pfr.1.1626969933198;
        Thu, 22 Jul 2021 09:05:33 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 201sm9157622pgd.37.2021.07.22.09.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 09:05:32 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] net: dsa: ensure linearized SKBs in case of tail
 taggers
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
 <20210721215642.19866-2-LinoSanfilippo@gmx.de>
 <20210721233549.mhqlrt3l2bbyaawr@skbuf>
 <8460fa10-6db7-273c-a2c2-9b54cc660d9a@gmail.com> <YPl9UX52nfvLzIFy@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e5ad77b7-377d-1f03-0335-54b6d6e890be@gmail.com>
Date:   Thu, 22 Jul 2021 09:05:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPl9UX52nfvLzIFy@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/21 7:14 AM, Andrew Lunn wrote:
>> Agreed, with those fixed:
>>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Hi Florian, Vladimir
> 
> I would suggest stop adding Reviewed-by: when you actual want changes
> made. The bot does not seem to be reading the actual emails, it just
> looks for tags. And when there are sufficient tags, it merges,
> independent of requests for change, open questions, etc.

Yes, I will definitively stop doing that. I did not think that the
merging was handled by a bot, but if it is, that makes me seriously
nervous about the whole process.
-- 
Florian
