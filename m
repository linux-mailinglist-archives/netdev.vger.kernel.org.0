Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAC2E28C3
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 05:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403962AbfJXDXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 23:23:14 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39933 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390629AbfJXDXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 23:23:14 -0400
Received: by mail-lj1-f194.google.com with SMTP id y3so23323161ljj.6;
        Wed, 23 Oct 2019 20:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jTT71CQ2N+N/DzoTfao5n7oljlZcwohU5PS8pyZCLfQ=;
        b=m1a/gRrAYmj9FVRpT5bIUoo7VjhRp/WEjR+6NbVSBlNmhwJr/MQRA9LyFAbJ3zy6Jt
         XDL/ijR9YDtchalOxx8PmFF7a78CFUrhG0dAKSw7KSPalVi+JyVtq+KvQDcEE+kRwzS3
         0HVc8wiGPywDbsNqX7nFapk4wFa9PkmGrUJrUdfEqCi1mEV3JXjPjd7smDJRsePrUbmM
         P5EmO5y/TVKubZ9hzLFGuyLw/PKkOAZ0wtkORJgytUezdKzjR3KtiJGvBimPiAmkZXzC
         DtYEppvc+kZQEqjCoYUJzCuzFR8pXE+5ARTjHX3ygmxb4RTE1EyYNwY1C4oP72cYgsBY
         63bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jTT71CQ2N+N/DzoTfao5n7oljlZcwohU5PS8pyZCLfQ=;
        b=CdJwPucRPOYk/TbnCatAGTSese4P4vuyv376nnCzczII7TTP8zzmoHFYhi/1+ikr6y
         Bl/dJOzfX6d4HZZ0VDmFIiVt+8+ETsIriRyRJTDxhBe7KTFB1zeYzNGutx4kBewRVDHK
         1CkzBISV7mxaQytgxw9PLQZIOVgX3FSNDQTUP595AlagUeoh/wDAgox66ZxszOuNQi0g
         mXbxF++qtChQrRd4GFNo7LqmOJt4JFj9QowN005rIhY+8FEA0+EIZAqhgir7tnd9EY5C
         2OpAFl+60vH/H8GrNF1XlcfW9cxRpEIMPnb9MAxbBvdF0IasCMqtXAK8i+MabS0NIX3H
         9AZA==
X-Gm-Message-State: APjAAAVnzcqueT4oXV6Oq1A62Aewkrcy4u6dgsqGyz1g9yxKmHprOmbH
        +PjG2W3RWRsuSMmGTBGtkqyqfz4v84vS8/GiCL0=
X-Google-Smtp-Source: APXvYqx9SGDLByzE9h/BrIUW/ljf4ey7a/Ii2OuIzrPercn2xiuZ2lVE5t5YABxPWApjzgFagXSyTRTUMXBJG5Jumm8=
X-Received: by 2002:a2e:9cc9:: with SMTP id g9mr23780716ljj.188.1571887389907;
 Wed, 23 Oct 2019 20:23:09 -0700 (PDT)
MIME-Version: 1.0
References: <1571645818-16244-1-git-send-email-magnus.karlsson@intel.com> <B551C016-76AE-46D3-B2F5-15AFF9073735@gmail.com>
In-Reply-To: <B551C016-76AE-46D3-B2F5-15AFF9073735@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 23 Oct 2019 20:22:58 -0700
Message-ID: <CAADnVQ+t6ThJM_hfm9JvCApXdYfJLFNGdDd0ykBf-czvHeDAGQ@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix registration of Rx-only sockets
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        kal.conley@dectris.com, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 4:03 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On 21 Oct 2019, at 1:16, Magnus Karlsson wrote:
>
> > Having Rx-only AF_XDP sockets can potentially lead to a crash in the
> > system by a NULL pointer dereference in xsk_umem_consume_tx(). This
> > function iterates through a list of all sockets tied to a umem and
> > checks if there are any packets to send on the Tx ring. Rx-only
> > sockets do not have a Tx ring, so this will cause a NULL pointer
> > dereference. This will happen if you have registered one or more
> > Rx-only sockets to a umem and the driver is checking the Tx ring even
> > on Rx, or if the XDP_SHARED_UMEM mode is used and there is a mix of
> > Rx-only and other sockets tied to the same umem.
> >
> > Fixed by only putting sockets with a Tx component on the list that
> > xsk_umem_consume_tx() iterates over.
>
> A future improvement might be renaming umem->xsk_list to umem->xsk_tx_list
> or similar, in order to make it clear that the list is only used on the
> TX path.
>
> >
> > Fixes: ac98d8aab61b ("xsk: wire upp Tx zero-copy functions")
> > Reported-by: Kal Cutter Conley <kal.conley@dectris.com>
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Applied. Thanks
