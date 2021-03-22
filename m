Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E366344A25
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhCVQC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbhCVQCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:02:14 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663FBC061574;
        Mon, 22 Mar 2021 09:02:14 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h3so11234826pfr.12;
        Mon, 22 Mar 2021 09:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TxgbwfvEeZkYrurUbnEsv0ASlZPTTYngpuV8wfALc4E=;
        b=K1sZxYsl1lU9BZnL153NgkXJqBOxZrUtg3mgKt/7sAcVRAAN/TuR2zX57IlYKJ6BZp
         iBGwMhtjLaM0XNb5yH7/AucltIiZ9jrlCduhYQXHGbOC8UXP68jS3Gwvz0lxgo1/rTse
         9s2NUYOR+HTrLHQdDKZsl6met+Fz2OKZEnPZ2vEcv6k1mJiDALM/tJNig3MvWJNHS/m3
         99IZMPUtocx7RAvcKXoYLLH1CEvLeAWu+2+A5p9cfFIMzOa6GYu4LjNIpkFtKOuwuF76
         x5W4Vvc4p+0TfsxEYGCQNHS28lpsLVjScUZl37T92ygyVrmh57MSZqtkX64xpK5x097/
         BLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TxgbwfvEeZkYrurUbnEsv0ASlZPTTYngpuV8wfALc4E=;
        b=nFl919tUgSUfaxIEz3Vglh7zRXYFgR3R6yP5EHj+0sFZF7DQuWLX0g/SBX8gZ/PjHi
         H6qqm5P76o/47MmWIm1PxBe6uNK7YvNP20v4sBRsA5bmlj5Gn9idfK4BIip6lrYJxkwa
         qR2IBi2xldUqyAQ7ax+URLUhOBHkho05VaYihxmV8E575pDtunBVvKExe/uFjW23L5w7
         M93cadw+CvZjfeiLazmQNIRfSgm12/T1OPSbYMPz9bAY4sPCncCdRlE5WTSWPg7fxGKp
         1MNQiLe5PqV4NODD0WyXBLK4om0fRpFqRSvw3aZhnXr4ZUrZEvrh7RKlNsa7UtE902SA
         13Bg==
X-Gm-Message-State: AOAM531sM8vX8R/iI1YzUBjOayZkrnLPe6QrnC52dLsF2IYd5+xTIuDj
        c9eI2wIbZnI06n05B2h/Khk=
X-Google-Smtp-Source: ABdhPJxxqffz5n4czoiK7aqYkClImLDnROA9GCY8UTQlt9OEAEiaLgjXTLmAGDdx8HTCtvPd7/qfXA==
X-Received: by 2002:a62:83c6:0:b029:21b:b0e5:4560 with SMTP id h189-20020a6283c60000b029021bb0e54560mr474188pfe.69.1616428933847;
        Mon, 22 Mar 2021 09:02:13 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i14sm14646584pjh.17.2021.03.22.09.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 09:02:13 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 07/12] net: dsa: sync ageing time when joining
 the bridge
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
 <20210320223448.2452869-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4c481471-debb-f2ce-8368-ee0241efc53f@gmail.com>
Date:   Mon, 22 Mar 2021 09:02:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210320223448.2452869-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/20/2021 3:34 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME attribute is only emitted from:
> 
> sysfs/ioctl/netlink
> -> br_set_ageing_time
>    -> __set_ageing_time
> 
> therefore not at bridge port creation time, so:
> (a) drivers had to hardcode the initial value for the address ageing time,
>     because they didn't get any notification
> (b) that hardcoded value can be out of sync, if the user changes the
>     ageing time before enslaving the port to the bridge
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
