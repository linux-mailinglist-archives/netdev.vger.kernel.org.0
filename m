Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6672C676346
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 04:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjAUDMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 22:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjAUDL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 22:11:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1E13C1F;
        Fri, 20 Jan 2023 19:11:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B91FB82B8A;
        Sat, 21 Jan 2023 03:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E036C433D2;
        Sat, 21 Jan 2023 03:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674270714;
        bh=+ECSThDtgHq6VGg+SpyqaVTiA6kkOP5Gz3WruwdxuCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q7fCzHWAYbDwT4PYu3HePieOlwppJsOEOFtdfUuolfJPWgFq0jBNXAdrvnAOgquy8
         O1XVFROVjdXeWMYkxtLP1j+W4W2I78YxWIkhGt3aKVVJdE5ryRxRXvQR4hNIseKnmy
         paFDe+9oEu9pVRQgkWYhkeTw4M8zsMmwf0x4eDo8qXG2JOfmYZ/Kuh8PxFkYaX9c+R
         w9UyryL+dHSOi3qRsGfVWZLeyhpsKJ1i1yczFjpFeL8w7oKhVCBzk51CR/FzJ2UXWd
         6SIwaIz7a8BrPWmEE3ICu9TKPSQvrod+3UPzt9Lj5yB5x0ygjpkNavxF01pdY+ihlf
         f63olYqn4KsrQ==
Date:   Fri, 20 Jan 2023 19:11:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com
Subject: Re: [PATCH bpf-next 2/7] drivers: net: turn on XDP features
Message-ID: <20230120191152.44d29bb1@kernel.org>
In-Reply-To: <861224c406f78694530fde0d52c49d92e1e990a2.1674234430.git.lorenzo@kernel.org>
References: <cover.1674234430.git.lorenzo@kernel.org>
        <861224c406f78694530fde0d52c49d92e1e990a2.1674234430.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Jan 2023 18:16:51 +0100 Lorenzo Bianconi wrote:
> +static inline void
> +xdp_features_set_redirect_target(xdp_features_t *xdp_features, bool support_sg)
> +{
> +	*xdp_features |= NETDEV_XDP_ACT_NDO_XMIT;
> +	if (support_sg)
> +		*xdp_features |= NETDEV_XDP_ACT_NDO_XMIT_SG;
> +}
> +
> +static inline void
> +xdp_features_clear_redirect_target(xdp_features_t *xdp_features)
> +{
> +	*xdp_features &= ~(NETDEV_XDP_ACT_NDO_XMIT |
> +			   NETDEV_XDP_ACT_NDO_XMIT_SG);
> +}
> +

Shouldn't these generate netlink notifications?
