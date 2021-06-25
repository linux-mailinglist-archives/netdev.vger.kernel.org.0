Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB363B465C
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 17:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhFYPJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 11:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhFYPJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 11:09:45 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAC0C061574;
        Fri, 25 Jun 2021 08:07:24 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id i13so16786259lfc.7;
        Fri, 25 Jun 2021 08:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=svkyksNfhmxePdvgJKJPqr2pES2gWbjljd0+oSLrCbk=;
        b=ei66awCGjohBDRqTdvTXGIiSfxI7GLRcHOCGeuYlRtCZOhRBFL61I4dasn2nQ6WVnS
         +FZ2e+Zo0RvfllLVz5NA8JvreDtw22TZ9O7b9JUsnks4pajjtN3TvF5ROVwPdhSE/Ow0
         r/Ji0Gs3u741fkPvh/s/hlmglFjid+9QtoavP+vZQiYpRanRx8MRswj9UbO3g6oenJSp
         QufAPBGVDVnAeu0YrIMLcVgZbwCSDRfPxmLEsQ8QVANwVpu0a6C8UunnSDPOBHaaW6EA
         y7yQzcyNWTtF/xqF518mjXms5r0ek5+Ex4MW7PyGDegsYYO5wWg5X7B77YgWFKvN0A2z
         6WhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=svkyksNfhmxePdvgJKJPqr2pES2gWbjljd0+oSLrCbk=;
        b=cOh+SM9jXUE7qUY5KCid6jpMCwW1U+bSB+Ls9Rq+mhOwC5O/QiY74hs+Zojipw3H8e
         4L0QAT16+3O7z6SaJFyAvyLxl7wzn2EY3sjirLG2IPh0ZaA2HC52H2Ul96cYAGI703NV
         0HRnS73s7QgiKb4DRWcPYYXNSpUN1zvv0Srel3KnnfJYmbleK8SJSwpXOiTQOEurFWlL
         Z1dnS/UzN/rtivYA7Df9ZJvMI0HVI0qZX2lLCrjI3mk/HD74pmgRLDqrGgRDPDOi6hsY
         qrUiBuiMmfb4eAdZlV10YhDG4Lh5+afjMxUt0VPAktA0X+0MC3/nNr4dlnkYwQQ+ETh+
         TP8Q==
X-Gm-Message-State: AOAM533/JXS7+HncUsgwJyE0OXVK2yl0GKCgRoigoHu975AhoWA15saz
        YqQQvqjhe8zSBj2aj1t6zNMST8qf4T55FpLO07M=
X-Google-Smtp-Source: ABdhPJyn2BUgSGrJfpZtRns/wqudcsilxjSgHGAe2cRG9riIPlkwBYJeORHhQpGNgwY79XX5x0m6jIESBsvqlwIhtuQ=
X-Received: by 2002:ac2:4e82:: with SMTP id o2mr8606980lfr.38.1624633643234;
 Fri, 25 Jun 2021 08:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQJux+8n-vpuK9FqTLuj4cXrp04pGkpvKaUdAPXLQ4c-PQ@mail.gmail.com>
 <20210622110026.1157847-1-ravi.bangoria@linux.ibm.com> <CAADnVQKLwEEZJ=_=g8RfgOrt9b1XN=dM9bt515pOrru=ADQR1Q@mail.gmail.com>
 <960b5e26-e97d-2b1a-4628-df8525c0728b@linux.ibm.com>
In-Reply-To: <960b5e26-e97d-2b1a-4628-df8525c0728b@linux.ibm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 25 Jun 2021 08:07:11 -0700
Message-ID: <CAADnVQL7BdReSgw++Eh+MvS4+_uqnFFvp+7N4cGO2MWMTWaqcQ@mail.gmail.com>
Subject: Re: [PATCH] x86 bpf: Fix extable offset calculation
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 11:22 PM Ravi Bangoria
<ravi.bangoria@linux.ibm.com> wrote:
> > Could you send a followup patch with a selftest, so I don't make
> > the same mistake again ? ;)
>
> Unfortunately extable gets involved only for bad kernel pointers and
> ideally there should not be any bad pointer in kernel. So there is no
> easy way to create a proper selftest for this.

Right. We have lib/test_bpf.c kernel module for such cases.
