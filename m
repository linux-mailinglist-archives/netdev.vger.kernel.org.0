Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E0833972E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhCLTJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbhCLTJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:09:37 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D266C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 11:09:37 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id e21so11059668vsh.5
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 11:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e7t9VojiwipX4c0DRhanIDC4EbKbaw1JgeC7dh9/MO8=;
        b=o08uydWy9F4YyPA6hhBy2OBscsfZKNrXdsZH83oOzGF+TOyN1Z4hISahePWEHIsrnF
         QfAlSd+9BGHZ9Q3LFbalQ8eNEkP0dtCnP7FiBVJD9ewYmeUWJOVm1A4sD8x6GrrSLCiE
         vNrZyM4R1Kr4mNmVZe9/HQOAZq7l0iQv/F0GmjVf0S018n+vgFFysM9dCb7OgeJNDhCY
         BVvXDlQL+N6lVLEsZtUfJnE5iv7rVEnkZtPovB74bsIe+cE65gXBK65bW7ktAES5JlaM
         nnvzXvUWjEeVgV1KZQh28eU34BQl8jNi8tR0FVlAYwdmY2F7rKwNoxMBZyB6+Ubp3McF
         kaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e7t9VojiwipX4c0DRhanIDC4EbKbaw1JgeC7dh9/MO8=;
        b=PqbwIp2XG+8bqVsXNXzga2/sJw19EXhv6vqWNt9L8ITDFNL8HRh4SVs4GPa+D0MLJH
         yL+3WmmHJElFjagQAG7dqt5e31yofdEWny6lOEj3tziTu0TevUfZoIIPfSb6RmGOaEEz
         +u2xUwkAnjxapsp92s4jIaNIWWdw14VKPg2Huep/doDIL+fKyLBqSLSkOV93JzilTERx
         0ceNT4GaetfYC5f061EdIzNXo9xJLT9X0MTsC3+VBofMXVY6TLmopqdXtKVpjuhLVoq3
         8+h0OmYPyWvQ3xGDJVmlDepgdSy1gJyrCQZLOam6rGRbvFx7TLGCFte+7AYQ0doLArws
         4f2w==
X-Gm-Message-State: AOAM532iEaHIVZi0DyK1UFA6twUeMojkRv5EfAKnvXQDzYQOtIHE3G8i
        ttBFRk3QmfMRAv8DnfPio3qf2+YClybJ0baqS7o0aA==
X-Google-Smtp-Source: ABdhPJxvn9Cq+22q4BiAMsAECZ+Zh/E5gmtQVktrPL4UZRrmuAAld72+wJRbxVB7Q9o+4+gJ3TQcDhoC7cYbsGfKCbw=
X-Received: by 2002:a67:1005:: with SMTP id 5mr9565286vsq.52.1615576176281;
 Fri, 12 Mar 2021 11:09:36 -0800 (PST)
MIME-Version: 1.0
References: <20210311203506.3450792-1-eric.dumazet@gmail.com>
 <20210312101847.7391bb8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAK6E8=dwWsvnimB1VW2WUcnVHQ298E6uuo0v9ej92TawAV+S2Q@mail.gmail.com>
In-Reply-To: <CAK6E8=dwWsvnimB1VW2WUcnVHQ298E6uuo0v9ej92TawAV+S2Q@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 12 Mar 2021 14:09:19 -0500
Message-ID: <CADVnQynwUZxaCyWgAikounP6esrKNy9Z40cA30aLBCVf8QNwiQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] tcp: better deal with delayed TX completions
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neil Spring <ntspring@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 2:05 PM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Fri, Mar 12, 2021 at 10:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 11 Mar 2021 12:35:03 -0800 Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > Jakub and Neil reported an increase of RTO timers whenever
> > > TX completions are delayed a bit more (by increasing
> > > NIC TX coalescing parameters)
> > >
> > > While problems have been there forever, second patch might
> > > introduce some regressions so I prefer not backport
> > > them to stable releases before things settle.
> > >
> > > Many thanks to FB team for their help and tests.
> > >
> > > Few packetdrill tests need to be changed to reflect
> > > the improvements brought by this series.
> >
> > FWIW I run some workloads with this for a day and looks good:
> >
> > Tested-by: Jakub Kicinski <kuba@kernel.org>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Thank you Eric for fixing the bug.

The series looks good to me as well.

Re this one:
-               WARN_ON(tp->retrans_out != 0);
+               WARN_ON(tp->retrans_out != 0 && !tp->syn_data);

it seems a little unfortunate to lose the power of this WARN_ON for
the lifetime of TFO connections, but I do not have a better idea. :-)

thanks,
neal
