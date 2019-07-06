Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A54612C4
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 21:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfGFTDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 15:03:01 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40329 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfGFTDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 15:03:01 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so17827208iom.7
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 12:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Qrfe3707bQFohyFDg2fih45GDF/NiT2yWaAqNLSrQ1I=;
        b=tKQHER214YwAzH2tP+60jGSUYZrSSE5HSnoevG616VJSPsMMnp+iH8CyssbEW6lVuY
         pMaJmZTFIrkq8xkrV1obHQW+WE6u/vJ4l3A+St90dZiqbzjmqbMEjhQhGEQTusuu+3/h
         VBicZ9hDSOoETLbxAEiXF3BLHXGhB6t7ljR0jhZG4HO83Luily5LVXun/Fv5IkXWDT7N
         6xmQnon22VGHWdkvMjoIiu2dl1L5GoW8obTOCnF3QJGAYdJYzIf+RtjVMQPgcKhW0FIx
         kd6tHN9FtyYYiadMiaHfD/nwFnal95gTI5yaauQ6iHyS9Ev5519SnMws70Fu/7YmglaD
         1hDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Qrfe3707bQFohyFDg2fih45GDF/NiT2yWaAqNLSrQ1I=;
        b=Wvv9cRURWdETpROmENMWv0YY42xXtK4Q5aECxEoTlfEZw/Lm43Lxkd2eB/4Cwe8CeY
         x8cbBspzLK/cfFvzADeHrdEkdR0N9ZdFaTdJ+BNl7qod/5eo+RJxLEWXGAQebs4mCkMY
         SV1+sgaZ9we6rwWn4Sc1/3PoLgAaisCvDcNd2QQmdxgtF+L7JGPiNtsO+JBertfOB9Ff
         0uSHUMie0v4T++v0LSYgyeFH6Ha/qdurQiLV1S0bB7pLXyvIt6f85icM28fSnp2q+hwC
         +QOrAoyZZX3GcuvPVQKDp1KY0wE0uoccLCZhkPAi3l5J71JwvdK/4ayivJvSBXq8a3gQ
         M7xw==
X-Gm-Message-State: APjAAAUxLX/zPvKOp8XZYdLO0j19tDJ3vlcNINdtQGgrWUJ6pQ96Rg+g
        S+j1MQSZLHS/17cDHFzwmHBpBytlEUUYhB9HrM8=
X-Google-Smtp-Source: APXvYqxcdsnXl+N4cnaUawcWa61k/0B6P0+h5NS4SrUxbXBTv9H7jIbJWUCmw7xNH58y5EEY9bv+PlBjyO+QuEtPQio=
X-Received: by 2002:a6b:dd18:: with SMTP id f24mr8623980ioc.97.1562439780098;
 Sat, 06 Jul 2019 12:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1> <156240283578.10171.1470306115442701328.stgit@alrua-x1>
In-Reply-To: <156240283578.10171.1470306115442701328.stgit@alrua-x1>
From:   Y Song <ys114321@gmail.com>
Date:   Sat, 6 Jul 2019 12:02:24 -0700
Message-ID: <CAH3MdRVKtwjyjPigr2490m+Ermdq6D58DsdqTvsvjdqzGsPW1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/6] xdp: Refactor devmap allocation code for reuse
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 6, 2019 at 1:47 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The subsequent patch to add a new devmap sub-type can re-use much of the
> initialisation and allocation code, so refactor it into separate function=
s.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>  kernel/bpf/devmap.c |  137 +++++++++++++++++++++++++++++++--------------=
------
>  1 file changed, 84 insertions(+), 53 deletions(-)
>
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index d83cf8ccc872..a2fe16362129 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -60,7 +60,7 @@ struct xdp_bulk_queue {
>  struct bpf_dtab_netdev {
>         struct net_device *dev; /* must be first member, due to tracepoin=
t */
>         struct bpf_dtab *dtab;
> -       unsigned int bit;
> +       unsigned int idx; /* keep track of map index for tracepoint */
>         struct xdp_bulk_queue __percpu *bulkq;
>         struct rcu_head rcu;
>  };
> @@ -75,28 +75,22 @@ struct bpf_dtab {
>  static DEFINE_SPINLOCK(dev_map_lock);
>  static LIST_HEAD(dev_map_list);
>
> -static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
> +static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr,
> +                           bool check_memlock)
>  {
> -       struct bpf_dtab *dtab;
>         int err, cpu;
>         u64 cost;
>
> -       if (!capable(CAP_NET_ADMIN))
> -               return ERR_PTR(-EPERM);
> -
>         /* check sanity of attributes */
>         if (attr->max_entries =3D=3D 0 || attr->key_size !=3D 4 ||
>             attr->value_size !=3D 4 || attr->map_flags & ~DEV_CREATE_FLAG=
_MASK)
> -               return ERR_PTR(-EINVAL);
> +               return -EINVAL;
>
>         /* Lookup returns a pointer straight to dev->ifindex, so make sur=
e the
>          * verifier prevents writes from the BPF side
>          */
>         attr->map_flags |=3D BPF_F_RDONLY_PROG;
>
> -       dtab =3D kzalloc(sizeof(*dtab), GFP_USER);
> -       if (!dtab)
> -               return ERR_PTR(-ENOMEM);
>
>         bpf_map_init_from_attr(&dtab->map, attr);
>
> @@ -107,9 +101,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *=
attr)
>         /* if map size is larger than memlock limit, reject it */
>         err =3D bpf_map_charge_init(&dtab->map.memory, cost);
>         if (err)
> -               goto free_dtab;
> -
> -       err =3D -ENOMEM;
> +               return -EINVAL;
>
>         dtab->flush_list =3D alloc_percpu(struct list_head);
>         if (!dtab->flush_list)
> @@ -124,19 +116,38 @@ static struct bpf_map *dev_map_alloc(union bpf_attr=
 *attr)
>         if (!dtab->netdev_map)
>                 goto free_percpu;
>
> -       spin_lock(&dev_map_lock);
> -       list_add_tail_rcu(&dtab->list, &dev_map_list);
> -       spin_unlock(&dev_map_lock);
> -
> -       return &dtab->map;
> +       return 0;
>
>  free_percpu:
>         free_percpu(dtab->flush_list);
>  free_charge:
>         bpf_map_charge_finish(&dtab->map.memory);
> -free_dtab:
> -       kfree(dtab);
> -       return ERR_PTR(err);
> +       return -ENOMEM;
> +}
> +
[...]
