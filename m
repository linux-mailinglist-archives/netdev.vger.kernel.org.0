Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479B95F52A9
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 12:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiJEKdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 06:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJEKdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 06:33:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAA2760EC
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 03:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664966017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aSocIwrgEkDka1DlTJPwPXJMuDv+aU5NB9kPIpmlG0I=;
        b=BhBftDmyyYKjikUCm8RWAT5pV2OaKkwSNSeUXQkSJt92oS48XzvtMSpAMgqFKDbOdkPhBj
        ZTzk0MYMaJuvr3L+vPx+srTRYQt6P1ytFSZWG8g42rpW3f18apjIMRpLbwwJTBGy4mmpYT
        gayCLgcXwVaaMmsPD/ad/Gh5nGN0VhM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-172-4DbSlpevNNG_vQapsUWj0A-1; Wed, 05 Oct 2022 06:33:36 -0400
X-MC-Unique: 4DbSlpevNNG_vQapsUWj0A-1
Received: by mail-ed1-f70.google.com with SMTP id i17-20020a05640242d100b0044f18a5379aso13437315edc.21
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 03:33:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=aSocIwrgEkDka1DlTJPwPXJMuDv+aU5NB9kPIpmlG0I=;
        b=6u0WouxHpEpfz9Q3MnnMkcfNmFYzAB/n17SuFm+xYGxLr6qAvK6Tp9gtfQzuXO2Zvl
         FZqimV5W8FEbiclcUChipmQp9XgedUztjBsAvYzbxes7LEWwFv02BGgkQ4B3ViXl+myB
         MgYpjECNzfrEvccFEicURPmWYjmk17qcrvHCThiuGg/LMF+XIon856ho5ZcK64kedK8l
         w39Uy+NLpwgNwHfMsorzYG4WPbJc3FayMI1yQJ/pnsdCIXQwuAU+uGwxpKFIe6QCvjnG
         gH2A62VOGCSHU5uhe6lwrgTkh2wt5Ceobsjo2/huejez8K/2XKrvY2JLDSyt0H95OdY6
         8jxA==
X-Gm-Message-State: ACrzQf2C7Xz7s4RzjCzzwN09IVllJ78HqnmshRuTkwFNJ8AZf+XMqwDB
        SgK3DYShBQcczP+fuXzMBMq3VlsSda5JpUnpACJogTZ8CQnOFIdrxpX+bRZj2jvYYDJTFHVGmeV
        8mC7ShgClIgfxXH4y
X-Received: by 2002:a05:6402:3547:b0:451:3be6:d55b with SMTP id f7-20020a056402354700b004513be6d55bmr27300773edd.57.1664966013548;
        Wed, 05 Oct 2022 03:33:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM64Kd8eN0YvoYqGN6dYRN8+ecYh1gUUThzoOVgNb56Y2SDI4BsTp0JLge+DROJ9OwiXcqW6zQ==
X-Received: by 2002:a05:6402:3547:b0:451:3be6:d55b with SMTP id f7-20020a056402354700b004513be6d55bmr27300629edd.57.1664966011102;
        Wed, 05 Oct 2022 03:33:31 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j14-20020a170906094e00b007417041fb2bsm8397875ejd.116.2022.10.05.03.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 03:33:30 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AB7DF64EB7E; Wed,  5 Oct 2022 12:33:29 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, joe@cilium.io,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach
 tc BPF programs
In-Reply-To: <20221004231143.19190-2-daniel@iogearbox.net>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 05 Oct 2022 12:33:29 +0200
Message-ID: <87bkqqimpy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> As part of the feedback from LPC, there was a suggestion to provide a
> name for this infrastructure to more easily differ between the classic
> cls_bpf attachment and the fd-based API. As for most, the XDP vs tc
> layer is already the default mental model for the pkt processing
> pipeline. We refactored this with an xtc internal prefix aka 'express
> traffic control' in order to avoid to deviate too far (and 'express'
> given its more lightweight/faster entry point).

Woohoo, bikeshed time! :)

I am OK with having a separate name for this, but can we please pick one
that doesn't sound like 'XDP' when you say it out loud? You really don't
have to mumble much for 'XDP' and 'XTC' to sound exactly alike; this is
bound to lead to confusion!

Alternatives, in the same vein:
- ltc (lightweight)
- etc (extended/express/ebpf/et cetera ;))
- tcx (keep the cool X, but put it at the end)

[...]

> +/* (Simplified) user return codes for tc prog type.
> + * A valid tc program must return one of these defined values. All other
> + * return codes are reserved for future use. Must remain compatible with
> + * their TC_ACT_* counter-parts. For compatibility in behavior, unknown
> + * return codes are mapped to TC_NEXT.
> + */
> +enum tc_action_base {
> +	TC_NEXT		= -1,
> +	TC_PASS		= 0,
> +	TC_DROP		= 2,
> +	TC_REDIRECT	= 7,
> +};

Looking at things like this, though, I wonder if having a separate name
(at least if it's too prominent) is not just going to be more confusing
than not? I.e., we go out of our way to make it compatible with existing
TC-BPF programs (which is a good thing!), so do we really need a
separate name? Couldn't it just be an implementation detail that "it's
faster now"?

Oh, and speaking of compatibility should 'tc' (the iproute2 binary) be
taught how to display these new bpf_link attachments so that users can
see that they're there?

-Toke

