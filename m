Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6CC19627D
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 01:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbgC1Acb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 20:32:31 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:39804 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbgC1Aca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 20:32:30 -0400
Received: by mail-qv1-f67.google.com with SMTP id v38so5871753qvf.6;
        Fri, 27 Mar 2020 17:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tBoFcP2MRayTJTdOMjjEvhO91QmiVetcVDrFeYxN6m8=;
        b=aqcCLnHd6Y+Zu4JSw6vMQfTrxw4iGdRVzi+OLqlLP970hhTQIRlDkqWshcd3YIH2ao
         HA3sUjx4o7Cz/Dg4FFFjq9KYKo0iVnWI4jQ1LgdW3S1k9sFsZxBmVQAuph+Q+qpqYosj
         jnrbg/pdAwCWbJj4WnqQ8VyNYIDeoB6kZ6kXJ6CYhzZRtHL57Cqp6585hw5o5LQ9OntI
         fNvKZdBhyC9DCXNgn5yjA40H304FUzxe1dxon/jNi3cDdvwuoageUwbzP78drkVKEh3A
         lRWP0+d5C2L6/uxRzulkoHognE7m+jQvL4UAmlA/1wpIQ83ccdx4LL9iwku0WtJN0cSL
         0tog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tBoFcP2MRayTJTdOMjjEvhO91QmiVetcVDrFeYxN6m8=;
        b=hIieIaTLR0toBluhEZh7xrlW9cUvZVtgKrc8Ssk6DqgGRbC1gn0TMzy7W/7YjqKmlk
         HM8KwEfIWYfZY6gqBTpNnLJY//G+jQr+dDfMftkMhNGUeDje4ugIFNpDTj5ZvjZIol8P
         bGyyRJcl6hVtvLbDO++tj1RhxsClAAKODBst64q7AWE/fdJmQSil3K3Ee7TQPT2LA/se
         SJRDnQUwF/EweGOGNXPo+eik8oqu8r6qZ/rU/YT3T5owp/JYzR0r0nfR3pjRagCPS8P9
         4t5EZecTQUIRt2sUQqHe8Xfd/bIREBTPW5JDFIQgBX4T/pBFEkcMJttGpwGWuLQQeT8r
         9S+w==
X-Gm-Message-State: ANhLgQ2FEbz8sPjw8fPbd+Xo/xOecNlRyBhtU+HH9Bc44wZfiil4ujSy
        AKpP9750DzZ4lSasZAaKDF0cUtt0jtne/sQCOoEWFrt5
X-Google-Smtp-Source: ADFU+vsonNv8ZXK0zCRWho9P9hh5Scb6Os6IXJMOiT5TFhbthR5n5KIjixobCPudgMTkDk/Wg4mXjWVTYl+NAwoV+1w=
X-Received: by 2002:ad4:4182:: with SMTP id e2mr1836397qvp.247.1585355549435;
 Fri, 27 Mar 2020 17:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585323121.git.daniel@iogearbox.net> <c47d2346982693a9cf9da0e12690453aded4c788.1585323121.git.daniel@iogearbox.net>
In-Reply-To: <c47d2346982693a9cf9da0e12690453aded4c788.1585323121.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Mar 2020 17:32:18 -0700
Message-ID: <CAEf4BzbZiZwfae+B2gu4WkWVRoVkLJUYhFf0rorx0jVCf_kiQw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: add netns cookie and enable it for bpf
 cgroup hooks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martynas Pumputis <m@lambda.lt>,
        Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 8:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> In Cilium we're mainly using BPF cgroup hooks today in order to implement
