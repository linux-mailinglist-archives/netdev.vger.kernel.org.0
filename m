Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E27F362685
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240536AbhDPRPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239820AbhDPRP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 13:15:28 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32821C06175F
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 10:15:04 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g16so5469736pfq.5
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 10:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=umErYAmVGAbwwXVAd5BMkpTRo3eAmL116FdgOjKC22k=;
        b=fcQAhLzmPamy63PUDdyzNodf7R91FQH31GBcWfpSXGgaoQnH9vT7aH3Y8G8+ya6LUZ
         4iAlnP7KmmfOIXDnPKm083D99P9Hnq5EUXnvZNnL2O8KV5nrLInpd4ECF/QQaNZoYKfY
         qdiZbsei8Df9X8Koqz1gN1tezb2o+t4+Ou8CznV+SFQsvPITOZEYb0PdE3d4bDWLVWYq
         RYU+JCQkjXlsVgBZx/IHj5i1ZqUg/Cyyvhg+lGtoGzNtkaG/z4Y8Ikc0XSB+Blqv4ZpB
         zDWNwavjQ3E0texEUfxGNX6aAhs3FwDmFg/ZJTS5cCVOmyJHfoYnZhb1CFwzJE6eM+nG
         Qouw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=umErYAmVGAbwwXVAd5BMkpTRo3eAmL116FdgOjKC22k=;
        b=V6P+C1tpIJqEct4ahY0+HTtRX4vzvI+mEdoLRuowNRKLAQzK5BuW7Hpwx70PNLBdDN
         5LLbHa1YT3hFCihcLSkzIEVnpovKH368YOb/n8GBswcLmv316u9S/Up4Nwpq5+s5uxzs
         uieTcQcnoXDAvQvH1jYWSW3ppo+QHBJxHGc/SZVt0LFcc4MOtqrTnkS6307KR+A15ZjF
         xba6gcASKG2eXbiws/ioR82ubmyyaHNNLi7Kw/E1jwufntRy34BbC4r9zmUplfNU8Lei
         2FARwdsG9f6n0Q0ExK+96ZygFH3FgzqdafRNR0b8NI4f1Zda+cflJnEWYGloBV/R+QTe
         CWAA==
X-Gm-Message-State: AOAM5305PR+S2dr5OsGD3H3SpK2IVzoIvAPjwRwZzGXhjj2kPo94gHwB
        N4VBLtgzpDY/DHdk5QdFm66Z7k/x/EuLMWYwkUQ=
X-Google-Smtp-Source: ABdhPJxTEHCjy8VPGXG9fbw4koU9h+lwpWhWDaRTsacdMLi2eAmVBRy8jLg1x7/eqsBfCPqeOXxnAPiinA9gmRvMmb4=
X-Received: by 2002:a63:6a41:: with SMTP id f62mr114973pgc.428.1618593303711;
 Fri, 16 Apr 2021 10:15:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210415231742.12952-1-ducheng2@gmail.com>
In-Reply-To: <20210415231742.12952-1-ducheng2@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 16 Apr 2021 10:14:52 -0700
Message-ID: <CAM_iQpWs3Z55=y0-=PJT6xZMv+Hw9JGPLFXmbr+35+70DAYsOQ@mail.gmail.com>
Subject: Re: [PATCH v3] net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule
To:     Du Cheng <ducheng2@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 4:17 PM Du Cheng <ducheng2@gmail.com> wrote:
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 8287894541e3..abd6b176383c 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -901,6 +901,10 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>
>                 list_for_each_entry(entry, &new->entries, list)
>                         cycle = ktime_add_ns(cycle, entry->interval);
> +
> +               if (!cycle)
> +                       return -EINVAL;

Just a nit: please add an extack to explain why we return EINVAL here.

Thanks.
