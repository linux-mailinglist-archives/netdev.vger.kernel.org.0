Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED26BE0E7E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 01:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389560AbfJVXYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 19:24:45 -0400
Received: from mail-yb1-f176.google.com ([209.85.219.176]:32846 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389382AbfJVXYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 19:24:45 -0400
Received: by mail-yb1-f176.google.com with SMTP id h7so5740316ybp.0
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 16:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JNZ9cQQy/+YTISqxyV+yCK168ushSuYj3Ro5Pm4Btfk=;
        b=Eng172xJ2oqEmzdTrw1Jn5B17kPsWhJn319VtQg2922gXYUypXeN189FCoyFcQjhE6
         DlkgF/QKrdePvMChqge2ju7Cx9eS2ZuFnaSpmspf2AtXzyLGyO0Z2JyXG5HLQnMx4Vj0
         DxdCDzAqP7JpUY3VeFHEcf5rALtabrMB6GnNyUF/OkWgHClJll1j/NSPg9o4qWcDYYaN
         4ctLLYXZhd1vHfTK6Ew5eFfmyPWhP9bHLXDX0EjMzKPtXHqQCv5e25fG8KIvducWPi+U
         txHJZ5fus3govpwMMi70v9KPfcqVgshnEPCsrUkdw//3r6Gcy4h7rfqo3IcMQ5KgThR+
         hypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JNZ9cQQy/+YTISqxyV+yCK168ushSuYj3Ro5Pm4Btfk=;
        b=ATCtFFW/t65iuYMzVU2E0/mbCd+fV7P3+DsghOseNOq/h14NbxU3SG7LIjuAjDYN8G
         DJIZBwSxuoNrpkwedeEWVusPgqzHSI1h2PSRhhQqJFHKoouIUO0U1YyHzk2Yf8CaOTvz
         RGba+Kf3JbjOoauW7MdNcK7XUuJa1RfZc1aiVdg0qRn/PnNgVK1XjIdYI1CxYax1GfsI
         gEaxyWf6XMF3eZDQDRscaEh20xQkkGQ01rZoFUQNGt1+VdDINGnPxyC/CIzbGSYRBGg+
         LwqHbKYa/M7stZfh5a0CZQdcodHkAoh2//4irFGj5wIEvD2OjLTPLV95Vjmo4lC+mcD1
         RhAQ==
X-Gm-Message-State: APjAAAWtoRPyV/1ebpsKFM29L+8VJ/ziSWvNugtm9N/b2pZ9NqeY7U8d
        kpct31246l/vyC16OnJc5yg6BK7qkuuT/djX4FKCPw==
X-Google-Smtp-Source: APXvYqyqqb6TlGtoZwiXHN5itq1sJDNfj/mC/82mYGjo42NHoQQphL2S1nYSB7VK4MxxI0V9XV5aN2RhUCpvxoNC3G4=
X-Received: by 2002:a25:a085:: with SMTP id y5mr4368492ybh.408.1571786683709;
 Tue, 22 Oct 2019 16:24:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com> <20191022231051.30770-4-xiyou.wangcong@gmail.com>
In-Reply-To: <20191022231051.30770-4-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 22 Oct 2019 16:24:31 -0700
Message-ID: <CANn89i+Y+fMqPbT-YyKcbQOH96+D=U8K4wnNgFkGYtjStKPrEQ@mail.gmail.com>
Subject: Re: [Patch net-next 3/3] tcp: decouple TLP timer from RTO timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 4:11 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Currently RTO, TLP and PROBE0 all share a same timer instance
> in kernel and use icsk->icsk_pending to dispatch the work.
> This causes spinlock contention when resetting the timer is
> too frequent, as clearly shown in the perf report:
>
>    61.72%    61.71%  swapper          [kernel.kallsyms]                        [k] queued_spin_lock_slowpath
>    ...
>     - 58.83% tcp_v4_rcv
>       - 58.80% tcp_v4_do_rcv
>          - 58.80% tcp_rcv_established
>             - 52.88% __tcp_push_pending_frames
>                - 52.88% tcp_write_xmit
>                   - 28.16% tcp_event_new_data_sent
>                      - 28.15% sk_reset_timer
>                         + mod_timer
>                   - 24.68% tcp_schedule_loss_probe
>                      - 24.68% sk_reset_timer
>                         + 24.68% mod_timer
>
> This patch decouples TLP timer from RTO timer by adding a new
> timer instance but still uses icsk->icsk_pending to dispatch,
> in order to minimize the risk of this patch.
>
> After this patch, the CPU time spent in tcp_write_xmit() reduced
> down to 10.92%.

What is the exact benchmark you are running ?

We never saw any contention like that, so lets make sure you are not
working around another issue.
