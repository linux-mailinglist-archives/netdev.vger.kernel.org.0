Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A5A332DBB
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 19:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhCISBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 13:01:25 -0500
Received: from mail-yb1-f170.google.com ([209.85.219.170]:35722 "EHLO
        mail-yb1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhCISAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 13:00:54 -0500
Received: by mail-yb1-f170.google.com with SMTP id p186so14921977ybg.2;
        Tue, 09 Mar 2021 10:00:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d09tCXoDPz/gPvVq2LzHz5z3xcmuD/lr6SC5zub3HT8=;
        b=rygDn7jEP/jVCCdNu/wZ8/oQvZB9aip92Ajz55aoRRyNGnMB2RcJWDLorpFOHNFJn3
         dGh+a8A18TyyWtUQNkPTb9D3pqJiKEuGYaDLuIct10u/4cZdTtFOVoq+wL4xyvWpRmxl
         M9gWbmq4S1g9ZwNvZNPguBF86lazVLSTGeGLp25S2cLaX3p5R9EqEDQOe3hQ7Tsn9oQ9
         0p1HLnuQSo7bq3Yfbhvf0uvWSLLNWASi3c+gR53YtvhsSCgkFOG+yy/DkWNNCwXC3jTA
         0y/bwA53xiVQ8msCM8iiZaCR6uz9rbs7/oiNSOABje3D6CChw2ihH3DlEEIHjn7CWAEE
         wNOg==
X-Gm-Message-State: AOAM531NxcQpUAFfgpf/X4CnggYxjq/ImQPVp0VVAYDhu31IzKEZBQkx
        4Wt82DqcEjbvj72jIws+Mp9EVXrznfB2gL0OIYo=
X-Google-Smtp-Source: ABdhPJxnh4XwyORoIaJFyZrpzJ3MnNuNx8SJSawU6P0DnrxP2BS6a2mjJjwPIDMt5lVtM+jf44yiDTHpTy1kCwpD0co=
X-Received: by 2002:a25:3853:: with SMTP id f80mr41403299yba.514.1615312853886;
 Tue, 09 Mar 2021 10:00:53 -0800 (PST)
MIME-Version: 1.0
References: <20210309152354.95309-1-mailhol.vincent@wanadoo.fr> <20210309152354.95309-2-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20210309152354.95309-2-mailhol.vincent@wanadoo.fr>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 10 Mar 2021 03:00:43 +0900
Message-ID: <CAMZ6RqJ8e0sQPvaT_6dVOwisnHj6m+STgdnmLmmQxzV0+uHbvw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] dql: add dql_set_min_limit()
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 10 Mar 2021 at 00:23, Vincent Mailhol
<mailhol.vincent@wanadoo.fr> wrote:
>
> Add a function to set the dynamic queue limit minimum value.
>
> This function is to be used by network drivers which are able to
> prove, at least through empirical tests, that they reach better
> performances with a specific predefined dql.min_limit value.
>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>  include/linux/dynamic_queue_limits.h | 3 +++
>  lib/dynamic_queue_limits.c           | 8 ++++++++
>  2 files changed, 11 insertions(+)
>
> diff --git a/include/linux/dynamic_queue_limits.h b/include/linux/dynamic_queue_limits.h
> index 407c2f281b64..32437f168a35 100644
> --- a/include/linux/dynamic_queue_limits.h
> +++ b/include/linux/dynamic_queue_limits.h
> @@ -103,6 +103,9 @@ void dql_reset(struct dql *dql);
>  /* Initialize dql state */
>  void dql_init(struct dql *dql, unsigned int hold_time);
>
> +/* Set the dql minimum limit */
> +void dql_set_min_limit(struct dql *dql, unsigned int min_limit);
> +
>  #endif /* _KERNEL_ */
>
>  #endif /* _LINUX_DQL_H */
> diff --git a/lib/dynamic_queue_limits.c b/lib/dynamic_queue_limits.c
> index fde0aa244148..8b6ad1e0a2e3 100644
> --- a/lib/dynamic_queue_limits.c
> +++ b/lib/dynamic_queue_limits.c
> @@ -136,3 +136,11 @@ void dql_init(struct dql *dql, unsigned int hold_time)
>         dql_reset(dql);
>  }
>  EXPORT_SYMBOL(dql_init);
> +
> +void dql_set_min_limit(struct dql *dql, unsigned int min_limit)
> +{
> +#ifdef CONFIG_BQL
> +       dql->min_limit = min_limit;
> +#endif

Marc pointed some issue on the #ifdef in a separate thread:
https://lore.kernel.org/linux-can/20210309153547.q7zspf46k6terxqv@pengutronix.de/

I will come back with a v2 tomorrow.

> +}
> +EXPORT_SYMBOL(dql_set_min_limit);
