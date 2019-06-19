Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD764C136
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 21:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730066AbfFSTIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 15:08:20 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44674 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfFSTIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 15:08:20 -0400
Received: by mail-qt1-f196.google.com with SMTP id x47so291812qtk.11;
        Wed, 19 Jun 2019 12:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/NuX+3WkUD8MPqANFCqpmo76cOhvITNkLzdl91UF+IU=;
        b=dvBuK+hN7ZFK3WmZdGGBaTeYz0CTAFLkM7kx3R+awqIzgrsJQIng6FbpsRJfYdyqEp
         av1ax6F5N14h0nIez3tsA6GD59qvszwBNMigOsh9bWeS6Gw1iZUPUuye/OandwecczK3
         m85N8o2xD+OMO3011fWa0Bn/KkLCFIzSgbGjui0/Jk4vZlNm7PxLMdXNk9RvALaRS9Zi
         24S8rjsXrrru+b/P8hi04y+UB8NkfdSLg79w+qknxzFBxxW3huHD151NF2/B+v7A7PrC
         HLjWQVJ0bYMvtW8k67mq7GjK/DD2cPk/kNhg9I90eyqm6j+iWFL7ZABZ1ol0Nu+VkVHB
         ALzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/NuX+3WkUD8MPqANFCqpmo76cOhvITNkLzdl91UF+IU=;
        b=U41RwmzgOuq6DwHW8WgvrACiC2yyuFkqM1QC5lTgYc75uWh7LHw1TZsLpTj0m4TuQI
         rotcJjS6bCFrWx4M21FvLC4cJM3nXAVgMPoqFaQUTQUiod51yduzVWUAU3K7icEr0VRx
         l3ZtHpF2LDFJnQrw++UDHkB08T6jBD2qa3frHpgZLqNF7cSww28/iUdqWYMNigpTfwvg
         bxgnsX/pdXsTzk89eClpUEV3mR2jzroejh1s8S14cA/K3QZDQqn0Jn3R8wRqLo8s049K
         xFpBYTqYOZ2j7EDouHta57fETh0LxZT1nhU30FFFFSKM2B+EtWlRBQ5PV2AHGa5bZKTt
         XrCw==
X-Gm-Message-State: APjAAAXIZPViZ/rt+OkigbgXRd6T49ou1eK4gYQHoDycP4A2+M9qHFP6
        saeex0mZKmnw+scGC9FKG34RU9XSO5NgyIu6W+g=
X-Google-Smtp-Source: APXvYqwmh86CGNfbPYHjkFMIcguxAOBFlx1bU2wpGoJ38+Rs/i1L5bWESEOQBTQ9mILAtFEKG3whilsLSaMhrUoOtRE=
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr22103594qvv.38.1560971299127;
 Wed, 19 Jun 2019 12:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190619190105.261533-1-sdf@google.com>
In-Reply-To: <20190619190105.261533-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Jun 2019 12:08:07 -0700
Message-ID: <CAEf4BzZ73LvgvQDLaNm3YwUwCbfr-RQ14cACw+wcpkfExmEnJA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix NULL deref in btf_type_is_resolve_source_only
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 12:01 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Commit 1dc92851849c ("bpf: kernel side support for BTF Var and DataSec")
> added invocations of btf_type_is_resolve_source_only before
> btf_type_nosize_or_null which checks for the NULL pointer.
> Swap the order of btf_type_nosize_or_null and
> btf_type_is_resolve_source_only to make sure the do the NULL pointer
> check first.
>
> Fixes: 1dc92851849c ("bpf: kernel side support for BTF Var and DataSec")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/btf.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index cad09858a5f2..546ebee39e2a 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -1928,8 +1928,8 @@ static int btf_array_resolve(struct btf_verifier_env *env,
>         /* Check array->index_type */
>         index_type_id = array->index_type;
>         index_type = btf_type_by_id(btf, index_type_id);
> -       if (btf_type_is_resolve_source_only(index_type) ||
> -           btf_type_nosize_or_null(index_type)) {
> +       if (btf_type_nosize_or_null(index_type) ||
> +           btf_type_is_resolve_source_only(index_type)) {
>                 btf_verifier_log_type(env, v->t, "Invalid index");
>                 return -EINVAL;
>         }
> @@ -1948,8 +1948,8 @@ static int btf_array_resolve(struct btf_verifier_env *env,
>         /* Check array->type */
>         elem_type_id = array->type;
>         elem_type = btf_type_by_id(btf, elem_type_id);
> -       if (btf_type_is_resolve_source_only(elem_type) ||
> -           btf_type_nosize_or_null(elem_type)) {
> +       if (btf_type_nosize_or_null(elem_type) ||
> +           btf_type_is_resolve_source_only(elem_type)) {
>                 btf_verifier_log_type(env, v->t,
>                                       "Invalid elem");
>                 return -EINVAL;
> @@ -2170,8 +2170,8 @@ static int btf_struct_resolve(struct btf_verifier_env *env,
>                 const struct btf_type *member_type = btf_type_by_id(env->btf,
>                                                                 member_type_id);
>
> -               if (btf_type_is_resolve_source_only(member_type) ||
> -                   btf_type_nosize_or_null(member_type)) {
> +               if (btf_type_nosize_or_null(member_type) ||
> +                   btf_type_is_resolve_source_only(member_type)) {
>                         btf_verifier_log_member(env, v->t, member,
>                                                 "Invalid member");
>                         return -EINVAL;
> --
> 2.22.0.410.gd8fdbe21b5-goog
>
