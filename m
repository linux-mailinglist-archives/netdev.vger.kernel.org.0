Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237B3627D54
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 13:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiKNMHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 07:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237088AbiKNMHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 07:07:01 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B13E59;
        Mon, 14 Nov 2022 04:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zMu0HTKg3FuUP4Nz5uxf9TpO0N2V/XYeubVj5LZJiTY=; b=JRKiJ4nDH44Lp8lZYuuQJ0FbUx
        RAciPYCaHXxkO43oTLTNwpYvq+d7+2LFSo9Z4Orj5x0H1xIOcnkK6bmI+QoljvlP/p4GeLH4fZKfq
        rMf0b5zps6wzl+BdBxQ8nT9pNF5GuZrR8yZREkvcrGhtwFPpKpkdVssXKRPqpQwF+4So=;
Received: from p54ae9c3f.dip0.t-ipconnect.de ([84.174.156.63] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1ouYEe-0021Go-GC; Mon, 14 Nov 2022 13:06:44 +0100
Message-ID: <8faa9c5d-960c-849b-e6af-a847bb1fd12f@nbd.name>
Date:   Mon, 14 Nov 2022 13:06:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20221110212212.96825-1-nbd@nbd.name>
 <20221110212212.96825-2-nbd@nbd.name> <20221111233714.pmbc5qvq3g3hemhr@skbuf>
 <20221111204059.17b8ce95@kernel.org>
 <bcb33ba7-b2a3-1fe7-64b2-1e15203e2cce@nbd.name>
 <20221114115559.wl7efrgxphijqz4o@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next v3 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
In-Reply-To: <20221114115559.wl7efrgxphijqz4o@skbuf>
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

On 14.11.22 12:55, Vladimir Oltean wrote:
> On Sat, Nov 12, 2022 at 12:13:15PM +0100, Felix Fietkau wrote:
>> On 12.11.22 05:40, Jakub Kicinski wrote:
>> I don't really see a valid use case in running generic XDP, TC and NFT on a
>> DSA master dealing with packets before the tag receive function has been
>> run. And after the tag has been processed, the metadata DST is cleared from
>> the skb.
> 
> Oh, there are potentially many use cases, the problem is that maybe
> there aren't as many actual implementations as ideas? At least XDP is,
> I think, expected to be able to deal with DSA tags if run on a DSA
> master (not sure how that applies when RX DSA tag is offloaded, but
> whatever). Marek Behun had a prototype with Marvell tags, not sure how
> far that went in the end:
> https://www.mail-archive.com/netdev@vger.kernel.org/msg381018.html
> In general, forwarding a packet to another switch port belonging to the
> same master via XDP_TX should be relatively efficient.
In that case it likely makes sense to disable DSA tag offloading 
whenever driver XDP is being used.
Generic XDP probably doesn't matter much. Last time I tried to use it 
and ran into performance issues, I was told that it's only usable for 
testing anyway and there was no interest in fixing the cases that I ran 
into.

>> How about this: I send a v4 which uses skb_dst_drop instead of skb_dst_set,
>> so that other drivers can use refcounting if it makes sense for them. For
>> mtk_eth_soc, I prefer to leave out refcounting for performance reasons.
>> Is that acceptable to you guys?
> 
> I don't think you can mix refcounting at consumer side with no-refcounting
> at producer side, no?
skb_dst_drop checks if refcounting was used for the skb dst pointer.

> I suppose that we could leave refcounting out for now, and bug you if
> someone comes with a real need later and complains. Right now it's a bit
> hard for me to imagine all the possibilities. How does that sound?
Sounds good. I think I'll send v4 anyway to deal with the XDP case and 
to switch to skb_dst_drop.

- Felix
