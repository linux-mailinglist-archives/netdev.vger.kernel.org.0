Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1887439EA2D
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 01:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhFGXeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 19:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFGXeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 19:34:08 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58141C061574;
        Mon,  7 Jun 2021 16:32:16 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id i4so27511058ybe.2;
        Mon, 07 Jun 2021 16:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jx6UDh/W4FGG1jjm7Zd5A5fUohmAi0ctiRZxHA7aUhM=;
        b=UVaOavK9dfvUmvhiCGd6NsrRgn4LMFFK7F6rCjrJpWZCZ5LzDVz2xcqY1t4CA15Wc0
         m6VKU3mFPtwOxyqsr90hZoRlQ1b15qlXMvgjtRQYRurWmWaSePx3sn9vjI2hKPs/v0mL
         srSlWDHc9nL6UkGYcTOknsp3vW5oMHET0wsMnFisgx+kBROUdfsYp7MCP8Y9inkE+EnF
         haHgwL5FN3za5uo/ZCHmcKUM+ujwAHZSkuEl01Phxp8K3O+AmYZgd+BP0AUDd9XkmqIq
         p+WyPQfQS8CuzUPR7435zsSREABke+6BHQZg+GWXuks+hFBWVgr3jB4atpJeEDpPQbu8
         5tkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jx6UDh/W4FGG1jjm7Zd5A5fUohmAi0ctiRZxHA7aUhM=;
        b=YYLpkHZfsGqvWbHbI/Hl3g5gXYxRrvk1+6jEFwyX4KZDYuuTiXPhq3/VgxjIscDWHt
         7nZBPRj5cKa1879Skw/jfFXveajVg3IIiYu1iEWrzru7rloB4pvm+iMKlKCrrOJC1Fni
         qgs4RaMqav/W+4/HgZPTurTybdzPAziNqeDj77W+DE7oAvWapjOoMICfdlOfp8i2BpPo
         MS0117eIVCdyBKQCwsjEQC+aVLwA07/KTW7GHtuOiki3oG0ISlA1upIpNv1AZZE893QH
         r+IPrdFBLwWOgE9fnjg8XbeuHs5mhXh045xkTI0YUcgZ3CGBOS6RX/xN18wg2jwZOGEu
         FhKw==
X-Gm-Message-State: AOAM532s7M0DnUkTE7o6K0U6MOQB8ejrXZNuWch9gdSdJ5FWDdx3V78I
        4Ao5oMa2SdG//HajgmyAB/V89sNW59axrMeSzxTh59IO3VI=
X-Google-Smtp-Source: ABdhPJxEfpqXYmctgpDfRKQanRCnDtVyDowM+Cz9BJ3x28J/xpidvIJ219Rpf7RjGy8CS/KjB5rsiDAbnuiDswyN+EM=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr25712548ybg.459.1623108735577;
 Mon, 07 Jun 2021 16:32:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210604063116.234316-1-memxor@gmail.com> <20210604063116.234316-5-memxor@gmail.com>
