Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8ECCF10C
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 05:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbfJHDI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 23:08:29 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33820 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbfJHDI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 23:08:29 -0400
Received: by mail-qt1-f196.google.com with SMTP id 3so22849989qta.1;
        Mon, 07 Oct 2019 20:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ry2rZ2lF67ewBNaK+hq9OuhPhxN04Li8uwv9PYhdlqs=;
        b=OUuGsB+1hqdhdlcyb+Fnhru6JIYbl+gdgS7VLEFL3+w7MoRwNJNHDJnHStLXzWAghj
         pB2rGClff+zgJzJuNvQ0iQDghs2mwlL3Isr4RMRHdz+kUXRZevZmpcz7dUWhwU+UPfaa
         kjk5kBPRX3s6FWNZFa7hiPB0AJdLyt2TO6ETzGsXYp9Vu+/JV55SiTjLUVdQf5K6Catg
         zlCz9dhYBPs6hI4l4+/EB7H24V7Wgp9tnYa21Pk1+JPGvs5SfD7R+iZGaG4ypAwDzOBr
         MZMh7aWG5VlngG9hnC8SDHO/Eps/hDlxa0lxsuC4zSCnfOKpJisMvl81e0vNn89yyIjj
         zxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ry2rZ2lF67ewBNaK+hq9OuhPhxN04Li8uwv9PYhdlqs=;
        b=bWL+bnWYmWDhZAL2cd5vMy385py+oTjdgDk2bQt7HSYq/Zj0yg6Ng+UHzq5EdKrCsw
         PtMbXL6LFjMnk6JTF5Cwpuy+I6HC4nzMspOTJZsGzc6ucL+vogBZGZet8oLGTOxF+Gj5
         JHnjy7/T6DqB05eYHBQ23GHJaFM1enMRPErmxXEyFOBgRoGFKyhl4zyUk+67pvJBJepn
         mxMVbPBF2G0ZnYL8Cq8Dle5fyl7WRLLgBuxft4sVRVb4pHCucl/uW9/F7PaqlTnpE8WY
         YI1GYBM/fzrXxoRMMO36hX4F7v6/KWk6U05Qlw/xsaHxCSuZiXipifizNU93yT49stBg
         FeRg==
X-Gm-Message-State: APjAAAVZJynJk62DHdCvK0a5STS46UE/Add0FdKizOq5+kxjZ/VYyiB7
        LZDrgj69EUrFadY7f/vkzHmwk5Ee+EFjoMFZEy4=
X-Google-Smtp-Source: APXvYqxgBnEQzdqqaLpxSS/+6w5RHBHjanxqTLYB5Dyz4RYTvkjhASwNge3HbnRMi6Ra6vEe0u3lO6mSrh7cEd6xCLY=
X-Received: by 2002:ac8:7401:: with SMTP id p1mr33242393qtq.141.1570504108344;
 Mon, 07 Oct 2019 20:08:28 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-7-ast@kernel.org>
In-Reply-To: <20191005050314.1114330-7-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Oct 2019 20:08:17 -0700
Message-ID: <CAEf4BzYK3pm11EdhMJ+xgDbfVwFJ_Dnp6kgM839q5_AX+zc7sw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/10] bpf: add support for BTF pointers to interpreter
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 10:07 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Pointer to BTF object is a pointer to kernel object or NULL.
> The memory access in the interpreter has to be done via probe_kernel_read
> to avoid page faults.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/filter.h |  3 +++
>  kernel/bpf/core.c      | 19 +++++++++++++++++++
>  kernel/bpf/verifier.c  |  8 ++++++++
>  3 files changed, 30 insertions(+)
>

[...]
