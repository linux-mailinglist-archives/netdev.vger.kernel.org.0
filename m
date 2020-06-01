Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33C91EA45C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 15:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgFANCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 09:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgFANCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 09:02:20 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EB4C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 06:02:19 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x13so11438901wrv.4
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 06:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zvdN0KlmX3wZK+orI8fawnIsdS+O3fazG4GsTX6VAMw=;
        b=glDPvZpDBHShxX0NxVM/DL3zWnixukRAJ0kclV+fg9UWRYFG+l0sxSBJB4ZQn5X42z
         qF2wNbjf8pi++voupgIx2DSHBGUbwIvEg7cFR2RSvhagj5UHYQxjWVASO4JYMnfLjVg5
         ZdMuu+rbpSI7t6EoSbHeama679hQyfITJMGtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zvdN0KlmX3wZK+orI8fawnIsdS+O3fazG4GsTX6VAMw=;
        b=V2qQ3y7fY1AdI4rHVmH1BTMox8LHVtWOZsbf1NuSdFz5xQT04+3SktkF+A3N92PUK4
         7TE73qjgRdjh1v5DaX9UPCeqi6w+YPFp0K4D6vYhRbSfsk0bZuvH3QM0+5REkGeP1T18
         O50zNGgwjjlvzMtLQ3ga5b1WMIVPXNELyXaNS/jyB3DFli0eJIbrvoS4eqFd6eyrQhFx
         W9iLopnIKnisrbpsvSbAnae7wzmRMD50SCgFb7pm0oTkrFI6dHELRHa5TK5aRkvC/OKG
         krlScn5Kv/VzkrCiyS4huQO7//vEKMslNKp1lYopf5uLOWd3yfBSrIN5Up3tUO1KXGqm
         jaMg==
X-Gm-Message-State: AOAM532oCFKI2Xgo2I6RpuviqUYF/02njEFV2xwt53UOg3pmVAmPZLYH
        DN6qTFSFMJrolSeeISLb8yZpGg==
X-Google-Smtp-Source: ABdhPJzQKtYwLPVnq7gokB1pCd+55Kguwy/aCan4uC20Cs5DFU2CIeIlQb9adydVmm4U6wGkic9g0w==
X-Received: by 2002:a5d:5492:: with SMTP id h18mr21219699wrv.330.1591016538339;
        Mon, 01 Jun 2020 06:02:18 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s132sm13750541wmf.12.2020.06.01.06.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 06:02:17 -0700 (PDT)
Subject: Re: [PATCH net 1/2] bridge: Avoid infinite loop when suppressing NS
 messages with invalid options
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@cumulusnetworks.com,
        dlstevens@us.ibm.com, allas@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20200601125855.1751343-1-idosch@idosch.org>
 <20200601125855.1751343-2-idosch@idosch.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <7e2ffbf7-b756-04ee-1210-a11fd26d1237@cumulusnetworks.com>
Date:   Mon, 1 Jun 2020 16:02:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200601125855.1751343-2-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06/2020 15:58, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> When neighbor suppression is enabled the bridge device might reply to
> Neighbor Solicitation (NS) messages on behalf of remote hosts.
> 
> In case the NS message includes the "Source link-layer address" option
> [1], the bridge device will use the specified address as the link-layer
> destination address in its reply.
> 
> To avoid an infinite loop, break out of the options parsing loop when
> encountering an option with length zero and disregard the NS message.
> 
> This is consistent with the IPv6 ndisc code and RFC 4886 which states
> that "Nodes MUST silently discard an ND packet that contains an option
> with length zero" [2].
> 
> [1] https://tools.ietf.org/html/rfc4861#section-4.3
> [2] https://tools.ietf.org/html/rfc4861#section-4.6
> 
> Fixes: ed842faeb2bd ("bridge: suppress nd pkts on BR_NEIGH_SUPPRESS ports")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: Alla Segal <allas@mellanox.com>
> Tested-by: Alla Segal <allas@mellanox.com>
> ---
>  net/bridge/br_arp_nd_proxy.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/bridge/br_arp_nd_proxy.c b/net/bridge/br_arp_nd_proxy.c
> index 37908561a64b..b18cdf03edb3 100644
> --- a/net/bridge/br_arp_nd_proxy.c
> +++ b/net/bridge/br_arp_nd_proxy.c
> @@ -276,6 +276,10 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
>  	ns_olen = request->len - (skb_network_offset(request) +
>  				  sizeof(struct ipv6hdr)) - sizeof(*ns);
>  	for (i = 0; i < ns_olen - 1; i += (ns->opt[i + 1] << 3)) {
> +		if (!ns->opt[i + 1]) {
> +			kfree_skb(reply);
> +			return;
> +		}
>  		if (ns->opt[i] == ND_OPT_SOURCE_LL_ADDR) {
>  			daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
>  			break;
> 

Good catch!
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
