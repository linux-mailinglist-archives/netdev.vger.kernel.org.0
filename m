Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D89C632B5C
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiKURp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiKURpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:45:23 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9534853ECF;
        Mon, 21 Nov 2022 09:45:21 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 8E47F816AE;
        Mon, 21 Nov 2022 17:45:18 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669052720;
        bh=dyD0zchae5y2rg9SSls4wz00jK0afhTlcmMVE/acKtM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=K3QMGo6/Up7PCwiWCDLe90Em2kiceIrd2ngcIYlyUZEAagrFXw2qBt+Ut71X+qv9X
         y1JyDWDFhFBFvVpTnk5wmoIdCp8+p3xljGJHOywiRmTigyViDOCmLr6nibpGs2+6k/
         pduLoutvD/hRl9lLTC+vzUD6oRua5lqmoti+wmjuerkdl33nfOl7/Fp7tdr+sjZFzb
         1XCkDZrqujN2UFxgxT5Ib5H3L+kZMbW4gxYDChHvWR3rZQMrGs64vongIGC0vJ/Nx0
         0eMZyIj5wfBnhT/7UliVoeyQmDllv84jtmKVGk/pI3TV7DOnwFNjGxSiWHIRODRms7
         +5BCSwirUM9kA==
Message-ID: <2dde9961-b820-c301-6eb7-c5a26309c019@gnuweeb.org>
Date:   Tue, 22 Nov 2022 00:45:15 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH v4 2/3] io_uring: add api to set / get napi
 configuration.
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221121172953.4030697-1-shr@devkernel.io>
 <20221121172953.4030697-3-shr@devkernel.io>
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221121172953.4030697-3-shr@devkernel.io>
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

On 11/22/22 12:29 AM, Stefan Roesch wrote:
> +static int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	const struct io_uring_napi curr = {
> +		.busy_poll_to = ctx->napi_busy_poll_to,
> +	};
> +	struct io_uring_napi *napi;
> +
> +	napi = memdup_user(arg, sizeof(*napi));
> +	if (IS_ERR(napi))
> +		return PTR_ERR(napi);
> +
> +	WRITE_ONCE(ctx->napi_busy_poll_to, napi->busy_poll_to);
> +
> +	kfree(napi);
> +
> +	if (copy_to_user(arg, &curr, sizeof(curr)))
> +		return -EFAULT;
> +
> +	return 0;

Considering:

    1) `struct io_uring_napi` is 16 bytes in size.

    2) The lifetime of `struct io_uring_napi *napi;` is brief.

There is no need to use memdup_user() and kfree(). You can place it
on the stack and use copy_from_user() instead.

-- 
Ammar Faizi

