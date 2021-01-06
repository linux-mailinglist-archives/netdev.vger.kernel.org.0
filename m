Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7662EBC1B
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbhAFKIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:08:06 -0500
Received: from mail-vk1-f169.google.com ([209.85.221.169]:36755 "EHLO
        mail-vk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbhAFKIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:08:05 -0500
Received: by mail-vk1-f169.google.com with SMTP id d23so661328vkf.3;
        Wed, 06 Jan 2021 02:07:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NXNZpoA2ZSITq4uUe3zl/hOrh6XuKoXhuanjWZzX++8=;
        b=GCfPx5hDCjQA5SB42UOdmwUuDpXIrnLBGOAAi4z0xn+mMKYmsU6rooip+d6AzwH79g
         bD+x90ydneNJ/GaPFAg71gQzxe4P9pYrq8HvI3aTFd51EM9K5GcpVZcf2IePf5BQkLSV
         5n4J1If9GOBrDTZOKMMEj3QG0WZ5ZX2Cl644JYOVyxtjPNO6UhzgTtuqmXrfC28z2RMw
         Hkxbp5JwuB/RKgbQQMmLPmBUjdl4O1xbmBFAxJIhBnWnR8qc/hVKmhHC1y5nMbrWVzjx
         eqkTwOU+opXxwAU0OiTJ0WHxp8jlRV7kKLjoUttr29j8TSUlCe+jinw9FRex3ovDOTGo
         3fRA==
X-Gm-Message-State: AOAM5306NY3I+WquIkK4LSXJGY+YlLRbf6akoxBIQrrzHF7w7xodoHLx
        hO8SAdOeJ0Dw0MKlvUWmd4WTJGCMgZBUgQ==
X-Google-Smtp-Source: ABdhPJxecH6hcV4e1AjhlgizzMADUl+WrG93Z8eDPgai/b6T0NHVhSniptKOIz3HA7Tv5SVGznMbbA==
X-Received: by 2002:a1f:9310:: with SMTP id v16mr2793163vkd.25.1609927643970;
        Wed, 06 Jan 2021 02:07:23 -0800 (PST)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com. [209.85.221.180])
        by smtp.gmail.com with ESMTPSA id j8sm295179vsn.33.2021.01.06.02.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 02:07:23 -0800 (PST)
Received: by mail-vk1-f180.google.com with SMTP id u67so655526vkb.5;
        Wed, 06 Jan 2021 02:07:23 -0800 (PST)
X-Received: by 2002:a1f:180a:: with SMTP id 10mr2912690vky.2.1609927643242;
 Wed, 06 Jan 2021 02:07:23 -0800 (PST)
MIME-Version: 1.0
References: <20210103112542.35149-1-samuel@sholland.org> <20210103112542.35149-6-samuel@sholland.org>
In-Reply-To: <20210103112542.35149-6-samuel@sholland.org>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Wed, 6 Jan 2021 18:07:10 +0800
X-Gmail-Original-Message-ID: <CAGb2v66PVJ6chc83HC6R_x-LbwK4L3tcN2ZW+un_yx4jf4mtog@mail.gmail.com>
Message-ID: <CAGb2v66PVJ6chc83HC6R_x-LbwK4L3tcN2ZW+un_yx4jf4mtog@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] net: stmmac: dwmac-sun8i: Add a shutdown callback
To:     Samuel Holland <samuel@sholland.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>,
        Ondrej Jirman <megous@megous.com>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 3, 2021 at 7:25 PM Samuel Holland <samuel@sholland.org> wrote:
>
> The Ethernet MAC and PHY are usually major consumers of power on boards
> which may not be able to fully power off (that have no PMIC). Powering
> down the MAC and internal PHY saves power while these boards are "off".
>
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
