Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703DA59100B
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiHLLaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiHLLaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:30:18 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0337617D
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 04:30:15 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M41bl5RsBz1M8Lv;
        Fri, 12 Aug 2022 19:26:59 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 12 Aug
 2022 19:30:13 +0800
Subject: Re: [RFCv7 PATCH net-next 36/36] net: redefine the prototype of
 netdev_features_t
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20220810030624.34711-1-shenjian15@huawei.com>
 <20220810030624.34711-37-shenjian15@huawei.com>
 <20220810113547.1308711-1-alexandr.lobakin@intel.com>
 <3df89822-7dec-c01e-0df9-15b8e6f7d4e5@huawei.com>
 <20220811130757.9904-1-alexandr.lobakin@intel.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <9f3cf440-aa0d-a112-8d2d-661a93489a71@huawei.com>
Date:   Fri, 12 Aug 2022 19:30:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220811130757.9904-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/8/11 21:07, Alexander Lobakin 写道:
> From: "shenjian (K)" <shenjian15@huawei.com>
> Date: Wed, 10 Aug 2022 21:34:43 +0800
>
> BTW, you replied in HTML instead of plain text and korg mail servers
> rejected it. So non-Ccs can't see it. Just be aware that LKML
> accepts plain text only :)
>
>> 在 2022/8/10 19:35, Alexander Lobakin 写道:
>> > From: Jian Shen <shenjian15@huawei.com>
>> > Date: Wed, 10 Aug 2022 11:06:24 +0800
>> >
>> >> For the prototype of netdev_features_t is u64, and the number
>> >> of netdevice feature bits is 64 now. So there is no space to
>> >> introduce new feature bit. Change the prototype of netdev_features_t
>> >> from u64 to structure below:
>> >>     typedef struct {
>> >>         DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
>> >>     } netdev_features_t;
>> >>
>> >> Rewrite the netdev_features helpers to adapt with new prototype.
>> >>
>> >> To avoid mistake using NETIF_F_XXX as NETIF_F_XXX_BIT as
>> >> input macroes for above helpers, remove all the macroes
>> >> of NETIF_F_XXX for single feature bit. Serveal macroes remained
>> >> temporarily, by some precompile dependency.
>> >>
>> >> With the prototype is no longer u64, the implementation of print
>> >> interface for netdev features(%pNF) is changed to bitmap. So
>> >> does the implementation of net/ethtool/.
>> >>
>> >> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> >> ---
>> >>   drivers/net/ethernet/amazon/ena/ena_netdev.c  |  12 +-
>> >>   .../net/ethernet/intel/i40e/i40e_debugfs.c    |  12 +-
>> >>   .../ethernet/netronome/nfp/nfp_net_common.c   |   4 +-
>> >>   .../net/ethernet/pensando/ionic/ionic_lif.c   |   4 +-
>> >>   include/linux/netdev_features.h               | 101 ++----------
>> >>   include/linux/netdev_features_helper.h        | 149 
>> +++++++++++-------
>> >>   include/linux/netdevice.h                     |   7 +-
>> >>   include/linux/skbuff.h                        |   4 +-
>> >>   include/net/ip_tunnels.h                      |   2 +-
>> >>   lib/vsprintf.c                                |  11 +-
>> >>   net/ethtool/features.c                        |  96 ++++-------
>> >>   net/ethtool/ioctl.c                           |  46 ++++--
>> >>   net/mac80211/main.c                           |   3 +-
>> >>   13 files changed, 201 insertions(+), 250 deletions(-)
>> > [...]
>> >
>> >> -static inline int find_next_netdev_feature(u64 feature, unsigned 
>> long start)
>> >> -{
>> >> -    /* like BITMAP_LAST_WORD_MASK() for u64
>> >> -     * this sets the most significant 64 - start to 0.
>> >> -     */
>> >> -    feature &= ~0ULL >> (-start & ((sizeof(feature) * 8) - 1));
>> >> -
>> >> -    return fls64(feature) - 1;
>> >> -}
>> >> +#define NETIF_F_HW_VLAN_CTAG_TX
>> >> +#define NETIF_F_IPV6_CSUM
>> >> +#define NETIF_F_TSO
>> >> +#define NETIF_F_GSO
>> > Uhm, what are those empty definitions for? They look confusing.
>> I kept them temporary for some drivers use them like below:
>> for example in drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
>> #ifdef NETIF_F_HW_VLAN_CTAG_TX
>> #include <linux/if_vlan.h>
>> #endif
>>
>> So far I haven't got a good way to replace it.
>
> I believe such constructs sneaked in from some development/draft
> versions of the code, as those definitions are always here, so
> this is just redundant/pointless.
> Just remove those ifdefs and always include the file.
> The empty definitions you left in netdev_features.h are confusing,
> I'd not keep them.
>
OK, I will add a new patch to remove them.

