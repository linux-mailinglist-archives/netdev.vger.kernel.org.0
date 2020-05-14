Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A041D3DC8
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgENTm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727118AbgENTm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:42:56 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE5DC061A0C;
        Thu, 14 May 2020 12:42:56 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id c21so3680716lfb.3;
        Thu, 14 May 2020 12:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=df7/N//m7Nu/6u8ySTdlTgJ4VZrs2TxfUIK2y2Yeyag=;
        b=A7ooXWTgIzKQvu/CnZ/3r517AiLFG0KB5se32kJbOYZ0Tkb25z51rqx72BkavzBGeC
         leakGnjqbHI9mRKDvN7XZxtnqoSjQ2x4EXJnJP4F5A6wc2OWtuuPOVbbZW/T+Lhk1gbQ
         OEMY4dSM9vCtdHGIXoJUUoJIxo/GAo1jtuku6nYuOla5Rezfd1uWBf8H9SeKQvSoFSF2
         XElT1US1QCtICDB9XdaPZPf2I5VQJSB1OkwlakFqRYt6EjhfqAzQVC3MAWJ1T6dTjYfN
         VX2HsUHHpf+x/phZ444aN6dYhXZrSavqhr5pZN/JmlnXYdelVUS2aoancKw+baf+lwz1
         IMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=df7/N//m7Nu/6u8ySTdlTgJ4VZrs2TxfUIK2y2Yeyag=;
        b=QHoKytCfGStTyjyQsX6HGiBAcTBm2vt1KUN4W0lyaO8fGy/T/Oq22ptCl4faVcRKGa
         B/4WdCoY7wDYOH8uoxqXrJZVNwuUIKWvAbFnjSyGiGVkU7YdaWQQ3JfaCHhejmBJsb4E
         wUxY8LOd7XO2/mH14FnvkxN6vpp3VU+xzXr4svKbi2VEZI+Y9pDK4GjPih5fmdqRqBEk
         +QOCWKcPAp3nnlaXoOxYXOA+VL186EQwdamAsAQoDXxwtxJzP2IIGo9iK6b3EJOMuUNM
         K7tUAWwdba9cDeBskCYWyBirtttNOg8Rhk6ao31CMNzcBvZS3n1mbDrgoVw9qGXKdH9Y
         U2PQ==
X-Gm-Message-State: AOAM5305hNTyJQTsBgeLZ5VAWlKvBUQIdynvKxJFECHAAxMx1W3X2LWt
        5l39Ri3dNGQeh5F+8JgcKcIT4Y2vr+0SqFWGTpI=
X-Google-Smtp-Source: ABdhPJwUHKZXRgqFYHl2Cf92zpXngu4OQoPbXPecCHATPNKUQorSpmVHSzV6FAH3/vD6aHBIUEBjHh2u6LowD4JVbuE=
X-Received: by 2002:ac2:5999:: with SMTP id w25mr4261622lfn.196.1589485374757;
 Thu, 14 May 2020 12:42:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200512235925.3817805-1-andriin@fb.com> <832dc9d7-2a38-9728-a845-2f7f7e34bb74@fb.com>
In-Reply-To: <832dc9d7-2a38-9728-a845-2f7f7e34bb74@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 May 2020 12:42:43 -0700
Message-ID: <CAADnVQ+iGHrCmWK_9hFF5N6eVF_ASD6dSoLykDRXJRF5z9fi4g@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix bug in mmap() implementation for BPF array map
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 8:21 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/12/20 4:59 PM, Andrii Nakryiko wrote:
> > mmap() subsystem allows user-space application to memory-map region with
> > initial page offset. This wasn't taken into account in initial implementation
> > of BPF array memory-mapping. This would result in wrong pages, not taking into
> > account requested page shift, being memory-mmaped into user-space. This patch
> > fixes this gap and adds a test for such scenario.
> >
> > Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
