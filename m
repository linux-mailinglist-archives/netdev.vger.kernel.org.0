Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F91D302700
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 16:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbhAYPhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 10:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730000AbhAYPfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:35:40 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F0DC0611C0
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 07:25:43 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q1so27231736ion.8
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 07:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r+wfrvqtOpxPoqdtWvG82QG2jp5MbSFV+Tu1UFjBSDM=;
        b=RHRTj5fcCfCRzDmSKGv539mFjvdCDijLz7Y7rUyEaCS8oZmksrBSiET40Da/3LgEXV
         NSai00HiTAUDGIs87nf5c+y17/XxDBS05Ea9CzTD1ZNjFes0ydKJhAY4N76dClZK+88r
         +G0NSYUSEw1lsKE9xvurkLIhBMvpKW+MoRCz7hkWVvyQ+2A/HGSyZ/iu0nGYk6LuKF2/
         8XIAK+BEfTOysDXHKU3IGtvhV758xkpP09ze0UpokIB3K8l+IK4E6U00DEUjWhs7GVLN
         AMoc9f68SEJu3lbZiUVFSh5FXsquFUIoSBc1D5bi0Hs0rZZ1XovKB7gHn1TTjFqg/G5e
         xKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r+wfrvqtOpxPoqdtWvG82QG2jp5MbSFV+Tu1UFjBSDM=;
        b=FzrhwdrgvTeK18ULCvJA9AQdAjxqe7ptLIE99LU2m7OpSUDHoq+0IooGQyGjjSJ7VX
         CgmMg30RFLyxYF6D9sHtZpDmSDR/3VYlGQ73U3P1D5KlBGbgC5N0Kk6+gEsnz8mVTX8H
         pRSdt7V7Lpy+st6YH74X40ydgQptuTR+ADz+1dTPXisTR+/KAGA//fBNJ95eRcW3D2vU
         jNgyqx0VhX56UDv9TgB9dBGlZmdinVPGtDsS0vEGaZB+K6AvFZUDzTucgFWprTdng/n4
         SobCB/OCMAtY5OTMjU9qxgxfP6ut3NrvVVAOj+QixswB0DhyjwF04zxiD8dhE0j7+Hkw
         UUhg==
X-Gm-Message-State: AOAM533RUJ0qVCy04XNAogtMFct8iwCm12L1iSM8IRKD3abgy1VuHInY
        OLqDDcsBIf1r/mToN8ywW3sn7IVpV0CJUJ8LAUtpfA==
X-Google-Smtp-Source: ABdhPJzFnvqEgbnL8Mg0JMnCYP+Zt8gPrVuABjrRQKuC6ErxkE2h7yfn+nhzAFr67AT2WR37Ln9FaaQ0bj+iTj4+tMM=
X-Received: by 2002:a05:6e02:1d0e:: with SMTP id i14mr754933ila.69.1611588342867;
 Mon, 25 Jan 2021 07:25:42 -0800 (PST)
MIME-Version: 1.0
References: <20210125150949.619309-1-eric.dumazet@gmail.com> <97cf98b0-d464-1901-f01f-ac5dd362561d@candelatech.com>
In-Reply-To: <97cf98b0-d464-1901-f01f-ac5dd362561d@candelatech.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 25 Jan 2021 16:25:31 +0100
Message-ID: <CANn89iLn5HVzuCJvCeZaV3e6CNJyzsM7GO38kWEtvm0i2s5UTg@mail.gmail.com>
Subject: Re: [PATCH net] iwlwifi: provide gso_type to GSO packets
To:     Ben Greear <greearb@candelatech.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 4:15 PM Ben Greear <greearb@candelatech.com> wrote:
>
> On 1/25/21 7:09 AM, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > net/core/tso.c got recent support for USO, and this broke iwlfifi
> > because the driver implemented a limited form of GSO.
> >
> > Providing ->gso_type allows for skb_is_gso_tcp() to provide
> > a correct result.
> >
> > Fixes: 3d5b459ba0e3 ("net: tso: add UDP segmentation support")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: Ben Greear <greearb@candelatech.com>
> > Bisected-by: Ben Greear <greearb@candelatech.com>
>
> I appreciate the credit, but the bisect and some other initial bug hunting was
> done by people on this thread:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=209913
>

Well, I do not think bugzilla can display full names/emails ?
