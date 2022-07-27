Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D57583427
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 22:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbiG0UjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 16:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiG0UjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 16:39:22 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F6E5C97D
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 13:39:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w205so129646pfc.8
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 13:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AqDJFMVyy+ZPy4OKfJDKdS0bxDg1ZZcxkSxs6/xipuE=;
        b=eR9B63r9PTWSRQRF4HENp+yCDJjP2BGnz+MyZ/kgON/3k+qX2doDACf3cO1hikDbM5
         9p8fCSdVeWWJ4XaNzkcZl8za3dxYTcUzrdnEoxikqeA12Ia+duEBwWO0hQmnOYIh4fec
         g0i/7nfYPxhXmP/RgrvkZAlVO42et6bbMpTNY8+7miwWjiUA8+TZCVsnRD9S7rCAP4Bb
         r5FlFYWZMFCgN5UJ55E5GB1ITrs/IQ7ZWVVITFaBGRRFKwdx0UClC8FPoq57F5WDwYXU
         AYN5FUedyz3JaR3oxRw2CoyjOhJ1iBC8w/nVfJwnMiNWOYkrvf2FCcFpfnRVr6ajE7Id
         B4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AqDJFMVyy+ZPy4OKfJDKdS0bxDg1ZZcxkSxs6/xipuE=;
        b=fl5yOVbb8FHW0qHa9YH+kFYwJ44OH7FH6tt6HNJuYZ/jowU210ANZlXm4gDt7Zdq2R
         8Q8QMre/ZGdSNlHKNPs8paAelffKVuxvKXl8pY+m2h/BNRIetyZH6scqC7+Xd6D8dFVV
         5W3XNdIju+cMVemC1uLuRkvYdQgMWp0PA2ASdKGdFjF5Wq6Jyxm5jsopF/vs8oJltE+f
         H7En5JtzWRt+VQsBxCr0Qq/H/zL6waYhe8V3sVBne+7cwiaFrpQ/5TdmIUMmm/HvFtPe
         gZmZGBXgJtmSo5r6g/JNWqBD/pzxPVZw19087w0zmilVrZIRUCiNU4Dosjso0d6/oN8a
         13Cg==
X-Gm-Message-State: AJIora/kgYiwPe6HmLylxv1j6xYUyF6DinKWNSL6qp/UTZKf+pWB/tZP
        PurI7pew4FQ2N3CfPDWAozJ1LBOsf/QzO3BPUcpLFuCqQ1gBpg==
X-Google-Smtp-Source: AGRyM1u+B2OnfrqZ49Q8hgnhE5RUUMQb4XCxVLk91YgtsKVCjcPudRH6gqvN1joBMHtNi3Gu0IzXbrXrEyMIMurgWIE=
X-Received: by 2002:a65:4c0b:0:b0:415:d3a4:44d1 with SMTP id
 u11-20020a654c0b000000b00415d3a444d1mr20575176pgq.191.1658954359746; Wed, 27
 Jul 2022 13:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220727060856.2370358-1-kafai@fb.com> <20220727060909.2371812-1-kafai@fb.com>
 <YuFsHaTIu7dTzotG@google.com> <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 27 Jul 2022 13:39:08 -0700
Message-ID: <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 11:37 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Jul 27, 2022 at 09:47:25AM -0700, sdf@google.com wrote:
> > On 07/26, Martin KaFai Lau wrote:
> > > Most of the codes in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > > the sock_setsockopt().  The number of supported options are
> > > increasing ever and so as the duplicated codes.
> >
> > > One issue in reusing sock_setsockopt() is that the bpf prog
> > > has already acquired the sk lock.  sockptr_t is useful to handle this.
> > > sockptr_t already has a bit 'is_kernel' to handle the kernel-or-user
> > > memory copy.  This patch adds a 'is_bpf' bit to tell if sk locking
> > > has already been ensured by the bpf prog.
> >
> > Why not explicitly call it is_locked/is_unlocked? I'm assuming, at some
> > point,
> is_locked was my initial attempt.  The bpf_setsockopt() also skips
> the ns_capable() check, like in patch 3.  I ended up using
> one is_bpf bit here to do both.

Yeah, sorry, I haven't read the whole series before I sent my first
reply. Let's discuss it here.

This reminds me of ns_capable in __inet_bind where we also had to add
special handling.

In general, not specific to the series, I wonder if we want some new
in_bpf() context indication and bypass ns_capable() from those
contexts?
Then we can do things like:

  if (sk->sk_bound_dev_if && !in_bpf() && !ns_capable(net->user_ns,
CAP_NET_RAW))
    return ...;

Or would it make things more confusing?



> > we can have code paths in bpf where the socket has been already locked by
> > the stack?
> hmm... You meant the opposite, like the bpf hook does not have the
> lock pre-acquired before the bpf prog gets run and sock_setsockopt()
> should do lock_sock() as usual?
>
> I was thinking a likely situation is a bpf 'sleepable' hook does not
> have the lock pre-acquired.  In that case, the bpf_setsockopt() could
> always acquire the lock first but it may turn out to be too
> pessmissitic for the future bpf_[G]etsockopt() refactoring.
>
> or we could do this 'bit' break up (into one is_locked bit
> for locked and one is_bpf to skip-capable-check).  I was waiting until a real
> need comes up instead of having both bits always true now.  I don't mind to
> add is_locked now since the bpf_lsm_cgroup may come to sleepable soon.
> I can do this in the next spin.
