Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565D65F5F7D
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiJFDVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJFDUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:20:16 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0483EE36;
        Wed,  5 Oct 2022 20:19:48 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id k2so1746830ejr.2;
        Wed, 05 Oct 2022 20:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zGJ9xia225hQhe8DB/Dq+lC6sroDfU6F0eS1ZLsNYEU=;
        b=De3fe9OZ+WKLXTiqoqxMV8fD/YJ08x6gHxozXvL70Ex2huKHz/10ulClhLUTBkAuzD
         2fOPhHa+qbRSXPkQAKQSyzxXJIsbofe0pKUCTFQLz5ng8sbosWa1/K0mBN2k0ZrxtQPR
         0Uc+kDVLDbiVghCFTX2XuxlpQas6j9dZAb07WKyluGwNkgBByjHYceD0xwf0r7SQV+e8
         vIbvaIU0aiRMQUIRk9lk4+XVlB3eWBsxGmB78SjhSsNMpmY/1zOLF4kCnfn8a9YhdNuY
         O92YrIp/wfXWdzNzADxGarN0FDffnyz412SYODrFOLkPROHAdk8jsAH3bGU1In01bYiD
         XWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGJ9xia225hQhe8DB/Dq+lC6sroDfU6F0eS1ZLsNYEU=;
        b=FAWiMBSttwYcFVVFhzvRNOO8bgHx0aV67TPLtSZVld17JWuUcoaI1SnRu4E3xWnflw
         CxWquq9bL4kA/Ub8/UEvgd39YbfE4FEwr7leEVWk+KNoybEvpRoOe9INtTzGAKAZwCg7
         F9eD+P6bd3iUdEP3eFaYiEh5Vt2vA+deh5b/k7eD5oVPQzKJOy9BMLAEASPC4raKqu17
         EGFZu5rJTyK3Hv78tC+1xIAAaqT/AeRRlR4sxc1LgVv+0LK9kS5NER7blkLwr1ZHBwJh
         x5WShSWxGCUhx/x1jutbF2QhfZbOI7Vgyfc9LacECzesAt0xoDCsunEpRQKUdYhKVK4a
         Q6/A==
X-Gm-Message-State: ACrzQf1XiLVDpgHWCsb9HkZD8X5SalGsxofRxt98IQto+djMMYzOvcvl
        +D3Z5NxsC785S/tN7WSZ+75rzE9V63tIE8ZYE44=
X-Google-Smtp-Source: AMsMyM6ZzPaiYqLbYUKbgb68YcnN6Rl+jLI+KeGb1LE+fVavyyJw2iMB8Vyu4DNRN1XFyleCaD7edKE5PtMmHB4dZ6w=
X-Received: by 2002:a17:907:984:b0:77f:4d95:9e2f with SMTP id
 bf4-20020a170907098400b0077f4d959e2fmr2265620ejc.176.1665026387102; Wed, 05
 Oct 2022 20:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-6-daniel@iogearbox.net>
In-Reply-To: <20221004231143.19190-6-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Oct 2022 20:19:33 -0700
Message-ID: <CAEf4BzaTXtC6RsC9cJQLZB08RV+h-SL0JZAFPgb-M8b+ruro5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/10] bpf: Implement link detach for tc BPF link programs
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
> Add support for forced detach operation of tc BPF link. This detaches the link
> but without destroying it. It has the same semantics as auto-detaching of BPF
> link due to e.g. net device being destroyed for tc or XDP BPF link. Meaning,
> in this case the BPF link is still a valid kernel object, but is defunct given
> it is not attached anywhere anymore. It still holds a reference to the BPF
> program, though. This functionality allows users with enough access rights to
> manually force-detach attached tc BPF link without killing respective owner
> process and to then introspect/debug the BPF assets. Similar LINK_DETACH exists
> also for other BPF link types.
>
> Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>


>  kernel/bpf/net.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/kernel/bpf/net.c b/kernel/bpf/net.c
> index a74b86bb60a9..5650f62c1315 100644
> --- a/kernel/bpf/net.c
> +++ b/kernel/bpf/net.c
> @@ -350,6 +350,12 @@ static void xtc_link_release(struct bpf_link *l)
>         rtnl_unlock();
>  }
>
> +static int xtc_link_detach(struct bpf_link *l)
> +{
> +       xtc_link_release(l);
> +       return 0;
> +}
> +
>  static void xtc_link_dealloc(struct bpf_link *l)
>  {
>         struct bpf_tc_link *link = container_of(l, struct bpf_tc_link, link);
> @@ -393,6 +399,7 @@ static int xtc_link_fill_info(const struct bpf_link *l,
>
>  static const struct bpf_link_ops bpf_tc_link_lops = {
>         .release        = xtc_link_release,
> +       .detach         = xtc_link_detach,
>         .dealloc        = xtc_link_dealloc,
>         .update_prog    = xtc_link_update,
>         .show_fdinfo    = xtc_link_fdinfo,
> --
> 2.34.1
>
