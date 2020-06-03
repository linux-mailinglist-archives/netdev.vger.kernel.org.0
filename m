Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CB11EC872
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 06:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgFCE36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 00:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFCE36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 00:29:58 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5A5C05BD43
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 21:29:58 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id k18so802299ion.0
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 21:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2775XYKzB3jo5g9PBLRdfsBnxeHsE7NDoiO0w1rX6Ig=;
        b=M3Hr/ZXYQakd0XBOGzUr0Z4ttC9WB8TR8ilGpGINs8Oqu4SCHtb+nE46kHeDABl8xg
         M1F7Mi41ABi2p9qMbxBzLQLoB0szcvZ2PuCiw24L9NWq26A1ZlZbODN0OD/fwbygc9EE
         HZCgTqO8qfQcj7IK0Xpqgv5dVb+Kom3i7Tcuswb+Jrlj/lKvo7S55W3U6iWG9GJwc5C6
         xJWt/ONv40NiRoUH4tarVlO9SRx8Aa/BTnm9ZhmNjpIjk2XUiYNff0d+pNFhDsfuR2B3
         Ygs/KvmV0LM3YiI06imqMT+dEIqdvkhZOjroUcUkvvb12eArvaDF6RcGQp8VpdThMxn+
         w4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2775XYKzB3jo5g9PBLRdfsBnxeHsE7NDoiO0w1rX6Ig=;
        b=miKELBM4t+lKQEK+N3049nm5w9WW9qacM4N3aghF0oohJc56rMXwuXmGg96zI8s5xF
         haoyFClEbSp2PdC8+op8Kth4onS8OuobhZuOL7xTdGFFE4nIVQ7v3d+mOIrbBdrE74Qg
         iOEoJSzMjEDAGvZON9zL6QCh1aj5eH7lb5TOE8lp0UMBtNxh04y8qAcLeJjhia6waqEl
         ScSAZYwjbpPj/o5uPmSeT324OWeGVuGXulIv2JZRF5TekmqA6Z0fXIp3SEA3gOr2/EJ8
         MN4je5/xgGUET4mRxsAwbPRtXbvVWmLlVDABfG1V0rxQ05ejPxVeWtCZgsAbOYfMmrIY
         gwIw==
X-Gm-Message-State: AOAM533V0NryWfEg+tHDn2xXQFrAqQ8L1+oFbvWw0t/JKhVu9vgW2PX1
        xPBxBEJ0ejDHR93w90vyjtWUtzW++feBCu+sAItZdKX5
X-Google-Smtp-Source: ABdhPJx7WN+AT4gnkLU2LfFUUBuurZ8i0rFZCeChtI59hGi83NHlx7OiPK4GU1wbbi7Nr9lkd6faokRaPoXrzhqrhQ8=
X-Received: by 2002:a5e:a705:: with SMTP id b5mr2152652iod.12.1591158596954;
 Tue, 02 Jun 2020 21:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200603032942.20995-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20200603032942.20995-1-xiyou.wangcong@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 2 Jun 2020 21:29:45 -0700
Message-ID: <CAM_iQpWfU0W1tn2zEPnCtWqDXD6gCmH0_5K_8kksmifjzN8cCQ@mail.gmail.com>
Subject: Re: [Patch net] genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     syzbot+21f04f481f449c8db840@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Pirko <jiri@mellanox.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Shaochun Chen <cscnull@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 8:30 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>         if (ops->start) {
> -               genl_lock();
> +               if (!ctx->family->parallel_ops)
> +                       genl_lock();
>                 rc = ops->start(cb);
> -               genl_unlock();
> +               if (!ctx->family->parallel_ops)
> +                       genl_unlock();
>         }

Hmm, wg_get_device_start() uses cb->data, so I have to install it before this.

Will send v2.

Thanks.
