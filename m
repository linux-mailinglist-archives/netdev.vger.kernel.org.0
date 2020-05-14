Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C131D3F6F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgENVAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726201AbgENVAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 17:00:04 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354E8C061A0C;
        Thu, 14 May 2020 14:00:03 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id l21so139812eji.4;
        Thu, 14 May 2020 14:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oLhuR8HS5ejq1vXdwrdSp2iS9vK3c80XB67HZI/sIAk=;
        b=JMzyOVelIl+D9VNYc15hQhibmAOQzixQf4tza209c9xFcrofC0aFYUgCqQyVqaWR6y
         TjIu6J6lcvsg0lSB4aPOWfIcu/1nWI4S881QE5RpIwGZyD1WwAUgq/JLOfa3Y370tYVb
         ix2giNJIK+fNr9sn7qxiCL3N+7yDSg4TMGHDRxRPAgjHh25J9mCVLgmLftlBonarlQBC
         ljSonxdNOe1oHwhBPqRIetmmdLO9mzXhEO05PlOFI9RdsXfc9mKQYN8T9pcC+oX/vjgT
         o5sMS4OZs9sFH4f5qNUH6Dgho8UcEv0jfushG8dzbsIqyU0M3dx7uLJjMYxHDrYXJ0c4
         lPqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oLhuR8HS5ejq1vXdwrdSp2iS9vK3c80XB67HZI/sIAk=;
        b=r2L00ODy9SatTvnYhrtDblevwRJLXjN4uNnhkGEqpQrS4CmKf5xn9vKQBKqtshPEjN
         zYkirOje6zoYUsu7LFRl3KYR1jyxTWPGC9v8HJXTzjFYQtuVKKeljFy3JZWF6seN/B7E
         1eo7ka1Xdz9JqC4JoEDulcJc4yh+OIt8LGBsxenYIjN+XgxUq7aQOTGS8fRp8X6Hs2Uf
         +UHWCcXvwiNeKbywfy7PEE6pHsqUog4iySCzmCeEiZlHas7/s8kAzhXAFvUxjxunthol
         AoVaQPf5zJbojRHJGrlLyZM74Rz59BDK3KAq/x8I9GkvOlJF7e6u300sETRb8j75eE2v
         9Sgg==
X-Gm-Message-State: AOAM530Ln88wZjptlg2A+noDEBr8olnfcjNJWMd/utZxfzVwKFhHVY7D
        WiLkZfRmPiHy9QvUF3D+lMrsk4k3uAt7REIZqCoVNSq8
X-Google-Smtp-Source: ABdhPJxxoY1f6fVa6YQPSyhvR2jwvZmnKgI9b2jjpnJ9nf4hE4za+JJteHbAUqFch4+Lo2HWdonQM8Ko1nVkTp1pcZA=
X-Received: by 2002:a17:906:27c2:: with SMTP id k2mr5592477ejc.239.1589490001827;
 Thu, 14 May 2020 14:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200514183302.16925-1-colin.king@canonical.com>
In-Reply-To: <20200514183302.16925-1-colin.king@canonical.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 14 May 2020 23:59:50 +0300
Message-ID: <CA+h21hpdw5aXLnS0VRnf1XWkseKY83pAoqvUuM09xAFLHyrqWw@mail.gmail.com>
Subject: Re: [PATCH][next] net: dsa: felix: fix incorrect clamp calculation
 for burst
To:     Colin King <colin.king@canonical.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Thu, 14 May 2020 at 21:34, Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently burst is clamping on rate and not burst, the assignment
> of burst from the clamping discards the previous assignment of burst.
> This looks like a cut-n-paste error from the previous clamping
> calculation on ramp.  Fix this by replacing ramp with burst.
>
> Addresses-Coverity: ("Unused value")
> Fixes: 0fbabf875d18 ("net: dsa: felix: add support Credit Based Shaper(CBS) for hardware offload")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/dsa/ocelot/felix_vsc9959.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index df4498c0e864..85e34d85cc51 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -1360,7 +1360,7 @@ static int vsc9959_qos_port_cbs_set(struct dsa_switch *ds, int port,
>         /* Burst unit is 4kB */
>         burst = DIV_ROUND_UP(cbs_qopt->hicredit, 4096);
>         /* Avoid using zero burst size */
> -       burst = clamp_t(u32, rate, 1, GENMASK(5, 0));
> +       burst = clamp_t(u32, burst, 1, GENMASK(5, 0));
>         ocelot_write_gix(ocelot,
>                          QSYS_CIR_CFG_CIR_RATE(rate) |
>                          QSYS_CIR_CFG_CIR_BURST(burst),
> --
> 2.25.1
>

Thanks!
-Vladimir
