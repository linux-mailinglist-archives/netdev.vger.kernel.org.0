Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F66A52651D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 16:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381412AbiEMOpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 10:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381437AbiEMOo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 10:44:56 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6683C702
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 07:44:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7610B20613;
        Fri, 13 May 2022 16:44:34 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id r3Hi3bxaDUk9; Fri, 13 May 2022 16:44:34 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 080722058E;
        Fri, 13 May 2022 16:44:34 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 009BA80004A;
        Fri, 13 May 2022 16:44:33 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 16:44:33 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 16:44:33 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 109FA3180A74; Fri, 13 May 2022 16:44:33 +0200 (CEST)
Date:   Fri, 13 May 2022 16:44:32 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH ipsec-next 3/6] xfrm: add an interface to offload policy
Message-ID: <20220513144432.GK680067@gauss3.secunet.de>
References: <cover.1652176932.git.leonro@nvidia.com>
 <66ec5e0b1ac8c5570391830473bc538650be04e0.1652176932.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <66ec5e0b1ac8c5570391830473bc538650be04e0.1652176932.git.leonro@nvidia.com>
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

On Tue, May 10, 2022 at 01:36:54PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>  
> +int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
> +			struct xfrm_user_offload *xuo, u8 dir)
> +{
> +	struct xfrm_dev_offload *xdo = &xp->xdo;
> +	struct net_device *dev;
> +	int err;
> +
> +	if (!xuo->flags || xuo->flags & ~XFRM_OFFLOAD_FULL)
> +		/* We support only Full offload mode and it means
> +		 * that user must set XFRM_OFFLOAD_FULL bit.
> +		 */
> +		return -EINVAL;

Minor nit: Please add the comment before the 'if' statement or
use braces.

