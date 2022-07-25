Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6859580438
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 20:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiGYSxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 14:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiGYSx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 14:53:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279EE13F71;
        Mon, 25 Jul 2022 11:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C65F9B810A4;
        Mon, 25 Jul 2022 18:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C525C341C6;
        Mon, 25 Jul 2022 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658775205;
        bh=NdlvHAPlRtboP1PVhuZybJuRI8HwULVktfJH3uEL+RQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HrjzKrpC6swMvYZZTsSIb7DGKVxnhLhK5VQ3z/F/3/QYGLe2MJvxOJVDXooPWEQrs
         OnyRXoSbWzG6UrmF3DXsnt2wp+iJRr8BOQMqraVo+vtR/0bt2DXYhkPmhb/RgIPzfg
         ott/Tap8TsyZ+vwcMG+8vLw1hONObABY1Nr5qvsfjyFVfifwg23xPu/Bjg7Wlqw1Mh
         RSl5bUIq443QkZ4Qx8O/KYXasXXrVZj3pA8/EQeMmAyg8PHYg539jYd6UPSOJ5H5Mt
         yKv2rkYsV49mKTImrKgTWhH1RDjTt79m2LEN3n7HmLHxqhsrgP3i09bR/10YEv23qE
         cLpoyCtgnmSYQ==
Date:   Mon, 25 Jul 2022 11:53:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] netlink: add 'bitmap' attribute type and
 API
Message-ID: <20220725115324.7a1ad2d6@kernel.org>
In-Reply-To: <20220725130255.3943438-1-alexandr.lobakin@intel.com>
References: <20220721155950.747251-1-alexandr.lobakin@intel.com>
        <20220721111318.1b180762@kernel.org>
        <20220722145514.767592-1-alexandr.lobakin@intel.com>
        <20220722111951.6a2fd39c@kernel.org>
        <20220725130255.3943438-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 15:02:55 +0200 Alexander Lobakin wrote:
> > Actually once a field crosses the biggest natural int size I was
> > thinking that the user would go to a bitmap.
> > 
> > So at the netlink level the field is bigint (LE, don't care about BE).
> > Kernel side API is:
> > 
> > 	nla_get_b8, nla_get_b16, nla_get_b32, nla_get_b64,
> > 	nla_get_bitmap
> > 	nla_put_b8, nla_put_b16 etc.
> > 
> > 	u16 my_flags_are_so_toight;
> > 
> > 	my_flags_are_so_toight = nla_get_b16(attr[BLAA_BLA_BLA_FLAGS]);
> > 
> > The point is - the representation can be more compact than u64 and will
> > therefore encourage anyone who doesn't have a strong reason to use
> > fixed size fields to switch to the bigint.  
> 
> Ahh looks like I got it! So you mean that at Netlink level we should
> exchange with bigint/u64arrs, but there should be an option to
> get/set only 16/32/64 bits from them to simplify (or keep simple)
> users?

Not exactly. I'd prefer if the netlink level was in u32 increments.
u64 requires padding (so the nla_put..() calls will have more args).
Netlink requires platform alignment and rounds up to 4B, so u32 is much
more convenient than u64. Similarly - it doesn't make sense to represent
sizes smaller than 4B because of the rounding up, so nla_put_b8() can
be a define to nla_put_b32(). Ethool's choice of u32 is not without
merit.

> Like, if we have `u16 uuid`, to not do
> 
> 	unsigned long uuid_bitmap;
> 
> 	nla_get_bitmap(attr[FLAGS], &uuid_bitmap, BITS_PER_TYPE(u16));
> 	uuid = (u16)uuid_bitmap;
> 
> but instead
> 
> 	uuid = nla_get_b16(attr[FLAGS]);
> 
> ?

Yes.

> > about being flexible when it comes to size, I guess, more than
> > bitmap in particular.  
> 
> Probably, but you also said above that for anything bigger than
> longs you'd go for bitmaps, didn't you? So I guess that series
> goes in the right direction, just needs a couple more inlines
> to be able to get/put u{32, 64; 8, 16 -- not sure about these two
> after reading your follow-up mail} as easy as nla_{get,put}<size>()
> and probably dropping Endianness stuff? Hope I got it right ._.

Modulo the fact that I do still want to pack to u32. Especially a
single u32 - perhaps once we cross 8B we can switch to requiring 8B
increments.

The nla_len is 16bit, which means that attrs nested inside other attrs
are quite tight for space (see the sad story of VF attrs in
RTM_GETLINK). If we don't represent u8/u16/u32 in a netlink-level
efficient manner we're back to people arguing for raw u32s rather than
using the new type.
