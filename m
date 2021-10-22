Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D34E437E3E
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbhJVTNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbhJVTM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 15:12:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAC9C06122D
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 12:09:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so3690673pjb.5
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 12:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nLiv7nTkqKtaeMc0HlO/nkxybj+dHXLWywhlvZsmZ7Y=;
        b=BQBaN5Q5Os9J2vkRezzEIaKwaCJR4YHV77v+6k+94wl7Rs9b6tCxv2mFQted1uuOaH
         wBVVjXw0+VvWnIRN0RaACKqkZfYwzeAnAz4ml7svKr+rb5aIMBlPnlsOH8fDrFMfQRDU
         cxncOiKeQn7plgnN8fGlXVM7s80FM3FWUfJWPKVt/oqeDAvzrs72ecXX/SU+IkIUVmf5
         W9DzbaoSFeICxCIodkEddg4paYE1LZGxIPPg97uEKK8rdThZ0xUKeN6Y01PkUiWiWrf2
         Z077ie24Mc9Z2aJjUDOA1ZYH3EO0dVoNWw8eR8aagP+JDFzeajhsLdcPXGGdmL9rk993
         eJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nLiv7nTkqKtaeMc0HlO/nkxybj+dHXLWywhlvZsmZ7Y=;
        b=bCHj24z87nlpc1lNNj4Ngp3pgll731+gQb+8DIOe3EValgvurr7GfFIfX8sMDJqEVo
         JE/A9aWbgnz+JpAZqvAMjETCBO7OkUaQdWQm3Rmhye77xf8li4tRlqzB4xuIqJ5FhGuR
         /UH9rZEv/ZPgZ0PHFlcdpm5vv8NXQZyVDcfOocnEOU9UE0qggPYGbZlyBHK3xhtWGWQf
         TP2+WA0S3DlswwhAFV4L2LYwacNlLqgYJt3yyIVK/JiHY6EgiqrdLVbogiYtH06rnfpQ
         AbJoxaVby6Vc252YbONXldHEuotUc3vO7YcoMy2ACPEP50Wxo1WiumNNEfSD1LigIq3a
         swAw==
X-Gm-Message-State: AOAM531pBCr5UXHWcBGGVq0LAmQGqsuTwwoOCNm2J3uISmBYav6sj66B
        1g3be383xgWq4iwY8/iUK6U=
X-Google-Smtp-Source: ABdhPJzlbAQcrFUxX68U1INmu9kqws9QcIWFzcGGvb+4UyGIvuQy+naTTFeTQ7LDizKYyVT70u6bzg==
X-Received: by 2002:a17:90a:d24d:: with SMTP id o13mr16980204pjw.59.1634929775486;
        Fri, 22 Oct 2021 12:09:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id lw14sm11446489pjb.34.2021.10.22.12.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 12:09:34 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 5/9] net: dsa: lantiq_gswip: serialize access
 to the PCE table
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
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
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
 <20211022184312.2454746-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f456f43f-1341-b8a1-788b-e2c8dd2453c6@gmail.com>
Date:   Fri, 22 Oct 2021 12:09:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211022184312.2454746-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 11:43 AM, Vladimir Oltean wrote:
> Looking at the code, the GSWIP switch appears to hold bridging service
> structures (VLANs, FDBs, forwarding rules) in PCE table entries.
> Hardware access to the PCE table is non-atomic, and is comprised of
> several register reads and writes.
> 
> These accesses are currently serialized by the rtnl_lock, but DSA is
> changing its driver API and that lock will no longer be held when
> calling ->port_fdb_add() and ->port_fdb_del().
> 
> So this driver needs to serialize the access to the PCE table using its
> own locking scheme. This patch adds that.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
