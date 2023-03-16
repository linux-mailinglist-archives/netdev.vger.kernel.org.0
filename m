Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D1B6BC27C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 01:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjCPA3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 20:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbjCPA3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 20:29:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE3E53285;
        Wed, 15 Mar 2023 17:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E923B81F7B;
        Thu, 16 Mar 2023 00:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99992C433D2;
        Thu, 16 Mar 2023 00:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678926574;
        bh=JOo7lCs0JbNI6WF/I8Jddw5Cnnl2jQx+YcjZGn/JaLA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aCmbu2pxjGovbcR1DtH5ixvW6Rd2SNORYexsddbke1CJNTp6VxFwE+RR4tAvOI6WV
         nJkaGXXxIPAWtI/8c3UmurFPy7F2W6jlCw+wjueQxp4YyCJ29X61gMXa8s95naXnoH
         dH23xhLtmumtY8FkBd5Ts6on4cg0Tloh1gJntIIGgwcIZbOkunvOBrLFuRCqZSoJJk
         97EwQAKJ8VkJS6l/ic7NqgBCVtHzCIAFq4ih/dV50mgyUfdQL/JeJIZyV0jbNDzRnp
         o2+EjAae0Y6AdHP0nB6YHSNwokho8RvD0NqzpKPVBcugU1nGhY565hzTsDqU7kpKOZ
         JL675aX/yBmog==
Date:   Wed, 15 Mar 2023 17:29:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: Re: [PATCH net v2 7/8] net/mlx5e: take into account device
 reconfiguration for xdp_features flag
Message-ID: <20230315172932.71de01fa@kernel.org>
In-Reply-To: <20230315163900.381dd25e@kernel.org>
References: <cover.1678364612.git.lorenzo@kernel.org>
        <16c37367670903e86f863cc8c481100dd4b3a323.1678364613.git.lorenzo@kernel.org>
        <20230315163900.381dd25e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 16:39:00 -0700 Jakub Kicinski wrote:
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 87e654b7d06c..5722a1fc6e9e 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -781,6 +781,9 @@ void xdp_set_features_flag(struct net_device *dev, xdp_features_t val)
>                 return;
>  
>         dev->xdp_features = val;
> +
> +       if (dev->reg_state < NETREG_REGISTERED)
> +               return;
>         call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
>  }
>  EXPORT_SYMBOL_GPL(xdp_set_features_flag);
> 
> ? The notifiers are not needed until the device is actually live.

I think so.. let me send a full patch.
