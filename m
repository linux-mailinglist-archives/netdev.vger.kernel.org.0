Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C91D4D8EF7
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 22:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244520AbiCNVnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 17:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbiCNVnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 17:43:17 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0161DA54;
        Mon, 14 Mar 2022 14:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=5fYJDkb70nOkHbd2/M46rkppX6DCn4ZobzkUMoM9LVo=; b=FdI76ZQ7Kt7g2yLPyuZKT6vKGD
        Etuf79OkUCGcAdgGg7lvX6URaStuopjbS5spn4BeqhVvVJIQf9Mt4o5kdPG+P3zGPeJ4grLvus4Te
        ilrumcKphbkpc4dpmxPOCEbO1w0CNXP+Czm2SilPLC7+3++PWsSw4YtNapgfCcRSAa5g=;
Received: from p200300daa7204f00f1d305288d0030be.dip0.t-ipconnect.de ([2003:da:a720:4f00:f1d3:528:8d00:30be] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nTsS4-0000JU-Dt; Mon, 14 Mar 2022 22:42:04 +0100
Message-ID: <4ff44a95-2818-32d9-c907-20e84f24a3e6@nbd.name>
Date:   Mon, 14 Mar 2022 22:42:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
To:     "Jesper D. Brouer" <netdev@brouer.com>, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
Cc:     brouer@redhat.com, Toke Hoiland Jorgensen <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220314102210.92329-1-nbd@nbd.name>
 <86137924-b3cb-3d96-51b1-19923252f092@brouer.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] net: xdp: allow user space to request a smaller packet
 headroom requirement
In-Reply-To: <86137924-b3cb-3d96-51b1-19923252f092@brouer.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14.03.22 21:39, Jesper D. Brouer wrote:
> (Cc. BPF list and other XDP maintainers)
> 
> On 14/03/2022 11.22, Felix Fietkau wrote:
>> Most ethernet drivers allocate a packet headroom of NET_SKB_PAD. Since it is
>> rounded up to L1 cache size, it ends up being at least 64 bytes on the most
>> common platforms.
>> On most ethernet drivers, having a guaranteed headroom of 256 bytes for XDP
>> adds an extra forced pskb_expand_head call when enabling SKB XDP, which can
>> be quite expensive.
>> Many XDP programs need only very little headroom, so it can be beneficial
>> to have a way to opt-out of the 256 bytes headroom requirement.
> 
> IMHO 64 bytes is too small.
> We are using this area for struct xdp_frame and also for metadata
> (XDP-hints).  This will limit us from growing this structures for
> the sake of generic-XDP.
> 
> I'm fine with reducting this to 192 bytes, as most Intel drivers
> have this headroom, and have defacto established that this is
> a valid XDP headroom, even for native-XDP.
> 
> We could go a small as two cachelines 128 bytes, as if xdp_frame
> and metadata grows above a cache-line (64 bytes) each, then we have
> done something wrong (performance wise).
Here's some background on why I chose 64 bytes: I'm currently 
implementing a userspace + xdp program to act as generic fastpath to 
speed network bridging.
For that I need to support a very diverse set of network drivers 
(including a lot of WLAN drivers).
My XDP program only needs up to 4 bytes extra headroom (for a VLAN header).
I made this headroom reduction opt-in, so that by default generic-XDP 
programs can still rely on 256 bytes headroom.

If we make the small version any bigger than 64 bytes, it limits my 
options to:
1) bump NET_SKB_PAD accordingly at the risk of creating issues with 
buffer management for some affected drivers (IMHO not likely to be 
accepted upstream)
2) create patches for each and every driver that could possibly get used 
on OpenWrt to make my approach viable (there's so many of them, so I 
think that's not really feasible either)
3) stick with non-upstream hacks for dealing with this in OpenWrt
I don't really like any of those options, but I can't think of any other 
solution right now.

If I take the pskb_expand_head hit from the headroom mismatch, the 
result is that my bridge accelerator code actually decreases performance 
instead of making anything better.

- Felix
