Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A67C592D80
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiHOIuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 04:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiHOIuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 04:50:05 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CFB205F2
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 01:50:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 36EA520606;
        Mon, 15 Aug 2022 10:50:03 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id v3PICAx4U7c4; Mon, 15 Aug 2022 10:50:02 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8CBD2205FD;
        Mon, 15 Aug 2022 10:50:02 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 7AEB780004A;
        Mon, 15 Aug 2022 10:50:02 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 15 Aug 2022 10:50:02 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 15 Aug
 2022 10:50:02 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id CC6C93182A0E; Mon, 15 Aug 2022 10:50:01 +0200 (CEST)
Date:   Mon, 15 Aug 2022 10:50:01 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Benedict Wong <benedictwong@google.com>
CC:     <netdev@vger.kernel.org>, <nharold@google.com>,
        <lorenzo@google.com>
Subject: Re: [PATCH ipsec 2/2] xfrm: Skip checking of already-verified
 secpath entries
Message-ID: <20220815085001.GB2950045@gauss3.secunet.de>
References: <20220810182210.721493-1-benedictwong@google.com>
 <20220810182210.721493-3-benedictwong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220810182210.721493-3-benedictwong@google.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 06:22:10PM +0000, Benedict Wong wrote:
> This change fixes a bug where inbound packets to nested IPsec tunnels
> fails to pass policy checks due to the inner tunnel's policy checks
> not having a reference to the outer policy/template. This causes the
> policy check to fail, since the first entries in the secpath correlate
> to the outer tunnel, while the templates being verified are for the
> inner tunnel.
> 
> In order to ensure that the appropriate policy and template context is
> searchable, the policy checks must be done incrementally after each
> decryption step. As such, this marks secpath entries as having been
> successfully matched, skipping these on subsequent policy checks.
> 
> By skipping the immediate error return in the case where the secpath
> entry had previously been validated, this change allows secpath entries
> that matched a policy/template previously, while still requiring that
> each searched template find a match in the secpath.
> 
> For security:
> - All templates must have matching secpath entries
>   - Unchanged by current patch; templates that do not match any secpath
>     entry still return -1. This patch simply allows skipping earlier
>     blocks of verified secpath entries
> - All entries (except trailing transport mode entries) must have a
>   matching template
>   - Unvalidated entries, including transport-mode entries still return
>     the errored index if it does not match the correct template.
> 
> Test: Tested against Android Kernel Unit Tests
> Signed-off-by: Benedict Wong <benedictwong@google.com>
> Change-Id: Ic32831cb00151d0de2e465f18ec37d5f7b680e54

This ID is meaningless on a mainline kernel, please remove it.

> ---
>  include/net/xfrm.h     |  1 +
>  net/xfrm/xfrm_input.c  |  3 ++-
>  net/xfrm/xfrm_policy.c | 11 ++++++++++-
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index c39d910d4b45..a2f2840aba6b 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -1031,6 +1031,7 @@ struct xfrm_offload {
>  struct sec_path {
>  	int			len;
>  	int			olen;
> +	int			verified_cnt;
>  
>  	struct xfrm_state	*xvec[XFRM_MAX_DEPTH];
>  	struct xfrm_offload	ovec[XFRM_MAX_OFFLOAD_DEPTH];
> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> index b24df8a44585..895935077a91 100644
> --- a/net/xfrm/xfrm_input.c
> +++ b/net/xfrm/xfrm_input.c
> @@ -129,6 +129,7 @@ struct sec_path *secpath_set(struct sk_buff *skb)
>  	memset(sp->ovec, 0, sizeof(sp->ovec));
>  	sp->olen = 0;
>  	sp->len = 0;
> +	sp->verified_cnt = 0;
>  
>  	return sp;
>  }
> @@ -587,7 +588,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
>  
>  		// If nested tunnel, check outer states before context is lost.

Please use networking style comments here too.

>  		if (x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL
> -				&& sp->len > 0
> +				&& sp->len > sp->verified_cnt
>  				&& !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family)) {

As in the first patch, please use common networking code
alignment.

Thanks!
