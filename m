Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19D3D142E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhGUPq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhGUPq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 11:46:57 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75456C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 09:27:34 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id cu14so2003454pjb.0
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 09:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E8q+sxQ/OKWc9Yjv2NdwSWvKkf3e/JsO3sjkasoj5T4=;
        b=PFbCjhOF3i/Qih8MWpNpCV1WDr1IkD812JarIXVhPKFUS9GojJTTe9Laxl6eXH9Ox/
         lI5XNcYavP+RTWIGHN7tfcaET9UVWn70R26wRRPg0q6y1T5yr6QdY3wIghHroOC6Kw1V
         XGzivzeBTQU9Cn3p/4OYMqb115LRSNYarpmjRC4rgVLAeC8p2msJQ6SZN3OGyn8OwbAJ
         nsBXbx8ENY96O0ku0YZc9gJysN8/aiYyMetHRXBGhhTGlhIr4dhITRRQxTC5Mqt3uzkI
         8QYa6s47awW6f9ZQT986o03QSi7re61pvRzgVt7aej4jGk64HrmMbl/BKbxU1oLw15an
         x+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E8q+sxQ/OKWc9Yjv2NdwSWvKkf3e/JsO3sjkasoj5T4=;
        b=Wnp2oVQ5xP3Sxz/NKjLyTzxLw+zix/KF0bYWoBeenneslCM7zN1qtkhjKaDjyDnVtZ
         z5KFdkdJFIbv3oxBaxuusju8Lk+q2jqMxeUu1YXBYhAMbnw7wEUDayPAbXjvl3fQyLAV
         sEq6dH2WP20noJCUL7XMV6QiaYr6B0Ku34F5/78OlnMx6Xj0XFY3H6JpyFvq3ysb+upG
         ZW46jfJoMoGv/rOBLr9uQGdMnj9EcEWrDNRGZK6NVHx7wC0q/WuM5sWUDcxYOa0O46/C
         D52qILdzn1XUIr+el6NWNnFYS3wZoBHTPRnYgIgo1LB2TIys9Hhzy3Pc0adIWK344J9T
         QQSg==
X-Gm-Message-State: AOAM533fyv5PC0+Zq5PwfpKLND2xA/p05QKBuQvF9NgYV9uKsqcdjITH
        p41A5ggbJjTTg+4Yew10UUo=
X-Google-Smtp-Source: ABdhPJxrYFS6u6g9J7Ib9385Tt61Rm23ceo93gcW4Llpb4g/1KXiS9LQEmXOMJjdAaWUUEnFV/Gj2A==
X-Received: by 2002:a17:90a:7441:: with SMTP id o1mr35327306pjk.96.1626884853939;
        Wed, 21 Jul 2021 09:27:33 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t2sm2344224pjq.0.2021.07.21.09.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 09:27:33 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 6/7] net: bridge: guard the switchdev replay
 helpers against a NULL notifier block
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
        DENG Qingfang <dqfext@gmail.com>
References: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
 <20210721162403.1988814-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dce98c0f-5ec4-8a54-209e-7891d239fbc9@gmail.com>
Date:   Wed, 21 Jul 2021 09:27:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210721162403.1988814-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/21 9:24 AM, Vladimir Oltean wrote:
> There is a desire to make the object and FDB replay helpers optional
> when moving them inside the bridge driver. For example a certain driver
> might not offload host MDBs and there is no case where the replay
> helpers would be of immediate use to it.
> 
> So it would be nice if we could allow drivers to pass NULL pointers for
> the atomic and blocking notifier blocks, and the replay helpers to do
> nothing in that case.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
