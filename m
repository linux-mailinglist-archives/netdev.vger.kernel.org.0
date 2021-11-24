Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DDA45CF72
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 22:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243780AbhKXVvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 16:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242955AbhKXVvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 16:51:31 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D49FC061574;
        Wed, 24 Nov 2021 13:48:21 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id q64so5345650qkd.5;
        Wed, 24 Nov 2021 13:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J5TxSWZqv1/aQ9N8ZF+t0XKluxfAnJgla0A/LvTumhg=;
        b=dtD8j4rCQYYWUq2J6H+PzbIytag3UxPV+3uvx33aJrgi45YcrffXgOOF+Wnnj7Rfus
         /b0sd50UTvV+LchAv0sGimV0nw3Te+951Vzf7gnIv0j5zpifhSNcyYLs7z9h0/5Mg7pv
         +whHNky3he3BLOtwD1GMSb6wo0Zei8il5ZcGcxPjfrE+7nS9hzAvSB9wnzaCMuRebHv6
         3PkwmgXy+8x612jMBbY8+LcRiHQMVWmsDCFFJzeVi1t1e13jQOqqMBbLpj1CBL1M6XBz
         1Fph5Tm2g5kMjjkpDSHpQatXtAQJxIBwzLBY/THH2uE039NCpjv3vYfd4lj6K9TPsScj
         UaWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J5TxSWZqv1/aQ9N8ZF+t0XKluxfAnJgla0A/LvTumhg=;
        b=mdMccBFDDacrjRjawBYEFjGhLkw7f9/614ygEN1uHJQG1kcZ8zbTiv/sOO2IfIOkJH
         vNXZzxI6fe1ybtNOFMUXMFa8giv7gCrSpXqvdocLxFDLqejIoHOAikxynCi24QwYsdnK
         uy0q3n42K1Tx3JYPIdAJ+I4S3EXsIjNZyAw+TPsIYLTyBH4YY0jPcii/F5EGcKB3UzFt
         0vSoJ2zYFwjrGXgFakBDPTAcGfJEyIZYRTz1KVJaiG8GF4GY3AYJqRio43qYN9vIafe1
         YThprQCsJzcrChdNhVc9aLuky1WeKssk937CDMaLFTgpFJPmdOvJS4WkD8TlbyI2Zi76
         4Fww==
X-Gm-Message-State: AOAM532tvPJke2ne4Ma0eShfO4i1aRFD4LkMBcSLJC8twqJhWm3WecAM
        WtiNQ4eYP8e+hcQ1jfaf/0V0+UjKRcIMAN/CKXw=
X-Google-Smtp-Source: ABdhPJzVGneSjMaQmLcSNESZZdZUOK0VvxVBvEmT9c3RQfV/m88KtVO6Nwc8T3XRvB0wuAsHk9G0B7j5OqWOZnQIziw=
X-Received: by 2002:a25:42c1:: with SMTP id p184mr239799yba.433.1637790500802;
 Wed, 24 Nov 2021 13:48:20 -0800 (PST)
MIME-Version: 1.0
References: <20211118112455.475349-1-jolsa@kernel.org> <20211118112455.475349-9-jolsa@kernel.org>
In-Reply-To: <20211118112455.475349-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Nov 2021 13:48:09 -0800
Message-ID: <CAEf4BzbZZLedE+Xbsu5VewtJThEzJZYiEn4WMQ-AjfiGeTAAAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/29] bpf: Keep active attached trampoline in bpf_prog
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 3:25 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Keeping active attached trampoline in bpf_prog so it can be used
> in following changes to account for multiple functions attachments
> in program.
>
> As EXT programs are not going to be supported in multiple functions
> attachment for now, I'm keeping them stored in link.

can the same EXT program be attached twice? If not, why can't you just
use the same prog->aux->trampoline instead of the if/else everywhere?

>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h  |  1 +
>  kernel/bpf/syscall.c | 34 +++++++++++++++++++++++++++++-----
>  2 files changed, 30 insertions(+), 5 deletions(-)
>
