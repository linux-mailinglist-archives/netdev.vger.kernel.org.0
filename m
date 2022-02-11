Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AEF4B3034
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 23:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353993AbiBKWOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 17:14:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbiBKWOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 17:14:43 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35D9D42;
        Fri, 11 Feb 2022 14:14:41 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id i62so13132596ioa.1;
        Fri, 11 Feb 2022 14:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=52zLhq6JupnpDnczY4RSinDjoi0eWr+X0TGdI4GIvj4=;
        b=ck4MZNgPyVCIG5mEiTnkDfBIu0xulCw0QXjuuNavbtOLoWXTHW4iHzYN5kcyDEEIZJ
         f4IiaKUlJHpzypV/lkOSgVk5HWPUq6YPxHzjM61elstXcZUG4lomYgk6h3FVO3TdJtKO
         hjAtq3yhj9AzWG+mUudzTNN5idcHEAz2MlDh0FxKXzPIRy7s+2Otw7CqVH3KmehBcjZd
         ehhB58Rxj4NcjPdL7576Kn2Jjy1aEus6mr3SJbRQUAsk6CcDFOpQGe6ps30U37MbCN1H
         slez+HGgcIYVqb7pZflgY0+EL2laPoqGXnIjgMyzj8vCS8z2WE5ukHl+FiPscIZzhEL1
         Z8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=52zLhq6JupnpDnczY4RSinDjoi0eWr+X0TGdI4GIvj4=;
        b=rhLja9z9iZ0tCZCsf8uYG3a3YdoTQlfRrq+eaav2vMIccZYYJRcY1w7geuaVsOpdb2
         Gkg5YizHKGkA6NI7hsNuOJuE/n/6PL9/qJdS6r7AGWKJKVD5WAbq/6sCHUCkv8csAyeE
         nKsHgJbzbDeqLfIO7ap8u0rahHxb1pnvQZs2gppNR24Sfchu/ei9LASlnV1GGiQ5AwUw
         12LCnScwLJkwSagbdVeylVyEKC/unk8xIMt/m6ATZ9axLrfZIbqMPCxdPSIVetAOEX1z
         1ACJ1LqOVxNTkVW15FaSjSse4SHOlr/xG4ueXQdU+BkQjyqzQ0RLPIAPgFByFyZUEFnE
         anZQ==
X-Gm-Message-State: AOAM532Tcy5mAPJQexV2NghoVqxGWpoGUmRzNIatcWZ7VyAFfvWDS2os
        sApP3yCJrKz3nCmo1o2AntnplBDMSZkcuXuYLwk=
X-Google-Smtp-Source: ABdhPJyFjTBPVdYT8GAQ1UCAektZApLalJnZcsGE9mAHl9p14pKXihMblonhCF/JG90DhqiIMWKLDDD0xZXsP5XB3RA=
X-Received: by 2002:a05:6602:2dc8:: with SMTP id l8mr1918425iow.63.1644617681071;
 Fri, 11 Feb 2022 14:14:41 -0800 (PST)
MIME-Version: 1.0
References: <20220211195101.591642-1-toke@redhat.com>
In-Reply-To: <20220211195101.591642-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Feb 2022 14:14:30 -0800
Message-ID: <CAEf4BzY=spmQrPX06-hrNMSaH_Sst-WTZiHSpNaCid4+ZNjB3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Use dynamically allocated buffer when
 receiving netlink messages
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Zhiqian Guan <zhguan@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 11:51 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> When receiving netlink messages, libbpf was using a statically allocated
> stack buffer of 4k bytes. This happened to work fine on systems with a 4k
> page size, but on systems with larger page sizes it can lead to truncated
> messages. The user-visible impact of this was that libbpf would insist no
> XDP program was attached to some interfaces because that bit of the netli=
nk
> message got chopped off.
>
> Fix this by switching to a dynamically allocated buffer; we borrow the
> approach from iproute2 of using recvmsg() with MSG_PEEK|MSG_TRUNC to get
> the actual size of the pending message before receiving it, adjusting the
> buffer as necessary. While we're at it, also add retries on interrupted
> system calls around the recvmsg() call.
>
> Reported-by: Zhiqian Guan <zhguan@redhat.com>
> Fixes: 8bbb77b7c7a2 ("libbpf: Add various netlink helpers")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/netlink.c | 55 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 52 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index c39c37f99d5c..9a6e95206bf0 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -87,22 +87,70 @@ enum {
>         NL_DONE,
>  };
>
> +static int __libbpf_netlink_recvmsg(int sock, struct msghdr *mhdr, int f=
lags)

let's not use names starting with underscored. Just call it
"netlink_recvmsg" or something like that.

> +{
> +       int len;
> +
> +       do {
> +               len =3D recvmsg(sock, mhdr, flags);

recvmsg returns ssize_t, is it ok to truncate to int?


> +       } while (len < 0 && (errno =3D=3D EINTR || errno =3D=3D EAGAIN));
> +
> +       if (len < 0)
> +               return -errno;
> +       return len;
> +}
> +
> +static int libbpf_netlink_recvmsg(int sock, struct msghdr *mhdr, char **=
buf)
> +{
> +       struct iovec *iov =3D mhdr->msg_iov;
> +       void *nbuf;
> +       int len;
> +
> +       len =3D __libbpf_netlink_recvmsg(sock, mhdr, MSG_PEEK | MSG_TRUNC=
);
> +       if (len < 0)
> +               return len;
> +
> +       if (len < 4096)
> +               len =3D 4096;
> +
> +       if (len > iov->iov_len) {
> +               nbuf =3D realloc(iov->iov_base, len);
> +               if (!nbuf) {
> +                       free(iov->iov_base);
> +                       return -ENOMEM;
> +               }
> +               iov->iov_base =3D nbuf;

this function both sets iov->iov_base *and* returns buf. It's quite a
convoluted contract. Seems like buf is not necessary (and also NULL
out iov->iov_base in case of error above?). But it might be cleaner to
do this MSG_PEEK  + realloc + recvmsg  in libbpf_netlink_recv()
explicitly. It's only one place.


> +               iov->iov_len =3D len;
> +       }
> +
> +       len =3D __libbpf_netlink_recvmsg(sock, mhdr, 0);
> +       if (len > 0)
> +               *buf =3D iov->iov_base;
> +       return len;
> +}
> +
>  static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
>                                __dump_nlmsg_t _fn, libbpf_dump_nlmsg_t fn=
,
>                                void *cookie)
>  {
> +       struct iovec iov =3D {};
> +       struct msghdr mhdr =3D {
> +               .msg_iov =3D &iov,
> +               .msg_iovlen =3D 1,
> +       };
>         bool multipart =3D true;
>         struct nlmsgerr *err;
>         struct nlmsghdr *nh;
> -       char buf[4096];
>         int len, ret;
> +       char *buf;
> +
>
>         while (multipart) {
>  start:
>                 multipart =3D false;
> -               len =3D recv(sock, buf, sizeof(buf), 0);
> +               len =3D libbpf_netlink_recvmsg(sock, &mhdr, &buf);
>                 if (len < 0) {
> -                       ret =3D -errno;
> +                       ret =3D len;
>                         goto done;
>                 }
>
> @@ -151,6 +199,7 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid=
, int seq,
>         }
>         ret =3D 0;
>  done:
> +       free(iov.iov_base);

double free on -ENOMEM? And even more confusing why you bother with
buf at all...

>         return ret;
>  }
>
> --
> 2.35.1
>
