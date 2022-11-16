Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B65662CBB4
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiKPUza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238754AbiKPUyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:54:06 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367F11FCF3
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:55 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-13ae8117023so21553662fac.9
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iP31vGQdnwIPrJ8QzQNj6IEJAV4JOhauU9F/tjVw540=;
        b=RhE3GguRkPEMkXUWs2VadW6PJBaWq89Jp2SiJNlls6JRTE8mYi/tH3+hYfFUZ0awNq
         rdTLnbDvvlWtlAn3A555cdj2q43IH77zOkuCycZ6mFrhsSPGwqOBP1OSDhPtcf7hQ9Uh
         nBhTGXY8+aR5+OofMmshbAQ6DRpJRA8ISYwI6CAjBYKV/kixobp2iboEeAj9OigYFk72
         a1zhGyWFXEKFadwEDR2szNIf2XMcpM1xf2pdDKd0I5r/92MynGASw1G5HYhkOA/0gZO8
         L8EvcpXXPkNsSNYo/1L7zgzrl3I0l/c+Qrav01bX+9oVZ+23tSVX5NvZzAFjyqSnCWn1
         A+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iP31vGQdnwIPrJ8QzQNj6IEJAV4JOhauU9F/tjVw540=;
        b=TA0Tygu632vqIQwNDsay/3tJShlr5YPVOTD8PCC4auXe6aFX7aT6a/sMFh6xxolyoV
         8B92uFU4JjkVZUspLCrSnr6Wokr5o9CiLWQjFouNaqgkopPTS5fLpW2c1VeiTP+QxnzN
         /h7Gf9WMx+n15XLrfpcxbB3pQO8K0x9hav+AOjciPnLuQoO+sgDZb9b1YsB0J9pQ5rZb
         Fd7HCu4oRAFAFVFnm0HiBJnbcSRX/KKhUZXzUDeFTGQvT4abJQu4fKB878yaQPB1uZXm
         oTnn1XJoBvyNwOxyj0ZuMhX7lgjBUbwKdmt7M/EEVerdvvuy01vIv8lGbo5UZu8T7YyY
         4B5w==
X-Gm-Message-State: ANoB5pm3B0wxMGpq1tMjkVgys238n+0Ds/n3CzLHx8LVCktGg+7hK/wy
        CVWKePsr4m8O5ixT2+yR38IFJmsMM0WTcwbUTAQn7A==
X-Google-Smtp-Source: AA0mqf6eJxglnZ5l/hFZloPm9zgfAzleZbfH7DZTmauEcjQrsRWNmtnycEjocULM0ilXXaKoHeZDHShdBtF4/d0XM+w=
X-Received: by 2002:a05:6870:e9a2:b0:13b:be90:a68a with SMTP id
 r34-20020a056870e9a200b0013bbe90a68amr2712686oao.181.1668632034425; Wed, 16
 Nov 2022 12:53:54 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-4-sdf@google.com>
 <20221116124256.04a75fba@kernel.org>
In-Reply-To: <20221116124256.04a75fba@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 16 Nov 2022 12:53:43 -0800
Message-ID: <CAKH8qBvUtpVA2WgeV0wyNK=sZ1kQV7bnWLKCCDuqM2Anry1weQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/11] bpf: Support inlined/unrolled kfuncs for
 xdp metadata
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 12:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 14 Nov 2022 19:02:02 -0800 Stanislav Fomichev wrote:
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 117e830cabb0..a2227f4f4a0b 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -9258,6 +9258,13 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
> >                       return -EOPNOTSUPP;
> >               }
> >
> > +             if (new_prog &&
> > +                 new_prog->aux->xdp_kfunc_ndo &&
> > +                 new_prog->aux->xdp_kfunc_ndo != dev->netdev_ops) {
> > +                     NL_SET_ERR_MSG(extack, "Cannot attach to a different target device");
> > +                     return -EINVAL;
> > +             }
>
> This chunk can go up into the large
>
>         if (new_prog) {
>                 ...
>
> list of checks?

Agreed, will move!

> nit: aux->xdp_kfunc_ndo sounds like you're storing the kfunc NDO,
>      not all ndos. Throw in an 's' at the end, or some such?

SG. But I'll most likely replace this xdp_kfunc_ndo with something
like xdp_netdev and to add proper refcounting.
