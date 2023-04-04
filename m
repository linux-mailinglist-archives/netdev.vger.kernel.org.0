Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0E06D6E3B
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 22:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbjDDUo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 16:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbjDDUoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 16:44:25 -0400
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1218E44A2;
        Tue,  4 Apr 2023 13:44:24 -0700 (PDT)
Received: by mail-qv1-f42.google.com with SMTP id ev7so5875682qvb.5;
        Tue, 04 Apr 2023 13:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680641063; x=1683233063;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0HVHefUKQ8B9vvbZJ5DRzJdQ7JnRZ8j2CPowYhNt000=;
        b=6ZBBVN5dR4s8wPNEpHjVKcb2l7XPPdSp1yV7e6YR9pkhepAWnSLUQHt2jJhGJqoios
         HW8uMyEBroOYD/1Rm5D/tO+k/UhOQnK+mOFH/H6tuYuQDFhBr0h0ttOdsk/cCUoaDTjm
         AuxwN3lReSrFUR27MdWmQQTJXuwQ9TZXdOYPdPjQf5jZ1MWLsK70Y8mzlLwrKN9V8T3l
         pKzU/ybqk2cIIVS/IVuwrQyEWuPmCGUvYdnk5eH0gqX2ii/YAuK9rXfkfYx1XJXkOrm1
         yD9mb86guxU/KkiaASFk6/vpLEnqL4kuiybkhqqfh/O1DHUwJ7U1k6TQrjzhe8U12hrv
         X5dA==
X-Gm-Message-State: AAQBX9f13YnsBOG78nYxVSwIYsPa/7wn2nVxm5G/HHnj5x5r6QttbDW6
        20PZmpF0lfvO7SKBzIRC8BWhzSkZCyxZyA==
X-Google-Smtp-Source: AKy350a9CExc6NLhbfpr/LQAhC5iCh6ok58Zu64xGH+Op+G45gQmac+qeLjUHNGEzIy+30j0knKxeQ==
X-Received: by 2002:a05:6214:3005:b0:56e:9da4:82ff with SMTP id ke5-20020a056214300500b0056e9da482ffmr5520489qvb.50.1680641062852;
        Tue, 04 Apr 2023 13:44:22 -0700 (PDT)
Received: from maniforge ([2620:10d:c091:400::5:6933])
        by smtp.gmail.com with ESMTPSA id j22-20020a05620a289600b0074873dfe555sm3841390qkp.68.2023.04.04.13.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 13:44:22 -0700 (PDT)
Date:   Tue, 4 Apr 2023 15:44:19 -0500
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 4/8] bpf: Teach verifier that certain helpers
 accept NULL pointer.
Message-ID: <20230404204419.GC3896@maniforge>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404045029.82870-5-alexei.starovoitov@gmail.com>
 <20230404144652.GA3896@maniforge>
 <CAADnVQJEBJdXp11NE_zti0jBHbMmodDKh7YuBFGkN3q_wOHJtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJEBJdXp11NE_zti0jBHbMmodDKh7YuBFGkN3q_wOHJtA@mail.gmail.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 01:17:25PM -0700, Alexei Starovoitov wrote:
