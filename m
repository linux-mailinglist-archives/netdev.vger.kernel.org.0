Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A6016545
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 15:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfEGN7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 09:59:23 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43247 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfEGN7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 09:59:23 -0400
Received: by mail-ed1-f67.google.com with SMTP id w33so16490926edb.10;
        Tue, 07 May 2019 06:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c4qUAvfECC+5XnnozAJrEygXcMh19erkY9Z8c0W8zz4=;
        b=LiCljLFxU+I+ROMxt+Drpvlt9cCT3G4Fx5na1wBOG54AsZXFm/nrhOKzcoHFBnm2mO
         DOfqpzOqNkaFkjz59+OqLjk8w7K8/h/80dUgrSRraXySbx21wgjnMYwi6m2ss5qIBADs
         1Dy5nupzlgCfouz8KqIv87vpIYhdkPfktQregqQInYjTRMbmJudYQYDjxubv5EX5FMvt
         K7ZAuzIy2szKl51EthtG9j+3E+eUfDLjVa7hv4d0F30Ffh2OJvzO7b82NFHMBxLAjiq3
         HjlfgEW8crnISA1k1kN2IJ7FF6nXvit73f7RmyRv75YggtLQ4LGMSte71ianYpK3/PCe
         gQaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c4qUAvfECC+5XnnozAJrEygXcMh19erkY9Z8c0W8zz4=;
        b=NcXZnjmYR2eGlE7Jy0SKAFXrfvl51NYY6z5D7eEVT0bgiG8NstgAmhvjtQy+Z2jzut
         qRTA39ZTBnT5mKoDn7t5NPoRU5fQvasVFRsKTeHVhezrdiVLCDIPmW8pYMnTehcUW50U
         GN1KInquwP+4fKT9oBaMLrW4XsiiO+s22Xiy+8zFizQM/9UHjGRhEN72IDsGC/iTgWE/
         bseb1sArSbQftmTovy1GNhR2+Cdxeh6IDTx09fCnlJvzJE16qX3oltnMlNuS00AkuyGg
         Ic9N8NmhOE5DDqsoIjVKoTYDSYm8kbEg/11qCL2G8NEUAB/I5j9aqz0KtkP7go6ktOBH
         m6MA==
X-Gm-Message-State: APjAAAWgjVRnKYEVyCoQh0In+pxFPJnmVo6wjH63nu5oaOP1o0bhnMgU
        BPGFTB9zpZCAbz1Cim83+NAGh/wv67GRrpvXEX8=
X-Google-Smtp-Source: APXvYqxH4Q4BwOE6qyChi1eCxJOf+jcHtJWG150h5jBaAvMYs9tpbxLhKMxGNhR0giXV2aIBTMPFS9EpL44SwVwIBwg=
X-Received: by 2002:a17:906:6410:: with SMTP id d16mr24647031ejm.75.1557237561209;
 Tue, 07 May 2019 06:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190507103434.16174-1-colin.king@canonical.com>
In-Reply-To: <20190507103434.16174-1-colin.king@canonical.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 7 May 2019 16:59:10 +0300
Message-ID: <CA+h21hoEVYKTeGxSxPi0E1bWp1rBE=sG5T8MzGOBkranpdGhjQ@mail.gmail.com>
Subject: Re: [PATCH][next] net: dsa: sja1105: fix check on while loop exit
To:     Colin King <colin.king@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 May 2019 at 13:34, Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The while-loop exit condition check is not correct; the
> loop should continue if the returns from the function calls are
> negative or the CRC status returns are invalid.  Currently it
> is ignoring the returns from the function calls.  Fix this by
> removing the status return checks and only break from the loop
> at the very end when we know that all the success condtions have
> been met.
>
> Kudos to Dan Carpenter for describing the correct fix.
>
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>
> V2: Discard my broken origina fix. Use correct fix as described by
>     Dan Carpenter.
> ---
>  drivers/net/dsa/sja1105/sja1105_spi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
> index 244a94ccfc18..40ac696adf63 100644
> --- a/drivers/net/dsa/sja1105/sja1105_spi.c
> +++ b/drivers/net/dsa/sja1105/sja1105_spi.c
> @@ -465,9 +465,11 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
>                         dev_err(dev, "Switch reported that configuration is "
>                                 "invalid, retrying...\n");
>                         continue;
> +
>                 }
> -       } while (--retries && (status.crcchkl == 1 || status.crcchkg == 1 ||
> -                status.configs == 0 || status.ids == 1));
> +               /* Success! */
> +               break;
> +       } while (--retries);
>
>         if (!retries) {
>                 rc = -EIO;
> --
> 2.20.1
>

Hi Colin, Dan,

Thanks for the fix.
This portion below needs to be changed as well: "else if (retries !=
RETRIES - 1)" should become "else if (retries != RETRIES)" because on
success, it now does not decrement retries due to the early break.
Otherwise this message gets printed: "Succeeded after 0 tried" which
was not the original intention.
Please also remove the extraneous newline introduced at 468.

Tested-by: Vladimir Oltean <olteanv@gmail.com>

-Vladimir
