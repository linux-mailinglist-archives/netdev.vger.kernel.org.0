Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B12B5429CD
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732573AbfFLOru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:47:50 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34373 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732556AbfFLOru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 10:47:50 -0400
Received: by mail-lf1-f68.google.com with SMTP id y198so12366937lfa.1;
        Wed, 12 Jun 2019 07:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=atj4Dig3dtuCtSDSSa+DD85GmhDxDaBZi0keQGxDoi8=;
        b=sDszYOIoZwSCOxJ1bqIhnEQdDWhP/Y13vCedI/horI8IhJjeSMtx6JDbLl80JC+2ZG
         hjjoGsBPdZeHRiFIHWsWGZnD+JSsmNfeOUu+u/iVVl78D1Lqj1X5BVNCUzr8jw7l2Vqk
         Dc9hON+r3NREYlwIIQMKt7+X4/pTnJNDFiPN7s6QmrbpReF+FoSRaBhglQ1gyZPW6Jph
         XzpB2HbK3Wh8IjY5piM/FVYIegFueG8QtUDvETEnv6IeftPvU7gG8wcL/hHiuQzFFZ1G
         qT4i+ccebM2CrhPlZcHyixAJOj+trdKGIya7w4SNdVLaUU3zR6ufQPzN6uWut3qYcHdy
         /tTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=atj4Dig3dtuCtSDSSa+DD85GmhDxDaBZi0keQGxDoi8=;
        b=G9yqeB6V+Y7Q28NSvqYLbPwuNI8P2/eirMQNcSn6YyrcEpbo+p2/1+VmGrUugwuH5d
         nSy/VQXcbcJrefzi1ihmJg8yiM+9+Zj+YjHO6q3OHQ3u6Vl26WxpWOnr/3vWYr9ByVva
         4oWxOMEjsNlcMMnrThAO4Y/UuvYQ1ngHYl94sxkLKGxLiMX6tAgeOxUQrPHfNC8ER/w1
         Ik1S86NFdKZv5KQXNwLIBnwoqLQVVjpa/GgzPrXOrZRYLfkLg1vblGc0DVKS2iBNW73O
         X7S71EnR0QIfvRghzRve/t8BvsdTiVOFpaPBG8rlxLbhNehGXb5I48V+KEYABSlnGnpt
         SZZA==
X-Gm-Message-State: APjAAAX8cbzbJTyR60xWPeKRA8jWBMkscoAc6zn6htmaydhYjEiAoilb
        VIf+oSL1j1Uw2vehNiPJw4uzA58zIfOmURn93C1AHQ==
X-Google-Smtp-Source: APXvYqzv10lk2WbQXRocxToNZyod64yBRQS3n0YKJMQmBM6fU2Q+rYqgb3hw2533pYAt0M5y9gZ0toZWIapcNKr3Juk=
X-Received: by 2002:ac2:4252:: with SMTP id m18mr16950403lfl.100.1560350868086;
 Wed, 12 Jun 2019 07:47:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Jun 2019 07:47:36 -0700
Message-ID: <CAADnVQLp+N8pYTgmgEGfoubqKrWrnuTBJ9z2qc1rB6+04WfgHA@mail.gmail.com>
Subject: Re: [PATCH] bpf: optimize constant blinding
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jiong Wang <jiong.wang@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 4:32 AM Naveen N. Rao
<naveen.n.rao@linux.vnet.ibm.com> wrote:
>
> Currently, for constant blinding, we re-allocate the bpf program to
> account for its new size and adjust all branches to accommodate the
> same, for each BPF instruction that needs constant blinding. This is
> inefficient and can lead to soft lockup with sufficiently large
> programs, such as the new verifier scalability test (ld_dw: xor
> semi-random 64 bit imms, test 5 -- with net.core.bpf_jit_harden=2)

Slowdown you see is due to patch_insn right?
In such case I prefer to fix the scaling issue of patch_insn instead.
This specific fix for blinding only is not addressing the core of the problem.
Jiong,
how is the progress on fixing patch_insn?