>>
>> >>   >>   /* This goes for the MSB to the LSB through the set feature 
>> bits,
>> >>    * mask_addr should be a u64 and bit an int
>> >>    */
>
> [...]
>
>> >> +#define GSO_ENCAP_FEATURES (((u64)1 << NETIF_F_GSO_GRE_BIT) 
>> |        \
>> >> +                 ((u64)1 << NETIF_F_GSO_GRE_CSUM_BIT) |        \
>> >> +                 ((u64)1 << NETIF_F_GSO_IPXIP4_BIT) |        \
>> >> +                 ((u64)1 << NETIF_F_GSO_IPXIP6_BIT) |        \
>> >> +                 (((u64)1 << NETIF_F_GSO_UDP_TUNNEL_BIT) |    \
>> >> +                  ((u64)1 << NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT)))
>> > 1) 1ULL;
>> ok，will fix it
>>
>> > 2) what if we get a new GSO encap type which's bit will be higher
>> >     than 64?
>> So far I prefer to use this.  It's used to assgned to 
>> skb_shinfo(skb)->gso_type, which prototype
>> is 'unsigned int'.  Once new gso encap type introduced, we should 
>> extend the gso_type first.
>
> But ::gso_type accepts flags like %SKB_GSO_DODGY and so on, not
> netdev_features, doesn't it?
>
>>
>>
>> >> +
>> >>   #endif    /* _LINUX_NETDEV_FEATURES_H */
>
> [...]
>
>> >>   static inline netdev_features_t
>> >>   netdev_features_and(const netdev_features_t a, const 
>> netdev_features_t b)
>> >>   {
>> >> -    return a & b;
>> >> +    netdev_features_t dst;
>> >> +
>> >> +    bitmap_and(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
>> >> +    return dst;
>> > Yeah, so as I wrote previously, not a good idea to return a whole
>> > bitmap/structure.
>> >
>> > netdev_features_and(*dst, const *a, const *b)
>> > {
>> >     return bitmap_and(); // bitmap_and() actually returns useful value
>> > }
>> >
>> > I mean, 16 bytes (currently 8, but some new features will come
>> > pretty shortly, I'm sure) are probably okayish, but... let's see
>> > what other folks think, but even Linus wrote about this recently
>> > BTW.
>> Yes, Jakub also mentioned this.
>>
>> But there are many existed features interfaces(e.g. ndo_fix_features,
>> ndo_features_check), use netdev_features_t as return value. Then we
>> have to change their prototype.
>
> We have to do 12k lines of changes already :D
> You know, 16 bytes is probably fine to return directly and it will
> be enough for up to 128 features (+64 more comparing to the
> mainline). OTOH, using pointers removes that "what if/when", so
> it's more flexible in that term. So that's why I asked for other
> folks' opinions -- 2 PoVs doesn't seem enough here.
>

>>
>> second problem is for the helpers' definition. For example:
>> When we introduce helper like netdev_features_zero(netdev_features_t 
>> *features)
>> without change prototype of netdev_features_t.
>> once covert netdev_features_t from u64 to unsigned long *, then it 
>> becomes
>> netdev_features_zero(unsigned long **features), result in much 
>> redundant work
>> to adjust it to netdev_features_zero(unsigned long *features).
>
>>
>>
>> >>   }
>
> [...]
>
>> >>   static noinline_for_stack
>> >> -char *netdev_bits(char *buf, char *end, const void *addr,
>> >> +char *netdev_bits(char *buf, char *end, void *addr,
>> >>             struct printf_spec spec,  const char *fmt)
>> >>   {
>> >> -    unsigned long long num;
>> >> -    int size;
>> >> +    netdev_features_t *features;
>> > const? We're printing.
>> It will cause compile warning for bitmap_string use features->bits
>> as input param without "const" definition in its prototype.
>
> Oof, that's weird. I checked the function you mentioned and don't
> see any reason why it would require non-RO access to the bitmap it
> prints.
> Could you maybe please change its proto to take const bitmap, so
> that it won't complain on your code? As a separate patch going right
> before this one in your series.
>
OK,  will do it.

>> >>   >>       if (check_pointer(&buf, end, addr, spec))
>> >>           return buf;
>> >>   >>       switch (fmt[1]) {
>> >>       case 'F':
>> >> -        num = *(const netdev_features_t *)addr;
>> >> -        size = sizeof(netdev_features_t);
>> >> +        features = (netdev_features_t *)addr;
>> > Casts are not needed when assigning from `void *`.
>> ok, will fix it
>> >> +        spec.field_width = NETDEV_FEATURE_COUNT;
>> >>           break;
>> >>       default:
>> >>           return error_string(buf, end, "(%pN?)", spec);
>> >>       }
>> >>   >> -    return special_hex_number(buf, end, num, size);
>> >> +    return bitmap_string(buf, end, features->bits, spec, fmt);
>> >>   }
>
> [...]
>
>> >> -- >> 2.33.0
>> > That's my last review email for now. Insane amount of work, I'm glad
>> > someone did it finally. Thanks a lot!
>> >
>> > Olek
>> > .
>> Hi   Olek,
>> Grateful for your review.  You made a lot of valuable suggestions. I 
>> will
>> check and continue refine the patchset.
>>
>> Thanks again!
>>
>> Jian
>
> Thanks!
> Olek
> .
>
Thanks,
Jian

