Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE094BA538
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiBQP53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:57:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiBQP52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:57:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFA316202B
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:57:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05EEF60AEA
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 15:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45178C340E8;
        Thu, 17 Feb 2022 15:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645113433;
        bh=LGgMPjCT4OAw7wGPYhmeIERD1wyS1PDzaUUiW2DA+UM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lYx+QavdH8OE4T/yMra1aa+5aIJ2/8drDdBLiXp2kjVVT35KWW1TeTc9vUv7ajgJ0
         0Z0FVqlBt3gTOLJYmsPzp/nC8bflKgcJJxzRXcxltdJgVohl080DSTNQhlJOL3Uys9
         wlfKk/8nLznl3DuML9CAcBHPnnhtCWubSpK27V5XL9ZEvaInD4N8wXVtaVdvgJ6p+q
         OA23h4sWCwoZK5bIUkGgbwEQ7GepJ02Vj2pWE/qCt3dtbJttw8VWSF4Ul2cIfVH9RT
         wQYDAZBF++6uiGghWFDGtwZNq89eIsFDK33jtv8G+AXbMKDHECNjEU8Fm650TUI91g
         L+XwQUW5uNVkA==
Date:   Thu, 17 Feb 2022 07:57:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH net] ping: fix the dif and sdif check in ping_lookup
Message-ID: <20220217075712.6bf6368c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ea03066bc7256ab86df8d3501f3440819305be57.1644988852.git.lucien.xin@gmail.com>
References: <ea03066bc7256ab86df8d3501f3440819305be57.1644988852.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 00:20:52 -0500 Xin Long wrote:
>  	if (skb->protocol == htons(ETH_P_IP)) {
> +		dif = inet_iif(skb);
> +		sdif = inet_sdif(skb);
>  		pr_debug("try to find: num = %d, daddr = %pI4, dif = %d\n",
>  			 (int)ident, &ip_hdr(skb)->daddr, dif);
>  #if IS_ENABLED(CONFIG_IPV6)
>  	} else if (skb->protocol == htons(ETH_P_IPV6)) {
> +		dif = inet6_iif(skb);
> +		sdif = inet6_sdif(skb);
>  		pr_debug("try to find: num = %d, daddr = %pI6c, dif = %d\n",
>  			 (int)ident, &ipv6_hdr(skb)->daddr, dif);
>  #endif
> +	} else {
> +		pr_err("ping: protocol(%x) is not supported\n", ntohs(skb->protocol));
> +		return NULL;
>  	}

Are you sure this is not reachable from some networking path allowing
attacker (or local user) to DoS the kernel logs?
