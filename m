Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464DC6D8C2D
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbjDFA46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjDFA45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:56:57 -0400
Received: from out-46.mta1.migadu.com (out-46.mta1.migadu.com [95.215.58.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99226E96
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 17:56:55 -0700 (PDT)
Message-ID: <ea5cda51-e8f0-2bcd-abfa-b6bf4b11d354@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680742613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v5pNCgmHqmE8juo4JSOBCt773Bp7S8yhRwYjVqHpGJY=;
        b=pBzeqEWbOFiXD6UfyX6bpYU0T+G/bTGR5ZnLQzKxBnm5cueivUrKh+z3e8/lN70Emji+cP
        dESbpwel9GZga5K1wEEBMOCRWrMLPUJbNY5h+k/m2WejMHCFhSzlUZPrniMYvfphxtKM4N
        4TGd+wqGGGKSx6DWplUK/OCPZu3EEB8=
Date:   Wed, 5 Apr 2023 17:56:45 -0700
MIME-Version: 1.0
Subject: Re: [PATCH net v2 6/8] veth: take into account device reconfiguration
 for xdp_features flag
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, saeedm@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com, ttoukan.linux@gmail.com
References: <cover.1678364612.git.lorenzo@kernel.org>
 <f20cfdb08d7357b0853d25be3b34ace4408693be.1678364613.git.lorenzo@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <f20cfdb08d7357b0853d25be3b34ace4408693be.1678364613.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/23 4:25 AM, Lorenzo Bianconi wrote:
> +static void veth_set_xdp_features(struct net_device *dev)
> +{
> +	struct veth_priv *priv = netdev_priv(dev);
> +	struct net_device *peer;
> +
> +	peer = rcu_dereference(priv->peer);
> +	if (peer && peer->real_num_tx_queues <= dev->real_num_rx_queues) {
> +		xdp_features_t val = NETDEV_XDP_ACT_BASIC |
> +				     NETDEV_XDP_ACT_REDIRECT |
> +				     NETDEV_XDP_ACT_RX_SG;
> +
> +		if (priv->_xdp_prog || veth_gro_requested(dev))
> +			val |= NETDEV_XDP_ACT_NDO_XMIT |
> +			       NETDEV_XDP_ACT_NDO_XMIT_SG;

This broke the xdp_do_redirect selftest. The bpf CI is consistently failing at:

test_xdp_do_redirect:FAIL:veth_src query_opts.feature_flags unexpected veth_src 
query_opts.feature_flags: actual 35 != expected 103

Please address it asap.
