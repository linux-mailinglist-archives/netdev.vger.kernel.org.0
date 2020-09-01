Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35906259569
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 17:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgIAPuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 11:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728408AbgIAPuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 11:50:37 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51409C061258
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 08:50:31 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id w12so1292988qki.6
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 08:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jV8bljM3lK+GBB6jw/WspxqJuyJuh/lf4f+szOAk3Fw=;
        b=XZCGQwgwBt860UII5cREakpxcHTR71LTVSlB36D/ju3AvUYviLZB4KikFD+0jTIyh4
         elj6nui5j6HeINBSDmNWHrIdG34Uv3wns0bdy9KTaoVYV+kisqyRNmJSOgrYLuePTrad
         lA3IdMFJZtWBxBXHGSaG/pYJoPXIiHRGQ618S7d0TpMG/bMbJyArJDrv/7cZrSJ2Yojz
         mFwtdlJXC2TzgWARoJGIRfZ659fxiIKfJZwTq6NzfUmje2J3LyDHznp3jhgy78USqdaf
         r3yjjGj0lEMDSnlPQp5OvFZlLTcgShRmFUDnTX8/kuG4fVTST5BA+0DKvJ/FMGBpjY70
         VFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jV8bljM3lK+GBB6jw/WspxqJuyJuh/lf4f+szOAk3Fw=;
        b=Sniz3htTOy2XWU16P8wa/Ogb2qLiEEjqcXIcpiWlbvKB2+5uml1YoNWQc3VZuWkGbB
         9F9I8/yxk+sjdo32I4WoZQkrr3OdTRxsj8mwAK6bTWLw3aYtyhd2dnL008FJ37RjtQoH
         fs3bCD6bWxKr7jVmNhsVG5uwfVcsL1locRnbyqIXyVVwOazSYkxmNlQYB34PcW0WZbmg
         oKlzW007xqWO1yY+M4Y8NnmQOKbiUO2pkUE//sdtAj9Y7mXkiBonQOLNazo24ZPrTgJY
         hoWROZ/AITdMRh73lSjpyljau+h13e88wqB4JpemO81BFAkHym/FJuDSa7rVsZHU2BJK
         xu+A==
X-Gm-Message-State: AOAM533MccxdBmMPzNghAQH64DAIEUMPTaoLwnhiF766fV6F8XGc6R2p
        KUMgBEe0mtlUldlvy1ZGQxbZS/UhNozcFfvJZTQ/YQ==
X-Google-Smtp-Source: ABdhPJzkzDW/A2xwJZao0bULy5cxXeAqA2rpndP/DYOEayvx3lxC0orZ2wXvB+yxIaKuMONJzHiBClgTfH9lIzLya+E=
X-Received: by 2002:a37:9d4:: with SMTP id 203mr2555955qkj.277.1598975430108;
 Tue, 01 Sep 2020 08:50:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200901065758.1141786-1-brianvv@google.com> <CANn89iKA5Ut4AcZfsZi3bVpE33_pqgO=E1RhBzePUeBDn6gznQ@mail.gmail.com>
 <52832405-fa37-38fb-b8fb-d7bd7a0d1d52@gmail.com>
In-Reply-To: <52832405-fa37-38fb-b8fb-d7bd7a0d1d52@gmail.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Tue, 1 Sep 2020 08:50:18 -0700
Message-ID: <CAMzD94TmFiJRfgLp44z1GQ1zzg2Zy7o2Oa9GTTCed0kj5tLdLg@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: fix __rt6_purge_dflt_routers when forwarding
 is not set on all ifaces
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey David,

On Tue, Sep 1, 2020 at 7:57 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 9/1/20 1:56 AM, Eric Dumazet wrote:
> > On Tue, Sep 1, 2020 at 8:58 AM Brian Vazquez <brianvv@google.com> wrote:
> >>
> >> The problem is exposed when the system has multiple ifaces and
> >> forwarding is enabled on a subset of them, __rt6_purge_dflt_routers will
> >> clean the default route on all the ifaces which is not desired.
> >>
> >> This patches fixes that by cleaning only the routes where the iface has
> >> forwarding enabled.
> >>
> >> Fixes: z ("net: ipv6: Fix processing of RAs in presence of VRF")
>
> are you sure that is a Fixes tag for this problem? looking at that
> change it only handles RA for tables beyond the main table; it does not
> change the logic of how many or which routes are purged.

That commit also added RT6_TABLE_HAS_DFLT_ROUTER so I thought that was
the commit needed to be mentioned. But probably it shouldn't?
Also Am I missing something or this is only called on on the sysctl path?

>
>
>
