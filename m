Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AAF294ACE
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 11:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441537AbgJUJwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 05:52:35 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43906 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441494AbgJUJwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 05:52:35 -0400
Received: by mail-ot1-f68.google.com with SMTP id k68so1274909otk.10;
        Wed, 21 Oct 2020 02:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kJkrnozfaMLpPcgeu/Q+YTzE8Ukz50ZnvbK5wInOKOU=;
        b=hsJrxhB23aYwgW88F304oLcUlluJ1SHAZKZYo5o2QyOv31yqelwKHXh2NbMutyrvxI
         cRjsqXAIErONu+pOtQiWApXhHPXNxjXbx5Sthe8Uu+jXuUwRw9lwLwVVxMgRNgplgo9A
         ZIepRsbEFh4R3999oOFGA5X/d2b3BVQpOposPMK7k1LZzjSMmvOa9tfzqMvsKXOuECDF
         0T/7GYMS9SIxDeIgVVzQtRCHw7W6XN/gu0yDVl5PVzLU4p9JygUfhYGXdfcvtbkFpM7i
         io4kOo9hmGm0173yA3gaflTQ5GFrrSMKpmDJaEfqz+B0gZhg0WQOaRAR1nCjY7G5qAb6
         0tyg==
X-Gm-Message-State: AOAM531JHpCpafpqIECIK2IUcMbiBzHfQh0s5+yFYupKyG4Zq+11W9Uc
        jlqZ7hvePWEyJsdciAO5jV4RO8ZlbXL9V+0mHME=
X-Google-Smtp-Source: ABdhPJxRL1fZFFVN/iPeCd5oyAHWxUtsED20zwFi/bX4gbl91pWAbXJ1nSc2fCMrLdWhZW8medycvhcheAmarhLGqVM=
X-Received: by 2002:a9d:3b76:: with SMTP id z109mr2017856otb.250.1603273952560;
 Wed, 21 Oct 2020 02:52:32 -0700 (PDT)
MIME-Version: 1.0
References: <20201020073839.29226-1-geert@linux-m68k.org> <5dddd3fe-86d7-d07f-dbc9-51b89c7c8173@tessares.net>
 <20201020205647.20ab7009@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMuHMdW=1LfE8UoGRVBvrvrintQMNKUdTe5PPQz=PN3=gJmw=Q@mail.gmail.com> <619601b2-40c1-9257-ef2a-2c667361aa75@tessares.net>
In-Reply-To: <619601b2-40c1-9257-ef2a-2c667361aa75@tessares.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 21 Oct 2020 11:52:21 +0200
Message-ID: <CAMuHMdXUs_2DodcYva8bP+Df979TMrmRD=+LUiVVzdH0zmxK1Q@mail.gmail.com>
Subject: Re: [PATCH] mptcp: MPTCP_IPV6 should depend on IPV6 instead of
 selecting it
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        netdev <netdev@vger.kernel.org>, mptcp@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthieu,

On Wed, Oct 21, 2020 at 11:47 AM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
> On 21/10/2020 11:43, Geert Uytterhoeven wrote:
> > On Wed, Oct 21, 2020 at 5:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >> On Tue, 20 Oct 2020 11:26:34 +0200 Matthieu Baerts wrote:
> >>> On 20/10/2020 09:38, Geert Uytterhoeven wrote:
> >>>> MPTCP_IPV6 selects IPV6, thus enabling an optional feature the user may
> >>>> not want to enable.  Fix this by making MPTCP_IPV6 depend on IPV6, like
> >>>> is done for all other IPv6 features.
> >>>
> >>> Here again, the intension was to select IPv6 from MPTCP but I understand
> >>> the issue: if we enable MPTCP, we will select IPV6 as well by default.
> >>> Maybe not what we want on some embedded devices with very limited memory
> >>> where IPV6 is already off. We should instead enable MPTCP_IPV6 only if
> >>> IPV6=y. LGTM then!
> >>>
> >>> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> >>
> >> Applied, thanks!
> >
> > My apologies, this fails for the CONFIG_IPV6=m and CONFIG_MPTCP=y
> > case:
>
> Good point, MPTCP cannot be compiled as a module (like TCP). It should
> then depends on IPV6=y. I thought it would be the case.
>
> Do you want me to send a patch or do you already have one?

I don't have a patch yet, so feel free to send one.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
