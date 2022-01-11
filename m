Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1035048B461
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343982AbiAKRuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344718AbiAKRtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:49:40 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21112C06173F;
        Tue, 11 Jan 2022 09:49:40 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso191672pjb.1;
        Tue, 11 Jan 2022 09:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7d4f9OeHE1AUWS6VvZSAGVP+TjEkekjrAdEq9W1CT2E=;
        b=LtkofzxD8TdZdP1aO140lbC8WPCnOpwojXcvO2mF652G/dUReimGiS1A8lxeLWYeuc
         xreoO/umV7fcww04Au79l7Tgczx7oFMt9jbgxbJDOHoUUOk6TeiyJDcqzPPX15QnDJhG
         Icarugm+ycoyN2G6XHMgkUclx4/BPA4qVJy4u/ICwz7tePpLVJLfXb0aZrZtz1MUoy9x
         wxcoHtjVPAd6Bio8X0xK4kdbaSa92d4KHV+6OELn1y2pS0vHFHI8qac3Nlmyt99MwPVF
         AzUp7RiblUYkcB6mB7m5mpOrxfTlwo56vTJ6Ck0eFaf3qTH2s6MrcW+G13KXZ+cmMw4Q
         640g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7d4f9OeHE1AUWS6VvZSAGVP+TjEkekjrAdEq9W1CT2E=;
        b=NItp4sSpjmcP5N687W2wGrVVhm3fWF4Xj/mVQjxGXiRCXadXnCwSvU+EhhMcZ9mY5Q
         X6mn/jgAR43ZJIPntJC/Bxo1//giDRD8czXNAGJRuF+bfo/jyDrveIzKwpFfjbXQ+U3X
         qhEfMv45goTWl2GLFnbQ+jAFc1uD/W0IGCxGG4za5D6Ruq75RddFiwnKiDpihMohUf4B
         68Uz96NXD9VDqirBVWd/eI5PVNaGVOOjwvJaWf5rUV4yUzFfZxiG1caRdxYdyoRMdHYG
         UcjrC5SBeHygaNfiHZl+uAVbztEt6tn4z80irOX8vRzEyf5By4H+cMNN/tkdk6P7BL0u
         RQRw==
X-Gm-Message-State: AOAM5331iVMkyHLgbPz3LC8dg8F/8B6BtEzojxTlEC43wyPq5U08X4uC
        bz/by3w9pRC4FxqGIEKKFb+8gir5zqcer/JFTt0=
X-Google-Smtp-Source: ABdhPJxFxc6D7uid0EDFruT8ggqzhgP0nSd8Gassl1xLfHh3m98dx/PYKvteYP8uz0sXDUXmDuWPMrGAmdt3mgJ+wak=
X-Received: by 2002:a05:6a00:1582:b0:4bb:4bc8:7ecd with SMTP id
 u2-20020a056a00158200b004bb4bc87ecdmr5567919pfk.46.1641923379584; Tue, 11 Jan
 2022 09:49:39 -0800 (PST)
MIME-Version: 1.0
References: <20220107221115.326171-1-toke@redhat.com> <CAADnVQLBDwUEcf63Jd2ohe0k5xKAcFaUmPL6tC-h937pSTzcCg@mail.gmail.com>
In-Reply-To: <CAADnVQLBDwUEcf63Jd2ohe0k5xKAcFaUmPL6tC-h937pSTzcCg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 11 Jan 2022 09:49:28 -0800
Message-ID: <CAADnVQ+eK+cmOE7OcKjV1O9J-x0=Hb_5yM61KeBXeWWn2TWquw@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/3] xdp: check prog type before updating BPF link
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        syzbot <syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 8, 2022 at 11:37 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jan 7, 2022 at 2:11 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
> >
> > The bpf_xdp_link_update() function didn't check the program type before
> > updating the program, which made it possible to install any program typ=
e as
> > an XDP program, which is obviously not good. Syzbot managed to trigger =
this
> > by swapping in an LWT program on the XDP hook which would crash in a he=
lper
> > call.
> >
> > Fix this by adding a check and bailing out if the types don't match.
> >
> > Fixes: 026a4c28e1db ("bpf, xdp: Implement LINK_UPDATE for BPF XDP link"=
)
> > Reported-by: syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Thanks a lot for the quick fix!
> The merge window is about to begin.
> We will land it as soon as possible when bpf tree will be ready
> to accept fixes.

Applied to bpf tree.
