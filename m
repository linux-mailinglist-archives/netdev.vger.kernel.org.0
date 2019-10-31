Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90181EB791
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfJaSwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:52:13 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42250 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729239AbfJaSwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:52:12 -0400
Received: by mail-ot1-f67.google.com with SMTP id b16so6301982otk.9
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 11:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y665542Oih3bbYG29RtcM5M1AA4CG5FcogMWKfgVUYw=;
        b=d5jLZkPdet2j4vxMAlRu9b4Y1iX5gCZ+5c/Y4KAlnWMJy3BoEUmzDGWLpGTeAotrWn
         PMyrul5BdDeHk42eLBoRMTXXlpr7PEAEc0QpNV8nm8x1HLnoJoNAKRwEOU2KTeNN7mKU
         O4bKCNrK5zFcYoJXDQ3jxA1SixCBbWHmbUWucIlWsU6PIru+FabhjDPRAmtYuO8Cbnmg
         dwStpIVV7QaZaipeXYkOwNZbZpOA0i1d5Y6lRWOw2OCMGcEnsgST3LFifr+vhOhcBLZv
         e+q65GD7RtN02l1t38OzVH/cswduI4BZqNcuiOgVwEl5KHzIPbgMXlH2BV3n+tqmzB/J
         jMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y665542Oih3bbYG29RtcM5M1AA4CG5FcogMWKfgVUYw=;
        b=KNjfv8E4IN1p33uBQlrJhSNbWvTXxO6THEgdQHYNMVWgWeK1WW6tiaI/nUcGlFgCyN
         AVwOsuQAVPy75CMJAqjRvaHmIQ1ElZQMNshjw2lNZLkLLas8zdqqODngniGgt287kwfq
         DRBH7STPw0srWOOqbd9cWSklqepiAcoC7a0lL7yzO5Z9SDkUFogCTxX01nbQhrK0hX6Y
         Bx7+17FFCnZR870uX255okh/GW6Wn79Br3FB1DmIQZJX1IUNPl5XvNk2P9mJQ5yTnkcP
         2Fc11ZQd6osf01XF7cV5yeqUpQsA1PfrknxuCMQp0ZsxY7a1Xt0Q7vRa3ecPGdoiiqFd
         xfAw==
X-Gm-Message-State: APjAAAX6XRv9ialHHk0ldqWJu2zN1ibc/WxqttxPntk1shrNzAgJ8BBS
        mLYL11TvXXcTQsAmWowRmGP9/jlum0sBjGG75Dq+2w==
X-Google-Smtp-Source: APXvYqwFhgFBvc1YFm7oFHDExuZRWg7JWPuj+gexAJNggudyRztHHP+1uFgwz6wqygk9AUdId1hhArr8jtiDsq9vf3U=
X-Received: by 2002:a9d:5e10:: with SMTP id d16mr3381847oti.191.1572547930208;
 Thu, 31 Oct 2019 11:52:10 -0700 (PDT)
MIME-Version: 1.0
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
 <20191024205027.GF3622521@devbig004.ftw2.facebook.com> <CALvZod6=B-gMJJxhMRt6k5eRwB-3zdgJR5419orTq8-+36wbMQ@mail.gmail.com>
 <11f688a6-0288-0ec4-f925-7b8f16ec011b@gmail.com> <CALvZod6Sw-2Wh0KEBiMgGZ1c+2nFW0ueL_4TM4d=Z0JcbvSXrw@mail.gmail.com>
 <20191031184346.GM3622521@devbig004.ftw2.facebook.com>
In-Reply-To: <20191031184346.GM3622521@devbig004.ftw2.facebook.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 31 Oct 2019 11:51:57 -0700
Message-ID: <CALvZod7Lm5d-84wWubTUOFWo4XU2cgqBpFw84QzFdiokX86COQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: fix sk_page_frag() recursion from memory reclaim
To:     Tejun Heo <tj@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 11:43 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Thu, Oct 31, 2019 at 11:30:57AM -0700, Shakeel Butt wrote:
> > Basically what I wanted to say that MM treats PF_MEMALLOC as the
> > reclaim context while __GFP_MEMALLOC just tells to give access to the
> > reserves. As gfpflags_allow_blocking() can be used beyond net
> > subsystem, my only concern is its potential usage under PF_MEMALLOC
> > context but without __GFP_MEMALLOC.
>
> Yeah, PF_MEMALLOC is likely the better condition to check here as we
> primarily want to know whether %current might be recursing and that
> should be indicated reliably with PF_MEMALLOC.  Wanna prep a patch for
> it?

Sure, I will keep your commit message and authorship (if you are ok with it).

>
> Thanks.
>
> --
> tejun
