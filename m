Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DBC77606
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 04:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfG0Chh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 22:37:37 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44569 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfG0Chg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 22:37:36 -0400
Received: by mail-lj1-f195.google.com with SMTP id k18so53234721ljc.11
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 19:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rRuVoGQyiTr9OUVJXnZ+mSEFCM9DeRijbw8KeVVr9qA=;
        b=CqthdUK3I5f1pgMbLDofd4KnjLcPFrqkN9aDucnvupiA1OVhLJf7fiU9qJpf7ye2GT
         RbW1RNJFPP/itRtlczIUYEZnt/BZbeyMOTY+mA9Q3Br/G3SfnGCP4iMUnQIBll/n1pik
         D/0MwAQdtPTxdxt/k0w3VOygmGrY+l6w3VCNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rRuVoGQyiTr9OUVJXnZ+mSEFCM9DeRijbw8KeVVr9qA=;
        b=i60LRLQGNyi7Tt7pY/LbVaFM85E9LKaSKavfepNHFupcTis/mnB6PD1gSlmQ7Ls7Tl
         Kqya/atUVQ6ttlUR4WNDA9yj+nmrzX6Yr+00n9QYbGhXtKcTxDARiObQfvH2GZF25xyY
         HCiW43/xbV1zLQx5nbje9cDgn7gpOg5gGJPT+mymygRLL3AaiH3LLzFtshQezN30ZrzD
         9KV/3FKgwzA43frFGJ+CYM/cK4bUDUXm3SsHHgl0xg+jbm06MlsP6uOYK0DMmYm1Ecqr
         7WnOpp6TqiYpq3LnSCpRREMlU8OUQ4P5BwpxakWkSgRk7USF/G2b4CEyq1Rb9gVirZ+x
         NK0A==
X-Gm-Message-State: APjAAAVhjF5VWuXOqGBQzYSm5DXc/XZ9mk3itfZ2CLWBnsnC6eRFelcG
        Re0fJuFpcAkePnPQhfeUt91LrzHfNug=
X-Google-Smtp-Source: APXvYqws6VhND+IxMxWyTj1zcMkxcWMMdSBiT1E3+gujKjGfC+ml4A9MRdMrWTNj/4NBcjLGLyeYdA==
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr42732717ljq.184.1564195054279;
        Fri, 26 Jul 2019 19:37:34 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id x67sm10625744ljb.13.2019.07.26.19.37.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 19:37:34 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id c9so38313143lfh.4
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 19:37:34 -0700 (PDT)
X-Received: by 2002:ac2:4839:: with SMTP id 25mr46122226lft.79.1564194572710;
 Fri, 26 Jul 2019 19:29:32 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000edcb3c058e6143d5@google.com> <00000000000083ffc4058e9dddf0@google.com>
In-Reply-To: <00000000000083ffc4058e9dddf0@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 26 Jul 2019 19:29:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=why-PdP_HNbskRADMp1bnj+FwUDYpUZSYoNLNHMRPtoVA@mail.gmail.com>
Message-ID: <CAHk-=why-PdP_HNbskRADMp1bnj+FwUDYpUZSYoNLNHMRPtoVA@mail.gmail.com>
Subject: Re: memory leak in kobject_set_name_vargs (2)
To:     syzbot <syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        David Miller <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kuznet@ms2.inr.ac.ru,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, luciano.coelho@intel.com,
        Netdev <netdev@vger.kernel.org>, steffen.klassert@secunet.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 4:26 PM syzbot
<syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit 0e034f5c4bc408c943f9c4a06244415d75d7108c
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed May 18 18:51:25 2016 +0000
>
>      iwlwifi: fix mis-merge that breaks the driver

While this bisection looks more likely than the other syzbot entry
that bisected to a version change, I don't think it is correct eitger.

The bisection ended up doing a lot of "git bisect skip" because of the

    undefined reference to `nf_nat_icmp_reply_translation'

issue. Also, the memory leak doesn't seem to be entirely reliable:
when the bisect does 10 runs to verify that some test kernel is bad,
there are a couple of cases where only one or two of the ten run
failed.

Which makes me wonder if one or two of the "everything OK" runs were
actually buggy, but just happened to have all ten pass...

               Linus
