Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9642B21C1F7
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 05:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgGKDxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 23:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgGKDxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 23:53:15 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626AEC08C5DD;
        Fri, 10 Jul 2020 20:53:15 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id j10so6075893qtq.11;
        Fri, 10 Jul 2020 20:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z6AWxd/5FGxxwuquMSsRnXjurO0TQ1vFQCnKi381IDk=;
        b=C6VcTj4xMiKCEMQoy5rLWrZmdNXOcvN+ZJWsPgA9F3KDPpSTwuPddnzlcvjzaKviDr
         36i/TPtGiY1XVQCDCjvcjth6U2AL3ZxXYLYsQZSQ1recPIH7ulfuNjErU6j0rezNvOWM
         5+GEBf+5tYDU3h9DQX5dC0ozoCRszTSkW6hoU2r+HeYbu8/JGVfZKxFFrzYOhJ6YQyxh
         USF0vCFLTGo0LFcP91ac6lr7NIv1CICrork6aBlnlYwSIp5sVTUVSTJhhX7E9fh3v1xg
         Yo8NotMYcQRJbM7zYazEa97OHP5uKQuXNsjTpCjrSg7KurH5U6wsmi1wdBCGJtSlD3q8
         xTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z6AWxd/5FGxxwuquMSsRnXjurO0TQ1vFQCnKi381IDk=;
        b=uBA/1EffQo+rn7sr0ClHhi+bJurc/YBs+MIul7ZpkhMDn0IZwHxm73+rc46ZRhKMiF
         vJfJf1/pS1ibZMrbd3ajNpH/t4NnXYiB2DrvSeItYbM69mH17RNk9wiedb6xSBOWIpOq
         ixDrAKs8yE2HT7+8QvcL0lXm/gFwQZ2DqfNn5KhZ/vDt07kertgGXxThWFkNDXD7f+lX
         C50rTVP+lsJjJ9qhtt0MYS7RYotaDDd9fOsoqvh7bUxo1Dqf/iJdN4xn7OfUHUJjTRlj
         FwXrORCSShB9du2pGC0btyMjDvM4lcefjQacYZaim/ps+8WVTavlIUxKoP9+NwzIMcV1
         bONg==
X-Gm-Message-State: AOAM530oXK5seH8HX5Bw7ox6hWSrm4Wmw5m0lfDBItC3payNoQVHhcE+
        p2palbTGGpqHg44MbufZDmdc5Vmo/MnyKypbCVw=
X-Google-Smtp-Source: ABdhPJwgVQL48QhDtJJQVaXSbLNISPQqNbnZ3eCE90UTFVul8XrkkQj4mMMjzfQjXuY4Ls28ymvubqCEz1Bz8OM/M94=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr71393499qtj.93.1594439594578;
 Fri, 10 Jul 2020 20:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200711012639.3429622-1-songliubraving@fb.com> <20200711012639.3429622-2-songliubraving@fb.com>
In-Reply-To: <20200711012639.3429622-2-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Jul 2020 20:53:03 -0700
Message-ID: <CAEf4BzaHAFNdEPp38ZnKOYTy3CfRCwaxDykS_Xir_VqDm0Kiug@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] bpf: block bpf_get_[stack|stackid] on
 perf_event with PEBS entries
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Peter Ziljstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 6:30 PM Song Liu <songliubraving@fb.com> wrote:
>
> Calling get_perf_callchain() on perf_events from PEBS entries may cause
> unwinder errors. To fix this issue, the callchain is fetched early. Such
> perf_events are marked with __PERF_SAMPLE_CALLCHAIN_EARLY.
>
> Similarly, calling bpf_get_[stack|stackid] on perf_events from PEBS may
> also cause unwinder errors. To fix this, block bpf_get_[stack|stackid] on
> these perf_events. Unfortunately, bpf verifier cannot tell whether the
> program will be attached to perf_event with PEBS entries. Therefore,
> block such programs during ioctl(PERF_EVENT_IOC_SET_BPF).
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

Perhaps it's a stupid question, but why bpf_get_stack/bpf_get_stackid
can't figure out automatically that they are called from
__PERF_SAMPLE_CALLCHAIN_EARLY perf event and use different callchain,
if necessary?

It is quite suboptimal from a user experience point of view to require
two different BPF helpers depending on PEBS or non-PEBS perf events.

[...]
