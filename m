Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13836D6DCA
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 22:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbjDDURm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 16:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDDURl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 16:17:41 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6CC4202;
        Tue,  4 Apr 2023 13:17:39 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id eg48so135370946edb.13;
        Tue, 04 Apr 2023 13:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680639457; x=1683231457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqZVoXjOAv2u4LoLOfTRprpwbdE9Fph8iUoKEg7tHpY=;
        b=THK0k9nEiE1ZTlgF0be5uHcjN2AjsY1SWNT5pZzUKmiObxNVEWtYGJ69YGD/eTq1Ti
         4oz0hBTY3EQJQA4FnxKpAJmNmizsa5VemYJvxG2qQs1ot3QT4d3qc8HJpQNejOp8wC5H
         fPPg/Ka4+PcVg/F05aQVToq3ZyODH15zbs9Vkg8/DYT/6QQXmUXsVU8azq8BMfCzFLKe
         uo/FC+ghxxPwGo7Lt1lTedwADk1xux2s4IBZpnza+PlxniBT3ItEbBdrucT0N7SMN4gJ
         n0fXbC+zwouNFFxros1abI117nReh5O7RHnSshJVjAlZZIHnT2B/unmyg5kd/oZkSLHU
         eFvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680639457; x=1683231457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SqZVoXjOAv2u4LoLOfTRprpwbdE9Fph8iUoKEg7tHpY=;
        b=U7+O+3Be24pY/FUt3X/iWKWi+c6cE5WL0fhBjws/k7afXexlpTJLePPJG3CV6O/eOX
         TG/TnfEOPO3xVU4yWqcHpF8QWl+n3a7SQqvRPa/K7x1/E4yPXLccTRFfjWwuRYUz1gJN
         kkx/0abKWk/4ruc6vwClwUQxyCiI3m9joMOUEVyxt4MhhxE1vCpUy8z2IqK3D4ArISx7
         ayX2kOSOsDFjsO/IF9Ofal8u7V4T/RhuIyDYrplCDBIM1Y6X/3V03+e+3iK8bNQbrsl1
         enJ+VGZYXDDBo2QwzhWKgbaQ7AB/kvqWXJOn9H2EFFrXQ8r7lPpL22OTRknwu/ODXCEy
         cBnQ==
X-Gm-Message-State: AAQBX9eNAe2sqI5DPnzSlRj198qgslb260qkkJ00jp6aTSpP/ed6+pfv
        7TxGpkOPoYzcdyxeNJVkpXKbuU9F56gDo/X40iE=
X-Google-Smtp-Source: AKy350a8kqpEVJ/iR2f6sw6W1KfBnjufJxbZFPozDZjk/xmMlnKRWo1XUWnqciRBB0M/1UargpsA5iY+aVSXmsENBKs=
X-Received: by 2002:a17:906:1c0e:b0:90a:33e4:5a69 with SMTP id
 k14-20020a1709061c0e00b0090a33e45a69mr382515ejg.3.1680639457295; Tue, 04 Apr
 2023 13:17:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404045029.82870-5-alexei.starovoitov@gmail.com> <20230404144652.GA3896@maniforge>
In-Reply-To: <20230404144652.GA3896@maniforge>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 4 Apr 2023 13:17:25 -0700
Message-ID: <CAADnVQJEBJdXp11NE_zti0jBHbMmodDKh7YuBFGkN3q_wOHJtA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/8] bpf: Teach verifier that certain helpers
 accept NULL pointer.
