Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C3762815E
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbiKNNd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbiKNNdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:33:55 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C26AFAF4;
        Mon, 14 Nov 2022 05:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=60PRZUikRdqopFokv/DkHEVCSO7RX3hL4yVs/FGe6Rc=; b=HUVTOszrTxynyiRnYJm5pvd8ow
        TJPoXYl2hqn3xaz+DaOzXARw6hlgG4We+kTUhEOq3Wowgn0jDQDw10uMdhv5v1uauhJjjEQ9VEvww
        zyX5OBOA0wBPickHMe325P/C2S6y7JnTfMz/1ZgiJST7FIW0ckqsTMFVwG0O9NFO72Sk=;
Received: from p54ae9c3f.dip0.t-ipconnect.de ([84.174.156.63] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1ouZas-0022vj-0a; Mon, 14 Nov 2022 14:33:46 +0100
Message-ID: <9c9efca9-8c10-8ac9-6fe8-a18708571ece@nbd.name>
Date:   Mon, 14 Nov 2022 14:33:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Content-Language: en-US
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
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
 <8faa9c5d-960c-849b-e6af-a847bb1fd12f@nbd.name>
 <CAA93jw4Z-fz_6gTxrjwsifcMy=oAcF0mPT6s=_aGdDU3UgCgcg@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next v3 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
In-Reply-To: <CAA93jw4Z-fz_6gTxrjwsifcMy=oAcF0mPT6s=_aGdDU3UgCgcg@mail.gmail.com>
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

On 14.11.22 14:18, Dave Taht wrote:
> On Mon, Nov 14, 2022 at 4:21 AM Felix Fietkau <nbd@nbd.name> wrote:
>>
>> On 14.11.22 12:55, Vladimir Oltean wrote:
>> > On Sat, Nov 12, 2022 at 12:13:15PM +0100, Felix Fietkau wrote:
>> >> On 12.11.22 05:40, Jakub Kicinski wrote:
>> >> I don't really see a valid use case in running generic XDP, TC and NFT on a
>> >> DSA master dealing with packets before the tag receive function has been
>> >> run. And after the tag has been processed, the metadata DST is cleared from
>> >> the skb.
>> >
>> > Oh, there are potentially many use cases, the problem is that maybe
>> > there aren't as many actual implementations as ideas? At least XDP is,
>> > I think, expected to be able to deal with DSA tags if run on a DSA
>> > master (not sure how that applies when RX DSA tag is offloaded, but
>> > whatever). Marek Behun had a prototype with Marvell tags, not sure how
>> > far that went in the end:
>> > https://www.mail-archive.com/netdev@vger.kernel.org/msg381018.html
>> > In general, forwarding a packet to another switch port belonging to the
>> > same master via XDP_TX should be relatively efficient.
>> In that case it likely makes sense to disable DSA tag offloading
>> whenever driver XDP is being used.
>> Generic XDP probably doesn't matter much. Last time I tried to use it
>> and ran into performance issues, I was told that it's only usable for
>> testing anyway and there was no interest in fixing the cases that I ran
>> into.
> 
> XDP continues to evolve rapidly, as do its use cases. ( ex:
> ttps://github.com/thebracket/cpumap-pping#readme )
> 
> What cases did you run into?
My issue was the fact that XDP in general (including generic XDP) 
assumes that packets have 256 bytes of headroom, which is usually only 
true for drivers that already have proper driver or hardware XDP support.
That makes generic XDP pretty much useless for normal use, since on XDP 
capable drivers you should use driver/hardware XDP anyway, and on 
everything else you get the significant performance penalty of an extra 
pskb_expand_head call.
I ended up abandoning XDP for my stuff and used tc instead.

- Felix