> kube-proxy free Kubernetes service translation for ClusterIP, NodePort (*),
> ExternalIP, and LoadBalancer as well as HostPort mapping [0] for all traffic
> between Cilium managed nodes. While this works in its current shape and avoids
> packet-level NAT for inter Cilium managed node traffic, there is one major
> limitation we're facing today, that is, lack of netns awareness.
>
> In Kubernetes, the concept of Pods (which hold one or multiple containers)
> has been built around network namespaces, so while we can use the global scope
> of attaching to root BPF cgroup hooks also to our advantage (e.g. for exposing
> NodePort ports on loopback addresses), we also have the need to differentiate
> between initial network namespaces and non-initial one. For example, ExternalIP
> services mandate that non-local service IPs are not to be translated from the
> host (initial) network namespace as one example. Right now, we have an ugly
> work-around in place where non-local service IPs for ExternalIP services are
> not xlated from connect() and friends BPF hooks but instead via less efficient
> packet-level NAT on the veth tc ingress hook for Pod traffic.
>
> On top of determining whether we're in initial or non-initial network namespace
> we also have a need for a socket-cookie like mechanism for network namespaces
> scope. Socket cookies have the nice property that they can be combined as part
> of the key structure e.g. for BPF LRU maps without having to worry that the
> cookie could be recycled. We are planning to use this for our sessionAffinity
> implementation for services. Therefore, add a new bpf_get_netns_cookie() helper
> which would resolve both use cases at once: bpf_get_netns_cookie(NULL) would
> provide the cookie for the initial network namespace while passing the context
> instead of NULL would provide the cookie from the application's network namespace.
> We're using a hole, so no size increase; the assignment happens only once.
> Therefore this allows for a comparison on initial namespace as well as regular
> cookie usage as we have today with socket cookies. We could later on enable
> this helper for other program types as well as we would see need.
>
>   (*) Both externalTrafficPolicy={Local|Cluster} types
>   [0] https://github.com/cilium/cilium/blob/master/bpf/bpf_sock.c
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  include/linux/bpf.h            |  1 +
>  include/net/net_namespace.h    | 10 +++++++++
>  include/uapi/linux/bpf.h       | 16 ++++++++++++++-
>  kernel/bpf/verifier.c          | 16 +++++++++------
>  net/core/filter.c              | 37 ++++++++++++++++++++++++++++++++++
>  net/core/net_namespace.c       | 15 ++++++++++++++
>  tools/include/uapi/linux/bpf.h | 16 ++++++++++++++-
>  7 files changed, 103 insertions(+), 8 deletions(-)
>

[...]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 745f3cfdf3b2..cb30b34d1466 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3461,13 +3461,17 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
>                 expected_type = CONST_PTR_TO_MAP;
>                 if (type != expected_type)
>                         goto err_type;
> -       } else if (arg_type == ARG_PTR_TO_CTX) {
> +       } else if (arg_type == ARG_PTR_TO_CTX ||
> +                  arg_type == ARG_PTR_TO_CTX_OR_NULL) {
>                 expected_type = PTR_TO_CTX;
> -               if (type != expected_type)
> -                       goto err_type;
> -               err = check_ctx_reg(env, reg, regno);
> -               if (err < 0)
> -                       return err;
> +               if (!(register_is_null(reg) &&
> +                     arg_type == ARG_PTR_TO_CTX_OR_NULL)) {


Other parts of check_func_arg() have different pattern that doesn't
negate this complicated condition:

if (register_is_null(reg) && arg_type == ARG_PTR_TO_CTX_OR_NULL)
    ;
else {
    ...
}

It's marginally easier to follow, though still increases nestedness :(

> +                       if (type != expected_type)
> +                               goto err_type;
> +                       err = check_ctx_reg(env, reg, regno);
> +                       if (err < 0)
> +                               return err;
> +               }
>         } else if (arg_type == ARG_PTR_TO_SOCK_COMMON) {
>                 expected_type = PTR_TO_SOCK_COMMON;
>                 /* Any sk pointer can be ARG_PTR_TO_SOCK_COMMON */

[...]

> +static const struct bpf_func_proto bpf_get_netns_cookie_sock_addr_proto = {
> +       .func           = bpf_get_netns_cookie_sock_addr,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_CTX_OR_NULL,

Just for completeness sake, have you considered using two helpers -
one accepting context and other accepting nothing instead of adding
ARG_PTR_TO_CTX_OR_NULL? Would it be too bad?

> +};
> +

[...]

> +static atomic64_t cookie_gen;
> +
> +u64 net_gen_cookie(struct net *net)
> +{
> +       while (1) {
> +               u64 res = atomic64_read(&net->net_cookie);
> +
> +               if (res)
> +                       return res;
> +               res = atomic64_inc_return(&cookie_gen);
> +               atomic64_cmpxchg(&net->net_cookie, 0, res);

you'll always do extra atomic64_read, even if you succeed on the first
try. Why not:

while (1) {
   u64 res = atomic64_read(&net->net_cookie);
   if (res)
       return res;
   res = atomic64_inc_return(&cookie_gen);
   if (atomic64_cmpxchg(&net->net_cookie, 0, res) == 0)
      return res;
}

> +       }
> +}
> +

[...]
