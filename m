Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46F92A3559
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgKBUqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgKBUpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:45:36 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22D9C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:45:36 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id x13so11790394pgp.7
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rNFP+10VaLHRX3o3jPP47G5NkJi9yOP0Ibf78pNiPQk=;
        b=Y2kQ1sh3b3623gHBTSFmhtEq63ZOdG060L3YuIy3NtswdBGmW1ALDu2FqQ8URwxTBc
         4/JX6sdaMzAsl8bgX1Au+tTyWIVtwM2EeIc5OwHefX+4Ko52bDFF+Srh0mVL3oqFS5lP
         bCNJBBKdkeRd0hGjxqXhkar0k91SCgKOpdxnhs6Ks7dJ8EW4T7RjoZhX9lOnDDsbSZ6A
         Z2sXzDOdHCz/A3tyw6J2BP+of1CXcbTtEsLEwwgrkd+xmfbfaIGZY/GU/O2tmG6MC3i5
         Wl6pIRG3obavM1vpwUQrVtMzdwHTT3c4bRTqF6U1mCNKvrxY4lxLgzXrAx40KdPM17Hp
         /IWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rNFP+10VaLHRX3o3jPP47G5NkJi9yOP0Ibf78pNiPQk=;
        b=gtiVPsyYrW/wcEZ+fCqmWGpo9ZeIq4vKq5fdcSlL9n59NpyZJ7I8ZPJbK+6jjbR85M
         gppTixITd/Mv49srN15Igp7Yw+HtRVPf4UQ2jE+AHW7RUAMbnFokGfKueuO8xIjox9EN
         TFkEhuqSdnEElXzvHrl1oWieZfkHiRWskU1AYSumlX5ZZcGRWhTI+ruB40dBmyHE5fTN
         P4/de087Ex8JSi0P6Ltm+6xEm89cn53PloEiEpU4RKP1p6xylyT9LhwQ9qCCTQZ2LDKw
         S5zG8ELIC9xxVKcyFO/AgIw6iPWmjRuGkFF2KcBE+GK4qksHLyPyUrFi3fzTqfo/XvzT
         0ttw==
X-Gm-Message-State: AOAM530/swBHMf5ck28WX0keQt8S0DmLeGQHnaUIS2wTZ0UTwhve0lYM
        Ma3EK4iykN4W1tg0OT2Pt3A=
X-Google-Smtp-Source: ABdhPJyVedPL6c6Oo5LUp6YRjrFB239y9KEFoqYM4Tp7jV+B0DS83oCinmU8wSW6nCGL5yIROiV7qQ==
X-Received: by 2002:a17:90b:89:: with SMTP id bb9mr4067950pjb.53.1604349936410;
        Mon, 02 Nov 2020 12:45:36 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r7sm10156576pfl.7.2020.11.02.12.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:45:35 -0800 (PST)
Subject: Re: [PATCH v3 net-next 06/12] net: dsa: tag_mtk: let DSA core deal
 with TX reallocation
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f96f8414-9061-9d2a-712a-ec0e712ad205@gmail.com>
Date:   Mon, 2 Nov 2020 12:45:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 11:16 AM, Vladimir Oltean wrote:
> Now that we have a central TX reallocation procedure that accounts for
> the tagger's needed headroom in a generic way, we can remove the
> skb_cow_head call.
> 
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Sean Wang <sean.wang@mediatek.com>
> Cc: John Crispin <john@phrozen.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
