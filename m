Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2B73DE6EC
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 08:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhHCG7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 02:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233907AbhHCG7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 02:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B208F61050;
        Tue,  3 Aug 2021 06:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627973959;
        bh=4Sb+0NOSFm85LKdgmKosHIsr0gryivEtorknGClKzc0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TGnes8jOpj6iNpciHe/Ich4G5+4pDqiCAGNBduT9YDitlBkjcuK6yWBmWN67IgPVS
         EswliryEaIBjUMyDgglxZtwmwywFImbRj713uEMW+GbIkae9ihlWz5OLO0xgtssbYi
         cPXN2ncD2qg/IxeHwGB3C7ksdJC9Ghar9qCCn/gJxj6h7WTxexd4VFBacy5LxEjRVz
         LK5NOrskOw/eW/IjraAfBO/3NFoL5dm61FW1hu8vYvWl2wUvAPT1ejwSUGSEjTVyts
         3vPhByIal78BBCpNgCQFWGwY/meu3yj6Ad1trz9Sl/h3MJ1Vnp6mlWl3kDctf2z2Q3
         yk7w93q4b3SFQ==
Received: by mail-wm1-f46.google.com with SMTP id x17so5535473wmc.5;
        Mon, 02 Aug 2021 23:59:19 -0700 (PDT)
X-Gm-Message-State: AOAM5328fcEBa1z7RK6m/Jth42NKA/DAPEZYBsVnSXjLbo9tx6BfiFhm
        AfoLmRBfMjXX13nHnk1A9QM/3vrwpFoyKGPxG5Q=
X-Google-Smtp-Source: ABdhPJw6f6eacQ6aHBp9WoW5eKY4Ovz5FQXgdVsMZJU/hB32fKJbdMrav10kWSfqlmfhDt2zauF+Yc3fWxlYRpp9M8g=
X-Received: by 2002:a05:600c:3641:: with SMTP id y1mr11424785wmq.43.1627973958225;
 Mon, 02 Aug 2021 23:59:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210802145937.1155571-1-arnd@kernel.org> <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com> <20210802230921.GA13623@hoboy.vegasvil.org>
In-Reply-To: <20210802230921.GA13623@hoboy.vegasvil.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 3 Aug 2021 08:59:02 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
Message-ID: <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK dependencies
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 1:09 AM Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Mon, Aug 02, 2021 at 07:54:20PM +0000, Keller, Jacob E wrote:
> > So go back to "select"?
>
> Why not keep it simple?
>
> PTP core:
>    Boolean PTP_1588_CLOCK
>
> drivers:
>    depends on PTP_1588_CLOCK
>
> Also, make Posix timers always part of the core.  Tinification is a
> lost cause.

It may well be a lost cause, but a build fix is not the time to nail down
that decision. The fix I proposed (with the added MAY_USE_PTP_1588_CLOCK
symbol) is only two extra lines and leaves everything else working for the
moment. I would suggest we merge that first and then raise the question
about whether to give up on tinyfication on the summit list, there are a few
other things that have come up that would also benefit from trying less hard,
but if we overdo this, we can get to the point of hurting even systems that are
otherwise still well supported (64MB MIPS/ARMv5 SoCs, small boot partitions,
etc.).

        Arnd
