Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2262E9642
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 14:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbhADNnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 08:43:46 -0500
Received: from mail-ua1-f47.google.com ([209.85.222.47]:34363 "EHLO
        mail-ua1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbhADNnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 08:43:46 -0500
Received: by mail-ua1-f47.google.com with SMTP id k47so9084859uad.1;
        Mon, 04 Jan 2021 05:43:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DWf6z2OIC+lTWIgt6fgK7fJgxdAn3XFKyGff4CPvkec=;
        b=DmEEw1/UZsaY8+0sdoqdic+3nuLC8n7UF1KWyKUaVKIJFEzF9AB6qhMzBD98gFxKxO
         Pqg5eTlLLEBfdjSiQ/ZI18SojKrJlCxGGTzCcg/VvPZH2vHoyEFf0uCsLoKMQWtzJcVo
         ZD/w1Y1+WUewD8rhE2eZJVj9WQb3Z/H8W6VrPsrne89rgH8Uge+K8TtVBcgKMLcUadHN
         MNPO4Sryc012yPh35ogPJeQ17MTqLGoW2Fq+DMs3hxvo3DNK02ipq7eXREXq+31ngfWF
         VWGpqHq8YGfrlTORQoK6c5ETnJ3+lKS+OEI11XMZKROzy+5NzmSetWduM1OBEZ1ktZ29
         11fA==
X-Gm-Message-State: AOAM533EnJS00LTFBBmZJcO4k9hhP0uJ8icfV6d/vn128w1ivpK1+oXK
        NqaHzO0e/TYS27SyWkHui0K99muJUU5Gkw==
X-Google-Smtp-Source: ABdhPJwURuqUQQ13R/03kupporf20305BQ+I4bcbG49fQfqdKm/uq9ncyM2/La7E1TCsKk5PyXtHdw==
X-Received: by 2002:ab0:2a01:: with SMTP id o1mr36318366uar.133.1609767783938;
        Mon, 04 Jan 2021 05:43:03 -0800 (PST)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id f1sm8526287vkb.46.2021.01.04.05.43.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 05:43:03 -0800 (PST)
Received: by mail-ua1-f46.google.com with SMTP id 73so9078844uac.8;
        Mon, 04 Jan 2021 05:43:02 -0800 (PST)
X-Received: by 2002:ab0:6512:: with SMTP id w18mr43605161uam.55.1609767782501;
 Mon, 04 Jan 2021 05:43:02 -0800 (PST)
MIME-Version: 1.0
References: <20210103111744.34989-1-samuel@sholland.org> <20210103111744.34989-3-samuel@sholland.org>
In-Reply-To: <20210103111744.34989-3-samuel@sholland.org>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Mon, 4 Jan 2021 21:42:52 +0800
X-Gmail-Original-Message-ID: <CAGb2v66j+xj-Pq5ijcb+HwLUf0TZkDDnpHcTjj20Q+M2UEtqUQ@mail.gmail.com>
Message-ID: <CAGb2v66j+xj-Pq5ijcb+HwLUf0TZkDDnpHcTjj20Q+M2UEtqUQ@mail.gmail.com>
Subject: Re: [PATCH net 2/4] net: stmmac: dwmac-sun8i: Balance internal PHY
 resource references
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

On Sun, Jan 3, 2021 at 7:17 PM Samuel Holland <samuel@sholland.org> wrote:
>
> While stmmac_pltfr_remove calls sun8i_dwmac_exit, the sun8i_dwmac_init
> and sun8i_dwmac_exit functions are also called by the stmmac_platform
> suspend/resume callbacks. They may be called many times during the
> device's lifetime and should not release resources used by the driver.
>
> Furthermore, there was no error handling in case registering the MDIO
> mux failed during probe, and the EPHY clock was never released at all.
>
> Fix all of these issues by moving the deinitialization code to a driver
> removal callback. Also ensure the EPHY is powered down before removal.
>
> Fixes: 634db83b8265 ("net: stmmac: dwmac-sun8i: Handle integrated/external MDIOs")
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
