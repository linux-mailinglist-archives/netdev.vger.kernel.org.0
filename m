Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B747358CF7
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhDHSwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhDHSwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:52:24 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD709C061760;
        Thu,  8 Apr 2021 11:52:12 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id i190so2498725pfc.12;
        Thu, 08 Apr 2021 11:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=vPVJuTnTZIpwD3zBSiZSHiPhLH2vt3JYwL7ismnrZC8=;
        b=D9NSMZDi7yoUeJ0HXUrZNQAS3ZB9qUQUYzZ1fO39qkWPBQJQabRWuGLUMZmrALI0m6
         TkyahbEi6l7duHXpZZ0+F6oXlSb+peNLAoc7FhhbnluxAwCrKqo1P1Ex55qdXXX7wNK0
         Daus6yyeZoEatzxMqASAymz230Tn8TL5K4NyE9kNutb3wRTvTEk4sgYQbIlrFcdZcXfD
         d8STS8wFnPOXkN/VtshVtiHJFayW/h8ObdHClWv4WxOsmx2UC+SBzpplfMb2AsFPDRVh
         1n0c9pGhArIYDJNa8pJOcA+315Bkg6x+LWVVZeMvYuDg9zb1LSnWXN9EAVnR8DsJLqDP
         VGog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vPVJuTnTZIpwD3zBSiZSHiPhLH2vt3JYwL7ismnrZC8=;
        b=JYRJnWcA5fg+ibyglGOD1nl8nfhduZ+2rQ50c34VD0OJL3z1zKFY4qwGQ8+l0du6C4
         dWZrJoOyBRD8ytL1N5pZm6oGZ5vtsSlGfs2iyjWgy+8/kpqcFapFQNy9La7fo8hy1Cfc
         RNIYrPw6juLmmH1Bmfr08cUXJ9+SFr6OVISh0526T/2qt0sEh8fuoPBSyR/sS+c6CXCk
         bkvk5uV03fboF8rkazQaGqyybbh/j1W2vJKQjFDEw/XSXp5zjPeH3NQZZJCBekQ88p7u
         dAVi/Y5cpBUaDO1S+iA7GlKOi1+gsJZgM4rM+XYwUUSV+n9qBr5KPmEddDO0Bw87Yo/P
         tv/w==
X-Gm-Message-State: AOAM5327Yb7wikh2Z8c58kKEC7+cYgTcI4wfiPM4MMIhs4d1AOTBxHal
        043y+NUV8atbzPPpUJNFyn9GoYI5sXS6OGlAaQ8=
X-Google-Smtp-Source: ABdhPJxHr75Ivml6vKF6SOoDL3AmJaDbLDBEfXCB2Y9EDw2ofY2GqEfDG6MyEVsVqFBTK8bR9htVbZZdozQOnW1V5B8=
X-Received: by 2002:a62:5ac4:0:b029:22e:e8de:eaba with SMTP id
 o187-20020a625ac40000b029022ee8deeabamr8907459pfb.4.1617907931906; Thu, 08
 Apr 2021 11:52:11 -0700 (PDT)
MIME-Version: 1.0
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 8 Apr 2021 11:52:01 -0700
Message-ID: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
Subject: Problem in pfmemalloc skb handling in net/core/dev.c
To:     Mel Gorman <mgorman@suse.de>,
        Mel Gorman <mgorman@techsingularity.net>, jslaby@suse.cz,
        Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mel Gorman,

I may have found a problem in pfmemalloc skb handling in
net/core/dev.c. I see there are "if" conditions checking for
"sk_memalloc_socks() && skb_pfmemalloc(skb)", and when the condition
is true, the skb is handled specially as a pfmemalloc skb, otherwise
it is handled as a normal skb.

However, if "sk_memalloc_socks()" is false and "skb_pfmemalloc(skb)"
is true, the skb is still handled as a normal skb. Is this correct?
This might happen if "sk_memalloc_socks()" was originally true and has
just turned into false before the check. Can this happen?

I found the original commit that added the "if" conditions:
commit b4b9e3558508 ("netvm: set PF_MEMALLOC as appropriate during SKB
processing")
The commit message clearly indicates pfmemalloc skbs shouldn't be
delivered to taps (or protocols that don't support pfmemalloc skbs).
However, if they are incorrectly handled as normal skbs, they could be
delivered to those places.

I'm not sure if my understanding is correct. Could you please help? Thank you!