To:     David Vernet <void@manifault.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 7:46=E2=80=AFAM David Vernet <void@manifault.com> wr=
ote:
>
> On Mon, Apr 03, 2023 at 09:50:25PM -0700, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > bpf_[sk|inode|task|cgrp]_storage_[get|delete]() and bpf_get_socket_cook=
ie() helpers
> > perform run-time check that sk|inode|task|cgrp pointer !=3D NULL.
> > Teach verifier about this fact and allow bpf programs to pass
> > PTR_TO_BTF_ID | PTR_MAYBE_NULL into such helpers.
> > It will be used in the subsequent patch that will do
> > bpf_sk_storage_get(.., skb->sk, ...);
> > Even when 'skb' pointer is trusted the 'sk' pointer may be NULL.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  kernel/bpf/bpf_cgrp_storage.c  | 4 ++--
> >  kernel/bpf/bpf_inode_storage.c | 4 ++--
> >  kernel/bpf/bpf_task_storage.c  | 8 ++++----
> >  net/core/bpf_sk_storage.c      | 4 ++--
> >  net/core/filter.c              | 2 +-
> >  5 files changed, 11 insertions(+), 11 deletions(-)
> >
> > diff --git a/kernel/bpf/bpf_cgrp_storage.c b/kernel/bpf/bpf_cgrp_storag=
e.c
> > index d17d5b694668..d44fe8dd9732 100644
> > --- a/kernel/bpf/bpf_cgrp_storage.c
> > +++ b/kernel/bpf/bpf_cgrp_storage.c
> > @@ -224,7 +224,7 @@ const struct bpf_func_proto bpf_cgrp_storage_get_pr=
oto =3D {
> >       .gpl_only       =3D false,
> >       .ret_type       =3D RET_PTR_TO_MAP_VALUE_OR_NULL,
> >       .arg1_type      =3D ARG_CONST_MAP_PTR,
> > -     .arg2_type      =3D ARG_PTR_TO_BTF_ID,
> > +     .arg2_type      =3D ARG_PTR_TO_BTF_ID_OR_NULL,
> >       .arg2_btf_id    =3D &bpf_cgroup_btf_id[0],
> >       .arg3_type      =3D ARG_PTR_TO_MAP_VALUE_OR_NULL,
> >       .arg4_type      =3D ARG_ANYTHING,
> > @@ -235,6 +235,6 @@ const struct bpf_func_proto bpf_cgrp_storage_delete=
_proto =3D {
> >       .gpl_only       =3D false,
> >       .ret_type       =3D RET_INTEGER,
> >       .arg1_type      =3D ARG_CONST_MAP_PTR,
> > -     .arg2_type      =3D ARG_PTR_TO_BTF_ID,
> > +     .arg2_type      =3D ARG_PTR_TO_BTF_ID_OR_NULL,
> >       .arg2_btf_id    =3D &bpf_cgroup_btf_id[0],
> >  };
> > diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_stor=
age.c
> > index e17ad581b9be..a4d93df78c75 100644
> > --- a/kernel/bpf/bpf_inode_storage.c
> > +++ b/kernel/bpf/bpf_inode_storage.c
> > @@ -229,7 +229,7 @@ const struct bpf_func_proto bpf_inode_storage_get_p=
roto =3D {
> >       .gpl_only       =3D false,
> >       .ret_type       =3D RET_PTR_TO_MAP_VALUE_OR_NULL,
> >       .arg1_type      =3D ARG_CONST_MAP_PTR,
> > -     .arg2_type      =3D ARG_PTR_TO_BTF_ID,
> > +     .arg2_type      =3D ARG_PTR_TO_BTF_ID_OR_NULL,
> >       .arg2_btf_id    =3D &bpf_inode_storage_btf_ids[0],
> >       .arg3_type      =3D ARG_PTR_TO_MAP_VALUE_OR_NULL,
> >       .arg4_type      =3D ARG_ANYTHING,
> > @@ -240,6 +240,6 @@ const struct bpf_func_proto bpf_inode_storage_delet=
e_proto =3D {
> >       .gpl_only       =3D false,
> >       .ret_type       =3D RET_INTEGER,
> >       .arg1_type      =3D ARG_CONST_MAP_PTR,
> > -     .arg2_type      =3D ARG_PTR_TO_BTF_ID,
> > +     .arg2_type      =3D ARG_PTR_TO_BTF_ID_OR_NULL,
> >       .arg2_btf_id    =3D &bpf_inode_storage_btf_ids[0],
> >  };
> > diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storag=
e.c
> > index d1af0c8f9ce4..adf6dfe0ba68 100644
> > --- a/kernel/bpf/bpf_task_storage.c
> > +++ b/kernel/bpf/bpf_task_storage.c
> > @@ -338,7 +338,7 @@ const struct bpf_func_proto bpf_task_storage_get_re=
cur_proto =3D {
> >       .gpl_only =3D false,
> >       .ret_type =3D RET_PTR_TO_MAP_VALUE_OR_NULL,
> >       .arg1_type =3D ARG_CONST_MAP_PTR,
> > -     .arg2_type =3D ARG_PTR_TO_BTF_ID,
> > +     .arg2_type =3D ARG_PTR_TO_BTF_ID_OR_NULL,
> >       .arg2_btf_id =3D &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
> >       .arg3_type =3D ARG_PTR_TO_MAP_VALUE_OR_NULL,
> >       .arg4_type =3D ARG_ANYTHING,
> > @@ -349,7 +349,7 @@ const struct bpf_func_proto bpf_task_storage_get_pr=
oto =3D {
> >       .gpl_only =3D false,
> >       .ret_type =3D RET_PTR_TO_MAP_VALUE_OR_NULL,
> >       .arg1_type =3D ARG_CONST_MAP_PTR,
> > -     .arg2_type =3D ARG_PTR_TO_BTF_ID,
> > +     .arg2_type =3D ARG_PTR_TO_BTF_ID_OR_NULL,
> >       .arg2_btf_id =3D &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
> >       .arg3_type =3D ARG_PTR_TO_MAP_VALUE_OR_NULL,
> >       .arg4_type =3D ARG_ANYTHING,
> > @@ -360,7 +360,7 @@ const struct bpf_func_proto bpf_task_storage_delete=
_recur_proto =3D {
> >       .gpl_only =3D false,
> >       .ret_type =3D RET_INTEGER,
> >       .arg1_type =3D ARG_CONST_MAP_PTR,
> > -     .arg2_type =3D ARG_PTR_TO_BTF_ID,
> > +     .arg2_type =3D ARG_PTR_TO_BTF_ID_OR_NULL,
> >       .arg2_btf_id =3D &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
> >  };
> >
> > @@ -369,6 +369,6 @@ const struct bpf_func_proto bpf_task_storage_delete=
_proto =3D {
> >       .gpl_only =3D false,
> >       .ret_type =3D RET_INTEGER,
> >       .arg1_type =3D ARG_CONST_MAP_PTR,
> > -     .arg2_type =3D ARG_PTR_TO_BTF_ID,
> > +     .arg2_type =3D ARG_PTR_TO_BTF_ID_OR_NULL,
> >       .arg2_btf_id =3D &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
> >  };
> > diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> > index 085025c7130a..d4172534dfa8 100644
> > --- a/net/core/bpf_sk_storage.c
> > +++ b/net/core/bpf_sk_storage.c
> > @@ -412,7 +412,7 @@ const struct bpf_func_proto bpf_sk_storage_get_trac=
ing_proto =3D {
> >       .gpl_only       =3D false,
> >       .ret_type       =3D RET_PTR_TO_MAP_VALUE_OR_NULL,
> >       .arg1_type      =3D ARG_CONST_MAP_PTR,
> > -     .arg2_type      =3D ARG_PTR_TO_BTF_ID,
> > +     .arg2_type      =3D ARG_PTR_TO_BTF_ID_OR_NULL,
> >       .arg2_btf_id    =3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> >       .arg3_type      =3D ARG_PTR_TO_MAP_VALUE_OR_NULL,
> >       .arg4_type      =3D ARG_ANYTHING,
> > @@ -424,7 +424,7 @@ const struct bpf_func_proto bpf_sk_storage_delete_t=
racing_proto =3D {
> >       .gpl_only       =3D false,
> >       .ret_type       =3D RET_INTEGER,
> >       .arg1_type      =3D ARG_CONST_MAP_PTR,
> > -     .arg2_type      =3D ARG_PTR_TO_BTF_ID,
> > +     .arg2_type      =3D ARG_PTR_TO_BTF_ID_OR_NULL,
> >       .arg2_btf_id    =3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> >       .allowed        =3D bpf_sk_storage_tracing_allowed,
> >  };
>
> Should we also add PTR_MAYBE_NULL to the ARG_PTR_TO_BTF_ID_SOCK_COMMON
> arg in bpf_sk_storage_get_proto and bpf_sk_storage_delete_proto?

It makes sense. I'd like to do it in the follow up though.
I haven't seen networking progs passing null-able pointer into these helper=
s.
Only tracing progs do.
I need to craft a test case, etc.
While this set is good to go imo.
