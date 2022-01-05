Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108D0485C75
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 00:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245542AbiAEXvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 18:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245543AbiAEXut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 18:50:49 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE7CC061201;
        Wed,  5 Jan 2022 15:50:47 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id m4so826436ilf.0;
        Wed, 05 Jan 2022 15:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b40oZck9H7qomq3L3iW45P12leZXCNdZnJUoXWTUtDI=;
        b=D0Nph9f3ON/oS6OyrzyNnXUXJMYwB1fb6bEMgaI0UeStzQZZGs5tqXh71srdOhccKu
         eNQRl11cAqwWXJ6kY7XOVRNv7AkJ5L2MOKzAoLLD1KltH1lVFqAJf6WCGK903lSCdcSR
         Ip8Bb8li010TLxYRf4rmqf7vIg2fDOkv/X+JcNLoykZDLlKZEbQnEpMfjo8Vaxe5UX+/
         2BmlFhid5IvX0kp+/0KimoYgN+peQhOEtIej2b43dgzdKJSyjVKfSakKkbrPNUOpatRM
         D+x5JqIeZcZH2hHSAwEGts3I1zBPjH1LDy1EBVzuMShPncbVEOyVu1ORoh/UeVbdGBow
         Vz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b40oZck9H7qomq3L3iW45P12leZXCNdZnJUoXWTUtDI=;
        b=g0GdLnlS3Z4Tu/OTZhKwj0tALZhvaL69PL4qesko2eWH9IaYBhCVUAZZ9yRZaKfi4b
         Nidn33Tz3aDFTFGSS4g2gvYmLqnLSpb9oZ5GVaoXGDTpgFmIO41+cL4mMGExOTAZoUo0
         pVySx+Ydf5uIUCeEtqsNM9m6AcPrmjrIaGoZbooRCVQfIMPcydGkj10au7C5jg4tYX56
         hEvKbsBsnO/zITWOxRVKQPpPnFePsXEGnxrnfBvVPKp5GU17iiQ/9dKSmrutAZvdwGTz
         m2cc4eWtwF8BKwK33DcY6lgXuTsmHxXCCLTk752cZKb3r9ORbCBAs80zVuWyTETXvWMv
         yJgQ==
X-Gm-Message-State: AOAM530Vib34Bcyk2Vlpdo5PB4o9Pw0AFcIUTLrNMO4/ksFVkCyKAW++
        nWQ+gj8WDEGQCRx9QpxeKefDE2kKlZMW0knAVrA=
X-Google-Smtp-Source: ABdhPJwX7uFKLRClqZ9DEZpjMBZHaihfKSdlLd8O8g+VR4Mrr4vMlrxuDdanS1CocbpM+sgd7sUFFIL+jVx2b3aUzAY=
X-Received: by 2002:a05:6e02:1c01:: with SMTP id l1mr27427925ilh.239.1641426647383;
 Wed, 05 Jan 2022 15:50:47 -0800 (PST)
MIME-Version: 1.0
References: <ADAFDE41-E3FC-4D96-A8D8-1DAEC56211E9@gmail.com>
In-Reply-To: <ADAFDE41-E3FC-4D96-A8D8-1DAEC56211E9@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Jan 2022 15:50:36 -0800
Message-ID: <CAEf4BzY9=Eqs7QnSj0s9uf0_DySO=7ySYXsFzPg2uHKXTbScjg@mail.gmail.com>
Subject: Re: [Resource Leak] Missing closing files in tools/bpf/bpf_asm.c
To:     Ryan Cai <ycaibb@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 7:40 PM Ryan Cai <ycaibb@gmail.com> wrote:
>
> Dear Kernel maintainers,
>               1. In tools/bpf/bpf_asm.c, the file opened at Line 40 may not closed within the function?
>               Location: https://github.com/torvalds/linux/blob/5bfc75d92efd494db37f5c4c173d3639d4772966/tools/bpf/bpf_asm.c#L40-L49
>
>               Should it be a bug? I can send patches for these.

file will be closed by the kernel on exit, but it would be better to
close it explicitly, so please feel free to send a fix

>
> Best,
> Ryan
>
>
