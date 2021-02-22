Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5400632158C
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhBVL6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 06:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhBVL56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 06:57:58 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865B1C061786
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 03:57:18 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id b14so12252845qkk.0
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 03:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wyd6bMdzRakwIZzWcTReYzcouUtfWGkSJhmejhxTRvM=;
        b=i9ayoASE0H3Cy8+A9xuuoPoO7d5vUPYG2BCBRhY7iY+o6F8miLRBxFXoNsU0Djbw4X
         nPvojy7Cqm+xVuzCQIoC8kBD2tj0ebUIjLTSMTIC9MX3ZxVc5C43g8l15zwZXlxw93SD
         +JrKvCvYGoZ5wlN6PH9NOESnkgfJO8RCOgt0/PAeEuXPejqg4yK+cOZPVaYb57uxxeq3
         IRA5Hyp/XgKXsY/XgxEGpdDqFaE7Z5zTfTEVVrYRCP0SLeIUHux+FBWZlri+EQjBpgXw
         ss3KCSLlyWNX+lucpWBOzU57vi7GLwimXbEx3HNIYdZJ96PjTvtONe5dTYYyvOiRuatr
         s4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wyd6bMdzRakwIZzWcTReYzcouUtfWGkSJhmejhxTRvM=;
        b=dLsMPqyP9r8AxB/5vGqlUnWb461WTV8Hn4DCx8jAPxcznRtjXSY5Ef2+JGabCcW+OY
         MIxgHKGAyR5l/RoVb6WVZi/XmbNrvjGQOpra70VdlNk/YewlNe4lQoA8q/mF58Xz9Xox
         Wf33279lUAJH/aOY7QZY+HbrIMoVvPJvoAHS5M769UF+CtBn4itQ03z1wpTxw5e6AWLk
         AfTWcZnbh8lO3dA81rphi8/d9JerpQ7+WVLxC/r0LFgFxbNAsBsZkGD9CwrnO0GsVa0m
         zdqzswJxgP94C2KLplPeEqlbufytR7BF9aucXJrtyeLP3vFyoRSKdpAh6HtYlFE1n3FJ
         1dTw==
X-Gm-Message-State: AOAM532jBRGU7rkRGkW51JGCt8l0oEcPFNSShp3GGPCSrdSPQQaLwoa+
        mjT50pIttGpV++ysh3vsyN4DpESty8GRX/5xQv0=
X-Google-Smtp-Source: ABdhPJx+qICqr2IfSq8uwAtNCim3uM/PhGsTAZpqzcrqlUDcBRYch/tPebMl+ocC54pTslVIxN12J5phcoAHHYaXp+0=
X-Received: by 2002:a05:620a:248e:: with SMTP id i14mr20688858qkn.245.1613995037797;
 Mon, 22 Feb 2021 03:57:17 -0800 (PST)
MIME-Version: 1.0
References: <20210220110356.84399-1-redsky110@gmail.com> <CANn89iKw_GCU6QeDHx31zcjFzqhzjaR2KrSNRON=KbohswHhmg@mail.gmail.com>
 <CA+kCZ7-AeEHrOo18DMzF1zOGC=b-GrP3XFj5QhPeOoM3U0j6Ow@mail.gmail.com> <CANn89i+mkQ31=dV+VcJNg-ChJrBOSC41L9+RqdO3Tkf_NtwSgA@mail.gmail.com>
In-Reply-To: <CANn89i+mkQ31=dV+VcJNg-ChJrBOSC41L9+RqdO3Tkf_NtwSgA@mail.gmail.com>
From:   Honglei Wang <redsky110@gmail.com>
Date:   Mon, 22 Feb 2021 19:57:07 +0800
Message-ID: <CA+kCZ7-oL9hXNjRuAEFR0=JpYr=xgU4eo9-WFt-gJm=QgRGp7g@mail.gmail.com>
Subject: Re: [PATCH] tcp: avoid unnecessary loop if even ports are used up
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 7:29 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Feb 22, 2021 at 12:10 PM Honglei Wang <redsky110@gmail.com> wrote:
>
> > Really? I just came to the latest 5.11 including Linus' tree and
> > net-next, seems it's still here at line
> > 725 of inet_hashtables.c.. Do I miss something?
>
> 5.11 is old already.  inet_hashtables.c has been changed for upcoming 5.12
>
> You always must look at current trees before submitting a patch.
>
> Read Documentation/networking/netdev-FAQ.rst for additional hints.

Got it, thanks, Eric!
