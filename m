Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A721B3890
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 09:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgDVHMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 03:12:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24967 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725811AbgDVHMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 03:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587539555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pdqu1HOdp/sMFSCDZ2cid2+2Ni/4URBjxSyv7u+9fCQ=;
        b=BltcYY3Wf+6UxEqu3N7J9ZWReW0n4ZQhXNHF8goub3gEMBGeejJ6v2/qvjRfMW1231XI5b
        BOCDilmI9H5kcJUztCxVIzGyA0pHkmRI+WgEgKiqSAUjZyz5f7+hb1vOM8CYXRBeHTmwbJ
        q0IM/camOdxVDrK3ttuj1NqTmKcVXQo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-5eU-hmiLMUW6tP9eOWyHKA-1; Wed, 22 Apr 2020 03:12:33 -0400
X-MC-Unique: 5eU-hmiLMUW6tP9eOWyHKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 044EB8018AF;
        Wed, 22 Apr 2020 07:12:32 +0000 (UTC)
Received: from carbon (unknown [10.40.208.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC5A2CFC0;
        Wed, 22 Apr 2020 07:12:27 +0000 (UTC)
Date:   Wed, 22 Apr 2020 09:12:26 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH net-next 4/4] dpaa2-eth: use bulk enqueue in
 .ndo_xdp_xmit
Message-ID: <20200422091226.774b0dd7@carbon>
In-Reply-To: <20200421152154.10965-5-ioana.ciornei@nxp.com>
References: <20200421152154.10965-1-ioana.ciornei@nxp.com>
        <20200421152154.10965-5-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Apr 2020 18:21:54 +0300
Ioana Ciornei <ioana.ciornei@nxp.com> wrote:

> Take advantage of the bulk enqueue feature in .ndo_xdp_xmit.
> We cannot use the XDP_XMIT_FLUSH since the architecture is not capable
> to store all the frames dequeued in a NAPI cycle so we instead are
> enqueueing all the frames received in a ndo_xdp_xmit call right away.
> 
> After setting up all FDs for the xdp_frames received, enqueue multiple
> frames at a time until all are sent or the maximum number of retries is
> hit.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 60 ++++++++++---------
>  1 file changed, 32 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 9a0432cd893c..08b4efad46fd 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -1933,12 +1933,12 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
>  			      struct xdp_frame **frames, u32 flags)
>  {
>  	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
> +	int total_enqueued = 0, retries = 0, enqueued;
>  	struct dpaa2_eth_drv_stats *percpu_extras;
>  	struct rtnl_link_stats64 *percpu_stats;
> +	int num_fds, i, err, max_retries;
>  	struct dpaa2_eth_fq *fq;
> -	struct dpaa2_fd fd;
> -	int drops = 0;
> -	int i, err;
> +	struct dpaa2_fd *fds;
>  
>  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
>  		return -EINVAL;
> @@ -1946,41 +1946,45 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
>  	if (!netif_running(net_dev))
>  		return -ENETDOWN;
>  
> +	/* create the array of frame descriptors */
> +	fds = kcalloc(n, sizeof(*fds), GFP_ATOMIC);

I don't like that you have an allocation on the transmit fast-path.

There are a number of ways you can avoid this.

Option (1) Given we know that (currently) devmap will max bulk 16
xdp_frames, we can have a call-stack local array with struct dpaa2_fd,
that contains 16 elements, sizeof(struct dpaa2_fd)==32 bytes times 16 is
512 bytes, so it might be acceptable.  (And add code to alloc if n >
16, to be compatible with someone increasing max bulk in devmap).

Option (2) extend struct dpaa2_eth_priv with an array of 16 struct
dpaa2_fd's, that can be used as fds storage.

> +	if (!fds)
> +		return -ENOMEM;
> +

[...]
> +	kfree(fds);


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

