Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D996C97C6
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 22:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjCZUiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 16:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCZUiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 16:38:50 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1795252
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 13:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=qVf0O6v6SeqmGF9Kh7KDJ5KiLT8JseXMVeSt+RpXNB0=; b=N5nSxLN4Bx3zj1hbQNely37Gx6
        qu6+YEPwU7ix5p82RUZ3DlUzRGSFXk72cFbdbdngaX01pHl1TAQ1w6aw2QeeWjlm28zXdw4yCOMPD
        +QLY6ruzIC0aQX9Voi5ssZpoE6LNzn9mw6QTYyuBAZpZga7sw2TnuITNVsDnCGgEWIUwFV3MkBgtj
        xYifyWc+GMVfmDCjElGugNMl99LOVxdRUrT5Z3yftEWOdq9ntvjOrQxWTDZBp7ewuPY9wPJoZE9MW
        2iE/K8NjK5bbngLS15XvPCDiXTfpQAYEfx9BIwf7kxtdoXlxmT69kGQKaks3rXcosRGX+HLb0aaoN
        0UFccQHw==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pgX8M-005wsc-19;
        Sun, 26 Mar 2023 20:38:35 +0000
Message-ID: <188a8527-23ce-5a5a-b1ca-3d45b03f9086@infradead.org>
Date:   Sun, 26 Mar 2023 13:38:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v6 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <cover.1677377639.git.geoff@infradead.org>
 <1bf36b8e08deb3d16fafde3e88ae7cd761e4e7b3.1677377639.git.geoff@infradead.org>
 <fe77a548-a248-95f3-f840-8cd6ee0c1c27@intel.com>
Content-Language: en-US
In-Reply-To: <fe77a548-a248-95f3-f840-8cd6ee0c1c27@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've gone back to setting up the napi routines.

On 2/28/23 08:12, Alexander Lobakin wrote:
> From: Geoff Levand <geoff@infradead.org>
> Date: Sun, 26 Feb 2023 02:25:42 +0000
> 
>> The Gelic Ethernet device needs to have the RX sk_buffs aligned to
>> GELIC_NET_RXBUF_ALIGN and the length of the RX sk_buffs must be a
>> multiple of GELIC_NET_RXBUF_ALIGN.

>> +
>> +	napi_buff = napi_alloc_frag_align(GELIC_NET_MAX_MTU,
>> +		GELIC_NET_RXBUF_ALIGN);
>> +
>> +	descr->skb = napi_build_skb(napi_buff, GELIC_NET_MAX_MTU);
> 
> You're mixing two, no, three things here.
> 
> 1. MTU. I.e. max L3+ payload len. It doesn't include Eth header, VLAN
>    and FCS.
> 2. Max frame size. It is MTU + the abovementioned. Usually it's
>    something like `some power of two - 1`.
> 3. skb truesize.
>    It is: frame size (i.e. 2) + headroom (usually %NET_SKB_PAD when
>    !XDP, %XDP_PACKET_HEADROOM otherwise, plus %NET_IP_ALIGN) + tailroom
>    (SKB_DATA_ALIGN(sizeof(struct skb_shared_info), see
>     SKB_WITH_OVERHEAD() and adjacent macros).
> 
> I'm not sure whether your definition is the first or the second... or
> maybe third? You had 1522, but then changed to 1920? You must pass the
> third to napi_build_skb().
> So you should calculate the truesize first, then allocate a frag and
> build an skb. Then skb->data will point to the free space with the
> length of your max frame size.
> And the truesize calculation might be not just a hardcoded value, but an
> expression where you add all those head- and tailrooms, so that they
> will be calculated depending on the platform's configuration.
> 
> Your current don't reserve any space as headroom, so that frames / HW
> visible part starts at the very beginning of a frag. It's okay, I mean,
> there will be reallocations when the stack needs more headroom, but
> definitely not something to kill the system. You could leave it to an
> improvement series in the future*.
> But it either way *must* include tailroom, e.g.
> SKB_DATA_ALIGN(see_above), otherwise your HW might overwrite kernel
> structures.
> 
> * given that the required HW alignment is 128, I'd just allocate 128
> bytes more and then do `skb_reserve(skb, RXBUF_HW_ALIGN` right after
> napi_build_skb() to avoid reallocations.

Looking at the docs for the PS3's gelic network device I found
that the DMA buffer it uses has a fixed layout:

  VLAN Data   2 bytes
  Dest MAC    6 bytes
  Source MAC  6 bytes
  Type/Length 2 bytes
  DATA        46-2294 bytes

So, the max DMA buffer size is 2310, which I guess is the same
as the MAX_FRAME size, which is given as 2312.  That's about
18.05*128.  So if the napi_buff size is 19*128 = 2432 and the
start aligned to 128, that should give me what I need:

  #define GELIC_NET_RXBUF_ALIGN 128
  static const unsigned int napi_buff_size = 19 * GELIC_NET_RXBUF_ALIGN;

  napi_buff = napi_alloc_frag_align(napi_buff_size, GELIC_NET_RXBUF_ALIGN);

  descr->skb = napi_build_skb(napi_buff, napi_buff_size);

  cpu_addr = dma_map_single(dev, napi_buff, napi_buff_size, DMA_FROM_DEVICE);

You can find the actual patch here:

  https://git.kernel.org/pub/scm/linux/kernel/git/geoff/ps3-linux.git/commit/?h=ps3-queue-v6.3--gelic-work&id=629de5a5d2875354c5d48fca7f5c1d24f4bf3a8e

I did some rigorous testing with this and didn't have any
problems.

-Geoff




 





