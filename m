Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3033D34F96D
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhCaHGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233939AbhCaHGL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 03:06:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B81E7619CF;
        Wed, 31 Mar 2021 07:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617174370;
        bh=GFNu/dhI0J9kZ4WlROA/yJNcmBXvrZW9pxZC4VNia80=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qUui+xut8hg6f9wsWSBu880h4hFEfvyPAwPVrNpwnDpW/DqkY2pRN4wBRcbRX4X3g
         M+kO1d+Uv7mL5IxoReSjatf5bphOozwwRkFxNH8o6p6dlRCHOH303WhZGaoKk33vlH
         suyNfxgtG1wHa2pbxsoptbHKGbQrOnckqcNvwGFZHbvxIiFPeDzurYHz1hQKqvbT8E
         jk3+1cD5w6VswPfCCXqqSMt7Y7TbgQxj3suzTFiO3zDC2dpR6mhTc4YFhG/Lu78v6I
         t5jZ6Jq/PibMFJWZtGic816QFMbNvjsml4AJ/vWm+GRAXAvri3fa7IH7C3ajL0O6D+
         dfWFtrwRwvriw==
Received: by mail-wr1-f42.google.com with SMTP id j7so18547041wrd.1;
        Wed, 31 Mar 2021 00:06:09 -0700 (PDT)
X-Gm-Message-State: AOAM530lDZACSD2JFOeTyGtWrmth3rbuI926yok576g2hi8sS/ksv1v2
        y8pojzMoDynYHq6aqN7iFj6+iVZTNkSVGLwinfg=
X-Google-Smtp-Source: ABdhPJxMjRwsTlV9yQLKdib3ebiZrPxtBCuOUuTZnmHXieRvf7BIo9N4IeeP/U55e03M1I5BLMJR9ryipEyfOgo2t3s=
X-Received: by 2002:a5d:591a:: with SMTP id v26mr1872032wrd.172.1617174368379;
 Wed, 31 Mar 2021 00:06:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210331061218.1647-1-ciara.loftus@intel.com>
In-Reply-To: <20210331061218.1647-1-ciara.loftus@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Date:   Wed, 31 Mar 2021 09:05:56 +0200
X-Gmail-Original-Message-ID: <CAJ+HfNjsbAA0v48CLOgEw0bj4prsg5ZzP3=iU=QGTFWrAbOAng@mail.gmail.com>
Message-ID: <CAJ+HfNjsbAA0v48CLOgEw0bj4prsg5ZzP3=iU=QGTFWrAbOAng@mail.gmail.com>
Subject: Re: [PATCH v4 bpf 0/3] AF_XDP Socket Creation Fixes
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Mar 2021 at 08:43, Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> This series fixes some issues around socket creation for AF_XDP.
>
> Patch 1 fixes a potential NULL pointer dereference in
> xsk_socket__create_shared.
>
> Patch 2 ensures that the umem passed to xsk_socket__create(_shared)
> remains unchanged in event of failure.
>
> Patch 3 makes it possible for xsk_socket__create(_shared) to
> succeed even if the rx and tx XDP rings have already been set up by
> introducing a new fields to struct xsk_umem which represent the ring
> setup status for the xsk which shares the fd with the umem.
>
> v3->v4:
> * Reduced nesting in xsk_put_ctx as suggested by Alexei.
> * Use bools instead of a u8 and flags to represent the
>   ring setup status as suggested by Bj=C3=B6rn.
>

Thanks, Ciara! LGTM!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>


> v2->v3:
> * Instead of ignoring the return values of the setsockopt calls, introduc=
e
>   a new flag to determine whether or not to call them based on the ring
>   setup status as suggested by Alexei.
>
> v1->v2:
> * Simplified restoring the _save pointers as suggested by Magnus.
> * Fixed the condition which determines whether to unmap umem rings
>  when socket create fails.
>
> This series applies on commit 861de02e5f3f2a104eecc5af1d248cb7bf8c5f75
>
> Ciara Loftus (3):
>   libbpf: ensure umem pointer is non-NULL before dereferencing
>   libbpf: restore umem state after socket create failure
>   libbpf: only create rx and tx XDP rings when necessary
>
>  tools/lib/bpf/xsk.c | 57 +++++++++++++++++++++++++++++----------------
>  1 file changed, 37 insertions(+), 20 deletions(-)
>
> --
> 2.17.1
>
