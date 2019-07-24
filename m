Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0DF74155
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfGXWWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:22:00 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46003 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfGXWWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:22:00 -0400
Received: by mail-qk1-f196.google.com with SMTP id s22so35010191qkj.12;
        Wed, 24 Jul 2019 15:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uTlIMXz8vE0R0watOd38b3ZihZqTqNBzw3sHVo5+R3I=;
        b=efSZKX7LrCLzTnYO0h2Xl9j3bI0QwbBnv2Nz9EcUk4WGfYKeoAtsN+VbuQpFmYGNBB
         j21/mF3OFs6tLeVXtyCcC2OlPr2cz0uhpjmMQwdbO6EYelcFb0JVoCHyeeWdiebOkJls
         iMAqTnthcpl1clWhZUdUBnbcg1q9sLzQknK62qNmBbRkEdSnQhi2eDuroxBqEkmg2QqE
         vPc6wS59iGtCGqkf1FNaYjSzbvnsiZLob6ScXsyXSdsXkhNmk4hDkV8XiJIaF23CU/pR
         jXLYsAedsefaYLXOCk7lS29Ds9CB7L9Wq5PmL508TabNKnk+Y9kAi+9Y0ypdr4o4Gx0B
         Lc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uTlIMXz8vE0R0watOd38b3ZihZqTqNBzw3sHVo5+R3I=;
        b=oVcB8k0dhknCog4IMeS5IS5+Q+JyzlNUBd1+e5eCv40WgSbDHU0P0ALPXOVi4Mn6f5
         +6JUjvy1mPhF95EfOPGo6IHUKiBuwZbXmTCa60hkq6MNrAS6ZU7sySVBQENV87+ryosG
         GPhcdQ6L2CoXNjk9Rkmbgf5/MILKLArSPz12E0idKBXipS43wRwtLsRnneJzDQKCbULo
         Zi+syb23GmEyU2RrAJ77xOfBVfKx+MCbMZAIA3jCcq30IhMSLHoHci/lzJqb+tttg2aN
         qsrKjUbIQbU4FxNVCXMJ3XNo/uxe1AWjhGOiPwQY+5+gNmMtmZabvtzkpyMqSETvw/nA
         ltQg==
X-Gm-Message-State: APjAAAVkJs5JYrjry+OPS1Z/zDFbC8uGORcaKMUasq2BRz+YQyX6Fzpu
        VepAls8+t2eZ6fKhCIzWQdjlQ4R9Yfj3tSPuBr8=
X-Google-Smtp-Source: APXvYqx3HfS93c0iWKEj8ryYIjN4oCoNxNRRTYKQ6f2bYJvjcflpGchAYif6mqPfzbiG3DPBSfDRAaTQMIUBS8uyaCc=
X-Received: by 2002:a37:6984:: with SMTP id e126mr54980217qkc.487.1564006919222;
 Wed, 24 Jul 2019 15:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com> <20190724170018.96659-2-sdf@google.com>
In-Reply-To: <20190724170018.96659-2-sdf@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 15:21:47 -0700
Message-ID: <CAPhsuW6wq_6Pf80yV7oEb0uW7Xv9=UKAbTm4XJLyKAtSmDzCBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/7] bpf/flow_dissector: pass input flags to BPF
 flow dissector program
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:11 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> C flow dissector supports input flags that tell it to customize parsing
> by either stopping early or trying to parse as deep as possible. Pass
> those flags to the BPF flow dissector so it can make the same
> decisions. In the next commits I'll add support for those flags to
> our reference bpf_flow.c
>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/skbuff.h       | 2 +-
>  include/net/flow_dissector.h | 4 ----
>  include/uapi/linux/bpf.h     | 5 +++++
>  net/bpf/test_run.c           | 2 +-
>  net/core/flow_dissector.c    | 5 +++--
>  5 files changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 718742b1c505..9b7a8038beec 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1271,7 +1271,7 @@ static inline int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
>
>  struct bpf_flow_dissector;
>  bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
> -                     __be16 proto, int nhoff, int hlen);
> +                     __be16 proto, int nhoff, int hlen, unsigned int flags);
>
>  bool __skb_flow_dissect(const struct net *net,
>                         const struct sk_buff *skb,
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 90bd210be060..3e2642587b76 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -253,10 +253,6 @@ enum flow_dissector_key_id {
>         FLOW_DISSECTOR_KEY_MAX,
>  };
>
> -#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG                BIT(0)
> -#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL    BIT(1)
> -#define FLOW_DISSECTOR_F_STOP_AT_ENCAP         BIT(2)
> -
>  struct flow_dissector_key {
>         enum flow_dissector_key_id key_id;
>         size_t offset; /* offset of struct flow_dissector_key_*
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index fa1c753dcdbc..b4ad19bd6aa8 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3507,6 +3507,10 @@ enum bpf_task_fd_type {
>         BPF_FD_TYPE_URETPROBE,          /* filename + offset */
>  };
>
> +#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG                (1U << 0)
> +#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL    (1U << 1)
> +#define FLOW_DISSECTOR_F_STOP_AT_ENCAP         (1U << 2)

Do we have to move these?

Thanks,
Song
