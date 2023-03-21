Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EF86C294A
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCUEtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCUEtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:49:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B5F10278
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 21:49:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AF3E618F1
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BBCC433D2;
        Tue, 21 Mar 2023 04:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679374187;
        bh=AoeOEc9tXW4BOahiavtxHWd4sEOmLLw16/fE4gHgxpA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VuqHC/BFMwo/vv1B6fH2PZSVY7T3+jANrTPImLdEnG2H0Qk0p6uoeaHeYANILjp2B
         FVb8vSfj1UrX7TSFejgddr4ADfAOSUOsJcwRd1ead2DE3r33esJ1kvAe/0w6F/4UJh
         lNXRoeVio+P1oQLDe4HV319GfJ9Qk+IgMXlVPsQdojAHn4ndOnPUCyTaX2aD9Q7Zkj
         pLNJCXHoshxCrDGt5T9nZXym7GsZ2aKxx/woUVwJCnIDRUIS/DvbW8iEG6odYaZWgf
         IEq8saUwIG2ysNayVLjYm/Bz//VFuJVAOSfbRfIEN4hv1Ui6cpPZ7GaVgMxNdozrl4
         PfPjqsEJCO5CA==
Date:   Mon, 20 Mar 2023 21:49:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] netdev: Enforce index cap in
 netdev_get_tx_queue
Message-ID: <20230320214942.38395e6e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20230317181941.86151-2-nnac123@linux.ibm.com>
References: <20230317181941.86151-1-nnac123@linux.ibm.com>
        <20230317181941.86151-2-nnac123@linux.ibm.com>
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

On Fri, 17 Mar 2023 13:19:41 -0500 Nick Child wrote:
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 23b0d7eaaadd..fe88b1a7393d 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2482,6 +2482,13 @@ static inline
>  struct netdev_queue *netdev_get_tx_queue(const struct net_device *dev,
>  					 unsigned int index)
>  {
> +	if (unlikely(index >= dev->num_tx_queues)) {
> +		net_warn_ratelimited("%s selects TX queue %d, but number of TX queues is %d\n",
> +				     dev->name, index,
> +				     dev->num_tx_queues);
> +		return &dev->_tx[0];
> +	}
> +

Should we maybe do DEBUG_NET_WARN_ON_ONCE() instead?
It will likely run multiple times per each Tx packet,
so I wonder if we really want to add a branch for what's
effectively defensive programming...
