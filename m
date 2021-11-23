Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFA145A36D
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbhKWNGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:06:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236744AbhKWNGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:06:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637672602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gJS2hE9meSrfHb6e5NHCGdUmWvOoiL3+X/GKhzTkYq8=;
        b=KC/p5haaOBnrHtV2+IgOY0EwGQc+s3SFagZkxbglDeVmEniQoPHL/KyhklYYjRBzltfra4
        sfOS2dsUj2G6GAslVpdGLucYY/T9PHW4X0skzH1UnWRSdlcBjpQUZB++g5WAMITGfsv/Ro
        2cZ8Zmsr9nwUKViBDOJhchAaTsewbFA=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-Be-BDnt-Mcajgk-XNNEo4w-1; Tue, 23 Nov 2021 08:03:20 -0500
X-MC-Unique: Be-BDnt-Mcajgk-XNNEo4w-1
Received: by mail-yb1-f197.google.com with SMTP id l145-20020a25cc97000000b005c5d04a1d52so1660718ybf.23
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 05:03:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJS2hE9meSrfHb6e5NHCGdUmWvOoiL3+X/GKhzTkYq8=;
        b=E3A/ZYfikuter40X6c5ZT3cDCgq4g84DAGoSxllL9+4tr9F4BfuaDIO+xZOZq86ffi
         s2kUCypsp/R+AJv2IM2AK2JHK+0Exzt71FeLMai9RsxJGe31OPTQhbMlzQhF4p1LF336
         IH9Zd04M81sUoY9FiVo2W9UtFUUcxczdkta5aU5b44hnqK3992VpFW21muzIZHrybW+w
         STpzgpCNcxJjbktAWpUUhLTBpt0evrwBvr9J+7iOIIwOrcLiGE7jpEcTOiq2pueyc1iz
         vV/En399IGB6nJYSBfDNQuKGOk4sjibaW4ED4+7rOXpKiu7n+FnAObDyAlsRMdx3w+7M
         5ARw==
X-Gm-Message-State: AOAM533npEFjDS2c29Cb34nxXyZH9k0aeinTwbzSPn/9ZKdPyicIKKpi
        cr9BIdeRFyK5ryYVgVmXLbSwRzeCYMR4xl8N3Aau4Tw851EikXpkvg9JJUTPyQN4d26QZxo6dnu
        hkBAzVsCX1xmhKR6NGGY+GpKLAsmlsELX
X-Received: by 2002:a25:82:: with SMTP id 124mr5994835yba.490.1637672599813;
        Tue, 23 Nov 2021 05:03:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx90litci3a2IS4xD3UYEwrFDH7+6fJ9NHE4ABuck1+GRf/xlknv//V79K+ZvkhjFcUMrb7VoWZ994CsBmjLLU=
X-Received: by 2002:a25:82:: with SMTP id 124mr5994720yba.490.1637672598897;
 Tue, 23 Nov 2021 05:03:18 -0800 (PST)
MIME-Version: 1.0
References: <7f383e1d5d343f5703bf5c3ee89a1f4c9c5977d2.1637666466.git.dcaratti@redhat.com>
In-Reply-To: <7f383e1d5d343f5703bf5c3ee89a1f4c9c5977d2.1637666466.git.dcaratti@redhat.com>
From:   Davide Caratti <dcaratti@redhat.com>
Date:   Tue, 23 Nov 2021 14:03:08 +0100
Message-ID: <CAKa-r6skpM6YDoU5i-d34v+9UwKfVe-P1cOFRqynB5h7jJCogg@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: sch_ets: don't peek at classes beyond 'nbands'
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

On Tue, Nov 23, 2021 at 12:29 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> when the number of DRR classes decreases, the round-robin active list can
> contain elements that have already been freed in ets_qdisc_change(). As a
> consequence, it's possible to see a NULL dereference crash,

[...]

> diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
> index 0eae9ff5edf6..3b4ae56ebb19 100644
> --- a/net/sched/sch_ets.c
> +++ b/net/sched/sch_ets.c
> @@ -480,6 +480,10 @@ static struct sk_buff *ets_qdisc_dequeue(struct Qdisc *sch)
>                         goto out;
>
>                 cl = list_first_entry(&q->active, struct ets_class, alist);
> +               if (!cl->qdisc) {
> +                       list_del(&cl->alist);
> +                       goto out;

on a second thought, we probably can do better than 'goto out'.
The round-robin list might contain some other entry, so probably it's
better to cxheck if the list is now empty, and if not re-do that

cl = list_first_entry(&q->active,...)

assignment. So, 'dequeue' dequeues the first valid skb in the round
robin even after cleaning up those no-more-valid list entries. I will
send a v2 in the next minutes.

-- 
davide

