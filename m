Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B12A1FA5AE
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgFPBdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 21:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgFPBdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 21:33:42 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0122FC08C5C3
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 18:33:42 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id w9so14322106qtv.3
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 18:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cDOEIQV5YQAeIdEMMGx3+/GevUyhzhDnAbEIVpCOnXI=;
        b=B8O7J4rJokQDXjU31zgPybo1cTW2Je/Kd6MMZp1L9D1ePsA7Yu4unjGsty4wjVY6y5
         6KOLOawoFG95cEFHEsatqraAC7BNZXmTMnc1cgE/6paJHcMrwiZUwPlyLqKnmoXZzH6E
         f8uVTRRbgDFf56GPhBFtDkrkqau8ltI7y0uho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cDOEIQV5YQAeIdEMMGx3+/GevUyhzhDnAbEIVpCOnXI=;
        b=D2vMm8ZljL2bfXB1ENQfXVt9FwlkTf8/SplqeYy9XprMGwS8jl8N5p7ZxP6U9eH5rB
         tC95EvVmUeNZOeB6kBgH9qS9IGvJKVeVHJRxBYK7+ehaCDOS7+4JtOf5zrWDJ1tFOE1G
         rxVt117CzFkM0ptKeZ/Fde/u+2jnGQvlD/CImw1uQAS+gG/GI7FTin9isA9TSnLwTmZa
         KiLNiG71jAkLfWwFg7ZzXiMgxPMYchTiARgjcLjlffSxHTGi2aOwaJbtfa+xQlwm0cbN
         UjsJmIQ9iWfo5Ipgq9HgimDgsVZsYBhWIcE+k20zjyhdDOBtjLoxWdr9MU8m0AhvvPfN
         DOeg==
X-Gm-Message-State: AOAM533ZmhlM4saI0qMql/OWU1zLNKSHXo5iGTVp5QjGRWHfFUZlaKjb
        B1aIAwIMMFAJq25AO+hfgRlrtE52RdIxVKHLH+GnRw==
X-Google-Smtp-Source: ABdhPJzfoS6eBeapghRz9PNlO0sf80T4JJIcwcg/RDgpsN2vhEmKNBk9sSWTfS/Osmsto+Bn7eoaf1doTxFmQlzCvjg=
X-Received: by 2002:aed:35af:: with SMTP id c44mr18911337qte.349.1592271221067;
 Mon, 15 Jun 2020 18:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200615190119.382589-1-drc@linux.vnet.ibm.com>
 <CACKFLimd0a=Y8WyvqCt4BD7SU_Cg1vQ=baKs6-uPv0dZuCm=mw@mail.gmail.com> <95bf20c6-a812-32ad-fd38-45cba7e10491@linux.vnet.ibm.com>
In-Reply-To: <95bf20c6-a812-32ad-fd38-45cba7e10491@linux.vnet.ibm.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 15 Jun 2020 18:33:29 -0700
Message-ID: <CACKFLi=-2jUO4UU2BKERqee1XMOgf7OrGerurAf53B-axJwotw@mail.gmail.com>
Subject: Re: [PATCH] tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes
To:     David Christensen <drc@linux.vnet.ibm.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 3:21 PM David Christensen
<drc@linux.vnet.ibm.com> wrote:
>
> On 6/15/20 1:45 PM, Michael Chan wrote:
> > On Mon, Jun 15, 2020 at 12:01 PM David Christensen
> > <drc@linux.vnet.ibm.com> wrote:
> >>
> >> The driver function tg3_io_error_detected() calls napi_disable twice,
> >> without an intervening napi_enable, when the number of EEH errors exceeds
> >> eeh_max_freezes, resulting in an indefinite sleep while holding rtnl_lock.
> >>
> >> The function is called once with the PCI state pci_channel_io_frozen and
> >> then called again with the state pci_channel_io_perm_failure when the
> >> number of EEH failures in an hour exceeds eeh_max_freezes.
> >>
> >> Protecting the calls to napi_enable/napi_disable with a new state
> >> variable prevents the long sleep.
> >
> > This works, but I think a simpler fix is to check tp->pcierr_recovery
> > in tg3_io_error_detected() and skip most of the tg3 calls (including
> > the one that disables NAPI) if the flag is true.
>
> This might be the smallest change that would work.  Does it make sense
> to the reader?
>
> diff --git a/drivers/net/ethernet/broadcom/tg3.c
> b/drivers/net/ethernet/broadcom/tg3.c
> index 7a3b22b35238..1f37c69d213d 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -18168,8 +18168,8 @@ static pci_ers_result_t
> tg3_io_error_detected(struct pci_dev *pdev,
>
>          rtnl_lock();
>
> -       /* We probably don't have netdev yet */
> -       if (!netdev || !netif_running(netdev))
> +       /* May be second call or maybe we don't have netdev yet */
> +       if (tp->pcierr_recovery || !netdev || !netif_running(netdev))

Dereferencing tp needs to be done after checking netdev.  If we don't
have netdev, tp won't be valid.

Other than that, I think the logic looks good and is quite clear.

Thanks.
