Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26747331527
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 18:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCHRrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 12:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhCHRrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 12:47:16 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB37CC06174A;
        Mon,  8 Mar 2021 09:47:15 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id k2so9612608ili.4;
        Mon, 08 Mar 2021 09:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sMKJhv2mzJOGTerVdFexLl8nyHCo/hJ5Vn7sQjFVS5Y=;
        b=jR94KJGGxkVVBPT4hgFRPVtMB0iLlfvsXDFnXh74Td+1jWpralwfT2vyDliLDFNTWx
         3bvYYhGs7Zv4ku7HITInDSZ0vPuVH0dTd2VlCeoGUhx+2OivbOLkm3jYNJ/9TdiMvsWn
         YBSXK1QP5/BcO0lAGlgmilPSysPZrPxXJdzKHblKz3RcrFM0e5XrA5tGLWyLzcOxWDBQ
         24uKR8G0DLgS+OQPs/Q2NBtxTQgKOHS/40YrQMD3Bi6FotRjxjQHc4igjpji/GaFuDex
         FAydP1tYBwTFhm1eLyYX389P/k+sk4TJdAab8N0GpRRJnzHfgOkSM5ugl5sIxM2I5Uuv
         u8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sMKJhv2mzJOGTerVdFexLl8nyHCo/hJ5Vn7sQjFVS5Y=;
        b=L5eRrYuDAsYrJA34OfuHEL7MJ2uKRRTG2aKMmamRx/pfMUZLfplzXyebObEyWzVZ/i
         cq/IU5sXVdcayWeYvXVxC9XqdA713QfsirrYtX6iZCl/aYe+I/kCgFsNotmWI7pTco/7
         72DkkaydntifR78RYQpPqrudOpv/AjloICt6jftm7sOpX5RKq29U0z9DiCaPLQltxyrq
         H6fKMbxsSLZlM4+oeFFgdELb5cc1XC4LyyjkdvV531KQBKeDfefqHCZeSeskSn8teof/
         0gZ198FHaT89PqbvMJq/h1fAS94dNdsjSJfMGHZeVNTixqQoOoxC+6NwIaJBKdLSbOm8
         itPw==
X-Gm-Message-State: AOAM5304sqQBZ9DP8j0+vrH0l3KJ16nV9dEhDn6Y/9kPwTHQdrHTVmzd
        F8oZ8gS/9+6f/Remh5hDFRETX0wB9Ow7khSjTi1GOxiPhQA=
X-Google-Smtp-Source: ABdhPJyUhn/AeHgikfhQCvdOnwDbW0ym9SvabMduTSBWo+pC2hxFCegO79I1gn2RqkPVsMI9FVVPhxa/nV7JlhmlHSo=
X-Received: by 2002:a05:6e02:2196:: with SMTP id j22mr20705311ila.64.1615225635083;
 Mon, 08 Mar 2021 09:47:15 -0800 (PST)
MIME-Version: 1.0
References: <20210308032529.435224-1-ztong0001@gmail.com>
In-Reply-To: <20210308032529.435224-1-ztong0001@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 8 Mar 2021 09:47:04 -0800
Message-ID: <CAKgT0UftdTobwgA6hi=CdOfQ+1fdozhPs89fDmapbvcp7jLASw@mail.gmail.com>
Subject: Re: [PATCH 0/3] fix a couple of atm->phy_data related issues
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 8, 2021 at 12:39 AM Tong Zhang <ztong0001@gmail.com> wrote:
>
> there are two drivers(zatm and idt77252) using PRIV() (i.e. atm->phy_data)
> to store private data, but the driver happens to populate wrong
> pointers: atm->dev_data. which actually cause null-ptr-dereference in
> following PRIV(dev). This patch series attemps to fix those two issues
> along with a typo in atm struct.
>
> Tong Zhang (3):
>   atm: fix a typo in the struct description
>   atm: uPD98402: fix incorrect allocation
>   atm: idt77252: fix null-ptr-dereference
>
>  drivers/atm/idt77105.c | 4 ++--
>  drivers/atm/uPD98402.c | 2 +-
>  include/linux/atmdev.h | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

For the 2 phys you actually seen null pointer dereferences or are your
changes based on just code review?

I ask because it seems like this code has been this way since 2005 and
in the case of uPD98402_start the code doesn't seem like it should
function the way it was as PRIV is phy_data and there being issues
seems pretty obvious since the initialization of things happens
immediately after the allocation.

I'm just wondering if it might make more sense to drop the code if it
hasn't been run in 15+ years rather than updating it?
