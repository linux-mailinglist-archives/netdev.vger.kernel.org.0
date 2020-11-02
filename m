Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4E32A3566
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgKBUvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgKBUvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:51:52 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C6CC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:51:51 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 10so12207665pfp.5
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4ELFR3FthCVqTXckBw1n9FnhU0aq0SkQ6HP135ZVNjI=;
        b=vU7DR+V7NCrse/4cdqRT7v3lttp2aQRPVUz1ESYqeo/f6aDYAt8j9nr/PJWlAhYp/D
         ocuoZdBHGcZx2Z+CC4jGwkRUNFdRCvxDeqHbl3J3xmI5R0qxWIhhsMEOGQ8rm4Fj5mS9
         A1nLaG8jrTqZwbjNaB6drALkOOAMW7D+xKDNoEYggY2LtIModP08xFVUyzBH4MNQ5KUv
         U/UfyMTC9iPXLIirqXFBGthfe5s/LxethmU4kRsm1xflsR5l/iy9ThDR+ppYz06qLMwk
         XsMa5iAyIzcvXGDaCL8PRP1KBZW1k+LMSb+2+12yd1KhVl9m5AOJx3XwckYgaOORKPCp
         ycIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ELFR3FthCVqTXckBw1n9FnhU0aq0SkQ6HP135ZVNjI=;
        b=qFlM3tJJUle6jrKXt8wD2V6aMfOkiYlGHxukZe85mi5XQFFQnOGmvCX2/jkg3jM732
         84pKlqMkXKRrCKbm3JU1qNMoWW/Uhu/Lc+4CrhqAg5LVfpebeMhH3DuasDbJB7gqJDWw
         4Y1d5W14nPfU1nfcLhmrHh9sw/mn7MasxR574eq9SJFpzXh2vrhWyNpQAKguzg7t9CJk
         OVwbQIQxN4eMYrli1slLXHtaeEE0MUxl/dV9fYrv9rYxLOa4jE5U56uxW+/r3uZAtJkT
         nnpIKUmzVA6dBBY4STjh3JUQtMIWxhnxUNpPkTYR+kkmO9hdfX/lTWsSNFLU5XyLSASN
         BRkw==
X-Gm-Message-State: AOAM530AJX4O96AnN9X/nTQoRNgvs5elzeBIIK6cZhySl3p2A/e/rFLx
        JzvdOOYif8HDbY+9zbvd9d0=
X-Google-Smtp-Source: ABdhPJytOo1lnuzRVSNmEZL3YNkiXeASkMxrhnJuh4M3777wF+2qejrfnQgMI/XYeFOrPCJJtGOMow==
X-Received: by 2002:a17:90a:4b45:: with SMTP id o5mr18013465pjl.223.1604350311593;
        Mon, 02 Nov 2020 12:51:51 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j11sm14189502pfc.64.2020.11.02.12.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:51:50 -0800 (PST)
Subject: Re: [PATCH v3 net-next 08/12] net: dsa: tag_edsa: let DSA core deal
 with TX reallocation
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-9-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dd672cd3-a2ba-44ba-d737-7bede7854f7c@gmail.com>
Date:   Mon, 2 Nov 2020 12:51:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-9-vladimir.oltean@nxp.com>
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
> Note that the VLAN code path needs a smaller extra headroom than the
> regular EtherType DSA path. That isn't a problem, because this tagger
> declares the larger tag length (8 bytes vs 4) as the protocol overhead,
> so we are covered in both cases.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
