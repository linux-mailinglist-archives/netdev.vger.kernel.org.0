Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EC75EF9C8
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbiI2QIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbiI2QIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:08:25 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9993B1D359F
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:08:08 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id s14so2117635ybe.7
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=KrzdmdP7A/RvrL6kKLZHl68pd2UTuFHx8ezB4uKekmc=;
        b=dFKbKMNTrwZUpcAXt72ZT+WtotrUZKRnGipXW+/qWYbAb2YVZ6+D7VGRqeuJkguSB9
         rvOKyln3WqPo4+oYSlDqVzci4Tz7swvvcyo4IPo8rzGplcSSDcn472Tznu5nsq8Jr8sn
         pIFGYIeZuNjEZ1GPmDjHafZLfXKlvj/ocEkUdPu7D8tuNNHdTSw/71x96PD+y0bi6uCh
         b+awXmd2DiB6f+4qdDmMSIAuvL08cY51vGeeprPcFfqCkpHVqMO2iShLs5uHzmVwvAs4
         f35USWMaat0H39tJvHdEyKWwvFtW5CGyjUkQXZpDkWZTG1Nx9DB4Rdsy4/2biJc7LaFN
         e99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KrzdmdP7A/RvrL6kKLZHl68pd2UTuFHx8ezB4uKekmc=;
        b=eZ4bcf9uhJQR6u+5XrfLc8lo3Ec70HVRl3qPXHi5bhI7BCygX5PYBxetTgUwvIvSWz
         uZ3AKtIY9NpmUN2biYOhYHH0UY2lFtxF2VZpeBZsmtXWttjF5zFRlEmMsIeheWOdwqfK
         WLaA6OhC+lhTFc45Q6/1459bQlgVwFlVGySBj2nBLKEDwHG1UEBSPzPU1LCaMUXZHXNd
         ysOgCvTPQgZq5i2hb6Eilew35MEtmN9t7Uf/f+LCoJenlKw5N+ElNyL4YD55bkB6KcJi
         kKNaNjyvMdhCLPi/AdDd3p/kLN2+I33n+sMBC3Dc1RBkz9C9l9s0THFtoC7LomaslVMe
         TeiA==
X-Gm-Message-State: ACrzQf1c0cLbEWxeCTLtmamVvHtMdWG+vt0Ytts3fIGAVS5yGefzHlwg
        8hbnUSI6ON/145fkWAs8D7rd4hokPEQqUTglWvp8zQ==
X-Google-Smtp-Source: AMsMyM5iMcajf5qkAAiGZ8YX8eut3RMxIjcNl+tBZlHZNtoy3q1v5+MTYAfiIW8W3owhqY3BDggXt0OMlHGfQVyGrVw=
X-Received: by 2002:a25:2d4e:0:b0:6bc:df1d:9cb with SMTP id
 s14-20020a252d4e000000b006bcdf1d09cbmr139377ybe.55.1664467687000; Thu, 29 Sep
 2022 09:08:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220929070407.965581-1-martin.lau@linux.dev> <20220929070407.965581-5-martin.lau@linux.dev>
In-Reply-To: <20220929070407.965581-5-martin.lau@linux.dev>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 29 Sep 2022 09:07:55 -0700
Message-ID: <CANn89iKGvPA1ChjTQkfoRUR+_fGLrApXG9QD50vwpGECGO8ohQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/5] bpf: tcp: Stop bpf_setsockopt(TCP_CONGESTION)
 in init ops to recur itself
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 12:04 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> From: Martin KaFai Lau <martin.lau@kernel.org>
>
> When a bad bpf prog '.init' calls
> bpf_setsockopt(TCP_CONGESTION, "itself"), it will trigger this loop:
>
> .init => bpf_setsockopt(tcp_cc) => .init => bpf_setsockopt(tcp_cc) ...
> ... => .init => bpf_setsockopt(tcp_cc).
>
> It was prevented by the prog->active counter before but the prog->active
> detection cannot be used in struct_ops as explained in the earlier
> patch of the set.
>
> In this patch, the second bpf_setsockopt(tcp_cc) is not allowed
> in order to break the loop.  This is done by using a bit of
> an existing 1 byte hole in tcp_sock to check if there is
> on-going bpf_setsockopt(TCP_CONGESTION) in this tcp_sock.
>
> Note that this essentially limits only the first '.init' can
> call bpf_setsockopt(TCP_CONGESTION) to pick a fallback cc (eg. peer
> does not support ECN) and the second '.init' cannot fallback to
> another cc.  This applies even the second
> bpf_setsockopt(TCP_CONGESTION) will not cause a loop.
>
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>

Reviewed-by: Eric Dumazet <edumazet@google.com>
