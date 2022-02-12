Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B9C4B3627
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 17:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiBLQAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 11:00:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbiBLQAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 11:00:12 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088D6B9;
        Sat, 12 Feb 2022 08:00:09 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id e11so8235272ils.3;
        Sat, 12 Feb 2022 08:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HlqOqQg1Z5E2YUWNPixxwwmt4TppKj+2QVQSRCCtTX0=;
        b=f+V5FLcvFvdZrShVIj74bpyle7RbqiOn0Hp+acGMRv0YoY9kbU+QXFGa6I67Ft/8hh
         M7Nouo7YnBMLdcWRc//c4apcH2bAh8nvpjROgDIQv7nyxzJTOwD1Y+BC2g7XW+k9LGzt
         cW9YJjwLYNuwQ9TXVLbSiQhkwnS79AtLks5UZC/C+n6xz/tfXheV9pLgi4CAPPs6RqQC
         9gNjx4PoHI/vZF1KGju4HL2+VkNBsmbSASATwnh0b+y9iH+XE+G1IfQWxqRVSNT2WGa/
         9tYPdQBl9sUX6FtgwoSylc3W+3mYmCxIkmPztPM4sdBi7wPIGryU0SZjWCtujIeWvPnJ
         bM0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HlqOqQg1Z5E2YUWNPixxwwmt4TppKj+2QVQSRCCtTX0=;
        b=nKHD2EqVZiHHLx84K3stMzAWwNT5kLJt9uhMqxppQ3U4XeWqCRvgMM/3N11I99nAut
         VfdMvFHi0aTNl56ob+sH3vlXBIttZJ/PQFeI2j6dAYc8EpNC0VSm6WdVsKQR8HK0OwaS
         bB7HVSJYrygOaKdfKQ1xcIF9looADJa4qXl2oq2vRyoxwlgs8wpT00uFqslBXcGDSHRX
         Q2iv5nEBbgzX69jhmEKec6hEqPO4Znr1LGAhYTBOCqh9aFDaZecYGZs/nvseTkpBh5GR
         m+0IJpuNBgnVgbQmPvz54ST+JC5B3PU/MnIgAeGu8nQn6UOG3iFSoBvVA6c+MoePjUdB
         4qog==
X-Gm-Message-State: AOAM531kmiBNPIlYs52imuEkc4iPE/RcRLifO4c1q2DQ/08kov6n2KKA
        rG6nTJRGIwcZlEt/YekArV/DZeCu9b5NVVsSFqI=
X-Google-Smtp-Source: ABdhPJzFidudNfuImLZkMiJ8N8LbAv839GMz2qP/T5IJbJZd5N4FUD7Ynr3DIQPQ5XLx+Rm4mW47IQaGTidAkOpVZuE=
X-Received: by 2002:a05:6e02:2163:: with SMTP id s3mr3426359ilv.252.1644681608409;
 Sat, 12 Feb 2022 08:00:08 -0800 (PST)
MIME-Version: 1.0
References: <20220211234819.612288-1-toke@redhat.com>
In-Reply-To: <20220211234819.612288-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 12 Feb 2022 07:59:57 -0800
Message-ID: <CAEf4BzYURbRGL2D-WV=VUs6to=024wO2u=bGtwwxLEKc6pmfhQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: Use dynamically allocated buffer when
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

On Fri, Feb 11, 2022 at 3:49 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
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
> v2:
>   - Move peek logic to libbpf_netlink_recv(), don't double free on ENOMEM=
.
>
> Reported-by: Zhiqian Guan <zhguan@redhat.com>
> Fixes: 8bbb77b7c7a2 ("libbpf: Add various netlink helpers")
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Applied to bpf-next. One improvement would be to avoid initial malloc
of 4096, especially if that size is enough for most cases. You could
detect this through iov.iov_base =3D=3D buf and not free(iov.iov_base) at
the end. Seems reliable and simple enough. I'll leave it up to you to
follow up, if you think it's a good idea.

>  tools/lib/bpf/netlink.c | 55 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 51 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index c39c37f99d5c..a598061f6fea 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -87,29 +87,75 @@ enum {
>         NL_DONE,
>  };
>
> +static int netlink_recvmsg(int sock, struct msghdr *mhdr, int flags)
> +{
> +       int len;
> +
> +       do {
> +               len =3D recvmsg(sock, mhdr, flags);
> +       } while (len < 0 && (errno =3D=3D EINTR || errno =3D=3D EAGAIN));
> +
> +       if (len < 0)
> +               return -errno;
> +       return len;
> +}
> +
> +static int alloc_iov(struct iovec *iov, int len)
> +{
> +       void *nbuf;
> +
> +       nbuf =3D realloc(iov->iov_base, len);
> +       if (!nbuf)
> +               return -ENOMEM;
> +
> +       iov->iov_base =3D nbuf;
> +       iov->iov_len =3D len;
> +       return 0;
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
>
> +       ret =3D alloc_iov(&iov, 4096);
> +       if (ret)
> +               goto done;
> +
>         while (multipart) {
>  start:
>                 multipart =3D false;
> -               len =3D recv(sock, buf, sizeof(buf), 0);
> +               len =3D netlink_recvmsg(sock, &mhdr, MSG_PEEK | MSG_TRUNC=
);
> +               if (len < 0) {
> +                       ret =3D len;
> +                       goto done;
> +               }
> +
> +               if (len > iov.iov_len) {
> +                       ret =3D alloc_iov(&iov, len);
> +                       if (ret)
> +                               goto done;
> +               }
> +
> +               len =3D netlink_recvmsg(sock, &mhdr, 0);
>                 if (len < 0) {
> -                       ret =3D -errno;
> +                       ret =3D len;
>                         goto done;
>                 }
>
>                 if (len =3D=3D 0)
>                         break;
>
> -               for (nh =3D (struct nlmsghdr *)buf; NLMSG_OK(nh, len);
> +               for (nh =3D (struct nlmsghdr *)iov.iov_base; NLMSG_OK(nh,=
 len);
>                      nh =3D NLMSG_NEXT(nh, len)) {
>                         if (nh->nlmsg_pid !=3D nl_pid) {
>                                 ret =3D -LIBBPF_ERRNO__WRNGPID;
> @@ -151,6 +197,7 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid=
, int seq,
>         }
>         ret =3D 0;
>  done:
> +       free(iov.iov_base);
>         return ret;
>  }
>
> --
> 2.35.1
>
