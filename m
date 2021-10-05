Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43824224C7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbhJELQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:16:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233514AbhJELQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:16:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633432455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z6j5kDP9a85am6Js/oUgKy2JNfR+Qv1TzJL2pu2qLq0=;
        b=WG/U9RZLyYVTEjRTUEDZwRekCi/eol45XWAo9MO5zOUlN28OuLRE8ZBvNPDidw5KCnoanQ
        5j5lmX9i74LbteIfxWT3EJSpn1qWA8Mw3yh0WRbQdp/53slxDB/YOpZUU10sxIPAbPwRXz
        Z5/8KWq+h5qZ0GJm2DnZCeXbpQSr+CM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-yOJVAjSXOGKpiK2Rc5e56w-1; Tue, 05 Oct 2021 07:14:14 -0400
X-MC-Unique: yOJVAjSXOGKpiK2Rc5e56w-1
Received: by mail-ed1-f70.google.com with SMTP id k10-20020a508aca000000b003dad77857f7so4378629edk.22
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 04:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z6j5kDP9a85am6Js/oUgKy2JNfR+Qv1TzJL2pu2qLq0=;
        b=glEBBTsGodyg60pqKyIJGUZa/exZtzjfiXmchJt3j83TZ2dkQNj/6FfRO9Kz64Lthh
         kqfx7OzyeLwwvO/35+87GHKTLbwp9435AfBAJ1/jxltwnphu3ovErXjfS4vc1aTX8RqJ
         LEFtmn4Enr4qGydxfF4dS3hQ0u71Ip8eq2eBE5qOcmmdBOcJWSqmr8uM+jNhd0YWx17a
         tzgCSbsQDv0rN222oJagQGgsNbdmST9dQGZVnxRK1f4JHxaeOkPftLdP+e/02aYRMmMg
         geAgrzFduVIKnB5I9j5UCqOqjB/QMTJrvDMZIEuAr1P1xwjrr34T9jlbp+BuRCyvsqJd
         FVxA==
X-Gm-Message-State: AOAM53016NxLDNDMMQn+R9tBJhYxY9s8VXyhJdWllRW4poOW7P4gwaww
        Rx8QzKJLQ6KVN15+dVWbqnifR8oab9XZ19BeQcsKuYeFtTMcScEMokXit9aBUSUnndwRdZY59XQ
        0ePm+5zv+7Bqv5mfv
X-Received: by 2002:a17:906:6403:: with SMTP id d3mr23729885ejm.37.1633432453191;
        Tue, 05 Oct 2021 04:14:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxY2hCJkGC5AzT9vl/0Yb7fJ8ctbBZv5PMN7VoTenL51WxdmBhuVP9l6AdVnGc4K3Ps0gWaAA==
X-Received: by 2002:a17:906:6403:: with SMTP id d3mr23729860ejm.37.1633432452994;
        Tue, 05 Oct 2021 04:14:12 -0700 (PDT)
Received: from localhost (net-188-218-17-84.cust.vodafonedsl.it. [188.218.17.84])
        by smtp.gmail.com with ESMTPSA id dn10sm8457145edb.84.2021.10.05.04.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 04:14:12 -0700 (PDT)
Date:   Tue, 5 Oct 2021 13:14:11 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net/sched: sch_taprio: properly cancel timer from
 taprio_destroy()
Message-ID: <YVwzgwrW0QttrbFv@dcaratti.users.ipa.redhat.com>
References: <20211004195522.2041705-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004195522.2041705-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Eric, thanks for the patch!

On Mon, Oct 04, 2021 at 12:55:22PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> There is a comment in qdisc_create() about us not calling ops->reset()
> in some cases.
> 
> err_out4:
> 	/*
> 	 * Any broken qdiscs that would require a ops->reset() here?
> 	 * The qdisc was never in action so it shouldn't be necessary.
> 	 */

right, I didn't spot this error path.
 
 
> Fixes: 44d4775ca518 ("net/sched: sch_taprio: reset child qdiscs before freeing them")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Davide Caratti <dcaratti@redhat.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>


Acked-by: Davide Caratti <dcaratti@redhat.com>

> ---
>  net/sched/sch_taprio.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 1ab2fc933a214d04dfff763d2c5de65f4a67374a..b9fd18d986464f317a9fb7ce709a9728ffb75751 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1641,6 +1641,10 @@ static void taprio_destroy(struct Qdisc *sch)
>  	list_del(&q->taprio_list);
>  	spin_unlock(&taprio_list_lock);
>  
> +	/* Note that taprio_reset() might not be called if an error
> +	 * happens in qdisc_create(), after taprio_init() has been called.
> +	 */
> +	hrtimer_cancel(&q->advance_timer);
>  
>  	taprio_disable_offload(dev, q, NULL);
>  
> -- 
> 2.33.0.800.g4c38ced690-goog
> 

