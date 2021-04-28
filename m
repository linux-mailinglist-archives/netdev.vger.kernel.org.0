Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F02D36DB43
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236957AbhD1PLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhD1PLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 11:11:17 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BAEC061573;
        Wed, 28 Apr 2021 08:10:30 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x7so63410142wrw.10;
        Wed, 28 Apr 2021 08:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=caPcWX0HvCbUGxoKUybXsnQMiEeBgCwT/cgikCWDkpc=;
        b=ZTYFlakBWBp2Opq/jD01M4nUgx0ti9JQ4aFD9Q+GvDNrPY6zj6++mTcAniLmsOC6p3
         n3ZxHDzViQ1KclzV2l64XWnJooQN+CqlOSot0SwWzQwkczNOg4ujcabw/Y/Q7exfiHYy
         IUcm65kebe92ZvH4PLQ9tukBAmZSrm52uEUoiAVyHlEDKf90TSlDbMFGrQRVCEomxUdN
         0+0HgeOrajuXqr/Xbda3LkvUKjm/9/OT2jdoRtNoMCCEBUx4YgN/HzUeFztmUnWiRtsr
         gPmTeMAB2S6A0aiJvtoOipgwQK7TFt7Ow9i8l6crZLd4fBdshk4uQzOVN+b8xpRuujrC
         bHrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=caPcWX0HvCbUGxoKUybXsnQMiEeBgCwT/cgikCWDkpc=;
        b=lgF4p3uKfwq03VeWVWlDowtUFin0K8fQd0ATxlHUSBdR8Lt+BUu2LsBrvzGuzi8xVO
         hll+d4oBsxT/bSgoz2cQbCSzFMZA4TsyjuWSiDFfdpZoDUy73FBUu2jTpta7oesDs5EQ
         FWBZcGCE4PRoJX40JhjCj1d23oCS0u4xys/U79jx+8MayL9MiVnwq/idhootZlIa44t2
         9K4bfUIt0rTBN7T6PRSBq38bDM3b5iOcsx3IDoWAo2mt14EtyvB4N1AJFDSYwVdGlPuj
         DUSPvLsnkrPVApEsZsgoG0S2sLQkpG3Dby8K93j2ST7I4ercpau1TKN1URsdCEQ5Q4kE
         xvyg==
X-Gm-Message-State: AOAM532KAgodls0egq8jcAtOWmEiQVOPNxJjGqG9Nkf3m2WSr2bVyzEh
        lT7BcVpLWKFFKkq124HXlKmsDL60t0SqGJEEmvY=
X-Google-Smtp-Source: ABdhPJxVN5btpbhyyFI3SSpFSYUJhcM6me5+lef8qqcMI92e90PN00NzDC1AMx2HcHRG/qI8ZSgbTRstZBP73rH4vZs=
X-Received: by 2002:adf:f190:: with SMTP id h16mr22688829wro.393.1619622629615;
 Wed, 28 Apr 2021 08:10:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210428135929.27011-1-justin.he@arm.com> <20210428135929.27011-2-justin.he@arm.com>
In-Reply-To: <20210428135929.27011-2-justin.he@arm.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 28 Apr 2021 18:10:13 +0300
Message-ID: <CAHp75Vfx8aGQGJR58o49t2bOtu5adkrSRfWW9bb63OBoePcj1g@mail.gmail.com>
Subject: Re: [PATCH 2/4] lib/vsprintf.c: Make %p{D,d} mean as much components
 as possible
To:     Jia He <justin.he@arm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 5:56 PM Jia He <justin.he@arm.com> wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>

Hmm... Okay.

> We have '%pD'(no digit following) for printing a filename. It may not be
> perfect (by default it only prints one component.
>
> %pD4 should be more than good enough, but we should make plain "%pD" mean
> "as much of the path that is reasonable" rather than "as few components as
> possible" (ie 1).

Sorry, but from above I didn't get why.

The commit message tells only about %pD, but patch changes behaviour
of the ~100 or so users of "%pd" without any explanation.

Besides that the patch is prepended only by one change (which is also
not related to %pD), while we have ~30 users which behaviour got
changed.


-- 
With Best Regards,
Andy Shevchenko
