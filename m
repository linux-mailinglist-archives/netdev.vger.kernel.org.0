Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223A84C0280
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 20:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbiBVTz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 14:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbiBVTz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 14:55:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE155C5DB8
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 11:55:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66AA16165F
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 19:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D91EC340F1;
        Tue, 22 Feb 2022 19:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645559729;
        bh=3pYdCU3eBSgwCCKoPwtXmuEyx7Y+9kaO6Tf/e+HzuFg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uqxRWFDowDBDBqQv7F1WYPAyaglyjE8ivUmmhYPYoOy6RcZyjv017hjBlb4VYhBOE
         TnUFs4fy6yOux8+e/K4rXa4kGWrfVjw2WgRn0ET2wdujCHtgrbJ+Isdc3oRN870C/J
         Ii2lwXfZem6qVrohMbGQRitay+hIVPyp09hiLy2ogEWdZdW1cyYF0EWbMqSWFnooZx
         btis5YuwX4ixvK9UTUzHi5qOxTVM1jjtfAXgeju8+WP0kC/6fMtNYVojp6nvu6ZBUo
         /itY70UzWqM4wgYCfV7V5LWC6lLHEcHBEZd1lFYi0E4iKrzkXPfAk8cCX01UGsyahE
         QA/J6YmKRyoSA==
Date:   Tue, 22 Feb 2022 11:55:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Eelco Chaudron <echaudro@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: Re: [PATCH net v4 1/1] openvswitch: Fix setting ipv6 fields causing
 hw csum failure
Message-ID: <20220222115528.6eaccb8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220220132114.18989-1-paulb@nvidia.com>
References: <20220220132114.18989-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You'll need to rebase, the patch which made everything force inlined
got merged.

On Sun, 20 Feb 2022 15:21:14 +0200 Paul Blakey wrote:
> +static inline __wsum
> +csum_block_replace(__wsum csum, __wsum old, __wsum new, int offset)
> +{
> +	return csum_block_add(csum_block_sub(csum, old, offset), new, offset);

Why still _block? Since the arguments are pre-shifted we should be able
to subtract and add the entire thing, and the math will work out.
Obviously you'd need to shift by the offset in the word, not in a byte
in the caller.

> +}
> +
>  static inline __wsum csum_unfold(__sum16 n)
>  {
>  	return (__force __wsum)n;
> @@ -184,4 +190,5 @@ static inline __wsum wsum_negate(__wsum val)
>  {
>  	return (__force __wsum)-((__force u32)val);
>  }
> +

Spurious?

>  #endif
