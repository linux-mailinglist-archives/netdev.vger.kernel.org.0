Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220222777E4
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 19:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgIXRes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 13:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgIXRer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 13:34:47 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F09C0613CE;
        Thu, 24 Sep 2020 10:34:47 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u4so76384ljd.10;
        Thu, 24 Sep 2020 10:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WBocD17QKfLE5dlBNSQOv/R7NHFqDK4TJN8Edjd8wFY=;
        b=SVmq4dFTMANF5321odKDQ86LQ3q3szNNANs590uuic9ySPG5PmJnu/rdR7fu/nVT+K
         RQl/SqxMO9hpb3Qwn0pKqEkId/1XyeYD7BE75YmXZcPUZmEvr3QqvwB6f5+PjZdVypM4
         NC0wPD1gl6tDjVY7Ro9KDWmL7Nyvan4tdZD+RpUZzfz1vbLCpnnmiJsHyWC8rtd6vqan
         bjgURu1ZEojeL+cnZraMepfuOfnwMRWc2yUcuFTWsq0KAba8x/QAXn27ffwlgeBQ4dbb
         KjwPpRb5RW4B7K1KofC9lCKLqopnukUySZ7YsoBDUlpfFnJVofCmzn5lVF2JQV76A0yf
         YUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WBocD17QKfLE5dlBNSQOv/R7NHFqDK4TJN8Edjd8wFY=;
        b=L03DDwwUr+yKlEOPb/rB6MGWBXRnr+77el1bfW4MoPp7KINuUbetaDnX6PE7b8EabW
         w7Q0mYaAd5raD4EO7E4WnP6cQoilzmrtn6Ty5ilMHlJnhiKBYacS2I9PDkJfaHkW4Xx5
         aTCrHFgGnxhBHSSxp5g/UR/7f0wF8rcy6khIIjI+uTEo+d2SlgIQibIm70XrJqC1mvtK
         qzKDh2QFL6RnYkEcK97cdNEwSmCNpf42n/2lQyCkmR9gK8Axl9r8BeFUzoVXsTpaD2+T
         Io5RyHrgooATsxXQbWzVkkc/tleyzqYl0w/Pi372oEroQV3CXzCOSudkkXrf8ULag8cb
         2FxA==
X-Gm-Message-State: AOAM531SflslUuXAM6qr+BmaoXXj+onGowWSGGm2kCXrvPOKaYZ6fsC7
        +eUSInBVmTP0taMt89KDIMRor8gcG4kfC59Uu477ure2
X-Google-Smtp-Source: ABdhPJx8ZXM6TS8qeVSXC7jpEHpjFZOkKpS1osc/P0ro17uLaBxpepzzB8Y3oBH2JZuaAiO3DhDZjiFJ55aMUpMeVxM=
X-Received: by 2002:a05:651c:cb:: with SMTP id 11mr34052ljr.2.1600968885986;
 Thu, 24 Sep 2020 10:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200924171705.3803628-1-andriin@fb.com>
In-Reply-To: <20200924171705.3803628-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 24 Sep 2020 10:34:33 -0700
Message-ID: <CAADnVQLtxtMOsuBvt0U_UTLVuX-X__AWuih8t-CuGu67GbZJ_w@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix XDP program load regression for old kernels
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Nikita Shirokov <tehnerd@tehnerd.com>,
        Udip Pant <udippant@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 10:18 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Fix regression in libbpf, introduced by XDP link change, which causes XDP
> programs to fail to be loaded into kernel due to specified BPF_XDP
> expected_attach_type. While kernel doesn't enforce expected_attach_type for
> BPF_PROG_TYPE_XDP, some old kernels already support XDP program, but they
> don't yet recognize expected_attach_type field in bpf_attr, so setting it to
> non-zero value causes program load to fail.
>
> Luckily, libbpf already has a mechanism to deal with such cases, so just make
> expected_attach_type optional for XDP programs.
>
> Reported-by: Nikita Shirokov <tehnerd@tehnerd.com>
> Reported-by: Udip Pant <udippant@fb.com>
> Fixes: dc8698cac7aa ("libbpf: Add support for BPF XDP link")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks

Looks like libbpf CI needs to add a few old kernels.
