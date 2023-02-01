Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525486871D9
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 00:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjBAXY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 18:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjBAXYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 18:24:53 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9868518A8D;
        Wed,  1 Feb 2023 15:24:15 -0800 (PST)
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.183.234])
        by gnuweeb.org (Postfix) with ESMTPSA id 9B45482FB1;
        Wed,  1 Feb 2023 23:15:29 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1675293332;
        bh=IvA3kcjhH3kFIonqYsH/a8oN8jrejMfZxNOTHkij1fY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EfvDsl2RbkhIEqGWEDXVjTGIjDqvD96R1AF/0dLMr7WJ8nqgKqVk3E9yk6YyHxgwk
         1+C+GKS6TbVuAWbQqElqz1oW+e4xmsnTKPmA+08GEZB/pYs10NgzsuMYAtL2OjUbKs
         exvb9oNHB0dMiJBjEs8XKTBlvCJQbwAOcCWH2nyjIC3GYakPe0yhfqoVPH9K/s/3SB
         Aqhu7p8rTeHVZ6EUqlQqehZsIgnNuVdIs6pwKQcz28GC1S3N9deXYTgo9Ga9T1ZKxu
         uT9p2/DslWnkoXvdJT2NzS9ok1hwVYN15yfOVkOFVRDDUewC+EuuKT5iZlbSnNCsE/
         pTwDHPE7i3HaA==
Date:   Thu, 2 Feb 2023 06:15:25 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v6 2/3] io_uring: add api to set / get napi configuration.
Message-ID: <Y9ryjXdUg2ii8P71@biznet-home.integral.gnuweeb.org>
References: <20230201222254.744422-1-shr@devkernel.io>
 <20230201222254.744422-3-shr@devkernel.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201222254.744422-3-shr@devkernel.io>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 02:22:53PM -0800, Stefan Roesch wrote:
> +static int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	const struct io_uring_napi curr = {
> +		.busy_poll_to = ctx->napi_busy_poll_to,
> +	};
> +
> +	if (arg) {
> +		if (copy_to_user(arg, &curr, sizeof(curr)))
> +			return -EFAULT;
> +	}
> +
> +	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
> +	return 0;
> +#else
> +	return -EINVAL;
> +#endif
> +}

Just to follow the common pattern when a feature is not enabled the
return value is -EOPNOTSUPP instead of -EINVAL. What do you think?

> +	case IORING_UNREGISTER_NAPI:
> +		ret = -EINVAL;
> +		if (!arg)
> +			break;
> +		ret = io_unregister_napi(ctx, arg);
> +		break;

This needs to be corrected. If the @arg var is NULL, you return -EINVAL.
So io_unregister_napi() will always have @arg != NULL. This @arg check
should go, allow the user to pass a NULL pointer to it.

Our previous agreement on this API is to allow the user to pass a NULL
pointer in case the user doesn't care about the old value.

Also, having a liburing test case that verifies this behavior would be
excellent.

-- 
Ammar Faizi

