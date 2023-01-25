Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F71D67A9C9
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 05:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjAYEyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 23:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYEyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 23:54:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E54C298F2
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 20:54:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 085DDCE1D44
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 04:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E6CC433EF;
        Wed, 25 Jan 2023 04:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674622438;
        bh=HuDChuqbsd83+2R0u+Nvr2LiWnwQKm0OYfH796lVZ9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BPLdeL4drl3N6CWBo7J6NqfRyAdta/7j71IDylVvLsBI7uO6THyqqbaZs5fycv9y/
         d7M9aYw0ctPfFrXfGV6lATQRTWGzzzKmjLTgaeJ7jNtYtqMCswN9I3lmY/+3Abkk2e
         bNkhQLd4cmgsbZ7I6VSw7omC9KOl1GLVOctQA1aA632PfdtOcdrst4n5wFIkxeBbTu
         Xm2G+OPD7iu+qRGx6FE9nPs1BxFZv//2cbo67tCGn74jCvJxgr8PbBxIwAd3mCnABR
         Oilu6S09AvUv7df39Q2P6IkzBfV1Bu3i5MRrw9xl3EM0+aS7JyXvGIw19AkL21eXEY
         y4W1ynWWC2flg==
Date:   Tue, 24 Jan 2023 20:53:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     m.chetan.kumar@linux.intel.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, ilpo.jarvinen@linux.intel.com,
        ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v5 net-next 4/5] net: wwan: t7xx: Enable devlink based
 fw flashing and coredump collection
Message-ID: <20230124205356.2bd6683e@kernel.org>
In-Reply-To: <fc8bbb0b66a5ff3a489ea9857d79b374508090ef.1674307425.git.m.chetan.kumar@linux.intel.com>
References: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
        <fc8bbb0b66a5ff3a489ea9857d79b374508090ef.1674307425.git.m.chetan.kumar@linux.intel.com>
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

On Sat, 21 Jan 2023 19:03:38 +0530 m.chetan.kumar@linux.intel.com wrote:
> 1> Driver Registers with Devlink framework.
> 2> Implements devlink ops flash_update callback that programs modem fw.
> 3> Creates region & snapshot required for device coredump log collection.  

Sounds like these should be 3 patches?

> +	devlink_params_register(dl_ctx, t7xx_devlink_params, ARRAY_SIZE(t7xx_devlink_params));
> +	value.vbool = false;
> +	devlink_param_driverinit_value_set(dl_ctx, T7XX_DEVLINK_PARAM_ID_FASTBOOT, value);
> +	devlink_set_features(dl_ctx, DEVLINK_F_RELOAD);
> +	devlink_register(dl_ctx);

Please take the devl_lock() explicitly and use the devl_
version of those calls.
