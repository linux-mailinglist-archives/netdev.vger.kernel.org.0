Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69CC666A87
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 05:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbjALErY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 23:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbjALErX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 23:47:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346A1D132
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:47:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF69EB81AA0
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8B5C433EF;
        Thu, 12 Jan 2023 04:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673498839;
        bh=F0ue6QAWpjFw9OXFioBV9KhNaVbsw9SxS6k4zIWaonA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L132JqSMK6Ii1nPoLp4mPUyjk9OjffQ8pISpO00dRCuQqdKWEL6tSxunfbMqxSk/H
         tapmM/I/5y325jFw7r82cQs4XmiFrNzxvsfyHVMNt+IdY12h6ZTw2oY/idduchw5wd
         W7fbembE87VmKW6skJohJLsINOM8X2jMnLgKTtlQy1nc1MEJ2AT47c864N7jj/g+oU
         p3SCW9q5h/fmTtvfbNrGbSSgMcmx98tIGebPB+z2NmYTGgkvSo59JK1ZShyUn554gc
         mQp/BYGXM1OvBeOiMcSQhH7RBR10eBi5zG/enWa0Z7iU5pO+JdplpL5RPWYduh5UNX
         aaCeEGZzs19fQ==
Date:   Wed, 11 Jan 2023 20:47:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        Boris Pismenny <borisp@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Subject: Re: [PATCH v8 01/25] net: Introduce direct data placement tcp
 offload
Message-ID: <20230111204718.215bc22c@kernel.org>
In-Reply-To: <20230109133116.20801-2-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
        <20230109133116.20801-2-aaptel@nvidia.com>
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

On Mon,  9 Jan 2023 15:30:52 +0200 Aurelien Aptel wrote:
> +	int (*ulp_ddp_limits)(struct net_device *netdev,
> +			      struct ulp_ddp_limits *limits);
> +	int (*ulp_ddp_sk_add)(struct net_device *netdev,
> +			      struct sock *sk,
> +			      struct ulp_ddp_config *config);
> +	void (*ulp_ddp_sk_del)(struct net_device *netdev,
> +			       struct sock *sk);
> +	int (*ulp_ddp_setup)(struct net_device *netdev,
> +			     struct sock *sk,
> +			     struct ulp_ddp_io *io);
> +	void (*ulp_ddp_teardown)(struct net_device *netdev,
> +				 struct sock *sk,
> +				 struct ulp_ddp_io *io,
> +				 void *ddp_ctx);
> +	void (*ulp_ddp_resync)(struct net_device *netdev,
> +			       struct sock *sk, u32 seq);

no need to prefix all the members of this struct with ulp_ddp_
