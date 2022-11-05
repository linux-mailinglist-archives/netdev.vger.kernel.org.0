Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F026061DD1A
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 19:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiKESGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 14:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiKESGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 14:06:20 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752BD12D06
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 11:06:14 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id h10so5514313qvq.7
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 11:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QVXj0cLL9VUphH0bgK54o5rYv0DrN8lZjO0Vg0C726g=;
        b=BiWqOqpPR07eLTLe6T5V72Y9xGIsPmkwMbeqbdJI+puK8c9LIXxNrw3cBq8D1NOQuQ
         pJAo1Am+vhs2mPh44VnFCaOf/bPGjWGgUGvIUZGM5ZyxOFAC9ctuTinIwdqjqf8e/+Oh
         zszIk7RIyfcGhJ2qo9t79gizH+wXzLk0Rme42YB++2Np66N+AS1lZh5mWgKCvTL3MXkG
         IroGDXKDgdShBjiGiZjOoQb51+O4x47utL/pDgknyokKrwmVyCvjvq6zXYAtCtqhz/aH
         Ayrr65bsaXYcR6RqK22dn9qNoe8iDNfts2eAAfn9pZJm5cU/ksSijDS3FPNr7M24NIUm
         TXPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QVXj0cLL9VUphH0bgK54o5rYv0DrN8lZjO0Vg0C726g=;
        b=L9jbfMhiZ8hqwnpSnKD4Dp7MXSROxRBxgBU+BNpAt+E79EPWBI0y45PrCPHl2Va5Bg
         The3lxO5alIVd9D13CLJO2wVMnC1sb+MfHLJVCP4qK9nnlsANbda+gaW34LaD1sSWXJj
         tF5MLM2wzBSUvxqdpluj8vi6i8ApZyezYmkZ2eJbj2EQ9o+FX7a6lYZMhjB29rdvZ/Ot
         WdYMDfyNq+avtPfG7Rh8kIVC6MSRrBcOkerrujtJSsG3RQJduhb0wmcLWojxt7ih08l/
         94rWJHZJJHPHMJ/EfrU8tASpwO0zmS1cVf12caGmdutFMhLhjWBmOQnk4KmtiycVW2He
         yp6w==
X-Gm-Message-State: ACrzQf1KCsmeII/MJxKQZNMijMNOOYjwSpSIKzu4ncVqG99HKF87EPEm
        qIRxplSYoFT49JD+nqsf6OiOZO2mqBk=
X-Google-Smtp-Source: AMsMyM5ykWHATcWPatRo/33KLi9THALVK39GfwuzjEdKSjc9B/MtYqEqfDl+8fz+JopiU4lH7mK6rA==
X-Received: by 2002:a05:6214:ca1:b0:4bb:9b8c:55a0 with SMTP id s1-20020a0562140ca100b004bb9b8c55a0mr37286660qvs.131.1667671573428;
        Sat, 05 Nov 2022 11:06:13 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id r1-20020a05620a298100b006ecf030ef15sm2338501qkp.65.2022.11.05.11.06.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Nov 2022 11:06:12 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id k13so5429994ybk.2
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 11:06:12 -0700 (PDT)
X-Received: by 2002:a25:f89:0:b0:6bc:1488:2f93 with SMTP id
 131-20020a250f89000000b006bc14882f93mr495714ybp.85.1667671572356; Sat, 05 Nov
 2022 11:06:12 -0700 (PDT)
MIME-Version: 1.0
References: <20221030220203.31210-1-axboe@kernel.dk> <CA+FuTSfj5jn8Wui+az2BrcpDFYF5m5ehwLiswwHMPJ2MK+S_Jw@mail.gmail.com>
 <02e5bf45-f877-719b-6bf8-c4ac577187a8@kernel.dk> <CA+FuTSd-HvtPVwRto0EGExm-Pz7dGpxAt+1sTb51P_QBd-N9KQ@mail.gmail.com>
 <88353f13-d1d8-ef69-bcdc-eb2aa17c7731@kernel.dk> <CA+FuTSdEKsN_47RtW6pOWEnrKkewuDBdsv_qAhR1EyXUr3obrg@mail.gmail.com>
 <46cb04ca-467c-2e33-f221-3e2a2eaabbda@kernel.dk> <fe28e9fa-b57b-8da6-383c-588f6e84f04f@kernel.dk>
In-Reply-To: <fe28e9fa-b57b-8da6-383c-588f6e84f04f@kernel.dk>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 5 Nov 2022 14:05:35 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfEqmx_rHPLaSp+o+tYzqCvF6oSjSOse0KoFvXj9xK9Cw@mail.gmail.com>
Message-ID: <CA+FuTSfEqmx_rHPLaSp+o+tYzqCvF6oSjSOse0KoFvXj9xK9Cw@mail.gmail.com>
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 5, 2022 at 1:39 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> >> FWIW, when adding nsec resolution I initially opted for an init-based
> >> approach, passing a new flag to epoll_create1. Feedback then was that
> >> it was odd to have one syscall affect the behavior of another. The
> >> final version just added a new epoll_pwait2 with timespec.
> >
> > I'm fine with just doing a pure syscall variant too, it was my original
> > plan. Only changed it to allow for easier experimentation and adoption,
> > and based on the fact that most use cases would likely use a fixed value
> > per context anyway.
> >
> > I think it'd be a shame to drop the ctl, unless there's strong arguments
> > against it. I'm quite happy to add a syscall variant too, that's not a
> > big deal and would be a minor addition. Patch 6 should probably cut out
> > the ctl addition and leave that for a patch 7, and then a patch 8 for
> > adding a syscall.
> I split the ctl patch out from the core change, and then took a look at
> doing a syscall variant too. But there are a few complications there...
> It would seem to make the most sense to build this on top of the newest
> epoll wait syscall, epoll_pwait2(). But we're already at the max number
> of arguments there...
>
> Arguably pwait2 should've been converted to use some kind of versioned
> struct instead. I'm going to take a stab at pwait3 with that kind of
> interface.

Don't convert to a syscall approach based solely on my feedback. It
would be good to hear from others.

At a high level, I'm somewhat uncomfortable merging two syscalls for
behavior that already works, just to save half the syscall overhead.
There is no shortage of calls that may make some sense for a workload
to merge. Is the quoted 6-7% cpu cycle reduction due to saving one
SYSENTER/SYSEXIT (as the high resolution timer wake-up will be the
same), or am I missing something more fundamental?
