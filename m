Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8AF2DECA7
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 02:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgLSBmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 20:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgLSBmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 20:42:01 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8D4C0617B0
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 17:41:21 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id n4so3782725iow.12
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 17:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IAXWrRjwd5HWLzlR/BgYJ/EPLGhMzaW+RO7KCdBiBLY=;
        b=i0YXJ/Jz3W4TMYso3t6Pu+f8Lm7Evw23phEFXTP0Ln138x1L7/o/DtCiXNcD3hhY9y
         wkej59xcr9tTfq2uR+pq/vtoAVGcNnLgQjr/6uxO5VAzG1IudTiiLY4wuB5Sy3Un2PXU
         1MufQiNN383joJNL54CSBbcbutrG5jfyzfFOEbwarJHIel0JsHHjn9m3ZbLzZvCd5zfc
         5TnwlTJYbFkxF/bUyVZ2WNSnibi3Qbnl2oxCvlaqwqBtYQ+vzcvly2WSF5ZutdKaV7sC
         PHZUQYMwHnJKEKOH06Jqo2eti8Z5tAO1V+p7tNkakKRH/VO+DJTtGjhaQIUmHPS9JoD7
         O4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IAXWrRjwd5HWLzlR/BgYJ/EPLGhMzaW+RO7KCdBiBLY=;
        b=fbbAV97wMiJPND0bpKPZILHA8lOLLVj82wlwOjOLSQVAVYcqBVJvnRbgm0WjGqtAZY
         VkPscSvX1F/56SLIAEwOkSZTSsDAcUNQKBcS3s65o7ZpknvKh35yihhOW+B3+2PCBanE
         TIHYA8vdJbWHevhqxuEVQ+sZBv1j0IPG3kwdYoOepboZnilGgJNcTARdQeAXbT8rPjPv
         p03gvm/uDl08r22BSgM4oNP9C3xQBL681L6MblSLXQ3S+dYQhLuY9+HP8cVHCQnn9eAo
         qeZyvqBo4S5soE3lPDdhW6F3ZfXUppvb8xUcFglJMFWNzX9fIxp194kzegrkkPytc2ni
         8pbA==
X-Gm-Message-State: AOAM531XnCoWvW/A1EDATRhpoCkxraYPqz9vvVAQ688LSneqLPD6hDe/
        YOYVbIsRLdc/gjwl9XN5FOVcc691xBKNVfUVH70=
X-Google-Smtp-Source: ABdhPJzWQm4IJkpYi0xghARA3AL5/kEHhV6bc19CxGjFWXql8ETny2X2f2tsNaHYrwPco6chSDdEB4Gp+ZN842htVY8=
X-Received: by 2002:a02:969a:: with SMTP id w26mr6379177jai.96.1608342079530;
 Fri, 18 Dec 2020 17:41:19 -0800 (PST)
MIME-Version: 1.0
References: <20201217162521.1134496-1-atenart@kernel.org> <20201217162521.1134496-2-atenart@kernel.org>
 <20201218163041.78f36cc2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201218163041.78f36cc2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 18 Dec 2020 17:41:08 -0800
Message-ID: <CAKgT0UeSSwU+pdujyTKNiQXuO4+UAyRxeCr9tB4dwO2n9a-KyA@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net-sysfs: take the rtnl lock when storing xps_cpus
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Antoine Tenart <atenart@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 4:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 17 Dec 2020 17:25:18 +0100 Antoine Tenart wrote:
> > Callers to netif_set_xps_queue should take the rtnl lock. Failing to do
> > so can lead to race conditions between netdev_set_num_tc and
> > netif_set_xps_queue, triggering various oops:
> >
> > - netif_set_xps_queue uses dev->tc_num as one of the parameters to
> >   compute the size of new_dev_maps when allocating it. dev->tc_num is
> >   also used to access the map, and the compiler may generate code to
> >   retrieve this field multiple times in the function.
> >
> > - netdev_set_num_tc sets dev->tc_num.
> >
> > If new_dev_maps is allocated using dev->tc_num and then dev->tc_num is
> > set to a higher value through netdev_set_num_tc, later accesses to
> > new_dev_maps in netif_set_xps_queue could lead to accessing memory
> > outside of new_dev_maps; triggering an oops.
> >
> > One way of triggering this is to set an iface up (for which the driver
> > uses netdev_set_num_tc in the open path, such as bnx2x) and writing to
> > xps_cpus in a concurrent thread. With the right timing an oops is
> > triggered.
> >
> > Fixes: 184c449f91fe ("net: Add support for XPS with QoS via traffic classes")
>
> Let's CC Alex
>
> > Signed-off-by: Antoine Tenart <atenart@kernel.org>
>
> Two things: (a) is the datapath not exposed to a similar problem?
> __get_xps_queue_idx() uses dev->tc_num in a very similar fashion.

I think we are shielded from this by the fact that if you change the
number of tc the Tx path has to be torn down and rebuilt since you are
normally changing the qdisc configuration anyway.

> Should we perhaps make the "num_tcs" part of the XPS maps which is
> under RCU protection rather than accessing the netdev copy?

So it looks like the issue is the fact that we really need to
synchronize netdev_reset_tc, netdev_set_tc_queue, and
netdev_set_num_tc with __netif_set_xps_queue.

> (b) if we always take rtnl_lock, why have xps_map_mutex? Can we
> rearrange things so that xps_map_mutex is sufficient?

It seems like the quick and dirty way would be to look at updating the
3 functions I called out so that they were holding the xps_map_mutex
while they were updating things, and for __netif_set_xps_queue to
expand out the mutex to include the code starting at "if (dev->num_tc)
{".
