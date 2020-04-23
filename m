Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457371B5442
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgDWF3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726027AbgDWF3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:29:17 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF68C03C1AB;
        Wed, 22 Apr 2020 22:29:17 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id r17so3715154lff.2;
        Wed, 22 Apr 2020 22:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OvwANZ50BYHbdM53cjg6Ie9KQxCh8TcIYuZW9bMZWgo=;
        b=GApN3mpnXSsQdVgpO16HhRHm9D1UrgLe4GItyxL85AvES2eFwsurcz7JqpuGO/QpE6
         vwo0YNln1qG9Rb1IROFKqgw61A9NT2O6ewlrXGb1fVRAlPK0oMBzdLgRdIrK2206nwiX
         KuWFclv+4jA8Qf8wf1ZmvRYjcnq9L/gjn5POj884T7Fm7B4TKyBNjd88fpoe+FguYTW3
         oQRbRtKdSCB7eaq+X8QwHHOgltPd5VIMjTVBr1HAE7czIyi3YSxYwH7nCKoqJsWccHMW
         LzdaUYmlTijiYs7vIxTPGms8+t7V2bLK6MRZCDccD+lKuIA6iFg2pZrehKsdAmxoFHwF
         8/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OvwANZ50BYHbdM53cjg6Ie9KQxCh8TcIYuZW9bMZWgo=;
        b=Cm31vu1YPXbIOMjmXipzWR0ho2iYve28AM1hncq3rodF8aLgMuZ2tCmdtrgEBswoZY
         mTWGkpETmAUtIuK4wiH0n97gmOTlVzUFIKhd4S+wKJ9nXpdb+BS4YYFtJStDB+VLDtTO
         ql5CG465bMYSazhttBl78tx0DBd8hkTk8hn2J3DACOWRwX10PvzEP0XtivICEABrr2Z0
         dQJhT/fY4tT4GmYVzrqg49duphJZlHOR2DaYtAm7Ar65Mc49VnAMJTQmcZO2cgAhamrV
         2x56XotOqJ9SPOff9otsc3FBZAqkS039nwG/UnYcKn6+BAJw4AR18gGRadzBUQ1eFiAw
         Mgtw==
X-Gm-Message-State: AGi0PuYXE7gm5DIiSFT+m3lp+IpJ58dGXn2YxoNd7uE+9eEQTRVBIdaS
        183dopo0ELss7yaFknMV+OAjCHmFbNjyVeWsOl8=
X-Google-Smtp-Source: APiQypIBAfdsfyIcYH5jTMKcB5AikSQ0/9NuwH9FYspTBf/i9YuCKHSBz8UMRJTv1vpiZ1TqZIdKEthn4AXRo5ktzXc=
X-Received: by 2002:ac2:569b:: with SMTP id 27mr1280515lfr.134.1587619755739;
 Wed, 22 Apr 2020 22:29:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200421002804.5118-1-luke.r.nels@gmail.com>
In-Reply-To: <20200421002804.5118-1-luke.r.nels@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Apr 2020 22:29:04 -0700
Message-ID: <CAADnVQ+taVOr+Zr44eGgOoHXD6y-T-KBKco4KbFZ26jAOsa90A@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf, riscv: Fix tail call count off by one in RV32
 BPF JIT
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 5:28 PM Luke Nelson <lukenels@cs.washington.edu> wrote:
>
> This patch fixes an off by one error in the RV32 JIT handling for BPF
> tail call. Currently, the code decrements TCC before checking if it
> is less than zero. This limits the maximum number of tail calls to 32
> instead of 33 as in other JITs. The fix is to instead check the old
> value of TCC before decrementing.
>
> Fixes: 5f316b65e99f ("riscv, bpf: Add RV32G eBPF JIT")
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Applied. Thanks
