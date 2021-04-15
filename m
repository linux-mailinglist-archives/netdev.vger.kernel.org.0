Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007363603AD
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhDOHsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:48:14 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:34350 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhDOHsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:48:13 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 047E9800051;
        Thu, 15 Apr 2021 09:47:50 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 09:47:49 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 15 Apr
 2021 09:47:49 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 67AC331805D9; Thu, 15 Apr 2021 09:47:49 +0200 (CEST)
Date:   Thu, 15 Apr 2021 09:47:49 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net 2/3] net/xfrm: Add inner_ipproto into sec_path
Message-ID: <20210415074749.GM2966489@gauss3.secunet.de>
References: <20210414232540.138232-1-saeed@kernel.org>
 <20210414232540.138232-3-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210414232540.138232-3-saeed@kernel.org>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 04:25:39PM -0700, Saeed Mahameed wrote:
> From: Huy Nguyen <huyn@nvidia.com>
> 
> The inner_ipproto saves the inner IP protocol of the plain
> text packet. This allows vendor's IPsec feature making offload
> decision at skb's features_check and configuring hardware at
> ndo_start_xmit.
> 
> For example, ConnectX6-DX IPsec device needs the plaintext's
> IP protocol to support partial checksum offload on
> VXLAN/GENEVE packet over IPsec transport mode tunnel.
> 
> Signed-off-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Huy Nguyen <huyn@nvidia.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>  include/net/xfrm.h     |  1 +
>  net/xfrm/xfrm_output.c | 36 +++++++++++++++++++++++++++++++++++-
>  2 files changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index c58a6d4eb610..e535700431fb 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -1032,6 +1032,7 @@ struct sec_path {
>  
>  	struct xfrm_state	*xvec[XFRM_MAX_DEPTH];
>  	struct xfrm_offload	ovec[XFRM_MAX_OFFLOAD_DEPTH];
> +	u8			inner_ipproto;

This is for offload, so it should go to struct xfrm_offload.
We have already 'proto' there, so it is just easy add
'inner_proto'.

