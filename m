Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B721C1FD314
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgFQRDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgFQRDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:03:17 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A25C06174E;
        Wed, 17 Jun 2020 10:03:16 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id 9so3769198ljv.5;
        Wed, 17 Jun 2020 10:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mtctRQxhH8ycAUAVu8GEW0mMFQIgVXaqkRpoRHlDMrE=;
        b=gCUUBfrefOq4JRPNQOwvFVQPeB/MCisfJBbriZ1aZDCvYyekQ8hTnDCoQRsIylBCoK
         pbzvIFFvv3InDi29Brp7hmcV4bcIKoUfOFMGPENCJYS10gCvbzp5xVXCbqxO5ISGQf0n
         /0K2pnG8xnL7WhLPtyuXDS4szq8WPbwWIHiDgd9xMVKItMtLkqMgD/0MjPP8tJce+pUf
         YzY11Cz2hw9Br9Q2l8SkPnm6AsNS3wlJa/mOk4Y7pPnnqBmd7VEy86unoG0tRscjDKqz
         B9Mp6NDVeqrlIBJltYc8+nhjW5aXoA92WoAqjQ4E4mapenlYQVO8KSefRi9WKq6h2JYR
         8FYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mtctRQxhH8ycAUAVu8GEW0mMFQIgVXaqkRpoRHlDMrE=;
        b=FZFbczz1qvjRM0qvzpO9PK6VFTn5q0f2C1XjUBz3PqadrqWF+SkkHNsxvpJnzcaHo2
         RrgM+11DCrfEeXqc9j2tzJfmf8IrX56Jyp2s5JJHrXP64Ak2Kyxm498cXQILFcgZbicu
         +hE6f48dpearFETFNhEMuonW+kxhWxHt2IO0lmlfv32ct5QsnLjcJRGFdHn6qIdUB2FT
         IUubCOOIGudbXCg489NJzamSsGys2BCCsc00YX77LoFpR0kwyUTpLhvfdisk4wq0ZQLa
         b9WH7ttI6HXHGdVf8ivcgwOoeox5u4hHB89OSKkBoThESSbTLBtrYEY4AJux4plhbVJn
         eurQ==
X-Gm-Message-State: AOAM5315Q2avdkoIwa7TYk3alpIEdqo6HI/T6W8ct5I+SM9SpvtOIEsj
        4V+N5yjRKgFiKm3PPQgQOl/LT6Oq/HMqVtivmrlJ4g==
X-Google-Smtp-Source: ABdhPJwaFFuBg+Pm5fxWk7QBjaGHpojRrtfTWQna9a6pDcSFN7U80WpY2bxYyjeNsS9HsfDJvGvA0T3Q37wEes/TY1A=
X-Received: by 2002:a2e:2f07:: with SMTP id v7mr101173ljv.51.1592413395101;
 Wed, 17 Jun 2020 10:03:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200616142829.114173-1-toke@redhat.com> <5ee9b2f6a7be2_1d4a2af9b18625c480@john-XPS-13-9370.notmuch>
In-Reply-To: <5ee9b2f6a7be2_1d4a2af9b18625c480@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 17 Jun 2020 10:03:03 -0700
Message-ID: <CAADnVQK5eSxpgc=-SoQgiQqQJfeYcAwho7AAZvdQBCuetK0w_A@mail.gmail.com>
Subject: Re: [PATCH bpf] devmap: use bpf_map_area_alloc() for allocating hash buckets
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Xiumei Mu <xmu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 11:07 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Syzkaller discovered that creating a hash of type devmap_hash with a la=
rge
> > number of entries can hit the memory allocator limit for allocating
> > contiguous memory regions. There's really no reason to use kmalloc_arra=
y()
> > directly in the devmap code, so just switch it to the existing
> > bpf_map_area_alloc() function that is used elsewhere.
> >
> > Reported-by: Xiumei Mu <xmu@redhat.com>
> > Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devi=
ces by hashed index")
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---
> >  kernel/bpf/devmap.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied. Thanks
