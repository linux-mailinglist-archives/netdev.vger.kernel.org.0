Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AAC687CA5
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjBBLsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjBBLsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:48:09 -0500
X-Greylist: delayed 36808 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Feb 2023 03:48:07 PST
Received: from out-137.mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB28C402E7
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 03:48:06 -0800 (PST)
Message-ID: <c3e0428b-f293-657b-08e5-d4299bf344b8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675338485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LyJ3WMerf/aIBJsBc6T+b6ZJjTgD4rC3cDM4ym644g0=;
        b=UsSnLfV46dTtuNMrFlufGZlipagZfW7nVTAWhFYrfcG8k1VXRu3JTf83U4fsE7BVuVHWIW
        qkPgORon9RjvnHU/uh1fdEtUCEP2a+GSK7X4TxZfeEaCFqs0XdYJcGZ62s3HZrPxSf2Zw9
        AY1IfMa3L8cIubDp7BdnNzeDMoKXEcQ=
Date:   Thu, 2 Feb 2023 11:48:04 +0000
MIME-Version: 1.0
Subject: Re: [PATCH net v4 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
To:     Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@meta.com>
Cc:     Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org
References: <20230201122605.1350664-1-vadfed@meta.com>
 <20230201122605.1350664-3-vadfed@meta.com>
 <20230201190801.5082bb49@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20230201190801.5082bb49@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/02/2023 03:08, Jakub Kicinski wrote:
> On Wed, 1 Feb 2023 04:26:05 -0800 Vadim Fedorenko wrote:
>> +	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id) {
> 
> FWIW I still can't understand why this is correct. If we lose ts for
> the last elem before wrap we'll see something like (assume wrap at 256
> for easier math):
> 
>    cc: 255  pc: 2    skb_id: 0   => cc > skb_id, OOO, drop
>    cc: 255  pc: 2    skb_id: 1   => cc > skb_id, OOO, drop
>    cc: 255  pc: 3 // produce
>    cc: 255  pc: 3    skb_id: 2   => cc > skb_id, OOO, drop
>    cc: 255  pc: 4 // produce
>    cc: 255  pc: 4    skb_id: 3   => cc > skb_id, OOO, drop
> 
> No?

Agreed. I'll change the check in the next version, thanks!
