Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FD8626034
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 18:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbiKKROo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 12:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbiKKROn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 12:14:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2136A167E1
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 09:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B285362066
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 17:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9E3C433D6;
        Fri, 11 Nov 2022 17:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668186882;
        bh=zbdsF3koELlEFr9t6fefDyMzc/WhHm/LM1dRClYRSAc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aw+0yaJLAnRjgfga8ECyz5VXIltw59HHDO9E95YECIocMMlXzSI+kutTNcKgwW89l
         eZNTmrkjNGdBVK0MxDqG09fRE7AIw2CWd1NXSmQrBIXM0ZFU6B1ZmRFASDBwK69m8V
         mGFxwCQtVQ1aQyuvTclHK6DmNSz+9upS9ZDR0/rMRNgaZVKMFO6AevJagy5EkmJn9L
         UGk7fO4QE+baBGR02rUh7VeeR8q8Ny/202HjdS7YN2sYbpHA67xbxbbTD5zr6G5tFb
         4iMSG2m7AWikkHdeQtx94GpWVmiG1cCMVgUUS15ISuJsQmuodvjSwSh7J6qVB+zEBZ
         pf3lmPYGzeyOg==
Date:   Fri, 11 Nov 2022 09:14:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets
 aggregation
Message-ID: <20221111091440.51f9c09e@kernel.org>
In-Reply-To: <20221109180249.4721-3-dnlplm@gmail.com>
References: <20221109180249.4721-1-dnlplm@gmail.com>
        <20221109180249.4721-3-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Nov 2022 19:02:48 +0100 Daniele Palmas wrote:
> +bool rmnet_map_tx_agg_skip(struct sk_buff *skb)
> +{
> +	bool is_icmp = 0;
> +
> +	if (skb->protocol == htons(ETH_P_IP)) {
> +		struct iphdr *ip4h = ip_hdr(skb);
> +
> +		if (ip4h->protocol == IPPROTO_ICMP)
> +			is_icmp = true;
> +	} else if (skb->protocol == htons(ETH_P_IPV6)) {
> +		unsigned int icmp_offset = 0;
> +
> +		if (ipv6_find_hdr(skb, &icmp_offset, IPPROTO_ICMPV6, NULL, NULL) == IPPROTO_ICMPV6)
> +			is_icmp = true;
> +	}
> +
> +	return is_icmp;
> +}

Why this? I don't see it mention in the commit message or any code
comment.
