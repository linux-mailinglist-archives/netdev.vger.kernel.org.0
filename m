Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE32627ABC1
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 12:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgI1KZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 06:25:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38042 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbgI1KZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 06:25:05 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601288703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RS8aaD/teCyQjHIzfzURMvl8u+n+j/rIgE5B0tuRdqE=;
        b=gefvSazqCe4P8yXMo6E5U3J2nl9MRIsoO0COTSGGhv6CaqV3kK47f3WLpsoS162+/W9/Vc
        Wkzqk6yvWPGwPTL2eAmHgrG3XH/+ywXzrlCVryyrOnGaUtfzn4Tijwv/s1YNtCkS0vEhrG
        +4YN1IIfcrakr2TzIlS9lSPb9AyFXfZrXkhJw1HF7Pi6y5zrgk9waDEU48V9Kw+lPeZLly
        Wu1mg8ha3QHNKHUEwLgWa6tKTwRcGJLzAda1mhslxVkZ1je+KWGN3kAPZD7ly/wCWCC4CD
        OnKYpfAfsMlO2sywS2GlLfQG5j5EJ4fk8dHmS+9cCbyjOqWVrFmGedLp39lLug==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601288703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RS8aaD/teCyQjHIzfzURMvl8u+n+j/rIgE5B0tuRdqE=;
        b=OxHd7EyfzbyMOnvuIYpsPknE9szpQG6fIVC/UtImzmuMTucnagAwUguEK0km7NFiEUZ3/L
        u706LrSyXdPBgFAg==
To:     David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        torvalds@linuxfoundation.org, paulmck@kernel.org,
        willy@infradead.org, benve@cisco.com, _govind@gmx.com,
        kuba@kernel.org, netdev@vger.kernel.org, corbet@lwn.net,
        mchehab+huawei@kernel.org, linux-doc@vger.kernel.org,
        bigeasy@linutronix.de, luc.vanoostenryck@gmail.com,
        jcliburn@gmail.com, chris.snook@gmail.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        snelson@pensando.io, drivers@pensando.io, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        tsbogend@alpha.franken.de, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com, jdmason@kudzu.us,
        dsd@gentoo.org, kune@deine-taler.de, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, stas.yakovlev@gmail.com,
        stf_xl@wp.pl, johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com
Subject: Re: [patch 00/35] net: in_interrupt() cleanup and fixes
In-Reply-To: <20200927.135707.1699954431349573308.davem@davemloft.net>
References: <20200927194846.045411263@linutronix.de> <20200927.135707.1699954431349573308.davem@davemloft.net>
Date:   Mon, 28 Sep 2020 12:25:02 +0200
Message-ID: <87blhqkxkx.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27 2020 at 13:57, David Miller wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Sun, 27 Sep 2020 21:48:46 +0200
>
>> in the discussion about preempt count consistency accross kernel configu=
rations:
>
> Please respin this against net-next, some of the patches in here are alre=
ady
> in net-next (the wireless debug macro one) and even after that the series
> doesn't build:

Will do.

> drivers/net/ethernet/cisco/enic/enic_main.c: In function =E2=80=98enic_re=
set=E2=80=99:
> drivers/net/ethernet/cisco/enic/enic_main.c:2315:2: error: implicit decla=
ration of function =E2=80=98enic_set_api_state=E2=80=99; did you mean =E2=
=80=98enic_set_api_busy=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>  2315 |  enic_set_api_state(enic, true);
>       |  ^~~~~~~~~~~~~~~~~~
>       |  enic_set_api_busy
> At top level:
> drivers/net/ethernet/cisco/enic/enic_main.c:2298:13: warning: =E2=80=98en=
ic_set_api_busy=E2=80=99 defined but not used [-Wunused-function]
>  2298 | static void enic_set_api_busy(struct enic *enic, bool busy)
>       |             ^~~~~~~~~~~~~~~~~

Duh, not sure how I managed that. Sorry. will fix and rebase.

Thanks,

        tglx
