Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7247A45FD24
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 07:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238719AbhK0GvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 01:51:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43248 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348932AbhK0GtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 01:49:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9636B82946;
        Sat, 27 Nov 2021 06:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80436C53FCC;
        Sat, 27 Nov 2021 06:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637995562;
        bh=wQ/Vo+26AE+z8+JhLsdwErI3+CaDGfIdoHcExvqcoIo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E0BFu98JdBafGTHTVTJ5FzW20ek3B2/aOn5oBNw7EfS9C7gv9aCcRdrg0QV88UFai
         mKJGHTZ03UiMxj4HHbrnp4QynvOPLQvBP9dLFUHHM9Lla4Ef2DO5sodsc7NXCl+1g1
         jNlB0xxux8aABJzJTEhLfenWNL4RygSc88X4PYX0FMUR3izwM+Sft8dy+1RDCZPZlD
         ZYunsbF1BDduHol3gct9uWqSIPqi/kJdMAb0zIgZYX1nQh2xQQ3hT3PJPWvoti8RLD
         57lGB8Flw6eoZEvMDgwj9BrF0b2cR8AIdDL0bDIDvlqnbMLtFEPKFrYkihTloZs77k
         eS38RikJV0eqQ==
Received: by mail-yb1-f178.google.com with SMTP id v138so25823740ybb.8;
        Fri, 26 Nov 2021 22:46:02 -0800 (PST)
X-Gm-Message-State: AOAM530eb2Wpn/b59Wz9rjsnyvwgeqW51bTWIyoiX/dWN3XWojOBY8zc
        qD8cKuVC0f689gje3klPmJuG7pgjoie970mT/+Y=
X-Google-Smtp-Source: ABdhPJzPPhwZ2EPkStPsgxToLvW/4PcaG1whvCG1SsWi1exesEosgg9MGP6/E/c2iWEFTmR+YWf3Qck57nCTF8xjrLQ=
X-Received: by 2002:a25:af82:: with SMTP id g2mr21718822ybh.509.1637995561629;
 Fri, 26 Nov 2021 22:46:01 -0800 (PST)
MIME-Version: 1.0
References: <20211124091821.3916046-1-boon.leong.ong@intel.com> <20211124091821.3916046-5-boon.leong.ong@intel.com>
In-Reply-To: <20211124091821.3916046-5-boon.leong.ong@intel.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 26 Nov 2021 22:45:51 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4AiqzH+vx3hOJb5taae0cN0NDKUUNsi5iybG+PF9xYgg@mail.gmail.com>
Message-ID: <CAPhsuW4AiqzH+vx3hOJb5taae0cN0NDKUUNsi5iybG+PF9xYgg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] samples/bpf: xdpsock: add time-out for
 cleaning Tx
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        bjorn@kernel.org, Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 1:22 AM Ong Boon Leong <boon.leong.ong@intel.com> wrote:
>
> When user sets tx-pkt-count and in case where there are invalid Tx frame,
> the complete_tx_only_all() process polls indefinitely. So, this patch
> adds a time-out mechanism into the process so that the application
> can terminate automatically after it retries 3*polling interval duration.
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 136383         1000000
> rx dropped         0              0
> rx invalid         0              0
> tx invalid         35             245
> rx queue full      0              0
> fill ring empty    0              1
> tx ring empty      957            7011
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 0              1000000
> rx dropped         0              0
> rx invalid         0              0
> tx invalid         0              245
> rx queue full      0              0
> fill ring empty    0              1
> tx ring empty      1              7012
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 0              1000000
> rx dropped         0              0
> rx invalid         0              0
> tx invalid         0              245
> rx queue full      0              0
> fill ring empty    0              1
> tx ring empty      1              7013
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 0              1000000
> rx dropped         0              0
> rx invalid         0              0
> tx invalid         0              245
> rx queue full      0              0
> fill ring empty    0              1
> tx ring empty      1              7014
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           1.00
> rx                 0              0
> tx                 0              1000000
> rx dropped         0              0
> rx invalid         0              0
> tx invalid         0              245
> rx queue full      0              0
> fill ring empty    0              1
> tx ring empty      0              7014
>
>  sock0@enp0s29f1:2 txonly xdp-drv
>                    pps            pkts           0.00
> rx                 0              0
> tx                 0              1000000
> rx dropped         0              0
> rx invalid         0              0
> tx invalid         0              245
> rx queue full      0              0
> fill ring empty    0              1
> tx ring empty      0              7014

I am not following why we need examples above in the commit log.

>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> ---
>  samples/bpf/xdpsock_user.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 61d4063f11a..9c3311329ec 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -1410,6 +1410,7 @@ static inline int get_batch_size(int pkt_cnt)
>
>  static void complete_tx_only_all(void)
>  {
> +       u32 retries = 3;

Shall we make the retry value configurable? And maybe make it a timeout
value in seconds?

>         bool pending;
>         int i;
>
> @@ -1421,7 +1422,8 @@ static void complete_tx_only_all(void)
>                                 pending = !!xsks[i]->outstanding_tx;
>                         }
>                 }
> -       } while (pending);
> +               sleep(opt_interval);
> +       } while (pending && retries-- > 0);
>  }
>
>  static void tx_only_all(void)
> --
> 2.25.1
>