In-Reply-To: <20210604063116.234316-5-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Jun 2021 16:32:04 -0700
Message-ID: <CAEf4BzaLdLgwnjajPu=ZtzH+HB=eKKCWMrs3P+uUmQKBuANPew@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/7] net: sched: add lightweight update path
 for cls_bpf
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 11:32 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This is used by BPF_LINK_UPDATE to replace the attach SCHED_CLS bpf prog
> effectively changing the classifier implementation for a given filter
> owned by a bpf_link.
>
> Note that READ_ONCE suffices in this case as the ordering for loads from
> the filter are implicitly provided by the data dependency on BPF prog
> pointer.
>
> On the writer side we can just use a relaxed WRITE_ONCE store to make
> sure one or the other value is visible to a reader in cls_bpf_classify.
> Lifetime is managed using RCU so bpf_prog_put path should wait until
> readers are done for old_prog.
>
> All other parties accessing the BPF prog are under RTNL protection, so
> need no changes.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>.
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  net/sched/cls_bpf.c | 55 +++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 53 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
> index bf61ffbb7fd0..f23304685c48 100644
> --- a/net/sched/cls_bpf.c
> +++ b/net/sched/cls_bpf.c
> @@ -9,6 +9,7 @@
>   * (C) 2013 Daniel Borkmann <dborkman@redhat.com>
>   */
>
> +#include <linux/atomic.h>
>  #include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/skbuff.h>
> @@ -104,11 +105,11 @@ static int cls_bpf_classify(struct sk_buff *skb, co=
nst struct tcf_proto *tp,
>                         /* It is safe to push/pull even if skb_shared() *=
/
>                         __skb_push(skb, skb->mac_len);
>                         bpf_compute_data_pointers(skb);
> -                       filter_res =3D BPF_PROG_RUN(prog->filter, skb);
> +                       filter_res =3D BPF_PROG_RUN(READ_ONCE(prog->filte=
r), skb);
>                         __skb_pull(skb, skb->mac_len);
>                 } else {
>                         bpf_compute_data_pointers(skb);
> -                       filter_res =3D BPF_PROG_RUN(prog->filter, skb);
> +                       filter_res =3D BPF_PROG_RUN(READ_ONCE(prog->filte=
r), skb);
>                 }
>
>                 if (prog->exts_integrated) {
> @@ -775,6 +776,55 @@ static int cls_bpf_link_detach(struct bpf_link *link=
)
>         return 0;
>  }
>
> +static int cls_bpf_link_update(struct bpf_link *link, struct bpf_prog *n=
ew_prog,
> +                              struct bpf_prog *old_prog)
> +{
> +       struct cls_bpf_link *cls_link;
> +       struct cls_bpf_prog cls_prog;
> +       struct cls_bpf_prog *prog;
> +       int ret;
> +
> +       rtnl_lock();
> +
> +       cls_link =3D container_of(link, struct cls_bpf_link, link);
> +       if (!cls_link->prog) {
> +               ret =3D -ENOLINK;
> +               goto out;
> +       }
> +
> +       prog =3D cls_link->prog;
> +
> +       /* BPF_F_REPLACEing? */
> +       if (old_prog && prog->filter !=3D old_prog) {
> +               ret =3D -EINVAL;
> +               goto out;
> +       }
> +
> +       old_prog =3D prog->filter;
> +
> +       if (new_prog =3D=3D old_prog) {
> +               ret =3D 0;

So the contract is that if update is successful, new_prog's refcount
taken by link_update() in kernel/bpf/syscall.c is transferred here. On
error, it will be bpf_prog_put() by link_update(). So here you don't
need extra refcnt, but it's also not an error, so you need to
bpf_prog_put(new_prog) explicitly to balance out refcnt. See how it's
done for XDP, for example.


> +               goto out;
> +       }
> +
> +       cls_prog =3D *prog;
> +       cls_prog.filter =3D new_prog;
> +
> +       ret =3D cls_bpf_offload(prog->tp, &cls_prog, prog, NULL);
> +       if (ret < 0)
> +               goto out;
> +
> +       WRITE_ONCE(prog->filter, new_prog);
> +
> +       bpf_prog_inc(new_prog);

and you don't need this, you already got the reference from link_update()

> +       /* release our reference */
> +       bpf_prog_put(old_prog);
> +
> +out:
> +       rtnl_unlock();
> +       return ret;
> +}
> +
>  static void __bpf_fill_link_info(struct cls_bpf_link *link,
>                                  struct bpf_link_info *info)
>  {
> @@ -859,6 +909,7 @@ static const struct bpf_link_ops cls_bpf_link_ops =3D=
 {
>         .show_fdinfo =3D cls_bpf_link_show_fdinfo,
>  #endif
>         .fill_link_info =3D cls_bpf_link_fill_link_info,
> +       .update_prog =3D cls_bpf_link_update,
>  };
>
>  static inline char *cls_bpf_link_name(u32 prog_id, const char *name)
> --
> 2.31.1
>
