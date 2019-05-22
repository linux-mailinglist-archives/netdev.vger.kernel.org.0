Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD1C272A9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 00:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbfEVW6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 18:58:49 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:36999 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbfEVW6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 18:58:49 -0400
Received: by mail-lj1-f181.google.com with SMTP id h19so3630292ljj.4
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 15:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eiPzMyOs63Y3bxLy+vXT5x7xyRvI6hSbEVGCGU88yC4=;
        b=e2qQHdYny//6XgV1qInDJKyzy3lKA4vNtPGobrytTzIE5Zt1tJWFnLSorBYItO5L2r
         djaLoKDryHAkr7+vT1ccUSj37CnuuNWiH2gaJF3kh44ruw7xmTKsLuaDnrHoBquRTwaR
         GauDd5nCf/U1Bkr2RsNGvQYVeqwPQChdN9428=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eiPzMyOs63Y3bxLy+vXT5x7xyRvI6hSbEVGCGU88yC4=;
        b=bLICZ2x/zHFdefn+1ieLnPI5P3Nx0k1iGJfn3jYJmJizLp3Fke8a4qAnzEbzFX+O55
         /xexfsll681AtYj2vJIc9tlOWkw2nmE2w1sYQqy4eLR32OOBV1HDrUgBD/yNLVFah8hW
         Q5jszn0l9J0/oYi61QYwQNmt0dgWimTIQDOffXxPAJQnfkDDR5vcVggo2Dl2twFVNOja
         KFqPehhtOQVhN3OAbiOJGfyMZIVRg7gUcCnRho5n3UAIBslGxbTkLD4U+gDeNei0N7QZ
         i/iLqp2MUI3J5PsbaCKzs+hgCHYKSgWpaDhc31fmfHzq5GUQ/V/lADdljdy3TKJRpomu
         iLOg==
X-Gm-Message-State: APjAAAU141nVt9+wTFl0TRRmnPJGUyy7tGmNY+7jlb/X9QkwLxyrUwh6
        /VmfAr2A90IKBGJ+Tt2v9TleVHSb580=
X-Google-Smtp-Source: APXvYqynjElaXiMpA42lzUlVNYKYWZopqqhCyKsFa1okL2Rp3QmytW+dmxDegd0g1JDy6xHb+D5dSg==
X-Received: by 2002:a2e:8555:: with SMTP id u21mr38688543ljj.133.1558565926651;
        Wed, 22 May 2019 15:58:46 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id y3sm5588514lfh.12.2019.05.22.15.58.43
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 15:58:44 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id y10so2933017lfl.3
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 15:58:43 -0700 (PDT)
X-Received: by 2002:a19:7d42:: with SMTP id y63mr38374010lfc.54.1558565923584;
 Wed, 22 May 2019 15:58:43 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fd342e05791cc86f@google.com> <000000000000e7e3a5058980ee7b@google.com>
In-Reply-To: <000000000000e7e3a5058980ee7b@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 22 May 2019 15:58:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjq3q6ey_S41R0kzR0BwYBrg=h4G+x_TAJregrnkKK6=A@mail.gmail.com>
Message-ID: <CAHk-=wjq3q6ey_S41R0kzR0BwYBrg=h4G+x_TAJregrnkKK6=A@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in sk_psock_unlink
To:     syzbot <syzbot+3acd9f67a6a15766686e@syzkaller.appspotmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, john.fastabend@gmail.com,
        kafai@fb.com,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, songliubraving@fb.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 2:49 PM syzbot
<syzbot+3acd9f67a6a15766686e@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit 48a3c64b4649 ("Merge tag 'drm-fixes-2018-06-29' of  git://anongit.freedesktop.org/drm/drm")

That looks very unlikely indeed. I strongly suspect your bisection is broken.

Looking at the bisection log, the problem sometimes happens only once
out of the ten tries. Presumably it then happened zero times a couple
of times, and the bisection went off into the weeds.

Any possibility of re-doing the bisection (the ones marked "bad" are
clearly bad, so you don't need to redo it _all_) with many more runs
for each test point?

                 Linus
