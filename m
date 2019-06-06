Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7809368A4
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFFAOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:14:04 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44668 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFFAOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:14:04 -0400
Received: by mail-lf1-f68.google.com with SMTP id r15so173630lfm.11;
        Wed, 05 Jun 2019 17:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aXrDN3EGoMNOai3xNClZPIzc6tnDf+HKd0phCU3s7tU=;
        b=F6lRlbd10IcIoKchBpSGeanqhBOXnHVi+4WteJiHZcWYMYpPLyW9ZJMhl4ISQxY6rR
         I+6i4gG5srqlwQaLpbVzXC/L3w4zv/IxIdPdINvJOqMyDFL2WmOekaYtliNxcv7p9JS7
         2ycLIJR5YQsy/VJgx5n/9SXHnv5c9mQkVWbwk2krQ0IgTGYxoGorO4s+bprNYcy4TXVb
         CmWsqMQvZuDw6pDrpycvAFsToHiQD4uj17IjE3A7wlT+DrJisyTYTkaOL+NSEsfSmfF1
         g8IR7xwQ61wwBfNnqWg6HF16Bxv7Ayo7lDPLeQjp0MdUeCitP6pW78LuXtczeNA8ZocB
         8AZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aXrDN3EGoMNOai3xNClZPIzc6tnDf+HKd0phCU3s7tU=;
        b=GMJaMO9NTVFijMdFsC5e1OSXBXZhwPcUnUYExKJ0oYS6m426sXQyeE1hznE2R3yUjR
         ox/cL/F/hqBd1FvA05IKtr69xWwO8Mw7Tem1pwMRVxw4Zw8wSFy4Gdml3ISi91Odfr7p
         R9UmgzM9UrXwvewUlpqD+n/4vTa9GY1BMdDwk09aU0f6K/WeZx6EUKGps/cn535Cck0H
         DqrX/1x+AU2qaEX7KcmXDF1YwSA8Xa+aGbrWGyWq5dBRWFfjupY+5iltuFboxNhwnrTm
         kgZx4EXGjIaJwzVheg1NhShwQVhofE1h7M9t6Gfyxr9+Qkp9rP4/kgGbZyftLO+2vzV4
         ZUlw==
X-Gm-Message-State: APjAAAVdHT4Sp8lqqB12GpY+kr76yc9IJKQ05N6y2XOfpjZjG2y74Irw
        Pe32njssULIHdBmIDpAdAvS19cDr7WCvRP0Wv6U=
X-Google-Smtp-Source: APXvYqxMXfxvz5dtkY2Jcgv/Al3NCEeVsKuYHWMMcvilTML82tvagnn/uHV8Q0bpPJ20rR7KrlL3kvF0XDwZLLK7tDU=
X-Received: by 2002:a19:e05c:: with SMTP id g28mr7340408lfj.167.1559780042420;
 Wed, 05 Jun 2019 17:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <3d59d0458a8a3a050d24f81e660fcccde3479a05.1559767053.git.daniel@iogearbox.net>
 <20190605235451.lqas2jgbur2sre4z@kafai-mbp.dhcp.thefacebook.com> <bcdc5ced-5bf0-a9c2-eeaf-01459e1d5b62@iogearbox.net>
In-Reply-To: <bcdc5ced-5bf0-a9c2-eeaf-01459e1d5b62@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 5 Jun 2019 17:13:51 -0700
Message-ID: <CAADnVQ+nraxxKw8=ues8W3odoLx5JR3JwAjCqW3AA3W64XY77w@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: fix unconnected udp hooks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin Lau <kafai@fb.com>, Andrey Ignatov <rdna@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 5, 2019 at 5:09 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> >>  tools/bpf/bpftool/cgroup.c     |  5 ++++-
> >>  tools/include/uapi/linux/bpf.h |  2 ++
> > Should the bpf.h sync to tools/ be in a separate patch?
>
> I was thinking about it, but concluded for such small change, it's not
> really worth it. If there's a strong opinion, I could do it, but I think
> that 2-liner sync patch just adds noise.

it's not about the size. It breaks the sync of libbpf.
we should really enforce user vs kernel to be separate patches.
