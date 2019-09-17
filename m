Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAEA8B4635
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 06:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfIQEEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 00:04:49 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:47033 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfIQEEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 00:04:49 -0400
Received: by mail-qt1-f195.google.com with SMTP id u22so2598851qtq.13;
        Mon, 16 Sep 2019 21:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pctghK9G0OAh8NYk0H+4z3PFv/uq7ohY2TuisEW5TQ0=;
        b=XczL2/iDpFRTfWv9FYYXa1o6klUhWcax3pDf+uBcrctRYdheNwppHgUcr7c0+kEeKU
         Op+lYI/3F0I7YIKv6ZbtNZbj76hv2o7MTHdEnNbwroTuoOThnnRkQy33N9Ajb3Nk64Pl
         nj8tGL9GhzYPhikYNaXlfdd9giuxqi9k3b1SAaXoUIoN0CuazDWXAogXtPw/D2G62QWw
         wymw0yuFoBUZt0GhgQWQDVsFqw0XH2wSpz1xaCeNYyzPss410fSYqGShYf62WUXeLBmT
         VWykSMtaBZOb7Ng4cVjSuALgdzyS6ltitb0y8itp7nLcezPabTAnndYhV3UG3Ou5C5kE
         gGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pctghK9G0OAh8NYk0H+4z3PFv/uq7ohY2TuisEW5TQ0=;
        b=CiHzszLy4FvGPS9GDtt0S+de3pho2x9bp48WZEK1FGse/DeM7jK0UjExXdcFPEK27y
         klozhwv/OGdsVN52C8MXPsjuKC6Ng6Ykb45Qu0EImqNGBuecD/lIlxTBqW+tAVA3V9w4
         jghLRu6VGHkXclX+UxRVqNNOUdhK6ydNXH/xe5ogUd04fSLSsoZ1vmGBxnwcjeMCSYe/
         273wRrAHV4vcwH98720NeoxuZJQulxmVzw2ooMeyrEnQMnVQHoCnVTFJM/XVcobTkbrE
         VZ1HmxMN8QjmEUu2b7Iw4BapmZMwoA1MLIvvM2TGorRvo7yJonwvfvP+gWCt/FsMHSS1
         az8g==
X-Gm-Message-State: APjAAAWPQgFaoAK08vOs8xs16G5lb7n5lzPB+sCTsegntBXy+io0eJF9
        ukmxuMDTkxxDMWGWsQtMxhgOeepyn/e11SUAGcQ=
X-Google-Smtp-Source: APXvYqyeeCYiX4U53AQ2VheOamKuKW5sCQlcICDkB5p1tyIR4eJXs0NB0Q9x8XBAVDpU68tEAh7kVM+6kzHG3sw7Mc8=
X-Received: by 2002:a0c:e48b:: with SMTP id n11mr1543342qvl.38.1568693087891;
 Mon, 16 Sep 2019 21:04:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190911190218.22628-1-danieltimlee@gmail.com>
In-Reply-To: <20190911190218.22628-1-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Sep 2019 21:04:36 -0700
Message-ID: <CAEf4Bza7tFdDP0=Nk4UVtWn68Kr7oYZziUodN40a=ZKne4-dEQ@mail.gmail.com>
Subject: Re: [bpf-next,v3] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 2:33 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> to 600. To make this size flexible, a new map 'pcktsz' is added.
>
> By updating new packet size to this map from the userland,
> xdp_adjust_tail_kern.o will use this value as a new max_pckt_size.
>
> If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> will be 600 as a default.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> ---
> Changes in v2:
>     - Change the helper to fetch map from 'bpf_map__next' to
>     'bpf_object__find_map_fd_by_name'.
>
>  samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
>  samples/bpf/xdp_adjust_tail_user.c | 28 ++++++++++++++++++++++------
>  2 files changed, 41 insertions(+), 10 deletions(-)
>
> diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> index 411fdb21f8bc..d6d84ffe6a7a 100644
> --- a/samples/bpf/xdp_adjust_tail_kern.c
> +++ b/samples/bpf/xdp_adjust_tail_kern.c
> @@ -25,6 +25,13 @@
>  #define ICMP_TOOBIG_SIZE 98
>  #define ICMP_TOOBIG_PAYLOAD_SIZE 92
>
> +struct bpf_map_def SEC("maps") pcktsz = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .key_size = sizeof(__u32),
> +       .value_size = sizeof(__u32),
> +       .max_entries = 1,
> +};
> +

Hey Daniel,

This looks like an ideal use case for global variables on BPF side. I
think it's much cleaner and will make BPF side of things simpler.
Would you mind giving global data a spin instead of adding this map?

>  struct bpf_map_def SEC("maps") icmpcnt = {
>         .type = BPF_MAP_TYPE_ARRAY,
>         .key_size = sizeof(__u32),
> @@ -64,7 +71,8 @@ static __always_inline void ipv4_csum(void *data_start, int data_size,
>         *csum = csum_fold_helper(*csum);
>  }
>

[...]
