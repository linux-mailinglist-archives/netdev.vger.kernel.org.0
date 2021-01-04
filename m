Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043632E963C
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 14:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbhADNna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 08:43:30 -0500
Received: from mail-ua1-f43.google.com ([209.85.222.43]:39250 "EHLO
        mail-ua1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbhADNn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 08:43:29 -0500
Received: by mail-ua1-f43.google.com with SMTP id t15so9076990ual.6;
        Mon, 04 Jan 2021 05:43:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8VbMSWmEqU8F9kIb/ExiNCnMs16r+n245ZIQPcdpXYw=;
        b=dqjFTOa+vj6lOg3qJLCHfXgu9okVP/qEoI0jZ0xLXuE/AkYLcV1NocncjHMveSMA4T
         5wMMqBvamqSmBnDQFilF07Pgn7eQmfrs1GFxSgoRy1RBeT7NygD6Ij2gZF1geakqRiVz
         NRXmXuHs/mrejmrMFCXfVKQCbBoBI+c1c6hv4H1LWmgiWWf0g7rUubUCTs6IwdyWmSUo
         DYjPICyVSw9shqtJsSHzjSVZ/Pi0+u0zYk94/FeHhb9b79HMQ3nLgEnJ458njEqwKc4A
         S2nRnflDGFIwoAl864EX/6ii2HX12txMgh5i3se4AdU1IjdZe0EtPfczVqTVW1huR2pF
         r0/w==
X-Gm-Message-State: AOAM530i+njn5i9xqb8i8h8map0mTjTdOWzYeiIwlAP3icN/M80xYIt5
        XHumO41Yt/i1VioOTZbDsK8AS/9d4eQtjQ==
X-Google-Smtp-Source: ABdhPJyFlNkFVEw3TgdwD3DJjdZs6kpBrp7tPOPxTaTy3AR9Dc/ioj/TeqLhFGQHpW3YcTQ/A4YVdA==
X-Received: by 2002:ab0:2:: with SMTP id 2mr33200229uai.108.1609767768342;
        Mon, 04 Jan 2021 05:42:48 -0800 (PST)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id v202sm2075761vkd.51.2021.01.04.05.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 05:42:47 -0800 (PST)
Received: by mail-vs1-f46.google.com with SMTP id e20so14480453vsr.12;
        Mon, 04 Jan 2021 05:42:47 -0800 (PST)
X-Received: by 2002:a67:ca84:: with SMTP id a4mr46523862vsl.2.1609767767700;
 Mon, 04 Jan 2021 05:42:47 -0800 (PST)
MIME-Version: 1.0
References: <20210103111744.34989-1-samuel@sholland.org> <20210103111744.34989-2-samuel@sholland.org>
In-Reply-To: <20210103111744.34989-2-samuel@sholland.org>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Mon, 4 Jan 2021 21:42:37 +0800
X-Gmail-Original-Message-ID: <CAGb2v67c-2ZHadh=Es6eKyRYOHWi+Q5Tf9dxX_dkbK-Z=mHs-g@mail.gmail.com>
Message-ID: <CAGb2v67c-2ZHadh=Es6eKyRYOHWi+Q5Tf9dxX_dkbK-Z=mHs-g@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net: stmmac: dwmac-sun8i: Fix probe error handling
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
> stmmac_pltfr_remove does three things in one function, making it
> inapproprate for unwinding the steps in the probe function. Currently,
> a failure before the call to stmmac_dvr_probe would leak OF node
> references due to missing a call to stmmac_remove_config_dt. And an
> error in stmmac_dvr_probe would cause the driver to attempt to remove a
> netdevice that was never added. Fix these by reordering the init and
> splitting out the error handling steps.
>
> Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
> Fixes: 40a1dcee2d18 ("net: ethernet: dwmac-sun8i: Use the correct function in exit path")
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
