Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DCF64CFAC
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 19:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238888AbiLNSoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 13:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238938AbiLNSoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 13:44:04 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526AE27177
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 10:44:03 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id g10so4249220plo.11
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 10:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JnOlNEVM5JqV3wE3k9/PzZ4i3lcEcVI0S6phNBabVFY=;
        b=Odil4KikOc9OuEumEX767aMYDlGJ1NLTUtYpo4AirTQU2qNwPiBvvnNy+s3Uw9xNwb
         cihb3h8FCw3jpQPWbwvDqQrYpb/QtL4dWRSIZVFfRtexbE9omby/qUHQEvQTIKNd1KyW
         F5oxZ2ijNhTOjEjBkVCKhQtXS/Gp2+s/iGzaKJhby3xgln9x1kG6b1zaaVeNgT0HI9Qn
         vANrJgbaPu5uLw+GOhFGlwoWNbegcRDuXhrQWnF0dnsT5Zuth9cUg4k3knWPNVZtxts3
         kvoD/6dbi6ljAgm/L3OmZ8p4aGb8/dWRXktkC6b798A27p9CRrFtRRa3o8Btjzl+ZKW4
         Bg2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JnOlNEVM5JqV3wE3k9/PzZ4i3lcEcVI0S6phNBabVFY=;
        b=fKvOpwPT7co9xGiBgTz5OCxl+LkNz2Gqm4zXkzEf+GpK+4kIEW/yr4vjdjtXvzdZeU
         iZ5kGchXJf8HVV3XpCWFWcZ9GzKj/sKitmLUWp5xfKANGTDQgotHAElZAvH9YFmckqQo
         WUXYzOoTgZS0bWT7T0FEB+1gUHTq6B5mPVgcpPvutLQFS5yunAgnCd1akGqn91J1cbiA
         GpGJ643v+3X5IiIUTfRvOeuBCfY19oVPMX+82v6+6fvoW/864/BXA825qTdnvIomrR+Q
         imxQnaRdcBl7/sCzJ5KA3lv76x/tarZW28ReZxOfHj4YgmQiWk81pBwW1+8feefzABmI
         ZFUQ==
X-Gm-Message-State: ANoB5pnrUlMdRuGQ7nQIbP/SI5t7Iim/RUhzeqqYiBEd5UffZdiENqaZ
        Z2U7ogGYWIYA0t0XII07t4VO6fUFIrQR6hoRzkHbsQ==
X-Google-Smtp-Source: AA0mqf63Mmzf5TI9e0MWyXM4Xi/jEwuRunkR35qO/ou1KM7Exy0P82kXP4HHtSiZ8H+zASf+FJ8ZTm88t81z7hHVt84=
X-Received: by 2002:a17:902:d711:b0:188:c7b2:2dd with SMTP id
 w17-20020a170902d71100b00188c7b202ddmr80295252ply.88.1671043442639; Wed, 14
 Dec 2022 10:44:02 -0800 (PST)
MIME-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com> <20221213023605.737383-6-sdf@google.com>
 <74e48fc9-8f5d-4183-9f39-c4587c74a74e@linux.dev>
In-Reply-To: <74e48fc9-8f5d-4183-9f39-c4587c74a74e@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 14 Dec 2022 10:43:51 -0800
Message-ID: <CAKH8qBsB2epy_s-NFs3TEuNBhXHfq-WuNvAOM9t16SUe=V8RNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 05/15] bpf: XDP metadata RX kfuncs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 5:54 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 12/12/22 6:35 PM, Stanislav Fomichev wrote:
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index ca22e8b8bd82..de6279725f41 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -2477,6 +2477,8 @@ void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
> >                                      struct net_device *netdev);
> >   bool bpf_offload_dev_match(struct bpf_prog *prog, struct net_device *netdev);
> >
> > +void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id);
> > +
>
> This probably requires an inline version for !CONFIG_NET.

Yeah, not sure why my confings didn't catch this :-(

> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index d434a994ee04..c3e501e3e39c 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -2097,6 +2097,13 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
> >       if (fp->kprobe_override)
> >               return false;
> >
> > +     /* When tail-calling from a non-dev-bound program to a dev-bound one,
> > +      * XDP metadata helpers should be disabled. Until it's implemented,
> > +      * prohibit adding dev-bound programs to tail-call maps.
> > +      */
> > +     if (bpf_prog_is_dev_bound(fp->aux))
> > +             return false;
> > +
> >       spin_lock(&map->owner.lock);
> >       if (!map->owner.type) {
> >               /* There's no owner yet where we could check for
> > diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> > index f714c941f8ea..3b6c9023f24d 100644
> > --- a/kernel/bpf/offload.c
> > +++ b/kernel/bpf/offload.c
> > @@ -757,6 +757,29 @@ void bpf_dev_bound_netdev_unregister(struct net_device *dev)
> >       up_write(&bpf_devs_lock);
> >   }
> >
> > +void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
> > +{
> > +     const struct xdp_metadata_ops *ops;
> > +     void *p = NULL;
> > +
> > +     down_read(&bpf_devs_lock);
> > +     if (!prog->aux->offload || !prog->aux->offload->netdev)
>
> This happens when netdev is unregistered in the middle of bpf_prog_load and the
> bpf_offload_dev_match() will eventually fail during dev_xdp_attach()? A comment
> will be useful.

Right, that's the expectation - we load/verify the prog but it's
essentially un-attach-able.
Will try to clarify here.

> > +             goto out;
> > +
> > +     ops = prog->aux->offload->netdev->xdp_metadata_ops;
> > +     if (!ops)
> > +             goto out;
> > +
> > +     if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
> > +             p = ops->xmo_rx_timestamp;
> > +     else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
> > +             p = ops->xmo_rx_hash;
> > +out:
> > +     up_read(&bpf_devs_lock);
> > +
> > +     return p;
> > +}
> > +
> >   static int __init bpf_offload_init(void)
> >   {
> >       int err;
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 203d8cfeda70..e61fe0472b9b 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -15479,12 +15479,35 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >                           struct bpf_insn *insn_buf, int insn_idx, int *cnt)
> >   {
> >       const struct bpf_kfunc_desc *desc;
> > +     void *xdp_kfunc;
> >
> >       if (!insn->imm) {
> >               verbose(env, "invalid kernel function call not eliminated in verifier pass\n");
> >               return -EINVAL;
> >       }
> >
> > +     *cnt = 0;
> > +
> > +     if (xdp_is_metadata_kfunc_id(insn->imm)) {
> > +             if (!bpf_prog_is_dev_bound(env->prog->aux)) {
>
> The "xdp_is_metadata_kfunc_id() && (!bpf_prog_is_dev_bound() ||
> bpf_prog_is_offloaded())" test should have been done much earlier in
> add_kfunc_call(). Then the later stage of the verifier does not have to keep
> worrying about it like here.
>
> nit. may be rename xdp_is_metadata_kfunc_id() to bpf_dev_bound_kfunc_id() and
> hide the "!bpf_prog_is_dev_bound() || bpf_prog_is_offloaded()" test into
> bpf_dev_bound_kfunc_check(&env->log, env->prog).
>
> The change in fixup_kfunc_call could then become:
>
>         if (bpf_dev_bound_kfunc_id(insn->imm)) {
>                 xdp_kfunc = bpf_dev_bound_resolve_kfunc(env->prog, insn->imm);
>                 /* ... */
>         }

Makes sense, ty!


> > +                     verbose(env, "metadata kfuncs require device-bound program\n");
> > +                     return -EINVAL;
> > +             }
> > +
> > +             if (bpf_prog_is_offloaded(env->prog->aux)) {
> > +                     verbose(env, "metadata kfuncs can't be offloaded\n");
> > +                     return -EINVAL;
> > +             }
> > +
> > +             xdp_kfunc = bpf_dev_bound_resolve_kfunc(env->prog, insn->imm);
> > +             if (xdp_kfunc) {
> > +                     insn->imm = BPF_CALL_IMM(xdp_kfunc);
> > +                     return 0;
> > +             }
> > +
> > +             /* fallback to default kfunc when not supported by netdev */
> > +     }
> > +
>
>
