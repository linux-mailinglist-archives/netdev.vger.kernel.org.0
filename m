Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFD23F2072
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbhHSTRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231500AbhHSTRI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 15:17:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 674BC6056B;
        Thu, 19 Aug 2021 19:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629400591;
        bh=SJ3235q9hx12OGYIqj8/Xxy7qhG3c50+PnIJGMoSKFs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jd/GRVSISKYAijQLjgoLT9KaALfVQp9430QDHKRKwIynSx+U9/h0wz6ZoPfB1GmfC
         +z/U8IjS3mskE4paQZeFqjV4cTD/EVsf4VJyvjTdf8ILql/0qb6qOj4q8gJa0dlV0e
         SZpFkAOfbEu/8T1AGJbh7X60bDi0lXEjzgWhJZI9xoKxk3fymAcv+s6s5hUbeSfpm2
         ZOIBCDxxQG+EAu87xwUl2JJy7AfyESG0JkWfrcCYNymLdLf54tIUiFjMzvoPhZcfNJ
         IdoniaeSO8Qf8AmgW4LWbF4ge7iGseLwxamnP5BL6HERxQHuzaNXl0oEg8i9pvWhEa
         qcqbNnoU7B5qw==
Date:   Thu, 19 Aug 2021 12:16:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc:     mani@kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        butt3rflyh4ck <butterflyhhuangxx@gmail.com>,
        bjorn.andersson@linaro.org, paskripkin@gmail.com
Subject: Re: [PATCH] net: qrtr: fix another OOB Read in qrtr_endpoint_post
Message-ID: <20210819121630.1223327f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210819181458.623832-1-butterflyhuangxx@gmail.com>
References: <20210819181458.623832-1-butterflyhuangxx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Aug 2021 02:14:58 +0800 butt3rflyh4ck wrote:
> From: butt3rflyh4ck <butterflyhhuangxx@gmail.com>
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

Please make sure to CC authors of patches which are under Fixes, they
are usually the best people to review the patch. Adding them now.

> Signed-off-by: butt3rflyh4ck <butterflyhhuangxx@gmail.com>

We'll need your name. AFAIU it's because of Developer Certificate of
Origin. You'll need to resend with this fixed (and please remember the CCs).

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

