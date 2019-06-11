Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00CE3C458
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 08:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391214AbfFKGgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 02:36:23 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41279 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390485AbfFKGgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 02:36:23 -0400
Received: by mail-lf1-f67.google.com with SMTP id 136so8381239lfa.8
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 23:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W9YFEKTGAkTYLGj170sg5Xp7uQpSs3pvrKuAYhY4Fzk=;
        b=LopbqbmDpRA3tgW/YgPLP3MgfJbFJXTtJw5H35lAB5547qKnEutQgzoFYlc58YMstd
         lc1pv6OTmzxvfGFGCeMkhivo/8iIRLed+7rqBMsVhZ+JTPWIinM7yp/WIZutE98iLVsk
         tLeH8/hoScxNfldcslEzRo9cdmdy7Ka00mrwoyiSKnI7LTD0EAAVeB8CCH3k6BP3MWmI
         TGGtbLdepB46eJsyegQSOJ+U+dZzU/noFpOK/EZpA52u/R5KPqw6qLvsg5Xi7W8HPwpi
         woehWRDf8Sps93PUHLY27PL8MeFuitUmoDzwOPVaY9JGtJdjn9bPmejm461Ee8Pd0RuO
         fGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W9YFEKTGAkTYLGj170sg5Xp7uQpSs3pvrKuAYhY4Fzk=;
        b=K4MANE/zp37bf5uNtXzDFYA+uzkkvZtdDiY4YxPKneBWcj8OZz1o370bddT6oFR7TT
         3zq0S9oDT34S20jB+MPoMjFwRr780oGFVeRtawHcClWByM8V65djP/i7vrYcJPPSX5oX
         4cpYWyIG9iEntkzGzume1zJQZghkwtxUFNbsz7WuVz4tn6qLG2XfFTawtK9iUwT5HYvB
         9s4k2sEhJOLeyNRSovwHBB4OjqwZVJjQkL+8GaH/nmL70AtrQw8vJbNcAOE7iyP/Qybq
         9LlWtaSzJjjZNM8cgpMrmXcTuI2zqp0qkB9XX0dAjlraeokulb0Y/+6wGABciOQrZ4AI
         ZtVw==
X-Gm-Message-State: APjAAAXgFcTfJy/olb/zAnCqqVDEhTpwjz1ZBPezT/8ogtyjQZUhg6xT
        d3cvdrbdlJUGO1ZWmSC8wdMXOjqDe7iTzcfkGBA=
X-Google-Smtp-Source: APXvYqwO5uSGXOY3lW+S27lO4h/DGSQ6j/RMKVNjDcX2dakU6P7CU/bDU6306oLxd5RZ4+o1H2w31BOnGMqlc7NsJMs=
X-Received: by 2002:a19:e05c:: with SMTP id g28mr22401639lfj.167.1560234981544;
 Mon, 10 Jun 2019 23:36:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190606205943.818795-1-jonathan.lemon@gmail.com>
In-Reply-To: <20190606205943.818795-1-jonathan.lemon@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 10 Jun 2019 23:36:09 -0700
Message-ID: <CAADnVQJ=fP0Uc7U6=Tefegt1D6tMj2vvAs4NRNXATPbago1xJw@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/4] Better handling of xskmap entries
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 1:59 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> Currently, the AF_XDP code uses a separate map in order to
> determine if an xsk is bound to a queue.  Have the xskmap
> lookup return a XDP_SOCK pointer on the kernel side, which
> the verifier uses to extract relevant values.
>
> Patches:
>  1 - adds XSK_SOCK type
>  2 - sync bpf.h with tools
>  3 - add tools selftest
>  4 - update lib/bpf, removing qidconf
>
> v4->v5:
>  - xskmap lookup now returns XDP_SOCK type instead of pointer to element.
>  - no changes lib/bpf/xsk.c

Applied. Thanks
