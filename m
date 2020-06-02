Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5971EBED1
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 17:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgFBPOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 11:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgFBPOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 11:14:07 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBD5C08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 08:14:06 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id v3so2233795oot.1
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 08:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WM9ZlROIbiUXx7qTgo99BGmB7kDyUeyoS1N3IBC6Bao=;
        b=atpPG86BmqAUTW1CU9GVZK5KayQYaIiWp5eMiWHphmlE0bCJGM34DmCOqnCQWOiB0+
         JLhTP2DhKRDFbIKwlOIxkE1EXUvF2VvsLdPnYUh0Jd0i2hKPewf5OW8i4ufXt3hGAZUI
         HDSmZHFV4EnSE+NrBkasADrktLTvEfmszLOf4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WM9ZlROIbiUXx7qTgo99BGmB7kDyUeyoS1N3IBC6Bao=;
        b=YPjlrNiBGtsPaZ9Q+DlQcC8J5hHBN0m4Mhl4R43a99FyYXOuPbQfHRnQb4FhDqMOWe
         j/Z7rIQTtGHJMgl2ac6amKLYUZ6c5wYgWfZt1g9ineluGfeTdbacWr+JwReHKpjO3riF
         B278JUGExWq5Btwn5GPlEFO/7JulCNFMgeqYDzrm325lI0ZDGwAVLFyq41yuaWKrqL3R
         HkYXy4lwGExQXUBlPZV92HfIF6hoNq3tnAw91PBoeSPqgrkj2YIuWquN/eqYWBS/8dHU
         pLu1JgVkZrDq/047tB7HEi+YtoXRJKmSe2vyQx6O5gQec2mlrwceeshnMUuHw317tpbH
         47gQ==
X-Gm-Message-State: AOAM530Eq1Wq6MDtp24zZ67ImPlCi8NFRw+/VrwqP0kzWJMRgNLvL9Hf
        7rEtNO0ZCUtfm8ko7vZObnYJHIWvIjrEi7KGJQ0j1g==
X-Google-Smtp-Source: ABdhPJy//7QeqWW3yefX3QKoJHBC2mUJPXpqn3ZxMe6hisK59hdcGF8hmDIkrMsQNfS4A66v+DuT1PhRsfkst6HQBqQ=
X-Received: by 2002:a4a:d292:: with SMTP id h18mr11791661oos.80.1591110845414;
 Tue, 02 Jun 2020 08:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1591108731.git.daniel@iogearbox.net> <e7458f10e3f3d795307cbc5ad870112671d9c6f7.1591108731.git.daniel@iogearbox.net>
In-Reply-To: <e7458f10e3f3d795307cbc5ad870112671d9c6f7.1591108731.git.daniel@iogearbox.net>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 2 Jun 2020 16:13:54 +0100
Message-ID: <CACAyw998Yy6NBJbSi+RfUofpKQYjYA78HGmWEqDTm1B+BkvuOw@mail.gmail.com>
Subject: Re: [PATCH bpf 3/3] bpf, selftests: Adapt cls_redirect to call
 csum_level helper
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jun 2020 at 15:58, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Adapt bpf_skb_adjust_room() to pass in BPF_F_ADJ_ROOM_NO_CSUM_RESET flag and
> use the new bpf_csum_level() helper to inc/dec the checksum level by one after
> the encap/decap.

Just to be on the safe side: we go from
    | ETH | IP | UDP | GUE | IP | TCP |
to
    | ETH | IP | TCP |
by cutting | IP | UDP | GUE | after the Ethernet header.

Since IP is never included in csum_level and because GUE is not eligible for
CHECKSUM_UNNECESSARY we only need to do csum_level-- once, not twice.

If that is correct:
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>

>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  tools/testing/selftests/bpf/progs/test_cls_redirect.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> index 1668b993eb86..f0b72e86bee5 100644
> --- a/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> +++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> @@ -380,9 +380,10 @@ static ret_t accept_locally(struct __sk_buff *skb, encap_headers_t *encap)
>         }
>
>         if (bpf_skb_adjust_room(skb, -encap_overhead, BPF_ADJ_ROOM_MAC,
> -                               BPF_F_ADJ_ROOM_FIXED_GSO)) {
> +                               BPF_F_ADJ_ROOM_FIXED_GSO |
> +                               BPF_F_ADJ_ROOM_NO_CSUM_RESET) ||
> +           bpf_csum_level(skb, BPF_CSUM_LEVEL_DEC))
>                 return TC_ACT_SHOT;
> -       }
>
>         return bpf_redirect(skb->ifindex, BPF_F_INGRESS);
>  }
> @@ -472,7 +473,9 @@ static ret_t forward_with_gre(struct __sk_buff *skb, encap_headers_t *encap,
>         }
>
>         if (bpf_skb_adjust_room(skb, delta, BPF_ADJ_ROOM_NET,
> -                               BPF_F_ADJ_ROOM_FIXED_GSO)) {
> +                               BPF_F_ADJ_ROOM_FIXED_GSO |
> +                               BPF_F_ADJ_ROOM_NO_CSUM_RESET) ||
> +           bpf_csum_level(skb, BPF_CSUM_LEVEL_INC)) {
>                 metrics->errors_total_encap_adjust_failed++;
>                 return TC_ACT_SHOT;
>         }
> --
> 2.21.0
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
