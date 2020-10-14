Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB7E28E577
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 19:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389443AbgJNRhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 13:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389398AbgJNRhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 13:37:14 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AA7C061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 10:37:13 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k21so2441691ioa.9
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 10:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E5P9XanwOge6BO0+3eqi7lgaSRWxBp2wvk7ap4OM9kU=;
        b=PLY8MUElKEICEnctPspYXJKR28/9ZIVyBpVpzS32Ba5PoNvOjgLWZTm0k6PJrnF8G8
         WLu5E49dAv5TFVXs1pydQ7YW6T877BWhhjsSU0k+arfC6/RHmRqLqREPFH4Hl6qTS1Ml
         tyNKLtPK3f8niK1VxqIL5Oh3QtlgXJmplytiuT5Og9IPI2WMC38e87JkrfD7oWY2EqXT
         IEJhCt0/lrphzBI91nsQNaiOYR3rPG1bJbBzNMmG8nEI63fxsZ1WqM39/9rhJ1DvzoyO
         lc1q2qgKKLdO1jYCOjUjUBDLEDwpRxfNfRyxH8nqwqEbE37Epwdqhf7gR553cnwKwyKz
         ShlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E5P9XanwOge6BO0+3eqi7lgaSRWxBp2wvk7ap4OM9kU=;
        b=hUy2LJN9ZyUfqtfu8cdSVLhq/rgRb1xKK05xbZ8A9aHM7v7+NGEptTUblcLAbr/XMJ
         2+dTqKhBpI/eDv7w0HiHufe7CiQlN+ZPlBJDzq2tUFy/OydxuDYrzrjmcn+rak2jaqB7
         HRJV0AXaMTYS+/4OW0gTL+wYG0SPsc/xM4hwrGq7ErrkIiz9sVQ6XIlwsBB7CrOi1mib
         +4zXLVy4/yjR3yLqcCesIF3Ntwgi5J0mbt6nxDs7cBy+NNhhcE6kMgmmRzel6wBfgsin
         orLe5yvsjswyXHlscLnsCubae51lO93cEb24BSKjNF6TgAs/UWXSlVClWIbeAgkp5Do8
         wryQ==
X-Gm-Message-State: AOAM533T5D3oaDMdwhWGcTSHe5/56Po4EwWh5nh7iqvLlr1ilhcx1TV/
        70YGiNQCBh3Fj232Z0+2yHbwcznbFvEreWgNBvo=
X-Google-Smtp-Source: ABdhPJxmT+vP3B/PA4B2WFafPwnlknQyd19fXql5RTR4trVNE2KFE9P4lMhAPlzgLb9uEfFqZzk9nHKXaAkjAbVJL/0=
X-Received: by 2002:a05:6602:54:: with SMTP id z20mr357528ioz.85.1602697033124;
 Wed, 14 Oct 2020 10:37:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201014085642.21167-1-leon@kernel.org>
In-Reply-To: <20201014085642.21167-1-leon@kernel.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 14 Oct 2020 10:37:01 -0700
Message-ID: <CAM_iQpV_exrncjYnN1_+gT42uSVGwsFijsu6K1pmYGv9yCBi5Q@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: Fix suspicious RCU usage while accessing tcf_tunnel_info
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 1:56 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> The access of tcf_tunnel_info() produces the following splat, so fix it
> by dereferencing the tcf_tunnel_key_params pointer with marker that
> internal tcfa_liock is held.

Looks reasonable to me,

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
