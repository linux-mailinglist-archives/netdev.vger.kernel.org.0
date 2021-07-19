Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2A63CD72E
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 16:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbhGSOLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 10:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241406AbhGSOLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 10:11:00 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF96C061574;
        Mon, 19 Jul 2021 07:19:45 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id f17so22403476wrt.6;
        Mon, 19 Jul 2021 07:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2TMqggDy1d4GjwkeBWFENMCiF9IVcT7UERyMIqhwYKo=;
        b=cePslZ91T589YXi+3HkXUOwh7qnmfP0xhw4Qm8qke5RPoUaOTCXMBbnt5FwRU+446L
         g1LcU7pZVTxoYFwIBxr1awlaMkj7dGrYj2KAEQaKVPaGuEpo8n+cE4glttLHzbyfBpEr
         bKmSTOc8mNjgqtXOj3NHPxRf/tdPK3EaZernnrC0PNKrqkmrG0R9aCzuvbtChw1Ws0/c
         BmICbm/pkEemp7ThE+EXCfvvMN+fzqAZ1AAznQF6ZMLGYzbQIU+Tx+vMJG+Ior1sGkGb
         fKRQK3OyUDgijP6LmQVPc0nxJ63hYLdRshhkLZcpY415xApz2M+tXXe28pDTjMYcF3vy
         cbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2TMqggDy1d4GjwkeBWFENMCiF9IVcT7UERyMIqhwYKo=;
        b=dn7ln2jmwM4DINGKp6fUCrGDPYiwe9JDPmmjpLhX381B4mMlvb8MhBViGDjQPYy4NA
         cq8qY1AJQu9Vl6Ua2qOaRsxcU4zdTvoK7rfm8Uk9FkLGzGqn7y4fze3Kmw86xpZxA0kj
         3hfHQno9duXNCKVhNWue9E27FKtCn/CPFLGkQQ15VehXXFLlRSP+F5do2uagT+g5mPjG
         vnEhTjDqZPhJtuiCpKCmnzdGKEzOso8MVm93iYLuZSrqKNCkmunL0QSvt4aESw3fyDSc
         hhI2rRKOxNrgQqQe2uGK/VIlczFqsluurrLVsHZ029qF8/8KC7bjxAb39g7FPdq1DwSt
         r3NQ==
X-Gm-Message-State: AOAM531HXFBXn0tMblnU1zFm3SVSMM7Ah7JyUp5G1KQnvu6GPdXmuuky
        GfjbSzOwLjZLlEncXdvGxYLDsXeDD5lTP0nkymg=
X-Google-Smtp-Source: ABdhPJwNz0auJQIu/oQY1Paggbn4qOK+Whd3rECDa6KNwvbLE3jYddobF9KeV80+E0G/5YgUvnGlUM5EYJUHDVnCYfE=
X-Received: by 2002:adf:ed46:: with SMTP id u6mr30387204wro.252.1626706291240;
 Mon, 19 Jul 2021 07:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210715080822.14575-1-justin.he@arm.com> <CAJ2QiJLWgxw0X8rkMhKgAGgiFS5xhrhMF5Dct_J791Kt-ys7QQ@mail.gmail.com>
 <AM6PR08MB4376894A46B47B024F50FBB3F7E19@AM6PR08MB4376.eurprd08.prod.outlook.com>
In-Reply-To: <AM6PR08MB4376894A46B47B024F50FBB3F7E19@AM6PR08MB4376.eurprd08.prod.outlook.com>
From:   Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
Date:   Mon, 19 Jul 2021 20:20:54 +0530
Message-ID: <CAJ2QiJJ8=jkbRVscnXM2m_n2RX2pNdJG4iA3tYiNGDYefb-hjA@mail.gmail.com>
Subject: Re: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()
To:     Justin He <Justin.He@arm.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nd <nd@arm.com>, Shai Malin <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Justin,

