Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986654DA2C9
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 19:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351189AbiCOS57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 14:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351177AbiCOS56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 14:57:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9910159A4D;
        Tue, 15 Mar 2022 11:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33181615F8;
        Tue, 15 Mar 2022 18:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661CCC340EE;
        Tue, 15 Mar 2022 18:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647370605;
        bh=PcuV39IsErBrPwKL/fcwiUJYxGGPNPA+TfHf+Zawgm8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MkHhzZXa1AYOJY6fjc3CoX1kIC3/40ekAStsq3tUJAE6HRZCbup5jvtwGZ3kJuFBX
         jYL79RMgNxbfipwc31G3azF7CFiM67m1QP54TmL3EaEYUsJz2h6jUwuuR4I1xDTXUV
         3X3aF4f7sKYjCedo+L2DkGoNm7Bh6U0iTsrkOKwOis03a0A66TZGFtIXY/khrq2BIs
         fG96e95Wm6UuJBZVfVuMACGPFMeD1wk8y5vVNjHCNX3UZiuLJUWk6k7L9JqFzq4guD
         ZK4wwIsZoddJ76PnZoU2RIcAUPZmAgkxA3mr8VMFnFNgmf5hATzQYCJomSJSfDDgs8
         FahifA9QE4c6g==
Date:   Tue, 15 Mar 2022 11:56:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 2/6] netfilter: nf_tables: Reject tables of
 unsupported family
Message-ID: <20220315115644.66fab74b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315091513.66544-3-pablo@netfilter.org>
References: <20220315091513.66544-1-pablo@netfilter.org>
        <20220315091513.66544-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 10:15:09 +0100 Pablo Neira Ayuso wrote:
> +	return false
> +#ifdef CONFIG_NF_TABLES_INET
> +		|| family == NFPROTO_INET
> +#endif
> +#ifdef CONFIG_NF_TABLES_IPV4
> +		|| family == NFPROTO_IPV4
> +#endif
> +#ifdef CONFIG_NF_TABLES_ARP
> +		|| family == NFPROTO_ARP
> +#endif
> +#ifdef CONFIG_NF_TABLES_NETDEV
> +		|| family == NFPROTO_NETDEV
> +#endif
> +#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)

is there a reason this one is IS_ENABLED() and everything else is ifdef?

> +		|| family == NFPROTO_BRIDGE
> +#endif
> +#ifdef CONFIG_NF_TABLES_IPV6
> +		|| family == NFPROTO_IPV6
> +#endif
> +		;

	return (IS_ENABLED(CONFIG_NF_TABLES_INET) && family == NFPROTO_INET)) ||
	       (IS_ENABLED(CONFIG_NF_TABLES_IPV4) && family == NFPROTO_IPV4)) ||
		...

would have also been an option, for future reference.
