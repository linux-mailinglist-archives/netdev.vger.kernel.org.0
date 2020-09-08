Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7582F2613DD
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 17:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730606AbgIHPxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 11:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730872AbgIHPwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:52:37 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BBDC061797
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 05:02:49 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id t10so18871700wrv.1
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 05:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fHKZGBn8DYDZmUzkcQdtFyocASRnUskXF0G0c14zQIY=;
        b=I49U5h01ldadqbGBSJ+JPwaa/XpVL1RHekltbw+5yb9vJdeb7HlxO2SH/MxU+AXAwy
         mFX3smUOgYMCiRiMYtlhJgNbB0x45bfB59AcCGTmRd7oJw5HUypGbJ+wDCYeJroaA4or
         rnyPXVVdanOQ2bOVqv7iQHTy8xceM8lkCF844=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fHKZGBn8DYDZmUzkcQdtFyocASRnUskXF0G0c14zQIY=;
        b=bF2wY3jYC1fbzhTyUkxlQTMd8iJ16DeWvvkH+BreoJKVwkJR91UNQaMmKdbWTgIYGd
         NNu07BeKNk50Uv68ETXaYC5yNEpv08RxD0dkexQE8Cy/2dnnl6rMRKds6xyMCG+7WSjI
         RWjTJ+yODeTVdb/4IUuYCEukMlINR2hGGYGFlzMraYRKMXvRgPFmb10U7lSL8LpvL81x
         88Cyu1zZmgVz2ldQzXQkex9f0osal276b6WjQKvmonN1zGSTXQFgeLO0KEZlqUHfuh/D
         8zS2huncw5wBnJn1xibPQH3g8kxnJr6AvPjWdk3EnElD3nrTsowRBzfglXReXJQujKb5
         AGrA==
X-Gm-Message-State: AOAM53286iA+Pbaub3W+QMM3KH6TqAIDB+dAmyhfxftj6ssKCsONXivP
        JYIJzK9HFr+qqeXOHsIia9lDU7YpmVJVAtpn0S8eZw==
X-Google-Smtp-Source: ABdhPJxLDgBM+s6ZLA0Xk5AyltkUhSxI4KJM4wlm9qfxvCvlS9XOiwZ2ahmKEQRp2PPZaiGtIw02aY3u8gSTeR+ZTXc=
X-Received: by 2002:adf:eecb:: with SMTP id a11mr26936125wrp.356.1599566568481;
 Tue, 08 Sep 2020 05:02:48 -0700 (PDT)
MIME-Version: 1.0
References: <bad4e33a-af2f-b44f-63e5-56386c312a91@broadcom.com>
 <20200908001324.8215-1-keitasuzuki.park@sslab.ics.keio.ac.jp> <c13ee142-d69d-6d21-6373-acb56507c9ec@broadcom.com>
In-Reply-To: <c13ee142-d69d-6d21-6373-acb56507c9ec@broadcom.com>
From:   Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Date:   Tue, 8 Sep 2020 21:02:35 +0900
Message-ID: <CAEYrHjmG-R4RHn=59AGK8E0jKDXE5sbxQj49VpBvDMvBuBGiig@mail.gmail.com>
Subject: Re: [PATCH] brcmsmac: fix memory leak in wlc_phy_attach_lcnphy
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Takafumi Kubota <takafumi@sslab.ics.keio.ac.jp>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list@cypress.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for your comment. I am relatively new to the Linux
kernel community, so I am more than happy to receive comments.
Please let me know if I'm violating any other rules.

> > Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
> > ---
> ... changelog here describing difference between previous patch and this
> version.

I will re-send the patch with the change log.

Thanks,
Keita

2020=E5=B9=B49=E6=9C=888=E6=97=A5(=E7=81=AB) 20:18 Arend Van Spriel <arend.=
vanspriel@broadcom.com>:
>
> On 9/8/2020 2:13 AM, Keita Suzuki wrote:
> > When wlc_phy_txpwr_srom_read_lcnphy fails in wlc_phy_attach_lcnphy,
> > the allocated pi->u.pi_lcnphy is leaked, since struct brcms_phy will be
> > freed in the caller function.
> >
> > Fix this by calling wlc_phy_detach_lcnphy in the error handler of
> > wlc_phy_txpwr_srom_read_lcnphy before returning.
>
> Thanks for resubmitting the patch addressing my comment. For clarity it
> is recommended to mark the subject with '[PATCH V2]' and add a ...
>
> > Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
> > ---
> ... changelog here describing difference between previous patch and this
> version.
>
> Regards,
> Arend
> ---
> >   .../net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c    | 4 +++=
-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
