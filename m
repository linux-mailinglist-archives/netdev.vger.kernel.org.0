Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF1B41F86D
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 02:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhJBACg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 20:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbhJBACf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 20:02:35 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF59DC061775;
        Fri,  1 Oct 2021 17:00:50 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id z5so23910873ybj.2;
        Fri, 01 Oct 2021 17:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IrFD9m/yZudFqfkKn6shlO1MnuJ+CaJRGM3yhqCgxn4=;
        b=o/RbuAWuljay28z7qVHyrZIpl7LhJ75d7GSdFp0r72MR3ZfwNuhjT9smXHTV+Qwf0l
         mICzFNKKpsVOj3HJQOd2ovjstWKM96zfA/LbM6xxhQlXafOQ9ZvyaoMY8CFCUp+WqFcB
         xprIkR8ikWKrS5vrSmxsdWwM+exiRrEIirzE1ENB4n8j92FgpX50OJB1BAObKB4d1kiH
         c5jG511krtE3CWDqDWw+q3ZWHMrraGODHDmO7vqeprkPCmAVq6uawpF5eiXiNH983r7y
         0bcLN0aziCztdKS3RH3tzAyN2m/5S0JG6g20of4PTEhn61r8nliR8U+6OW850RYkJNwv
         yjFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IrFD9m/yZudFqfkKn6shlO1MnuJ+CaJRGM3yhqCgxn4=;
        b=Qt9cqKmnDtgXZKFqrn8g89kTQpLB4raveebGB6IAV+92Tg5GjLavLNgkDpgQCvsgFN
         6aEDsZVZo7IqSb76v+vRYspTwDdmHo3vI5yVHNJq8HpkAs8pOwh2h79Z1tSQAE3pgi0G
         AmVN00bqVd60LtIYTRCVQduDCXol/3YJFnLsaNllMJXJHs0QhLHRl2u5k8IK5Ass0NIQ
         LR0G68SIofFXtCmSbBXXyC2f/39EDV2EOPclBTkKKcP0rngJdDqHIWSpDUtBAeuhHd4y
         zf+5mPad65h1xfaZxh8lIpKEFB0SDm7RdxNzDiuaSPOUFKAM/mPRxIArQt4uFU3ywKZ8
         x45A==
X-Gm-Message-State: AOAM5332HxULAzvcI4aZIfJKn/8D6Hee60TSkdI+tURW1C8gs0kg11Ty
        j2AkZxaF2wermyj14m/nlliiAqiunDmV0cdocNE=
X-Google-Smtp-Source: ABdhPJxe1TM5L4BtTMNaBlwl2UlPzbM1Ec3gJ02NKzc1YIbpkt/8omcMcrxH1lIlHKaPYbVrGQUL8CbM3E1BOoxCpAM=
X-Received: by 2002:a25:bb0b:: with SMTP id z11mr786543ybg.108.1633132849900;
 Fri, 01 Oct 2021 17:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210928002212.14498-1-xiyou.wangcong@gmail.com>
 <20210928002212.14498-4-xiyou.wangcong@gmail.com> <61562fa0b3f74_6c4e4208c1@john-XPS-13-9370.notmuch>
In-Reply-To: <61562fa0b3f74_6c4e4208c1@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 1 Oct 2021 17:00:39 -0700
Message-ID: <CAM_iQpUj7h0L7xE=CY0zHTJ=VzJ-Cmy6foJQvvpTv1aixLwY6Q@mail.gmail.com>
Subject: Re: [Patch bpf v2 3/4] net: implement ->sock_is_readable for UDP and AF_UNIX
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 2:44 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > +bool sk_msg_is_readable(struct sock *sk)
> > +{
> > +     struct sk_psock *psock;
> > +     bool empty = true;
> > +
> > +     psock = sk_psock_get_checked(sk);
>
> We shouldn't need the checked version here right? We only get here because
> we hooked the sk with the callbacks from *_bpf_rebuild_rpotos. Then we
> can just use sk_psock() and save a few extra insns/branch.

Good catch! Indeed only sockmap overwrites that hook.

I will send V3 shortly after all tests are done.

Thanks
