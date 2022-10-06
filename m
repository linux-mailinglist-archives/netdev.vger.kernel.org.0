Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3E45F5F75
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiJFDUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiJFDUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:20:00 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0505FC8;
        Wed,  5 Oct 2022 20:19:42 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id 13so1736409ejn.3;
        Wed, 05 Oct 2022 20:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BqX+FTc4QFCw82zWORUhB2dUCyhxfvFjXd8OwwXnw4c=;
        b=Aj8o3v6oucle7bXN0iFfpAOPI9Vzol+jzu8+tV+VA8HB2DRpzeb4SMyUm5hz9M0lwc
         X4c+f3Hyc/k7zrYBePEV2odTODN+Lkycbr3A4XLttvZUzWbXaN8CC/rFy23GdMkdHXLN
         cu1qk5sqftQL2HxoHxhuKcZI2gALA1RZWoFmlC04/bKAhcr6JQ2LXAmxHH+8teBrRQP5
         qB9DiU3XyRVx2xOAKGHTEMuZb3SR1sEbfhgb6BIx0cpMwl4WQZhUd2fHeg3jF96L72Dl
         c7eDyBdjTSPniB7KSaji7RhjDLAvyGp2qUPUQ9H6MgmsPeWfAlIIOjxyof4SErse3Bn6
         lkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BqX+FTc4QFCw82zWORUhB2dUCyhxfvFjXd8OwwXnw4c=;
        b=gWzLWj4dVFn/6cPQLgSWO54iDe+hcKBj0KCLd7pbkGVtIYN/2v8CzexdRpHDH/VPsA
         uS46lt8Imu/nJrIgRtXDRNSKHbWTPCuUQab1EtJaJBShBUntml3ayjzJxHO909dCo/8a
         rjkKyk0sbFwJJw0DLlLu1SirY46PU55cP5h19UDZwA9XAnXpD/pMHA/1vo5/tXAYJwn7
         ICwmx+091kSi4P5KLm0cFYe+1NqpSkWImL6YeW0rW1F3yKOTyLeC8dqNgr84JjFnLID8
         HUkBgDMiSRb3xf/RYhkKHzuaZ8pM7bN4U55Y9S98SDcgm4kwHUYurijBQDW/zqkFLfGm
         fd2A==
X-Gm-Message-State: ACrzQf3VflctbDTqsb5pW+gXwkGZGt59NRMKYQslqCynDj+KardnDeJl
        AvoDhjPjSveSUIrun07Uu7tFyUC8CTolpyYmiQ8=
X-Google-Smtp-Source: AMsMyM56vEFyxEwKy1zLBgvy1XsUGt+Y2CTwDHEiC3xZQASqiPZebsdaOJ2WRE4qpdPZvhYlL17noXjXEJ+i4TVPImI=
X-Received: by 2002:a17:907:7245:b0:78d:1de4:7033 with SMTP id
 ds5-20020a170907724500b0078d1de47033mr2174903ejc.114.1665026379586; Wed, 05
 Oct 2022 20:19:39 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-4-daniel@iogearbox.net>
In-Reply-To: <20221004231143.19190-4-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Oct 2022 20:19:25 -0700
Message-ID: <CAEf4BzbBtgXStX5RUVa8s9kh23bQoaTvi-3Va-cE6qMH-hiDAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/10] bpf: Implement link update for tc BPF link programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 4, 2022 at 4:12 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add support for LINK_UPDATE command for tc BPF link to allow for a reliable
> replacement of the underlying BPF program.
>
> Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  kernel/bpf/net.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/kernel/bpf/net.c b/kernel/bpf/net.c
> index 22b7a9b05483..c50bcf656b3f 100644
> --- a/kernel/bpf/net.c
> +++ b/kernel/bpf/net.c
> @@ -303,6 +303,39 @@ static int __xtc_link_attach(struct bpf_link *l, u32 id)
>         return ret;
>  }
>
> +static int xtc_link_update(struct bpf_link *l, struct bpf_prog *nprog,
> +                          struct bpf_prog *oprog)
> +{
> +       struct bpf_tc_link *link = container_of(l, struct bpf_tc_link, link);
> +       int ret = 0;
> +
> +       rtnl_lock();
> +       if (!link->dev) {
> +               ret = -ENOLINK;
> +               goto out;
> +       }
> +       if (oprog && l->prog != oprog) {
> +               ret = -EPERM;
> +               goto out;
> +       }
> +       oprog = l->prog;
> +       if (oprog == nprog) {
> +               bpf_prog_put(nprog);
> +               goto out;
> +       }
> +       ret = __xtc_prog_attach(link->dev, link->location == BPF_NET_INGRESS,
> +                               XTC_MAX_ENTRIES, l->id, nprog, link->priority,
> +                               BPF_F_REPLACE);
> +       if (ret == link->priority) {

prog_attach returning priority is quite confusing. I think it's
because we support specifying zero and letting kernel pick priority,
so we need to communicate it back, is that right? If yes, can you
please add comment to xtc_prog_attach explaining this behavior?

and also, here if it's not an error then priority *has* to be equal to
link->priority, right? So:

if (ret < 0)
    goto out;

oprog = xchg(...)
bpf_prog_put(...)
ret = 0;

would be easier to follow, otherwise we are left wondering what
happens when ret > 0 && ret != link->priority. If you are worried of
bugs, BUG_ON/WARN_ON if ret != link->priority?


> +               oprog = xchg(&l->prog, nprog);
> +               bpf_prog_put(oprog);
> +               ret = 0;
> +       }
> +out:
> +       rtnl_unlock();
> +       return ret;
> +}
> +
>  static void xtc_link_release(struct bpf_link *l)
>  {
>         struct bpf_tc_link *link = container_of(l, struct bpf_tc_link, link);
> @@ -327,6 +360,7 @@ static void xtc_link_dealloc(struct bpf_link *l)
>  static const struct bpf_link_ops bpf_tc_link_lops = {
>         .release        = xtc_link_release,
>         .dealloc        = xtc_link_dealloc,
> +       .update_prog    = xtc_link_update,
>  };
>
>  int xtc_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> --
> 2.34.1
>
