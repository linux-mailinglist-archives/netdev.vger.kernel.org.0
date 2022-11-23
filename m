Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2A4636D12
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 23:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiKWW3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 17:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiKWW3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 17:29:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29A21C908;
        Wed, 23 Nov 2022 14:29:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 955A7B82544;
        Wed, 23 Nov 2022 22:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA3CC433D6;
        Wed, 23 Nov 2022 22:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669242579;
        bh=cH9nHeYLvsFLUPXg0Ojh1J6f4FowOk1ddzAiez/0fDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DmmnChB6g81EqGDriHV4aoCQ98VlVoIyVw9WUJE0KSHyH2uQRT1uUnKrsjl8z+g/e
         3itadwVQd4oV/FiGdXsZjeqkhEQVP7YkHCMqEuvgh1nIxyjRYB/Aic1+CdM83fIG5G
         HTX+q1LxQi7wB6oX+88lc4xbJIqoYERcM5fG3XBF9+fu0M5kUM6RRl3AoywkcrzBiD
         fqK3yrhTZabXDccfal9ZnKmU52MpUESfuZzUdj4V1ojw45tysRMymsCzgfdATM88Vb
         oGCofBXA0kVpQMxLaGms7UkiIYY48yT1RZzOBhMcqLwFpobyby3n6l1HHJbKe8aMDV
         gXd/kGhtV6cpQ==
Date:   Wed, 23 Nov 2022 14:29:37 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>,
        Stanislav Fomichev <sdf@google.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] [PATCH bpf-next 2/2] mlx5: Support XDP RX metadata
Message-ID: <Y36e0Qt9eLtLZXmO@x130.lan>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221123144641.339138-1-toke@redhat.com>
 <20221123144641.339138-2-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221123144641.339138-2-toke@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23 Nov 15:46, Toke Høiland-Jørgensen wrote:
>Support RX hash and timestamp metadata kfuncs. We need to pass in the cqe
>pointer to the mlx5e_skb_from* functions so it can be retrieved from the
>XDP ctx to do this.
>
>Cc: John Fastabend <john.fastabend@gmail.com>
>Cc: David Ahern <dsahern@gmail.com>
>Cc: Martin KaFai Lau <martin.lau@linux.dev>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Willem de Bruijn <willemb@google.com>
>Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>Cc: Maryam Tahhan <mtahhan@redhat.com>
>Cc: Stanislav Fomichev <sdf@google.com>
>Cc: xdp-hints@xdp-project.net
>Cc: netdev@vger.kernel.org
>Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>---
>This goes on top of Stanislav's series, obvioulsy. Verified that it works using
>the xdp_hw_metadata utility; going to do ome benchmarking and follow up with the
>results, but figured I'd send this out straight away in case others wanted to
>play with it.
>
>Stanislav, feel free to fold it into the next version of your series if you
>want!
>

[...]

> #endif /* __MLX5_EN_XSK_RX_H__ */
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>index 14bd86e368d5..015bfe891458 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>@@ -4890,6 +4890,10 @@ const struct net_device_ops mlx5e_netdev_ops = {
> 	.ndo_tx_timeout          = mlx5e_tx_timeout,
> 	.ndo_bpf		 = mlx5e_xdp,
> 	.ndo_xdp_xmit            = mlx5e_xdp_xmit,
>+	.ndo_xdp_rx_timestamp_supported = mlx5e_xdp_rx_timestamp_supported,
>+	.ndo_xdp_rx_timestamp    = mlx5e_xdp_rx_timestamp,
>+	.ndo_xdp_rx_hash_supported = mlx5e_xdp_rx_hash_supported,
>+	.ndo_xdp_rx_hash         = mlx5e_xdp_rx_hash,

I hope i am not late to the party.
but I already expressed my feelings regarding using kfunc for xdp hints,
@LPC and @netdevconf.

I think it's wrong to use indirect calls, and for many usecases the
overhead will be higher than just calculating the metadata on the spot.

so you will need two indirect calls per packet per hint.. 
some would argue on some systems calculating the hash would be much faster.
and one major reason to have the hints is to accelerate xdp edge and
security programs with the hw provided hints.

what happened with just asking the driver to place the data in a specific
location on the headroom? 
