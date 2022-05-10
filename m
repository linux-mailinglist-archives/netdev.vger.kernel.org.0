Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196EF520AEE
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbiEJCEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiEJCEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:04:37 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B590B167C0
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 19:00:40 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2f16645872fso164200867b3.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 19:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fPVKbS/kxXxLU3/LC1SXQ4W5eBO/r3DISuZbkRKMbNI=;
        b=hFegsTvluKctlaO/ncV7+6nKazxub24QJBCDf+cCocE/2gRCJE9OhdtWnwZf5VDiHq
         FSyyQI4sn27IkGuD3G0x628JTDqPPaT6Tiv43dQmTX78jz5H5UBm4ZyGHgJda7iTzQPb
         qtC9qaKn3JD40MLO2zB2g06b8386LytenYx+3qX45XdNdAiB+IvUFoV2Xo9Ahix8ixQ9
         KYE6IL+i/9kEzhTKt6la/xsPrIdMMxYvHYmBOnqRZg7VBwjK6NsbkPDuKw7wC+naMjRL
         JTCg27UDXVfrrSczH8M1Nq+ePqayzNDBVnv423dkK4PB/kEhVnu9mqPiePgcgAyJQL4u
         U5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fPVKbS/kxXxLU3/LC1SXQ4W5eBO/r3DISuZbkRKMbNI=;
        b=zeDkMG2M4/fLojGMa8zTABYG3AEEzB3TzvLZPUIFyJZc8MF4UcCjYicJNJsdK5E/rw
         Jz+FVcjp9IoB7IjWsyBcoLVHRBsxvJIc6MVBNU+W9PZO975ssFskHg6BO9JfUrTkA4DY
         FUtRY+Os0SqUdlO1YOvIDX/ASQhChJQt6t+p+/zVmngPHIM2fH/1+w4OUob5/hG/pNeR
         s8xI1+x7kCh1wdidQ5XSmcfoljnKbl90WvzF+OXpnL5rKNV+0+i85gh0xzVONXGS/1a4
         TyVlAr5Ukf5ZUupUk3lQGtoJ8G5We27PRphUqf5qr3dpvPxN17ctsAtJmV7Km2nDWmul
         Wo3Q==
X-Gm-Message-State: AOAM5337kwoh7B/zNFaPe2Tw4/5o5WiNqHBw8gWsn3haSnpRHbtLZ99+
        ENw11YDdQR4SXr6XjMYIdxmvBp7X5DliVxbkhBU34A==
X-Google-Smtp-Source: ABdhPJz3vct4AcZ2kNdyEmJlDdXWYPVHVqM57fIasJlktFg8VRm13tG4jg6I3BtVXqgHwfVivC7KtyHmU8/7fy3ot5g=
X-Received: by 2002:a81:4f0c:0:b0:2f8:46f4:be90 with SMTP id
 d12-20020a814f0c000000b002f846f4be90mr17551992ywb.332.1652148039583; Mon, 09
 May 2022 19:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
 <20220509222149.1763877-14-eric.dumazet@gmail.com> <20220509183853.23bd409d@kernel.org>
In-Reply-To: <20220509183853.23bd409d@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 19:00:28 -0700
Message-ID: <CANn89iLQvZFZzonh5SAyWkinujO4sc3bSjrQMKQxGabZyGLnLw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 13/13] mlx5: support BIG TCP packets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 6:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  9 May 2022 15:21:49 -0700 Eric Dumazet wrote:
> > From: Coco Li <lixiaoyan@google.com>
> >
> > mlx5 supports LSOv2.
> >
> > IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> > with JUMBO TLV for big packets.
> >
> > We need to ignore/skip this HBH header when populating TX descriptor.
> >
> > Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
> > layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.
> >
> > v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
> > v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=y
> >
> > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > Cc: Saeed Mahameed <saeedm@nvidia.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
>
> So we're leaving the warning for Kees to deal with?

I think so. I do not see an easy way to escape this, unless perhaps add some
extra obfuscation, so that gcc can not determine the memcpy() third
argument at compile time.

Alternative is to remove mlx5 patch from the upstream series.

>
> Kees is there some form of "I know what I'm doing" cast
> that you could sneak us under the table?
