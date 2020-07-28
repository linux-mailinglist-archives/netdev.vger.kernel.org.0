Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7149B230118
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgG1FHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgG1FHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:07:34 -0400
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354B222B47;
        Tue, 28 Jul 2020 05:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595912853;
        bh=julnmZ6d99C3BH6F52UlRn44Ck82VwZ9mFMWkFSJq0E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GiEob/uUATJb6NGdNXNRPIXJMwx5B1hmd89pvpgQ1A7bneO6GstY8d5UUx/Xzh3cX
         rTw+eqI8jlyDCvT8aDqgDW2shNnG1Ip+L41mIssxsr9WnhIF264dq+dfevQdECGoYd
         IBJsfXYE+eCnZir5jQMZr1HGV8XIwIL9uKm2aL48=
Received: by mail-lj1-f176.google.com with SMTP id v4so10027279ljd.0;
        Mon, 27 Jul 2020 22:07:33 -0700 (PDT)
X-Gm-Message-State: AOAM531IRPBcM5FuHh/WX+4DNE11SPB8Flpz+CfVAPSp3nHL0lUqSxul
        NOBpxK9RlF+XFYygNJR+LhqDqG64eWzHoOpNU3s=
X-Google-Smtp-Source: ABdhPJytszNTur7+L8yYaMkkhh+bgs5XLkap0KlVaVnWI6a+xCWLQT4+KIxYTOVT5ftgIxWwP5luaCd2mGdDBu/bXb8=
X-Received: by 2002:a2e:9996:: with SMTP id w22mr12656350lji.446.1595912851449;
 Mon, 27 Jul 2020 22:07:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200728022859.381819-1-yepeilin.cs@gmail.com>
In-Reply-To: <20200728022859.381819-1-yepeilin.cs@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:07:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7L6KWAM55=oLgQ2MtoJOB9i4mwZHOVF+KJj7W5ht_+YQ@mail.gmail.com>
Message-ID: <CAPhsuW7L6KWAM55=oLgQ2MtoJOB9i4mwZHOVF+KJj7W5ht_+YQ@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH net] xdp: Prevent kernel-infoleak
 in xsk_getsockopt()
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 7:30 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> xsk_getsockopt() is copying uninitialized stack memory to userspace when
> `extra_stats` is `false`. Fix it by initializing `stats` with memset().
>
> Cc: stable@vger.kernel.org

8aa5a33578e9 is not in stable branches yet, so we don't need to Cc stable.

> Fixes: 8aa5a33578e9 ("xsk: Add new statistics")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
>  net/xdp/xsk.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 26e3bba8c204..acf001908a0d 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -844,6 +844,8 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
>                 bool extra_stats = true;
>                 size_t stats_size;
>
> +               memset(&stats, 0, sizeof(stats));
> +

xsk.c doesn't include linux/string.h directly, so using memset may break
build for some config combinations. We can probably just use

struct xdp_statistics stats = {};

Thanks,
Song


>                 if (len < sizeof(struct xdp_statistics_v1)) {
>                         return -EINVAL;
>                 } else if (len < sizeof(stats)) {
> --
> 2.25.1
>
