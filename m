Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750506A2CCD
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 01:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjBZAQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 19:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjBZAQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 19:16:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6BD166EA
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 16:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=foqnmGpMs1C0a7QA/AM97kddjLA6Tlygtuea7Mxtn80=; b=ZzVOhEBInortY0kuo3YJlpcVdd
        yfY0vS/d5ZOphTUbS689sYHhze4GjFwfRKznxTMVuLtxmspN4PZFISGQYx78wg33xc8SDOpZCwKlF
        ATMk+Qpno058XXqH4tO9SlXRmocmQKarrIw9JdZRv1L0uNkdQrEut9ErcuK2Rx0EyMPLhJHZzXu3a
        rwNals9C5/zwcjjJ/y7zJJxYJVWem9zBlwXRCF1/fdpf95sN+J0+v3uCZiOnQGLmWndOAZVmdx+6U
        vJMWA8hgrSCqHMBPZtxorV/BvQh+9JFIHD7OkEOWhbE+/mYCGVjp+WOwXDI/7YrS5rmw0EtjYFoqu
        johhSwOw==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pW4id-00GUKJ-6O; Sun, 26 Feb 2023 00:16:47 +0000
Message-ID: <7e8798e6-36ac-4f26-0a12-c9d6fb302bac@infradead.org>
Date:   Sat, 25 Feb 2023 16:16:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v5 2/2] net/ps3_gelic_net: Use dma_mapping_error
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <cover.1676221818.git.geoff@infradead.org>
 <ea17b44b48e4dad6c97e3f1e61266fcf9f0ad2d5.1676221818.git.geoff@infradead.org>
 <f04caea6-128c-2852-bd25-3d01a803f664@intel.com>
Content-Language: en-US
In-Reply-To: <f04caea6-128c-2852-bd25-3d01a803f664@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/14/23 09:28, Alexander Lobakin wrote:
> From: Geoff Levand <geoff@infradead.org>
> Date: Sun, 12 Feb 2023 18:00:58 +0000
> 
>> The current Gelic Etherenet driver was checking the return value of its
>> dma_map_single call, and not using the dma_mapping_error() routine.
>>
>> Fixes runtime problems like these:
>>
>>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
>>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc
>>
>> Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
>> Signed-off-by: Geoff Levand <geoff@infradead.org>
>> ---
>>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 41 ++++++++++----------
>>  1 file changed, 20 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> index 2bb68e60d0d5..0e52bb99e344 100644
>> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c

>> -		if (!descr->bus_addr)
>> -			goto iommu_error;
>> +		if (unlikely(dma_mapping_error(dev, descr->bus_addr))) {
> 
> dma_mapping_error() already has unlikely() inside.

OK, I'll remove that in the next patch set.

>> +			dev_err(dev, "%s:%d: dma_mapping_error\n", __func__,
>> +				__LINE__);

> It is fast path. You're not allowed to use plain printk on fast path,
> since you may generate then thousands of messages per second.
> Consider looking at _ratelimit family of functions.

OK, I'll fix that.

Thanks for the review.

-Geoff

