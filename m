Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39ED31B5748
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 10:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgDWIfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 04:35:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21164 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWIfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 04:35:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587630910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8k7R0G5U7B6YJiNv+fHV9QM1njpER4AXJ048xgA+jBo=;
        b=WRjUR4PR5J5xhUInjkMRq3BeYKXGFR4l4gI9etFoK1QmwhfdXt3z61XVv90wPcNOjeGvOf
        N4hUnA3oMAy5NBWSSv+iSxhApUTN4Qf+JQu5sc4gt2ROzM6unDK8oLpMGLnfgmQ0LZAGL0
        LgVPdMWR1sE8Uue+nAhSuWpVrhG631k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-DAukozEsMDOX8le41nrbnA-1; Thu, 23 Apr 2020 04:35:06 -0400
X-MC-Unique: DAukozEsMDOX8le41nrbnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DA8B8CC6AB;
        Thu, 23 Apr 2020 08:35:04 +0000 (UTC)
Received: from ovpn-114-154.ams2.redhat.com (ovpn-114-154.ams2.redhat.com [10.36.114.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1A5B10016DA;
        Thu, 23 Apr 2020 08:35:01 +0000 (UTC)
Message-ID: <8546038508824f0a440f40bb9eef7ede61d223bb.camel@redhat.com>
Subject: Re: [PATCH V3 -next] mptcp/pm_netlink.c : add check for
 nla_put_in/6_addr
From:   Paolo Abeni <pabeni@redhat.com>
To:     Bo YU <tsu.yubo@gmail.com>, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Thu, 23 Apr 2020 10:34:54 +0200
In-Reply-To: <20200423020957.g5ovpymbbp4nykbr@debian.debian-2>
References: <20200423020957.g5ovpymbbp4nykbr@debian.debian-2>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-04-23 at 10:10 +0800, Bo YU wrote:
> Normal there should be checked for nla_put_in6_addr like other
> usage in net.
> 
> Detected by CoverityScan, CID# 1461639
> 
> Fixes: 01cacb00b35c("mptcp: add netlink-based PM")
> Signed-off-by: Bo YU <tsu.yubo@gmail.com>
> ---
> V3: fix code style, thanks for Paolo
> 
> V2: Add check for nla_put_in_addr suggested by Paolo Abeni
> ---
>  net/mptcp/pm_netlink.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index 86d61ab34c7c..b78edf237ba0 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -599,12 +599,14 @@ static int mptcp_nl_fill_addr(struct sk_buff *skb,
>  	    nla_put_s32(skb, MPTCP_PM_ADDR_ATTR_IF_IDX, entry->ifindex))
>  		goto nla_put_failure;
> 
> -	if (addr->family == AF_INET)
> -		nla_put_in_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR4,
> -				addr->addr.s_addr);
> +	if (addr->family == AF_INET &&
> +	    nla_put_in_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR4,
> +			    addr->addr.s_addr))
> +		goto nla_put_failure;
>  #if IS_ENABLED(CONFIG_MPTCP_IPV6)
> -	else if (addr->family == AF_INET6)
> -		nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6);
> +	else if (addr->family == AF_INET6 &&
> +		 nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6))
> +		goto nla_put_failure;
>  #endif
>  	nla_nest_end(skb, attr);
>  	return 0;
> --
> 2.11.0

Thanks for addressing my feedback!

Acked-by: Paolo Abeni <pabeni@redhat.com>



