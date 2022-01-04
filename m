Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AAB4844FA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiADPoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbiADPoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:44:14 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79DAC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 07:44:13 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id w184so89400940ybg.5
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 07:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LsM+pfLA+oVKFnLbOpczApkRyOb/KtnNkOitW2wm+b0=;
        b=NCO+PmCIMMg1qg/HXfgZY+i0yUZSNv5z4wWs1xWqsE5m4Ensise37On14OpGnqixq7
         KwsTQAQv7oNKH7NE5udXQv1Xli2cipoZbzMeW5wJoQuaQZ3Z/N/bz+EblI3dMQV/iWzk
         YNgwb/bWKxQHeRnZneDkEOQIctgVbUBBwMw6dX3/lAy1JSL3G1WQiQhbxN6n5E5m1S78
         Fnh/vXfVwOlzaFuKIDPjDCe/I92t3iRoyV1O0KOsKYHuOU0gw8hu1l5S7YcF4yxTGjEa
         CThiEqSCJ2wihy7jt7VANszcOKnz2eC5Y/4VcyETWj5meZcKeYhnRUa6ASrnGirOvAUg
         CNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LsM+pfLA+oVKFnLbOpczApkRyOb/KtnNkOitW2wm+b0=;
        b=XAq4urkp9O//EQYOxX7mfGeLv9scgzQ9PFm59ic7qpngegTXn/VEH628ju5XpENJEA
         DJ1o6DfSfEiIAw0ABTEDSi1NcIKyFyNArfAb+nRDio3Q/93gyPQw2AMTj2XZ1ubWFZ36
         /V5UeQRhD63xihNeayieLtbqlYslqC1ZvhdIqSiiV4oBMuXtZ7FGaYtE33eMFhSfUAeZ
         MOlM0qZwZMwjVZMM+RtAqbJUPi6gwXFMxUZrGsr5Ty4Y9KjukHkCLUfJTgqlNIhrhr5J
         vD06FGXsLoESx1SQoFZvPuv73sKTgAviEVLvVqNOgbvVIRRNHNIHFmVh7EvW+K9MJ1lw
         UTCA==
X-Gm-Message-State: AOAM533DE++EkRk0/n8OjXqZuuVWilNcg8dx8wVi4vRbRqZ4hoBtmuCs
        AfExCMhEuELy1rKzpDMh7wIi7UDHgZCnILsQ0V5gFg==
X-Google-Smtp-Source: ABdhPJyUlMUMU4V6LjLH9sYO6VNkunoEyPye2usADd0IojjZ006tVAXVNamih/byE8GJhFdX2XicWfyYR8EIGuAslyM=
X-Received: by 2002:a25:d195:: with SMTP id i143mr50050713ybg.711.1641311052446;
 Tue, 04 Jan 2022 07:44:12 -0800 (PST)
MIME-Version: 1.0
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
 <20211207013039.1868645-12-eric.dumazet@gmail.com> <5836510f3ea87678e1a3bf6d9ff09c0e70942d13.camel@sipsolutions.net>
In-Reply-To: <5836510f3ea87678e1a3bf6d9ff09c0e70942d13.camel@sipsolutions.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Jan 2022 07:44:01 -0800
Message-ID: <CANn89i+yzt=Y_fgjYJb3VMYCn7aodFVRbZ9hUjb0e4+T+d14ww@mail.gmail.com>
Subject: Re: [PATCH net-next 11/13] netlink: add net device refcount tracker
 to struct ethnl_req_info
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 7:29 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Mon, 2021-12-06 at 17:30 -0800, Eric Dumazet wrote:
> >
> > @@ -624,6 +625,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
> >       }
> >
> >       req_info->dev = dev;
> > +     netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
> >       req_info->flags |= ETHTOOL_FLAG_COMPACT_BITSETS;
> >
>
> I may have missed a follow-up patch (did a search on netdev now, but
> ...), but I'm hitting warnings from this and I'm not sure it's right?
>
> This req_info is just allocated briefly and freed again, and I'm not
> even sure there's a dev_get/dev_put involved here, I didn't see any?

We had a fix.

commit 34ac17ecbf575eb079094d44f1bd30c66897aa21
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue Dec 14 00:42:30 2021 -0800

    ethtool: use ethnl_parse_header_dev_put()


>
> At least it would seem we need to free the tracker at the end of this
> function, or perhaps never even create one?
>
> johannes
