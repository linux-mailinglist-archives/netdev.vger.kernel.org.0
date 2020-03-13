Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44306183EAD
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 02:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgCMBaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 21:30:21 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39744 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgCMBaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 21:30:20 -0400
Received: by mail-lj1-f195.google.com with SMTP id f10so8702978ljn.6;
        Thu, 12 Mar 2020 18:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+f8gupTNs8QwwqWyowgs1SqTg/02EBthP6Knr2UCYRA=;
        b=nODddTl+e3Eqhf35jmrbsBgEa7ZJS/NjbHhO/55Z0Ucao9gyT8nP5LEGpH7ZdR+OeO
         QxWCWPGYI/HML9LH/KOz3r9TS8yfa9aNfVE5RQcV95nBLngKOALQwAm5M5h/YaP/5exo
         6PLCQrvPagKAGtcF2rGpBVbp+FTytIt0fG06VCLw2ujptbZ4FTsLSYwO0TVeCmr1DldG
         nnKdYttGryD5NlVdvHDDiq5wrxhPjT3CNpmmJkWrPyPzxns32dHTFMxZGxXyJKpImoxf
         0ba7E80ZVL1oVNM/6oI1meq+HpgpEDIJxBWGjrFxwysr6m7T5Mxo5lbd1JX6KXp6AU+m
         l5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+f8gupTNs8QwwqWyowgs1SqTg/02EBthP6Knr2UCYRA=;
        b=bDR2ZBq4u8CPldFX12RhX+yuQGsNybu/9iEu6YDQg3ir4YKboLfBYA2lW0iBfHvkNo
         41Lc3raneliG6BGHoW35q6P77pD4qCVvECBwvcUhG3RUHUnwgfAlLkO3TFVfswbDvlNN
         qFUBU42s/X1vXD5tDq8/mHTHdRU9Fss6kR/iaRaGK6cXIeftdOu3YJf/sh4qzbrjm0Xd
         8yvtoFajLkle39Wtl3dzM56pknk1tIM2pE7XEaz33MpKqBRBdbAQtSnoMqOw6YcKLf+r
         QU4EZ15peWbZohQD0ngZwTnzvyzEs+hVzmbq1SIamvtFzzv5jAaKQeD0RZQNrPT2HGMN
         TSzQ==
X-Gm-Message-State: ANhLgQ152Zd/5Yfvvy6yPm+OIuyha7RgBSEhcniS/3la6TveNRMFxCpR
        dmw0/O31SRLcAOBig+CGTdismVYLqRkwOM8/GOU=
X-Google-Smtp-Source: ADFU+vu4XHi9NvP91XxA/aM32nSzOLsNTjUcXLjbRHfqWU9Rm+LxHGAQ9avw47qGP3sNjJxHd7qqdirT2z5toBVBdH0=
X-Received: by 2002:a2e:b5a2:: with SMTP id f2mr6980702ljn.212.1584063018944;
 Thu, 12 Mar 2020 18:30:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200311222749.458015-1-andriin@fb.com>
In-Reply-To: <20200311222749.458015-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 12 Mar 2020 18:30:07 -0700
Message-ID: <CAADnVQKf3fXHGgpkR31tBaBK8mQ5eN4Bio26jkPi6sJ4h=KUgg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: make tcp_rtt test more robust
 to failures
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 3:28 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Switch to non-blocking accept and wait for server thread to exit before
> proceeding. I noticed that sometimes tcp_rtt server thread failure would
> "spill over" into other tests (that would run after tcp_rtt), probably just
> because server thread exits much later and tcp_rtt doesn't wait for it.
>
> v1->v2:
>   - add usleep() while waiting on initial non-blocking accept() (Stanislav);
>
> Fixes: 8a03222f508b ("selftests/bpf: test_progs: fix client/server race in tcp_rtt")
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
