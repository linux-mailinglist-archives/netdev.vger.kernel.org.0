Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAE7639132
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 22:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiKYVoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 16:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiKYVn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 16:43:59 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EFE21E02;
        Fri, 25 Nov 2022 13:43:59 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 6B64F810FE;
        Fri, 25 Nov 2022 21:43:56 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669412638;
        bh=6NJSyBuPSXeA3jyb2VX6aFoW7Kiif1Et0jRGbTEorgw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cCD8lw59+ifRh7z/DZMZrL31X/0MJhytH/4NBgBXKAxET2XTfQ+DuyZK/0fgKGuGy
         VwxpVpxUlSA61idC0Ll5crpOekcVSGj14nn1ak5T78ByA2CQpsiIwziZ49fzlVdDkN
         CkBKOw4E7eEPKs0M2X04LUScK9za/phjWdq2WM07zUgcSOmxfCcmDfZbOVQ8yLr/vk
         /7Iaikg8BhwTHZFyTi2Ua7m1M7jV4wMjYcLml19S4rXXiooG5wxiJrJav4wqrf7aH6
         TGHLussphwexSYIrkk5rSVJYYZU3e32vQA7UaBXTiwHoHztuD2Iq4o6/xeE0EnZeqk
         ijxnvFNsSFCSA==
Message-ID: <6ab47920-7e13-cd67-76c8-2d4ca8a31fd5@gnuweeb.org>
Date:   Sat, 26 Nov 2022 04:43:54 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 2/3] io_uring: add api to set / get napi configuration.
Content-Language: en-US
To:     Facebook Kernel Team <kernel-team@fb.com>,
        Stefan Roesch <shr@devkernel.io>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20221121191437.996297-1-shr@devkernel.io>
 <20221121191437.996297-3-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221121191437.996297-3-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/22 2:14 AM, Stefan Roesch wrote:
> +static int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	const struct io_uring_napi curr = {
> +		.busy_poll_to = ctx->napi_busy_poll_to,
> +	};
> +
> +	if (copy_to_user(arg, &curr, sizeof(curr)))
> +		return -EFAULT;
> +
> +	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
> +	return 0;
> +#else
> +	return -EINVAL;
> +#endif
> +}
> +
I suggest allowing users to pass a NULL as the arg in case they
don't want to care about the old values.

Something like:

    io_uring_unregister_napi(ring, NULL);

What do you think?

-- 
Ammar Faizi

