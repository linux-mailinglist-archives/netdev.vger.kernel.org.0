Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83081EA45F
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 15:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgFANCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 09:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgFANCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 09:02:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACADC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 06:02:52 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j10so11391057wrw.8
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 06:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c+QoV/HcMCTMVpf40QgOdghuE0cBC54AdoG6hgzUvEU=;
        b=bXNGLd36g19lQhm9wc2ucAu6ZWWI/gszeaBbB1NS+obGicxXFoHjlU2iinmTbvKo70
         Id6xXBUi/krErs7Q6DieEbq471E+GLthmwz5o/nNEmXxiyGvqE4VogS/eEnUeMnD5Th6
         pcrcl+e6USCW+qGg58swXjw+R6EjNCNcgQ5kY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c+QoV/HcMCTMVpf40QgOdghuE0cBC54AdoG6hgzUvEU=;
        b=D4WevVTR0aeqSu89Plw0pNG+ijjzy3g/dRzfQWdmLXp6bIITjw7ev/4lm67cNaCo/o
         Zzaw5gIPRC5Nv//VZEPi8TvSctrxi33Dd4r8W7+j7K/mJOTgAbb+oC2/jov17qjml0Qk
         7kyq/sw0ggtcZV1QTcNLceClEAHSoTSpw+SOFzJq4ssIm1B8wr0+7DUv+1QhS4FCwUaj
         cOMvGhfVD7THSS3vYnYTLNzhJx7bDZsoLaCrOWvFFEUJiPN59bnAib9USuapx/eImhhE
         YhIhNd2SsqVbZlr8uod8TAsYR8CFDF60b00xE+x5yehQ6GjVy8b2Qw2Xgl7CcgQB0/Sh
         curQ==
X-Gm-Message-State: AOAM532KpdvoEzneYk77DYOz0KJrMKHe6Jz/YUkkatJ9a0D3GHsOhFJz
        ZYga7LMZpNtCrDljj7o2k0qR1g==
X-Google-Smtp-Source: ABdhPJyvJgDBLwC4bSkCDVyoydG38HExBeyXwTCGezzxTjgwWFG8eRidscqY9ZUDo/lnnpjqVUHz/Q==
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr23124419wrs.115.1591016570931;
        Mon, 01 Jun 2020 06:02:50 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id l1sm12897330wrb.31.2020.06.01.06.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 06:02:50 -0700 (PDT)
Subject: Re: [PATCH net 2/2] vxlan: Avoid infinite loop when suppressing NS
 messages with invalid options
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@cumulusnetworks.com,
        dlstevens@us.ibm.com, allas@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20200601125855.1751343-1-idosch@idosch.org>
 <20200601125855.1751343-3-idosch@idosch.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <b0466e34-47a5-b71f-58bd-321955fdb9aa@cumulusnetworks.com>
Date:   Mon, 1 Jun 2020 16:02:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200601125855.1751343-3-idosch@idosch.org>
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
> When proxy mode is enabled the vxlan device might reply to Neighbor
> Solicitation (NS) messages on behalf of remote hosts.
> 
> In case the NS message includes the "Source link-layer address" option
> [1], the vxlan device will use the specified address as the link-layer
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
> Fixes: 4b29dba9c085 ("vxlan: fix nonfunctional neigh_reduce()")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  drivers/net/vxlan.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index a5b415fed11e..779e56c43d27 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -1924,6 +1924,10 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
>  	ns_olen = request->len - skb_network_offset(request) -
>  		sizeof(struct ipv6hdr) - sizeof(*ns);
>  	for (i = 0; i < ns_olen-1; i += (ns->opt[i+1]<<3)) {
> +		if (!ns->opt[i + 1]) {
> +			kfree_skb(reply);
> +			return NULL;
> +		}
>  		if (ns->opt[i] == ND_OPT_SOURCE_LL_ADDR) {
>  			daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
>  			break;
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
