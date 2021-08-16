Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D758B3ED0D4
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 11:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhHPJG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 05:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbhHPJG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 05:06:26 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6690FC06179A;
        Mon, 16 Aug 2021 02:05:55 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id o123so12976302qkf.12;
        Mon, 16 Aug 2021 02:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i+Rjw8G7sWGeEjQRHiEVKqpPDTMTHAenZZ7LzHx1zLM=;
        b=n0dydki+IRi5XXhKFKJnIzGKsxUXd1pnSChDV5Ad9Dj3JSxHOER8NkbN54MY8RT1ES
         /3+2Jgaq2azvcTyqRLKeoz6g5Uqw0zcHhf2x89Tl1Xj/h4dZz3CJjs0BkSSoPcc1F7u0
         KhEtKV1rSy3XI/979h/5ON32sh4XDTO6XaRm76op4qduF+ZN5uvuuLVBhBCZvlXKP1SU
         ZY0HHHALvohSZL1pFT78ICbMsUU5sz9OZpFIksV99s/sB63+WdVnqA6h2dHDXTNEbMm8
         qSbr1JlkX2k0lhmXXtdhht4QjbZHNNl9dhcPTn3XAmHRJmSfUCL7SgXYsu/P2fGePvV0
         FaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i+Rjw8G7sWGeEjQRHiEVKqpPDTMTHAenZZ7LzHx1zLM=;
        b=dfqoVQxjqjLpl51wx0wxf38JG6o0HPEgPKlQpjSQzGMV3a+14eb4bkJORz80chA/O1
         hgSjGppOQto9NGjJmRAod+W9O0DBL4pIWWQfl0CkFnyY+kSALriu9wy73VrdFd3LCvZo
         cCSqUWqprZIAZ93xfou4N37EfGp7OKEJGghkV+qWMt5U5Hz3R9I/EU2y1bcyeopwScyu
         VjMlwebXJHGVoJx4/cotFn4jCsSBAr9mAmNYyMVVcYE9G/S1dzS0QUdlQIAosllWIMAv
         PbfYXxJ8IakM3klS3sWjBaKQM14vn9KKyuyJmqHCcYLaNif14oFMkHjfn2XzJrprH5/J
         r+1g==
X-Gm-Message-State: AOAM532gsKUtmjX/QqfrtdA/QBmKpUj7ZpysRJozV5dgWRPN++tXw4dg
        ZSSWvCKPIIMmNEympIvGnlyipfoA1rmc4FjUPw==
X-Google-Smtp-Source: ABdhPJyewk7jCu6kepnfWE6YURcK1hq/Iy5LxNLdfcjGw44kvuafp3qcRX5m0qUmElGr41pK5qh8JojsCYycptHjHcs=
X-Received: by 2002:a37:a58b:: with SMTP id o133mr15084238qke.120.1629104754546;
 Mon, 16 Aug 2021 02:05:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210731055738.16820-1-joamaki@gmail.com>
 <20210731055738.16820-2-joamaki@gmail.com> <2bb53e7c-0a2f-5895-3d8b-aa43fd03ff52@redhat.com>
 <CAHn8xckOsLD463JW2rc1LhjjY0FQ-aRNqSif_SJ6GT9bAH7VqQ@mail.gmail.com> <3b0657f0-d7ef-e568-57c2-0db41acea615@redhat.com>
In-Reply-To: <3b0657f0-d7ef-e568-57c2-0db41acea615@redhat.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Mon, 16 Aug 2021 11:05:43 +0200
Message-ID: <CAHn8xcmU8r3-hzm15x5Bu+MaOc7iY82WZh9_6C5SqHx5OKhWrA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/7] net: bonding: Refactor bond_xmit_hash for
 use with xdp_buff
To:     Jonathan Toppins <jtoppins@redhat.com>, jiri@nvidia.com
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 4:05 PM Jonathan Toppins <jtoppins@redhat.com> wrote:
>
> On 8/11/21 4:22 AM, Jussi Maki wrote:
> > Hi Jonathan,
> >
> > Thanks for catching this. You're right, this will NULL deref if XDP
> > bonding is used with the VLAN_SRCMAC xmit policy. I think what
> > happened was that a very early version restricted the xmit policies
> > that were applicable, but it got dropped when this was refactored.
> > I'll look into this today and will add in support (or refuse) the
> > VLAN_SRCMAC xmit policy and extend the tests to cover this.
>
> In support of some customer requests and to stop adding more and more
> hashing policies I was looking at adding a custom policy that exposes a
> bitfield so userspace can select which header items should be included
> in the hash. I was looking at a flow dissector implementation to parse
> the packet and then generate the hash from the flow data pulled. It
> looks like the outer hashing functions as they exist now,
> bond_xmit_hash() and bond_xmit_hash_xdp(), could make the correctly
> formatted call to __skb_flow_dissect(). We would then pass around the
> resultant struct flow_keys, or bonding specific one to add MAC header
> parsing support, and it appears we could avoid making the actual hashing
> functions know if they need to hash an sk_buff vs xdp_buff. What do you
> think?

That sounds great! I wasn't particularly happy about how it works with
skb being optional as that was just waiting to break (as it did). The
team driver does the hashing using a user-space provided bpf program
and I'm looking to figure out how to support XDP with it. I wonder if
we could have a single approach that would work for both bonding and
team (e.g. use bpf to hash). CC'ing Jiri as he wrote the team driver.
