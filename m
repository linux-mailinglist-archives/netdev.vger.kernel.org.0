Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDE53CD205
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbhGSJzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 05:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbhGSJzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 05:55:43 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE35C061574;
        Mon, 19 Jul 2021 02:43:20 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id c17so3006547wmb.5;
        Mon, 19 Jul 2021 03:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z0X9y/lDNtL87bpbBdWAHXnXi5ZZR2DEsvITW9WU+Ow=;
        b=ivtnYf6oY3VW1qZ9gJU5TOuNYFInsWGpX/L5R+O/hukf0IavtW9yKBl/SEr//dzigb
         oWshTwmLhf8IBeDUMwkqknBgVORUHZBE1pgOz8a8+a4mgAaG8X+7A+YgrDSZsxN4GFQ2
         iHxs9hKXrqufvdexpXBPy5VBTY6AQjf1BwkefMYn57s4W9ktCGlMWktY3YfnePn8tJfy
         EUTDjavjnRPUitlbnU/tanC5rSOaS67ps/Ih7wlgkok/qd7V0khqnUXuViD6k4EO6ziX
         Rcc4FjRbilyp3dPK3e3uBH3pRQJwEmx3e50S6km3WZPioYORLleZqIuohW60Wgm44TH8
         1Atw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z0X9y/lDNtL87bpbBdWAHXnXi5ZZR2DEsvITW9WU+Ow=;
        b=gLrSpLOee/l/TiCyRvoLAZn06oPgl+iI7W1pPr6wACVfmTshxRI1afUliKi05a7Lst
         xq/Ox8EpSDkewe5snr488MShpgBcQJ7PVdvgZme8t3hCJM35uKnZuRcIpEZQ2O9vdv0a
         i22KeC8CijwHN13dDgQY04TEP2YmYiyLIe9hgx1E5T0xt3GClf7o1navChKHAOCK6HNB
         2zN4fAXx9w3HeaGau2X53+FI3oAsL8zmnoPveUD1nDZGUiELF1twrm8hUKxlLbQFWXES
         ZEy8civb5p7zwyu5jjknHleRbC4R4Q3b9amSLkfYbv5bfFoi1TtoYIe5ZASNq3eVNcWl
         pqDA==
X-Gm-Message-State: AOAM532kKNiq2+8zy/Kptjao66SOUzHYj/ZSl9l7oLq5SNzLAoMvgFKW
        22Te/+1sRpvO6YoLzeMBTZsDoIRQDPJ63rD0azA=
X-Google-Smtp-Source: ABdhPJy7PaMSlTPT5+4WNzlo/jagkWEZ/FWGrVOaqegHMGeX1nECerUJ/MvUu5+cffU0nvJCpSkpVPp70mB5kZpyolA=
X-Received: by 2002:a05:600c:246:: with SMTP id 6mr25128473wmj.180.1626690981597;
 Mon, 19 Jul 2021 03:36:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210715080822.14575-1-justin.he@arm.com>
In-Reply-To: <20210715080822.14575-1-justin.he@arm.com>
From:   Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
Date:   Mon, 19 Jul 2021 16:05:45 +0530
Message-ID: <CAJ2QiJLWgxw0X8rkMhKgAGgiFS5xhrhMF5Dct_J791Kt-ys7QQ@mail.gmail.com>
Subject: Re: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()
To:     Jia He <justin.he@arm.com>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nd@arm.com, Shai Malin <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jia,

On Thu, Jul 15, 2021 at 2:28 PM Jia He <justin.he@arm.com> wrote:
>
> Liajian reported a bug_on hit on a ThunderX2 arm64 server with FastLinQ
> QL41000 ethernet controller:
>  BUG: scheduling while atomic: kworker/0:4/531/0x00000200
>   [qed_probe:488()]hw prepare failed
>   kernel BUG at mm/vmalloc.c:2355!
>   Internal error: Oops - BUG: 0 [#1] SMP
>   CPU: 0 PID: 531 Comm: kworker/0:4 Tainted: G W 5.4.0-77-generic #86-Ubuntu
>   pstate: 00400009 (nzcv daif +PAN -UAO)
>  Call trace:
>   vunmap+0x4c/0x50
>   iounmap+0x48/0x58
>   qed_free_pci+0x60/0x80 [qed]
>   qed_probe+0x35c/0x688 [qed]
>   __qede_probe+0x88/0x5c8 [qede]
>   qede_probe+0x60/0xe0 [qede]
>   local_pci_probe+0x48/0xa0
>   work_for_cpu_fn+0x24/0x38
>   process_one_work+0x1d0/0x468
>   worker_thread+0x238/0x4e0
>   kthread+0xf0/0x118
>   ret_from_fork+0x10/0x18
>
> In this case, qed_hw_prepare() returns error due to hw/fw error, but in
> theory work queue should be in process context instead of interrupt.
>
> The root cause might be the unpaired spin_{un}lock_bh() in
> _qed_mcp_cmd_and_union(), which causes botton half is disabled incorrectly.
>
> Reported-by: Lijian Zhang <Lijian.Zhang@arm.com>
> Signed-off-by: Jia He <justin.he@arm.com>
> ---

This patch is adding additional spin_{un}lock_bh().
Can you please enlighten about the exact flow causing this unpaired
spin_{un}lock_bh.

Also,
as per description, looks like you are not sure actual the root-cause.
does this patch really solved the problem?

--pk
