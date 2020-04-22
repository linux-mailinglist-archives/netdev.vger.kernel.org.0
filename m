Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0FB1B3D2F
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 12:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgDVKMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 06:12:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34238 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729014AbgDVKMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 06:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587550355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQGoc5LkA70Jf4s1hHcHchKL4x32fK3s73ObS3Mo9wM=;
        b=ETUCHM/cafVlEqXP/r80Q7ZKrHQld8w0o+sTbhgrAOrz3FrW6V3gESk2jbJa3YP0VG5Scz
        RV8Ygjb6kxeSAkhiX6BH7nltcgZReac9inW+l+jjp/BB0t++xrjEeqwn8SCUEC4aKTcF0D
        3U539GmhC6Rm4Uwl6G+twu7JKPingPc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-9EjndfONPnCpHfttxMDvvA-1; Wed, 22 Apr 2020 06:12:32 -0400
X-MC-Unique: 9EjndfONPnCpHfttxMDvvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C64AF100CD04;
        Wed, 22 Apr 2020 10:12:30 +0000 (UTC)
Received: from ovpn-114-173.ams2.redhat.com (ovpn-114-173.ams2.redhat.com [10.36.114.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68FE1600D2;
        Wed, 22 Apr 2020 10:12:28 +0000 (UTC)
Message-ID: <f82e4d00d4d4680994f0885c55831b2e9a2299c1.camel@redhat.com>
Subject: Re: [PATCH V2 -next] mptcp/pm_netlink.c : add check for
 nla_put_in/6_addr
From:   Paolo Abeni <pabeni@redhat.com>
To:     Bo YU <tsu.yubo@gmail.com>, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Wed, 22 Apr 2020 12:12:27 +0200
In-Reply-To: <20200422013433.qzlthtmx4c7mmlh3@host>
References: <20200422013433.qzlthtmx4c7mmlh3@host>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-22 at 09:34 +0800, Bo YU wrote:
> Normal there should be checked for nla_put_in6_addr like other
> usage in net.
> 
> Detected by CoverityScan, CID# 1461639
> 
> Fixes: 01cacb00b35c("mptcp: add netlink-based PM")
> Signed-off-by: Bo YU <tsu.yubo@gmail.com>
> ---
> V2: Add check for nla_put_in_addr suggested by Paolo Abeni

Thank you for addressing my feedback!

> ---
>  net/mptcp/pm_netlink.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index 86d61ab34c7c..0a39f0ebad76 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -599,12 +599,15 @@ static int mptcp_nl_fill_addr(struct sk_buff *skb,
>  	    nla_put_s32(skb, MPTCP_PM_ADDR_ATTR_IF_IDX, entry->ifindex))
>  		goto nla_put_failure;
> 
> -	if (addr->family == AF_INET)
> +	if (addr->family == AF_INET &&
>  		nla_put_in_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR4,
> -				addr->addr.s_addr);
> +				addr->addr.s_addr))
> +		goto nla_put_failure;
> +

I'm very sorry about the nit-picking, but the above is now a single
statement, and indentation should be adjusted accordingly:
'nla_put_in_addr()' should be aligned with 'addr->family'.

The same applies to the chunk below.

>  #if IS_ENABLED(CONFIG_MPTCP_IPV6)
> -	else if (addr->family == AF_INET6)
> -		nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6);
> +	else if (addr->family == AF_INET6 &&
> +		nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6))
> +		goto nla_put_failure;
>  #endif
>  	nla_nest_end(skb, attr);
>  	return 0;

Otherwise LGTM, thanks!

Paolo

