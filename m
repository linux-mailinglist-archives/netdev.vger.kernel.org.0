Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D3C342888
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhCSWMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhCSWLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:11:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB3DC06175F;
        Fri, 19 Mar 2021 15:11:50 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w8so5327413pjf.4;
        Fri, 19 Mar 2021 15:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ClRzW2QCAQcrf4DlWK10ME5VHfuCpEFnQZzwtpdNUQs=;
        b=jiMPQ82090dqZCq+McNDTYGipkoQN+pqPay7OcaWh05jWKa50MmYrdRqeHXBwK/dj2
         S8W/ppmnyz6lVtX39hqpw1+VSMmsxnSd7FNEIoCHO8TK2NMFQ+MX9moVVA5kjVPMGJ2t
         gbdSCuHPVQTPPn+OcXh3r/J56cAyAFvPDU/3e5irpOpGi0fOnV1jP1AL6LNlKbYngPAk
         lJsTLwmQLfZWJlLoOeTjuRVFeiGLaT/9jd5ep992qA3rhlb0Yd9U9RzhNF+qNK9QsiQG
         /X1T4dDgRLTYnP/lcllwG6F+7Hs3nXjpnFBYfQQPVogVHCfaMrc0uSGcSH7CPIR9kbun
         SNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ClRzW2QCAQcrf4DlWK10ME5VHfuCpEFnQZzwtpdNUQs=;
        b=WGTorT6Bh/GTKM11D0JjTm7Gf+eDDSd1FCb6QSIl6plJSx6f3vWx5s/RykWEYWfm7F
         EiRKgDClW8+W4ixJIvGmpX7XAnPtl8Dpu0zXfcmup30PV2TINwOS1KGOJMur15G4nK0s
         5+mhTfY7WDqZuXs8QZ0jQ9Kd7cknEJ0AmHqzrO/RloJAt9gmqXjgJxEWHxfOAldBLzIt
         vNPaRPWKlBEC92qboIt8tmjQgRYyBOdg3QNDPHZFMsX/7vCUq9k0gtda/f2VUOkljtDy
         I5t6Ng2YIEFapNWaDsQGJEBhFod0YBrl2QejiFZ+AeHyUhpHRYfUsEb/+mkYYhCuODpm
         j0bg==
X-Gm-Message-State: AOAM531UnOoKkVHV+FVqdc5ETXivZW2DApvYzQtvG87yodGHdvy41o9V
        Bwiw4RnBL0GzZINmTnarF7A=
X-Google-Smtp-Source: ABdhPJwu/Oyszq6atPTx1nRQj2VEElJpo9u1ALctp9D8rbI8CVH9Y+lBmrHQ9Cdp0HQA/tmYpJiRsA==
X-Received: by 2002:a17:902:7407:b029:e4:9b2c:528b with SMTP id g7-20020a1709027407b02900e49b2c528bmr16353293pll.6.1616191909843;
        Fri, 19 Mar 2021 15:11:49 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v7sm6408027pfv.93.2021.03.19.15.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 15:11:49 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 05/16] net: dsa: sync up VLAN filtering
 state when joining the bridge
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8fb46d86-0519-6381-c3ce-ce1a78327e3a@gmail.com>
Date:   Fri, 19 Mar 2021 15:11:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318231829.3892920-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is the same situation as for other switchdev port attributes: if we
> join an already-created bridge port, such as a bond master interface,
> then we can miss the initial switchdev notification emitted by the
> bridge for this port.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