> On Tue, Apr 4, 2023 at 7:46 AM David Vernet <void@manifault.com> wrote:
> >
> > On Mon, Apr 03, 2023 at 09:50:25PM -0700, Alexei Starovoitov wrote:
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > bpf_[sk|inode|task|cgrp]_storage_[get|delete]() and bpf_get_socket_cookie() helpers
> > > perform run-time check that sk|inode|task|cgrp pointer != NULL.
> > > Teach verifier about this fact and allow bpf programs to pass
> > > PTR_TO_BTF_ID | PTR_MAYBE_NULL into such helpers.
> > > It will be used in the subsequent patch that will do
> > > bpf_sk_storage_get(.., skb->sk, ...);
> > > Even when 'skb' pointer is trusted the 'sk' pointer may be NULL.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >  kernel/bpf/bpf_cgrp_storage.c  | 4 ++--
> > >  kernel/bpf/bpf_inode_storage.c | 4 ++--
> > >  kernel/bpf/bpf_task_storage.c  | 8 ++++----
> > >  net/core/bpf_sk_storage.c      | 4 ++--
> > >  net/core/filter.c              | 2 +-
> > >  5 files changed, 11 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/kernel/bpf/bpf_cgrp_storage.c b/kernel/bpf/bpf_cgrp_storage.c
> > > index d17d5b694668..d44fe8dd9732 100644
> > > --- a/kernel/bpf/bpf_cgrp_storage.c
> > > +++ b/kernel/bpf/bpf_cgrp_storage.c
> > > @@ -224,7 +224,7 @@ const struct bpf_func_proto bpf_cgrp_storage_get_proto = {
> > >       .gpl_only       = false,
> > >       .ret_type       = RET_PTR_TO_MAP_VALUE_OR_NULL,
> > >       .arg1_type      = ARG_CONST_MAP_PTR,
> > > -     .arg2_type      = ARG_PTR_TO_BTF_ID,
> > > +     .arg2_type      = ARG_PTR_TO_BTF_ID_OR_NULL,
> > >       .arg2_btf_id    = &bpf_cgroup_btf_id[0],
> > >       .arg3_type      = ARG_PTR_TO_MAP_VALUE_OR_NULL,
> > >       .arg4_type      = ARG_ANYTHING,
> > > @@ -235,6 +235,6 @@ const struct bpf_func_proto bpf_cgrp_storage_delete_proto = {
> > >       .gpl_only       = false,
> > >       .ret_type       = RET_INTEGER,
> > >       .arg1_type      = ARG_CONST_MAP_PTR,
> > > -     .arg2_type      = ARG_PTR_TO_BTF_ID,
> > > +     .arg2_type      = ARG_PTR_TO_BTF_ID_OR_NULL,
> > >       .arg2_btf_id    = &bpf_cgroup_btf_id[0],
> > >  };
> > > diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
> > > index e17ad581b9be..a4d93df78c75 100644
> > > --- a/kernel/bpf/bpf_inode_storage.c
> > > +++ b/kernel/bpf/bpf_inode_storage.c
> > > @@ -229,7 +229,7 @@ const struct bpf_func_proto bpf_inode_storage_get_proto = {
> > >       .gpl_only       = false,
> > >       .ret_type       = RET_PTR_TO_MAP_VALUE_OR_NULL,
> > >       .arg1_type      = ARG_CONST_MAP_PTR,
> > > -     .arg2_type      = ARG_PTR_TO_BTF_ID,
> > > +     .arg2_type      = ARG_PTR_TO_BTF_ID_OR_NULL,
> > >       .arg2_btf_id    = &bpf_inode_storage_btf_ids[0],
> > >       .arg3_type      = ARG_PTR_TO_MAP_VALUE_OR_NULL,
> > >       .arg4_type      = ARG_ANYTHING,
> > > @@ -240,6 +240,6 @@ const struct bpf_func_proto bpf_inode_storage_delete_proto = {
> > >       .gpl_only       = false,
> > >       .ret_type       = RET_INTEGER,
> > >       .arg1_type      = ARG_CONST_MAP_PTR,
> > > -     .arg2_type      = ARG_PTR_TO_BTF_ID,
> > > +     .arg2_type      = ARG_PTR_TO_BTF_ID_OR_NULL,
> > >       .arg2_btf_id    = &bpf_inode_storage_btf_ids[0],
> > >  };
> > > diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
> > > index d1af0c8f9ce4..adf6dfe0ba68 100644
> > > --- a/kernel/bpf/bpf_task_storage.c
> > > +++ b/kernel/bpf/bpf_task_storage.c
> > > @@ -338,7 +338,7 @@ const struct bpf_func_proto bpf_task_storage_get_recur_proto = {
> > >       .gpl_only = false,
> > >       .ret_type = RET_PTR_TO_MAP_VALUE_OR_NULL,
> > >       .arg1_type = ARG_CONST_MAP_PTR,
> > > -     .arg2_type = ARG_PTR_TO_BTF_ID,
> > > +     .arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
> > >       .arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
> > >       .arg3_type = ARG_PTR_TO_MAP_VALUE_OR_NULL,
> > >       .arg4_type = ARG_ANYTHING,
> > > @@ -349,7 +349,7 @@ const struct bpf_func_proto bpf_task_storage_get_proto = {
> > >       .gpl_only = false,
> > >       .ret_type = RET_PTR_TO_MAP_VALUE_OR_NULL,
> > >       .arg1_type = ARG_CONST_MAP_PTR,
> > > -     .arg2_type = ARG_PTR_TO_BTF_ID,
> > > +     .arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
> > >       .arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
> > >       .arg3_type = ARG_PTR_TO_MAP_VALUE_OR_NULL,
> > >       .arg4_type = ARG_ANYTHING,
> > > @@ -360,7 +360,7 @@ const struct bpf_func_proto bpf_task_storage_delete_recur_proto = {
> > >       .gpl_only = false,
> > >       .ret_type = RET_INTEGER,
> > >       .arg1_type = ARG_CONST_MAP_PTR,
> > > -     .arg2_type = ARG_PTR_TO_BTF_ID,
> > > +     .arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
> > >       .arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
> > >  };
> > >
> > > @@ -369,6 +369,6 @@ const struct bpf_func_proto bpf_task_storage_delete_proto = {
> > >       .gpl_only = false,
> > >       .ret_type = RET_INTEGER,
> > >       .arg1_type = ARG_CONST_MAP_PTR,
> > > -     .arg2_type = ARG_PTR_TO_BTF_ID,
> > > +     .arg2_type = ARG_PTR_TO_BTF_ID_OR_NULL,
> > >       .arg2_btf_id = &btf_tracing_ids[BTF_TRACING_TYPE_TASK],
> > >  };
> > > diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> > > index 085025c7130a..d4172534dfa8 100644
> > > --- a/net/core/bpf_sk_storage.c
> > > +++ b/net/core/bpf_sk_storage.c
> > > @@ -412,7 +412,7 @@ const struct bpf_func_proto bpf_sk_storage_get_tracing_proto = {
> > >       .gpl_only       = false,
> > >       .ret_type       = RET_PTR_TO_MAP_VALUE_OR_NULL,
> > >       .arg1_type      = ARG_CONST_MAP_PTR,
> > > -     .arg2_type      = ARG_PTR_TO_BTF_ID,
> > > +     .arg2_type      = ARG_PTR_TO_BTF_ID_OR_NULL,
> > >       .arg2_btf_id    = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> > >       .arg3_type      = ARG_PTR_TO_MAP_VALUE_OR_NULL,
> > >       .arg4_type      = ARG_ANYTHING,
> > > @@ -424,7 +424,7 @@ const struct bpf_func_proto bpf_sk_storage_delete_tracing_proto = {
> > >       .gpl_only       = false,
> > >       .ret_type       = RET_INTEGER,
> > >       .arg1_type      = ARG_CONST_MAP_PTR,
> > > -     .arg2_type      = ARG_PTR_TO_BTF_ID,
> > > +     .arg2_type      = ARG_PTR_TO_BTF_ID_OR_NULL,
> > >       .arg2_btf_id    = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> > >       .allowed        = bpf_sk_storage_tracing_allowed,
> > >  };
> >
> > Should we also add PTR_MAYBE_NULL to the ARG_PTR_TO_BTF_ID_SOCK_COMMON
> > arg in bpf_sk_storage_get_proto and bpf_sk_storage_delete_proto?
> 
> It makes sense. I'd like to do it in the follow up though.
> I haven't seen networking progs passing null-able pointer into these helpers.
> Only tracing progs do.
> I need to craft a test case, etc.

Sounds good

> While this set is good to go imo.

Agreed, the series LGTM.