On Mon, Jul 19, 2021 at 6:47 PM Justin He <Justin.He@arm.com> wrote:
>
> Hi Prabhakar
>
> > -----Original Message-----
> > From: Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
> > Sent: Monday, July 19, 2021 6:36 PM
> > To: Justin He <Justin.He@arm.com>
> > Cc: Ariel Elior <aelior@marvell.com>; GR-everest-linux-l2@marvell.com;
> > David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> > netdev@vger.kernel.org; Linux Kernel Mailing List <linux-
> > kernel@vger.kernel.org>; nd <nd@arm.com>; Shai Malin <malin1024@gmail.com>;
> > Shai Malin <smalin@marvell.com>; Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Subject: Re: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in
> > _qed_mcp_cmd_and_union()
> >
> > Hi Jia,
> >
> > On Thu, Jul 15, 2021 at 2:28 PM Jia He <justin.he@arm.com> wrote:
> > >
> > > Liajian reported a bug_on hit on a ThunderX2 arm64 server with FastLinQ
> > > QL41000 ethernet controller:
> > >  BUG: scheduling while atomic: kworker/0:4/531/0x00000200
> > >   [qed_probe:488()]hw prepare failed
> > >   kernel BUG at mm/vmalloc.c:2355!
> > >   Internal error: Oops - BUG: 0 [#1] SMP
> > >   CPU: 0 PID: 531 Comm: kworker/0:4 Tainted: G W 5.4.0-77-generic #86-
> > Ubuntu
> > >   pstate: 00400009 (nzcv daif +PAN -UAO)
> > >  Call trace:
> > >   vunmap+0x4c/0x50
> > >   iounmap+0x48/0x58
> > >   qed_free_pci+0x60/0x80 [qed]
> > >   qed_probe+0x35c/0x688 [qed]
> > >   __qede_probe+0x88/0x5c8 [qede]
> > >   qede_probe+0x60/0xe0 [qede]
> > >   local_pci_probe+0x48/0xa0
> > >   work_for_cpu_fn+0x24/0x38
> > >   process_one_work+0x1d0/0x468
> > >   worker_thread+0x238/0x4e0
> > >   kthread+0xf0/0x118
> > >   ret_from_fork+0x10/0x18
> > >
> > > In this case, qed_hw_prepare() returns error due to hw/fw error, but in
> > > theory work queue should be in process context instead of interrupt.
> > >
> > > The root cause might be the unpaired spin_{un}lock_bh() in
> > > _qed_mcp_cmd_and_union(), which causes botton half is disabled
> > incorrectly.
> > >
> > > Reported-by: Lijian Zhang <Lijian.Zhang@arm.com>
> > > Signed-off-by: Jia He <justin.he@arm.com>
> > > ---
> >
> > This patch is adding additional spin_{un}lock_bh().
> > Can you please enlighten about the exact flow causing this unpaired
> > spin_{un}lock_bh.
> >
> For instance:
> _qed_mcp_cmd_and_union()
>   In while loop
>     spin_lock_bh()
>     qed_mcp_has_pending_cmd() (assume false), will break the loop

I agree till here.

>   if (cnt >= max_retries) {
> ...
>     return -EAGAIN; <-- here returns -EAGAIN without invoking bh unlock
>   }
>

Because of break, cnt has not been increased.
   - cnt is still less than max_retries.
  - if (cnt >= max_retries) will not be *true*, leading to spin_unlock_bh().
Hence pairing completed.

I am not seeing any issue here.

> > Also,
> > as per description, looks like you are not sure actual the root-cause.
> > does this patch really solved the problem?
>
> I don't have that ThunderX2 to verify the patch.
> But I searched all the spin_lock/unlock_bh and spin_lock_irqsave/irqrestore
> under driver/.../qlogic, this is the only problematic point I could figure
> out. And this might be possible code path of qed_probe().
>

Without testing and proper root-cause,  it is tough to accept the suggested fix.

--pk
