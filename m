Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3FE306B1F
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhA1CfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhA1CfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 21:35:08 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20240C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 18:34:28 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d13so2507046plg.0
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 18:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f8rmeitNeQ0cbGXYm/6i5FyhFM9eJPg4FgfDcYHHhgI=;
        b=vMpx1MHFs7Nt0jPQlXkaymOEiaqNTKjdbcxGCw7es2AYysJJc/l95IxsottlqZOGug
         WgaBz/gJDKJvLFzXE6FsZqwqhklzQOTs+xpiaJXgOUeX/07wjx+Yag5AlR60UzWhCRN1
         Hx9aR6hBC9qxwVwWQ9sCffu/aIO3YiKkUZvx3LcdBiUItSqyWPc6PP0N5XJBYwGtaXWB
         d6fzB1w5YsITGVvYNlfgLpZT9tVmtxugNeIWikdRmuCqArhnBzh0jwl9CPA41dDLX2Aj
         Fk8qipHVges6DtJndzCP3s/c99HXbV3lXCYhRnl1uKrWN1bfI1IL6+4TJfldz3CY+dZD
         6D0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f8rmeitNeQ0cbGXYm/6i5FyhFM9eJPg4FgfDcYHHhgI=;
        b=p0NPsmuKEN1fvpFLNVl7vEmp2HUrfXqZMu5EqHO39udIyK3sjxBrEGdYgxx3bjPKXx
         NCZnE9P+9l7WecqEG51AFzUKO8/qFcI9clzBtu7bM0ZHs79XSvSRjiMExHO1xDckIPIj
         U/HVJCHuUxN/14+y+TKIobZzPymN/RuhUL0s9emKIBLbPxyIL491LtdEgfAy7BOrdHgP
         4MwDyPNWQeMw6cJBDQYP1ivaOASlueckcSXFdkOe7yxdlBUjQv0h/TExtfobnTjUddOv
         rTAv3QzlMrlxUFgbShctaefTOSPj/ccbgxVhU6zZkElHB0rhtjl7bYcjdUTAYwLa0XOW
         mV1A==
X-Gm-Message-State: AOAM531bmSp5k6Nk14za9dretLeCR3EK1kxs9S+n2MtG/NWdqi6SAvPn
        oCW2XznhES4y1OlVIs1ymN17M6DOPhEzGoex7C+Y2lFL1j3v2A==
X-Google-Smtp-Source: ABdhPJzudMCJjMc/psJUfz4tx1NVKKWIOheUXH5KnfqK9SosWJqvB58j+542qeVaf3bfFw/Vif/99scy4digpDHx+ww=
X-Received: by 2002:a17:902:d64e:b029:df:e5b1:b7f7 with SMTP id
 y14-20020a170902d64eb02900dfe5b1b7f7mr13900794plh.10.1611801267513; Wed, 27
 Jan 2021 18:34:27 -0800 (PST)
MIME-Version: 1.0
References: <20210127165453.GA20514@chinagar-linux.qualcomm.com>
In-Reply-To: <20210127165453.GA20514@chinagar-linux.qualcomm.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 27 Jan 2021 18:34:16 -0800
Message-ID: <CAM_iQpVvuHXiwdNn9NqU1M6UWGKTkQWqDQpPp7zuEA7zcGk-qw@mail.gmail.com>
Subject: Re: [PATCH] neighbour: Prevent a dead entry from updating gc_list
To:     Chinmay Agarwal <chinagar@codeaurora.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, sharathv@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 8:55 AM Chinmay Agarwal <chinagar@codeaurora.org> wrote:
>
> Following race condition was detected:
> <CPU A, t0> - neigh_flush_dev() is under execution and calls
> neigh_mark_dead(n) marking the neighbour entry 'n' as dead.
>
> <CPU B, t1> - Executing: __netif_receive_skb() ->
> __netif_receive_skb_core() -> arp_rcv() -> arp_process().arp_process()
> calls __neigh_lookup() which takes a reference on neighbour entry 'n'.
>
> <CPU A, t2> - Moves further along neigh_flush_dev() and calls
> neigh_cleanup_and_release(n), but since reference count increased in t2,
> 'n' couldn't be destroyed.
>
> <CPU B, t3> - Moves further along, arp_process() and calls
> neigh_update()-> __neigh_update() -> neigh_update_gc_list(), which adds
> the neighbour entry back in gc_list(neigh_mark_dead(), removed it
> earlier in t0 from gc_list)
>
> <CPU B, t4> - arp_process() finally calls neigh_release(n), destroying
> the neighbour entry.
>
> This leads to 'n' still being part of gc_list, but the actual
> neighbour structure has been freed.
>
> The situation can be prevented from happening if we disallow a dead
> entry to have any possibility of updating gc_list. This is what the
> patch intends to achieve.
>
> Fixes: 9c29a2f55ec0 ("neighbor: Fix locking order for gc_list changes")
> Signed-off-by: Chinmay Agarwal <chinagar@codeaurora.org>

Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
