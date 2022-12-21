Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA39F6530D9
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 13:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiLUMeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 07:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiLUMeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 07:34:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41067C00
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 04:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671626002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UfwSpMUrbS5QlCiQ/lUZJuhmzHTSBFxV4V+3orKFqcg=;
        b=DyGHm8dQWIrBZGw4PJB9i3fZzyFu9vWOpEoWvxWVaDc/H1Y9I3iI1RL4GB5tTIdAym4VPq
        JBVCmDrLVXAPKRdvdPTcoRzq/zFGxwX3f2aDCOV5b4jG3Vrif+eKF6GUVynqdS8J7+jE7t
        VvUu7Pz1anYmUas4PVmlQ+hqHwVa81o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-247-P2BhkhnjMMiQWjiY_Rp7XA-1; Wed, 21 Dec 2022 07:33:21 -0500
X-MC-Unique: P2BhkhnjMMiQWjiY_Rp7XA-1
Received: by mail-wr1-f72.google.com with SMTP id e10-20020adf9bca000000b0026e2396ab34so67116wrc.18
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 04:33:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UfwSpMUrbS5QlCiQ/lUZJuhmzHTSBFxV4V+3orKFqcg=;
        b=dBIISpso75//aANwHQT+ZBHQR0rJxvVWsRsXZqmg8B0RWq0dmjH+7ud1fNVNfARoSH
         +qwZNbg2RnotTTBzaJ/IH9gYvpMNJEpuDvoUVHlI5uz2uBaTAufir2TiPLUZwy2+ex2D
         mAsj+p7s2KkK/j4afJq9OugWV2+niIvJlppvjIji4EaJfnmVBMJTanBzUlBWM/zM7WpO
         x/E9JTHuANhKyidmxOqxlr1l0+JfjL6xFD5j/ClJGf5UciciXuzAaAt3hY8Zh51Xw3ii
         o625EKL/KVKdhrj9Zz12vG+an5YPy9d3nf+igldl6Wm6nnLNuteJWDMO+93/BdJGZeKu
         9eUA==
X-Gm-Message-State: AFqh2krMEkhE/aBBjvB321YSKMTmGxIqiIQqwg5kEvYLwd1Ga+cyrl/l
        i0l9mRlQS5iL60DgikJ7RjNyQ5fil/NmMifXr4/6vT7a2ABHmoV0l2GQv+/YgrQqrVAyzFlU845
        mnu/Ss0uHBOVxNVsV
X-Received: by 2002:a05:6000:1a41:b0:24b:b74d:8012 with SMTP id t1-20020a0560001a4100b0024bb74d8012mr1057875wry.18.1671626000063;
        Wed, 21 Dec 2022 04:33:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuVlFqxMHdgatYSltTWh5BxABbnsJVuYp/aWATKsyX3UxK/IJnpGpWhs1rYaZCrHl/VIrOKbQ==
X-Received: by 2002:a05:6000:1a41:b0:24b:b74d:8012 with SMTP id t1-20020a0560001a4100b0024bb74d8012mr1057864wry.18.1671625999865;
        Wed, 21 Dec 2022 04:33:19 -0800 (PST)
Received: from redhat.com ([2.52.8.61])
        by smtp.gmail.com with ESMTPSA id d1-20020adffbc1000000b002364c77bcacsm15184456wrs.38.2022.12.21.04.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 04:33:19 -0800 (PST)
Date:   Wed, 21 Dec 2022 07:33:16 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] virtio_net: send notification coalescing command only if
 value changed
Message-ID: <20221221073256-mutt-send-email-mst@kernel.org>
References: <20221221120618.652074-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221120618.652074-1-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 02:06:18PM +0200, Alvaro Karsz wrote:
> Don't send a VIRTIO_NET_CTRL_NOTF_COAL_TX_SET or
> VIRTIO_NET_CTRL_NOTF_COAL_RX_SET command if the coalescing parameters
> haven't changed.
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>

Why do we bother? Resending needs more code and helps
reliability ...

> ---
>  drivers/net/virtio_net.c | 48 ++++++++++++++++++++++------------------
>  1 file changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7723b2a49d8..1d7118de62a 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2760,31 +2760,37 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
>  	struct virtio_net_ctrl_coal_tx coal_tx;
>  	struct virtio_net_ctrl_coal_rx coal_rx;
>  
> -	coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
> -	coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
> -	sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
> -
> -	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> -				  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
> -				  &sgs_tx))
> -		return -EINVAL;
> +	if (ec->tx_coalesce_usecs != vi->tx_usecs ||
> +	    ec->tx_max_coalesced_frames != vi->tx_max_packets) {
> +		coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
> +		coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
> +		sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
> +
> +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> +					  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
> +					  &sgs_tx))
> +			return -EINVAL;
>  
> -	/* Save parameters */
> -	vi->tx_usecs = ec->tx_coalesce_usecs;
> -	vi->tx_max_packets = ec->tx_max_coalesced_frames;
> +		/* Save parameters */
> +		vi->tx_usecs = ec->tx_coalesce_usecs;
> +		vi->tx_max_packets = ec->tx_max_coalesced_frames;
> +	}
>  
> -	coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
> -	coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
> -	sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
> +	if (ec->rx_coalesce_usecs != vi->rx_usecs ||
> +	    ec->rx_max_coalesced_frames != vi->rx_max_packets) {
> +		coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
> +		coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
> +		sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
>  
> -	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> -				  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
> -				  &sgs_rx))
> -		return -EINVAL;
> +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> +					  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
> +					  &sgs_rx))
> +			return -EINVAL;
>  
> -	/* Save parameters */
> -	vi->rx_usecs = ec->rx_coalesce_usecs;
> -	vi->rx_max_packets = ec->rx_max_coalesced_frames;
> +		/* Save parameters */
> +		vi->rx_usecs = ec->rx_coalesce_usecs;
> +		vi->rx_max_packets = ec->rx_max_coalesced_frames;
> +	}
>  
>  	return 0;
>  }
> -- 
> 2.32.0

