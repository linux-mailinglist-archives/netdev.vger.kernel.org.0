Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CDB4423BC
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 00:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbhKAXJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 19:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbhKAXJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 19:09:11 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43164C061714;
        Mon,  1 Nov 2021 16:06:37 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id k2so3191181pff.11;
        Mon, 01 Nov 2021 16:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CBrwhi+266SNmocQtjUjpu7RuIG5JaXVmEioobTq/Q0=;
        b=e5ir3JlopUsdg02mbWzky0WMrnHm94v4jLAMXJvPkjJmUq4+0sSGRAe248xzJ1J1Ia
         uS3Lx60LMEgQhJwOQMD+sewVPHSrJFb6/kwWgvBET4Bb1aXocLK6tmyurVBLsto+gDLD
         Zt4A+o3+aqa3460LnnysF6C6cnehnjVrxawv0R2yIgnzV0p2KiF4Z6Z1tsbN+rgqtru4
         B9IgOUquV7HnWf4ngeN5b+OM015/knesMQP1atrPss7fYK4Pg6GZ3pPRRvfh/f5gdTpv
         Gx/0svQpdigSSpetR2egJnxxXlP90wimBgDZcpeh/AcM2CdjsTBQ8ku17eHEbRwD+7W3
         q6EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CBrwhi+266SNmocQtjUjpu7RuIG5JaXVmEioobTq/Q0=;
        b=CEt8uBH2sK/VVm07eLbaffMCa+UPGiRoabf/rW2rGVn1dDWbIOQSPA0uDoJ9yZw5K7
         YMCP9HX6e+nji9a/bec2cr0SkrUUFvtaStHYVcy28ae9ToXoZtDBj+RzPGpbG9NjJhoX
         eoKIQL/bOiQtlfQ0T+gdYaW7SkGL/pWCgYtdSJjJinkMsw+z6Z5x+POGGaNtVO6sWTzo
         fl4xP9v5lZAXl/q9P+apw6hJ3/xrlzZwEyKhHNKm0/ViWx/yZ+c2YP8SmuGKU+U1L3ax
         O07xwpQAwcCg9+XvQn8l7zgxfpsbUPRu/FTSEEiw3102/bRGhuHCuD/bMX87y8rw/RAj
         cBiA==
X-Gm-Message-State: AOAM5324MRJlvF5HpKZr99IS/weFi8EW0WoNt5XRNeuKYG+zTJ18wIyo
        H66kzcT+dpj/LvnrtrKft7KW9d38SXpLiH7P3iU=
X-Google-Smtp-Source: ABdhPJxZ398rdaxZrlVdJponkRkzJIK68Z6lwffaUd4NW6DsMl4CLGNvzsqZoOBoILzTYCS6brjmzPC5f8TGzKSruvE=
X-Received: by 2002:a62:644b:0:b0:480:e085:c2f0 with SMTP id
 y72-20020a62644b000000b00480e085c2f0mr16125378pfb.77.1635807996798; Mon, 01
 Nov 2021 16:06:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211101222153.78759-1-alexei.starovoitov@gmail.com>
 <20211101222153.78759-2-alexei.starovoitov@gmail.com> <87ea129f-a861-5684-8071-cd3390375d3d@fb.com>
In-Reply-To: <87ea129f-a861-5684-8071-cd3390375d3d@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Nov 2021 16:06:25 -0700
Message-ID: <CAADnVQLYf-tqV7efxgeHQ8K_130r_v_8Zft2wBVBZn0EYOzm6A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: Fix propagation of signed bounds
 from 64-bit min/max into 32-bit.
To:     Yonghong Song <yhs@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 4:03 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/1/21 3:21 PM, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Similar to unsigned bounds propagation fix signed bounds.
> > The 'Fixes' tag is a hint. There is no security bug here.
> > The verifier was too conservative.
> >
> > Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>
> The change looks good. Should a new test_verifier test be added
> to exercise the new change?

I think manually string comparing output the way VERBOSE_ACCEPT is doing
is an overkill here.
The real test case in .c will take some time to craft.
