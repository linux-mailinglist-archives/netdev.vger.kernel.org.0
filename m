Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46051EB089
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 22:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgFAU5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 16:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgFAU5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 16:57:43 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6FDC061A0E;
        Mon,  1 Jun 2020 13:57:43 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id x1so10534026ejd.8;
        Mon, 01 Jun 2020 13:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+q672Wm8RukSMAWeN/YA/sItHHH/mir9+L1tWbNB+s=;
        b=GmHrz8MVf147mDH/wLfr8OfPIg+fBn52wicTgcXORVUKlX4JSGV0WwZkoT+hAEeglo
         Ejy5Gf+7fHkCPBLFqr76r8eS4QCrLwXTVgHkJbHybdrJMz3MDGv2E5fsFM/wfmjkuafX
         m57KQUgZCsIBrIIACm+YZel5rFdZaU3GNUtV76+hl86ogJxnCDdRGloKUZnrugTnwrep
         w/DMGN+Lt31tPDflDPMA274YdK1XHSS8I3euiOoMTLAbIE65FHMpz/JLe0OMOeGRtUEe
         8BmHL0nz1oLmQOQq+D4O5FvdOHAc0z4mQTEihcJCgBBbHy4VCRb+a/Sw83uz9RKX8J0v
         afHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+q672Wm8RukSMAWeN/YA/sItHHH/mir9+L1tWbNB+s=;
        b=N0/+AcY2tUexpvbfptFuExiBAGi8Bc8HTWKAuWKe0B8fGo9ZdDZ0FTrQ8+mTGPtmqD
         kJ0Tvjz4VCKAVkG1vh+hEfMpbP856TPoE+61DmYvXmRSlQp1CsHFv66TONk+LIJQQd/W
         mRkX7Hn0JUJQwiw0s0MW8YeycNqMamTRj9vs3CxnZ71T1Qll1E2dav1+3zATYeCiAEVt
         pz2ZoaEpKoo/sUVg7zoRwcum0ni7HgUaYMxfE4AvQtct7y6YsAn9RYrw8oPZfn0sk8Zg
         m/XPl467H+XMMIvmqmbS4mQZ3mjNW4EkjzjoHzwoYS6WFzKhy475JrywC8bsiOEYoL7T
         UuPg==
X-Gm-Message-State: AOAM532If+xvkLLAvbLujReDPy0KhckUkFs5mg5hFIiQZ1qXsn6fjDGv
        1HUD5BEWQckymPuwWKZPDjnAX2C5h3tw/kDVFHk=
X-Google-Smtp-Source: ABdhPJxNZXlLtgMBTb/NUfyafm9mA+K7TqA2PFOiO0urCp6L/2jatgEYM7dNNptJdifLlcjRCGxibjaVUFl/sRAux9A=
X-Received: by 2002:a17:906:851:: with SMTP id f17mr9857533ejd.396.1591045061794;
 Mon, 01 Jun 2020 13:57:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200530214315.1051358-1-olteanv@gmail.com> <20200531001849.GG1551@shell.armlinux.org.uk>
 <CA+h21ho6p=6JhR3Gyjt4L2_SnFhjamE7FuU_nnjUG6AUq04TcQ@mail.gmail.com> <20200601002753.GH1551@shell.armlinux.org.uk>
In-Reply-To: <20200601002753.GH1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 1 Jun 2020 23:57:30 +0300
Message-ID: <CA+h21hqongWM=M7E_0d+Zb_qOsw-Gc4soZXoXd_izciz6YeUpA@mail.gmail.com>
Subject: Re: [PATCH stable-4.19.y] net: phy: reschedule state machine if AN
 has not completed in PHY_AN state
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, zefir.kurtisi@neratec.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Jun 2020 at 03:28, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Mon, Jun 01, 2020 at 12:00:16AM +0300, Vladimir Oltean wrote:

> > This is all relevant because our options for the stable trees boil
> > down to 2 choices:
> > - Revert f62265b53ef34a372b657c99e23d32e95b464316, fix an API misuse
> > and a bug, but lose an (admittedly ad-hoc, but still) useful way of
> > troubleshooting a system misconfiguration (hide the problem that Zefir
> > Kurtisi was seeing).
>
> Or maybe just allow at803x_aneg_done() to return non-zero but still
> print the warning (preferably identifying the affected PHY) so
> your hard-to-debug problem still gets a useful kernel message pointing
> out what the problem is?
>

Maybe.

> > - Apply this patch which make the PHY state machine work even with
> > this bent interpretation of the API. It's not as if all phylib users
> > could migrate to phylink in stable trees, and even phylink doesn't
> > catch all possible configuration cases currently.
>
> I wasn't even proposing that as a solution.
>
> And yes, I do have some copper SFP modules that have an (inaccessible)
> AR803x PHY on them - Microtik S-RJ01 to be exact.  I forget exactly
> which variant it is, and no, I haven't seen any of this "SGMII fails
> to come up" - in fact, the in-band SGMII status is the only way to
> know what the PHY negotiated with its link partner... and this SFP
> module works with phylink with no issues.
>

See, you should also specify what kernel you're testing on. Since
Heiner did the PHY_AN cleanup, phy_aneg_done is basically dead code
from the state machine's perspective, only a few random drivers call
it:
https://elixir.bootlin.com/linux/latest/A/ident/phy_aneg_done
So I would not be at all surprised that you're not hitting it simply
because at803x_aneg_done is never in your call path.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up

Thanks,
-Vladimir
