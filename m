Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED053338A1
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhCJJW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhCJJWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 04:22:46 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4E2C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 01:22:46 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id k9so32252724lfo.12
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 01:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WpZ+pkoDgZkjwssVaGIfHtpG80mv7ecIlWX/mJKDp9E=;
        b=Dx5wVzf+PTZw4A54jcWtPGPN1I+GRu3qRjRozpppgh3p77erkhdW7ULPuakUGWxvGl
         fJEDjlXMwfcUA/LG0FVJIaWrq3v4Rh/kHqCSMRYtann19Pjozqfz4hiOYEi22LER274I
         j3ey2oHtkBxTqfPTQD7N+Uw3g24Jv5jAoouq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WpZ+pkoDgZkjwssVaGIfHtpG80mv7ecIlWX/mJKDp9E=;
        b=boq1HR7wz31ktqQsanYbC4iUj8bWWmfEtVUhR90ujgLN22THNxxZGWainnxWi5rX/5
         p9tOMLtu7Dm7PFkfeqh1IrpbVb858AFOKkHLW25GSXTNaJa7eAdclkHy6zox2zeFWvkL
         w8d2VQNLS1FiqSF0MBgErOHyjdyuDSTF4+4XJrvqnWoIhjPqeex9iChVcR7uCBEy9l7K
         VnPZF+SrxDBRmquR2NbqFCTDdhFgHnul93h1HVMKDXgdzNoE/nMIkMgas8koKukyesbJ
         Ipvn114Sutg8IClu3iE9Ai5vXySMto2CB55ZaMA23xZu1wXFhwyRnf5/Z5e8/ydL0BXA
         tb4A==
X-Gm-Message-State: AOAM5314Q6Uf4RuMO9zNHFDp8zZs8EXr6t83Czww0Ax3G4XGcL8re/MH
        4geFHp7c8x5S5PUxyDP4pc+3Wjy/gMadBFeGinzR/g==
X-Google-Smtp-Source: ABdhPJwF4szkL55sAOtiaq5Pvt6aCXZl1ThSle1JWyDBgh3FOmB6lTRjepbw38wmzLsif/kHuRq2U7O0rX5gWyto1TQ=
X-Received: by 2002:a05:6512:12c3:: with SMTP id p3mr1429035lfg.97.1615368164840;
 Wed, 10 Mar 2021 01:22:44 -0800 (PST)
MIME-Version: 1.0
References: <20210309044349.6605-1-tonylu@linux.alibaba.com> <203c49a3-6dd8-105e-e12a-0e15da0d4df7@gmail.com>
In-Reply-To: <203c49a3-6dd8-105e-e12a-0e15da0d4df7@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 10 Mar 2021 09:22:34 +0000
Message-ID: <CACAyw9-tacJC-5Cimars4Ncu0PzZ6gg-qfj7g_yz_UgX5h6H-Q@mail.gmail.com>
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>, rostedt@goodmis.org,
        mingo@redhat.com, Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Mar 2021 at 20:12, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> On 3/9/21 5:43 AM, Tony Lu wrote:
> > There are lots of net namespaces on the host runs containers like k8s.
> > It is very common to see the same interface names among different net
> > namespaces, such as eth0. It is not possible to distinguish them without
> > net namespace inode.
> >
> > This adds net namespace inode for all net_dev events, help us
> > distinguish between different net devices.
> >
> > Output:
> >   <idle>-0       [006] ..s.   133.306989: net_dev_xmit: net_inum=4026531992 dev=eth0 skbaddr=0000000011a87c68 len=54 rc=0
> >
> > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> > ---
> >
>
> There was a proposal from Lorenz to use netns cookies (SO_NETNS_COOKIE) instead.
>
> They have a guarantee of being not reused.
>
> After 3d368ab87cf6681f9 ("net: initialize net->net_cookie at netns setup")
> net->net_cookie is directly available.

The patch set is at
https://lore.kernel.org/bpf/20210219154330.93615-1-lmb@cloudflare.com/
but I decided to abandon it. I can work around my issue by comparing
the netns inode of two processes, which is "good enough" for now.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
