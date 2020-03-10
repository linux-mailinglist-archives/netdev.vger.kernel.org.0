Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D1317EE02
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgCJBaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:30:39 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36444 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgCJBaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:30:39 -0400
Received: by mail-ed1-f65.google.com with SMTP id a13so14337284edh.3
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 18:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x72GsgTs8LUH0IzY/nrWmESYQ7NFTKv+f++7YEp7gFg=;
        b=tD+fzfkdGbQMpNCBm1kIikpOoKgWbqSQMBzVVCPKm6Gn2TX5kU5mXjicUrsUKx51Pb
         MIdTHBaBEfJyBr6lETwC4nZq8owsK4jtyUE8YdKY/7uewEbsMnEU/Tay+1l3D6kuDFKP
         UomLMBzNdB5igOATSxiq/d7W1iA6ZrQr3sFdQFMLo2RPqF4crvlVqCQ5IxkNI7SpiOlG
         7qMP2fv7LFw6d+hro/NyoIT7L4KJgWWQ79FNWi+8sClGA/q5VGTsbHcZCAbpi2JsM20M
         i4lNk/4nxEa65W8Mvql324GFkfT50bfiGmM7q+ZSomsCaDpRPh8XyvUxRyoevbe5FOFO
         Z8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x72GsgTs8LUH0IzY/nrWmESYQ7NFTKv+f++7YEp7gFg=;
        b=rL0g29HqZ2CGc5iNyTGubrPxLBQZ+PdTjHLUZeAm+cjRd7Ltsc8BJNBpJfm/Vjw2b1
         ahwQZqcHuUXXgHcVFP1xWS2GGahGO2d/g2toGDZuqXm4EaFBdf2+ZbndNdDEqAcGwOnM
         gG8HialAuDFE3Z+NSrJ5VDwdiSUyY0lrGApG64JNf8ImHaOSAb1gnPU11ujsy+01eoF8
         Guf7DRSwNl5di2YI8iVHcss7ZW+ztu+n4dXdsOSsOlFq42OcGhoEvSl6vPozcx4QOfN4
         eAazrmA1mF+HROQcsc+5juY1l9IcIeR3tN+bJdfxI9Wjcf1d9CI1dt0Lbm+a4UtXdt6I
         NPRw==
X-Gm-Message-State: ANhLgQ0fsJ8AGbJK9+QPYjHQBhHSehu4ekPvSOaBHV1DPMLtFE4gk9ts
        kHsYiCt7JQ8jtSnmAG08RqhKigC8Kg2LSt8UAsM=
X-Google-Smtp-Source: ADFU+vur7t2fZZ4jKDIFEw/7Iutl49b2ThDErienJpKwk5oNg6fEqtqhsZJ9agsIzuvsFcXDqMBKMV1o8heI6YvprYc=
X-Received: by 2002:a17:906:9501:: with SMTP id u1mr16088076ejx.113.1583803837666;
 Mon, 09 Mar 2020 18:30:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200309201608.14420-1-olteanv@gmail.com> <20200309.175551.444627983233718053.davem@davemloft.net>
In-Reply-To: <20200309.175551.444627983233718053.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 10 Mar 2020 03:30:26 +0200
Message-ID: <CA+h21hrjTFiyNFhFL5vK=0ii7+wdER_kCWObMfSf_G_hP0B5rA@mail.gmail.com>
Subject: Re: [PATCH net] net: mscc: ocelot: properly account for VLAN header
 length when setting MRU
To:     David Miller <davem@davemloft.net>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Mar 2020 at 02:55, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Mon,  9 Mar 2020 22:16:08 +0200
>
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > What the driver writes into MAC_MAXLEN_CFG does not actually represent
> > VLAN_ETH_FRAME_LEN but instead ETH_FRAME_LEN + ETH_FCS_LEN. Yes they are
> > numerically equal, but the difference is important, as the switch treats
> > VLAN-tagged traffic specially and knows to increase the maximum accepted
> > frame size automatically. So it is always wrong to account for VLAN in
> > the MAC_MAXLEN_CFG register.
> >
> > Unconditionally increase the maximum allowed frame size for
> > double-tagged traffic. Accounting for the additional length does not
> > mean that the other VLAN membership checks aren't performed, so there's
> > no harm done.
> >
> > Also, stop abusing the MTU name for configuring the MRU. There is no
> > support for configuring the MRU on an interface at the moment.
> >
> > Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
> > Fixes: fa914e9c4d94 ("net: mscc: ocelot: create a helper for changing the port MTU")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This doesn't apply cleanly to the current net tree, please respin.
>
> Thank you.

Ok. Sent new version here:
https://patchwork.ozlabs.org/patch/1251902/
When you merge net into net-next you can use this patch as reference
for the conflict resolution, since it is going to conflict with
69df578c5f4b ("net: mscc: ocelot: eliminate confusion between CPU and
NPI port") - both rename some variables.

Thanks,
-Vladimir
