Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBC758115E
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238754AbiGZKn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiGZKn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:43:27 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89DE1F2FC;
        Tue, 26 Jul 2022 03:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658832206; x=1690368206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lQiAilbEUppJcpJNbRqv8FIHJ4GJnsTYB+DqfHRxkjk=;
  b=nC46ls+tJlDDjC1WppY/gENhN1tWgHYgqDxfsyRCxphiIakq87GUPtUB
   kkVgMOZIaEww6DGIfJmIAfweH+ZfZVrVJPAjvtFK0Cg2iVy6Ci9Ehe3gY
   lb8FxwygrC7iJZB8qvayrZeEPZbCsTZdhxjaq9XxiVH2GV4av24comNwP
   ajlv6uhPLt8mooDG6B2/oC6nxWojkybpUf58Fy1yAgbohHDTcY7hPCERB
   RiQwBpkAicFkm5jAKFU964gcQ5AdqG0gsGKb1C6CiI7+lS/DdMITNBsZK
   +b8x782nUyjbQTr7l6xO8Urvqc3J3djIxQjh8lLVjixvhms40CJZNa4aJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="285471729"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="285471729"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 03:43:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="726495114"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 26 Jul 2022 03:43:23 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26QAhM9K023892;
        Tue, 26 Jul 2022 11:43:22 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] netlink: add 'bitmap' attribute type and API
Date:   Tue, 26 Jul 2022 12:41:45 +0200
Message-Id: <20220726104145.1857628-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725115324.7a1ad2d6@kernel.org>
References: <20220721155950.747251-1-alexandr.lobakin@intel.com> <20220721111318.1b180762@kernel.org> <20220722145514.767592-1-alexandr.lobakin@intel.com> <20220722111951.6a2fd39c@kernel.org> <20220725130255.3943438-1-alexandr.lobakin@intel.com> <20220725115324.7a1ad2d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 25 Jul 2022 11:53:24 -0700

> On Mon, 25 Jul 2022 15:02:55 +0200 Alexander Lobakin wrote:
> > > Actually once a field crosses the biggest natural int size I was
> > > thinking that the user would go to a bitmap.
> > > 
> > > So at the netlink level the field is bigint (LE, don't care about BE).
> > > Kernel side API is:
> > > 
> > > 	nla_get_b8, nla_get_b16, nla_get_b32, nla_get_b64,
> > > 	nla_get_bitmap
> > > 	nla_put_b8, nla_put_b16 etc.
> > > 
> > > 	u16 my_flags_are_so_toight;
> > > 
> > > 	my_flags_are_so_toight = nla_get_b16(attr[BLAA_BLA_BLA_FLAGS]);
> > > 
> > > The point is - the representation can be more compact than u64 and will
> > > therefore encourage anyone who doesn't have a strong reason to use
> > > fixed size fields to switch to the bigint.  
> > 
> > Ahh looks like I got it! So you mean that at Netlink level we should
> > exchange with bigint/u64arrs, but there should be an option to
> > get/set only 16/32/64 bits from them to simplify (or keep simple)
> > users?
> 
> Not exactly. I'd prefer if the netlink level was in u32 increments.
> u64 requires padding (so the nla_put..() calls will have more args).
> Netlink requires platform alignment and rounds up to 4B, so u32 is much
> more convenient than u64. Similarly - it doesn't make sense to represent
> sizes smaller than 4B because of the rounding up, so nla_put_b8() can
> be a define to nla_put_b32(). Ethool's choice of u32 is not without
> merit.
> 
> > Like, if we have `u16 uuid`, to not do
> > 
> > 	unsigned long uuid_bitmap;
> > 
> > 	nla_get_bitmap(attr[FLAGS], &uuid_bitmap, BITS_PER_TYPE(u16));
> > 	uuid = (u16)uuid_bitmap;
> > 
> > but instead
> > 
> > 	uuid = nla_get_b16(attr[FLAGS]);
> > 
> > ?
> 
> Yes.
> 
> > > about being flexible when it comes to size, I guess, more than
> > > bitmap in particular.  
> > 
> > Probably, but you also said above that for anything bigger than
> > longs you'd go for bitmaps, didn't you? So I guess that series
> > goes in the right direction, just needs a couple more inlines
> > to be able to get/put u{32, 64; 8, 16 -- not sure about these two
> > after reading your follow-up mail} as easy as nla_{get,put}<size>()
> > and probably dropping Endianness stuff? Hope I got it right ._.
> 
> Modulo the fact that I do still want to pack to u32. Especially a
> single u32 - perhaps once we cross 8B we can switch to requiring 8B
> increments.
> 
> The nla_len is 16bit, which means that attrs nested inside other attrs
> are quite tight for space (see the sad story of VF attrs in
> RTM_GETLINK). If we don't represent u8/u16/u32 in a netlink-level
> efficient manner we're back to people arguing for raw u32s rather than
> using the new type.

Ah, got it. I think you're right. The only thing that bothers me
a bit is that we'll be converting arrays of u32s to unsigned longs
each time, unlike u64s <--> longs which are 1:1 for 64 bits and LEs.
But I guess it's better anyway than waste Netlink attrs for
paddings?

So I'd like to summarize for a v2:

* represent as u32s, not u64s;
* present it as "bigints", not bitmaps. It can carry bitmaps as
  well, but also ->
* add getters/setters for u8, 16, 32, 64s. Bitmaps are already here.
  Probably u32 arrays as well? Just copy them directly. And maybe
  u64 arrays, too (convert Netlink u32s to target u64s)?
* should I drop Endianness stuff? With it still in place, it would
  be easier to use this new API to exchange with e.g. __be64.
* hope I didn't miss anything?

Thanks a lot, some great ideas here from your side :)

Olek
