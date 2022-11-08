Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624B7620BFF
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiKHJU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbiKHJUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:20:54 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE432655A;
        Tue,  8 Nov 2022 01:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qlS6GEUkXGwLlwdu2gwmGvxGx2k9efRT6xQlXFUW+zQ=; b=hUfcfaMxa0oNwAAY8cZ79bGZvg
        LgavErq/mVjr96n4XP7+CGKKQ1itY8GrUA9VER2MT8Q95dmLJ5z5RiOonUNeS4I9gqYtNgMUbDTZp
        0Hh+nXRV4OXD9xrBhokOLQGfLX3i/OK5O3Jp5+RyR2LUd6XZZedkRO4cmaeQWHwGofFk=;
Received: from p200300daa72ee1006d973cebf3767a25.dip0.t-ipconnect.de ([2003:da:a72e:e100:6d97:3ceb:f376:7a25] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1osKmj-000ToR-LN; Tue, 08 Nov 2022 10:20:45 +0100
Message-ID: <0948d841-b0eb-8281-455a-92f44586e0c0@nbd.name>
Date:   Tue, 8 Nov 2022 10:20:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-8-nbd@nbd.name> <20221107215745.ascdvnxqrbw4meuv@skbuf>
 <3b275dda-39ac-282d-8a46-d3a95fdfc766@nbd.name>
 <20221108090039.imamht5iyh2bbbnl@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20221108090039.imamht5iyh2bbbnl@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.11.22 10:00, Vladimir Oltean wrote:
> On Tue, Nov 08, 2022 at 07:08:46AM +0100, Felix Fietkau wrote:
>> On 07.11.22 22:57, Vladimir Oltean wrote:
>> > Aren't you calling __vlan_hwaccel_put_tag() with the wrong thing (i.e.
>> > htons(RX_DMA_VPID()) as opposed to VPID translated to something
>> > digestible by the rest of the network stack.. ETH_P_8021Q, ETH_P_8021AD
>> > etc)?
>> 
>> The MTK ethernet hardware treats the DSA special tag as a VLAN tag and
>> reports it as such. The ethernet driver passes this on as a hwaccel tag, and
>> the MTK DSA tag parser consumes it. The only thing that's sitting in the
>> middle looking at the tag is the VLAN device lookup with that warning.
>> 
>> Whenever DSA is not being used, the MTK ethernet device can also process
>> regular VLAN tags. For those tags, htons(RX_DMA_VPID()) will contain the
>> correct VPID.
> 
> So I don't object to the overall theme of having the DSA master offload
> the parsing and removal of the DSA tag, but you knock down a bit too
> many fences if you carry the DSA tag in skb->vlan_present (not only VLAN
> upper device lookup, but also the flow dissector).
> 
> What other information will be present in the offloaded DSA headers
> except source port information? Maxime Chevallier is also working on a
> similar problem for qca8k, except in that case, the RX DSA offload seems
> to not be optional for him.
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20221104174151.439008-4-maxime.chevallier@bootlin.com/
> 
> Would a solution based on METADATA_HW_PORT_MUX and dst_metadata that
> point to refcounted, preallocated structs work for Mediatek SoCs with
> DSA, or would more information be necessary?
> 
> Meaning: mtk_eth_soc attaches the dst_metadata to the skb, tag_mtk.c
> retrieves and removes it.
I need to look into how METADATA_HW_PORT_MUX works, but I think it could 
work.

- Felix
