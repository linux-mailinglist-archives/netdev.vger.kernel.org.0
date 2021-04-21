Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111C4366DFA
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243447AbhDUOUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243495AbhDUOTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 10:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55AC961451;
        Wed, 21 Apr 2021 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619014757;
        bh=bBmIn8S8ZMIPvTWH/+ochcCoeMONUXeO4WBQU2iFBEg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lqYc8BHKKR3M22tT1kNQkEdfvRhiIOKEdI2dF1DWl1QGd1sDoCBc0MVeAalheZ46m
         hJyjhy1ad3X/RmGWZWWkByEpqMDCDiFvS+x7CZRhAo9CHx3u4x94aTOqdavs3aX7B8
         Dp6bFxCEbWdR9xWmjhnVGzxocghVJtTjQ3k7bEayS5Pnbnx42CbkxWQxXxXS/Gl7MP
         zfrJhblRLM/QvoPePtJWaHm0NpjFsCNlHAHZ2tFczlScD2dM/hrPLOU/0EI2lK0Cqb
         Kr/4/K6e18mbn5S7dvGC17psQDlTx7F+3Q2gX7h7Y4gbwZ2Fkia+L9lU9DadcC2km/
         cBoOX1FxQGaqw==
Received: by mail-ej1-f50.google.com with SMTP id v6so62457021ejo.6;
        Wed, 21 Apr 2021 07:19:17 -0700 (PDT)
X-Gm-Message-State: AOAM530z9rfTcwsdJOZiZm06SvfYSpwaYvE3yNwtEqXF1AEC+0VK1K4D
        olu+mx61qlQfjXfMmBYE6dOjrOklxAolvW6oWro=
X-Google-Smtp-Source: ABdhPJxaQljIkxFOGY7dNHi0Pk8uTSoPpwsWKcSgA3QnPpgl9pl/W9LzYtSuU+JlWOvBgBy/wcAMfxpFNn+mSdq30Qs=
X-Received: by 2002:a17:906:4e93:: with SMTP id v19mr32427309eju.215.1619014755832;
 Wed, 21 Apr 2021 07:19:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210407000913.2207831-1-pakki001@umn.edu> <YH6aMsbqruMZiWFe@unreal>
 <YH6azwtJXIyebCnc@unreal>
In-Reply-To: <YH6azwtJXIyebCnc@unreal>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 21 Apr 2021 16:19:03 +0200
X-Gmail-Original-Message-ID: <CAJKOXPcyJ43m-n=ACGGgRZkWd8KDD5pNkBSY1mSOebH9BvHROA@mail.gmail.com>
Message-ID: <CAJKOXPcyJ43m-n=ACGGgRZkWd8KDD5pNkBSY1mSOebH9BvHROA@mail.gmail.com>
Subject: Re: [PATCH] net/rds: Avoid potential use after free in rds_send_remove_from_sock
To:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Apr 2021 at 11:13, Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Apr 20, 2021 at 12:09:06PM +0300, Leon Romanovsky wrote:
> > On Tue, Apr 06, 2021 at 07:09:12PM -0500, Aditya Pakki wrote:
> > > In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
> > > is freed and later under spinlock, causing potential use-after-free.
> > > Set the free pointer to NULL to avoid undefined behavior.
> > >
> > > Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> > > ---
> > >  net/rds/message.c | 1 +
> > >  net/rds/send.c    | 2 +-
> > >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > Dave, Jakub
> >
> > Please revert this patch, given responses from Eric and Al together
> > with this response from Greg here https://lore.kernel.org/lkml/YH5/i7OvsjSmqADv@kroah.com
>
> https://lore.kernel.org/lkml/YH5%2Fi7OvsjSmqADv@kroah.com/
>
> >
> > BTW, I looked on the rds code too and agree with Eric, this patch
> > is a total garbage.

When reverting, consider giving credits to Kees/Coverity as he pointed
out after testing linux-next that this is bogus:
https://lore.kernel.org/linux-next/202104081640.1A09A99900@keescook/


Best regards,
Krzysztof
