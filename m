Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B37339711
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbhCLTF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbhCLTFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:05:08 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5809EC061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 11:05:08 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id o14so1589352wrm.11
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 11:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iY/u/SQWhog5eUnKwtEvL9FiwwaCIX67ZjvFu/EkG+g=;
        b=SPxQj/y/gXace2ITZHX4E6QEYDxqP92LBE/+s1IixwjN7EPkgGJ99KxAR25cOwh5mW
         rXRL4Ve5CDXjtDTdrQYpnXX8KwszjopPqG5xkWtRWB0i+AlurA/tO8uW+FApm8yA+q/D
         nxWDet/cvkLC5edS7u4wHTFYWJSNAyWG/mzj1jUB6ns1wZr6vG46swo7rJdZfht3W70x
         5r4DcONna94BQOweHQNeu6UA/5GuEj9xhpxlpT5/Ll4xP6Y2kr8zNeSGKHuUuBYo5e0M
         2H21SDmP0iRr0b8HuFJAG4HLufUdnw1i78vlgBRCaKdW06sSWKmxcmE0WjtMdAzYYpTA
         yNOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iY/u/SQWhog5eUnKwtEvL9FiwwaCIX67ZjvFu/EkG+g=;
        b=LM5mmEaG55kQXiEnORwMBbNivaIf8FFcWOjSEvdfhPMGGxQ5UfHuOnyrzFfZ173tG2
         n4rDQLonZivHW706m/LKPAzPxxjoW9FWn74DhxpxwmfWuBF21lRuUdnJMzqppt3i0e+T
         HIB2g3nqVThIuKCcwEQgV73e9fpRuV3ZE4jJbCcXfk66xsCffiL/4Be6fxzf5zeCUgYR
         iSk6RXDx/AKU7v9YVVzpxdp1nODnH2APpoYNJ9rGScuTJtC90nHdnay0czo9wj1QYTey
         oNwnUJcTM+GNb7tiwrVB8PJ45u2Rp/TvdGz0bAO/BALLusUtQvup4rXJSBlMRnTnM5VM
         EZcQ==
X-Gm-Message-State: AOAM530QI5vY20nriKvxiVLbmJ9dhbHReLbIxYZoTnAx/VoDxPOptVJA
        /EDJ5nN2N94ytE/+P+VpE7jYqq3GoZnoZdb6Erfnew==
X-Google-Smtp-Source: ABdhPJw/DjQyA73OdC3xtya2v02P6yb/CWBkx0i1v7kgMZHSCw6qoRHdJrQHdOkD/u4ggAES1X/jtDF0uUxwsdhkBOo=
X-Received: by 2002:a5d:6a49:: with SMTP id t9mr15811916wrw.131.1615575906905;
 Fri, 12 Mar 2021 11:05:06 -0800 (PST)
MIME-Version: 1.0
References: <20210311203506.3450792-1-eric.dumazet@gmail.com> <20210312101847.7391bb8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210312101847.7391bb8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 12 Mar 2021 11:04:29 -0800
Message-ID: <CAK6E8=dwWsvnimB1VW2WUcnVHQ298E6uuo0v9ej92TawAV+S2Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] tcp: better deal with delayed TX completions
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Neil Spring <ntspring@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 10:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 11 Mar 2021 12:35:03 -0800 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Jakub and Neil reported an increase of RTO timers whenever
> > TX completions are delayed a bit more (by increasing
> > NIC TX coalescing parameters)
> >
> > While problems have been there forever, second patch might
> > introduce some regressions so I prefer not backport
> > them to stable releases before things settle.
> >
> > Many thanks to FB team for their help and tests.
> >
> > Few packetdrill tests need to be changed to reflect
> > the improvements brought by this series.
>
> FWIW I run some workloads with this for a day and looks good:
>
> Tested-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Yuchung Cheng <ycheng@google.com>
Thank you Eric for fixing the bug.

>
> Thank you!
