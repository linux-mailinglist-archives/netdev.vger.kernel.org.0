Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEA31D1043
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 12:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgEMKu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 06:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbgEMKuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 06:50:55 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430F6C061A0E
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 03:50:55 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s1so142428qkf.9
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 03:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o6RF/R6nRQ24p935e51htzLuDvkMpsHnIopBh1qLWjw=;
        b=NFawZPSY96WEDGV0An6C8cEVv9LnWtImKiszvdFNYCXVeQsIMqj0zPogcRzsak+YA2
         0l2tn3kPOa+7ZrmY02IwaRMihrn4W1zTvxSR95KNG+ZmaADaQ1DoT96Dd8P9rlHB2j5f
         eBiG0FyTo7b6QhaBbNw6G163MBBr5aSp6/SQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o6RF/R6nRQ24p935e51htzLuDvkMpsHnIopBh1qLWjw=;
        b=kld6Xfe9e9xy0rZ9CIhlYH2/W3qYzTk3MuSnLR4JhW5YyA3Ta5wzqfzwjOAm3qME/j
         oafTVUxKzjVC4+n4UXIV6GbAIZ+Ic3SZ3tXB1Ygv2ttJK3Eti3p/U2W6ptuqYI/GRzFS
         1RP3l28J06EAYEoDXc0pmarI8EDJiVVBZ/x5yGUYiGscUpKQ4alUdE+JVuZfwjMXsQcz
         Zy168uvaeIH+x5dMnHSC4bjMVKnjpgm73WTbyc0OPiApgu3ryM1R/1AIXhG9qJKXXH1D
         dMf/pE3ALO3dRl77Wof1moUNbsB5AD2fkYT98mvHTYoxGXjgiMIgOby0DWI/WJ23FQWF
         NmBQ==
X-Gm-Message-State: AGi0PuYbENjYhBweVAm9JQSAq5TXw722tAK4JpaFJF0+gx3In8LiA0As
        A/5hWhjRcy2kbS7hBkIw33dhGQ1GHnlYpcl4g5yDew==
X-Google-Smtp-Source: APiQypLoXfq1+PMeeoxxa6kAuVOtGxB0PsKlzBMx4xsPyXCS3MOLmm8Q+KsbxzPd2hhJA2wOHbtUTs+v+GidleTZmcs=
X-Received: by 2002:a37:9d4f:: with SMTP id g76mr16242977qke.235.1589367054213;
 Wed, 13 May 2020 03:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Wed, 13 May 2020 11:50:42 +0100
Message-ID: <CAJPywT+c8uvi2zgUD_jObmi9T6j50THzjQHg-mudNrEC2HuJvg@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 0/3] Introduce CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        network dev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com,
        Jann Horn <jannh@google.com>, kpsingh@google.com,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 4:19 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> CAP_BPF solves three main goals:
> 1. provides isolation to user space processes that drop CAP_SYS_ADMIN and switch to CAP_BPF.
>    More on this below. This is the major difference vs v4 set back from Sep 2019.
> 2. makes networking BPF progs more secure, since CAP_BPF + CAP_NET_ADMIN
>    prevents pointer leaks and arbitrary kernel memory access.
> 3. enables fuzzers to exercise all of the verifier logic. Eventually finding bugs
>    and making BPF infra more secure. Currently fuzzers run in unpriv.
>    They will be able to run with CAP_BPF.
>

Alexei, looking at this from a user point of view, this looks fine.

I'm slightly worried about REUSEPORT_EBPF. Currently without your
patch, as far as I understand it:

- You can load SOCKET_FILTER and SO_ATTACH_REUSEPORT_EBPF without any
permissions

- For loading BPF_PROG_TYPE_SK_REUSEPORT program and for SOCKARRAY map
creation CAP_SYS_ADMIN is needed. But again, no permissions check for
SO_ATTACH_REUSEPORT_EBPF later.

If I read the patchset correctly, the former SOCKET_FILTER case
remains as it is and is not affected in any way by presence or absence
of CAP_BPF.

The latter case is different. Presence of CAP_BPF is sufficient for
map creation, but not sufficient for loading SK_REUSEPORT program. It
still requires CAP_SYS_ADMIN. I think it's a good opportunity to relax
this CAP_SYS_ADMIN requirement. I think the presence of CAP_BPF should
be sufficient for loading BPF_PROG_TYPE_SK_REUSEPORT.

Our specific use case is simple - we want an application program -
like nginx - to control REUSEPORT programs. We will grant it CAP_BPF,
but we don't want to grant it CAP_SYS_ADMIN.

Marek
