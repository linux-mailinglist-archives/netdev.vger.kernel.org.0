Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1466AADCA
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 03:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjCECIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 21:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCECIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 21:08:05 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF62DBE8
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 18:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=12h7df2cbC1ROxKnp3ZwT83/sZad6sWR/tLZN3wG5kg=; b=D09/D7woHlQC2QYGHG4YFjdY/h
        gyki/6MWnsMQDKY3SUqroSREWtA5msbVvtMjn8wMjITaDAhB+deNPj/6tRi5Aaptuzhv4hW2oQfcY
        xSzFI/eDuQIkMs4tpVBhNBkqIv6/dBeuSSJE3mQiHDqg04/zs/h68DR/mJS/++mJjqSjrvSUXe5dM
        PDhdNmwNnV1USvmYJrMI2trcun7F6EA6kM+mbBP5JRPoknqi5WZuSUQBbntS2oLQgKqFYv7j36Gdq
        y4uiSws/L9aJzF91o0GEZFi2Hj5AkHNoIqVk0EEWs5424AZZf9R7tTbZk8aFohIyyozyoTvMrdMhP
        mcycVT8g==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pYdmq-00GBZc-1L;
        Sun, 05 Mar 2023 02:07:44 +0000
Message-ID: <e4b6ec21-0ed3-1c2c-58e2-8e0b329082f9@infradead.org>
Date:   Sat, 4 Mar 2023 18:07:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v6 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <cover.1677377639.git.geoff@infradead.org>
 <1bf36b8e08deb3d16fafde3e88ae7cd761e4e7b3.1677377639.git.geoff@infradead.org>
 <20230227182040.75740bb6@kernel.org>
 <03f987ab-2cc1-21f6-a4cb-2df1273a8560@intel.com>
 <20230228123135.251edc25@kernel.org>
Content-Language: en-US
In-Reply-To: <20230228123135.251edc25@kernel.org>
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

On 2/28/23 12:31, Jakub Kicinski wrote:
>>
>> IIRC the original problem is that the skb linear parts are not always
>> aligned to a boundary which this particular HW requires. So initially
>> there was something like "allocate len + alignment - 1, then
>> PTR_ALIGN()",
> 
> Let's focus on where the bug is. At a quick look I'm guessing that 
> the bug is that we align the CPU buffer instead of the DMA buffer.
> We should pass the entire allocate len + alignment - 1 as length 
> to dma_map() and then align the dma_addr. dma_addr is what the device
> sees. Not the virtual address of skb->data.
> 
> If I'm right the bug is not in fact directly addressed by the patch.
> I'm guessing the patch helps because at least the patch passes the
> aligned length to the dma_map(), rather than GELIC_NET_MAX_MTU (which
> is not a multiple of 128).

I found some old notes for the gelic network device.  It had values
for the max frame size, and the max MTU size.  These values are the
same as what is in the 'spider net' driver.  For patch set v7 I just
took what the spider net driver was doing for its RX DMA buffer
allocation and applied that to the gelic driver.

I think your comment about aligning the DMA buffer is addressed by
the lines:

    offset = ((unsigned long)descr->skb->data) &
		(GELIC_NET_RXBUF_ALIGN - 1);
    if (offset)
        skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);

I tried to do some thorough testing of v7, and I couldn't get it to
error.

-Geoff



