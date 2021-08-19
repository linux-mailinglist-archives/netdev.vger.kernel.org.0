Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C263F1E7C
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhHSQ6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhHSQ6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3EE860FE6;
        Thu, 19 Aug 2021 16:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629392260;
        bh=fLZ0moATq+iedeajzsVeMx4RO/u++Zw9Hj7B9K3nQuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GaLFnb1g7AgvVwf/MoKri+a3jUtPdiQQCmSDM9n1bnZBzdT2XKJSiUufvYoeycAme
         Uqa/7F4nP4Byq5lgPmD2UP9/l7nWHUQZgo60mBhGIG1QG7unx+/23Ygzb/5+ZBXHUV
         IP4AE+W9JlaW6486xIqNPQ5BJiXFymx6KMOmPp2k5bHdiuBy7rw9hh7cUBJZkbM7DY
         zeKEHrnuh9LFAoPLVk+kD0UYLX0L8ydOUHNXQ4rKIr5sl23Q4yac5dEoS5HAzE7ZHz
         +8fGKXyem/61Xt/QXLUYlqlRSIezNAsME84QMYWvwGGwABn00XdmZzAYAlxQYZNhST
         fxAe6N9qCdzJA==
Date:   Thu, 19 Aug 2021 22:27:31 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Another out-of-bound Read in qrtr_endpoint_post in
 net/qrtr/qrtr.c
Message-ID: <20210819165731.GD200135@thinkpad>
References: <CAFcO6XOLxfHcRFVNvUTPVNiyQ4FKwZ-x9SDgL7n9EJphoxawxQ@mail.gmail.com>
 <CAFcO6XOGjHzys4GywczXyePiPcEXw7P=gBPwYU5nv0f-a=eFig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFcO6XOGjHzys4GywczXyePiPcEXw7P=gBPwYU5nv0f-a=eFig@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Aug 18, 2021 at 03:33:38PM +0800, butt3rflyh4ck wrote:
> Here I make a patch for this issue.

[...]

> From 18d9f83f17375785beadbe6a0d0ee59503f65925 Mon Sep 17 00:00:00 2001
> From: butt3rflyh4ck <butterflyhhuangxx@gmail.com>
> Date: Wed, 18 Aug 2021 14:19:38 +0800
> Subject: [PATCH] net: qrtr: fix another OOB Read in qrtr_endpoint_post
> 
> This check was incomplete, did not consider size is 0:
> 
> 	if (len != ALIGN(size, 4) + hdrlen)
>                     goto err;
> 
> if size from qrtr_hdr is 0, the result of ALIGN(size, 4)
> will be 0, In case of len == hdrlen and size == 0
> in header this check won't fail and
> 
> 	if (cb->type == QRTR_TYPE_NEW_SERVER) {
>                 /* Remote node endpoint can bridge other distant nodes */
>                 const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
> 
>                 qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
>         }
> 
> will also read out of bound from data, which is hdrlen allocated block.
> 
> Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
> Fixes: ad9d24c9429e ("net: qrtr: fix OOB Read in qrtr_endpoint_post")
> Signed-off-by: butt3rflyh4ck <butterflyhhuangxx@gmail.com>

Thanks for the bug report and the fix. Could you please send the fix as a proper
patch as per: Documentation/process/submitting-patches.rst

Thanks,
Mani

> ---
>  net/qrtr/qrtr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index 171b7f3be6ef..0c30908628ba 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
>  		goto err;
>  	}
>  
> -	if (len != ALIGN(size, 4) + hdrlen)
> +	if (!size || len != ALIGN(size, 4) + hdrlen)
>  		goto err;
>  
>  	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
> -- 
> 2.25.1
> 

