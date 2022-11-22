Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2324633D47
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiKVNOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbiKVNN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:13:59 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EEF286F0;
        Tue, 22 Nov 2022 05:13:49 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id BE5DC816C8;
        Tue, 22 Nov 2022 13:13:46 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669122829;
        bh=0vvZL7yCi24L6SpwtynEYYsQneiGf+itsq4xm1bGdnM=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=TaJMuIuVQTMWg6h/iHYBJi9GIdkYDmyAw86nCii1mhsUfnkEj9eomhALrpn1gI+vt
         nWy1YHZVSGjzhdXLLbNg5BghQQdbmFG50PfbCSlg9WQ4gbGMFnlnXbIeZA3X3Ksn6a
         SrcsAeMBp5Il8idcuywFQiNpbj5aWSM3AOMRS6BopFxug4HRy87WJpP4iJOnyzVLy8
         4LyhgusmAmJMx7GCEUyz4D2DwfE/dNyqNjS3CViDLu2VS2n2IXoQfbX3qJCy28ttBb
         ENb/GKOXywlFBD6hTKu/7r7f2y3gB/x+7mvNQrnj8mMQqa3f+a3WwTJCD2x9v2nHGC
         wYWBzb+Vhnkuw==
Message-ID: <0bb0734c-5c3e-3f2c-1163-a9bfa720bf26@gnuweeb.org>
Date:   Tue, 22 Nov 2022 20:13:43 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Olivier Langlois <olivier@trillion01.com>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221121191437.996297-1-shr@devkernel.io>
 <20221121191437.996297-3-shr@devkernel.io>
 <35168b29-a81c-e1b2-7ec9-b5f0b896ee74@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH v5 2/3] io_uring: add api to set / get napi configuration.
In-Reply-To: <35168b29-a81c-e1b2-7ec9-b5f0b896ee74@kernel.dk>
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

On 11/22/22 2:46 AM, Jens Axboe wrote:
> On 11/21/22 12:14?PM, Stefan Roesch wrote:
>> +static int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
>> +{
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	const struct io_uring_napi curr = {
>> +		.busy_poll_to = ctx->napi_busy_poll_to,
>> +	};
>> +
>> +	if (copy_to_user(arg, &curr, sizeof(curr)))
>> +		return -EFAULT;
>> +
>> +	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
>> +	return 0;
>> +#else
>> +	return -EINVAL;
>> +#endif
>> +}
> 
> Should probably check resv/pad here as well, maybe even the
> 'busy_poll_to' being zero?

Jens, this function doesn't read from __user memory, it writes to
__user memory.

@curr.resv and @curr.pad are on the kernel's stack. Both are already
implicitly initialized to zero by the partial struct initializer.

-- 
Ammar Faizi

