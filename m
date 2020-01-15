Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6010913C8C9
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 17:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgAOQHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 11:07:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38228 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726574AbgAOQHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 11:07:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579104464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n4szi5gDkxp97Ng93BBXfp5uh1ezhK54QYpHsleD7g0=;
        b=WVtKT2uhQHwlON1PtYGZ0fmt1aoVXj3bnraFRPdsbl5kYdZnM3AYramKvXW+AqVZ+KThQE
        QjAfFDgbdKyfHI0rZDVCz+uYWQHTYZmKRn2dMxzoMQiHvtnE9wD9rWaHYU+FyUhXhzhNKy
        jCDh+MYEXePg+B4bf9skZLgi6Qqy2FA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-3jk7TQQOPY6BPoDfDspfNw-1; Wed, 15 Jan 2020 11:07:41 -0500
X-MC-Unique: 3jk7TQQOPY6BPoDfDspfNw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E4391A1795;
        Wed, 15 Jan 2020 16:07:40 +0000 (UTC)
Received: from ovpn-205-91.brq.redhat.com (ovpn-205-91.brq.redhat.com [10.40.205.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93C7910841BF;
        Wed, 15 Jan 2020 16:07:38 +0000 (UTC)
Message-ID: <f46117ffa869ca3ba7671b2dc38b6435b39b9c7a.camel@redhat.com>
Subject: Re: [PATCH v2 net] net/sched: act_ife: initalize ife->metalist
 earlier
From:   Davide Caratti <dcaratti@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
In-Reply-To: <20200115155803.4573-1-edumazet@google.com>
References: <20200115155803.4573-1-edumazet@google.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 15 Jan 2020 17:07:37 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  On Wed, 2020-01-15 at 07:58 -0800, Eric Dumazet wrote:
> It seems better to init ife->metalist earlier in tcf_ife_init()
> to avoid the following crash :

hi Eric, thanks for following up!

[...]
> ---
> v2: addressed Davide feedback.
>  net/sched/act_ife.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
> index 5e6379028fc392031f4b84599f666a2c61f071d2..ab748701374f65028c79cb789d065305430ea4c5 100644
> --- a/net/sched/act_ife.c
> +++ b/net/sched/act_ife.c
> @@ -537,6 +537,9 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
>  	}
>  
>  	ife = to_ife(*a);
> +	if (ret = ACT_P_CREATED)
> +		INIT_LIST_HEAD(&ife->metalist);
> +

I didn't test the hunk above, but I think there is a typo, this assigns
'ret' rather than checking if it's equal to ACT_P_CREATED.

It should be something like:

	if (ret == ACT_P_CREATED)
		INIT_LIST_HEAD(&ife->metalist);
 
correct?

thanks!
--
davide

