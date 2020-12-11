Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847C32D8056
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 22:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394769AbgLKVBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 16:01:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394751AbgLKVAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 16:00:50 -0500
X-Gm-Message-State: AOAM5322j4ttJklW+DSxqy+Hd8WKQNQcckFq0lP19zt92d1S1z6A6tUY
        CdMXowuzH33z9b53iHi2nwhvjj4a5uYg9L0n7js=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607720409;
        bh=0OdAfHXVSmV4upgVK23rC2WbpmA/myKVM+LFlH0XlSQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mpJYb+gNtdzZ6IlU8NXxiQGR6E4QaG75tYJQYVxDdFkWZw7S9r5DWhbVKQZJkN/wA
         Qmrbem+xtwznOPgGAYj0/HzaCuOUhs3rSSf6pAT/BY8yGk1/wqEelrw+DavY9DW0hR
         Ado57lSq5dCML+gxu+NYkcQQ0+341nPwL3TPT+0vHYjnvwOizrEM7jpeBLBkSwzJVu
         f9uArj5QA9M1PLW89R1FC3qvmpD68DxNrPdCPiC9E2OMIxV+8Gm+sTYkayQrKdNxWE
         x2xxxFFBb2K8+TaejDLAd+LIrmte6l/tfX/602H6grBPTJHfdaqL7zDaURzt85n/uw
         PfiEF+8ekQjDA==
X-Google-Smtp-Source: ABdhPJwiJpzQkQ22vcNutFE60niWIjCFOoaLOg3iwr+QhczmEN98RjDpRUwCX/UyGEjItEc0onPxtrvuVAJDsEytYT4=
X-Received: by 2002:aca:418b:: with SMTP id o133mr10373990oia.67.1607720408751;
 Fri, 11 Dec 2020 13:00:08 -0800 (PST)
MIME-Version: 1.0
References: <20201211163749.31956-1-yonatanlinik@gmail.com> <20201211163749.31956-2-yonatanlinik@gmail.com>
In-Reply-To: <20201211163749.31956-2-yonatanlinik@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 11 Dec 2020 21:59:51 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0_AwRxTsYuK4p-vv61H34ERDp7od3C2c45u+0QyR+uhQ@mail.gmail.com>
Message-ID: <CAK8P3a0_AwRxTsYuK4p-vv61H34ERDp7od3C2c45u+0QyR+uhQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: Fix use of proc_fs
To:     Yonatan Linik <yonatanlinik@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Willem de Bruijn <willemb@google.com>,
        john.ogness@linutronix.de, Arnd Bergmann <arnd@arndb.de>,
        Mao Wenan <maowenan@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        orcohen@paloaltonetworks.com, Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 5:37 PM Yonatan Linik <yonatanlinik@gmail.com> wrote:

> index 2b33e977a905..031f2b593720 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -4612,9 +4612,11 @@ static int __net_init packet_net_init(struct net *net)
>         mutex_init(&net->packet.sklist_lock);
>         INIT_HLIST_HEAD(&net->packet.sklist);
>
> +#ifdef CONFIG_PROC_FS
>         if (!proc_create_net("packet", 0, net->proc_net, &packet_seq_ops,
>                         sizeof(struct seq_net_private)))
>                 return -ENOMEM;
> +#endif /* CONFIG_PROC_FS */
>

Another option would be to just ignore the return code here
and continue without a procfs file, regardless of whether procfs
is enabled or not.

       Arnd
