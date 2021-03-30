Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7190734EC88
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbhC3Pcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbhC3PcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:32:23 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13F8C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:32:22 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g38so17806060ybi.12
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gFGHPRq5WIszYADyPLK/k2ezLagDSbDZ7MvpYZXDKbM=;
        b=o7QVOLiUj68J7KxLS8uRw09cZVEqjTytixGMpPwjIpUBIaxu9su7kK8f9++ICjqosm
         s/1LyfVBJjuwBhXbl85PyRgsruYd5YL2MjDVVgC6ww+MawKwGnDaFWKgvNwzkjtwEAQp
         bWicDfc/Leejqd2AFrJeDwDrrdP/NrK5+lQ/gT1cxuS8KAqYHM/k1yk1x7+6/nHvpwIM
         2wbWMMk7f7sznFSh5X361xmX7R+nWAMH+T8rQvTdjMMFjEy1EgNb9VwNXzpU5bMuvOqC
         i2aNGXO00mg8UnmNPSCL4VkEY3djQV1AsAQx9BORlCXqq+FEbuzvx52R4X7Y0tOZfzDp
         ywQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gFGHPRq5WIszYADyPLK/k2ezLagDSbDZ7MvpYZXDKbM=;
        b=ATjieoYcWGcXRRAAJ5PAUhbAFM7k1qQk0n6o++rJDpvqpvQfBxPcH9MLpuw6uEps4w
         XnIRUt/qSz7j/8jpLZduK3+iIgGeVxxWfnwLwFJ9XXJofH+ZDbHIrlX22ggnrX23XROX
         us6wEsqXh3dzit5agqfKFaX+C6V5K+D7arZEKZAO6UmKPEUqLnQWyCS0qsgfUw1UWBfS
         ca2yYadryi5smQR6Tj5q0oSrO4J2AHDnOIW94hL3BYW9OnXk1cd/Z5myd6l4O9Y2nLHB
         RWH4gqKMLNGFfsy8FJ5M0dH4Nqf6W/2Bd5nr9T9EBEbO+8K353xv4tyY0VqupYp/Ey3u
         D55A==
X-Gm-Message-State: AOAM530gvRTHyOG0RfnFoIcu8gDG628VIARgrdVGQoDT2chexrGDnITW
        iwyuAIYacC/2YxtKfq6GCjtvegqY7nbd6gT/w8+oVA==
X-Google-Smtp-Source: ABdhPJyjt6FfD2X0zZot3Lxgm+eTCQSXqMR//Kc5PFuVAwqEt+QZZFbD5qsIeEH1BJorZUIxnSts2aWDWAEfELHlims=
X-Received: by 2002:a25:3614:: with SMTP id d20mr29494853yba.452.1617118341069;
 Tue, 30 Mar 2021 08:32:21 -0700 (PDT)
MIME-Version: 1.0
References: <880d627b79b24c0f92a47203193ed11f48c3031e.1617113947.git.pabeni@redhat.com>
 <CANn89iJQRf5GVhiUp3PA5y9p3_Nqrm8J2CcfxA=0yd9_aB=17w@mail.gmail.com>
 <CANn89iJkXuhMdU0==ZV3s8z75p1hrhjY3reR_MWUh1i-gJVeCg@mail.gmail.com> <99736955c48b19366a2a06f43ea4a0d507454dbc.camel@redhat.com>
In-Reply-To: <99736955c48b19366a2a06f43ea4a0d507454dbc.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Mar 2021 17:32:09 +0200
Message-ID: <CANn89iLE-zxdieT2UePGyFYm+w9pdgd-AtmJ7HchFJnzmg0gWQ@mail.gmail.com>
Subject: Re: [PATCH net] net: let skb_orphan_partial wake-up waiters.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 5:18 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2021-03-30 at 16:40 +0200, Eric Dumazet wrote:

> > >
> > > Why TCP is not a problem here ?
>
> AFAICS, tcp_wfree() does not call sk->sk_write_space(). Processes
> waiting for wmem are woken by ack processing.

My concern was TCP Small Queue. If we do not call tcp_wfree() we might miss
an opportunity to queue more packets (and thus fallback to RTO or
incoming ACK is we are lucky)
