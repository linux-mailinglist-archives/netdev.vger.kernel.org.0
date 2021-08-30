Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A44C3FB009
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 05:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhH3DdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 23:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhH3DdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 23:33:16 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA25EC061575;
        Sun, 29 Aug 2021 20:32:23 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id y128so18232401oie.4;
        Sun, 29 Aug 2021 20:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qYWX5+fW4xjujbLa4k+fgCWESUP9bq3v4p0R4RlvdMY=;
        b=XOCZngbHRsBW/HUCfhxvU4B4g2JR9j7ubX7/gy75ocJpQaphjZpMiafmeOgxznl9C7
         np2+76HQwlKnnfgMUZAYOks7JIKe+sgTB2ARDIBqw6Mx28m2yjUUaq3ZJLuSO6Z42px+
         E5ErS26qdI9rCPwbOA12+19TSQ4VIewCk8aNs7GsM3keVkNjKN4BbSUDbl6Tori+JuTE
         ARAb4/pQO27AVZET08e/SwyxwxD71WWomO/ZC3kZQxNy+JRJpEQ0GzeG1bLLGrDzzwNE
         YUonFV667J5DJ/9ZerFosPDT5Tuh1eN9dR0h3IG46HINFMLVhENWAvFClqeYDjH3jTfF
         e+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qYWX5+fW4xjujbLa4k+fgCWESUP9bq3v4p0R4RlvdMY=;
        b=W7du0gq9G6nkAb/anq+W2LS8Hb7RInkTMY3UpHSJViCb957iZ8tzLEdKP2z1aqhSSB
         sJ0AkfzJnvVo3EASKMkkfbnZ8NZ+TsuMDr+u9UaNcLIyB6EQTkX8V/WD7Tu+4XPMOBZD
         8a5mz2vOL/6cX3W/saM8WpJzx31P+QUUamNLviOY85Vuok/LinfsufEhoaw6MZ8yVXST
         GVBVlCqi9M3CnVd2Q4ijkdVhVsF7JaU/rOHiiqD9pf4K6jYu5WG9kF2HxRyFxNdfC4kZ
         17MSfiTZHRNeVo5qTacqP0gN9HRbHG0AXmwxcN3Je9nuHAehkYRVOg6cxxzPxg5NP2lZ
         e8Nw==
X-Gm-Message-State: AOAM531FrgRrxBnc32jWEEd+cTtb6N9K2MIbibEJs7Kq0lxzloGXBItK
        hnPPoP3d/adfZfKwmDVTwh45ZqCzcNCR2fHs8yowhPvbNPo=
X-Google-Smtp-Source: ABdhPJxWRhlLd73xrWLBTdl6wz0JyREpItsaujS3cleDpZ9WEAPe3FjiUR5EgczFuYZdpsrmnerPhs/RL8X5ddyyKHE=
X-Received: by 2002:aca:220a:: with SMTP id b10mr13980732oic.101.1630294343178;
 Sun, 29 Aug 2021 20:32:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210824071926.68019-1-benbjiang@gmail.com> <fe512c8b-6f5a-0210-3f23-2c1fc75cd6e5@tessares.net>
 <CAPJCdBmTPW5gcO6DO5i=T+R2TNypzbaA666krk=7Duf2mt1yBw@mail.gmail.com> <f9b97b7f-cb48-f0bf-2dfb-a13bf1296b19@linux.intel.com>
In-Reply-To: <f9b97b7f-cb48-f0bf-2dfb-a13bf1296b19@linux.intel.com>
From:   Jiang Biao <benbjiang@gmail.com>
Date:   Mon, 30 Aug 2021 11:32:12 +0800
Message-ID: <CAPJCdBmqPgbxYTvViRQrzLgmNjQWc4PRmw_yScLgp0ktt-dVCQ@mail.gmail.com>
Subject: Re: [PATCH] ipv4/mptcp: fix divide error
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel <linux-kernel@vger.kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Jiang Biao <tcs_robot@tencent.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Aug 2021 at 01:56, Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
>
> On Tue, 24 Aug 2021, Jiang Biao wrote:
>
> > Hi,
> >
> > On Tue, 24 Aug 2021 at 15:36, Matthieu Baerts
> > <matthieu.baerts@tessares.net> wrote:
> >>
> >> Hi Jiang,
> >>
> >> On 24/08/2021 09:19, Jiang Biao wrote:
> >>
> >> (...)
> >>
> >>> There is a fix divide error reported,
> >>> divide error: 0000 [#1] PREEMPT SMP KASAN
> >>> RIP: 0010:tcp_tso_autosize build/../net/ipv4/tcp_output.c:1975 [inline]
> >>> RIP: 0010:tcp_tso_segs+0x14f/0x250 build/../net/ipv4/tcp_output.c:1992
> >>
> >> Thank you for this patch and validating MPTCP on your side!
> >>
> >> This issue is actively tracked on our Github project [1] and a patch is
> >> already in our tree [2] but still under validation.
> >>> It's introduced by non-initialized info->mss_now in __mptcp_push_pending.
> >>> Fix it by adding protection in mptcp_push_release.
> >>
> >> Indeed, you are right, info->mss_now can be set to 0 in some cases but
> >> that's not normal.
> >>
> >> Instead of adding a protection here, we preferred fixing the root cause,
> >> see [2]. Do not hesitate to have a look at the other patch and comment
> >> there if you don't agree with this version.
> >> Except if [2] is difficult to backport, I think we don't need your extra
> >> protection. WDYT?
> >>
> > Agreed, fixing the root cause is much better.
> > Thanks for the reply.
> >
>
> Hi Jiang -
>
> Could you try cherry-picking this commit to see if it eliminates the error
> in your system?
>
> https://github.com/multipath-tcp/mptcp_net-next/commit/9ef5aea5a794f4a369e26ed816e9c80cdc5a5f86
>
Errors' gone with the patch.:)

Regards,
Jiang
>
> Thanks!
>
> --
> Mat Martineau
> Intel
