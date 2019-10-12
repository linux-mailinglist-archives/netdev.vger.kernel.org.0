Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A39ED4B4E
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 02:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfJLALN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 20:11:13 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43680 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfJLALN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 20:11:13 -0400
Received: by mail-lj1-f194.google.com with SMTP id n14so11382382ljj.10;
        Fri, 11 Oct 2019 17:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UmqtRAbUHR0Wk9FzarhOPn9Pl/ebzWZj21JJy76ULQ4=;
        b=IVsjSMXhdcPGermy5FcJ+oGVwALObfe/BBcIRmJPTpHK/zSqguV8YhePONAIDUGJrA
         I8bU8sc55b2QKsrwRA9g4b6GWOcjYLhYuro4UqLv6kQp/9MCAxJjTCPc4WR4q5AAo8Gy
         FoDUIcfXWMC+qJMOus5CFbNI9oz1g9JVVEs8BNAEBwIppHgxESjfC6Q0EizH3rxpdkiq
         OyYJRww8oVgyvu7LbI+ZT2yPVPuhjgeuRryVvKmWC7WOJiEIMETbeU8Z5OimLnQBDDi6
         ZobGwrjGp0Rkj1bEcfm4ngiWWRdI2BOK1JyLNVWojHu0f/tqnkk48gDf7PoRb36pfKbc
         bTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UmqtRAbUHR0Wk9FzarhOPn9Pl/ebzWZj21JJy76ULQ4=;
        b=oEYaYgoipRPLi6XRZ626qIuBPL10AfqePO7A6bMvBbxcy1W2qAar2ac7S1OpGrITty
         KNxyDw/F7Ym8EwOcpscsXIS5I1gXYeq6NJXw05G5YcIIHD52qfHMIgOyROLNhBswFtyP
         p+cybwHCrxtyxqkKhCvD9dQVNvxF6famSCkgd8hu3RNgWKbUbG6cY+AkB0YVVozye+AB
         nKYDQLdr5y/WjYp9fxcpQqnuOxmpVZ9eppOfTGfaMoinXEpdR7c+7ANh8+aO1CmpVw74
         kzRr8Go+55ce/+EWCgFbD3c2MobxoBQv6Jzlc/X0fvP5kj3tVOjfZR9QegYf1Ur6GKD7
         cpGA==
X-Gm-Message-State: APjAAAVlKmGJ3hMaO92rPi95cHNS5+smYV4Z7ILeiaNRtNfQ3dL241kN
        WwwajYUvKdnXkvjMzLwz6MrJCIDDYI2hB7D1Mes=
X-Google-Smtp-Source: APXvYqz6IogaOtQbdYXCK/XDaULoLI7vfXdqXeaiYV3aEf/a23CU3l1fcQCSRaAwDpqLx5mugJnmBZiziildECgvsx0=
X-Received: by 2002:a2e:6c15:: with SMTP id h21mr10634389ljc.10.1570839069328;
 Fri, 11 Oct 2019 17:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <20191011162124.52982-1-sdf@google.com>
In-Reply-To: <20191011162124.52982-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 11 Oct 2019 17:10:58 -0700
Message-ID: <CAADnVQLKPLXej_v7ymv3yJakoFLGeQwdZOJ5cZmp7xqOxfebqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: preserve command of the process that
 loaded the program
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 9:21 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Even though we have the pointer to user_struct and can recover
> uid of the user who has created the program, it usually contains
> 0 (root) which is not very informative. Let's store the comm of the
> calling process and export it via bpf_prog_info. This should help
> answer the question "which process loaded this particular program".
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf.h      | 1 +
>  include/uapi/linux/bpf.h | 2 ++
>  kernel/bpf/syscall.c     | 4 ++++
>  3 files changed, 7 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5b9d22338606..b03ea396afe5 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -421,6 +421,7 @@ struct bpf_prog_aux {
>                 struct work_struct work;
>                 struct rcu_head rcu;
>         };
> +       char created_by_comm[BPF_CREATED_COMM_LEN];
>  };
>
>  struct bpf_array {
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a65c3b0c6935..4e883ecbba1e 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -326,6 +326,7 @@ enum bpf_attach_type {
>  #define BPF_F_NUMA_NODE                (1U << 2)
>
>  #define BPF_OBJ_NAME_LEN 16U
> +#define BPF_CREATED_COMM_LEN   16U

Nack.
16 bytes is going to be useless.
We found it the hard way with prog_name.
If you want to embed additional debug information
please use BTF for that.
