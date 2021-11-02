Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60651442A55
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 10:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhKBJ15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 05:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKBJ14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 05:27:56 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB22DC061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 02:25:21 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id b3so13025139uam.1
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 02:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bKCG/LFDj+4qsdT7nWY5D/doheuBylJpyUPgqkYuXWc=;
        b=GTE8kbQMAjMh6NHSeOps4yMX1nOZWv9N2mQ4w5/2N6wzHuI5dckZZxAdKeON99IRH1
         VetIj57Fi97O9awBY0790HpX3wXxGYqNk4zocNFIcL7Fcpcs1YCT9FpRvccEEQJ5Ue1G
         jtZb4HRxPXSrbKqLsM1B70mKj4vkpqirJ/l7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bKCG/LFDj+4qsdT7nWY5D/doheuBylJpyUPgqkYuXWc=;
        b=L+nY8PFXTvMV74WL1CdOGZA0+D4lU9sJbVsG8LRO5Gw5K9gDPgVSACWZt02NlvwjiW
         iFdCZmP3b5JXAYWk/N6kv3BCjJvoyLI7qYkyLCBGsQahyb5FDqUbLBF35K7vpGhREtDZ
         jb2SD62ErIxm6GA4Q2Snts7s5iBaHHYjSlf9HnyPpeci8tbtozB1hkDwnJaSxS0tr0+G
         78LjQIM9SgolGsiIczOmAeTJZ05pfWOvCKXhqFopApRGLp2orctStS0oAXMd+O9ltDOX
         vcFjqlfOz+w6+r3OW+fgvbkELMqUm3/T8bYzTmoD3xbJKCz9C+hfNPiTBKSmIosgLyM6
         GZPQ==
X-Gm-Message-State: AOAM532gO2xBW6nH1oKTcT/LQZadJB4M2M8BmMGGZ4xLLGfE7jhMvqSY
        1InzqnAi0Tl8+ek35p7Z0Z53JYaGGadyAhGawwzSzQ==
X-Google-Smtp-Source: ABdhPJz0m3W1JfSC2scZYfM2TAN0orTLWIwHqpB5Zb9llP9yVvU/GJEjmlfRYDw6X0rPl1IeSQxBW+EqIg17ID4lO60=
X-Received: by 2002:a9f:234a:: with SMTP id 68mr35529397uae.13.1635845121065;
 Tue, 02 Nov 2021 02:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211028094724.59043-1-lmb@cloudflare.com> <20211028094724.59043-3-lmb@cloudflare.com>
In-Reply-To: <20211028094724.59043-3-lmb@cloudflare.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 2 Nov 2021 10:25:10 +0100
Message-ID: <CAJfpegvPrQBnYO3XNcCHODBBCXm6uH73zOWXs+sfn=3LQmMyww@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/4] libfs: support RENAME_EXCHANGE in simple_rename()
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 at 11:48, Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Allow atomic exchange via RENAME_EXCHANGE when using simple_rename.
> This affects binderfs, ramfs, hubetlbfs and bpffs.

Ramfs and hugetlbfs are generic enough; those seem safe.

Binderfs: I have no idea what this does; binderfs_rename() should
probably error out on RENAME_EXCHANGE for now, or an explicit ack from
the maintainers.

Bpffs is your baby...

Thanks,
Miklos
