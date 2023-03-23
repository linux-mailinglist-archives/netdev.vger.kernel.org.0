Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FFE6C5D48
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjCWDdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjCWDd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:33:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCC53598;
        Wed, 22 Mar 2023 20:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94CBEB81D44;
        Thu, 23 Mar 2023 03:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5DFC433D2;
        Thu, 23 Mar 2023 03:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679542402;
        bh=1ZSupsuXzC8vrgGpj/6doZGXiLRqKihfMUlwCxLsk3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z358mj2F5j2c2We534GNA6GV31ay9kuX9o/ckLMUX3qsktFZ9iOoBhP8Vkg1cnXyZ
         XtaZwvRalN6bSTtv4zKVlWrL4k1BA8EaR5Uk+VkVLJsEA+1ogV8yMnBH4CR7dFlKSe
         IIEk9dOXqK0RI1LdeKr/NUquta2azw8Ur2HkwALYdSAdQuDC/GD1TdT4y/VBQGIVwr
         QzibkT3Ub7HURzOe2aXgN5eL0BZHc4ETeGQOnuFn3WfZdyMeYFMZA/S9CYunWn/vWH
         Cak1IIevYd7ZAz5KgF+E4OA/FRMnYwLHRkZcRRWlPHIm0k6OBoeEYE+wiEVSM4Zs4c
         UtFWQdtxKBQvg==
Date:   Wed, 22 Mar 2023 20:33:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tianfei Zhang <tianfei.zhang@intel.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-fpga@vger.kernel.org, ilpo.jarvinen@linux.intel.com,
        andriy.shevchenko@linux.intel.com, vinicius.gomes@intel.com,
        pierre-louis.bossart@linux.intel.com, marpagan@redhat.com,
        russell.h.weight@intel.com, matthew.gerlach@linux.intel.com,
        nico@fluxnic.net,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <20230322203320.798a1f77@kernel.org>
In-Reply-To: <20230322143547.233250-1-tianfei.zhang@intel.com>
References: <20230322143547.233250-1-tianfei.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 10:35:47 -0400 Tianfei Zhang wrote:
> + * A fine ToD HW clock offset adjustment. To perform the fine offset adjustment, the
> + * adjust_period and adjust_count argument are used to update the TOD_ADJUST_PERIOD
> + * and TOD_ADJUST_COUNT register for in hardware. The dt->tod_lock spinlock must be
> + * held when calling this function.
> + */
> +static int fine_adjust_tod_clock(struct dfl_tod *dt, u32 adjust_period,
> +				 u32 adjust_count)
> +{
> +	void __iomem *base = dt->tod_ctrl;
> +	u32 val;
> +
> +	writel(adjust_period, base + TOD_ADJUST_PERIOD);
> +	writel(adjust_count, base + TOD_ADJUST_COUNT);
> +
> +	/* Wait for present offset adjustment update to complete */
> +	return readl_poll_timeout_atomic(base + TOD_ADJUST_COUNT, val, !val, TOD_ADJUST_INTERVAL_US,
> +				  TOD_ADJUST_MAX_US);
> +}
> +
> +/*
> + * A coarse ToD HW clock offset adjustment.
> + * The coarse time adjustment performs by adding or subtracting the delta value

You should wrap the code at 80 characters in places 
where it's easily done.
