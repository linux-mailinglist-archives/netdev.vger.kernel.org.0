Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976885A3D52
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 13:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiH1LYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 07:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiH1LY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 07:24:27 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525F43136A;
        Sun, 28 Aug 2022 04:24:26 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 3FF611884659;
        Sun, 28 Aug 2022 11:24:23 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 1F69425032B8;
        Sun, 28 Aug 2022 11:24:23 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 1590D9EC0009; Sun, 28 Aug 2022 11:24:23 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 28 Aug 2022 13:24:22 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 1/6] net: bridge: add locked entry fdb flag to
 extend locked port feature
In-Reply-To: <YwoZdzVCkMV8vGtl@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-2-netdev@kapio-technology.com>
 <e9eb5b72-073a-f182-13b7-37fc53611d5f@blackwall.org>
 <YwoZdzVCkMV8vGtl@shredder>
User-Agent: Gigahost Webmail
Message-ID: <48ac861433e3c608c8630300efe4e828@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-27 15:17, Ido Schimmel wrote:
> On Sat, Aug 27, 2022 at 02:30:25PM +0300, Nikolay Aleksandrov wrote:
>> On 26/08/2022 14:45, Hans Schultz wrote:
>> Please add the blackhole flag in a separate patch.
> 
> +1
> 
> [...]
> 
>> > @@ -185,6 +196,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>> >  		if (test_bit(BR_FDB_LOCAL, &dst->flags))
>> >  			return br_pass_frame_up(skb);
>> >
>> > +		if (test_bit(BR_FDB_BLACKHOLE, &dst->flags))
>> > +			goto drop;
>> > +
>> Not happy about adding a new test in arguably the most used fast-path, 
>> but I don't see
>> a better way to do blackhole right now. Could you please make it an 
>> unlikely() ?
>> 
>> I guess the blackhole flag will be allowed for user-space to set at 
>> some point, why
>> not do it from the start?
>> 
>> Actually adding a BR_FDB_LOCAL and BR_FDB_BLACKHOLE would be a 
>> conflict above -
>> the packet will be received. So you should move the blackhole check 
>> above the
>> BR_FDB_LOCAL one if user-space is allowed to set it to any entry.
> 
> Agree about unlikely() and making it writeable from user space from the
> start. This flag is different from the "locked" flag that should only 
> be
> ever set by the kernel.
> 
> Regarding BR_FDB_LOCAL, I think BR_FDB_BLACKHOLE should only be allowed
> with BR_FDB_LOCAL as these entries are similar in the following ways:
> 
> 1. It doesn't make sense to associate a blackhole entry with a specific
> port. The packet will never be forwarded to this port, but dropped by
> the bridge. This means user space will add them on the bridge itself:
> 
> # bridge fdb add 00:11:22:33:44:55 dev br0 self local blackhole
> 
> 2. If you agree that these entries should not be associated with a
> specific port, then it also does not make sense to subject them to
> ageing and roaming, just like existing local/permanent entries.
> 
> The above allows us to push the new check under the BR_FDB_LOCAL check:
> 
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 68b3e850bcb9..4357445529a5 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -182,8 +182,11 @@ int br_handle_frame_finish(struct net *net,
> struct sock *sk, struct sk_buff *skb
>         if (dst) {
>                 unsigned long now = jiffies;
> 
> -               if (test_bit(BR_FDB_LOCAL, &dst->flags))
> +               if (test_bit(BR_FDB_LOCAL, &dst->flags)) {
> +                       if (unlikely(test_bit(BR_FDB_BLACKHOLE, 
> &dst->flags)))
> +                               goto drop;
>                         return br_pass_frame_up(skb);
> +               }
> 
>                 if (now != dst->used)
>                         dst->used = now;

It shall be so as suggested. :-)
