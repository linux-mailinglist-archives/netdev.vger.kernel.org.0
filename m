Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864CC6BF7C0
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 05:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCREdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 00:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCREdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 00:33:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CF56A67
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 21:33:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C816C6068E
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 04:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA831C433D2;
        Sat, 18 Mar 2023 04:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679113986;
        bh=SkKj+x4vKtG1OZy6WpS641QdxfZef/dCocfGeVsmOWs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kUY9c1i8yh9h4ei2xua5R/YgATiPeQp2HJd1WS9XnhJiOMjRpwkBosSCl9FYdyy+P
         +B39/AFILjn/c56g0ngF4MFD8xgwM8WC4DlYgLlRmauhOBSeyDVFRorUHt7++0Oefc
         RD+FKcj0ccjOppOPTgQNBMr1+XLM265QglzxmV1wJ0jFBgPvqQmUJyC4CsmCe5bwYP
         bQDXqqNrmiK0uBPOodWq3/7moqkC+T5bjsw+Y9ofuTS65sFCRBggbqfuu0k6rCJmaW
         BGIDZ3p2nyqsynw8t/g9wGdDhS6BHNkawcwt8Di87oJZmwmzZZT2hxM470XjriG0pe
         tUQY8DGi5o6Ew==
Date:   Fri, 17 Mar 2023 21:33:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 2/4] ynl: populate most of the ethtool spec
Message-ID: <20230317213304.2010ed71@kernel.org>
In-Reply-To: <20230318002340.1306356-3-sdf@google.com>
References: <20230318002340.1306356-1-sdf@google.com>
        <20230318002340.1306356-3-sdf@google.com>
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

On Fri, 17 Mar 2023 17:23:38 -0700 Stanislav Fomichev wrote:
> Things that are not implemented:
> - cable tests
> - bitmaks in the requests don't work (needs multi-attr support in ynl.py)
> - stats-get seems to return nonsense

Hm. What kind of nonsense?

> - notifications are not tested
> - features-nft has hard-coded value:13, not sure why it skews

ETHTOOL_MSG_FEATURES_SET_REPLY exists but there is no reply:
section in the spec.

> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  Documentation/netlink/specs/ethtool.yaml | 1473 ++++++++++++++++++++--
>  1 file changed, 1362 insertions(+), 111 deletions(-)
> 
> diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
> index 4727c067e2ba..ba9ee9b6e5ad 100644
> --- a/Documentation/netlink/specs/ethtool.yaml
> +++ b/Documentation/netlink/specs/ethtool.yaml
> @@ -6,6 +6,12 @@ protocol: genetlink-legacy
>  
>  doc: Partial family for Ethtool Netlink.
>  
> +definitions:
> +  -
> +    name: udp-tunnel-type
> +    type: enum
> +    entries: [ vxlan, geneve, vxlan_gpe ]

s/_/-/ everywhere

> +
>  attribute-sets:
>    -
>      name: header
> @@ -38,6 +44,7 @@ doc: Partial family for Ethtool Netlink.
>        -
>          name: bit
>          type: nest
> +        multi-attr: true
>          nested-attributes: bitset-bit
>    -
>      name: bitset
> @@ -53,6 +60,21 @@ doc: Partial family for Ethtool Netlink.
>          type: nest
>          nested-attributes: bitset-bits
>  
> +  -
> +    name: u64-array
> +    attributes:
> +      -
> +        name: u64
> +        type: nest
> +        multi-attr: true
> +        nested-attributes: u64
> +    name: s32-array

missing 

    -

before this line? the u64-array and s32-array should be separate?

> +    attributes:
> +      -
> +        name: s32
> +        type: nest
> +        multi-attr: true
> +        nested-attributes: s32
>    -
>      name: string
>      attributes:

> +    -
> +      name: features-get
> +      doc: Get features.
> +
> +      attribute-set: features
> +
> +      do: &feature-get-op
> +        request:
> +          attributes:
> +            - header
> +        reply:
> +          attributes: &feature
> +            - header
> +            # User-changeable features.
> +            - hw
> +            # User-requested features.
> +            - wanted
> +            # Currently active features.
> +            - active
> +            # Unchangeable features.
> +            - nochange
> +      dump: *feature-get-op
> +    -
> +      name: features-set
> +      doc: Set features.
> +
> +      attribute-set: features
> +
> +      do:
> +        request:
> +          attributes: *feature

	reply:

here. Not sure if it needs an empty attributes: or not.

