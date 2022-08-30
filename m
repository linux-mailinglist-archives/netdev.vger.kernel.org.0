Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6265A5BB9
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 08:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiH3GZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 02:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiH3GZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 02:25:36 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF717578AE
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 23:25:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F01412052D;
        Tue, 30 Aug 2022 08:25:30 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MVbgB2IJbx8O; Tue, 30 Aug 2022 08:25:30 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4D600201E5;
        Tue, 30 Aug 2022 08:25:30 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 3C52D80004A;
        Tue, 30 Aug 2022 08:25:30 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 08:25:30 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 30 Aug
 2022 08:25:29 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 55F0E3183BE2; Tue, 30 Aug 2022 08:25:29 +0200 (CEST)
Date:   Tue, 30 Aug 2022 08:25:29 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Benedict Wong <benedictwong@google.com>
CC:     <netdev@vger.kernel.org>, <nharold@google.com>,
        <lorenzo@google.com>
Subject: Re: [PATCH v2 ipsec 2/2] xfrm: Ensure policy checked for nested ESP
 tunnels
Message-ID: <20220830062529.GM2950045@gauss3.secunet.de>
References: <20220824221252.4130836-1-benedictwong@google.com>
 <20220824221252.4130836-3-benedictwong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220824221252.4130836-3-benedictwong@google.com>
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

On Wed, Aug 24, 2022 at 10:12:52PM +0000, Benedict Wong wrote:
> This change ensures that all nested XFRM packets have their policy
> checked before decryption of the next layer, so that policies are
> verified at each intermediate step of the decryption process.
> 
> Notably, raw ESP/AH packets do not perform policy checks inherently,
> whereas all other encapsulated packets (UDP, TCP encapsulated) do policy
> checks after calling xfrm_input handling in the respective encapsulation
> layer.
> 
> This is necessary especially for nested tunnels, as the IP addresses,
> protocol and ports may all change, thus not matching the previous
> policies. In order to ensure that packets match the relevant inbound
> templates, the xfrm_policy_check should be done before handing off to
> the inner XFRM protocol to decrypt and decapsulate.
> 
> In order to prevent double-checking packets both here and in the
> encapsulation layers, this check is currently limited to nested
> tunnel-mode transforms and checked prior to decapsulation of inner
> tunnel layers (prior to hitting a nested tunnel's xfrm_input, there
> is no great way to detect a nested tunnel). This is primarily a
> performance consideration, as a general blanket check at the end of
> xfrm_input would suffice, but may result in multiple policy checks.
> 
> Test: Tested against Android Kernel Unit Tests
> Signed-off-by: Benedict Wong <benedictwong@google.com>
> ---
>  net/xfrm/xfrm_input.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> index bcb9ee25474b..a3b55d109836 100644
> --- a/net/xfrm/xfrm_input.c
> +++ b/net/xfrm/xfrm_input.c
> @@ -586,6 +586,20 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
>  			goto drop;
>  		}
>  
> +		/* If nested tunnel, check outer states before context is lost.
> +		 * Only nested tunnels need to be checked, since IP addresses change
> +		 * as a result of the tunnel mode decapsulation. Similarly, this check
> +		 * is limited to nested tunnels to avoid performing another policy
> +		 * check on non-nested tunnels. On success, this check also updates the
> +		 * secpath's verified_cnt variable, skipping future verifications of
> +		 * previously-verified secpath entries.
> +		 */
> +		if ((x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL) &&
> +		    sp->verified_cnt < sp->len &&
> +		    !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family)) {
> +			goto drop;
> +		}

This is not the right place to do the policy lookup. We don't know
if we should check XFRM_POLICY_IN or XFRM_POLICY_FWD.

But it looks like we don't reset the secpath in the receive path
like other virtual interfaces do.

Would such a patch fix your issue too?

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index cc6ab79609e2..429de6a28f59 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3516,7 +3516,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 	int xerr_idx = -1;
 	const struct xfrm_if_cb *ifcb;
 	struct sec_path *sp;
-	struct xfrm_if *xi;
+	struct xfrm_if *xi = NULL;
 	u32 if_id = 0;
 
 	rcu_read_lock();
@@ -3668,6 +3668,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			goto reject;
 		}
 
+		if (xi)
+			secpath_reset(skb);
+
 		xfrm_pols_put(pols, npols);
 		return 1;
 	}
