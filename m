Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA701B2CBA
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 18:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgDUQcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 12:32:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23506 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725930AbgDUQcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 12:32:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587486738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oKEWmxtxEnbNXiG6aeuCSeiDYPuy1uau7So7mAsNm7M=;
        b=AgA8Kcm2F7/EwSnuWbsHbosWAWVzTBLO9BKpDcH749InMf6GraDd0pbLZB3htvx2vqoT1S
        Kdjd1SDpqIvubGwt4gEI79ivlIZUHgZUshj+BrGNu8qi5weP9wWs3r+kkjs3uxZpZI0tlv
        UJjkw2tGMGwNgoqb97ZfSeg76f5hNYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-bUcmUq9GOPaDE0BzO9reuA-1; Tue, 21 Apr 2020 12:32:15 -0400
X-MC-Unique: bUcmUq9GOPaDE0BzO9reuA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 674A11926DA8;
        Tue, 21 Apr 2020 16:32:14 +0000 (UTC)
Received: from ovpn-115-18.ams2.redhat.com (ovpn-115-18.ams2.redhat.com [10.36.115.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 436B176E8A;
        Tue, 21 Apr 2020 16:32:12 +0000 (UTC)
Message-ID: <4440312dc634ce08e2a3f76e38851bcc8cd331c2.camel@redhat.com>
Subject: Re: [PATCH -next] mptcp/pm_netlink.c : add check for
 nla_put_in6_addr
From:   Paolo Abeni <pabeni@redhat.com>
To:     Bo YU <tsu.yubo@gmail.com>, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Tue, 21 Apr 2020 18:32:10 +0200
In-Reply-To: <20200421161830.uaiwr5il6kh5texr@host>
References: <20200421161830.uaiwr5il6kh5texr@host>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-22 at 00:18 +0800, Bo YU wrote:
> Normal there should be checked for nla_put_in6_addr like other
> usage in net.
> 
> Detected by CoverityScan, CID# 1461639
> 
> Fixes: 01cacb00b35c("mptcp: add netlink-based PM")
> Signed-off-by: Bo YU <tsu.yubo@gmail.com>
> ---
> BWT, I am not sure nla_put_in_addr whether or not to do such that
> ---
>  net/mptcp/pm_netlink.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index 86d61ab34c7c..f340b00672e1 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -603,8 +603,9 @@ static int mptcp_nl_fill_addr(struct sk_buff *skb,
>  		nla_put_in_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR4,
>  				addr->addr.s_addr);
>  #if IS_ENABLED(CONFIG_MPTCP_IPV6)
> -	else if (addr->family == AF_INET6)
> -		nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6);
> +	else if (addr->family == AF_INET6 &&
> +		nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6))
> +		goto nla_put_failure;
>  #endif
>  	nla_nest_end(skb, attr);
>  	return 0;

This change LGTM, but I think we also need a similar check for
nla_put_in_addr(), thanks!

Paolo

