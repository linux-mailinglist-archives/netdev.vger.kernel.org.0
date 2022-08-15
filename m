Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30945592CEC
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241699AbiHOIpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 04:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241666AbiHOIpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 04:45:21 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8774FC16
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 01:45:18 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 54E8220606;
        Mon, 15 Aug 2022 10:45:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Py44kgUcf_ZB; Mon, 15 Aug 2022 10:45:15 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id BF904205FD;
        Mon, 15 Aug 2022 10:45:15 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id ADA3D80004A;
        Mon, 15 Aug 2022 10:45:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 15 Aug 2022 10:45:15 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 15 Aug
 2022 10:45:15 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D73F23182A0E; Mon, 15 Aug 2022 10:45:14 +0200 (CEST)
Date:   Mon, 15 Aug 2022 10:45:14 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Benedict Wong <benedictwong@google.com>
CC:     <netdev@vger.kernel.org>, <nharold@google.com>,
        <lorenzo@google.com>
Subject: Re: [PATCH ipsec 1/2] xfrm: Check policy for nested XFRM packets in
 xfrm_input
Message-ID: <20220815084514.GA2950045@gauss3.secunet.de>
References: <20220810182210.721493-1-benedictwong@google.com>
 <20220810182210.721493-2-benedictwong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220810182210.721493-2-benedictwong@google.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
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

On Wed, Aug 10, 2022 at 06:22:09PM +0000, Benedict Wong wrote:
> This change ensures that all nested XFRM packets have their policy
> checked before decryption of the next layer, so that policies are
> verified at each intermediate step of the decryption process.
> 
> This is necessary especially for nested tunnels, as the IP addresses,
> protocol and ports may all change, thus not matching the previous
> policies. In order to ensure that packets match the relevant inbound
> templates, the xfrm_policy_check should be done before handing off to
> the inner XFRM protocol to decrypt and decapsulate.
> 
> Test: Tested against Android Kernel Unit Tests
> Signed-off-by: Benedict Wong <benedictwong@google.com>
> Change-Id: I20c5abf39512d7f6cf438c0921a78a84e281b4e9
> ---
>  net/xfrm/xfrm_input.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> index 144238a50f3d..b24df8a44585 100644
> --- a/net/xfrm/xfrm_input.c
> +++ b/net/xfrm/xfrm_input.c
> @@ -585,6 +585,13 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
>  			goto drop;
>  		}
>  
> +		// If nested tunnel, check outer states before context is lost.

Please use networking style comments like so /* ... */

> +		if (x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL
> +				&& sp->len > 0

Please align this to the opening brace of the if statement
like it is done everywhere in networking code. If you are
unsure about coding style, try checkpatch it helps in that
case.

> +				&& !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family)) {

Hm, shouldn't the xfrm_policy_check called along the
packet path for each round after decapsulation?

Do you use ESP transformation offload (INET_ESP_OFFLOAD/
INET6_ESP_OFFLOAD)?

> +			goto drop;
> +		}
> +
>  		skb->mark = xfrm_smark_get(skb->mark, x);
>  
>  		sp->xvec[sp->len++] = x;
> -- 
> 2.37.1.595.g718a3a8f04-goog
